Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D0316DEC0;
	Thu, 11 Jul 2024 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721228; cv=none; b=pqpL5wMUpD9vpHlrARFlgMLNSy5mZOPPaIaaiqLm73Zp3inxMv7NIpnVZmfz3Y/rdglYetBIj/vFs5ii2oC9pN/xZkfJYtt/bYCPDDMtyVAEfiZSzrPVmOFRRn7UNG3OeMWfGRDwiJ+Lw+zvNMof/pJbxCEWETj6jumRrosiH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721228; c=relaxed/simple;
	bh=EtcF8uQ/QN2Cq9DSFB4M4YAovjV0kOImqb2khua9nY4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OnjIdefIjpj8H9d4soPjbw8eQcdOTpNQ+MvVgygsgpOV4ta5r5oATswJ9ru4tId4e5BR2V7H6oeQFAxoqDELFglEXws+4IG8v6ycZLFTP2qLDGR0cdaLlXHObfkPlFAQJS1malyYzCpDGM3jYUPAwg/CPgV07C53ssGA3ARn0qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHBayMaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHBayMaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E1FC116B1;
	Thu, 11 Jul 2024 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720721227;
	bh=EtcF8uQ/QN2Cq9DSFB4M4YAovjV0kOImqb2khua9nY4=;
	h=From:To:Cc:Subject:Date:From;
	b=rHBayMaCSHsy+Wr+So3vygZW06zHR7UI78oVM2Pa2R2deXD0DzU4IrAD4DUoHbyLA
	 hQTT2Ty+sd0vPzht+x+ha/iNXibyQXxFVxro//KHMNDUsZFnxRMIMoG34Q3z7pbTTr
	 BsFB+gAeLA1HFegqJ/ZGq8CbDsNiGMNxmg+sLK6FTnM86++Xv2aboyUmLwFgv7B3aB
	 8SsuGKV0KDSLQ/TzhaeqMUTpDwufanAkmdBwqUrMHAQmTKxhH1WthxLl+g9JMOG97K
	 K6VAyBTBxyYpUtJ2xFyV1Rwb7FSnAUbOWNAu9gPp5xMpyeSpOwJHQneqBbDOt7cO39
	 eGTe1oi/Xx1eQ==
From: Kees Cook <kees@kernel.org>
To: Brian King <brking@us.ibm.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: ipr: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 11:07:06 -0700
Message-Id: <20240711180702.work.536-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; i=kees@kernel.org; h=from:subject:message-id; bh=EtcF8uQ/QN2Cq9DSFB4M4YAovjV0kOImqb2khua9nY4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkB9Ku+0pr13dRVlUtFt3Apb/2DhkDDEcP0RgL jYNeyWluyGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAfSgAKCRCJcvTf3G3A Jp0SD/9g6Tj9uJv43ZjKk1rY+13SV7PIdShwt69nFU7TwR+0rkGMp/q7ADBthak2+929V323CbR ZeX0glEgrBW7qbUN3tqaI6TWuQv5ApUUWfTKumtxLlApdtBd/U92YqNbRLNKP/FDUrVE/D8FXYZ N0DOGEwNkpUS6FJOlkb86YfXgF0Y/rEJnKFhgP2kjsA+5bdPy9vq7RwA53hsaQLrsXIX16vMmeI sr5Uxx7rJgbRAsxnTTHSvOCo/XnswcvwpJCprD9VSsAnXprHJx9Im4I5Uqv+0jEEVAGhplXt0NB jp+ZDvv4V6uM0c4ODXlRLPRBg4ME2XWzYToFUJDMRmXhncspc6XenkKTalCh1HTuC/25Hlb9ywT p4IFyUNsWWIZu6pWQvn5ZfiLXud1Sf0eONYWPmUy//3mkDa3tQnUk/XLE3SiWOY7G2e5bdujpXF YM8r0KTvdvq9Q/aLgtxy/o+GMComizdA191zQY7nh7Gyu9bGwW3ulIm9LlUCqTWvm2C+J9x/5vZ iIOn3HKH69W2Z6srHUlPJy5N9r6G50J/pZfg+kIp5yA/CP0dDwbxfsFY5NUWcLXYUOBcpcn4ncW S5XqMba21LgtouG+muyNf4YOU5Rbf5VbsyczKtBukK2qk+OsIJdeZcFxWrC9UtNKvJsyt+cX1x6 fa5IG2fejI0Bq
 hw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element arrays in
struct ipr_hostrcb_fabric_desc and struct ipr_hostrcb64_fabric_desc
with modern flexible arrays.

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ipr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index c77d6ca1a210..b2b643c6dbbe 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1030,7 +1030,7 @@ struct ipr_hostrcb_fabric_desc {
 #define IPR_PATH_FAILED			0x03
 
 	__be16 num_entries;
-	struct ipr_hostrcb_config_element elem[1];
+	struct ipr_hostrcb_config_element elem[];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb64_fabric_desc {
@@ -1044,7 +1044,7 @@ struct ipr_hostrcb64_fabric_desc {
 	u8 res_path[8];
 	u8 reserved3[6];
 	__be16 num_entries;
-	struct ipr_hostrcb64_config_element elem[1];
+	struct ipr_hostrcb64_config_element elem[];
 }__attribute__((packed, aligned (8)));
 
 #define for_each_hrrq(hrrq, ioa_cfg) \
-- 
2.34.1

