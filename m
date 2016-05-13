From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
 objects
Date: Fri, 13 May 2016 21:17:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net>
References: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-team@fb.com" <kernel-team@fb.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Calvin Owens
> Sent: Friday, May 13, 2016 3:28 PM
...
> Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
> objects
> 
...
> The issue is that enclosure_remove_device() expects to be able to re-add
> the device that was previously enclosured: so with SES running, the order
> we unwind things matters in a way it otherwise wouldn't.
> 
> Since mpt3sas deletes the SAS objects before the SCSI hosts, enclosure
> ends up trying to re-parent the SCSI device from the enclosure to the SAS
> PHY which has already been deleted. This obviously ends in sadness.
> 
> The fix appears to be simple: just call scsi_remove_host() before we call
> sas_port_delete() and/or sas_remove_host().
> 
...
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -8149,6 +8149,8 @@ void scsih_remove(struct pci_dev *pdev)
>  		_scsih_raid_device_remove(ioc, raid_device);
>  	}
> 
> +	scsi_remove_host(shost);
> +
>  	/* free ports attached to the sas_host */
>  	list_for_each_entry_safe(mpt3sas_port, next_port,
>  	   &ioc->sas_hba.sas_port_list, port_list) {
> @@ -8172,7 +8174,6 @@ void scsih_remove(struct pci_dev *pdev)
>  	}
> 
>  	sas_remove_host(shost);
> -	scsi_remove_host(shost);
>  	mpt3sas_base_detach(ioc);
>  	spin_lock(&gioc_lock);
>  	list_del(&ioc->list);

That change matches the pattern of all other drivers calling
sas_remove_host, except for one:
	drivers/message/fusion/mptsas.c

That consensus means this comment in drivers/scsi/scsi_transport_sas.c
is wrong:

/**
 * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
 * @shost:      Scsi Host that is torn down
 *
 * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
 * Must be called just before scsi_remove_host for SAS HBAs.
 */
