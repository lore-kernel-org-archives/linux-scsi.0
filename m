From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: iSCSI HBA needs to have a unique host id
Date: Fri, 14 Nov 2003 09:31:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114093124.B2794@beaverton.ibm.com>
References: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:58805 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264518AbTKNRcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:32:12 -0500
Content-Disposition: inline
In-Reply-To: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com>; from surekhap@cisco.com on Fri, Nov 14, 2003 at 03:26:36PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 14, 2003 at 03:26:36PM +0530, Surekha.PC wrote:
> 
> Hi all,
> 
>    The host id for iSCSI HBA does not remain unique with  2.6 linux
> kernel. It keeps changing when iSCSI host is added and removed
> dynamically. This is a problem for persistent device naming for iSCSI
> devices through host id.
> 
> It would be good to maintain a database of already allocated host id's
> for the existing hosts. This would render the iSCSI HBA to get the same
> controller id, irrespective of loading/unloading the driver repeatedly.

The N in hostN  has to be unique across all hosts, since we have
/sysfs/class/scsi_host/hostN.

> Would like to know if there is any provision in 2.6 to achieve the
> above?

udev + scsi_id will be able to give persistent names to any SCSI attached
storage that supply a unique ID, including iSCSI.

If you want to name based on location (like host, chan, id, lun), udev has
a topology and "place" matching.  It needs work so we can wild card the
host number and use it for scsi, and it has to include the parent name for
scsi, but the general idea is include in udev (I'm not working on this for
udev).

As long as the iSCSI uses a parent that has unique and relevant name, then
the udev place can be modified to work.

i.e for pci we have:

[elm3b79 patman]$ ls /sysfs/devices/pci0000:01/0000:01:0c.0/host5/5:0:6:0
block   detach_state    model   queue_depth  rev         type
delete  device_blocked  online  rescan       scsi_level  vendor

So if you could use "place" with wildcards something like:

	0000:01:0c.0/*/*:0:6:0

We could use it to name scsi devices based on location.

It would be nice if the host number was a tag or name based on the
parent's name (or as you say stored), but then we would have to encode the parent's bus or such
to avoid name collision, and the scsi_device bus_id names get long. 

For sysfs devices would look like:

devices/pci0000:01/0000:01:0c.0/host_pci_0000:01:0c.0/pci_0000:01:0c.0:0:6:0

And: 

/sysfs/class/scsi_host/pci_0000:01:0c.0:0:6:0

So the hostN is replaced by the <parent's bus>_<parent's bus_id>, ugly,
but then the scsi device bus_id is unique, and (assuming the parent
assigned channels and target id's the same) can by itself be used with
udev's "place" with no modifications to udev.

-- Patrick Mansfield
