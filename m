From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Wed, 30 Jul 2008 03:30:34 -0700
Message-ID: <20080730103034.GG41607@plap4-2.qlogic.org>
References: <488E02DE.5080100@vlnb.net> <20080728180745.GE12762@plap4-2.qlogic.org> <488EE3A9.8030207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39915 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYG3Kah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 06:30:37 -0400
Content-Disposition: inline
In-Reply-To: <488EE3A9.8030207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Tue, 29 Jul 2008, Vladislav Bolkhovitin wrote:

>> Ok, your change looks correct here...  This is defintely the correct
>> way the qla24xx_report_id_acquisition() routine should be triggering
>> the DPC thread.
>>
>> I'm guessing the backtrace in "Gal Rosen's" report pointed to
>> qla24xx_report_id_acquisition()?  If, so, I'm not entirely sure we
>> need anything more to 'protect' tear-down...
>
> Nope, taking only one that hunk from this patch isn't sufficient. Around 
> dpc_thread there is pretty simple and classical race. You can't do
>
> if (x != NULL)
> 	y = *x;
>
> without any protection, if x can be set to NULL by another thread. It can 
> happen exactly between "if" and "*x" and hence lead to a crash, correct?
>
> What this patch does is adding such protection.

So there's a couple of ways we can address this:

* Drop the qla2xxx_wake_dpc() calls from all paths and let the timer
  handle triggering of the DPC routine...

* Simply extend the qla2xxx_wake_dpc() function to be a bit more
  careful during wakeup. In this case, check that ha->flags.online is
  set before waking-up the process.

The first option seems a bit heavy-handed, the second, a more
reasonable option without introducing any additional locks or the
like.

I'll queue-up the following to my queue, if there's no major
objections...

--
av

---

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bc90d6b..813bc77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2686,7 +2686,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
 		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-		wake_up_process(ha->dpc_thread);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c8af7e..12b127a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2451,8 +2451,10 @@ qla2x00_do_dpc(void *data)
 void
 qla2xxx_wake_dpc(scsi_qla_host_t *ha)
 {
-	if (ha->dpc_thread)
-		wake_up_process(ha->dpc_thread);
+	struct task_struct *t = ha->dpc_thread;
+
+	if (ha->flags.online && t)
+		wake_up_process(t);
 }
 
 /*
