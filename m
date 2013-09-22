From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/5] scsi: Fix assignment of 0/1 to bool variables
Date: Sun, 22 Sep 2013 20:44:09 +0200
Message-ID: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: naresh@chelsio.com, davem@davemloft.net, jj@chaosbits.net, arvindb@chelsio.com, hare@suse.de, michaelc@cs.wisc.edu, vijay.chauhan@netapp.com, bvanassche@acm.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Convert 0 to false and 1 to true when assigning values to bool
variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@@
bool b;
@@
(
-b = 0
+b = false
|
-b = 1
+b = true
)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/csiostor/csio_hw.c            |    4 ++--
 drivers/scsi/cxgbi/libcxgbi.c              |    4 ++--
 drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -u -p a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1603,7 +1603,7 @@ static int skb_read_pdu_data(struct iscs
 			     struct sk_buff *skb, unsigned int offset)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	bool offloaded = 0;
+	bool offloaded = false;
 	int opcode = tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
@@ -1626,7 +1626,7 @@ static int skb_read_pdu_data(struct iscs
 		offset += ISCSI_DIGEST_SIZE;
 
 	if (cxgbi_skcb_test_flag(lskb, SKCBF_RX_DATA_DDPD))
-		offloaded = 1;
+		offloaded = true;
 
 	if (opcode == ISCSI_OP_SCSI_DATA_IN)
 		log_debug(1 << CXGBI_DBG_PDU_RX,
diff -u -p a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -528,7 +528,7 @@ static int alua_rtpg(struct scsi_device
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err;
-	bool rtpg_ext_hdr_req = 1;
+	bool rtpg_ext_hdr_req = true;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
@@ -558,7 +558,7 @@ static int alua_rtpg(struct scsi_device
 		if (rtpg_ext_hdr_req == 1 &&
 		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
 		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
-			rtpg_ext_hdr_req = 0;
+			rtpg_ext_hdr_req = false;
 			goto retry;
 		}
 
diff -u -p a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3476,7 +3476,7 @@ csio_process_fwevtq_entry(struct csio_hw
 	__u8 op;
 	void *msg = NULL;
 	uint32_t msg_len = 0;
-	bool msg_sg = 0;
+	bool msg_sg = false;
 
 	op = ((struct rss_header *) wr)->opcode;
 	if (op == CPL_FW6_PLD) {
@@ -3488,7 +3488,7 @@ csio_process_fwevtq_entry(struct csio_hw
 
 		msg = (void *) flb;
 		msg_len = flb->totlen;
-		msg_sg = 1;
+		msg_sg = true;
 	} else if (op == CPL_FW6_MSG || op == CPL_FW4_MSG) {
 
 		CSIO_INC_STATS(hw, n_cpl_fw6_msg);

