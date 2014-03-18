From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [v3.13][v3.14][Regression] kthread: makekthread_create()killable
Date: Tue, 18 Mar 2014 21:03:16 +0900
Message-ID: <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp>
References: <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp>
	<201403170013.GJF86930.FtVOOQOHLFFMSJ@I-love.SAKURA.ne.jp>
	<20140316162512.GA9467@redhat.com>
	<201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp>
	<20140317142246.GA27453@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:62628 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaCRMDW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 08:03:22 -0400
In-Reply-To: <20140317142246.GA27453@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oleg@redhat.com, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com
Cc: rientjes@google.com, akpm@linux-foundation.org, joseph.salisbury@canonical.com, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org

Oleg Nesterov wrote:
> If we need the urgent hack to fix the regression, then I suggest to change
> scsi_host_alloc() temporary until mptsas (or whatever) is fixed.

Device initialization taking longer than 30 seconds is possible and is not a
hang up. It is systemd which needs to be fixed.

> --- x/drivers/scsi/hosts.c
> +++ x/drivers/scsi/hosts.c
> @@ -447,8 +447,18 @@ struct Scsi_Host *scsi_host_alloc(struct
>  	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
>  	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
>  
> -	shost->ehandler = kthread_run(scsi_error_handler, shost,
> -			"scsi_eh_%d", shost->host_no);
> +	/*
> +	 * HUGE COMMENT. and kthread_create() needs s/ENOMEM/EINTR/.
> +	 */
> +	for (;;) {
> +		shost->ehandler = kthread_run(scsi_error_handler, shost,
> +						"scsi_eh_%d", shost->host_no);
> +		if (!IS_ERR(shost->ehandler) || PTR_ERR(shost->ehandler) != -EINTR)
> +			break;
> +		clear_thread_flag(TIF_SIGPENDING);
> +	}
> +	recalc_sigpending();
> +
>  	if (IS_ERR(shost->ehandler)) {
>  		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n",
>  			shost->host_no, PTR_ERR(shost->ehandler));
> 
> 

I think we need a bit different version, in order to take TIF_MEMDIE flag into
account at the caller of kthread_create(), for the purpose of commit 786235ee
is "try to die as soon as possible if chosen by the OOM killer".

	for (;;) {
		shost->ehandler = kthread_run(scsi_error_handler, shost,
					      "scsi_eh_%d", shost->host_no);
		if (PTR_ERR(shost->ehandler) != -EINTR ||
		    test_thread_flag(TIF_MEMDIE))
			break;
		clear_thread_flag(TIF_SIGPENDING);
	}
	recalc_sigpending();

But I have two worrying points.

  (1) Changing return code from -ENOMEM to -EINTR may not be sufficient.

      If kmalloc(GFP_KERNEL) in kthread_create_on_node() does something that
      calls recalc_sigpending(), TIF_SIGPENDING will be set on the second call
      to kthread_run(). This will make wait_for_completion_killable() return
      -EINTR immediately because the second call to kthread_run() happens only
      when current thread already received SIGKILL (by other than the OOM
      killer). This may form an infinite busy loop.

      As I think it is difficult to prove that kmalloc(GFP_KERNEL) never sets
      TIF_SIGPENDING flag, we would need to call
      clear_thread_flag(TIF_SIGPENDING) immediately before
      wait_for_completion_killable() and call recalc_sigpending() immediately
      after wait_for_completion_killable(). Is this better than taking care of
      SIGKILL (by other than the OOM killer) on the first call to
      kthread_run() ?

  (2) I don't like scattering around test_thread_flag(TIF_MEMDIE), for there
      might be other drivers who receive SIGKILL by systemd's 30 seconds
      timeout.
