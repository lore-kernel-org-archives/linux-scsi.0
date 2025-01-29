Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BE213B29F;
	Wed, 29 Jan 2025 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738165539; cv=none; b=WEen93MV4apYQpHL+8Jyf7oiqzc3nV+J678+bfkDuka/EUR4wivKjTtGlKWftZoNlQVBCXqjuWkrd2ZmsgwKnEh9EVfOLIqdZLRqhQ54tdh64jwyxOaKz3tzWW7CW3Mmlcepam+RodJwPdQjhyfk1DxFl0vtIO/vvySYShp+6Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738165539; c=relaxed/simple;
	bh=JEsCclbowZxerX2s+Txja1hp5YDzd5ZarkrGVxZ9+so=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RkT82IIcUcT8ThEvfK+p1QBgP7bTkz51FElt26RO2qxlkBSdzcRVN0GaAhajkNWjvTNXM6NlySi6G/qdBZJfKt982K5pw/lXqE6lrF2KOCax8s+47lkGbLTbJXNh2BixQAf+BtYdmmwONE6X425nwBie9fBgexluFNq9LD+3680=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=shelob.surriel.com; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shelob.surriel.com
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@shelob.surriel.com>)
	id 1tdAFp-0000000087w-1vp9;
	Wed, 29 Jan 2025 10:45:25 -0500
Date: Wed, 29 Jan 2025 10:45:25 -0500
From: Rik van Riel <riel@surriel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Marc =?UTF-8?B?QXVy?=
 =?UTF-8?B?w6hsZQ==?= La France <tsi@tuyoix.net>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2] scsi: use GFP_NOIO to avoid circular locking dependency
Message-ID: <20250129104525.0ae8421e@fangorn>
In-Reply-To: <Z5m-FuU7wJsUoSST@infradead.org>
References: <20250128164700.6d8504c1@fangorn>
	<Z5m-FuU7wJsUoSST@infradead.org>
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

On Tue, 28 Jan 2025 21:35:18 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> GFP_NOFS is never the right thing for block layer allocations.
> The right thing here is GFP_NOIO which is a superset of GFP_NOFS.
> Otherwise you could reproduce the same deadlock when using swap
> instead of a file system to reproduce basically the same deadlock.

Duh, you are right of course!

The fixed up patch with GFP_NOIO is below.

---8<---

=46rom 74272b4537415fd7d94c216e422510c27aa88fa0 Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@surriel.com>
Date: Tue, 28 Jan 2025 16:35:39 -0500
Subject: [PATCH] scsi: use GFP_NOIO to avoid circular locking dependency
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Filesystems can write to disk from page reclaim with __GFP_FS
set. Marc found a case where scsi_realloc_sdev_budget_map
ends up in page reclaim with GFP_KERNEL, where it could try
to take filesystem locks again, leading to a deadlock.

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

Avoid the potential deadlock by doing the allocation with GFP_NOIO,
which prevents both filesystem and block layer recursion.

Reported-by: Marc Aur=C3=A8le La France <tsi@tuyoix.net>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2093982b3db..b0964b6dd646 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -245,7 +245,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_dev=
ice *sdev,
 	}
 	ret =3D sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOIO,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
--=20
2.47.1

