Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0F3703B4;
	Mon,  5 May 2025 23:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487150; cv=none; b=RS36UuUI1goNu2o9CXNGDkYJpfH0n5MhWWgVtEBfiiMINnmpBJF2S4XG7+FPo8bIwP9f2YvcN06LBYlIpYjYjNvLTjuF/O9BT6MUBbaV84/Q7JZ3lC6zvapXS7wKm0is3UqgJ2KJgOnxZgTdaizt39ut2KNCNkJSg3ns/fyCMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487150; c=relaxed/simple;
	bh=/avoP22PU4xSvFhBFBW2Gg0Cvmyfo5jS4j8ShxCHt9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddJtl9RFVx5u9tIgB/B4tEbFPtJbtzPxArBSEpSvxZMNRGxWc+SbBd6qbsrPHm7V7w9cVxuuu4t5anV0K0pw+Ld4lCpOkwJaaGTByMUuzKaXaU3nHjObzfBFs3cy2+zKCYxiU6jryOKqnmgHA002kZM0VM0n9UieJfOZf20RzVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQaLN8RU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQaLN8RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5ABC4CEED;
	Mon,  5 May 2025 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487149;
	bh=/avoP22PU4xSvFhBFBW2Gg0Cvmyfo5jS4j8ShxCHt9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQaLN8RU0jTh2j+pARbZLYvSWeYPzN4Qs1YwGxBXblV3lUTAxR6OI0aYMVRgMG95j
	 LbyW1miZU692EWUooR97/zVl86whoiYKhW8czp26Avq3B9EW9sed5lYOAVZYpniglG
	 oXfsyrEGhg9UIIVmo6J/14MKATv7NyqJzMh7wDXAHw/7ypki2RtzMYo0NJmPBcmJoZ
	 amljlHs2UZTiFHqwL7xQKkQVz8Bsxh8jr01HiZcd5n5oIhiKc06JimN7FusUhl8+om
	 Vt2/XoBXn2d8T3S4o62EDwucz7aQwv2rULa1bINyGnwjYJBHyfTHATnzbxJHf72v1u
	 IUav+FZG+Qgxw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 026/114] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 19:16:49 -0400
Message-Id: <20250505231817.2697367-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231817.2697367-1-sashal@kernel.org>
References: <20250505231817.2697367-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.237
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
index 47e59b74c09d2..747e69abfcfce 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2889,7 +2889,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

