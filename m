Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BA13991BC;
	Mon,  5 May 2025 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486473; cv=none; b=EAaKoQzdE3iKxP0xqbXwetF9sgOXUyVs7ksiyEGWTsj9S0s02WO8O/SpIT8psldi2OIH33vG+8uxqp+8elO9BleVIbuvd39UqJdZt5Zaf01bHmCdePWIWWGklIXiJkpss1y/mIi7nKgcgU2ZedKRmOk3/uuWCiQMO6btChffpt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486473; c=relaxed/simple;
	bh=qwMJOQ5swyZ+SMObVdycJa5sk+yXTYnxZmLt9zQKnKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKRjAgKO1ZO0uoVj+r8zDQnpDZEkon29A+8/nhm+BLLZI3qjg83ZaRaPnYxMLKnzr8HOaOnJo/tG/l758Ishaf2OQrubSamMBBamdYQA7f/LZDfutxGsdFxsMean3BPls6L1H8SxUUKYlIhPW0ZImbXIanIax4aVfZbHBkkjHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsKsB1pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsKsB1pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A49C4CEEF;
	Mon,  5 May 2025 23:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486472;
	bh=qwMJOQ5swyZ+SMObVdycJa5sk+yXTYnxZmLt9zQKnKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsKsB1pvKhC0LzeIP5zGFbxbXXxNJ2w6sas6AJVWOxB46yT6A0IGsINUiRKuTLx5n
	 jUnqorJ/NePjt8z/oDn/Y7BzRCE8c+zRIrwxq8vCktG7lhRWQznNNy4DhT+FvsXerz
	 HAPArPqUFS7Oylvx9UawKLnRlOb4hlw9Y2/FQr4SdGq1vvFN0zBkfSzifU7N1kaGC4
	 68u0vZeljWXd83xPeLhnaAMSvbFHQO2jRbOEXj9IS0d3S8Ux+yoUgnCqR7rDz45Kl2
	 IFqFUMqnXXagrnqfzZpojDGFid3h+oB7HkdeNU1WNnSQ+oPk3Ea6Kvp/T4wqtZBsq8
	 GOxgHwAwN+TMw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 048/212] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 19:03:40 -0400
Message-Id: <20250505230624.2692522-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 284c2cf1ae662..3ff4e6d44db88 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2887,7 +2887,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

