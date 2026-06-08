Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68123BB123;
	Mon,  8 Jun 2026 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912553; cv=none; b=LdpAdSjf+2zfW8brW7BhJnkeKm/iYsmUECED72RkZkNx6APpkGA+Zidm+TBu1Np/gyQmZjPbO8A73Q8lp8SxlCHPoAHdCYfHQ8hJUWeS+Rxtxu2aIQ3+2pB8C62+GcOJSBg01jh6Jen05AYaj4gnxDiMu9/XnrhTcLXzhM1AmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912553; c=relaxed/simple;
	bh=J+26cwnycjBB/+xh7/FyFiKHOw3YslMNo64DfLl50os=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oYmXy1R/WymbtmhbSue/dp0rfx1cpMwKvAageYAi8QVdPev8ikAoZA2w6voDfBB3Q59Noz1ynL9t32guaGshEsEsDfic9P53qrj/Vq7/Nbetm2NeF44XWIDELIZ6qpHnHQYqfWkN09YNxFk2PUZ1FlD8fi7KjgVlFx2qQ4CFzoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=VWOmjHfF; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="VWOmjHfF"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWht-00BrEA-GJ; Mon, 08 Jun 2026 11:55:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=6CXp94Ene1B/CC0Gj4fXjI3BrDySgYfWPJXaj6vUF1M=; b=VWOmjH
	fFkgjVU6aeSlnvbQ3JKbCiUSxRqWnCeG3OuPU26wEW5oaM2Bg5qarFyDId+vQezJrfaMBHzcv/FLG
	ob2bzMSaQ6F2mH20V1iQ8MOIyO2yZUVtAAnTtrqTbfmKct7BmuEiYf+XYCeN98PK88XSu31qeLJbf
	0OCg51Hrdlz4f331b3zyfGYYFfJEuWs7LS6y34v1E/lcpCluM8mGrxjE5z15in08ZHDYraKZD69Ci
	5cT9g1XzBidcGPmhLdinnfOgMNP3H5W+kv4DPur+Eu9BlnXH7hJZPHSeoe6+qhhp6HEozDjQSJ3T/
	YToYuAb0yj9hg+SoRxQQS06Qg3PA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWht-0000Jw-6x; Mon, 08 Jun 2026 11:55:45 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhb-00Ag6G-E3;
	Mon, 08 Jun 2026 11:55:27 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/bfa/bfad_attr: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:49 +0100
Message-Id: <20260608095523.2606-5-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/bfa/bfad_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 9751beff817d..c1fa5c38f596 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -364,8 +364,8 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	memset(&port_cfg, 0, sizeof(port_cfg));
 	u64_to_wwn(fc_vport->node_name, (u8 *)&port_cfg.nwwn);
 	u64_to_wwn(fc_vport->port_name, (u8 *)&port_cfg.pwwn);
-	if (strlen(vname) > 0)
-		strcpy((char *)&port_cfg.sym_name, vname);
+	if (vname[0])
+		strscpy(port_cfg.sym_name.symname, vname);
 	port_cfg.roles = BFA_LPORT_ROLE_FCP_IM;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-- 
2.39.5

