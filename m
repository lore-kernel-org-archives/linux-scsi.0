From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 16:08:54 -0600
Message-ID: <20041110220854.GB28524@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:42120 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262063AbUKJWJF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 17:09:05 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Nov 10, 2004 at 04:25:14PM -0500, Mukker, Atul wrote:
> >    original reason for splitting megaraid_mm and megaraid_mbox.  This
> >    driver is necessary for Chris's other older hardware.
> >    PCI 101e:9010, aka PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_MEGARAID
> > 
> This is not entirely correct. We initially planned to have SAS RAID drivers
> under the 2.20 umbrella, not IO based controllers.

I stand corrected, thanks.

 
> Now coming back to the original question of non-flexibility of having both
> drivers:
> 
> We do not want to have someone configure both drivers to load since legacy
> megaraid not only supports the older controllers, it _can_ take ownership of
> the newer ones as well, causing 2.20 to fail to load for those controllers.
> Also, management applications are written with a view of only one driver
> concept. These cannot interface with 2 drivers. So, in order to force one
> driver - Kconfig is written in this particular way.
> 
> Now, this can be easily changed, and we are definitely flexible to let user
> compile both drivers. This should work as long as user makes sure to load
> -_only one_ of these at any time. (suggestions?)

How about you remove all the PCI IDs from the 2.00.3 driver that the
2.20 driver handles, so that they're mutually exclusive again?

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
