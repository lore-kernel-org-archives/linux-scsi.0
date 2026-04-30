Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E807339D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573324; cv=none; b=cAbMep3+HK1LxRIqcKOK7IoDPojBLecvUZikPhnjBkZQqdmj8BqLjFZ/5R8QncdLNTWjRQy8v2M5EEYU3IOxx90bDdCf0c7Msbfm7EPmhISCbR514BI1VZDchI52oYJmBRrSRqE8S5OsPE31q3RLQuTJd0tv8ppBHTga1lq7Uvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573324; c=relaxed/simple;
	bh=RPSqlyVcrDjD3TyHDhbtTp+CYlig+PugFITVpvIhexE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpBDAqKNwGcE1H8kAxdPTEzKyVarOQm6hfHSvJa5o5y7jDEvs2CR8fbiWbCB1h07Xs0fGUNgncxm8YnkFgku2zzU1HfsNfQ+knVZv2pt6Sy55fkYXn5U9FKSzyHGN5T/u4tuW+tCz9IrpkU4LqFIVwuv8PeRhHOcagiV6yuAiD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J6l6SZdW; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J6l6SZdW"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZL0rGtzlffts;
	Thu, 30 Apr 2026 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573319; x=1780165320; bh=H3cBp
	wEs3DjpsYI96fr8/RXLpTdX3J+hBmOfzTi+6t8=; b=J6l6SZdWt6xuJGUTDzDvg
	82RY0ee0TIfox1YweGw/oornmNoH/VpbL5EC1DqQcu3E9uhyOwicxYlEy671iav4
	3eJzsZ/XaEVGk/9jvep7U6Eu8nPj96pDjVZux96sE4DWlce3IGI5u4qs6HH/Bilp
	L3hE/ndP6V2YA3gkMB1xwQFcIt+hlXbJN7RGuZSBztLdGtGp4BxVrnnVTS97ccts
	fVPRzW4ZshUhEKeqfo6r55Re1UOWc3cRJuCGb5fHkWpwGyHytEyllm6D2Llow6aQ
	Hfds6dwzVbZELe4TFTiEn2fytZqR25CP7lx6VDzJh8Uih97SPEoK8XiqIxnBWWxC
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KvQnNUIDXmEs; Thu, 30 Apr 2026 18:21:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ZF5sVmzlfpMB;
	Thu, 30 Apr 2026 18:21:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 04/56] scsi: st: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:34 -0700
Message-ID: <20260430182130.1978347-5-bvanassche@acm.org>
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

Document what mutex is released by st_common_ioctl().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..234482e1b70b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3535,6 +3535,7 @@ static int partition_tape(struct scsi_tape *STp, in=
t size)
 static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *ST=
m,
 			    struct file *file, unsigned int cmd_in,
 			    unsigned long arg)
+	__releases(&STp->lock)
 {
 	int i, retval =3D 0;
=20
