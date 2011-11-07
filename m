From: Anton Blanchard <anton@samba.org>
Subject: Re: [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in
 interrupt context
Date: Mon, 7 Nov 2011 22:05:21 +1100
Message-ID: <20111107220521.03e22b45@kryten>
References: <20110731192909.16bb341e@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1KGLFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2011 06:05:23 -0500
In-Reply-To: <20110731192909.16bb341e@kryten>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@lsi.com
Cc: eric.moore@lsi.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org


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
