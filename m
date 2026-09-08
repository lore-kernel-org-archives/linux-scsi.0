Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB44A341A;
	Tue,  8 Sep 2026 09:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861493; cv=none; b=AT7u4hOoaLMzDDDwsUacUi76Yfg6BBvENWH0xC1Fk7LZJrGmT6Uqo6SQf/4WF3t/MZTxVVne5/2Mw57nwpYJj4GlEcuCrq2HwPjI/1emvuQV8VH4VJRw74SEXuHk6phWWSCM31Be+GCMwnGIuDd6KFJjvuhGWRXXKf7R5rU8RQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861493; c=relaxed/simple;
	bh=yCf9MkgEK2rdnnzI+k5UQUi1fUWdhbbTi7LF1bAoNkk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k5MWR/6UEj0RCOmO71WLpubgb/YlYAGgNzatPKsQ2JxXsY2gXOCWiX3NKSsJG+pzK9TMxz+iVL0aIlCrEgR5vyUQb5ZHMokhpeXR5HNA9A3z/Sn/T3I1UQgOdEUnSUbCRpTQQ5CD/OgqQXzToWKuCqnhESgXXr4IP8jdpqQdDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxfzVGJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxfzVGJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57C71F00A3A;
	Tue,  8 Sep 2026 09:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861492;
	bh=yCf9MkgEK2rdnnzI+k5UQUi1fUWdhbbTi7LF1bAoNkk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QxfzVGJeqw6k074TGBSypkJd3vQGnlQDq2vxYh5qImJvN0uDcxk+gZ3IflsCx6+21
	 MxWcyCLZgf3P0HZ+lym237aVpjJklJK0BxUZ+eEqPy+sKph0ch9+870IKxWt2DFa9Y
	 Ka22/op2NH22cVkJduG7mp0YDgtYTCBLiWPuzGOHsb7Km1G6wcgM2/MD2H4B3YZUmI
	 673X5VbrQFtE+vEMF6AeY7h2VhyDYGSfXNxIvF7xXox/ES6/7IGUWgAtu30YX6vvsv
	 qMcB8JS1Kkots7ThWaOVLtulaOIQF/fe769ZF1QO89BmtZFp3kPwfnEdspFnQpo5P0
	 ypLmNcmy5PTzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-25-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:58:11 +0000
Message-Id: <20260908095811.A57C71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the qla2xxx driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> While at it, the declaration function qlt_send_resp_ctio(), which is
> modified to take a single 16-bits sense code argument, is changed to a
> static function declaration since that function is used only in the file
> where it is defined.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D24

