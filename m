Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114BA44E643;
	Wed, 26 Aug 2026 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757631; cv=none; b=elTsjw399gQw1GOLHjXPQSfjwlRRDAXkI2BjtcNE2mnEjKiegw/MCnBVPn9HwR84alX0WOg3RZX01EHazAGOnUTi6744NGISN0boSLZVi1/kCOY8TfFt7GnfOsTK6cLyT+prjIpewyvIS3ZtlSL2RLVjkZIxou5nmYDagf0zMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757631; c=relaxed/simple;
	bh=mqPsOXV/lfNVfD+Ep0lp165SfGeqWuJXSFfc8pvnTRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+VlTkOXPwkl0bbmkMd/RpO4HFUI9hbmjsI7x0YrpWkzcI2/DnFozTCBMQx/2/PKQuX9KQ3bNEZuyLAKo3WfRPIbp9ZT/locy/6TcNvgcAkoV8sUvKSKYx7h3HK7X7B4vybgONufUGjnFJQfFkPlxmjAFIppln3SC84ejxyq+/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fx3bvxtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fx3bvxtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2C81F000E9;
	Wed, 26 Aug 2026 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757630;
	bh=jphUJK5ZLwWhd53YVv8V3auiihN0qXdGkXQ/u22obuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fx3bvxtzS5GgNrpwzQMQcUPkTAeBiPImutCpd9MnxyQA129wS/1eSoGf22q6QcBTY
	 Dv3OFGrewibtUjZmcRVSsVDAxzHIvGBGPHcrAxu9Zww0ZnIlUm1jqpAisyOZt3jhjl
	 unhBtkXq2gE0ogtSianvkXeDWOZ4xKt6KTQQR0AI481QcLKu6qqa1LAIM3J97azsQ/
	 J3cBqRHqdtO48kA+Z4esT96ekTREfAWnNlBP7JJ+g7ksxQFJW4MadicVurYwRsDq+h
	 QLotvRFjwYUXMk0uBOTx6gLI43sj1WclMeGEIms//JQOP48Fz9I3caIrQdy+KHeV/R
	 UKPCyWL4WOg4A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] scsi: ibmvfc: Fix use of uninitialized rport in ibmvfc_do_work()
Date: Wed, 26 Aug 2026 11:20:15 -0400
Message-ID: <178775714066.3862282.8143552367405042697.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
References: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 12:04:55 -0700, Nathan Chancellor wrote:

> After commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
> thread"), clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is uninitialized when used here [-Werror,-Wuninitialized]
>    6154 |                         } else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>         |                                    ^~~~~
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: ibmvfc: Fix use of uninitialized rport in ibmvfc_do_work()
      https://git.kernel.org/mkp/scsi/c/b79b88b655a8

-- 
Martin K. Petersen
