Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEDA377AB5
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204459; cv=none; b=KbRgJ1YAxQOpExpOLRygWNk+X5MYJmMomgUgG4v1eCmdUhh4oTHCFLNiH7O9lbaYfHj6H+fMsb4rozWVOrBgyZjzvETn5Qh6r9Fz8pohDYk/5DRuaUb42K+rK6SzgoGrMXykGTMBune9jQCrNIqMNaHro18eprLPnKBDWFQ0LcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204459; c=relaxed/simple;
	bh=YHLJ6IspT+lCAccr3ZgRUz1v4OZrx/cDVU2sGIbA2cA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BeDPvXrvqrJkVjyPAMZQH4T1UQUFGlvxPcRDfF+g2SocgSObbxPOpMS0Satoj+TAkN8cDNLaLCB0nZfPdc1ZYXQGa/m0qfC6b1CbAnqmZANfqY7x7Axz0ISDXUH8esZvyWYANFJmBRu4N9goX9MBYk/ZvEKR6g6u/kkTHL2FO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kBfDxf8v; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kBfDxf8v"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYfCF0kjfzlfvpM;
	Mon, 31 Aug 2026 19:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1788204452; x=1790796453; bh=CKxTUnu/1ib75AwlN17zhNaqU1Uw03/7AjM
	afsSTyuw=; b=kBfDxf8vHuR/EvW5CLSONl5Wv+aniMgtGz5HhKisjv9ciQtjUHC
	ddxJ4k+5hQuC8lv41wNh2fdhD4r7MIUrum6ky1NInIOok0Wiy2miKtyCgc1cebcv
	jeLM23kNZ451LCXAVu0RZXSz/AzNTnUY1AKE+MBdcYI3SpPsg3I7SBvOeGJmq9Mu
	wX/Ux6+3zLGbVnrjL/oWFnLdF2rw8JU2zga5C6fy6OH3HrlQGZNRruMfSzSfk7Ky
	wdptO5bRpF2b+sSJZiArC7TZiR2yxAvHlDGb5ffY9XCWV0IR0Co8gdEBmwYNt4+0
	lRVhopsmwenR0b/2lr7FhkN/XtzyjjoT3ng==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T_flewD6JbDU; Mon, 31 Aug 2026 19:27:32 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYfC50nw1zlfvpH;
	Mon, 31 Aug 2026 19:27:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v2] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Mon, 31 Aug 2026 12:27:20 -0700
Message-ID: <f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Protect the megasas_get_ctrl_info() call in megasas_resume() with
instance->reset_mutex using scoped_guard().

megasas_get_ctrl_info() may release and reacquire instance->reset_mutex.
Hence, calling this function without holding instance->reset_mutex is not
safe.

Fixes: c3b10a55abc9 ("scsi: megaraid_sas: Update controller info during r=
esume")
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: moved goto outside scoped_guard() { }

 drivers/scsi/megaraid/megaraid_sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index f0152b043e18..d4cbc0643eaf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7875,7 +7875,9 @@ megasas_resume(struct device *dev)
 			goto fail_init_mfi;
 	}
=20
-	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
+	scoped_guard(mutex, &instance->reset_mutex)
+		rval =3D megasas_get_ctrl_info(instance);
+	if (rval !=3D DCMD_SUCCESS)
 		goto fail_init_mfi;
=20
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
