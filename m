From: tom.ty89@gmail.com
Subject: [PATCH resend v2 2/5] libata-scsi: fix read-only bits checking in ata_mselect_*()
Date: Fri, 22 Jul 2016 07:34:30 +0800
Message-ID: <57915c0d.0a6b620a.960cd.4d0f@mx.google.com>
References: <CAGnHSE=-upJ7_Wj-mpaa_tfZ6vxAbx5xaGqe0eRjFrw6Rw+ttA@mail.gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSE=-upJ7_Wj-mpaa_tfZ6vxAbx5xaGqe0eRjFrw6Rw+ttA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Commit 7780081c1f04 ("libata-scsi: Set information sense field for
invalid parameter") changed how ata_mselect_*() make sure read-only
bits are not modified. The new implementation introduced a bug that
the read-only bits in the byte that has a changeable bit will not
be checked.

Made it check every byte but mask the changeable bit.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index eb5e8ff..4a4e6f1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3611,7 +3611,7 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
 	char mpage[CACHE_MPAGE_LEN];
-	u8 wce;
+	u8 wce, mask;
 	int i;
 
 	/*
@@ -3632,8 +3632,11 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 	ata_msense_caching(dev->id, mpage, false);
 	for (i = 0; i < CACHE_MPAGE_LEN - 2; i++) {
 		if (i == 0)
-			continue;
-		if (mpage[i + 2] != buf[i]) {
+			mask = 0xfb;
+		else
+			mask = 0xff;
+
+		if ((mpage[i + 2] & mask) != (buf[i] & mask)) {
 			*fp = i;
 			return -EINVAL;
 		}
@@ -3666,7 +3669,7 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 {
 	struct ata_device *dev = qc->dev;
 	char mpage[CONTROL_MPAGE_LEN];
-	u8 d_sense;
+	u8 d_sense, mask;
 	int i;
 
 	/*
@@ -3687,8 +3690,11 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	ata_msense_control(dev, mpage, false);
 	for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
 		if (i == 0)
-			continue;
-		if (mpage[2 + i] != buf[i]) {
+			mask = 0xfb;
+		else
+			mask = 0xff;
+
+		if ((mpage[2 + i] & mask) != (buf[i] & mask)) {
 			*fp = i;
 			return -EINVAL;
 		}
-- 
2.9.0

