Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5FD39F164;
	Mon, 20 Apr 2026 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776687822; cv=none; b=R6gD972ArSCko02WY6Yt9rHzTTtzCvBHbB6M4dMr+2w9GHGLfulaJx3wYGBSulM4mz7sgMMYak40qJydVKSaaO4WWhh7evMY79wHXvbFPV6ZKAAAeFwfsPshgipFCOpKiq3tPQYDxN44WjA5V924OdEE2HA8xrO0y/Vu+ENrYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776687822; c=relaxed/simple;
	bh=zRabrlMAt8mmwgKPv2viGfu9sJPKsnu7kmQGmU+O7u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDZMndVsjTKEkxxIbCN0DwpKOfhGYWDUoRyl16Uo6tJSqpMgX5U1F40buaU/yWG8xve1WkcbcGgGUZKFWuWLUJaCHcNIPl4i/GSfQrJU/WEmCyW2eK81a20Z03X6mjt44w1GWavAhD8G+6J2G75vPH+5pd6I2KzXlHqdgKhFpNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=hSPonNTc; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="hSPonNTc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776687809;
	bh=zRabrlMAt8mmwgKPv2viGfu9sJPKsnu7kmQGmU+O7u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSPonNTccTzUaQqPzRj8xdtZYj1Uk3qLzAJdWsR952oSPgB22H2cKVeolSTXFySWJ
	 VfNATVZt7hBnCtZ4QpofE2sMZWklPQLZExUotcs2Ba4KaYhkrmvAsPoum/VyD8X3oU
	 CwQRoK9ocxC9MkP7zACOUI5ItBIkJjgy1Q5RxYBM=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 6A10BBEFEB;
	Mon, 20 Apr 2026 12:23:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id CE25C5FC5B;
	Mon, 20 Apr 2026 13:23:28 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v2 5/5] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
Date: Mon, 20 Apr 2026 13:23:21 +0100
Message-ID: <20260420122321.4161027-6-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420122321.4161027-1-philpem@philpem.me.uk>
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
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

The INQUIRY strings as reported by the device are:
  Vendor:  "COMPAQ  " (T10 format, space-padded)
  Product: "PD-1"

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
2.43.0

