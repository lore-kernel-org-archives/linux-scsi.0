Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3499253957;
	Fri, 19 Sep 2025 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758282731; cv=none; b=W1edqmeMEJS40mJISexrsN7+ScLzsglP3JWHyXczhsyVV0pVtkY2KCfQ+mEscRwt9KOAiNBB6YIG3TJapHhfPQRFhb8BcAPhPhP2Vojmxj0b/NjEcB2DdG1JEgz/Wi5xIWxEi4xDJ2zlmDf5dnQpRUVJkx9CfALx1V4ACMtOYk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758282731; c=relaxed/simple;
	bh=4zOOWCIE/jOUUbkA1p7nAv4iBylqqTbsZNU+OpYIMtM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Zdeg3NKJPp8s16lSlVMK68mqfkjZAdM7wJq4qwv8JKe+wa6rQS02EtLZbyMKoLMs7pNt/yYAM9GxxpX8WxcWud5ZnbG4turQTsH4cYSiRf/uGJQ1Rv6AXGn5ExBwRvOGSJPG+a3Veewvw6/vF/aXhpvoA2vcr4UJ8b/hq8swuvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j59se0WM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j59se0WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348C5C4CEF0;
	Fri, 19 Sep 2025 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758282730;
	bh=4zOOWCIE/jOUUbkA1p7nAv4iBylqqTbsZNU+OpYIMtM=;
	h=Date:From:To:Cc:Subject:From;
	b=j59se0WMkE6KHF7R+PhF5ql6vHkA7RgkKnujtTNGDU7sOBeavbYbWu2KsV+1rfYxX
	 +I54chMi6p8W9eWISW9U1Hxca7HOfnaQvr807ihWAuZ4LHgax2/tgiaWoL85Lv55mn
	 fvb1XGCRl04g3y/tAZpBlWWt5EXq9TZyjnRtJSvqvneQfuE1KghDdiIIWGazNistup
	 GHtbcTMgrirIMelgenu9rOejuXM6oIPJCsdYDWueZFX5hw6/0wmLVyPkxBx6uV5uh6
	 k9Np6vjWpq96grXyeRUZhISLUb8Z0Dp4jWoBhyGEN3tdSLPCgoPCk+TvSz3HFhKycD
	 gxTYnj++WSpNw==
Date: Fri, 19 Sep 2025 13:52:02 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: megaraid_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <aM1D4nPVH96DglfT@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the new TRAILING_OVERLAP() helper to fix the following warnings:

drivers/scsi/megaraid/megaraid_sas_fusion.h:1153:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/megaraid/megaraid_sas_fusion.h:1198:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM)
and a set of MEMBERS that would otherwise follow it --in this case
`struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN]` and
`struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES]` in the
corresponding structures.

This overlays the trailing members onto the FAM (struct MR_LD_SPAN_MAP
ldSpanMap[];) while keeping the FAM and the start of MEMBERS aligned.

The static_assert() ensures this alignment remains, and it's intentionally
placed inmediately after `struct virtnet_info` --no blank line in between).

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index b677d80e5874..ddeea0ee2834 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1150,9 +1150,13 @@ typedef struct LOG_BLOCK_SPAN_INFO {
 } LD_SPAN_INFO, *PLD_SPAN_INFO;
 
 struct MR_FW_RAID_MAP_ALL {
-	struct MR_FW_RAID_MAP raidMap;
-	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES];
+	/* Must be last --ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct MR_FW_RAID_MAP, raidMap, ldSpanMap,
+		struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES];
+	);
 } __attribute__ ((packed));
+static_assert(offsetof(struct MR_FW_RAID_MAP_ALL, raidMap.ldSpanMap) ==
+	      offsetof(struct MR_FW_RAID_MAP_ALL, ldSpanMap));
 
 struct MR_DRV_RAID_MAP {
 	/* total size of this structure, including this field.
@@ -1194,10 +1198,13 @@ struct MR_DRV_RAID_MAP {
  * And it is mainly for code re-use purpose.
  */
 struct MR_DRV_RAID_MAP_ALL {
-
-	struct MR_DRV_RAID_MAP raidMap;
-	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN];
+	/* Must be last --ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct MR_DRV_RAID_MAP, raidMap, ldSpanMap,
+		struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN];
+	);
 } __packed;
+static_assert(offsetof(struct MR_DRV_RAID_MAP_ALL, raidMap.ldSpanMap) ==
+	      offsetof(struct MR_DRV_RAID_MAP_ALL, ldSpanMap));
 
 
 
-- 
2.43.0

