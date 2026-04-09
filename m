Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409352FA0C6;
	Thu,  9 Apr 2026 21:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768771; cv=none; b=I9qMl66tLw/VPR17kC/EWUAunoXRy7/ZKbIzoyIOIEvOlXJXcvtHeU0RhpBt94VAbcIJ/DTBWC46tW2zAUWbCAsaPgm+lCCEDHlxVD1L9aKzeOGOZkRJLQ0r+rR/AAjpIJPu8dz/d7TjuTO1REXxaYYGItytLfOjj7qao6nXh0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768771; c=relaxed/simple;
	bh=dMHae3B3WHNdkgQmBXXItgY26TRoUjtY/leLghC1CEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf9P5zYYYmWFFFkUlj5tEPLSV4n8qUzpe7rvAJKWfvIb1dPuVcZoypWX7RFLg4pqxoVbc8GAolLSSuHAoqlcqfcu5eNWjL3fypuzymap0M3hBIyTOrS9YNl8Wbr7gXS8Q24GWaQvefH4m4JrB+fcuxv64xy27bNpxEueb0YFGFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=FBQ+ztlR; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="FBQ+ztlR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1775768768;
	bh=dMHae3B3WHNdkgQmBXXItgY26TRoUjtY/leLghC1CEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBQ+ztlRg//tc1fWRO/CQDAEzRmF6n0+wv8jOlXphICUB4CGL7JyadlC46+Ptrak4
	 8fPSVl461R4jv8WCQngEJW8DYA/05msuFr2tzAlVcNBMbcd4YFgZbLWHXAgORw/YoQ
	 W6shLnzAOO7M2a7sRIejIBoskPPwYLz/PrSXHNSk=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id C73F5BE5E4;
	Thu,  9 Apr 2026 21:06:08 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 4D9495FC3F;
	Thu,  9 Apr 2026 22:06:08 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: dlemoal@kernel.org,
	cassel@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH 1/3] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
Date: Thu,  9 Apr 2026 22:05:57 +0100
Message-ID: <20260409210559.155864-2-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409210559.155864-1-philpem@philpem.me.uk>
References: <20260409210559.155864-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Compaq-branded variant of the Panasonic/Matsushita LF-1195C PD/CD
combo drive is a multi-LUN ATAPI device that exposes the CD-ROM on
LUN 0 and a PD optical drive on LUN 1.

An entry already exists for the "MATSHITA PD-1" variant with OEM
firmware.

Add the Compaq-branded variant with the same BLIST_FORCELUN |
BLIST_SINGLELUN flags so that additional LUNs are scanned and commands
are serialised, matching the existing entries.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 68a992494b12..06b211b93567 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -150,6 +150,7 @@ static struct {
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
+	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
 	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-- 
2.39.5

