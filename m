Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC30B4C77C7;
	Thu,  6 Aug 2026 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044263; cv=pass; b=Tz87MdmUvYv73i4O2zFG4NL4nx1Z6C0t3u+eFkh0BMMKtDW76+YoWZddePj1xe9jCLriJC7XFMsyABXVB+SH7MypYsY8duhj7klvgegWVLWuvlPk/oK+0yFZe6mfRBzkYiWzzQrgTpPFAr2Zn/F0YMVTdAOYzk/tM8UElS41mrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044263; c=relaxed/simple;
	bh=eqM1ZPk/agcGMPcX21oUna0q3FO6SByOSOwQ/zPnPJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqeBCdrWwTC/Nxmx2yuYjri+xFCsrNGksPrHkZa9MfZ5+3kZA0KpXwvj/0wZrEA/7or+kIo2fKoq7aEn1CjhVy165pO4kiKRgp34L+AMvva6tqrhCaTR46U+jJX9/H63VlvjqIWeY4N5d1ZwYI8CfWReHv/YsUQDaXR91moQ20g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=XseFah/L; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="XseFah/L"
ARC-Seal: i=1; a=rsa-sha256; t=1786044241; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=HlR3vDANS8lmY72SGzX2i0i6muFtXoigjwZYsmR/JuJFedwep8XXUouHznZr7nL44xz5+9ayCvHK7jbmPmZzRvphzY0ENPdxjZ+eDfuqz0UotLnRssHywj3lJbVVWvkp/cLfEnyRBKpBdlSvpw9+uoeNVQ3MwlpxioHQR8LTMtY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044241; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EVZALisAIx7+fM/EWmicZYXYhpwiY2efmt9ZHcLNV9I=; 
	b=Qj9IvCsSJmoxmZ3cW+ozZoIrh2Ql/RpehSonZGdJLqhp1wdkhqumK+gpNn4WLy6M2p7CxK9R5YxON1mDogIyynW0uQjrJRkv/lOJ1BazD/8pFEljyCelHmw7hvWsa8dgjKLsZL/n9tgE14olQpnvusrWrywvMOg5AC+e9BvY4cU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044241;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EVZALisAIx7+fM/EWmicZYXYhpwiY2efmt9ZHcLNV9I=;
	b=XseFah/La2pWunFz+XzCYxdVgrs755k3OcWszQ5a4mfeUFcIDstWQ8RMEEi+oldb
	+9RVuPWcOsXG+rRltiEJztpdvlprUWMBEAAjOG6fOVDnKwhYDf/osVhCJyaxpDd62s5
	aDdK6olXroWPfNqX/uwlafV88HsqclgnvUjbTT/k=
Received: by mx.zoho.eu with SMTPS id 1786044239264751.5100185771277;
	Thu, 6 Aug 2026 21:23:59 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] scsi: elx: efct: check the HW state before allocating an HIO
Date: Thu,  6 Aug 2026 19:23:41 +0000
Message-ID: <20260806192345.328621-2-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_els_hw_srrs_send() takes an HIO from the pool and only then looks at
hw->state, returning without giving it back when the HW is not active:

	hio = efct_hw_io_alloc(hw);
	if (!hio) {
		pr_err("HIO alloc failed\n");
		return -EIO;
	}

	if (hw->state != EFCT_HW_STATE_ACTIVE) {
		efc_log_debug(hw->os,
			      "cannot send SRRS, HW state=%d\n", hw->state);
		return -EIO;
	}

_efct_hw_io_alloc() moves the entry from hw->io_free to hw->io_inuse and
initialises its reference, and the only thing that puts it back is the
completion of a submitted WQE. Nothing is submitted here, so the entry
stays on hw->io_inuse for the lifetime of the adapter. The memory is
reclaimed in efct_hw_teardown(), which frees hw->io[] as a whole, but the
pool loses one usable entry for every ELS or CT send that takes this
path. Once it is empty efct_hw_io_alloc() starts failing and no further
ELS or CT traffic can be sent.

Check the state first, the way efct_hw_bls_send() already does.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index b79c6a7ea791..15c37ff1d52e 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2706,18 +2706,18 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
 	u32 sge0_flags;
 	u32 sge1_flags;
 
-	hio = efct_hw_io_alloc(hw);
-	if (!hio) {
-		pr_err("HIO alloc failed\n");
-		return -EIO;
-	}
-
 	if (hw->state != EFCT_HW_STATE_ACTIVE) {
 		efc_log_debug(hw->os,
 			      "cannot send SRRS, HW state=%d\n", hw->state);
 		return -EIO;
 	}
 
+	hio = efct_hw_io_alloc(hw);
+	if (!hio) {
+		pr_err("HIO alloc failed\n");
+		return -EIO;
+	}
+
 	hio->done = efct_els_ssrs_send_cb;
 	hio->arg  = io;
 
-- 
2.55.0

