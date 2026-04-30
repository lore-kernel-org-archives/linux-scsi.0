Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A839D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573319; cv=none; b=f7V301OSpdpMh+XsmDwySoJjGJuCtlxVueiaCx+IJpT4gpSr6kGjzm9agreRIXjfJrdapGCMHH9FbsdOX9mbNtn+8zo7ZLGxogdnLLR8i2wzxMo2f48sR+YWdSo7K0Ths165ggNnyN5dEiVIfn7oJl0zcFoeattgcpU0Ras31Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573319; c=relaxed/simple;
	bh=cFHnNZYTKD+pHk5xcnjxkpmEwEurw/zRiWmJPwskxKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsKjsf/Z3dggUAIK8vaxd5Qv1jP0EmJro37DT4ONVrzaUYYIGmGuCLy4A11K1dFXqEx3ir0QpNE4Ff8JL11INmLeUWR0J2PWyNlNGHvEgElGOfNBrB8pkuvH1hkzHSpzxsjPo9yG23J8LB69xzEwDtToT7rLWIiI8L2lDO3Yuf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p1DN18WT; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p1DN18WT"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZF07tkzm1W0c;
	Thu, 30 Apr 2026 18:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573313; x=1780165314; bh=wPk9w
	IkDgT/VhHfJ3yS3FPVjrSFIlLaKb5AakBQB8as=; b=p1DN18WT8isK56101chVq
	c7zaU9huCcDxjto7BIcM+J2LEt+ijezo3o3dNXwzMX7IMaRs+T1MPO6ZOPYTT00O
	sxw5uCRL8vnK0NnwjQ+xLGxy0TcmLEuND0Dpo71JX1SHcZAfCc9iuGDF9Llt/KP2
	OgnkQf8srkw91zkCBv36YGsU8HQmkjNM79Z3QZqQgpCC1q4mV00suqytQ5lBfqVB
	A3I0kZal2W9UoZ0AgaDlhoW9UkdI1YI3Qz0bej24/A7rAWILOMoxBLzzl9Dg9Bh0
	0JzYNnIcAUN2mTqEY7eQiXIqi1Ca1T3PPZPBJ4mDC8L9Bhf2ZUR9nLAVw72cBA1T
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xCdqpnTLomnn; Thu, 30 Apr 2026 18:21:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Z452W9zm1W1N;
	Thu, 30 Apr 2026 18:21:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 01/56] PCI: Convert to_pci_dev() into an inline function
Date: Thu, 30 Apr 2026 11:19:31 -0700
Message-ID: <20260430182130.1978347-2-bvanassche@acm.org>
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

Clang's context analysis checker performs alias analysis on expressions
passed to annotations like __acquires(). Clang's alias analysis does not
support container_of(). Convert to_pci_dev() from a macro into an inline
function such that Clang recognizes multiple to_pci_dev() expressions as
identical if the 'dev' argument is the same.

It is on purpose that to_pci_dev() accepts a const pointer and returns a
pointer that is not const. Any other choice, e.g. accepting a non-const
pointer or returning a const pointer, triggers compiler errors.

While _Generic() could be used to support const and non-const struct
device pointers in a more elegant way, Clang's alias analysis does not
support _Generic().

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/pci.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4454583c11..f5989267a537 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -606,7 +606,10 @@ static inline struct pci_dev *pci_physfn(struct pci_=
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
