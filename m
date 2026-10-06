Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757EA4F799A;
	Tue,  6 Oct 2026 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330132; cv=none; b=muVCcooW0P5ZFKQVLR90VHowydi4JwgMjGO/us93hVVeVGi9m9vZ4K5rEgTeD0T/4PQ05tZbTUJSJUzbJdHPkuWnnRM6iiP9ENDzOvukBLzyQF6TNp6R9tjVxlNHeho0N2kIygxQG0q62jggFc3q5tYdORTOqWo8gkz63l5Ioh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330132; c=relaxed/simple;
	bh=HCBBSfZayrZxVxkx+wpLEKcAGN2g5IH75BgNsWG7vgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBb5uQk68DWOgy+E2xFYpTItxf3Lt4VKJgsVhCs7v39Ook0jo766RRmc3gXCLUOCtLn8xHslrICJXgseCKuCZLg1Paurdato9iDBke+h63YkCI8cplLDJnGoDrtKFYpgG3GRG28PmCjgHR9+bq+K14Zd+k2shVrJurMgNm4mnBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=S2lSBg2T; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="S2lSBg2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=HCBBSfZayrZxVxkx+wpLEKcAGN2g5IH75BgNsWG7vgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2lSBg2TwR2L1P4qFga/GF3x6s+TmcdW7xrHLeIb5hbuujg1t+musOnyrk6kHtwxT
	 nDfzRb0CXyAUltCDwkWTdkWjNPfiW3zbOMd23xAIBQjiwCsTTWSXgyv5+i8oO7hKAm
	 /VSclffQcWqmt/fL/YPwohiQ0re8muIMsJWPkw1Q=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 8D467BE532;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 3E6615FC53;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v9 04/11] scsi: sr: initialize logical block size before registering the disk
Date: Wed,  7 Oct 2026 00:41:54 +0100
Message-ID: <20261006234202.1139018-5-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sr_probe() sets sdev->sector_size to 2048, but the request queue keeps its
512-byte default until revalidation finds ready media. Booting a COMPAQ
PD-1 LF-1195C with a PD inserted leaves the empty CD LUN with mismatched
block sizes. Later CD reads can fail with "unaligned transfer".

After initial revalidation, set the queue's logical block size to
sdev->sector_size if they differ. Do this before registering the disk,
and unwind the probe if the update fails.

Revalidation must run first so ready media can supply the actual block
size. Applying the 2048-byte default earlier would raise the physical
block size and minimum I/O size, which stay raised if revalidation later
finds 512-byte sectors.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/sr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c36c54ecd354..268f15a4fdb8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -619,6 +619,7 @@ static void sr_release(struct cdrom_device_info *cdi)
 static int sr_probe(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct queue_limits lim;
 	struct gendisk *disk;
 	struct scsi_cd *cd;
 	int minor, error;
@@ -701,6 +702,16 @@ static int sr_probe(struct scsi_device *sdev)
 	if (error)
 		goto unregister_cdrom;
 
+	/* If no medium was ready, match the queue to the driver's guess. */
+	if (queue_logical_block_size(sdev->request_queue) != sdev->sector_size) {
+		lim = queue_limits_start_update(sdev->request_queue);
+		lim.logical_block_size = sdev->sector_size;
+		error = queue_limits_commit_update_frozen(sdev->request_queue,
+							  &lim);
+		if (error)
+			goto unregister_cdrom;
+	}
+
 	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
 	if (error)
 		goto unregister_cdrom;
-- 
2.43.0

