From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 09/10] zfcp: fix payload trace length for SAN request&response
Date: Wed, 10 Aug 2016 18:30:52 +0200
Message-ID: <1470846653-90691-10-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41268 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933033AbcHJSOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:14:07 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7AGXxN3117571
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:50 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9sxu3r-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:50 -0400
Received: from localhost
	by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 10 Aug 2016 17:35:48 +0100
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

commit 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
started to add FC_CT_HDR_LEN which made zfcp dump random data
out of bounds for RSPN GS responses because u.rspn.rsp
is the largest and last field in the union of struct zfcp_fc_req.
Other request/response types only happened to stay within bounds
due to the padding of the union or
due to the trace capping of u.gspn.rsp to ZFCP_DBF_SAN_MAX_PAYLOAD.

Timestamp      : ...
Area           : SAN
Subarea        : 00
Level          : 1
Exception      : -
CPU id         : ..
Caller         : ...
Record id      : 2
Tag            : fsscth2
Request id     : 0x...
Destination ID : 0x00fffffc
Payload short  : 01000000 fc020000 80020000 00000000
                 xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx <===
                 00000000 00000000 00000000 00000000
Payload length : 32                                  <===

struct zfcp_fc_req {
    [0] struct zfcp_fsf_ct_els ct_els;
   [56] struct scatterlist sg_req;
   [96] struct scatterlist sg_rsp;
        union {
            struct {req; rsp;} adisc;    SIZE: 28+28=   56
            struct {req; rsp;} gid_pn;   SIZE: 24+20=   44
            struct {rspsg; req;} gpn_ft; SIZE: 40*4+20=180
            struct {req; rsp;} gspn;     SIZE: 20+273= 293
            struct {req; rsp;} rspn;     SIZE: 277+16= 293
  [136] } u;
}
SIZE: 432

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 2c55b750a884 ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Alexey Ishchuk <aishchuk@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 968897f5e1c6..d8c0bfb40366 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -389,7 +389,7 @@ void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
 	struct zfcp_fsf_ct_els *ct_els = fsf->data;
 	u16 length;
 
-	length = (u16)(ct_els->req->length + FC_CT_HDR_LEN);
+	length = (u16)(ct_els->req->length);
 	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->req), ZFCP_DBF_SAN_REQ, length,
 		     fsf->req_id, d_id);
 }
@@ -405,7 +405,7 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 	struct zfcp_fsf_ct_els *ct_els = fsf->data;
 	u16 length;
 
-	length = (u16)(ct_els->resp->length + FC_CT_HDR_LEN);
+	length = (u16)(ct_els->resp->length);
 	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->resp), ZFCP_DBF_SAN_RES, length,
 		     fsf->req_id, ct_els->d_id);
 }
-- 
2.6.6

