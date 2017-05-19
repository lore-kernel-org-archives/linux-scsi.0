From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 4/7] qedi: Fix endpoint NULL panic in qedi_set_path.
Date: Fri, 19 May 2017 01:33:18 -0700
Message-ID: <20170519083321.18030-5-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0047.outbound.protection.outlook.com ([104.47.41.47]:15167
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751460AbdESIdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:41 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

 RIP: 0010:qedi_set_path+0x114/0x570 [qedi]
 Call Trace:
  [<ffffffffa0472923>] iscsi_if_recv_msg+0x623/0x14a0
  [<ffffffff81307de6>] ? rhashtable_lookup_compare+0x36/0x70
  [<ffffffffa047382e>] iscsi_if_rx+0x8e/0x1f0
  [<ffffffff8155983d>] netlink_unicast+0xed/0x1b0
  [<ffffffff81559c30>] netlink_sendmsg+0x330/0x770
  [<ffffffff81510d60>] sock_sendmsg+0xb0/0xf0
  [<ffffffff8101360b>] ? __switch_to+0x17b/0x4b0
  [<ffffffff8163a2c8>] ? __schedule+0x2d8/0x900
  [<ffffffff81511199>] ___sys_sendmsg+0x3a9/0x3c0
  [<ffffffff810e2298>] ? get_futex_key+0x1c8/0x2b0
  [<ffffffff810e25a0>] ? futex_wake+0x80/0x160

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 1917793..87f0af3 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1224,8 +1224,12 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 
 	iscsi_cid = (u32)path_data->handle;
 	qedi_ep = qedi->ep_tbl[iscsi_cid];
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "iscsi_cid=0x%x, qedi_ep=%p\n", iscsi_cid, qedi_ep);
+	if (!qedi_ep) {
+		ret = -EINVAL;
+		goto set_path_exit;
+	}
 
 	if (!is_valid_ether_addr(&path_data->mac_addr[0])) {
 		QEDI_NOTICE(&qedi->dbg_ctx, "dst mac NOT VALID\n");
-- 
1.8.3.1
