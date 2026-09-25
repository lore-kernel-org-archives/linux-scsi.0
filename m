Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C88409273
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360961; cv=none; b=sOeiVZjBE2V6K32rPBljFHfGheNj9z6UzA7+6ll+y0/s3wYjosb7zI0inuHGFnLpSHNnQ6F2lS4s0p8MLgvA3MUHQ2IMlFfudCXTHi6EQjDCbAQddIZ9G2+eJ8zMXh2J/VqnWApM4RP5RSikkLRuV7B3NIjhXaOTDNH35K6qGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360961; c=relaxed/simple;
	bh=q+y2z6XsmejXfJECSBz6QagDRiLF7OZ5YRQZFAjKCos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7nI7JrzAgd9gz4Haj+5m1S1CbWla/z6PScM+AiABV4NQ+eO0CcV36yk7SRE+jS48YLHTQ8kaTt+VGGp6NnoXT0xWqm5Q/L/u+ekvYqzQp/ho6Lzrj2BWG18cT6SQsyAcfhvB9SWfaFcqiMldiOU/fpN3GzSYJqDrhnqYMhyeJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rWdvdmih; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rWdvdmih"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkR5Zglz1XM30g;
	Fri, 25 Sep 2026 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360955; x=1792952956; bh=FhvBA
	19OS/L2EpR3w0PLx7nwR3iTEOCvTvVjRjfwVP4=; b=rWdvdmihFWHZHVlM4uEod
	uhN6fDaJm71OLR0NQNwfiLBuG90y00y/xr5x0IZJrE0pUKCsL+T5CfujHVFYduu3
	QyoLKarQgUOLeI8pTGgBdiPGOA2A8l8rvr3aD9jQlaGwwxWdIbQod2CuiPzqihES
	pPYX151qHZcUHpyc53RpVy2jt6eV13EMQi4zaV6hu0zKlH9BLUIjnIrAAjLMRCDG
	rFnxTccbMPxYUmekDsYdNHSoiKc5oSpgSmuQsIF0xGAgD1B+GhftrDr5a9LoxmW7
	ceYJ1RuxzA04kgM1NmCvyofOL+8k2dt4nW4XyCUJtfIrmtLGT0hMXhltcdFREZvB
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xeyK2FSO2ZY2; Fri, 25 Sep 2026 18:29:15 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkK4XFhz1XM5kY;
	Fri, 25 Sep 2026 18:29:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 07/54] scsi: aacraid: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:45 -0700
Message-ID: <09b6a1659d968bdc94c01f8215bbb4e41af5ebdc.1790360262.git.bvanassche@acm.org>
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

Document the aac_send_reset_adapter() locking requirements with
__must_hold(). Annotate functions that perform conditional locking with
__context_unsafe(). Enable lock context analysis.

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
index 347d480a39b0..0dba4406494a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -475,6 +475,7 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, =
u32 qid, struct hw_fib * hw
 int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 		int priority, int wait, int reply, fib_callback callback,
 		void *callback_data)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct aac_dev * dev =3D fibptr->dev;
 	struct hw_fib * hw_fib =3D fibptr->hw_fib_va;
@@ -698,6 +699,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, uns=
igned long size,
=20
 int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		void *callback_data)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct aac_dev *dev =3D fibptr->dev;
 	int wait;
@@ -1466,6 +1468,7 @@ static void aac_schedule_bus_scan(struct aac_dev *a=
ac)
 }
=20
 static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_=
type)
+	__context_unsafe(/*conditional locking*/)
 {
 	int index, quirks;
 	int retval;
