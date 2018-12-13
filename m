From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH] scsi: ufs: revamp string descriptor reading
Date: Thu, 13 Dec 2018 20:31:19 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B9DA525B5@hasmsx108.ger.corp.intel.com>
References: <20181211110705.11646-1-tomas.winkler@intel.com>
 <DM6PR04MB4923D16D47784A1750811A19FCA60@DM6PR04MB4923.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM6PR04MB4923D16D47784A1750811A19FCA60@DM6PR04MB4923.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Hunter, Adrian" <adrian.hunter@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vivek Gautam <vivek.gautam@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Alex Lemberg <Alex.Lemberg@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Avri Altman [mailto:Avri.Altman@wdc.com]
> Sent: Tuesday, December 11, 2018 18:18
> To: Winkler, Tomas <tomas.winkler@intel.com>; James E . J . Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; Vinayak Holikatti <vinholikatti@gmail.com>;
> Hunter, Adrian <adrian.hunter@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>; Vivek Gautam
> <vivek.gautam@codeaurora.org>; Subhash Jadavani
> <subhashj@codeaurora.org>; Alex Lemberg <Alex.Lemberg@wdc.com>; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] scsi: ufs: revamp string descriptor reading
> 
> Hello Tomas,
> 
> >
> > Define new a type: uc_string_id for easier string handling and less
> > casting. Reduce number or string copies in price of a dynamic
> > allocation.
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Tested-by: Avri Altman <avri.altman@wdc.com>
> 
> Just one nit - doesn't really matters.
> 
> Cheers,
> Avri
> 
> > ---
> >  drivers/scsi/ufs/ufs-sysfs.c |  20 ++---
> >  drivers/scsi/ufs/ufs.h       |   2 +-
> >  drivers/scsi/ufs/ufshcd.c    | 164 +++++++++++++++++++++--------------
> >  drivers/scsi/ufs/ufshcd.h    |   9 +-
> >  4 files changed, 115 insertions(+), 80 deletions(-)
> 
> 
> >
> >  	ufs_fixup_device_setup(hba, &card);
> > +	ufs_put_device_desc(&card);
> ufs_get_device_desc() and ufs_put_device_desc() actually serves the quirks
> setup.
> Make sense to call it from within so the logic is clear and in one place.
> Might also save ufs_put_device_desc().

You are right from the current perspective , just I'd need it also for the RPMB  patches that should follow,  
then it will have bit larger span than the quirks.

Thanks
Tomas
 
 
