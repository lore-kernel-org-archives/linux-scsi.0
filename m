Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D22D78B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDz8jSh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A1AC433C7;
	Thu,  4 Jan 2024 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704409865;
	bh=9H25DujCNhRbFNKtP9srcEguMARjH7liYfZmRDtEfBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=kDz8jSh5PtVysGsi6uvaRd94IBfpjhMwSp7Yn4GQnFJ5qxYLhGmlYJQF7Zb42ra5A
	 nYuh1XSF6K/YEraWO2BhKhbsHIRh6Vt8wwY7a1thWRlJGb3VFCE45XoPaDKNh6MWyL
	 SgABe60vH/aNJzKDoq3PAV3ej9jeLWXlDtrrEaSxrkhvHerb+c3REWu3tZov24lv9q
	 9hUXEH9Tm0hdtdIjSoHjduzV56qXO7FrfXO83KW+jXyWpaxVLZwVlcQp+jAeJ3g3ZQ
	 ed7M2pCBficzGP612xpAfsMIFVpTSd0bY2r+JNBwjcB0AKl9Jg7rVfniB2XX44IY8l
	 Cgr7Mi/x8W6Jw==
Date: Thu, 4 Jan 2024 17:11:03 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Subject: Re: [PATCH v2 1/6] mpi3mr: Creation of helper function
Message-ID: <20240104231103.GA1831468@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214205900.270488-2-ranjan.kumar@broadcom.com>

I wasn't cc'd on this series, so apologies if it's already been
applied and these comments are moot.

BTW, the cover doesn't say what this applies to, and it doesn't apply
cleanly to v6.7-rc1.

On Fri, Dec 15, 2023 at 02:28:55AM +0530, Ranjan Kumar wrote:
> Use of helper function to get controller and shost details.
> 
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 54 ++++++++++++++++++++++++++-------
>  1 file changed, 43 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 1bffd629c124..76ba31a9517d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5230,6 +5230,35 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_get_shost_and_mrioc - get shost and ioc reference if
> + *                     they are valid
> + * @pdev: PCI device struct
> + * @shost: address to store scsi host reference
> + * @mrioc: address store HBA adapter reference
> + *
> + * Return: 0 if *shost and *ioc are not NULL otherwise -1.
> + */
> +

Spurious blank line (I see that mpi3mr_probe() has a blank line here,
but most functions in this file do not).

> +static int
> +mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,

Most functions in this file use this style:

  static int mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,

> +	struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
> +{
> +	*shost = pci_get_drvdata(pdev);
> +	if (*shost == NULL) {
> +		dev_err(&pdev->dev, "pdev's driver data is null\n");
> +		return -ENXIO;
> +	}
> +
> +	*mrioc = shost_priv(*shost);
> +	if (*mrioc == NULL) {
> +		dev_err(&pdev->dev, "shost's private data is null\n");
> +		*shost = NULL;
> +		return -ENXIO;
> +		}
> +	return 0;
> +}
> +
>  /**
>   * mpi3mr_remove - PCI remove callback
>   * @pdev: PCI device instance
> @@ -5242,7 +5271,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   */
>  static void mpi3mr_remove(struct pci_dev *pdev)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost;
>  	struct mpi3mr_ioc *mrioc;
>  	struct workqueue_struct	*wq;
>  	unsigned long flags;
> @@ -5250,7 +5279,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>  	struct mpi3mr_hba_port *port, *hba_port_next;
>  	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
>  
> -	if (!shost)
> +	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
>  		return;
>  
>  	mrioc = shost_priv(shost);

Maybe I'm missing something, but it looks like this patch should
remove "mrioc = shost_priv(shost)" every time it adds a call to
mpi3mr_get_shost_and_mrioc().

Bjorn
