Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC64276D37
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 03:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740712686; cv=none; b=MIYraLchESWN2mFgxnAu8ZnycCD+osxhVxNgNzd42V2BUYNzUY5LYOmTJzCtQsQ/9k4umMJEIQLqTe0kGbjqgV2YMi6JNU1VKvPjbYMTZLYenXwRYW69RXYTCwGzvXRT+ynXYg5j23Ey5inLbtTo87N031ssd7hdx+scnnevfNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740712686; c=relaxed/simple;
	bh=OBBLoATyfSjOR8ri2azzo409IJpJ3N7b8PxggaLpn8M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HdW1QIyxiBiGrSX6/7obB/gYyvd2XVPqOcL+apgO5KR7t7u909ICOj8+/czR67ta7qzwbLxeSstOMG41uAF24HOttPOukco4K8pR+qe2OX4cS1IZAkKM9RWzQcrMnzhgcMJz1uH4E/p9rVC7I1MokqGzVVx6aeMRE5wZfbdmLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loV/E534; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loV/E534"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934B0C4CEDD;
	Fri, 28 Feb 2025 03:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740712686;
	bh=OBBLoATyfSjOR8ri2azzo409IJpJ3N7b8PxggaLpn8M=;
	h=From:To:Subject:Date:From;
	b=loV/E5346ckqSNo5rqfmex80d3YdZjx9F8PNftceIzQRPf1J5OL2UV/FdHG8lov7H
	 znckRqeDEbiKxlIKGxxEQkWQsU85Q5sN9vVXmz7g6wWdAvo+cbLc6wUgMSmJ5SMWIn
	 6VstKUJJShsyqSx3v8ZUIcaNct/9Lax07HzTfqN8EG23nYbzBT1aEbJGM8i32BOljr
	 CIbwKZJRFgFJlW/16R9ZdKx/dXKHBfGUBIjL4TxqjYNKj/R20lzcD90NaNJJhzw9sH
	 TerjnwsZGAG6VRedr+jKABRM8Goj8a5iny5WZy2MLjKNDdpfeI/3fYKMhCd6GJAPmv
	 wz/dC7oX3Euyg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_error: Add comments to scsi_check_sense()
Date: Fri, 28 Feb 2025 12:17:51 +0900
Message-ID: <20250228031751.12083-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a comment block describing the COMPLETED case with asc/ascq 0x55/0xa
to mention that it relates to command duration limits very special
policy 0xD command completion.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_error.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 815e7d63f3e2..d08ed65abfa6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -711,6 +711,13 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 	case COMPLETED:
+		/*
+		 * A command using command duration limits (CDL) with a
+		 * descriptor set with policy 0xD may be completed with success
+		 * and the sense data DATA CURRENTLY UNAVAILABLE, indicating
+		 * that the command was in fact aborted because it exceeded its
+		 * duration limit. Never retry these commands.
+		 */
 		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
 			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
 			req->cmd_flags |= REQ_FAILFAST_DEV;
-- 
2.48.1

