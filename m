From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: please fix FUSION (Was:
 [v3.13][v3.14][Regression]kthread:makekthread_create()killable)
Date: Sat, 22 Mar 2014 13:48:50 -0700
Message-ID: <1395521330.2143.51.camel@dabdike.int.hansenpartnership.com>
References: <20140319182910.GA14511@redhat.com>
	 <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com>
	 <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com>
	 <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
	 <20140322192511.GA14811@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48861 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaCVUsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2014 16:48:52 -0400
In-Reply-To: <20140322192511.GA14811@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joseph.salisbury@canonical.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, thenzl@redhat.com

On Sat, 2014-03-22 at 20:25 +0100, Oleg Nesterov wrote:
> On 03/22, Tetsuo Handa wrote:
> >
> > Oleg Nesterov wrote:
> > > Tetsuo, what do you think?
> >
> > I don't like blocking SIGKILL while doing operations that depend on memory
> > allocation by other processes. If the OOM killer is triggered and it chose
> > the process blocking SIGKILL in mptsas_init() (I know it unlikely happens),
> > it generates the OOM killer deadlock.
> 
> It seems that we do not understand each other.
> 
> I do not like this hack too. And it is even wrong, you can't really block
> SIGKILL. And it is unnecessary in a sense that (I think) it is fine that
> module_init() reacts to SIGKILL and aborts, just the fact it crashes the
> kernel in the error paths is not fine.
> 
> The driver should be fixed anyway. As for timeout, either userspace/systemd
> should be changed to not send SIGKILL after 30 secs, or (better) the driver
> should be changed to not waste 30 secs.
> 
> The hack I sent can only serve as a short term solution, it should be
> reverted once we have something better. And, otoh, this hack only affects
> the problematic driver which should be fixed in any case.
> 
> Do you see my point? I can be wrong, but I think that you constantly
> misunderstand the intent.
> 
> > My preference is to fix kthread_create() to handle SIGKILL gracefully.
> 
> And now I do not understand you too. I do not understand why should we
> "fix" kthread_create().
> 
> > Many kernel operations (e.g. mutex_lock() wait_event() wait_for_completion())
> > ignore SIGKILL and the current users depend on SIGKILL being ignored. Thus,
> > commit 786235ee sounds like a kernel API breakage.
> 
> Personally I do not really think so, but OK. In this case lets revert
> 786235ee.
> 
> > Commit 786235ee "kthread: make kthread_create() killable" changed to
> > leave kthread_create() as soon as receiving SIGKILL. But this change
> > caused boot failures because systemd-udevd receives SIGKILL due to timeout
> > while loading SCSI controller drivers using finit_module() [1].
> 
> And I still think that 786235ee simply uncovered the problems in this
> driver. Perhaps we should change kthread_create() for some reason, but
> (imho) not because we need to help the buggy code.
> 
> > Therefore, this patch changes kthread_create() from "wait forever in
> > killable state" to "wait for 10 seconds in unkillable state, check for
> > the OOM killer every second".
> 
> Personally I dislike this change. In fact I think it is ugly. But this
> is only my opinion.
> 
> If you convince someone to take this patch I won't argue.

OK, the fix from the SCSI point of view is to make the mpt teardown path
actually work.  The whole thing looks to be a complete mess because
there's another place where it will do the wrong thing in
mptscsih_remove().  You always have to call mpt_detach() otherwise the
device doesn't get removed from the lists.  In theory this patch fixes
both bugs in the driver.

James

---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..282d39a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1176,10 +1176,14 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_SCSI_HOST		*hd;
 	int sz1;
 
+	if (!host)
+		/* not brought up far enough to do scsi_host_attach() */
+		goto out;
+
 	scsi_remove_host(host);
 
 	if((hd = shost_priv(host)) == NULL)
-		return;
+		goto out;
 
 	mptscsih_shutdown(pdev);
 
@@ -1203,6 +1207,7 @@ mptscsih_remove(struct pci_dev *pdev)
 
 	scsi_host_put(host);
 
+ out:
 	mpt_detach(pdev);
 
 }


