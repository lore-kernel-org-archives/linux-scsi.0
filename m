Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C5E1F63CD
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 21:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873709; cv=none; b=MDR+GzlTB5cS8hYMxBJ0Rmbri6QnxL/yd7V/wC3/7nC+M1391g6y2LuqhhPViwajZRgUYHTGsI1FUheWArHxbxzexH3mSpF2coxsVfDCPDHJcsCBBy0l1CIQSkicR6SJTpCIkltTSX96l9g/KBiRO8iCvlb/EfDeu8FWcJYhUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873709; c=relaxed/simple;
	bh=aHSOMWISwHQa4yM9lAmfrDtmUaqAzv+6gd1Ofi39Rw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BDcROW2ML9UhjxTxv9f0DW4vHouNbrKv1yRu1IVV7bsrU6B6RCDOLZbQgt80cVNbaihJjbt4LP6yl414hHAQtX/XqiufufPGpEfe1GztdD5eln2JiKjD3ynsRVb9RM6GSuDt2W3kBBcIkfqWKO2eH5x5J1CCIEz+foerITrim6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a5+OOTzg; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a5+OOTzg"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ch8rz7454zlgqVx;
	Tue,  7 Oct 2025 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1759873698; x=1762465699; bh=v2izTBZE/hUlM6ag5GWowe5UTGqRk8b+LgW
	kcda96ZE=; b=a5+OOTzgfdPPb9dg1PVtJeJBvfmFS+Unuu2Rp7sZJyw3CipB8Lz
	ZOgzfltiSJ59bP2wX1y9cMH2Hnga+OriLlBTQJyIj3N6NLLxKdfuXAT6fkilLNqY
	BTDiMDS1N9IWixsMoUafwxajwKtc+4ztsv0YAYiAPXbFsGmgtNavWrc5dNKqpTm6
	VvUEH+kQIic4vRMMWR/Hi5RlvdL4iFU5+U4sMeHFGMhsuU9tlZ9nyY9/opc8Q0mJ
	ofmkD21F+5/+ECQ3eEz4EPzktJ2F5KfWjqVlbZHr/2RezN+2Q+++bkYJq/qryv4s
	A8kF356shc0ocZ7kJl9R7rHFNyEuaY4DN8g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oZQvKAFZsVHt; Tue,  7 Oct 2025 21:48:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ch8rt1D9DzlgqW3;
	Tue,  7 Oct 2025 21:48:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Fix a regression triggered by scsi_host_busy()
Date: Tue,  7 Oct 2025 14:48:00 -0700
Message-ID: <20251007214800.1678255-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
iterators") introduced the following regression:

Call trace:
 __srcu_read_lock+0x30/0x80 (P)
 blk_mq_tagset_busy_iter+0x44/0x300
 scsi_host_busy+0x38/0x70
 ufshcd_print_host_state+0x34/0x1bc
 ufshcd_link_startup.constprop.0+0xe4/0x2e0
 ufshcd_init+0x944/0xf80
 ufshcd_pltfrm_init+0x504/0x820
 ufs_rockchip_probe+0x2c/0x88
 platform_probe+0x5c/0xa4
 really_probe+0xc0/0x38c
 __driver_probe_device+0x7c/0x150
 driver_probe_device+0x40/0x120
 __driver_attach+0xc8/0x1e0
 bus_for_each_dev+0x7c/0xdc
 driver_attach+0x24/0x30
 bus_add_driver+0x110/0x230
 driver_register+0x68/0x130
 __platform_driver_register+0x20/0x2c
 ufs_rockchip_pltform_init+0x1c/0x28
 do_one_initcall+0x60/0x1e0
 kernel_init_freeable+0x248/0x2c4
 kernel_init+0x20/0x140
 ret_from_fork+0x10/0x20

Fix this regression by making scsi_host_busy() check whether the SCSI
host tag set has already been initialized. tag_set->ops is set by
scsi_mq_setup_tags() just before blk_mq_alloc_tag_set() is called. This
fix is based on the assumption that scsi_host_busy() and
scsi_mq_setup_tags() calls are serialized. This is the case in the UFS
driver.

Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Closes: https://lore.kernel.org/linux-block/pnezafputodmqlpumwfbn644ohjyb=
ouveehcjhz2hmhtcf2rka@sdhoiivync4y/
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c..17173239301e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -611,8 +611,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
 {
 	int cnt =3D 0;
=20
-	blk_mq_tagset_busy_iter(&shost->tag_set,
-				scsi_host_check_in_flight, &cnt);
+	if (shost->tag_set.ops)
+		blk_mq_tagset_busy_iter(&shost->tag_set,
+					scsi_host_check_in_flight, &cnt);
 	return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
