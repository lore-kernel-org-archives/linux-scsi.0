From: tom.ty89@gmail.com
Subject: [PATCH resend 3/5] libata-scsi: fix overflow in mode page copy
Date: Fri, 22 Jul 2016 02:41:52 +0800
Message-ID: <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com> <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

ata_mselect_*() would initialize a char array for storing a copy of
the current mode page. However, if char was actually signed char,
overflow could occur.

For example, `0xff` from def_control_mpage[] would be "truncated"
to `-1`. This prevented ata_mselect_control() from working at all,
since when it did the read-only bits check, there would always be
a mismatch.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ac90676..3c93341 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3610,7 +3610,7 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
-	char mpage[CACHE_MPAGE_LEN];
+	u8 mpage[CACHE_MPAGE_LEN];
 	u8 wce;
 	int i;
 
@@ -3675,7 +3675,7 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 			       const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
-	char mpage[CONTROL_MPAGE_LEN];
+	u8 mpage[CONTROL_MPAGE_LEN];
 	u8 d_sense;
 	int i;
 
-- 
2.9.0

