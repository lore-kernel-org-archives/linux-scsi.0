From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] mpt3sas: Force request partial completion alignment
Date: Wed, 28 Dec 2016 10:51:20 -0200
Message-ID: <1482929480-16688-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39481 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbcL1Mww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Dec 2016 07:52:52 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBSCn96t038930
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 07:51:35 -0500
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27m98qjk06-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 07:51:34 -0500
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 28 Dec 2016 10:51:30 -0200
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id 34522352006C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 07:50:57 -0500 (EST)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBSCpRIE32702588
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 10:51:27 -0200
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBSCpRUU008543
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 10:51:27 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, brking@linux.vnet.ibm.com, gpiccoli@linux.vnet.ibm.com, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com

From: Ram Pai <linuxram@us.ibm.com>

The firmware or device, possibly under a heavy I/O load, can return
on a partial unaligned boundary. Scsi-ml expects these requests to be
completed on an alignment boundary. Scsi-ml blindly requeues the I/O
without checking the alignment boundary of the I/O request for the
remaining bytes. This leads to errors, since devices cannot perform
non-aligned read/write operations.

This patch fixes the issue in the driver. It aligns unaligned
completions of FS requests, by truncating them to the nearest
alignment boundary.

Reported-by: Mauricio Faria De Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..55332a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4644,6 +4644,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
+	unsigned int sector_sz;
+	struct request *req;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4703,6 +4705,20 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
+
+	/* In case of bogus fw or device, we could end up having
+	 * unaligned partial completion. We can force alignment here,
+	 * then scsi-ml does not need to handle this misbehavior.
+	 */
+	sector_sz = scmd->device->sector_size;
+	req = scmd->request;
+	if (unlikely(sector_sz && req && (req->cmd_type == REQ_TYPE_FS) &&
+		    (xfer_cnt % sector_sz))) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "unaligned partial completion avoided\n");
+		xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;
+	}
+
 	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
 		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
-- 
2.1.0

