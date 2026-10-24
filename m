Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808536;
	b=K8E2LW5UxZ2vHHvV0jlsRrvJuZcESsKbvxfenD08osHyBuoj3T2AZrxrwmETLh2DOczV
	 dTbS84ksNrlYBkRmDEIFsLqDaZC8ZrNs+fEbaqbmJq4bEGx8jKlVLXJliz4hcup9PR5ig
	 hM5szpHuCIO/jwcAcDH5BTRLBfiQAWu84B8UrHaH+T2PuCRbrrzdNR+XwMPpMUoJl+7Xv
	 Yt9RuRey61m4n5K8H60L/9WCCsNRBJwEMTO8Y4BKPcGi5tx1sS6ygIa54V7snI5bbIwJY
	 UV/9GH5oe7QV84XgJcoyvhLh2Eg3fl28bv4fI7sb4oq9Ia8O5n+XO1VdZdzWcbBibJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808536;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=6G+E7R9VEyV1U8G+bklUJdfGzGm9SBW7F33f+6tv8vI=;
	b=doOzG6ReXiA/MFiPS+dxXPQ6unusHiaOUugxMvi2A/R9RdAMPkdzzMsrgB1OD5m85+py
	 ztJ5LBRvP8Gb4LzW+N+bmdhHcOAPOFEzxx2RSw+rI5CVQYNEoYlBTIz/CmfRFjkR+ohN7
	 4DUZuwuus9iZFNvmCqm/rYYg+HcyISR8p48CRR97hNEh/FroUvUrD9co9augW/YK+8dDC
	 89sfEHS/dst1+NyHWwypZHsv5vprxnSdkUpogOKmlOuItNSqKp7JLp0+fur7eDObS5SVl
	 JUlpAsGhByfVIzqHk7NA9/hNBh2yHD0+JrLO+1Gei3aptAsZyqaC2fhg6YGvq285A1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgYBL9nQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2C606A31A;
	Sat, 24 Oct 2026 02:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgYBL9nQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397281F01825;
	Sat, 24 Oct 2026 02:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792808535;
	bh=6G+E7R9VEyV1U8G+bklUJdfGzGm9SBW7F33f+6tv8vI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=IgYBL9nQgMJy+zomrxq+AzgvC99Hc9vmXnrB7JE7AcAkvRAY/2gs77sJ01ZpDbRbO
	 fhgThgcbi7TFXP7+pnI3GU81Z8kQGU6czqBOyhknQIsYrLxyZ2BJJvJuukPHIH2kIk
	 5Z6Q6sTKj1IgsyEfUBSfQWQaOiX8nFvTzPZegduoo62VOf2XKDQOomhpHJ27lwtP5j
	 ZTR6S1pR8mlCUsUDn0FEVn3zWtRTInHXTpNg4SBfWOg7NeJ6suImlNOSJGPEoZvAuX
	 B2rRVJl7EaBVtXJ9feTwyzKSGXAHjpEnihyw/bYJr81jThfqsCoGWn9JSDCRuU4C1C
	 qdJe6NKTSG40g==
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: Ram Vegesna <ram.vegesna@broadcom.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  James Smart <jsmart2021@gmail.com>,  Daniel Wagner
 <dwagner@suse.de>,  linux-scsi@vger.kernel.org,
  target-devel@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix resources leak in efcport_init()
 error path
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261008185403.2791781-1-vulab@iscas.ac.cn>
Message-ID: <yq1tsmbaldj.fsf@mail.kernel.org>
References: <20261008185403.2791781-1-vulab@iscas.ac.cn>
Date: Fri, 23 Oct 2026 22:22:13 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Haotian,

> efcport_init() creates efc->node_pool and efc->node_dma_pool before
> allocating efc->els_io_pool. When the latter allocation fails it returns
> -ENOMEM without releasing the node dma pool or the node pool, leaking
> both. The caller efct_efclib_config() only logs the error and
> efct_device_attach() failure path never calls efcport_destroy(), so the
> resources are never freed.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
