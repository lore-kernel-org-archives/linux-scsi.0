Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A1374E71
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781718130; cv=none; b=SWqgSEcHLRuboXlfR3ALhlVHR2rbh6JvHspoLwVmww7pYFkt6GzL3KZ0BqXvSQtfklAKpHXq5JPH5697a6X2nzBvKrR4zmTKWcxsdp6iBsqAviixYMHl3RnxxpDGyqwxtfkGc0c31+hDSoCIoZttNOl4un2hu9oe7QzdBd3XWYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781718130; c=relaxed/simple;
	bh=kvFAel3hT2aCpodG8ZLF82cEweXUConelsw4C01uKcs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=hAtDHxgL0GVWT3qK5Ke7qLrfG5GVUcKXtlWn0IgG7pbcBmkeP48BQLGGAqF++ktHD5V86H4Ufnvt+avVx/blVZbi0i1KnWO8YzUaQY6EBLwnqivdAEzbHdUr9nFWDYrpskaBXTVtzpHETYGzZ0EBQpFi0IfyJZ20xl8So2UbHHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=bXoC4Q/+; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="bXoC4Q/+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=kvFAel3hT2aCpo
	dG8ZLF82cEweXUConelsw4C01uKcs=; h=in-reply-to:references:cc:to:from:
	subject:date; d=arkamax.eu; b=bXoC4Q/+g8Q3M+9xsufKiMepSkRrdEDbRettbEIo
	oajAncUGQUldjtbTqy8AhgaD+HzaJ8QAADRQLRGqczE7okLXDvig4Lz48/IDg02y89IFTn
	aTC1piz2s2ajSiFnh3J6Uh04E6UkdMVY3aAY/f0eViV1SAUmSuFSkyI51WBtjCEcArizU6
	Indz+Zmt8umniFjDZwXlzbVabHvL5eQl/dIbD35xX5+nzG7/wTIUg6yIJOK6m779E0ggwU
	MTPmbT21rydTl7O6YryJVEvIA8szKEy2Cw0XS1TxVmkemKpOysUEmNO4nEug2IAp4bjEMD
	32RESfS9GtpbnrzxVpIVAQ==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 52c4389b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 17 Jun 2026 19:41:58 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 19:41:58 +0200
Message-Id: <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Keith Busch" <kbusch@kernel.org>, "Hannes Reinecke" <hare@suse.de>
Cc: "John Meneghini" <jmeneghi@redhat.com>, "Maurizio Lombardi"
 <mlombard@arkamax.eu>, "Maurizio Lombardi" <mlombard@redhat.com>,
 <hch@lst.de>, <chaitanyak@nvidia.com>, <bvanassche@acm.org>,
 <linux-scsi@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
 <James.Bottomley@hansenpartnership.com>, <emilne@redhat.com>,
 <bgurney@redhat.com>
X-Mailer: aerc 0.21.0
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp> <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp>
In-Reply-To: <aaXE4s3AT45UIAN8@kbusch-mbp>

Hello Keith,

On Mon Mar 2, 2026 at 6:12 PM CET, Keith Busch wrote:
> On Mon, Mar 02, 2026 at 08:16:19AM +0100, Hannes Reinecke wrote:
>> I really would like to go with the nsid based solution from Keith.
>> That would avoid quite some cumbersome code here.
>
> I've seen various documentation that assumes the current naming
> indicates the nsid, so the scheme follows at least some people's
> expectations. I don't know if we can make everyone happy here, though.
> :(
>
> I've fixed up most of the multipath races that get us closer to allowing
> nsid suffix, but there's one left: nvme_remove_head is called outside
> the subsys lock after detaching the head from the subsystem list. That
> could cause a subsequent add event to call nvme_alloc_ns() before the
> mpath side has completed del_gendisk() for the old nsid.

Did you manage to find a solution for this race?
I just wanted to check whether you had any patches ready for testing since
this discussion.

Thanks,
Maurizio
