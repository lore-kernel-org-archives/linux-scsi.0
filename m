From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 02/10] zfcp: fix ELS/GS request&response length for hardware data router
Date: Wed, 10 Aug 2016 18:30:45 +0200
Message-ID: <1470846653-90691-3-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63292 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935492AbcHJTC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 15:02:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7AGYILu102955
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:29 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9tfa1d-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:28 -0400
Received: from localhost
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 10 Aug 2016 17:35:26 +0100
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "# 3 . 2+" <stable@vger.kernel.org>

In the hardware data router case, introduced with kernel 3.2
commit 86a9668a8d29 ("[SCSI] zfcp: support for hardware data router")
the ELS/GS request&response length needs to be initialized
as in the chained SBAL case.

Otherwise, the FCP channel rejects ELS requests with
FSF_REQUEST_SIZE_TOO_LARGE.

Such ELS requests can be issued by user space through BSG / HBA API,
or zfcp itself uses ADISC ELS for remote port link test on RSCN.
The latter can cause a short path outage due to
unnecessary remote target port recovery because the always
failing ADISC cannot detect extremely short path interruptions
beyond the local FCP channel.

Below example is decoded with zfcpdbf from s390-tools:

Timestamp      : ...
Area           : SAN
Subarea        : 00
Level          : 1
Exception      : -
CPU id         : ..
Caller         : zfcp_dbf_san_req+0408
Record id      : 1
Tag            : fssels1
Request id     : 0x<reqid>
Destination ID : 0x00<target d_id>
Payload info   : 52000000 00000000 <our wwpn       >           [ADISC]
                 <our wwnn       > 00<s_id> 00000000
                 00000000 00000000 00000000 00000000

Timestamp      : ...
Area           : HBA
Subarea        : 00
Level          : 1
Exception      : -
CPU id         : ..
Caller         : zfcp_dbf_hba_fsf_res+0740
Record id      : 1
Tag            : fs_ferr
Request id     : 0x<reqid>
Request status : 0x00000010
FSF cmnd       : 0x0000000b               [FSF_QTCB_SEND_ELS]
FSF sequence no: 0x...
FSF issued     : ...
FSF stat       : 0x00000061		  [FSF_REQUEST_SIZE_TOO_LARGE]
FSF stat qual  : 00000000 00000000 00000000 00000000
Prot stat      : 0x00000100
Prot stat qual : 00000000 00000000 00000000 00000000

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 86a9668a8d29 ("[SCSI] zfcp: support for hardware data router")
Cc: <stable@vger.kernel.org> # 3.2+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 84353f45cfe6..96d35a7209fa 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -984,8 +984,12 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 	if (zfcp_adapter_multi_buffer_active(adapter)) {
 		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_req))
 			return -EIO;
+		qtcb->bottom.support.req_buf_length =
+			zfcp_qdio_real_bytes(sg_req);
 		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
 			return -EIO;
+		qtcb->bottom.support.resp_buf_length =
+			zfcp_qdio_real_bytes(sg_resp);
 
 		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
 					zfcp_qdio_sbale_count(sg_req));
-- 
2.6.6

