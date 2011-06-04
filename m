From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/7] iscsi-target: Fix iscsit_do_crypto_hash_sg() bug
Date: Fri,  3 Jun 2011 18:18:18 -0700
Message-ID: <1307150298-23921-8-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.136]:43986
	"HELO nm3-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752740Ab1FDBTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:19:13 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes breakage in iscsit_do_crypto_hash_sg() where
crypto_hash_update() was not referencing the current sg[] offset 'i'.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d84d52b..fdeea0f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1243,7 +1243,7 @@ static u32 iscsit_do_crypto_hash_sg(
 	while (data_length) {
 		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
 
-		crypto_hash_update(hash, sg, cur_len);
+		crypto_hash_update(hash, &sg[i], cur_len);
 
 		data_length -= cur_len;
 		page_off = 0;
-- 
1.7.2.5

