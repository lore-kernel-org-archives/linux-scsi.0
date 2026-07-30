Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F2C5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451639; cv=none; b=cpKVra4O4U+/Me28n3lE+6tSbotF0TWnzW5RwYfhTnVoPDQJk1U7BoFHiFysx/o9s61+Zc5I4oX3y8g2SO8q9IACe2Nu8ejDYc3QFet9J38VlUGHXGBI6Qi5PLCGqlp+O1Mb0z/CXkW1G+oCIWp3XuGeNyoRS+Bq8Wsssw/puB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451639; c=relaxed/simple;
	bh=6cg6PGAV6iWzan+gTTmMomsPSuauocTJ8EV/7mnHXak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijeDOKzJCFskRPdadMK0wvqk2rdH88Ik6B1DIokfBq7Gx7CoKh+fATCFXhAZzdVhMr5A94aUuugZD+NKJrioPU9BiPEOAShf9JGHZiSFTP9vHmZpyd61L4H6t3h2famhKT7TBhHpxqFP6a1COr6jvdlXFhnAOhMjJcnscjMXmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q65kwnB6; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q65kwnB6"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48P3yRkz1XM6Jk;
	Thu, 30 Jul 2026 22:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451633; x=1788043634; bh=OIKTK
	FlC10qKQR32D8tEe5z7XpgSyRIHTa4z/KgSLTw=; b=q65kwnB6w3K9DiBMwVL9x
	Yqhxo94yWT7bv+CIBSmBqDq2vVSWH4sc9daoB4rbe5l5ewzzpkWZlpgi0kqJi82+
	o0uFWv4pLRjHmOKcsKkeURtXW9IEnjRIUxKRmqjWO/PU6IRzqjXWrV4kBRQmpHzp
	0KlvmPVkRUM/MXWxP8FlSi6iiQAhqdh20a0IyCDFRKjU0NHivQaC9ZIRnQsP05hh
	5jCDS4i+Qk2hi3lmZcrQxboxk7/p/jXr1r7CFXXH8OmFGBEraadMkIRrlbUKKYCw
	MeURNmfjUuQKOx7EThClsErtxqYBw9xJ2QsAo/mud78s9ppNHeZP9Uh7vwuIY0lV
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kwlr_FZw0Mtc; Thu, 30 Jul 2026 22:47:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48H6rVHz1XM6Jm;
	Thu, 30 Jul 2026 22:47:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 08/57] scsi: aacraid: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:51 -0700
Message-ID: <e6fae05fcb62f58bbab103354b0e0fe5138bb30d.1785451174.git.bvanassche@acm.org>
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
index bd82aeb679ae..ac73c7b6d7be 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1043,6 +1043,7 @@ struct aac_reset_iop {
 };
=20
 static int aac_send_reset_adapter(struct aac_dev *dev, void __user *arg)
+	__must_hold(&dev->ioctl_mutex)
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
