Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D977731E85C;
	Mon,  8 Jun 2026 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954501; cv=none; b=FwnGDIUs1CFJDv36GIlob1XXKQND0vcU7bdVdcHv25dwS5NUjrN9Ll7pxeoiaaA+6xgJCWqItV6UENWVJzryZ9aL+/9mStB0C1KrrtSrHXlsGIET4roe4uq0JlGA9HRpR3WzUrzfV291k0bg7KqNomtkKW6SGdDisdVxFPYOZFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954501; c=relaxed/simple;
	bh=NgI+BloTluXJ7eZWq4tfe6pWs03z++jaiAMs+De/a1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4+GloB8ZqhVm83m+ZKw1+9roacXBoE/7wFU1zGhjVOznvbK1fFdr5rv0q3AJrUj/hoTjTKWCyUQr74sOi5oa8jNCeG6RYX6eWc+hE1ppbn5ZTu/vNmLVb0xUZ3OKvWTgavquthjE1Z0orbyDiAtYIoloOgkq/mFJ0nT9XHwSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ablupl2Y; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ablupl2Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1780954491;
	bh=NgI+BloTluXJ7eZWq4tfe6pWs03z++jaiAMs+De/a1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ablupl2YeRod29tWxeh0JJwSI+GG9HxBf+sKqgKP65Gs4h3oxT6vMiJS1f2HzGThZ
	 9G/PVc+9bHEBzJYZjgwocPGU/054DzFaQWz6THlp8GvA/9toK6QLWhPzfaO72fnZkE
	 NvwHZTONZ5qpmbZmdLaVqPbmx4CCfVGhLQrU3JIM=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 86F0DBECDE;
	Mon,  8 Jun 2026 21:34:51 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 2AB245FC53;
	Mon,  8 Jun 2026 22:34:51 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v6 6/6] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
Date: Mon,  8 Jun 2026 22:34:43 +0100
Message-ID: <20260608213443.2296614-7-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260608213443.2296614-1-philpem@philpem.me.uk>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The COMPAQ PD-1 (OEM Panasonic/Matsushita LF-1195C) is a PD/CD combo
drive that exposes two ATAPI LUNs: LUN 0 is a CD-ROM (TYPE_ROM),
LUN 1 is a 650 MB PD (TYPE_DISK).

Add it to the SCSI device list with:
  - BLIST_FORCELUN: tells the SCSI layer to scan past LUN 0
  - BLIST_SINGLELUN: serialises commands across the two LUNs, since
    the drive has a single transport and cannot handle concurrent
    operations on both
  - BLIST_NO_LUN_1F: the drive returns PQ=0/PDT=0x1f for unpopulated
    LUNs instead of PQ=3; this flag tells scsi_probe_and_add_lun()
    to silently skip them

The INQUIRY strings as reported by the device are:
  Vendor:  "COMPAQ  " (T10 format, space-padded)
  Product: "PD-1"

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_devinfo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 68a992494b12..bfc2cbd43897 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -150,6 +150,8 @@ static struct {
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
+	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
+				 BLIST_NO_LUN_1F},
 	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
 	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-- 
2.43.0

