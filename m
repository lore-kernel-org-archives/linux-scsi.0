Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3B52E0B5F;
	Mon, 13 Oct 2025 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760341553; cv=none; b=dCr6Vu1rAuEFQUMv0tSvqOAUYTt4q3JoInJv7NOP5vqF4NODZCIB7H4U46mmtj2Y9/ewgloxrKtYG0IFO5TWS0KdoG+/Ym/ChocoY6bTG9lb+dOLCbJPTdRfEXKNP1RZAt5/f/PG5Fr5n5wWQFHgsB6eDVmY0UpcINbQDbcV3Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760341553; c=relaxed/simple;
	bh=L9JV7fQgZkyT5akfcPN+oJ4PhIkfXdiyw9XSCV7QzCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxMqNBL9Pslxk3yHT1cywUQSstHZyEFpuavSjF3wi3O0qqSd//vVLnmZb9r/KPYhVepYSFAsd9tRAWXsJr4ENoY+dNQRHBTB9VESp+7whoNlWNxUlEJ4tb8fUimyA9Q+JasVR1FfATqwzThGtVMbj1W4V2feYOIskGJSlGcZEUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUgNQzAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUgNQzAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED5EC4CEE7;
	Mon, 13 Oct 2025 07:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760341553;
	bh=L9JV7fQgZkyT5akfcPN+oJ4PhIkfXdiyw9XSCV7QzCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUgNQzAwIuBEb71+WMCsaM1S1OQ0t1C7M1cv3E+mSGpNfcO4j4Uld4s/QRSXLoixE
	 ROpTAPYJosf5G7r3IY0N2SQ4XKDgRs2Y4q9CnvLAa7X3PCkaa0EydLnrIMXrFTyG6/
	 NdHUkhLdcO8dFSGyLTX6yjhqegq26Ri4OF7nbso7OlP5Ys9Bi3Go6Iec78kD1oncmI
	 DOFTOzOKOphX3rkEujiTtjOZi27E84rjv1BJK682IGjZcJi18U8dlPxlMpRyN9XHK1
	 WvIv98beOGjc1ZOWgKrRvtlKWjNizAwiQ0uGtHWl0pXF+C+PNE+1Sq9VaHSw4ZxDFo
	 9OtljQ9dRn77A==
Date: Mon, 13 Oct 2025 09:45:48 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] scsi: sd: Add manage_restart device attribute to
 scsi_disk
Message-ID: <aOyuLCEDJxJS76nN@ryzen>
References: <20251010223817.729490-1-markus.probst@posteo.de>
 <20251010223817.729490-2-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010223817.729490-2-markus.probst@posteo.de>

On Fri, Oct 10, 2025 at 10:38:34PM +0000, Markus Probst wrote:
> In addition to the already existing manage_shutdown,
> manage_system_start_stop and manage_runtime_start_stop device
> scsi_disk attributes, add manage_restart, which allows the high-level
> device driver (sd) to manage the device power state for SYSTEM_RESTART if set to 1.

The commit message explains what is done, but does not answer the question:
"why?"

I can read patch 2/2 and understand why, but considering that this is a patch
for SCSI and not ATA, I think that you need to provide some context here, so
that someone doing a git log drivers/scsi/ will actually have any idea of why
this was done.


Kind regards,
Niklas
