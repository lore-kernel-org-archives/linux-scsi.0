From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 4/18] qla4xxx: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:13 +0200
Message-ID: <1401117687-28911-5-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: benoit.taine@lip6.fr, iscsi-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/qla4xxx/ql4_os.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9eef7d4..3202063 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3565,14 +3565,13 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
 		conn->ipv6_traffic_class = fw_ddb_entry->ipv4_tos;
 
-		conn->link_local_ipv6_addr = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+		conn->link_local_ipv6_addr = kmemdup(
+					fw_ddb_entry->link_local_ipv6_addr,
+					IPv6_ADDR_LEN, GFP_KERNEL);
 		if (!conn->link_local_ipv6_addr) {
 			rc = -ENOMEM;
 			goto exit_copy;
 		}
-
-		memcpy(conn->link_local_ipv6_addr,
-		       fw_ddb_entry->link_local_ipv6_addr, IPv6_ADDR_LEN);
 	} else {
 		conn->ipv4_tos = fw_ddb_entry->ipv4_tos;
 	}
