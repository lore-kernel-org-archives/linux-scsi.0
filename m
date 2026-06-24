Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A82E8897
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317134; cv=none; b=tX4X0ISUW8yIvnvnVRaPyLgiDhtWqFET56pHxaayn6Qcgh2Z6/l3xQugBUKXtLhJS9tiBbxyIWm89nQu0KKiBr/4JAeHxzCV/1djmbZ0lhdvppVPI2FEpHTOMoClt8Lc9mdZTp24ENDLIUToZlJoqnLGYJl7Huw+Zc/8lu3/WHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317134; c=relaxed/simple;
	bh=hD4FEc334k5p7wS+1EUZv0M3YDlfeRjBdxRkz3ymdlQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=NuE+YnNGg2rKS0lx2xQvyCQZ96TSMvnqm7i3TDR9/qwj9wfrnkb+5m59QFXYDs0pokSk9GpcMsgonwTj2HJwiGId4dE90x9uyBw+7B9WmFzZd3jLT+80il4iZ2OeCL5mgPm8mkyqNiH3fRg0OuxsA6DpD8xcBGqjhWZsKnVeMec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=FDd2vMQK; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="FDd2vMQK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=hD4FEc334k5p7w
	S+1EUZv0M3YDlfeRjBdxRkz3ymdlQ=; h=in-reply-to:references:to:from:
	subject:cc:date; d=arkamax.eu; b=FDd2vMQK2LoTxyh9w8EnDq82IP8B1nNYfoQ4b
	u6BW3U6fQi7iSE9TpLNwfA9zz+Sx9WmhrO1SSUHUjlKNgGShdHtBUAamkN6czrigZPbbfn
	VT8NtHzzA8ONr6PU2fRqmyZmRZnYsvBCkSst8xL8s1FXm0ZbMv52nUYMYUm0yI7Ynki3BS
	rZyoqM+rGGDcb50asDNLl97FQ2z1rEzoSDz2ovng1ca32sTRXt5Exp8X5TmSoHW6G0ICHD
	5nWhzjyKDYkXoIycxDxUsMSx0bVFsA1kQl7dtbZ04Fv6OsSeCKaMlznjG1qip0vL7ekrnJ
	QR5MpouiNBVVwlyeajgPeHBMg==
Received: from localhost (<unknown> [213.175.37.14])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id e4795dec (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 24 Jun 2026 18:05:24 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 18:05:22 +0200
Message-Id: <DJHEOUT0726X.1GXII59NZR3YQ@arkamax.eu>
Cc: "Maurizio Lombardi" <mlombard@arkamax.eu>, "John Meneghini"
 <jmeneghi@redhat.com>, "Maurizio Lombardi" <mlombard@redhat.com>,
 <hch@lst.de>, <chaitanyak@nvidia.com>, <bvanassche@acm.org>,
 <linux-scsi@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
 <James.Bottomley@hansenpartnership.com>, <emilne@redhat.com>,
 <bgurney@redhat.com>
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Hannes Reinecke" <hare@suse.de>, "Keith Busch" <kbusch@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp> <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp> <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
 <ajRpWLqaEyA6cwkJ@kbusch-mbp>
 <531aa19b-a9ae-44f7-82ce-3714621ceee8@suse.de>
 <ajWOWdD0P5ri9bWY@kbusch-mbp>
 <d46493a3-3c9c-4799-bd63-e8759f04463c@suse.de>
In-Reply-To: <d46493a3-3c9c-4799-bd63-e8759f04463c@suse.de>

On Mon Jun 22, 2026 at 9:15 AM CEST, Hannes Reinecke wrote:
>
> In general I fail to see the issue here.
> Any modern distro should be using persistent device links to access
> devices, so the actual device name is pretty much irrelevant.
> We on our side haven't had any issues here since ages.

In principle, I agree with you that persistent links are best practice.
That said, many users still rely on /dev/nvmeXnY links, for example for
some nvme-cli commands. Because kernel 6.11 made these names totally
random across reboots, it's causing some confusion for them.

But yes, I totally understand the reason why you don't perceive this as
an issue.

Maurizio

