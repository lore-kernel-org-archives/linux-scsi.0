Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9369B27381C
	for <linux-scsi@vger.kernel.org>; Tue,  5 Aug 2025 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399258; cv=none; b=lvozcibmOeBTpfYYS+bE2MpZOmUav9FRHHyK0z73CXk57siTXKBJxYETKdJKBlBBScQvXBMWFvrVroYfoUyhWXD5dKG89oNO+w02vKH8nx1YLUE6iNo2PMWAH9oSLDot+YLY8BnWGYnuj5Zd5y0hrKRtsE6vCN/pj93nR66vyv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399258; c=relaxed/simple;
	bh=Nx+HG52Xy2f7DBk6DrUGLe9XUErsJVSHWb3eiwygXNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dm3NgNOOp+UAV1XKtR7gsL6l3Td1qD9HAjj4cTjWDLzeJIzt3QGM2TA3HBlYKd+iSLLVYCTSyr9OnGEpO9HQKj/twbn1YOOnnweStxRUGkkPyCPNQptCW85GE7EFW4ElYZe8tICV+N1lsL1+Ar89vaIs0hCeYBnbQBpkZA5VywA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 4A9B42C06644;
	Tue,  5 Aug 2025 15:07:27 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 43AA620DEFE; Tue,  5 Aug 2025 15:07:27 +0200 (CEST)
Date: Tue, 5 Aug 2025 15:07:27 +0200
From: Lukas Wunner <lukas@wunner.de>
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 18/31] elx: efct: Driver initialization routines
Message-ID: <aJICD3jH6gZ7RuI9@wunner.de>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
 <20210601235512.20104-19-jsmart2021@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601235512.20104-19-jsmart2021@gmail.com>

On Tue, Jun 01, 2021 at 04:54:59PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Emulex FC Target driver init, attach and hardware setup routines.

The above was committed as 4df84e846624 ("scsi: elx: efct: Driver
initialization routines").

Just noticed the following while inspecting the pci_error_handlers
of this driver:

When handling a Fatal Error, after a Secondary Bus Reset has been
performed to recover from the error, efct_pci_io_slot_reset()
calls efct_device_detach() + efct_device_attach():

> +static pci_ers_result_t
> +efct_pci_io_slot_reset(struct pci_dev *pdev)
> +{
[...]
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}

And then efct_pci_io_resume() does the same *again*:

> +static void
> +efct_pci_io_resume(struct pci_dev *pdev)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +}

Is that intentional / really needed?  It would seem to me that
the calls to efct_device_detach() + efct_device_attach() in
efct_pci_io_slot_reset() are superfluous.

Am I missing something?

Thanks,

Lukas
