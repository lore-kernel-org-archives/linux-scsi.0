Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65371C68BB
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845428; cv=none; b=k5SggDZ6uYYk3tkI+53V8tMELLLcjeuVfcFqrLpAcuchl2sx3LHl1ECwDZBKV0JEXAdNiFljb13SDwZ+dun8OC8qPUxKRk5lqKrJugGlQslsQql+04CBLUfqXnYZTuvfxVHDnHMVo6Bd9W+MJAmKK6jBOGTNIThE6G/hj4RtyvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845428; c=relaxed/simple;
	bh=7nGf1avZ8XzYh4Jo/5xXziYrWN4ZpJANrQpBr0PjxYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxjlvmKNN6yMllf0Aqa/WwLnila1fq3feQwxXTwTzewSo4yJ3MUJ5PXrHrjJJop1cgq13pWCafLxm+eg4sirdu4s4ylLpDdix7gsJWzylyZl9LbUzW5cQVkANEJ3gViLrTvHZVwt4/EOL7PXrBPeUGBO/Dopzspm/a4CvsNwafs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XZbCLCgW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XZbCLCgW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnZ2vNqz6ClY98;
	Fri, 16 Aug 2024 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845423; x=1726437424; bh=FvyvV
	epn9Ef318j/BW4eY2hkqG5sJ6CUqIzNn60Mg04=; b=XZbCLCgW6gkRXHP7bvNpW
	HXol7eLEPvwI7GK5u+dYej3GK1zAms78RM4qEZKQJq4st6lqB7xLhtMFp2/U2gPm
	HkU9gcHojZR1j8zr08/BUPlu2m2WlxHdVsWtZWnNBGLteSfZBESCO3oSEqDi/7J4
	CJF8gP0h1Q1YEGXv3kXxSJbJB7Mj9Sl6BPA2OqXsLvY3JrUgUAlOxcT+sP+5jvd8
	KXjMeRESyAyaCSxHI86QvOTVzAJVqJjr+gv7W8Mnqk1PjG1I7cqeqXg98TQhrx8v
	ZmYtdLTg7K9uY56h7pY49QOxvAyd1M13hN4PYItyImfqtRvdrXoFgBpwJhRSCl2s
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1rdiSiZ2iUsg; Fri, 16 Aug 2024 21:57:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnT6mMGz6ClY99;
	Fri, 16 Aug 2024 21:57:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 13/18] scsi: qedi: Simplify an alloc_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:36 -0700
Message-ID: <20240816215605.36240-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c
index 319c1da549f7..c5aec26019d6 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2776,9 +2776,9 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
 			goto free_cid_que;
 		}
=20
-		sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
-		qedi->offload_thread =3D
-			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+		qedi->offload_thread =3D alloc_workqueue("qedi_ofld%d",
+						       WQ_MEM_RECLAIM,
+						       1, qedi->shost->host_no);
 		if (!qedi->offload_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
