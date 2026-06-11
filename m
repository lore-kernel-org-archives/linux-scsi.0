Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D297831691A;
	Thu, 11 Jun 2026 02:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781145847; cv=none; b=ILSsQFhKy4ssTC5flAprvVUtfpzOq3tR0pQxmnF26HHk9pKKO8t6+noU8dbfryhhUHbDoEQazI/z3/Ps7hRP2ck3D/OxUsz18QwssdBMohsDXl9mlLlFDiTnoRYaw/vgSSInAeuSSgpAZkeWsY9pqro+bjWb4rMqadiyOvrHSLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781145847; c=relaxed/simple;
	bh=SXKTUGDwfhKpzvjsjmZlcpY4CospzsLshHJ2Jl+KeMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHeere2pGLra9MLgCHntQQeAXnJWSKk/jTM/LTgQOXWU8U0lNQruFFsv6sQkAuopZzLeIiuvUS2Ym5fSJ8HZ2ZvX7F/VMG0nTmDVhs93kPApSxjBIjt6aiZh5rKp7uWUD4XWV+eSyKAGksZqkUSBRt04YwYQIkAbkTZJWD3LzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=SQdlEbrb; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="SQdlEbrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1781145841;
	bh=SXKTUGDwfhKpzvjsjmZlcpY4CospzsLshHJ2Jl+KeMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQdlEbrbjpr2XItH74BgLUgLX+NSOyKCgeUc5j4IWMtT0wVewO12hh4B1uCD2Lhz5
	 6wzNRpxtmD280uF9GUKZStluCy/ND1hmDa7Qx9SG2WizPx25Hd+op6Ajjt1GUjpS5O
	 cXHPBBOK7ZMudZNeHs5LV2XjyGssOTrG6fkT1eI0=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id A472BBE51C;
	Thu, 11 Jun 2026 02:44:01 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 6AD8E5FC0E;
	Thu, 11 Jun 2026 03:44:01 +0100 (BST)
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
Subject: [PATCH v7 6/6] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
Date: Thu, 11 Jun 2026 03:43:56 +0100
Message-ID: <20260611024356.2769320-7-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611024356.2769320-1-philpem@philpem.me.uk>
References: <20260611024356.2769320-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Compaq PD-1 (and equivalent Panasonic LF-1195C) is a combination
PD/CD-ROM drive that exposes two LUNs: LUN 0 is the CD-ROM and LUN 1
is the PD (Phase-change rewritable) drive.

Add a scsi_devinfo entry with BLIST_FORCELUN to enable multi-LUN
scanning, BLIST_SINGLELUN to prevent issuing LUN-aware commands
simultaneously, and BLIST_NO_LUN_1F to suppress spurious "No Device"
entries for unpopulated LUNs (which respond with PQ=0/PDT=0x1f).

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

