Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA4178F58;
	Tue, 28 Jan 2025 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738100983; cv=none; b=UWP21hhy0MoRdSCH1w42hk+ETAaIsGzHLk29W9+7AdKyLb/t3a/CN5R8GUiX7Dv9L18DPCcXah1AOCD/v+vqlYjEziAHqags5wglvU4GXsiNLOZKmxBJdOqD1O4fPlgOaKd9NRUS+PKRkOnaO4dgdL3p2vfKhGGD4Kfq9r+PDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738100983; c=relaxed/simple;
	bh=61ttWb0lwCjTs1UfgP8Ubi8+lqe6biKRiQYcRzix700=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=qTciEAZ6orYh5U+VuzrzWbgXw3vsZo5G9B5f1ou7UXZWJNvawSWXY8G1sihwCwluUIiKpz32RGdPKN+X+VY0h7D5TYeKC0MvkXDq5aaxDX/0/ZMkhGazPK/6vnIkbHgLOycNNBCtnYDGabN+qI0XrzwLLm/9/HRcakFxRm0h248=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=shelob.surriel.com; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shelob.surriel.com
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@shelob.surriel.com>)
	id 1tctQD-0000000081x-3xvk;
	Tue, 28 Jan 2025 16:47:01 -0500
Date: Tue, 28 Jan 2025 16:47:00 -0500
From: Rik van Riel <riel@surriel.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Marc =?UTF-8?B?QXVyw6hsZQ==?= La France <tsi@tuyoix.net>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: [PATCH] scsi: use GFP_NOFS to avoid circular locking dependency
Message-ID: <20250128164700.6d8504c1@fangorn>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: riel@surriel.com

Filesystems can write to disk from page reclaim with filesystem
locks held, if __GFP_FS is set. Marc found a case where=20
scsi_realloc_sdev_budget_map ends up in page reclaim with GFP_KERNEL,=20
where it could try to take filesystem locks again, leading to a deadlock.

WARNING: possible circular locking dependency detected
6.13.0 #1 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff8881025d5d78 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_submit_b=
io+0x461/0x6e0

but task is already holding lock:
ffffffff81ef5f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x9f/0x760

The full lockdep splat can be found in Marc's report:

https://lkml.org/lkml/2025/1/24/1101

Avoid the potential deadlock by doing the allocation with GFP_NOFS.

Reported-by: Marc Aur=C3=A8le La France <tsi@tuyoix.net>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2093982b3db..93d6feef9c7c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -245,7 +245,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_dev=
ice *sdev,
 	}
 	ret =3D sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOFS,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
--=20
2.47.1

