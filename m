From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 029/103] target: Fix double test of inquiry_prod
Date: Thu, 21 Jul 2011 00:05:05 -0700
Message-ID: <1311231979-6631-30-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.bf1.yahoo.com ([98.139.212.162]:32503 "HELO
	nm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752258Ab1GUHHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:10 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

The code in transport_add_device_to_core_hba() really intends to make sure
that neither inquiry_prod nor inquiry_rev is NULL.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e4406c9..6f5d4df 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1623,7 +1623,7 @@ struct se_device *transport_add_device_to_core_hba(
 	 * setup.
 	 */
 	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (!(inquiry_prod) || !(inquiry_prod)) {
+		if (!inquiry_prod || !inquiry_rev) {
 			printk(KERN_ERR "All non TCM/pSCSI plugins require"
 				" INQUIRY consts\n");
 			goto out;
-- 
1.7.6

