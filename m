From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH RESEND 2/5] kexec: Export kexec_in_progress
Date: Tue, 02 Dec 2014 12:47:41 -0600
Message-ID: <201412021847.sB2Ilfvc002145@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:54283 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBSrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 13:47:47 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 11:47:47 -0700
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5A88038C8059
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 13:47:44 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2Ili0b19136664
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 18:47:44 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2IlgRS002364
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 13:47:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org, brking@linux.vnet.ibm.com, ebiederm@xmission.com, kexec@lists.infradead.org


A kexec boot for some ipr SAS adapters was seen to take ~20 seconds
just doing ipr adapter initialization. This is due to the fact that
a kexec invokes the driver's shutdown handler which places the adapter
into a state that requires a hard reset and resulting firmware initialization
to be usable again, which takes significant time. By exporting kexec_in_progress,
this process can be optimized significantly in the driver by essentially
placing the adapter into a state where this hardware reset and re-initialization
can be bypassed, eliminating this delay in kexec boot.

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: kexec <kexec@lists.infradead.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
--- scsi-queue/kernel/kexec.c~kexec_export_in_prog	2014-12-02 12:13:22.820325731 -0600
+++ scsi-queue-bjking1/kernel/kexec.c	2014-12-02 12:13:22.825325687 -0600
@@ -2768,3 +2768,5 @@ int kernel_kexec(void)
 	mutex_unlock(&kexec_mutex);
 	return error;
 }
+
+EXPORT_SYMBOL_GPL(kexec_in_progress);
_

