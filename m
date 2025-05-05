Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE540299528;
	Mon,  5 May 2025 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484961; cv=none; b=b1UNPly+exYrmywptsxmpp3rH4iT9bk8fmF4ctMwUprHo3qrSZ+r+kAeii1Wf96r0MToQFw/h9zwtoyM5fU2EtZk3tshNI4kfnRJsJUTmWPHRLMPYYr8182qu6XogkeIpzO8lnBvGVAdRd76iu36rJpi0/fny7dU2+8CyNUZ4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484961; c=relaxed/simple;
	bh=fCjaWOd3pchlGIGKJjbR2+45db094DX44m5tNadvp1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pK/tKB1KdFdl6XUdjd4xAMm+QCT14B75azfgHlFkbm7y0BkjZk7d5lHVZ7G9lwkp3Z1+ptz7PDbmOBDYT8NQNedzgm36Iuf1rTjS0SqV7vH+xAAQppVU9b30/dUKOa8iaRPd56eidJTUZ4Bxj+k2GMrbq+rSJeq2eIaEp/AeGws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uaLi0REo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uaLi0REo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1091C4CEE4;
	Mon,  5 May 2025 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484960;
	bh=fCjaWOd3pchlGIGKJjbR2+45db094DX44m5tNadvp1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaLi0REocY1HEh51Tk3/7CeDOHScxkQf5flIh06rT7QpRVD8KXG8DFuscwWo5A7MA
	 6nqiOaqSrc6Mdu7rquuT0VZHj3xbMZ3x5uCEWCRtjQWeu/r4s2YXySRNOTge11BzwN
	 DYsmOjmVLyjzB+S3N1No8iIsCpl1Nebw33yCDj5vo3hdWH6kTuVw844tZXA4905suW
	 mQTKCq8Qt8MiyPV+vuCrx7+jI48YNZcbFZddez27+LpA6O4s6fwyeskvDZm8Yk2i5M
	 2ZlCgm6dYWXeTbMBZlQqwDN6Fm2XBF+QrZgGxuhB0tcYm3sBHGtW/SwZpq0xB4ae43
	 DRJlJm7gmkqjw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 097/486] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 18:32:53 -0400
Message-Id: <20250505223922.2682012-97-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index 1c0951168f646..1cfd7e71dcdde 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2894,7 +2894,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

