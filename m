From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Wed, 12 Feb 2014 11:43:08 -0500
Message-ID: <20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>
References: <52EC60C3.1080103@gentoo.org>
	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>
	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: "prometheanfire@gentoo.org" <prometheanfire@gentoo.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sreekanth,

There hasn't been much recent activity in
drivers/scsi/scsi_transport_sas.c, so I wasn't sure who could best
review the patch.

Dan Williams added sas_rphy_unlink() back in 2011, perhaps he can
remember why sas_bsg_remove wasn't performed there?

Regards,

-- Joe


On Wed, 12 Feb 2014 11:43:58 +0000
"Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com> wrote:

> Hi Joe,
> 
> May I known the status of this patch having subject
> "[PATCH] scsi_transport_sas: move bsg destructor into sas_rphy_remove".
> 
> I need the status of this patch as I am also observing the same WARNING call trace on latest 3.14.0-rc2+ kernel whenever we unload the mpt2sas/mpt3sas driver or whenever we unplug the drive attached to the HBA.
> But after applying yours patch, these WARNING call trace is not observed.
> 
> Regards,
> Sreekanth
> 
> >-----Original Message-----
> >From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
> >Sent: Monday, February 03, 2014 7:54 PM
> >To: prometheanfire@gentoo.org
> >Cc: Nandigama, Nagalakshmi; Reddy, Sreekanth; Support; DL-MPT Fusion
> >Linux; linux-scsi@vger.kernel.org; JBottomley@parallels.com; linux-
> >kernel@vger.kernel.org; kernel@gentoo.org
> >Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
> >
> >On Fri, 31 Jan 2014 20:49:39 -0600
> >Matthew Thode <prometheanfire@gentoo.org> wrote:
> >
> >> I decided to pull a drive while it was in use out of laziness (it was
> >> open via luks, but not in actual use).  Got a fun trace as a result.
> >> Just thought you'd like to know :D
> >>
> >
> >Hi Matthew,
> >
> >The first trace looks a lot like what I see on mpt2sas driver removal [1].  I
> >posted a suggested fix back in Dec [2], which you might try, however it is not
> >reviewed at this point.
> >
> >[1] http://thread.gmane.org/gmane.linux.scsi/86237
> >[2] https://github.com/joe-
> >lawrence/linux/compare/scsi_transport_sas_sysfs_warning.patch
> >
> >Regards,
> >
> >-- Joe
> 
