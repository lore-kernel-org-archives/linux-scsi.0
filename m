Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F40286409
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511065; cv=none; b=M0Dj6pCt6Cc8OTaC03GqP6SB0iBAE354BixmiurqLwJYBX1+BeZ8qCv1SBD2WiTw9wVEwew/hnYMcFt8bF5NNmEgEsPR62NgQk5H0/A77aCsqH6ZQTCbbpc/7wHgU4vdYfA9sMsRdxLeWqQuhDuw2RADx1HhoZxHNLPd6BWGTpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511065; c=relaxed/simple;
	bh=fULTPgpFaddQiiea1heKc73/dtnZYpMBl2Qmacc9rxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvvv2Fb5BDIpici9XyIovs2fmudX5AEDPVAVAPCbn61bC16/y3Dj17Q/PWHzj/aTd6wOiO4ttM7HoXZrLU2UFc6PghjgDklIPk8OQzPua5IEAm4Naoo2bjqfHsTGurRpBjGG7QJ90erk+0V2VxKs39RDGbs/IjCw626tLC1S6X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w2RopZRz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w2RopZRz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dsb875Rp0z1XLwWt;
	Thu, 15 Jan 2026 21:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768511062; x=1771103063; bh=EMouz
	DcQ02xtF2ijuPsDWUmVpsBHfEh4RW7XtoEUf0c=; b=w2RopZRzPlhU18MSydha5
	10eRF54StQBv2Z4pQ9XlP3ZJ1IAMRm1oJcAwkTp9orDuBr13ISlucFozDysabSeC
	81i/vOtal2jHNZWqU4l9oMijuJIcpZzAHX9HR3u3IfaEKMIBGOBct2TLFIEw2dnS
	ubMe4d85Pg4luX67tIruwp9YFOcWCpmSbjhuw5264kft1CkZYxuFUJYw1IXx1Hfu
	KfPE/hkSXa5jop/kbfbF3KW6MvRjiw1xddORhXj7fRv7tsHfsTIIk4vMrF6eSeAa
	WvlaoxNnE2Qv/uZTRGk5rnn9ojX1xIV1s6zhSvTaIdlewst2Bi96OAAARIepipud
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sIRxHQ6AsdQu; Thu, 15 Jan 2026 21:04:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dsb842fq1z1XLyhS;
	Thu, 15 Jan 2026 21:04:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 4/5] qla2xxx: Declare qla2xxx_mqueuecommand() static
Date: Thu, 15 Jan 2026 13:03:40 -0800
Message-ID: <20260115210357.2501991-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260115210357.2501991-1-bvanassche@acm.org>
References: <20260115210357.2501991-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prevent that a later patch that modifies the qla2xxx_mqueuecommand()
declaration triggers the following checkpatch warning: "externs should be
avoided in .c files".

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index c9aff70e7357..fb0b689cbacd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -402,7 +402,7 @@ static int qla2x00_mem_alloc(struct qla_hw_data *, ui=
nt16_t, uint16_t,
 	struct req_que **, struct rsp_que **);
 static void qla2x00_free_fw_dump(struct qla_hw_data *);
 static void qla2x00_mem_free(struct qla_hw_data *);
-int qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
+static int qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmn=
d *cmd,
 	struct qla_qpair *qpair);
=20
 /* ---------------------------------------------------------------------=
----- */
@@ -981,7 +981,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
 }
=20
 /* For MQ supported I/O */
-int
+static int
 qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
     struct qla_qpair *qpair)
 {
