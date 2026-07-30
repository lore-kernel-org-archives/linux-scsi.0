Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370B75464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451625; cv=none; b=TXWBwcEVJqsQ1lMkPtRPnRTtHGjmWaNMM1AU8GIdPnBVf8jQZIg/BFUeetgfUPcaYfpRfenDSojgOtrmPRy/6E/EIKSdoLlBxfQw81wAp1tlFYRnLUlIbyoxMC6aRL3AkHo9h3c38FqkjgByXcV70ko3jCdyic3jZekNKdTtWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451625; c=relaxed/simple;
	bh=8zVo2giwShDL4xMiZ+SoCEH9LmsNT93W0Dsdkyi8T20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH1kfVo9BSsX80XxqZEfaNWJ6fs2xmNl3wRlI7lJXVWaeaGx2vmZT37KUS8eqS/YrR8A+PAkDAr/QKMCyciaozVdbMuMnK166WhxNDEwjyvE0vQqIBfxABf9o6QYY/15SvYZPcBk/tOxMD2uENXV84xVuzE+jWUEp91/7Cj81Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xbME1ALe; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xbME1ALe"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4872hmyz1XM6Jm;
	Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451619; x=1788043620; bh=mtkGf
	XhfWjFn1mrwtPCsbGQ7X3vDbahOPxJ3aXaLlD4=; b=xbME1ALe9Eqv2nz1Znc5b
	pvHwhIUKC7vz9vPjl2Vuz96Zxss0r6nXqUyu3xYsuqyxOZx1vJhytvKgfbNDln32
	akdsyhVE14Zi3ZySPI/3gzZVXSrPcQl6n2pxl239FeRf7hrGIGXT3Z2IjdgZKtmw
	AuoqxEmyvFjmWZXkALVb5MM2E2ZiK13IriFO7mq4+qNA8XMXhZiQdRWQFz8f8dLu
	EQE59RbGvaKIj05xjohST27jF8f/Ag/DvqNKF6FWVCn1WG/36j1v/L/ALNic97+G
	Fjy7f1JC3kiUMK3FUsmeBrMzKRbKPKekZs64BI5EV5PtcVfQsnqmpz/wRQ2eOCy1
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E-ym51g41Ijw; Thu, 30 Jul 2026 22:46:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4821Q8Nz1XM30k;
	Thu, 30 Jul 2026 22:46:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 01/57] PCI: Convert to_pci_dev() into an inline function
Date: Thu, 30 Jul 2026 15:44:44 -0700
Message-ID: <c962bcef9360656474e99e13b5b6785f0240fd9c.1785451174.git.bvanassche@acm.org>
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

Clang's context analysis checker performs alias analysis on expressions
passed to annotations like __acquires(). Clang's alias analysis does not
support container_of(). Convert to_pci_dev() from a macro into an inline
function such that Clang recognizes multiple to_pci_dev() expressions as
identical if the 'dev' argument is the same.

It is on purpose that to_pci_dev() accepts a const pointer and returns a
pointer that is not const. Any other choice, e.g. accepting a non-const
pointer or returning a const pointer, triggers compiler errors in code
that uses the to_pci_dev() macro.

While _Generic() could be used to support const and non-const struct
device pointers in a more elegant way, Clang's alias analysis does not
support _Generic().

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/pci.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index ebb5b9d76360..727050c5425a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -605,7 +605,10 @@ static inline struct pci_dev *pci_physfn(struct pci_=
dev *dev)
=20
 struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
=20
-#define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
+static inline struct pci_dev *to_pci_dev(const struct device *dev)
+{
+	return container_of(dev, struct pci_dev, dev);
+}
 #define for_each_pci_dev(d) while ((d =3D pci_get_device(PCI_ANY_ID, PCI=
_ANY_ID, d)) !=3D NULL)
 #define for_each_pci_dev_reverse(d) \
 	while ((d =3D pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, d)) !=3D N=
ULL)
