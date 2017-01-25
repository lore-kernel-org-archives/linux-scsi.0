From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] mpt3sas: Force request partial completion alignment
Date: Wed, 25 Jan 2017 18:46:13 -0500
Message-ID: <yq1a8aebt4q.fsf@oracle.com>
References: <1485272838-23180-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38012 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdAYXqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 18:46:22 -0500
In-Reply-To: <1485272838-23180-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
        (Guilherme G. Piccoli's message of "Tue, 24 Jan 2017 13:47:18 -0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com, brking@linux.vnet.ibm.com, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com

>>>>> "Guilherme" == Guilherme G Piccoli <gpiccoli@linux.vnet.ibm.com> writes:

Hi Guilherme,

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 75f3fce..e52c942 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4657,6 +4657,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
+	unsigned int sector_sz;
+	struct request *req;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4715,6 +4717,21 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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

Maybe a bit zealous on the sanity checking...

+		sdev_printk(KERN_INFO, scmd->device,
+			"unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
+			xfer_cnt, sector_sz);
+		xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;

Not so keen on divisions. xfer_cnt = round_down(xfer_cnt, sector_sz), maybe?

-- 
Martin K. Petersen	Oracle Linux Engineering
