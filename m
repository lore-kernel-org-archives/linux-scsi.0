Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5EB39182C;
	Sat,  5 Sep 2026 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578608; cv=none; b=FJj7AWzdhmjAc2LCcApUIOj4hsl5F9j8vFC11tgANJ7/or15/Qu0h/NXJRHLltbVqysri9T0V7kl4WlA3LPGSPrqPRIBe9s1BmpUDMuTRVWuPUU9mXTb08Wm6E8CZIoBI0YeM0+vZO7q2rhK2nq/xPSKmBYxAHXzvCx3AaK+8XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578608; c=relaxed/simple;
	bh=2OWP+VZyPtc4rBPqMMAVlnqOxhhJ6iLUTwO35GY2Ecg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Twhc2PMNwuFCbjNFR2+B1aW7zfhEGLuN2ya9a8z4NKAziZiOMCKjMr628HMR9BgUuyWLIxXkNyroxRHYgkDyjWnKYUAgjch/LlXeC9DDA2+APxlJwUXV32CNciLn0JP9BjsyQUxvWnmGi3iAPHzstbCFPZDt5fpuxXd4udxiTl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzuzDxLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzuzDxLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABAC1F00A3F;
	Sat,  5 Sep 2026 03:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578607;
	bh=4oZ/sMUzEYF+BJqyR9A58M8g1jra8zNiJWPXbfVMsT4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=EzuzDxLYj3nVBmOZ5273LlRzRKKPgJ4/wylJXK1VpjOb6/6E4TpLitxmvChB6MOZL
	 QESGYHqV/tdu9rYlUltBbhu6aXh4V1BXLucVER4c8ZADMWjakzQZQEBnfzLDabKOxC
	 4sGGUR7w6+f6QkFPCshBJmo0pbgPOSGeOUCrOeIdmVrb1m4ATdU9pIuSHxdzziOwqP
	 YfayP94KhgajwLqkgTjY8WyM66TuLtMBBlIlhMR5XV0Lw4IaDeqKxwOfVll+SXFq3Q
	 3UP63+72N6kE0fq2ifzPovUYvQACiflrzeCWLZttjD+cRMMltsZQAL1+CNvT/Lx+bc
	 qSLyVxVA2VqRg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v4 28/40] scsi: mvumi: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:12 +0900
Message-ID: <20260905032224.509860-29-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e9e2c25cde68..91c2db697c69 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2067,7 +2067,7 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 	return 0;
 
 error:
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	return -1;
 }
 
-- 
2.55.0

