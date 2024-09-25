Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38281CC407;
	Wed, 25 Sep 2024 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266087; cv=none; b=g2uGt4MvfCvNPPc79QoJnJL/Jwi9MkRUpnCKCcNYSlk9I7fiJJSK6+qhWCFocvB42ldDZ0Wff6RhPeMt1oIMeHKXML4Oi98fToftgCJ3XipDI5/+O0Irl3N6wdmbD7JSkCZhfERXk4se00xq0nu4v3El3lQCffH4iWb5qRYCKr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266087; c=relaxed/simple;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUX+rVnTEUMdFE9+GzPfhFoM+MDR4VxV3iqrvJ3/I7TQb5qR+cx8NfJsdcWdYwswvm2POjTk6TjIgiFej1DH6ro4KaB7Gqt0HcyoLMl1g0DcRbv43BdGjmzUKppUBh9AGxy3120Fj0Egy24OsWP2UAfWUHfiCwRhZ/9jcRt8I/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6azMLUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6azMLUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99644C4CEC3;
	Wed, 25 Sep 2024 12:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266087;
	bh=uwvlE86YHQU/hfeMbPJqPOnWFDozBb2zVNDOcuYEcH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6azMLUC7B4AQ/fg8BvnuYsTXPvbv4Cd5Me47OIsCUTAQd4pYmhTf53lv5kUdmvJ7
	 ERiYCNW1Gmwa7A9GeB5ROzQvlzrwZ1quuTXgP6/7lQr3536lUcSwWABKDNhpxQ7Ioo
	 XjL4NP4tgt3QX/7z8YlYOuOSVrTCEkjI9xl2HqZpnbz6jz0IVPfhlZBtQxF/IZieYO
	 ERZmftNwpWdx9DxY0Zkfm8hXYxiOeDiQ7veQNYXIB3GsF8AMXx+LmMHy/AwTKzpAlk
	 kNZ8w+Nj3plNMP3iez9Mnods2KEIaaw+OHFh9bykFX6SvxQ2bQASTYQCxnZEeTS2l9
	 HRzmfmM8iOAaA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	schmitzmic@gmail.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 168/197] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
Date: Wed, 25 Sep 2024 07:53:07 -0400
Message-ID: <20240925115823.1303019-168-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
Content-Transfer-Encoding: 8bit

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 1c71065df2df693d208dd32758171c1dece66341 ]

Following an incomplete transfer in MSG IN phase, the driver would not
notice the problem and would make use of invalid data. Initialize 'tmp'
appropriately and bail out if no message was received. For STATUS phase,
preserve the existing status code unless a new value was transferred.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/52e02a8812ae1a2d810d7f9f7fd800c3ccc320c4.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e4..a99221ead3e00 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1807,8 +1807,11 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				return;
 			case PHASE_MSGIN:
 				len = 1;
+				tmp = 0xff;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
+				if (tmp == 0xff)
+					break;
 				ncmd->message = tmp;
 
 				switch (tmp) {
@@ -1996,6 +1999,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				break;
 			case PHASE_STATIN:
 				len = 1;
+				tmp = ncmd->status;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				ncmd->status = tmp;
-- 
2.43.0

