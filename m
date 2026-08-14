Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C9E2F8EA5;
	Fri, 14 Aug 2026 02:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786674398; cv=none; b=NZ9VaTmvkgHGerRZSmFoaMFIqxd5jSoIF6Bt60y1Or42Th65dWY5k0uAM24t4/0cQCnvO22ittyfUiUF7tqRksCzsfiNJVrX0Ga9hKyaa15LcEs9BT/SqlJC4zD82SsaeDC2N++68VBmdMnT8mah77tKx0XxmxQyzuQp2qrvVF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786674398; c=relaxed/simple;
	bh=z8DS6XCve6v5wbnhikZbnUlwrT4lkvGlBeYv0TGsfAM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=gOsRCqTD40AcPjRC/6+JZVryMayqXihEJvSfpDcSYWaFK4XVjmsuPxtHlWGcNGCsYyyTMLX+yHDBUIw33/tyKLdHcIL0dPrmfxEiAg0Zj/S3ACmSPomjnUQ4/V6++FAGWUKh3CC2v7rGWDKf8mDPIMTh3JHLpl/qKgsBeI99ZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiH4m3Q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiH4m3Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5A21F000E9;
	Fri, 14 Aug 2026 02:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786674397;
	bh=io6LPOi8RyNkKPDOzUdSmPRj7b+Vc0KXnibJV631eAU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=MiH4m3Q58wlggJ9coFwNAnW3VsWHAgFa5ylMIo5xq3j4gtDqkK23GhZtzXn2osdx+
	 mmTo0+kv+PorQTQJu5TEqMsjDE5iu9s2CW27ZLqtmOMHFPZHmGjeG9h9Mc6pXN2uEa
	 QKOE7qt+W6BA/No3bHfWpKFyFNeEOvMsGCI/slZo4vzOAwiAzrvp1MOG/zQVsnJeiA
	 WLYhJ0rRfmKxviavsh70zsebfeTt8Ca5JZsw3vQMYPBpK8JuEoGL9YcFiUH/9d/DTu
	 N9XBOW4n6UYuIaoiG5Leul2EMjhr60k5jldkByDHxLEnCbQZT41dohHq7TpiPAuSYy
	 +y9XhrSHMNwvw==
To: John Garry <john.g.garry@oracle.com>
Cc: <James.Bottomley@HansenPartnership.com>,  <martin.petersen@oracle.com>,
  <linux-scsi@vger.kernel.org>,  <bvanassche@acm.org>,
  <linux-s390@vger.kernel.org>,  <linux-ide@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linuxppc-dev@lists.ozlabs.org>,
  <linux-usb@vger.kernel.org>,  John Garry <john.garry@linux.dev>,  Damien
 Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v3] scsi: core: Drop Scsi_Host.default_lock
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260810145236.384239-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 10 Aug 2026 14:52:36 +0000")
Message-ID: <yq15x1dtp3r.fsf@mail.kernel.org>
References: <20260810145236.384239-1-john.g.garry@oracle.com>
Date: Thu, 13 Aug 2026 22:26:35 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi John!

> However, support for this has long been removed, so drop
> Scsi_Host.default_lock and make Scsi_Host.host_lock as the actual
> lock.

Clashes with Bart's context analysis series. Please rebase, thanks!

-- 
Martin K. Petersen
