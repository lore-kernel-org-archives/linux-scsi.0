Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464B39D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573335; cv=none; b=EoxBeVmKw1Byjba620GB2At0/2HrSg8RKwl04f0QRBtbrxFi6ooQlrg3a0MyHJ+HxhA/ZxQ3B/FFVUU1npyVU5gGecVzbxZQS8gtgLXPgH6lUhEemvTnjFcEvRjBmnITnM6JaaNpmHZCNtw7PYuuCltRXfLAbM2oV+zJ9Ys4NQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573335; c=relaxed/simple;
	bh=o3S6krafpiKEuIjgRCZIRlSNMEuuYtCewrSu2dGF0mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tob8HCyzikJspbnEtc02JoWEpvDokKtPX46ZnM3nF11mW9xFl9TdiIDVwlwMFhTfIZHtTWfdQ4JVwnvP7Z/thqQ4w6Mazj4tX6vRbp4BJahwFJvvZtpcT8X2ZwuA05O/emUeGqq+pjTzey1qyUfzqJV2h1h39XJ3uN4ujILlTq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MejFCv/E; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MejFCv/E"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZY4YG3zlfpMB;
	Thu, 30 Apr 2026 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573329; x=1780165330; bh=jMfoz
	ViRj595K7epluumti/P9dpeULRAVVVBNXtF63g=; b=MejFCv/Ev0kU2xl/tjp1B
	l2auQrA5ZeYL7DfNgtp76JUEZb00hToTqaCu27R/r5wuSUx0jPyHzWk/rzZEzAgw
	dKzVIP2lfFlYkiW+V6Gsz5M18M85ynObtkdlzFJ9nbjCpaL3h7tIlbkdCYWhDJLa
	CkZvtne/nD1LZyuNNUAEI00AgXxApEXRkva3Cswk7AryI0EmZv3TCB67rnjEONhV
	3i1vV3I1nr2uCGh+5EzDAkY6diU49YjVKb5m3j63trJvHrM+DlkYN0DoAI5/xp++
	J6UCzjf1aFwPHqGqerfKeqhhPYW28mcndUFIsy7gnG2sCGLPsZdcYP3qKaKFjVAY
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AHY5FkjqtpMW; Thu, 30 Apr 2026 18:22:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ZS1tgPzlffts;
	Thu, 30 Apr 2026 18:22:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 08/56] scsi: aacraid: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:38 -0700
Message-ID: <20260430182130.1978347-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document the aac_send_reset_adapter() locking requirements with
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/Makefile   | 2 ++
 drivers/scsi/aacraid/commctrl.c | 1 +
 drivers/scsi/aacraid/commsup.c  | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/drivers/scsi/aacraid/Makefile b/drivers/scsi/aacraid/Makefil=
e
index 8f0eec682bb6..415e0ed5ad24 100644
--- a/drivers/scsi/aacraid/Makefile
+++ b/drivers/scsi/aacraid/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Adaptec aacraid
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_AACRAID) :=3D aacraid.o
=20
 aacraid-objs	:=3D linit.o aachba.o commctrl.o comminit.o commsup.o \
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commc=
trl.c
index bd82aeb679ae..77238e610db4 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1043,6 +1043,7 @@ struct aac_reset_iop {
 };
=20
 static int aac_send_reset_adapter(struct aac_dev *dev, void __user *arg)
+	__must_hold(dev->ioctl_mutex)
 {
 	struct aac_reset_iop reset;
 	int retval;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
index c4485629f792..fb4d78233c6d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -475,6 +475,7 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, =
u32 qid, struct hw_fib * hw
 int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 		int priority, int wait, int reply, fib_callback callback,
 		void *callback_data)
+	__context_unsafe(conditional locking)
 {
 	struct aac_dev * dev =3D fibptr->dev;
 	struct hw_fib * hw_fib =3D fibptr->hw_fib_va;
@@ -698,6 +699,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, uns=
igned long size,
=20
 int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		void *callback_data)
+	__context_unsafe(conditional locking)
 {
 	struct aac_dev *dev =3D fibptr->dev;
 	int wait;
@@ -1466,6 +1468,7 @@ static void aac_schedule_bus_scan(struct aac_dev *a=
ac)
 }
=20
 static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_=
type)
+	__context_unsafe(conditional locking)
 {
 	int index, quirks;
 	int retval;
