From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in
 interrupt context
Date: Thu, 10 Nov 2011 09:47:49 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6047262C625@inbmail02.lsi.com>
References: <20110731192909.16bb341e@kryten> <20111107220521.03e22b45@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:39219 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1KJER5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2011 23:17:57 -0500
In-Reply-To: <20111107220521.03e22b45@kryten>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The patch seem to be fine. Please consider this patch as an Acked by me

Regards,
Nagalakshmi


-----Original Message-----
From: Anton Blanchard [mailto:anton@samba.org] 
Sent: Monday, November 07, 2011 4:35 PM
To: Desai, Kashyap
Cc: Moore, Eric; JBottomley@parallels.com; linux-scsi@vger.kernel.org
Subject: Re: [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context


Hi Kashyap,

On Sun, 31 Jul 2011 19:29:09 +1000
Anton Blanchard <anton@samba.org> wrote:
> 
> _scsih_smart_predicted_fault is called in an interrupt and therefore
> must allocate memory using GFP_ATOMIC.

Just noticed this hasn't made it upstream, any chance you could review
it for merging?

Anton
--

_scsih_smart_predicted_fault is called in an interrupt and therefore
must allocate memory using GFP_ATOMIC.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

Index: linux-work/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-work.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-11-07 22:03:33.728865287 +1100
+++ linux-work/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-11-07 22:03:39.724972491 +1100
@@ -4330,7 +4330,7 @@ _scsih_smart_predicted_fault(struct MPT2
 	/* insert into event log */
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
 	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
-	event_reply = kzalloc(sz, GFP_KERNEL);
+	event_reply = kzalloc(sz, GFP_ATOMIC);
 	if (!event_reply) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
