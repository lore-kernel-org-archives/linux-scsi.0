Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499014D0A04
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360963; cv=none; b=VQwVI0+tvcYx2U03sqwKN31pJs881HZRHPxz9t4MOYeaDMYr/DSSvH4K9k49wKBguN+pXOT5ZDVEA7AuC+n5WTLnJosYhELykHOiFOxTedwbMjhVjys7Dl1G1gLIUfvijTGsEvCiLrzBa6tZtL2QY+qRxpEfWDn5XKLedtktsdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360963; c=relaxed/simple;
	bh=7Q1rStDl1EVqSO4SxMLYc8NvmwXY6DDlDRKWYXRnCQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a10CvBbNkHod+Qt0YCx99Gn/xo7HxRZOywU8iMsL9zDfaYmnTHSNeHbUoIXYAMqaYlQsRRFGwLteJ92LT7cfGukIkIVl6XT5aYiXZE1onpVhifgq+XExVf3sNj+mqnH9fy2Yx+7u4m2SNnN7lPSO2PqEvYh6X3a3FWh9n35XQ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ttHu+LaW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ttHu+LaW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkS0NJ5z1XM5kY;
	Fri, 25 Sep 2026 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360952; x=1792952953; bh=ntwmm
	uJ0M1fiSVwZvv8mqkE6PZzAuYmurfvcCeHkRXM=; b=ttHu+LaWFD3mjlsqcPnqx
	7PkzYHOSDhH1PCwiL/38dTEt6mSwHA/Z+iwSmkn4aej/Rl1RUrzg5VSgb4WcsGzo
	hjiyNSQL1VVERlMSLoseHYZrL5CzsPwj52WZ9J3R1+yIL7Rce3oox3hygGVIBC6e
	+itaE7vDLKvncrvKDQ7FxxA38+diaJz85CYnYMy8qT1w26V2AKDe6BqvqKToAblQ
	FuZMIXu63w2SwHiZQu+W9pqHYP48vospGDt0hwX290N4BsrBow7jHnMYOqKWc8b5
	tPf9IFTNXrk4n466OLggJK5mFOGnKmT7ZvEdP8/ZkOvfmDTOrRKtLYG3D8HCLief
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id slwg0KjpYcZN; Fri, 25 Sep 2026 18:29:12 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkG4tXhz1XM4Tl;
	Fri, 25 Sep 2026 18:29:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 06/54] scsi: NCR5380: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:44 -0700
Message-ID: <a9d1b960868ac4dae9c5a9b98aea5dcf6713fb97.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass the struct NCR5380_hostdata pointer directly to NCR5380_select()
and NCR5380_information_transfer() instead of the struct Scsi_Host
pointer. This ensures that the lock context annotations
(__releases(&hostdata->lock) and __acquires(&hostdata->lock)) refer to
a function argument. Update callers and function prototypes accordingly.

Cc: Finn Thain <fthain@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 19 ++++++++++---------
 drivers/scsi/NCR5380.h |  5 +++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 006dcf981218..6afbd5936892 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -718,7 +718,7 @@ static void NCR5380_main(struct work_struct *work)
 			 * entire unit.
 			 */
=20
-			if (!NCR5380_select(instance, cmd)) {
+			if (!NCR5380_select(hostdata, cmd)) {
 				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
 			} else {
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
@@ -728,7 +728,7 @@ static void NCR5380_main(struct work_struct *work)
 		}
 		if (hostdata->connected && !hostdata->dma_len) {
 			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfe=
r\n");
-			NCR5380_information_transfer(instance);
+			NCR5380_information_transfer(hostdata);
 			done =3D 0;
 		}
 		if (!hostdata->connected) {
@@ -937,7 +937,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int ir=
q, void *dev_id)
=20
 /**
  * NCR5380_select - attempt arbitration and selection for a given comman=
d
- * @instance: the Scsi_Host instance
+ * @hostdata: host private data
  * @cmd: the scsi_cmnd to execute
  *
  * This routine establishes an I_T_L nexus for a SCSI command. This invo=
lves
@@ -960,10 +960,11 @@ static irqreturn_t __maybe_unused NCR5380_intr(int =
irq, void *dev_id)
  * cmd->result host byte set to DID_BAD_TARGET.
  */
=20
-static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd =
*cmd)
+static bool NCR5380_select(struct NCR5380_hostdata *hostdata,
+			   struct scsi_cmnd *cmd)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
-	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
+	struct Scsi_Host *instance =3D hostdata->host;
 	unsigned char tmp[3], phase;
 	unsigned char *data;
 	int len;
@@ -1643,23 +1644,23 @@ static int NCR5380_transfer_dma(struct Scsi_Host =
*instance,
 }
=20
 /*
- * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
+ * Function : NCR5380_information_transfer(struct NCR5380_hostdata *host=
data)
  *
  * Purpose : run through the various SCSI phases and do as the target
  * directs us to.  Operates on the currently connected command,
  * instance->connected.
  *
- * Inputs : instance, instance for which we are doing commands
+ * Inputs : hostdata, the private host data
  *
  * Side effects : SCSI things happen, the disconnected queue will be
  * modified if a command disconnects, *instance->connected will
  * change.
  */
=20
-static void NCR5380_information_transfer(struct Scsi_Host *instance)
+static void NCR5380_information_transfer(struct NCR5380_hostdata *hostda=
ta)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
-	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
+	struct Scsi_Host *instance =3D hostdata->host;
 	unsigned char msgout =3D NOP;
 	int sink =3D 0;
 	int len;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index d402d4bffcb2..450b08da5858 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -278,12 +278,13 @@ static void NCR5380_print(struct Scsi_Host *instanc=
e);
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
 static void NCR5380_exit(struct Scsi_Host *instance);
-static void NCR5380_information_transfer(struct Scsi_Host *instance);
+static void NCR5380_information_transfer(struct NCR5380_hostdata *hostda=
ta);
 static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
+static bool NCR5380_select(struct NCR5380_hostdata *hostdata,
+			   struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned cha=
r *phase, int *count, unsigned char **data);
 static void NCR5380_transfer_pio(struct Scsi_Host *instance,
 				 unsigned char *phase, int *count,
