From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] megaraid_sas: use raw_smp_processor_id()
Date: Wed, 15 Apr 2015 09:44:37 -0700
Message-ID: <20150415164437.GA17287@infradead.org>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718AbbDOQoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2015 12:44:38 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

We only want to steer the I/O completion towards a queue, but don't
actually access any per-CPU data, so the raw_ version is fine to use
and avoids the warnings when using smp_processor_id().

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Andy Lutomirski <luto@kernel.org>
Tested-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675b5e7..5a0800d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1584,11 +1584,11 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			fp_possible = io_info.fpOkForIo;
 	}
 
-	/* Use smp_processor_id() for now until cmd->request->cpu is CPU
+	/* Use raw_smp_processor_id() for now until cmd->request->cpu is CPU
 	   id by default, not CPU group id, otherwise all MSI-X queues won't
 	   be utilized */
 	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
-		smp_processor_id() % instance->msix_vectors : 0;
+		raw_smp_processor_id() % instance->msix_vectors : 0;
 
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
@@ -1693,7 +1693,10 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 			<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
 		cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
 		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->msix_vectors ? smp_processor_id() % instance->msix_vectors : 0;
+			instance->msix_vectors ?
+				raw_smp_processor_id() %
+					instance->msix_vectors :
+				0;
 		os_timeout_value = scmd->request->timeout / HZ;
 
 		if (instance->secure_jbod_support &&
