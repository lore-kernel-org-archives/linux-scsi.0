From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.2
Date: Mon, 1 Dec 2003 15:38:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031201153806.A4012@infradead.org>
References: <20031128120338.A8954@infradead.org> <002b01c3b7f8$5e6fbf20$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:2319 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262965AbTLAPiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 10:38:07 -0500
Content-Disposition: inline
In-Reply-To: <002b01c3b7f8$5e6fbf20$a0074d0a@apac.cisco.com>; from surekhap@cisco.com on Mon, Dec 01, 2003 at 04:16:25PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Naveen Burmi' <naveenb@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Mon, Dec 01, 2003 at 04:16:25PM +0530, Surekha.PC wrote:
> >please don't add an attribute group, just use the shost_attrs field in
> the host template.
>  
> Can you please let me know why we should not use attribute group? Isn't
> it recommended for the driver writers to use it?

I don't think so.  At least that's not how we designed the sysfs
interface for scsi.

> >iscsi_show_device() doesn't look like a good idea,what about adding an
> iscsi pseudo 
> device as parent to identify the device as iscsi in sysfs?
> 
> iscsi_show_device() creates sysfs file "device_type" which is checked
> while parsing "udev.config" for iSCSI device activation. Since device
> attributes like vendor, model etc reside in this directory, isn't it ok
> to have it here?

Well, the big question is what exactly does this device_type field
mean.  Currently it's only implemented for iscsi so rather meaningless.
What do you think would be the values for other types of HBAs (plain
parallel scsi, firewire/sbp2, usb-storage, fc, ide-scsi, sata?).

IMHO the better choice would be to implement a fake iscsi bus in
the driver model, then you'll just have to look what bus your
host resides on in sysfs.

> If not, would like to know what field we need to use, for adding iscsi
> peusdo device as parent, I doubt this can be done with shost_attrs and
> sdev_attrs of host template.   

just setup a bus_type for iscsi, create a fake struct device for it
(see scsi_debug.c for examples) and hand it as second argument to
scsi_add_host.

> >This whole find_keyword business is not good.  sysfs files are supposed
> to have a single >value.  We should probably do some brainstorming on
> the right API for this..
> 
> Our driver has lot of user space attributes. Making each attribute as a
> separate file will endup with lots of files.

Yes.

> So we want to have all
> target specific attributes together in one file and lun specific
> attributes in another file for convinience. find_keyword() will help
> search for these keys from the cmdline specified.

Well, the whole point of sysfs is to get out of the procfs debacle
by having a defined, easily parseable structure, and that is one
value per file.

