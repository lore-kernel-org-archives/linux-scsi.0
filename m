From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
 objects
Date: Mon, 16 May 2016 13:25:11 -0700
Message-ID: <20160516202454.GA2018262@devbig337.prn1.facebook.com>
References: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
 <94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-team@fb.com" <kernel-team@fb.com>, calvinowens@fb.com
List-Id: linux-scsi@vger.kernel.org

On Friday 05/13 at 21:17 +0000, Elliott, Robert (Persistent Memory) wrote:
> 
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Calvin Owens
> > Sent: Friday, May 13, 2016 3:28 PM
> ...
> > Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
> > objects
> > 
> ...
> > The issue is that enclosure_remove_device() expects to be able to re-add
> > the device that was previously enclosured: so with SES running, the order
> > we unwind things matters in a way it otherwise wouldn't.
> > 
> > Since mpt3sas deletes the SAS objects before the SCSI hosts, enclosure
> > ends up trying to re-parent the SCSI device from the enclosure to the SAS
> > PHY which has already been deleted. This obviously ends in sadness.
> > 
> > The fix appears to be simple: just call scsi_remove_host() before we call
> > sas_port_delete() and/or sas_remove_host().
> > 
> ...
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -8149,6 +8149,8 @@ void scsih_remove(struct pci_dev *pdev)
> >  		_scsih_raid_device_remove(ioc, raid_device);
> >  	}
> > 
> > +	scsi_remove_host(shost);
> > +
> >  	/* free ports attached to the sas_host */
> >  	list_for_each_entry_safe(mpt3sas_port, next_port,
> >  	   &ioc->sas_hba.sas_port_list, port_list) {
> > @@ -8172,7 +8174,6 @@ void scsih_remove(struct pci_dev *pdev)
> >  	}
> > 
> >  	sas_remove_host(shost);
> > -	scsi_remove_host(shost);
> >  	mpt3sas_base_detach(ioc);
> >  	spin_lock(&gioc_lock);
> >  	list_del(&ioc->list);
> 
> That change matches the pattern of all other drivers calling
> sas_remove_host, except for one:
> 	drivers/message/fusion/mptsas.c
> 
> That consensus means this comment in drivers/scsi/scsi_transport_sas.c
> is wrong:
> 
> /**
>  * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
>  * @shost:      Scsi Host that is torn down
>  *
>  * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
>  * Must be called just before scsi_remove_host for SAS HBAs.
>  */

Yes, exactly: that comment appears to be backwards, and as you say most
drivers appear to do the opposite (I looked at HPSA at least, which calls
sas_port_delete() before scsi_remove_host()).

I suppose I should send a patch to fix the comment as well? It'd be nice
to get some testing to be certain I'm not breaking somebody else's setup
by fixing mine though...

Thanks,
Calvin
