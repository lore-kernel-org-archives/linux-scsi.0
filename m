Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0C63FE36F;
	Fri, 24 Apr 2026 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070564; cv=none; b=lFj1qsvaD0tjHuJjb88QnJk1rFmZPgr8UtSkoQgpmh75eTJw81yUK6Xcojpy/RsqgmGhDnuew52z6Ty05Q9Rs5MyB2/spMonscZAccH85iu3FAWK3bSGJV/Zpwpoh7la+pq2ZjpsbCqKQNUvg348Sx6e3aBG2PUfFC44QMwKpbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070564; c=relaxed/simple;
	bh=YEXRvfYoGKoOVlsj1+g7Dg0+lT8+RJA7W7E1F6o82f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHbgHJBiNeKHrG04t7nUtZj4iqKF3pUAUtCe4Q2L3LMsuO7vvjIxmjxcQ3W4cgc0GhvHnmDoskGzzZPpgT51rKml+Fqg8EOfwGhtMTFLfQl66GDcVm2Rs0GQdcKV3UJIKH27tB4zSlJ8rfczflkAzZmVGjQtbnpydu+jOAMkqeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=j1aNNLOl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="j1aNNLOl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdm450fz1XLHZJ;
	Fri, 24 Apr 2026 22:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070549; x=1779662550; bh=M8Eyn
	8V5rn+lEALKr950w0CEHUCI+r1ph+890KEjIOI=; b=j1aNNLOlkJ40+Ail6ncNH
	7McioCvFo3RZBNxnymejU7ALZs3b1LiMLW/Z1WeSsVw1R+cJ8bD45mIlm6bcVA0v
	kINrWAFXS2Fj6LLpoaGZcKie3vVGCzAlyAPHbtHoSZQUseYiUjYLnMLRR5BszIQW
	mifN7nBpcETjtyh42c02HwYq5OpPKv/9+l7m9+a0L65q0kDkvcR1H7lmVE1JM6EI
	iiJw5Jmhkd9JBgA3E0XA+1ecVe5jN+KGBxKRaeYnBcabQG1UpqA8hjFpIIYEwVUn
	hpFybqMjmPX/onqNlogrpdUMdvLhFLauM4NZCa4B8tFZWZjH9fJFYj7dGyxCIvIN
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TqDvJSaUYQ38; Fri, 24 Apr 2026 22:42:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdb1F22z1XQmtg;
	Fri, 24 Apr 2026 22:42:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 07/12] fs, block: Add copy_file_range() support for block devices
Date: Fri, 24 Apr 2026 15:41:56 -0700
Message-ID: <20260424224201.1949243-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Nitesh Shetty <nj.shetty@samsung.com>

Add copy_file_range() support for block devices. If input and output bloc=
k
devices have been opened with O_DIRECT and if copy offloading is supporte=
d
use blkdev_copy_offload(). Otherwise use splice_copy_file_range().

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/fops.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..f438503f1b77 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -19,6 +19,7 @@
 #include <linux/iomap.h>
 #include <linux/module.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/splice.h>
 #include "blk.h"
=20
 static inline struct inode *bdev_file_inode(struct file *file)
@@ -861,6 +862,58 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, =
struct iov_iter *to)
 	return ret;
 }
=20
+static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_i=
n,
+				      struct file *file_out, loff_t pos_out,
+				      size_t len, unsigned int flags)
+{
+	struct block_device *in_bdev =3D I_BDEV(bdev_file_inode(file_in));
+	struct block_device *out_bdev =3D I_BDEV(bdev_file_inode(file_out));
+	loff_t in_end, out_end;
+	int err;
+
+	if (check_add_overflow(pos_in, len, &in_end) ||
+	    PAGE_ALIGN(in_end) < in_end ||
+	    check_add_overflow(pos_out, len, &out_end) ||
+	    PAGE_ALIGN(out_end) < out_end)
+		return -EINVAL;
+
+	/*
+	 * filemap_write_and_wait_range() and filemap_invalidate_inode() expect
+	 * that the 'end' argument is rounded up to the next multiple of
+	 * PAGE_SIZE.
+	 */
+	in_end =3D PAGE_ALIGN(in_end);
+	out_end =3D PAGE_ALIGN(out_end);
+
+	if (bdev_max_copy_sectors(in_bdev) && bdev_max_copy_sectors(out_bdev) &=
&
+	    file_in->f_iocb_flags & file_out->f_iocb_flags & IOCB_DIRECT) {
+		struct blk_copy_seg in_seg =3D { .pos =3D pos_in, .len =3D len };
+		struct blk_copy_seg out_seg =3D { .pos =3D pos_out, .len =3D len };
+		struct blk_copy_params params =3D {
+			.in_bdev =3D in_bdev,
+			.out_bdev =3D out_bdev,
+			.in_nseg =3D 1,
+			.in_segs =3D &in_seg,
+			.out_nseg =3D 1,
+			.out_segs =3D &out_seg,
+		};
+		err =3D filemap_write_and_wait_range(file_in->f_mapping, pos_in,
+						   in_end);
+		if (err)
+			return err;
+		err =3D filemap_invalidate_inode(bdev_file_inode(file_out),
+					       /*flush=3D*/false,
+					       pos_out, out_end);
+		if (err)
+			return err;
+		if (blkdev_copy_offload(&params) =3D=3D 0)
+			return len;
+		/* If copy offloading fails, fall back to onloading. */
+	}
+
+	return splice_copy_file_range(file_in, pos_in, file_out, pos_out, len);
+}
+
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_WRITE_ZEROES)
@@ -967,6 +1020,7 @@ const struct file_operations def_blk_fops =3D {
 	.fallocate	=3D blkdev_fallocate,
 	.uring_cmd	=3D blkdev_uring_cmd,
 	.fop_flags	=3D FOP_BUFFER_RASYNC,
+	.copy_file_range =3D blkdev_copy_file_range,
 };
=20
 static __init int blkdev_init(void)
