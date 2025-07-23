Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1FAAD23
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260853; cv=none; b=A7pzTvbKqn7+eQ4XmezjAiQck6vROnZynUu5xqd4ZNMPKDUVfMlsvZBmWJq/U0k4J7rKYZGXuyty3hZvbaAdPpVFViZ/xYiZr+JgiSigOdJjxrReA0kgVbt+3dvTetk3m375Wl/vyWDPzW3e3CI7dR+Bm/AaqlV/EB7TXM3T/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260853; c=relaxed/simple;
	bh=b28l7UM8Uizb8ak2SglQQoNwT/PcpKiCkA0qdU6AFOk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXUPN7joVsoq0UZbnO6jcIymoBuprwwmsnWvJ8kh6VDaAyHl4e1reqAjLiPLy1iH4Ge922+VFF37cUh4f0Twyuv2JCQnwOCLPhxXnhZGENqOoVnjHmJ0508KY5GDLBRmKxi4yTx4FImKViL/jMqYEl8GgGoIktib0TbamzeGj5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6d7QSYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6d7QSYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38430C4CEF5;
	Wed, 23 Jul 2025 08:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753260852;
	bh=b28l7UM8Uizb8ak2SglQQoNwT/PcpKiCkA0qdU6AFOk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H6d7QSYs76DiDH6d0MyMtvmifuPMH/UwUUO0F/PDFesStCSgS9AyYyYQ1h9n73jOn
	 ajsHuPtvoY5yisByQzWTtQxbvfK2oPQ86+6+ceEVoRmte3H/Y9BcNasu8u+UNWryFV
	 HQ9YD7Vb9ZVE3S4l7B18J9CXjbTePnzJIJ5i4ADdJe4k5Hor6kljGKUSJ3XGpFJ/5I
	 o7FT1tMGIMZ+WIWClCjFEVFBY8e97Z8f//2hfNZr8PmriRZuHBOV4Ap6mRtGpWbf5B
	 DB948qxRsv+mzVxiyey5Ru8GEjwBcHcE4J1NAHjN1XHdSBuWCYBmei0LoYGqNfF54b
	 M7ug9uyfeBj5Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
Date: Wed, 23 Jul 2025 17:51:40 +0900
Message-ID: <20250723085143.134333-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723085143.134333-1-dlemoal@kernel.org>
References: <20250723085143.134333-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the code of sas_ata_wait_eh(), removing the local variable ap
for the pointer to the device ata_port structure.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7b4e7a61965a..440efdc714f7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -927,13 +927,8 @@ EXPORT_SYMBOL_GPL(sas_ata_schedule_reset);
 
 void sas_ata_wait_eh(struct domain_device *dev)
 {
-	struct ata_port *ap;
-
-	if (!dev_is_sata(dev))
-		return;
-
-	ap = dev->sata_dev.ap;
-	ata_port_wait_eh(ap);
+	if (dev_is_sata(dev))
+		ata_port_wait_eh(dev->sata_dev.ap);
 }
 
 void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
-- 
2.50.1

