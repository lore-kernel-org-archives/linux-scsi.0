Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C514F30D7;
	Fri,  9 Oct 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563234; cv=none; b=K+lqNsxrxggg5dJD0YXPaUVgimSg9BTcyQ7Uv7jBBqh0P4HVUn6s2xq1ineQMiIpUoFIFat/WkJ0C7MRoz5qAQGbZL37sRII4WsJEitzdDTuTBbFgyLJjjDLmuNEOefYitenEqPzEDbhikVAskxbQDRI7az2G35b9kB46VFQmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563234; c=relaxed/simple;
	bh=7oTcspw+Wal0IAOa7y/6zQYzzZWBNH+9Jefo+99ZC7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRLMeZoDTRgPNpWRj/BBglUxwazhPy1+NmW4Ijb895s1k3ozWGXPz3i7ROP/z/4QXa2zcjpjkHVfhE7UqIYKtDz2hdWuHrn+Nx18EFXvNU4cK9KdUF0yORLC5rx18Cr6OekojZViowGPjxIK0o0MPm2QNcL2UkN3IiKE2i3Bv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=pHmJvT9Q; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="pHmJvT9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=7oTcspw+Wal0IAOa7y/6zQYzzZWBNH+9Jefo+99ZC7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHmJvT9QKcEZ7UCSTlQ1+P7ePfnVBZvHzX+q5HAwXxPQ6A2JgosgU5IP2BHiXfK1R
	 CErwEv4JLVzCEOPn1mjSeMaWURGNacEQMzeLSfRTqUaRlfJlgGdsFPDHaxpAjIsN6z
	 lZMoe0BBECK0hBXwmiVtnHkeTpvzHK2NecG1g08E=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 6DE71BE776;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 32E615FC53;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
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
Subject: [PATCH v10 08/15] scsi: sr: keep queue block sizes in sync with the medium
Date: Fri,  9 Oct 2026 16:55:15 +0100
Message-ID: <20261009155522.593045-9-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
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

After initial revalidation, set the queue's block sizes to
sdev->sector_size if the logical size differs. Do this before registering
the disk, and unwind the probe if the update fails. Revalidate first so
ready media can supply the actual block size instead of the 2048-byte
guess.

Also set the physical block size and minimum I/O size when revalidating
media. The block layer raises these to the logical block size, but does
not lower them when a later medium has smaller sectors. Updating only
the logical size can therefore leave stale 2048-byte physical and minimum
I/O sizes after inserting 512-byte media or switching between media types.

sr does not discover separate physical or minimum I/O sizes, so keep both
in sync with the medium's reported sector size.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/sr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c36c54ecd354..28523b0eb659 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -488,6 +488,8 @@ static int sr_revalidate_disk(struct scsi_cd *cd)
 
 	lim = queue_limits_start_update(q);
 	lim.logical_block_size = sector_size;
+	lim.physical_block_size = sector_size;
+	lim.io_min = sector_size;
 	lim.features |= BLK_FEAT_ROTATIONAL;
 	return queue_limits_commit_update_frozen(q, &lim);
 }
@@ -619,6 +621,7 @@ static void sr_release(struct cdrom_device_info *cdi)
 static int sr_probe(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct queue_limits lim;
 	struct gendisk *disk;
 	struct scsi_cd *cd;
 	int minor, error;
@@ -701,6 +704,18 @@ static int sr_probe(struct scsi_device *sdev)
 	if (error)
 		goto unregister_cdrom;
 
+	/* If no medium was ready, match the queue to the driver's guess. */
+	if (queue_logical_block_size(sdev->request_queue) != sdev->sector_size) {
+		lim = queue_limits_start_update(sdev->request_queue);
+		lim.logical_block_size = sdev->sector_size;
+		lim.physical_block_size = sdev->sector_size;
+		lim.io_min = sdev->sector_size;
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

