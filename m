Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083E2135B;
	Fri,  5 Apr 2024 04:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292131; cv=none; b=ZmW1PJbrEfohDChKvQKPkeGQgc9PW3P2lTyGbY41K8l6feXEhYj1vBqc8CgLM8ezWqgMKEXuUI3OD6AqI8VA+lq/VAxHm9BoCtqUHldV5aAGeQWdcprJEt7kR6oPnMKcstkoNkmaQcTtyWcRhY/LlSjLigf45S6d8N2w9TUMBn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292131; c=relaxed/simple;
	bh=6IgWUvJqcNdjsX7V3ibm78gJ0SitnuzQFFEgbizFsdw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaTBkD5NKkHuOllau0KIJiTvXEo6cSytU07n4RgtllbDPUOpG0QIpLt6fhaIGvg+3z4sEUvCuTAojYCAB6X5F9Gnz7HxkeLOFQZfxFb5dH4WDIoZ5D4U+UxGLxBTWlzE/Oy2E0K1315eAtAC3ZXlAh0PPd7xma6vcGsNv3e7YMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iU0GmWRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iU0GmWRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8532C433F1;
	Fri,  5 Apr 2024 04:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292131;
	bh=6IgWUvJqcNdjsX7V3ibm78gJ0SitnuzQFFEgbizFsdw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iU0GmWRe3EFLdoGzcGJH4N5xBvrUhOfZdyEiljLXyx7lVuCE0obHgNfFZHTvc9/Ck
	 2sd+yGS476eoAZP1glK4W3KgNswbEZQcVaWGSB+mwC+oJ8qGZuHFpEL5fTaYYuRJ/c
	 g0VfCB/vc7Mdx7GhitO4ufhMQdTuuUQ0Jf07HHY5dCkQ6O0NbwAVN87ygCFwuCcP7o
	 vV8Vht4QqnpTT8f2UC2f0fBZbXek+651oDYcc43wnsK9Fo7wzrcx3WJTbiKerdGLG6
	 cvwKFVi/KAYzY37D/SzZGZdFJ8WfQ0uk7dAQeLvccHH4nczDcYkCSApxaCkU6CSl6c
	 WPNh2AeByNwdA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 01/28] block: Restore sector of flush requests
Date: Fri,  5 Apr 2024 13:41:40 +0900
Message-ID: <20240405044207.1123462-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On completion of a flush sequence, blk_flush_restore_request() restores
the bio of a request to the original submitted BIO. However, the last
use of the request in the flush sequence may have been for a POSTFLUSH
which does not have a sector. So make sure to restore the request sector
using the iter sector of the original BIO. This BIO has not changed yet
since the completions of the flush sequence intermediate steps use
requeueing of the request until all steps are completed.

Restoring the request sector ensures that blk_mq_end_request() will see
a valid sector as originally set when the flush BIO was submitted.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-flush.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index b0f314f4bc14..2f58ae018464 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,6 +130,7 @@ static void blk_flush_restore_request(struct request *rq)
 	 * original @rq->bio.  Restore it.
 	 */
 	rq->bio = rq->biotail;
+	rq->__sector = rq->bio->bi_iter.bi_sector;
 
 	/* make @rq a normal request */
 	rq->rq_flags &= ~RQF_FLUSH_SEQ;
-- 
2.44.0

