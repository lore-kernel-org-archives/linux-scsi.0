Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795228357;
	b=EJOCzOVRV1rCJKDfWx83n57knOlhtS2DJcJpeom4KWe88ffqkmg/QDenkmvzlG80fuw4
	 gNVqh3/W8zgK9FF7R/f+Wn9UbvG+7uUDkcNrYPZQgooE7NvoGf0Ml1vcpbWC8o25jLOR0
	 P+bbSKGoGxLh7mqt5ayl9MN78YNLGDv0VJEXI4+Q57RIYCX7PO+gPb1kU6HeS1zIpiad5
	 /MyP84xY8H5pqh2AkWVUaN+HQN2Soadmpcih5olYb6PmKOB26Svz246ruJriiMyjz0TIf
	 J6Qz7dD1a9yLPjCRPD36oxW7HTROYADVB9oyC9X7X2JmcH7GUHRdFc8pZUlJ6O4VeXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795228357;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lOHRRCHn8v14HucXYtP26C11bQZVD01siOOpRuS/gaE=;
	b=vs8jZVN3czK8nCUVrqq2tq6CEG+TfQ53NeW2onyv6Cgud6hTYm1C8vS6zQDcYSqobX2p
	 KMrP2fGlTP+9Z8+n9Ne/0fwOBqwHr5+no4H6D/pb5qfBTEsyVt2nRNEnUYXlM5FkjV2Bx
	 lhoNJyiy5IbuegIU7KuC0mzr830jtIUKnSBJXgg7OJUZTN20DyAXFJRD9zbyrT4P6U6vs
	 oRsdqBgIg2iKpsNDSsHGHRvF5ny8R15Y2JA7QzcQidtwRWpPrNm7HR0feDguQaReBDPnM
	 Zp5SsOZeIhoaArgTEfOhVU12ZLWwxIG+IroHWUFPxd6Q6vnX+Lfe+CEjDmw7pAv5rGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FEf/2zHH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBAD606A33A;
	Sat, 21 Nov 2026 02:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEf/2zHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51C61F000D0;
	Sat, 21 Nov 2026 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795228356;
	bh=lOHRRCHn8v14HucXYtP26C11bQZVD01siOOpRuS/gaE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=FEf/2zHHIXdPCXM8msxg85lk7WgZoPcSLpPeGFT9aXgCtLUFlFV4bW4HAcgxXaVZq
	 8rqi2Uz7k/T+0RCGQfHat24Fp+dTY3u+eU5zrwod93pnkEjNXPoLxJ05sKaezuz6xu
	 4YvLVnoC6tlKcQL8B24FGLem4PKTnDc3FjzIhdcaNu5CO/A/ahNxOiCRNLUWAtoraf
	 zjkjC1uL2lFWD1L540nSMQ3pS9t5nTIXYSDTWotaFsN9XBFtasRi4F66Kg5c4JPrjd
	 Cph1dshjF0XPRpQWXZ2r0/acbi+SdMcAyrbsDOwDrfDE3fIXtDArOqbac55IrYDiyI
	 G0FvBgDNaGlYg==
To: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>,
  GR-QLogic-Storage-Upstream@marvell.com,  "Martin K. Petersen"
 <mkp@kernel.org>,  Himanshu Madhani <himanshu.madhani@oracle.com>,  Quinn
 Tran <qutran@marvell.com>,  linux-scsi@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH v2 0/7] scsi: qla2xxx: Fix races, leaks and inverted
 logic found in review
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
Message-ID: <yq1o6bior7r.fsf@mail.kernel.org>
References: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
Date: Fri, 20 Nov 2026 21:32:35 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Daniel,

> A review of recent qla2xxx changes turned up a handful of bugs in
> commits that are already upstream and partly marked for stable:

Found two regressions:

1. **Patch 3:** SRB address reuse can let the timeout handler remove and
free another BSG job=E2=80=99s command. Retain the job-identity check along=
side
the pointer comparison.

2. **Patch 5:** ISP82xx recovery can skip `slot_reset()`, leaving
`IRQ_NO_BALANCING` set after successful recovery.

--=20
Martin K. Petersen
