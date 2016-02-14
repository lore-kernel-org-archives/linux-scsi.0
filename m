From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 20/34] iscsi-target: update struct iscsit_transport definition
Date: Sun, 14 Feb 2016 23:12:14 +0530
Message-ID: <a7968adffc57ab25f06713890159014b3571bc53.1455467089.git.varun@chelsio.com>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:28512 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751777AbcBNRms (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:42:48 -0500
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

add new function pointers to support ISCSI_TCP_CXGB4
transport,

1. void (*iscsit_rx_pdu)(struct iscsi_conn *);
   Rx thread uses this for receiving and processing
   iSCSI PDU in full feature phase.

2. void (*iscsit_release_cmd)(struct iscsi_conn *,
   struct iscsi_cmd *);
   This function pointer is used for releasing
   transport resources associated with the cmd.

3. int (*iscsit_validate_params)(struct iscsi_conn *);
   This function is used for checking whether default
   connection operational parameters are supported by
   the transport, if not transport driver will set the
   supported value.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 include/target/iscsi/iscsi_transport.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index a47124b..83228a7 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -22,6 +22,9 @@ struct iscsit_transport {
 	int (*iscsit_queue_data_in)(struct iscsi_conn *, struct iscsi_cmd *);
 	int (*iscsit_queue_status)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
+	void (*iscsit_rx_pdu)(struct iscsi_conn *);
+	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
+	int (*iscsit_validate_params)(struct iscsi_conn *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2

