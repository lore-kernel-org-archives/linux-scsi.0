Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216A19472;
	Mon,  4 Mar 2024 09:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543465; cv=none; b=IxWPWBBGYJv/YpH7TRhPqxsfEolgYB14f0lYXlnF7QU8+R3rQ2C3Pjzvk8r4Z5vP47bc0nVWt1Xg5ucyFmMGbl/Xj99fwaet+rhbVLRqVTAebE5AUCYP6jh5ZsMka3aMGyo2nYSYiWykDdV/wMxNyPiLE7oYD8eSTioon5uUGyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543465; c=relaxed/simple;
	bh=CVm0itqbknJclQDsY4Frf9OoAkYPPa/1GZRo1JGqk0M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FdxqIAI+JTPMe72VE7cjnBeV74+jAICEoA5gS2Uql1xw4Jsy5otUQAtE1kfJ5CNp7s6q794BYW5XaHBQ8gDF53HAEjr1Svl0e6xMHekrQDOPuGo5q5yz2YeFQ17NWaG3cgBicCIwIdcpBtbFnoBTLZup8zIZ11NJnTeZGCz4Mw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=MoQtuYqx; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="MoQtuYqx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1709543461;
	bh=CVm0itqbknJclQDsY4Frf9OoAkYPPa/1GZRo1JGqk0M=;
	h=From:To:Cc:Subject:Date:From;
	b=MoQtuYqxH59MYYoqJHYWXgE/CvSNkS4FDInxOYwx+mBhrrD6EgejdXCyXE9MrjrDc
	 JdM39yfc+uT7tRfH7HbyGWnZzyafiz0GiKY/DXxXIY6i8A66/aIYv0SdnLxGWOHMkm
	 ScjWEkYMttvzFGh6aEzmCCGOMq31NUtCyDf1yb31FEArCD6dkMM9eNf0QLqxh83vrI
	 8Ui56w0i4qR/Wyd3GXS2TFEeaZ70jlH8tuVXkVqg5Gu/15cXZiCCFgSOzDWkLfrEmh
	 nPAFMC2dj0ptermIeZBQFZ7dRJAieLIHyIoXCDebuPBkF88nytOK/Kb1Vufxx0O840
	 DCdQioVds9PdQ==
Received: from localhost.localdomain (broslavsky.collaboradmins.com [68.183.210.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 580A73781FE9;
	Mon,  4 Mar 2024 09:10:58 +0000 (UTC)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	kernel-janitors@vger.kernel.org,
	James Smart <jsmart2021@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: lpfc: correct size for cmdwqe/rspwqe for memset
Date: Mon,  4 Mar 2024 14:11:19 +0500
Message-Id: <20240304091119.847060-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cmdwqe and rspwqe are of type lpfc_wqe128. They should be memset
with the same type.

Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v1:
- Use *ptr instead of specifying type in sizeof
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d80e6e81053b0..7d5275d3a7406 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3169,10 +3169,10 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 	}
 
 	cmdwqe = &cmdiocbq->wqe;
-	memset(cmdwqe, 0, sizeof(union lpfc_wqe));
+	memset(cmdwqe, 0, sizeof(*cmdwqe));
 	if (phba->sli_rev < LPFC_SLI_REV4) {
 		rspwqe = &rspiocbq->wqe;
-		memset(rspwqe, 0, sizeof(union lpfc_wqe));
+		memset(rspwqe, 0, sizeof(*rspwqe));
 	}
 
 	INIT_LIST_HEAD(&head);
-- 
2.39.2

