Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D5F221FCD;
	Thu, 16 Jul 2026 06:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182842; cv=none; b=DrhnF3/wQ1ELAnJ4s22Dn8qZ3BpHYolznPGbh582T1iXJC9Jph5xdNEARjTQKwj8wte9FGapnY4fA/HEP4i6RLtC5mFnJw9XnBsf/SPzm4ziqMZc1Bl09EDMo75zvh8Pe0Hwriabb/TiVXecMXr08VNdzVbEprhQzF4uUjLYkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182842; c=relaxed/simple;
	bh=tCpoL5XK5VY0OlZKps6GfpgB1lIofIitQjnMPq3rt+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOO1reMhmY7nv5jcfZoB+NINHwbiULyBwMEXfZ1FpvT5LPWlrC6h248dTCxKmkkAMh+lVVZu7egmPLCV0mQMhcLVVTzs6Vdh4ed2Zgl8ikOt/JY/P2S/srz/uHywRSWkXu9e2keNSdQHxomSDncAUqRWMqHIRE3TdMQR9FuKikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 743e0e9c80de11f1aa26b74ffac11d73-20260716
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:39acd807-1be4-4647-90b5-bd5af1fda8b1,IP:15,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:39acd807-1be4-4647-90b5-bd5af1fda8b1,IP:15,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:1434aff7e56e8bb2da39c96e5d51f507,BulkI
	D:260716142035SE0J6FE1,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 743e0e9c80de11f1aa26b74ffac11d73-20260716
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1687945130; Thu, 16 Jul 2026 14:20:34 +0800
From: liqiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH 1/5] scsi: ufs: core: Validate string descriptors
Date: Thu, 16 Jul 2026 14:19:51 +0800
Message-ID: <c68b23bd15e3ff570e95afb5422bc242efd038df.1784182493.git.liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Qiang <liqiang01@kylinos.cn>

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

