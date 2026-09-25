Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D44CCDD4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360945; cv=none; b=RKFDe1KtY5ou0Cp2P2TWX0dG6hu5C7LtWq5ZTEcykZcOQY7gdU/ZjZ/UdezME65my/5ehTxvMyGC496JFz2cQ1BOFiAUF6Rg3c8YnrNgMvd75jxOkUYFb7UWVtUW1tD9XppTyQPIUYYnetn2cRwqpftCDvTISOjHvRrwNUQ12oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360945; c=relaxed/simple;
	bh=eGH3jSAZNycjEGeEdBCycT6RqUw7EkmH/4Gx+FFoeNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6nJrh62QaejxXQcw5FU+tOD6GCcXTV6yWtToqDKjEaipOWLL2HVu3I0A1oOrDubHAG7bh5ec1lyB7h5Faov+Lbu4GEJDOQOwqXFLaDwL00FNIFGywNZmiQ8B6a92CNqSllwGCIti2JCafpJJKTz37gBCz7SmWC8UXCafWlhToc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HSyBJTpx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HSyBJTpx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzk731s6z1XM5kt;
	Fri, 25 Sep 2026 18:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360939; x=1792952940; bh=NBioY
	+W1DSWfuh70/+Tyi+RGKzHx4Ee2yZC8t+GBo2Y=; b=HSyBJTpxtcYG4fhfKApai
	cYX/uI028y2A4VD9vybCMyNoJ4nQs4AAUsviffQaqc2lWLmuiPehfWSvjSdsVkV2
	XTHber4xKFtz8TtcNjDTiANDkHC35Z3UuUac5WSRAM0qJkQ6b75ZRFP1rL5dUUXd
	DTwTgpEKVzFzHoJosnoFt7fA3wPmghS37ieYRo+fiQoRlUsWKGDHqa7kpUAbkMXB
	3eaHX17T0fC6Nibkt2hoE4HfahV8oMikPd7CcCEP3JHWb422+ky/ynhczN9/XY8I
	a6XRWQelaLgdNC72XWrc7/RGHZ5aaiTs4/gDaNtJo7xPpO2mgTh5u8t8m/bY/uQQ
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 285hSRugULkk; Fri, 25 Sep 2026 18:28:59 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzk22GMQz1XM4Tl;
	Fri, 25 Sep 2026 18:28:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v4 01/54] PCI: Convert to_pci_dev() into an inline function
Date: Fri, 25 Sep 2026 11:25:39 -0700
Message-ID: <f147ad227b85439d56183e60e0332547b84441bc.1790360262.git.bvanassche@acm.org>
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
index d31a8d107b1e..68166c9f8158 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -611,7 +611,10 @@ static inline struct pci_dev *pci_physfn(struct pci_=
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
