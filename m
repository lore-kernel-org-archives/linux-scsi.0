Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51390361DA9;
	Wed, 17 Jun 2026 12:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699006; cv=none; b=R5jcixvtV6IP6jHARJvbiDXxnPXJk/rjX0rr6eIZARK1xDqyaPq7Wxmd+dMhMhWUd3AtWJ8KdokhlbCNhi3SbS0AWb6yjkgzyDlcKPnss27MUowt/ftbPjh+NDYiSwyzUC13Jrwg5VPySC5EenhKsye4g0s/AFI/R5M+7VaEQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699006; c=relaxed/simple;
	bh=5RbA+tX2kQ+wZxXaXRIEm6oD8ttFYPmNhgiuFqp7HTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVQ5EGuryMXV5ER1DhzTDpYeufVf74Qbf2jbg0umPlIKZL2tOmwJSQvvXnJz0Uf1RN7Gdw1Fu2CVmZVzfky+b0hJFhGRq8fqEcOCV6gKbgcy3vmob6NmgYrhOyzARJrV0ut30BpTrMKi51Nq6/nOZVCuwEHaKHQGBwnE/YJ1SM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAo5bRax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAo5bRax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A49E1F00A3D;
	Wed, 17 Jun 2026 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781699004;
	bh=Ot/c8lwjvhLeZWxA3+DaMNSQ9qONQIaJvYOVqx8ET9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IAo5bRaxt/5kzb3/AJe7/9HMRyQNHQZKWzBJWVFsFI3dO4JZM7EO+pYhwDcrMOUyg
	 Zw8ak+guDYxKfQoFYQfqWTWk4DNXekG6TQaz5cZqhIIzJ/kGya97jeFlCqB34a4hwR
	 Xkp9WahoE080Z3NstFA4agkiIxskNh2D5mEYq4EckKU0AKzsSZaaDbH2vAtbTlUaDa
	 K1HfW7UKrdy6ZCey3XqJRCIov7lVvJO7SLJ4x6Ewr1vmI50B5+3Nnoe32vXgFoWGkz
	 Xr40gvyAmC33d6KX0DvSAD2vXJ1AMvPQd0kOPOnalVLPVsZGnmpy9IFng/zREzaTIl
	 tA1K/RwhX+Q8w==
Date: Wed, 17 Jun 2026 14:23:20 +0200
From: Niklas Cassel <cassel@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
Message-ID: <ajKRuNWBXCHCFiRT@ryzen>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
 <20260608213443.2296614-5-philpem@philpem.me.uk>
 <yq1cxxrwatv.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1cxxrwatv.fsf@ca-mkp.ca.oracle.com>

Hello Martin,

On Mon, Jun 15, 2026 at 09:09:20PM -0400, Martin K. Petersen wrote:
> 
> Phil,
> 
> > Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
> > PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
> > normally adds such devices (PQ=0 means "connected"), producing
> > spurious "No Device" entries.
> >
> > The scsi_target field pdt_1f_for_no_lun already exists to suppress
> > this, but was previously only set by the USB UFI driver.
> >
> > Add BLIST_NO_LUN_1F so the flag can be set per-device from
> > scsi_devinfo, and wire it up in scsi_add_lun() to set
> > starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
> > during LUN 0 processing, before the sequential LUN scan probes
> > higher LUNs.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Thank you for reviewing!

There was already a v7 out when your sent your review:
https://lore.kernel.org/linux-ide/20260611024356.2769320-1-philpem@philpem.me.uk/T/#t

It looks like this patch [4/6] was modified in v7.
Patch [6/6] appears unmodified.


Kind regards,
Niklas

