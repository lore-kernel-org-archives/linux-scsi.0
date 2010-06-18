From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 5/5 v2]scsi:hosts.c Fix warning: variable 'rval' set
	but not used
Date: Fri, 18 Jun 2010 14:47:30 -0600
Message-ID: <20100618204730.GL9298@parisc-linux.org>
References: <1276892167-24161-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38752 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0FRUrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2010 16:47:31 -0400
Content-Disposition: inline
In-Reply-To: <1276892167-24161-1-git-send-email-justinmattock@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On Fri, Jun 18, 2010 at 01:16:07PM -0700, Justin P. Mattock wrote:
> @@ -420,7 +419,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->ehandler = kthread_run(scsi_error_handler, shost,
>  			"scsi_eh_%d", shost->host_no);
>  	if (IS_ERR(shost->ehandler)) {
> -		rval = PTR_ERR(shost->ehandler);
> +		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n", 
> +			shost->host_no, PTR_ERR(shost->ehandler));

Surely this should simply be:

		shost_printk(KERN_WARNING, shost, "error handler thread failed"
				"to spawn (%ld)\n", PTR_ERR(shost->ehandler));

>  		goto fail_kfree;
>  	}
>  
> -- 
> 1.7.1.rc1.21.gf3bd6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
