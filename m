From: tom.ty89@gmail.com
Subject: [PATCH resend v2 3/5] libata-scsi: use u8 array to store mode page copy
Date: Fri, 22 Jul 2016 07:35:34 +0800
Message-ID: <57915c4c.4229620a.243a4.4d9f@mx.google.com>
References: <20160721214202.GG23759@htj.duckdns.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160721214202.GG23759@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

ata_mselect_*() would initialize a char array for storing a copy of
the current mode page. However, char could be signed char. In that
case, bytes larger than 127 would be converted to negative number.

For example, 0xff from def_control_mpage[] would become -1. This
prevented ata_mselect_control() from working at all, since when it
did the read-only bits check, there would always be a mismatch.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4a4e6f1..a28e2ea94 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3610,7 +3610,7 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
-	char mpage[CACHE_MPAGE_LEN];
+	u8 mpage[CACHE_MPAGE_LEN];
 	u8 wce, mask;
 	int i;
 
@@ -3668,7 +3668,7 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 			       const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
-	char mpage[CONTROL_MPAGE_LEN];
+        u8 mpage[CONTROL_MPAGE_LEN];
 	u8 d_sense, mask;
 	int i;
 
-- 
2.9.0
