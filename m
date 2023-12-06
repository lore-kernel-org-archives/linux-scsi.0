Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9881D682
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL2QO/t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6EDC433C8;
	Wed,  6 Dec 2023 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701881799;
	bh=H7GvUItE9bkpRX6PKJbIM6QvCOjJD4z5/lc3+4b4Xsg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=FL2QO/t3VmbE7QefE+2ODxdzs0DNRX6Jmwr15X1hOcmTt55ioK3q97RG3NI487FdV
	 q+gWSDREEPuudROS6SsFz6APJYxx7QJVda73ioQdlvnqb4SHjweIrdFQYpPXDiuuGR
	 EiG5d9d4iXATomR+CzxJqE0OzLt3DI3KeMaI/RYMdUF54AHLrn3w6x7puheucvXDoy
	 ZVza9Oo1fF6MCFXzy+Ny6/G8dbkRBb9iOKiW74JE3KGYeJdhyv486wbEA3FxSjBsgP
	 PU5+IK7QIZlYQnV9aPR0LyOVujqZYYwTLB2Zw8QsqMLK1IG8ZxTySHRP+CRSh0qMZf
	 01n/I1XMO5s/Q==
Date: Wed, 6 Dec 2023 10:56:37 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Subject: Re: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback
 handlers
Message-ID: <20231206165637.GA717462@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206152513.71253-3-ranjan.kumar@broadcom.com>

On Wed, Dec 06, 2023 at 08:55:11PM +0530, Ranjan Kumar wrote:
> The driver has been upgraded to include support for the
> PCIe error recovery callback handler which is crucial for
> the recovery of the controllers. This feature is
> necessary for addressing the errors reported by
> the PCIe AER (Advanced Error Reporting) mechanism.
> 
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ...

> +static int
> +mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,
> +	struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
> +{
> +	*shost = pci_get_drvdata(pdev);
> +	if (*shost == NULL) {
> +		dev_err(&pdev->dev, "pdev's driver data is null\n");
> +		return -1;
> +	}
> +
> +	*mrioc = shost_priv(*shost);
> +	if (*mrioc == NULL) {
> +		dev_err(&pdev->dev, "shost's private data is null\n");
> +		*shost = NULL;
> +		return -1;

I'm a little bit skeptical about these checks for NULL, although I do
see that the existing code has similar "if (!shost)" checks.

Usually these checks will only find memory corruption or logic errors,
and silently bailing out, as the previous "if (!shost)" checks do,
just masks a serious problem.  Logging errors, as you do here, is a
little better, but I think it's better to just take the exception when
we dereference the NULL pointer later because that's impossible to
ignore and usually gives more clues about what went wrong.

> +}
> +	return 0;
> +}

The addition and use of mpi3mr_get_shost_and_mrioc() looks like it
could be a separate patch.  If so, it might be nice to split this into
several smaller, simpler patches.

>  static int __maybe_unused
>  mpi3mr_suspend(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost;
>  	struct mpi3mr_ioc *mrioc;
>  
> -	if (!shost)
> -		return 0;
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
> +		return -1;

Is -1 really the best return value here?  It seems like usually a
negative errno is returned.

Bjorn
