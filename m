Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469633CF73;
	Tue, 19 Nov 2024 00:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976162; cv=none; b=NIuG2E4FkRExgjFaVc3+IzBmIUAkRwGXrZK7UlKLniiX0kHKVUDmeanJRBoXndOsXes23ZmDFALDln/OZ93P1J750IRWrhXbeZMFkfuqHf+0ec/R3ErOWIo6wCNM5oIyJr6ys3HxBx4pxFLrEgo2vCC8oooxMliavnkY1SVKG2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976162; c=relaxed/simple;
	bh=tzk6wFCiz+nISJZzyxVRfy5Zdhci77ozeEvvnQn+Hek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGq5GApZ9lc83Xgl9DCHJftnReM0cnzTMHN3LmYgUGU4Qiy4FgQFTU/uFNYqYo3UEJoHsc5pkYrTwMuEdQl5v++0L39QjcmctAeaVlIl617jfggwV3YPab/tpw5MaGtX6K0K6AzAmZCwi+TYkRVCczlzatCFSBa4X4pK5r/Qqzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bp9uB69n; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bp9uB69n"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsljs0KrRzlgMVN;
	Tue, 19 Nov 2024 00:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976155; x=1734568156; bh=CgpLe
	vxFIdXXnVWzkP3TJcVOLg1Ot6lzGaTdNt7Ung8=; b=bp9uB69nNYvZAYHbZoHo2
	DI0g/vUc5fcfQsfqsscR/npmARt4YgVDFgTdvD38VBAwsz/JPGTQonJgBK5roLKY
	DBK109pnhl4uM02w47Cz0MSmaaOyBpnDfmxe5HwyI7Fff15GvGXJsgWEC6aHhL3R
	vkiHvt6UWumwTfR8rt+eHOPH/FjB6ZEhC/vqE+QeLtBq/DXODyXPbi6+BtagNTch
	C1zIBqIETxPbRWKfZWtu6dGc6B457oNTvYYhWviMePrAnSPsfxEe0mN2Fo9rhVrP
	VvO5d3kq6Pe79XpecbRDm0uyfZSB8C02BpKkNQBeGj0eNP88hNwhJEVL72qBqIIq
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fi0VJmnZPCh2; Tue, 19 Nov 2024 00:29:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xsljj04sCzlgMVd;
	Tue, 19 Nov 2024 00:29:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v16 26/26] scsi: ufs: Inform the block layer about write ordering
Date: Mon, 18 Nov 2024 16:28:15 -0800
Message-ID: <20241119002815.600608-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From the UFSHCI 4.0 specification, about the legacy (single queue) mode:
"The host controller always process transfer requests in-order according
to the order submitted to the list. In case of multiple commands with
single doorbell register ringing (batch mode), The dispatch order for
these transfer requests by host controller will base on their index in
the List. A transfer request with lower index value will be executed
before a transfer request with higher index value."

From the UFSHCI 4.0 specification, about the MCQ mode:
"Command Submission
1. Host SW writes an Entry to SQ
2. Host SW updates SQ doorbell tail pointer

Command Processing
3. After fetching the Entry, Host Controller updates SQ doorbell head
   pointer
4. Host controller sends COMMAND UPIU to UFS device"

In other words, for both legacy and MCQ mode, UFS controllers are
required to forward commands to the UFS device in the order these
commands have been received from the host.

Notes:
- For legacy mode this is only correct if the host submits one
  command at a time. The UFS driver does this.
- Also in legacy mode, the command order is not preserved if
  auto-hibernation is enabled in the UFS controller.

This patch improves performance as follows on a test setup with UFSHCI
3.0 controller:
- With the mq-deadline scheduler: 2.5x more IOPS for small writes.
- When not using an I/O scheduler compared to using mq-deadline with
  zone locking: 4x more IOPS for small writes.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abbe7135a977..a6dec3b7e3fd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5241,6 +5241,13 @@ static int ufshcd_device_configure(struct scsi_dev=
ice *sdev,
 	struct ufs_hba *hba =3D shost_priv(sdev->host);
 	struct request_queue *q =3D sdev->request_queue;
=20
+	/*
+	 * With auto-hibernation disabled, the write order is preserved per
+	 * MCQ. Auto-hibernation may cause write reordering that results in
+	 * unaligned write errors. The SCSI core will retry the failed writes.
+	 */
+	lim->driver_preserves_write_order =3D true;
+
 	lim->dma_pad_mask =3D PRDT_DATA_BYTE_COUNT_PAD - 1;
=20
 	/*
