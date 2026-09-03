Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA442DEA61;
	Thu,  3 Sep 2026 09:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426933; cv=none; b=HvpfHUgWwPUHtmdsap8Sr2Nszka1RZFtn20rSrucRIU/i6lSIRwM3aEmhPWhJhKTc93kSt51ZWiLk48i3BcpiSyZf8lpdo/+gElp2oy/e2j6FH28Zwc0QVdvwcrTKe1cBvgqg8vbpvPWY9ZuCuadyDamZy9G/EbK1+8m70fvRQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426933; c=relaxed/simple;
	bh=m7H8TekOSG4qos5vPIPxVNKUjiw0Ygyq7vH0ZgiEr8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bb/JXN5dd/rrVAiHEZrRrVh0Jpc/CVchY2C2wpUED2mosbl7Bg0VRc4/L4HGg35chVMYJKM4qBC+LbWEzpRsBydL3Joncn24PL3b5KgNcs8R200jaYjGMvhiH436xv0UtyLb4VtYekqhdRuuBEnrvJZnVTwM1hgIFSGYdN5iVK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrCbQwxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrCbQwxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A2E1F000E9;
	Thu,  3 Sep 2026 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788426931;
	bh=x2LmtDPoQQAqRYsbmaLvBhgbgEQtElpqcQehovTbr9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RrCbQwxRxTr0kOnpHqghHXmh0MsR0a/mkb+rslwZhV6bNToULfBYV6Dh3pE9HI+YT
	 Lse4DYVV4yXCARTQhtkkYZ975+RZtId9h1yVwqwg2HbMk0kshQc+M69VnmBFfJfB5f
	 /9boofSb0/EcIya7qqNdogJkxthRYaCqwiRNKHDa3KR1F+a/XMq/RUzpHSK3RVh5Oa
	 rZSgLSog8YBD1W05YV8RuaLMIZKoaeWwapK4aL9iC2QE0KNgAeRgRQKHSRVJixtlOF
	 fcE0eBiJ4j6kjSzHitsmsK+lOFFSiX+9thOj0OWhcZ179Wxw+pySJVdiUpzeWnyA8e
	 RCL/f0nR6B0dg==
Date: Thu, 3 Sep 2026 11:15:27 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v2 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Message-ID: <apk6r6Ad3QB872f6@ryzen>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-41-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903034201.112211-41-dlemoal@kernel.org>

On Thu, Sep 03, 2026 at 12:42:01PM +0900, Damien Le Moal wrote:
> Now that all code has been converted to use 16-bits sense codes and to
> initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
> the inline definitions of these new functions, change scsi_build_sense()
> and scsi_build_sense_buffer() to use a single 16-bits sense code as
> argument (instead of separate arguments for the ASC and ASCQ), and
> rename them to scsi_set_sense()  and scsi_set_sense_buffer().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>


With the trivial kdoc nit for scsi_set_sense() pointed out by Sashiko fixed:

Reviewed-by: Niklas Cassel <cassel@kernel.org>
