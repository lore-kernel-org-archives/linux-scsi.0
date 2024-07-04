Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609B9747F;
	Thu,  4 Jul 2024 05:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070905; cv=none; b=RB//WoQfLl+itfx25ZA+2swZYwAT/JNj8pDdstwldoOPA+plsqEwdRys2TAIoiO88kIy8Bhg2K5wi0BobIuVkdngTwBFgAacB4zRYsspj+kDvi7E5xHlWPZMqlpAdszVlAcK5aP00SIaoaBFdczBKpLCLgVsXa91+lM1K3SgzIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070905; c=relaxed/simple;
	bh=IfLIXxIUw0pegxhOVo68/iQZ/mEUM8Llrsw4O0Zqwrw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aftEG0w/T3NzDpa6gKsQ0Go3Sk6U9Bxpr08c6AajDkhkiA3/jaKXhTVsWmtnO9GQQ9JAsfHM3J1AW1yBHJa1puUqiHeV1ytMjS++AP/vB9ACtYKIf6ADkJjaqoTK+tTWmqiJyM2N+FEj68aE9q2f+toggWI4zNIz3gcmVTO0qmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lP+R4KQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lP+R4KQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11323C32786;
	Thu,  4 Jul 2024 05:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720070904;
	bh=IfLIXxIUw0pegxhOVo68/iQZ/mEUM8Llrsw4O0Zqwrw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lP+R4KQDUC7MaldDiF8xbhzhKER4Bz/BQmuHB+WkMg5OeZzOMuy/FcoYrJ5TbbwNk
	 murUvlZgZdIdEtUuT/y+DyRFPOo2SQMc5im755KhDUPw4EJV6J7IIBnTF1EjD1O/PF
	 gt/nljdQvz3HEy9miqIgrbwwIdTfQCaBcGwuAY0WwwMhqY0Epou1qoKkunghYYOq+T
	 AoizclpLfR6ncVlndYuamyeOvwFbwgqUjx1PBt2wjKf3jBkvtfKY1ewopBly1GhQRP
	 KlmVgWtCEdQhELIiy/slMqRoKGJlveZOp3k8V3BZApjDNoul0IHH5pU06xZqh1CbG9
	 ostfc0bHXjYLw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 2/5] dm: Refactor is_abnormal_io()
Date: Thu,  4 Jul 2024 14:28:13 +0900
Message-ID: <20240704052816.623865-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org>
References: <20240704052816.623865-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a single switch-case to simplify is_abnormal_io() and make this
function more readable and easier to modify.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7d107ae06e1a..0d80caccbd9e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1598,20 +1598,18 @@ static void __send_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 
 static bool is_abnormal_io(struct bio *bio)
 {
-	enum req_op op = bio_op(bio);
-
-	if (op != REQ_OP_READ && op != REQ_OP_WRITE && op != REQ_OP_FLUSH) {
-		switch (op) {
-		case REQ_OP_DISCARD:
-		case REQ_OP_SECURE_ERASE:
-		case REQ_OP_WRITE_ZEROES:
-			return true;
-		default:
-			break;
-		}
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+	case REQ_OP_FLUSH:
+		return false;
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_ZEROES:
+		return true;
+	default:
+		return false;
 	}
-
-	return false;
 }
 
 static blk_status_t __process_abnormal_io(struct clone_info *ci,
-- 
2.45.2

