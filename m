Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C116E613;
	Wed, 26 Jun 2024 18:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424918; cv=none; b=FQdZirkLlbE7d5VS5epRB5dYncaSb8kxuDWE0XWDVwOa4Bg5bjACqvcqJecPMfb6U0y7M/1huxiN7maSzFcNvWTBfp8GAMWvZ243/HA1Pk37qgXmcFQy5q2vyO/xp3tCHlGQJ+GDZFS+IciVryYs4b//WXymsIpeNEyW3tBbDKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424918; c=relaxed/simple;
	bh=k1HCGiw/R6mXVVFM15Im522WtWq7BVtq4BOm1kkTSZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGsM9KpjVUlhQPhTblu4ZAaObLMAqA7tCCe/W65abm8m2gPErPawzHBfpOPhOC75hMmaG86+VERAl5mxcbT4Ht/sv4sbrs7LvIR/L9Rmg1ZHBrO87oxxHDnXH3W9CSvGlpYl7+uBP9mcW7+rZYZaApXxJRHN3hBv0I9y87QqVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RImxqgAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RImxqgAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB1FC116B1;
	Wed, 26 Jun 2024 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424917;
	bh=k1HCGiw/R6mXVVFM15Im522WtWq7BVtq4BOm1kkTSZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RImxqgAeGHtd7mv5WYPVKRRT8T5wrMrcOgLCtW40o2gJx1odJiVVVX9zoWepHA3uP
	 lsOM1PwAx7Rb5G98udfe1snfQcLej954kTTs+JBF8Z0XY6s8eNHig2QK+jY60uatMc
	 oAMlEdz9k9tZq6nf/oueWG9HnoOGmBzuRO/EU0AWlg1FSglcLD+OMJgcyJkUkSnFyC
	 kLRVUUDk5cIPfMkpJ03ZnaY1mhXgkRZZAHGIguwdFTLcfg8v7MNJJzDMq8rNawrEXD
	 0YjqLP6lHbLED4HcdWqYLxbd658UrpEdERzXpFLJ81yzZro2++GDVLHYOs+Hbf/K73
	 G1bXQE+TQB/dA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port print_ids
Date: Wed, 26 Jun 2024 20:00:41 +0200
Message-ID: <20240626180031.4050226-26-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1709; i=cassel@kernel.org; h=from:subject; bh=k1HCGiw/R6mXVVFM15Im522WtWq7BVtq4BOm1kkTSZ4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwp33qR/NcHma7Gj/9+8vM9U31xPEl1qW6YX96/7ls zg26LRBRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACZycBrDX7kbMkky7nFBIae5 E16t3v+HKX3+/EkrRVYfenvm4rmJG3MY/sc96Nk5Z5/FZc+7J+PbV87oXrbjy+2Xk7+3KIpMeT9 vyyYGAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Currently, the ata_port print_ids are increased indefinitely, even when
there are lower ids available.

E.g. on first boot you will have ata1-ata6 assigned.
After a rmmod + modprobe, you will instead have ata7-ata12 assigned.

Move to use the ida_alloc() API, such that print_ids will get reused.
This means that even after a rmmod + modprobe, the ports will be assigned
print_ids ata1-ata6.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 52c1f0915aef..846ab99e0cd3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -86,7 +86,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-atomic_t ata_print_id = ATOMIC_INIT(0);
+static DEFINE_IDA(ata_ida);
 
 #ifdef CONFIG_ATA_FORCE
 struct ata_force_param {
@@ -5463,7 +5463,11 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
-	ap->print_id = atomic_inc_return(&ata_print_id);
+	ap->print_id = ida_alloc_min(&ata_ida, 1, GFP_KERNEL);
+	if (ap->print_id < 0) {
+		kfree(ap);
+		return NULL;
+	}
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5497,6 +5501,7 @@ void ata_port_free(struct ata_port *ap)
 	kfree(ap->pmp_link);
 	kfree(ap->slave_link);
 	kfree(ap->ncq_sense_buf);
+	ida_free(&ata_ida, ap->print_id);
 	kfree(ap);
 }
 EXPORT_SYMBOL_GPL(ata_port_free);
-- 
2.45.2

