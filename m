Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA9F207DE2
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747330570; cv=none; b=o7FSUK8EdCi48stzhpV4VQOwsrbxDB4VkhkZPTXlQJ4qg5BgLE9Xu7UUv/XTGVQdd7p/+O0mI2N2zAmiU83UdB46SLrDognnVh3SvggT7G6IqRXyLV+oA2aKpYILcAGnZkFtFRfJEbYW6xFiILi4eXOaGFo3jlAIDDOeHXetAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747330570; c=relaxed/simple;
	bh=NR2KwpgoP9e6xDNHhpTJz0r+PQREDf3/duguzujYn/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=baDds09vArm1ouF+5QcJXG69zX03Rr+Zd8DAGIYXNztlHtYAQUiiYDG9qjiCbCfi4Te0l7txT7PuzfeHUxAj2xtOdc/duN/iBKFdltKMPs1ad0dqaYhtAKzI79bgRI3krkm4ZuPVEQiduniFXoQ9FXYXs0sm9McctrupY0RPEEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pkRNxYw2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pkRNxYw2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zyy6v0pNQzlvtfp;
	Thu, 15 May 2025 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1747330565; x=1749922566; bh=7C/f5KRy5lLe36jI5JCXdFDUNDhQQDkAtCM
	FgJY/hPA=; b=pkRNxYw2EBoVhyG1RJnC1kYhS3vs4SOYMd62Gp9tHzJGXPAzlo/
	0XSbBA3eZDBBk/3vOsnmp09MW7xnkvV+ZeYgpqYPiGwuFN3m1UBFsAfpvn0l04vs
	zsNRHNyViWR9BzvJ+eMOup3tE9PwiFWwUhDcAkJ+lbbc5KZc+kYxxyUwQgLJRiBE
	LKMvRDC36MkrkexK3gfk5pQMN31iGMmxT8Nbqo2j0cnlEeJDRhVkpTduIdytBoao
	QiIqhEFTq6mZ2M91TnfcAECDf0WdBOPrCdzLQP1Bm5HR4c2xLMKW0Qmm4TBa9WEy
	ons0i+OS0vVS+1oOLoHP1Ik4W+0vUdBdIxg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u6Oj-sWmq-iO; Thu, 15 May 2025 17:36:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zyy6n6lX4zlgqW1;
	Thu, 15 May 2025 17:36:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_debug: Make max_sectors configurable
Date: Thu, 15 May 2025 10:35:37 -0700
Message-ID: <20250515173537.1024421-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make the SCSI debug host parameter max_sectors configurable to make it
easier to trigger request splitting in the block layer. If this parameter
is not set then the following SCSI core code will set max sectors to 1024=
:

	if (sht->max_sectors)
		shost->max_sectors =3D sht->max_sectors;
	else
		shost->max_sectors =3D SCSI_DEFAULT_MAX_SECTORS;

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346a..101a96530b11 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -913,6 +913,7 @@ static int sdebug_host_max_queue;	/* per host */
 static int sdebug_lowest_aligned =3D DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns =3D DEF_MAX_LUNS;
 static int sdebug_max_queue =3D SDEBUG_CANQUEUE;	/* per submit queue */
+static unsigned int sdebug_max_sectors;
 static unsigned int sdebug_medium_error_start =3D OPT_MEDIUM_ERR_ADDR;
 static int sdebug_medium_error_count =3D OPT_MEDIUM_ERR_NUM;
 static int sdebug_ndelay =3D DEF_NDELAY;	/* if > 0 then unit is nanoseco=
nds */
@@ -7314,6 +7315,7 @@ module_param_named(lowest_aligned, sdebug_lowest_al=
igned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(max_sectors, sdebug_max_sectors, uint, 0444);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int,
@@ -7395,6 +7397,7 @@ MODULE_PARM_DESC(lbpws10, "enable LBP, support WRIT=
E SAME(10) with UNMAP bit (de
 MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRI=
TE ATOMIC(16) (def=3D0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=3D0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> fla=
t address method");
+MODULE_PARM_DESC(max_sectors, "maximum sectors per command");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=3D=
1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def=
))");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow =
on MEDIUM error");
@@ -9465,6 +9468,7 @@ static int sdebug_driver_probe(struct device *dev)
 	hpnt->cmd_per_lun =3D sdebug_max_queue;
 	if (!sdebug_clustering)
 		hpnt->dma_boundary =3D PAGE_SIZE - 1;
+	hpnt->max_sectors =3D sdebug_max_sectors;
=20
 	if (submit_queues > nr_cpu_ids) {
 		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=3D%u\n",
