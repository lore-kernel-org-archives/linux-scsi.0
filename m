Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DBF1C68D;
	Wed,  3 Jul 2024 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049978; cv=none; b=qbokuJoP+eVDH+Izhi9DrAzvTARGRiT77zK1DkyCnfVUAjLdPGU3z76PqxgBE0eQpu9oyLd6D8mNoDybQGiwSvIYHDS6Pn1mdq++RL78bbO54e7gUqtGZ4w9vBsp7tgJXwUGJ5i4JPv8nnbdcWNpG13N1Vp640UmvP02vpoOvrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049978; c=relaxed/simple;
	bh=9hcHS0GVx3YqoDCidjjfxXZkDC0/OHf557vnfJIUR5E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtA56lEEtqU2tgpXXXUQ/VM+uP0rX7SWb1eAPl2DWI9AqklhtjFuDvBWiPQ5ItBYCINhYb1DYl8nr5K8HTaPlUDkRfFPn6TipkZlhce5gCH6KSyPY/au3jlst5tEt7ckzOV8nVWMd80ovzwHHZv9hPIsFharjI2gW2omTQGT8RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+ZSggTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+ZSggTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C054CC2BD10;
	Wed,  3 Jul 2024 23:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049978;
	bh=9hcHS0GVx3YqoDCidjjfxXZkDC0/OHf557vnfJIUR5E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=D+ZSggTiK5MF1gca6B0CBBpypCUYb942H055ylExej7w7gUrWDPzdUuQLCrl0IBpj
	 Mbq1TzXAWWvdm015KU8cQX76gym5NUMn89hfIOhziZgcoCzlG+lL/3QYeKU+5caf7W
	 HVKOnYZCx+p0k7zO/6I/T1YNQSY9TrlPJow3TZuVzFeyInb/dRp44/K+2nWFUC6Ckf
	 zSjrbvAh1vo+tPAFEkiX1Rqm+sREPI1VFCZEZt294DqDqICQr66mA1dOUbQ4ip5xgT
	 9sVDojwlE7vTv3x09OeqtbfQrX5AQs9mvFyZ/9K0y7mtOi/i8OpwdW39rq5vzcIvZh
	 xBO34DTVRZyew==
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
Subject: [PATCH 2/5] dm: Refactor is_abnormal_io()
Date: Thu,  4 Jul 2024 08:39:29 +0900
Message-ID: <20240703233932.545228-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703233932.545228-1-dlemoal@kernel.org>
References: <20240703233932.545228-1-dlemoal@kernel.org>
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

