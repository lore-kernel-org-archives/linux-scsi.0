Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036F3FE649;
	Fri, 24 Apr 2026 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070567; cv=none; b=hgN0qKgTALd7AfowhZH/eue0ZvUCuV5/lzZ9TF6LlKzEcLCQDGGp+GQUA2eDMgaTXG+oslrlfuvqYXmWIJvvDHYqU3f5HzWgF+tZ5KmokqvskyG9SBBkFclYz5s49b5z43daCwgbreIyiOBXvNFcYT0kTEt9piBunVAi/eAnQts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070567; c=relaxed/simple;
	bh=u7PjJsKO8KitLP+lbLsS9sfKOoKvdG3+FkA78tRgCeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA3j4/r0IHxhW5xnKAPFUXFYnF++tFTGvsyBcWV0vVXqPyXoaPGkJ6sCEf6tcrDrZdqU9tDaO8IbyY42Vz71WftrTIlHb24wozwu/Q8IOB2ofn5NSzQ4RxI0P/H4XkeaI6ynF7Dmq8tas+qm6vJOJ4cBjkSdTwqQ99arBxCPdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pt4+D8Qj; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pt4+D8Qj"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdl6qHkz1XQmtj;
	Fri, 24 Apr 2026 22:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070549; x=1779662550; bh=M4Sn0
	Uz7C3eCLnaBIcGNIfl1zUDw9GPLIKPhW/M1Vxg=; b=pt4+D8Qj7X6MJ7nHuhssD
	sYl351Aj1OMODaqbj+TntAA1Lwxb9V/Rqgcafvt3louxmvbrJWhLBKCrnNqFjN+S
	YBySRkVQ5UqiMliEmod3wt15o7m1cA/39Qb7qqM5+9IkLh9TqXuIKqePk+q1JI8b
	MEYE49l82YJOnS7WL0jTEN7TCfn9ubfwBHGQY+JNpaJgxKRDS4YnLx2kNZOzSplk
	Z77yTPnGsU8NjfKygHC2qdBJYv7AU5MuIoah7A6yE/DXvnAL8VollsMS7DIyPnYw
	t7W79i4s0gziLRp2Tgqve/iwYQ6EzBZcma5HRWskCAxktvtFQhD+G74j8gPoEoz1
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sy708VsVJXAT; Fri, 24 Apr 2026 22:42:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2SdX4pb7z1XLHZJ;
	Fri, 24 Apr 2026 22:42:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/12] fs/read_write: Generalize generic_copy_file_checks()
Date: Fri, 24 Apr 2026 15:41:55 -0700
Message-ID: <20260424224201.1949243-7-bvanassche@acm.org>
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

From: Anuj Gupta <anuj20.g@samsung.com>

Prepare for adding copy_file_range() support for block devices by making
the following changes:
 - Change file_inode(file) into file->f_mapping->host. Although only one
   inode is associated with regular files, two inodes are associated
   with block devices. file->f_mapping->host is the primary block device
   inode.
 - Change S_ISREG() into S_ISREG() || S_ISBLK().
 - Add an inode->i_mode & S_IFMT check that verifies that source and
   destination have the same type (block device or regular file).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
[ bvanassche: rewrote patch description ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 50bff7edc91f..d6fba5afff94 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1484,8 +1484,8 @@ static int generic_copy_file_checks(struct file *fi=
le_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    size_t *req_count, unsigned int flags)
 {
-	struct inode *inode_in =3D file_inode(file_in);
-	struct inode *inode_out =3D file_inode(file_out);
+	struct inode *inode_in =3D file_in->f_mapping->host;
+	struct inode *inode_out =3D file_out->f_mapping->host;
 	uint64_t count =3D *req_count;
 	loff_t size_in;
 	int ret;
@@ -1791,7 +1791,9 @@ int generic_file_rw_checks(struct file *file_in, st=
ruct file *file_out)
 	/* Don't copy dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+	if (!S_ISREG(inode_in->i_mode) && !S_ISBLK(inode_in->i_mode))
+		return -EINVAL;
+	if ((inode_in->i_mode & S_IFMT) !=3D (inode_out->i_mode & S_IFMT))
 		return -EINVAL;
=20
 	if (!(file_in->f_mode & FMODE_READ) ||
