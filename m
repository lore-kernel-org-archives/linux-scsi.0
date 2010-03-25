From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 1/3] [BNX2I] instruct firmware to use driver/iscsid
 provided expected statsn
Date: Thu, 25 Mar 2010 10:54:40 -0700
Message-ID: <1269539680.28522.68948.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4271 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0CYRy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 13:54:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com, waie@broadcom.com

	[BNX2I] instruct firmware to use driver/iscsid provided expected statsn
		field while constructing login pdu header.

	* Initialize 'flags' to instruct chip to use driver/iscsid provided
	  ExpStatSN value while constructing iSCSI login PDU header

Signed-off-by: Eddie Wai <waie@broadcom.com>
Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>

---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 1af578d..d5d8234 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -346,6 +346,7 @@ int bnx2i_send_iscsi_login(struct bnx2i_conn *bnx2i_conn,
 
 	login_wqe->cmd_sn = be32_to_cpu(login_hdr->cmdsn);
 	login_wqe->exp_stat_sn = be32_to_cpu(login_hdr->exp_statsn);
+	login_wqe->flags = ISCSI_LOGIN_REQUEST_UPDATE_EXP_STAT_SN;
 
 	login_wqe->resp_bd_list_addr_lo = (u32) bnx2i_conn->gen_pdu.resp_bd_dma;
 	login_wqe->resp_bd_list_addr_hi =
@@ -355,7 +356,6 @@ int bnx2i_send_iscsi_login(struct bnx2i_conn *bnx2i_conn,
 		 (bnx2i_conn->gen_pdu.resp_buf_size <<
 		  ISCSI_LOGIN_REQUEST_RESP_BUFFER_LENGTH_SHIFT));
 	login_wqe->resp_buffer = dword;
-	login_wqe->flags = 0;
 	login_wqe->bd_list_addr_lo = (u32) bnx2i_conn->gen_pdu.req_bd_dma;
 	login_wqe->bd_list_addr_hi =
 		(u32) ((u64) bnx2i_conn->gen_pdu.req_bd_dma >> 32);
-- 
1.6.5.1




