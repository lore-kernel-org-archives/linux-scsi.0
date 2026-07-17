Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17CC3403FE;
	Fri, 17 Jul 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302772; cv=none; b=NzQ7UvNAqzeDg6U8g8bgjg+wOoWXkLiGVsAkWPBIEGJIa16xyrDVl1+FLgVxOrL3p+KEROIVOcGIkZMPhwJjuKs966LGDCAlKH2NAdkN27yMCelGEe37A+X6vVe7GZnWvdWubHdmc4rS6BS0XnZL05+QCUPN0VFrJ9NToDcMWI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302772; c=relaxed/simple;
	bh=iyBVSLEXGrgKOou1YLMfigS1RsXHcPBpRZVTMx7c8sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKAKyrjdrtG0fSrV1t1PU2CshV1pA934wY6WLqH2zVyblWSNLn6E+fT663AvYG2irbOHGbdwUOpkfAq21mw9TjHRopDBae0aJp222Hpfco50gwBCTruV7w/dVA1n2ptkgJS5/Uk/bHuGOAIRTYPxqzaVgpc9pzoiOINV4a+vkI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: aef2ae4a81f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:330ff955-1933-47c0-9c9e-8a6e83110d1c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:330ff955-1933-47c0-9c9e-8a6e83110d1c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:1479b18c926dc5008f5f0571dab645c0,BulkI
	D:2607172339236XID7AL8,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aef2ae4a81f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1500451444; Fri, 17 Jul 2026 23:39:22 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH v2 1/6] scsi: ufs: core: Validate string descriptors
Date: Fri, 17 Jul 2026 23:39:08 +0800
Message-ID: <20260717153914.26321-2-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The string descriptor length includes a two-byte header while the
UTF-16 payload starts after it. utf16s_to_utf8s() expects a count
of UTF-16 code units, not bytes. Passing the payload byte count can
make it read beyond the descriptor buffer.

Validate that the payload has an even byte count, pass a code-unit
count to the converter, and allocate sufficient UTF-8 output space.

The raw string buffer starts after the descriptor header but its size
is bLength. Copying bLength bytes from that pointer can read beyond
the response buffer.

Allocate a zeroed bLength-sized buffer and copy only the UTF-16
payload. This preserves the raw buffer size consumed by the RPMB
device-ID ABI while avoiding the overread.

Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
Fixes: d794b499f948 ("scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufshcd.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..3541da5b6f4d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3865,7 +3865,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
-	int ret;
+	int ret, uc_len;
 
 	if (!buf)
 		return -EINVAL;
@@ -3890,11 +3890,19 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		goto out;
 	}
 
+	uc_len = uc_str->len - QUERY_DESC_HDR_SIZE;
+	if (uc_len % sizeof(*uc_str->uc)) {
+		dev_err(hba->dev, "String Desc has an odd UTF-16 payload length\n");
+		str = NULL;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
-		/* remove header and divide by 2 to move from UTF16 to UTF8 */
-		ascii_len = (uc_str->len - QUERY_DESC_HDR_SIZE) / 2 + 1;
+		/* Allow up to three UTF-8 bytes per UTF-16 code unit plus a NUL. */
+		ascii_len = uc_len / sizeof(*uc_str->uc) * 3 + 1;
 		str = kzalloc(ascii_len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
@@ -3906,7 +3914,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		 * we need to convert to utf-8 so it can be displayed
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
-				      uc_str->len - QUERY_DESC_HDR_SIZE,
+				      uc_len / sizeof(*uc_str->uc),
 				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
@@ -3916,11 +3924,17 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
+		/*
+		 * Keep the bLength-sized raw output for the RPMB device ID ABI.
+		 * The two bytes beyond the UTF-16 payload are explicitly zeroed
+		 * instead of being read past the descriptor buffer.
+		 */
+		str = kzalloc(uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
 		}
+		memcpy(str, uc_str->uc, uc_len);
 		ret = uc_str->len;
 	}
 out:
-- 
2.43.0

