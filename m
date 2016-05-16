From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY objects
Date: Mon, 16 May 2016 15:51:48 -0600
Message-ID: <f6e9d525a6435464bfa53bf7884b956f@mail.gmail.com>
References: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
 <94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net> <20160516202454.GA2018262@devbig337.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35640 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbcEPVvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 17:51:50 -0400
Received: by mail-io0-f175.google.com with SMTP id d62so340478iof.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2016 14:51:50 -0700 (PDT)
In-Reply-To: <20160516202454.GA2018262@devbig337.prn1.facebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Our understanding is the relationship between the SCSI host and SAS end
devices is a parent-child and before ripping of SCSI host we need to rip of
all the children. Why the enclosure ends up trying to re-parent the SCSI
device from the enclosure to the SAS PHY even after we remove the SAS Phy?.
Doesn't this need to be taken care in enclosure_removal?

-----Original Message-----
From: Calvin Owens [mailto:calvinowens@fb.com]
Sent: Monday, May 16, 2016 2:25 PM
To: Elliott, Robert (Persistent Memory)
Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen; MPT-FusionLinux.pdl@broadcom.com;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
kernel-team@fb.com; calvinowens@fb.com
Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
objects

On Friday 05/13 at 21:17 +0000, Elliott, Robert (Persistent Memory) wrote:
>
>
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Calvin Owens
> > Sent: Friday, May 13, 2016 3:28 PM
> ...
> > Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS
> > PHY objects
> >
> ...
> > The issue is that enclosure_remove_device() expects to be able to
> > re-add the device that was previously enclosured: so with SES
> > running, the order we unwind things matters in a way it otherwise
> > wouldn't.
> >
> > Since mpt3sas deletes the SAS objects before the SCSI hosts,
> > enclosure ends up trying to re-parent the SCSI device from the
> > enclosure to the SAS PHY which has already been deleted. This obviously
> > ends in sadness.
> >
> > The fix appears to be simple: just call scsi_remove_host() before we
> > call
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
> >  	   &ioc->sas_hba.sas_port_list, port_list) { @@ -8172,7 +8174,6 @@
> > void scsih_remove(struct pci_dev *pdev)
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

I suppose I should send a patch to fix the comment as well? It'd be nice to
get some testing to be certain I'm not breaking somebody else's setup by
fixing mine though...

Thanks,
Calvin
