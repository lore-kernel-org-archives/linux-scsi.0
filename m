Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5F2F7AC7;
	Fri,  5 Sep 2025 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084397; cv=none; b=HdOYD+ncn2/NmWRCzyNT+/Nc3iZwVx8g/rQxTh+dhOhfA9N3k/XuEgMz91kz7BRBRlGMW7wIo9BcIi4wFzhxYt/u5Es+oX1TKSuJot7AW4M8QULDhTT4cjco0ikRsW0UlOrnM05ynfMItuSRkSrebsuVQwRlqJfkPwN0Koq5FQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084397; c=relaxed/simple;
	bh=4Pg/kc9TsmuXZyTuBSEk148uZ3JxagZnVHVHLs/lqpk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CZ4iz6d3l6tZCX0qj0bltmZM/xKzs7284k9TNiMuE8xqo541y4KDZLt12KR7yyuE6LgBA/0y6pmsLtKxQqLb/kuXtsRsio15G8BqslVeCB4xIoF9vM5e1An5L/jqPwkbqGMpmeTlpx+aHCjTCUXoEw8MbU0kZ+RF3iTtMzZn/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2hDbgoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2hDbgoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07533C4CEF4;
	Fri,  5 Sep 2025 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084396;
	bh=4Pg/kc9TsmuXZyTuBSEk148uZ3JxagZnVHVHLs/lqpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S2hDbgozShyGTTd3qFyySfK8EonRHQzREz+TKg3kYNkoGTc2Hxza6JO6pzFgemkvp
	 G6OjXzi/XViRVWqqGg1D6+mn/YWV1L48lgZLYpFxRxxi1yIvIBCc08nMHudN304Ceo
	 D4/GXf+JbjPW3CZFJemHqM6GRcf4gqaAPoVoHhrhbPeQLZrLmyI68rxlZGgLM4oQfl
	 zvwnmql5qrsNCHl3OYPeAW2WI2X5JeQPtal6/Iwr97WRcmAmhYyhJuIJEHpU9pJ0PK
	 GTKX0hZJjSJd8HIaRiWovUd0i1re8bPt4Io7SxajbzcK5PQY8T2GnrOl2lorsAIf62
	 3PcM8XfxgwCFw==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:47 +0200
Subject: [PATCH v8 01/12] scsi: aacraid: use block layer helpers to
 calculate num of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-1-885984c5daca@kernel.org>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
In-Reply-To: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The calculation of the upper limit for queues does not depend solely on
the number of online CPUs; for example, the isolcpus kernel
command-line option must also be considered.

To account for this, the block layer provides a helper function to
retrieve the maximum number of queues. Use it to set an appropriate
upper queue number limit.

Fixes: 94970cfb5f10 ("scsi: use block layer helpers to calculate num of queues")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/scsi/aacraid/comminit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 726c8531b7d3fbff4cc7b6a7ac4891f7bcb1c12f..788d7bf0a2d371fd3b38d88b0a9d76937f37d28b 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -469,8 +469,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	}
 
 	/* Don't bother allocating more MSI-X vectors than cpus */
-	msi_count = min(dev->max_msix,
-		(unsigned int)num_online_cpus());
+	msi_count = blk_mq_num_online_queues(dev->max_msix);
 
 	dev->max_msix = msi_count;
 

-- 
2.51.0

