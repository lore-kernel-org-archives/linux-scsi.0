From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: ufs: select CONFIG_NLS
Date: Tue, 22 Mar 2016 15:18:27 +0100
Message-ID: <6292485.RzKll8UR2a@wuerfel>
References: <1458217819-2802119-1-git-send-email-arnd@arndb.de> <1458646999.2408.3.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60670 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbcCVOSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 10:18:55 -0400
In-Reply-To: <1458646999.2408.3.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday 22 March 2016 07:43:19 James Bottomley wrote:
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > index 5f4530744e0a..097894a1fab5 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > @@ -37,6 +37,7 @@ config SCSI_UFSHCD
> >       depends on SCSI && SCSI_DMA
> >       select PM_DEVFREQ
> >       select DEVFREQ_GOV_SIMPLE_ONDEMAND
> > +     select NLS
> 
> This looks like a bad solution: CONFIG_NLS is nothing more than a menu
> selector for the NLS subsystem.

It's a bit of both: CONFIG_NLS by itself controls the compilation of
the fs/nls/nls_base.c file, which has the definition of the utf16s_to_utf8s
function called by this driver. The same file also contains the
NLS subsystem with the register_nls/unregister_nls/unload_nls/load_nls
APIs that are used by the other files.

>  The problem is that selecting it will
> allow a kernel to be build with NLS and without NLS_DEFAULT which is
> going to cause all sorts of interesting problems on boot.  I think you
> really mean depends on NLS here.

I agree that 'depends on NLS' makes more sense here, however I was
just following what all other users of the API are doing. Mixing
'select' and 'depends on' can easily lead to circular dependencies,
and I was trying to avoid that.

A cleaner solution is probably to split out the utf16 access functions
from the NLS subsystem, and have all these files that currently
'select NLS' pick that other interface (or both, if necessary) instead:

drivers/acpi/device_sysfs.c
drivers/hid/hid-cp2112.c
drivers/hv/hv_fcopy.c
drivers/hv/hv_kvp.c
drivers/net/fjes/fjes_main.c
drivers/net/hyperv/rndis_filter.c
drivers/pci/pci-label.c
drivers/scsi/ufs/ufshcd.c
drivers/usb/core/message.c
drivers/usb/gadget/configfs.c
drivers/usb/gadget/u_os_desc.h
drivers/usb/gadget/usbstring.c
fs/cifs/cifs_unicode.c
fs/fat/dir.c
fs/fat/namei_vfat.c
fs/isofs/joliet.c

Not sure if that's worth the work though.

	Arnd
