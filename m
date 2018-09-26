From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Wed, 26 Sep 2018 16:32:41 -0500
Message-ID: <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, lukas@wunner.de, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[+cc LKML]

On Wed, Sep 26, 2018 at 09:52:34AM +0530, Suganath Prabu S wrote:
> * Driver uses "pci_device_is_present" to check whether
> If Hot unplugged:
> the outstanding IOs with 'DID_NO_CONNECT' before removing the drives
> attached to the HBA.

This sentence needs a verb.

> "DID_NO_CONNECT" status and free the smid, if driver detects that
> HBA is hot unplugged.

This sentence also needs a verb.

> * In the hard reset flush out all the outstanding IOs even if diag reset
> fails and also if driver detects that HBA is hot unplugged.
> 
> v1 change set:
> ==============
> unlock mutex before goto "out_unlocked",
> if active reset is in progress.
> 
> v2 change set:
> ==============
> 1) Use pci_device_is_present instead of
> mpt3sas_base_pci_device_is_unplugged.
> 2) As suggested by Lukas, removed using
> watchdog thread for checking hba hot unplug(Patch 02 of V1).
> Added Hot unplug checks in scan finish and reset paths.
> 
> v3 Change Set:
> =============
> Simplified function "mpt3sas_base_pci_device_is_available" and
> made inline.
> 
> v4 Changes:
> ===========
> Dont split strings in print statement.
> 
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 39 ++++++++++++++++++++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ++-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 50 ++++++++++++++++++++++++++++++++----
>  3 files changed, 86 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 59d7844..c880e72 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -543,6 +543,20 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>  }
>  
>  /**
> + * mpt3sas_base_pci_device_is_available - check whether pci device is
> + *			available for any transactions with FW
> + *
> + * @ioc: per adapter object
> + *
> + * Return 1 if pci device state is up and running else return 0.
> + */
> +inline bool
> +mpt3sas_base_pci_device_is_available(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	return !ioc->pci_error_recovery && pci_device_is_present(ioc->pdev);
> +}
> +
> +/**
>   * _base_fault_reset_work - workq handling ioc fault conditions
>   * @work: input argument, used to derive ioc
>   *
> @@ -6122,6 +6136,11 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
>  
>  	count = 0;
>  	do {
> +		if (!pci_device_is_present(ioc->pdev)) {
> +			ioc->remove_host = 1;
> +			pr_err(MPT3SAS_FMT "Hba Hot unplugged\n", ioc->name);

You capitalized as "HBA" above.

> +			goto out;
> +		}
>  		/* Write magic sequence to WriteSequence register
>  		 * Loop until in diagnostic mode
>  		 */
> @@ -6853,6 +6872,13 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
>  
>  	ioc->pending_io_count = 0;
>  
> +	if (!mpt3sas_base_pci_device_is_available(ioc)) {
> +		pr_err(MPT3SAS_FMT
> +		    "%s: pci error recovery reset or pci device unplug occurred\n",
> +		    ioc->name, __func__);
> +		return;
> +	}
> +
>  	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);

This is a good example of why I don't like pci_device_is_present(): it
is fundamentally racy and gives a false sense of security.  Here we
*think* we're making the code safer, but in fact we could have this
sequence:

  mpt3sas_base_pci_device_is_available()    # returns true
  # device is removed
  ioc_state = mpt3sas_base_get_iocstate()

In this case the readl() inside mpt3sas_base_get_iocstate() will
probably return 0xffffffff data, and we assume that's valid and
continue on our merry way, pretending that "ioc_state" makes sense
when it really doesn't.

>  	if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
>  		return;

Bjorn
