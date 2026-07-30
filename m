Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189863B19CF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451628; cv=none; b=IyT+l+1d+FO9wQpKEKbEaHZZg2SpLsvSnocXtpbZ7W64lR9YMaMTCx5QnlkCqlCOwQx8tkHVD1bo2w+QfkIh2d8YKrikfnuakEd2+XC7rwP4oTRtHev1qk4R848JpkxYfr6biU0Xx6c6oVp8DoE7LTWO6IZd5wGs/y1W+cn6+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451628; c=relaxed/simple;
	bh=qo4rBsFRrj1IGqVtVPDi4+hoWCEYJKQ8qiXYIxE4rM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGynblowToRouaAYNBUX5298CsUl97zXTGm3NPNSmw7N6pA1omqQq7NNWxwkVe9H1yfCzUY8xd/VWGsEH6BSDpuwPRIj95X6Ub3eEK5sayAl1pF3nGeJsBvjTVKslOmj7fsXGZVsEE2SXeaL2fENiC+Zvly2te8t6DmkhYoYujQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=39iskZbR; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="39iskZbR"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48B49Mdz1XM30k;
	Thu, 30 Jul 2026 22:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451623; x=1788043624; bh=S3LNG
	3tgkc6A/6c98AkWnIBo1YkeLTOaxDt9LeZipMs=; b=39iskZbR6WuMOlpkQsPUx
	VFZeK6/wKgk/kUYw/bSZGOKSTsewhyaM9IFWoR+I63P7xH6XpVTDGNhL5gxkwdYh
	GxTNOQRof8cgQ1b/2wr2y+d/CjpnXKXYmQ7rALdSCxWpvacBD7Vr71c13DOQ1DML
	LEw1MfxJ6o83M1Qlsij4EC6efl3iKJoMi36HyWFouqHtAD73ssgbwlFen5Ci3lBu
	TEJGCxHvtVT5gLkNY6g7/cP/uyr9Qd+uQGnVcA7m20fVFjszbd1psjTvprP/ekR5
	iQ29qg5jsL2ylHx4jQKGZcez8IfXqYSqybe1o3Ww4dRQ3amrgc7SakUIoQ9fs/Xl
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IXSvMcqbzgTx; Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4860RmWz1XM6Jk;
	Thu, 30 Jul 2026 22:47:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 03/57] scsi: sg: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:46 -0700
Message-ID: <854b4d05787854fb71e3d9387bfe5293a38409be.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Annotate open_wait() with __must_hold() since it unlocks and locks a
mutex.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 74cd4e8a61c2..dd3ca717ed13 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -245,6 +245,7 @@ static int sg_allow_access(struct file *filp, unsigne=
d char *cmd)
=20
 static int
 open_wait(Sg_device *sdp, int flags)
+	__must_hold(&sdp->open_rel_lock)
 {
 	int retval =3D 0;
=20
