From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Autosense requirement
Date: Wed, 31 Jul 2002 11:02:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020731110201.A13072@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200207311604.g6VG4Dn02203@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200207311604.g6VG4Dn02203@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Jul 31, 2002 at 11:04:13AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James -

On Wed, Jul 31, 2002 at 11:04:13AM -0500, James Bottomley wrote:
> patmans@us.ibm.com said:
> > Having Scsi_Device on its own list could also help in hot-replacement
> > of single pathed devices (Scsi_Host can be removed without having to
> > remove a Scsi_Device off of its host_queue).
> 
> Isn't this going to cause serious problems for the driverfs stuff?  
> Effectively you're changing the parent pointer under the device which alters 
> the layout of the device tree.

Yes, for any multi-path implementation, driverfs needs changes so that a
child can have multiple parents, or something along those lines.

For the next version of the patch, I'm planning on merging with the current
identifier code - the value put into the driverfs "name", and then I plan
on looking into driverfs changes.

Perhaps driverfs could seperate device registration (or creation) from link
(or path) registration.

> > If you make changes in the host/device list(s) please consider that I
> > need to have the Scsi_Devices on their own list separate from the
> > Scsi_host list. 
> 
> Could you post some of the details of this (separated from the multi-path 
> patch if possible)?  Thanks,
> 
> James

There is a document here:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/docs/index.html

It describes the current host_queue list (I think you had similiar
slides at OLS), and the new list introduced by the multi-path patch,
mainly to show the path structures, not the Scsi_Device list.

Generally, if we want one Scsi_Device per actual LUN, and a LUN is connected
to multiple adapters, the Scsi_Device can't easily be linked off of
Scsi_Host - there is no longer one Scsi_Host for a given Scsi_Device.

So, I added a list of Scsi_Devices; on each Scsi_Device there is a list
of paths, where each path includes a pointer back to Scsi_Host.

On removal of a single Scsi_Host (if there was such code), all paths
pointing to the host must first be removed, and Scsi_Device can remain
(even with no left paths).

If I linked off of Scsi_Host, there would have to be a separate list
structure so that a Scsi_Device could be on multiple Scsi_Host lists.
This could still be done even with a separate Scsi_Device list, but is
only usefull if we need a fast way to lookup all Scsi_Devices on a host.

-- Patrick Mansfield
