From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression]
	kthread:makekthread_create()killable)
Date: Fri, 21 Mar 2014 19:34:43 +0100
Message-ID: <20140321183443.GA3891@redhat.com>
References: <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp> <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com> <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140320192307.GA11883@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 03/20, Oleg Nesterov wrote:
>
> On 03/20, Joseph Salisbury wrote:
> >
> > There was some testing done with your test kernel.  The data collected
> > while running your kernel is available in the bug report:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705/comments/58
>
> Joseph, thanks a lot.
>
> I'll try to read the logs tomorrow, but at first glance Tetsuo was right,
> I do not see a "long" sleep in that log.

Yes, it seems that it actually needs > 30 secs. It spends most of the time
(30.13286 seconds) in

	msleep+0x20/0x30
	WaitForDoorbellInt+0x103/0x130 [mptbase]
	WaitForDoorbellReply+0x42/0x220 [mptbase]
	mpt_handshake_req_reply_wait+0x1dc/0x2c0 [mptbase]
	SendPortEnable.constprop.23+0x94/0xc0 [mptbase]

WaitForDoorbellInt() does msleep(1) in a loop. This trace starts at the line
6001, and it is repeated 3792 times, till the line 176686 which apparently
shows the trace of the 2nd WaitForDoorbellInt() in WaitForDoorbellReply().

SendPortEnable:

	if (ioc->ir_firmware || ioc->bus_type == SAS) {
		rc = mpt_handshake_req_reply_wait(ioc, req_sz,
		(u32*)&port_enable, reply_sz, (u16*)&reply_buf,
		300 /*seconds*/, sleepFlag);
	} else {
		rc = mpt_handshake_req_reply_wait(ioc, req_sz,
		(u32*)&port_enable, reply_sz, (u16*)&reply_buf,
		30 /*seconds*/, sleepFlag);
	}

I am wondering which branch calls mpt_handshake_req_reply_wait(), the
else's timeout=30 (passed to the 1st WaitForDoorbellInt) suspiciously
matches the time WaitForDoorbellInt() actually runs... But everything
works fine and at first glance the potential timeout error should be
propogated correctly. So "timeout" is probably 300. And probably this
all is fine.

All I can suggest is the dirty hack for now. User-space should be
changed too, I think, but this is another story.

Tetsuo, what do you think?

Oleg.
---


--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5395,6 +5395,8 @@ static struct pci_driver mptsas_driver = {
 #endif
 };
 
+#include <linux/signal.h>
+
 static int __init
 mptsas_init(void)
 {
@@ -5424,7 +5426,31 @@ mptsas_init(void)
 	mpt_event_register(mptsasDoneCtx, mptsas_event_process);
 	mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset);
 
-	error = pci_register_driver(&mptsas_driver);
+	{
+		sigset_t full, save;
+		/*
+		 * KILL ME. THIS IS THE DIRTY AND WRONG HACK WAITING FOR THE
+		 * FIX FROM MAINTAINERS.
+		 *
+		 * - This driver needs a lot of time to complete SendPortEnable()
+		 *   but systemd-udevd sends SIGKILL after 30 seconds, see
+		 *   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705
+		 *
+		 *   Probably user-space should be changed, but:
+		 *
+		 * - Since commit 786235eeba0e "kthread: make kthread_create()
+		 *   killable" scsi_host_alloc() becomes killable and this SIGKILL
+		 *   crashes the kernel.
+		 *
+		 *   If scsi_host_alloc() fails mptsas_probe() blindly calls
+		 *   mptscsih_remove() and scsi_remove_host() hits host == NULL.
+		 */
+		sigfillset(&full);
+		sigprocmask(SIG_SETMASK, &full, &save);
+		error = pci_register_driver(&mptsas_driver);
+		sigprocmask(SIG_SETMASK, &save, NULL);
+	}
+
 	if (error)
 		sas_release_transport(mptsas_transport_template);
 
