Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F521242EE0;
	Wed, 11 Dec 2024 18:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943098; cv=none; b=KLZe5YOUf7l85gGA3qc3E4QazxPKzauytb7GM21AgIQTgddncAM1Y19Vd2k4ijytE79w4VrKiL0Gf9POhNYcV7uVBwYxDGktpz/UK60vakE5wwt7rJhA3Kipn7Mo5caDZhOlPo7JeTtBApfqmF7g5D7dlk4VzownBE4+lAxK2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943098; c=relaxed/simple;
	bh=Gt84YUveXdEPxC2xpT/68Qqk4ysOf39wRKz/4+HEY3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruERUtpIQ5fvrNScJZM22xk9b3tEgyFJFu0O2D/xN3ShN4aSXtqVjTOQn/H9nTNC2vrZxE4m0P2GDNTz0FIi0Ys/oJKwAZPCdDwztPrW4JlY6dNPisCQF+aDd3TaRiRWKYIgUMLJ/zAm0ONnPdCs9sKUhqIieGFzMTzzcYYFUm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNDRrt0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNDRrt0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9189EC4CED4;
	Wed, 11 Dec 2024 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943098;
	bh=Gt84YUveXdEPxC2xpT/68Qqk4ysOf39wRKz/4+HEY3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNDRrt0PY0sDtlXW2PB2vyRnlb8eHlfaZkvMyGJnRmVQ4AA/dwIKWZbtNoO6BJGDb
	 SF3ZmRdjzGG01QEnwGIQgu2w1VN2mMgBzIozPcKAfow8WuCHpo0zFMCb7QZIqeC91G
	 hiQnqTGLhtVXRQd8xrZLbb785b7nwm12MYen0HrOkvro/SAh1/ck8gQnWBNQ75Lqb5
	 ZkkDhuRtX1Od0WoLtss92X3TAd5HsOqo+bubxImur4FVRvwVPt93IEAknQEnFSB5f+
	 0U1SzZBiP1kNAROxxTibXJydluX/H5FOopvqChMLOmZk770bId4EmA0vGEt9d0dt/X
	 PcKOXGS4xfHzg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 27/36] scsi: mpi3mr: Start controller indexing from 0
Date: Wed, 11 Dec 2024 13:49:43 -0500
Message-ID: <20241211185028.3841047-27-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 0d32014f1e3e7a7adf1583c45387f26b9bb3a49d ]

Instead of displaying the controller index starting from '1' make the
driver display the controller index starting from '0'.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f2f67acf8bf3..1bef88130d0c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5215,7 +5215,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	retval = ida_alloc_range(&mrioc_ida, 0, U8_MAX, GFP_KERNEL);
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
-- 
2.43.0

