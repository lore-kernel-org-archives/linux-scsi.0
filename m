From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 15:56:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122155615.A21301@eng2.beaverton.ibm.com>
References: <20021122183603.GC16865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e5.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAMNuI4s222302
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 18:56:18 -0500
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAMNuFFQ079922
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 18:56:15 -0500
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id gAMNpJV08451
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 15:51:19 -0800
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id gAMNuFj24820
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 15:56:15 -0800 (PST)
In-Reply-To: <20021122183603.GC16865@redhat.com>; from dledford@redhat.com on Fri, Nov 22, 2002 at 01:36:03PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 01:36:03PM -0500, Doug Ledford wrote:
> Like last time, this has been through a full compile test, but not a boot 
> test.  I'm heading up to the office next so the boot test will come 
> shortly.  But, because it touches lots of files, again, I thought I would 
> go ahead and push it up for people to see.  If there are no objections to 
> this or my previous patches, then once the boot test is complete and I'm 
> satisfied things are working properly, I'll push the whole lot to Linus 
> (which will necessarily include the scsi-misc-2.5 changes because they are 
> in my tree as well).
> 
> bk pull bk://linux-scsi.bkbits.net/scsi-dledford
> 
> New Changeset added since last night:
> ChangeSet@1.852, 2002-11-22 12:59:10-05:00, dledford@dledford.theledfords.org
>   Convert from host->host_queue to host->my_devices list usage
>   Add in usage of new same_target_siblings list
>   Add scsi_release_commandblocks() call to scsi_free_sdev()
>   Make all scsi device freeing use scsi_free_sdev()

Hi Doug -

It booted and runs fine on a netfinity + aic. I haven't updated my 
modutils yet, so did not try the qla driver (ported to your new naming
scheme, I need the qla to test with a qlogics 2300 with a multi-lun target).

Was there a missing scsi_release_commandblocks call?

Why not remove the next/prev in scsi_device? Any code referencing
them is broken, usage should at least generate a compilation warning.

The slave_destroy should be called before the channel/id/lun is modified
during scanning, so slave_destroy if needed can index off of 
host/channel/id/lun and figure out properly what to destroy. Perhaps there
should be a common function for this that calls slave_destroy, modifies
sdevscan channel/id/lun, and then calls slave_alloc; such a function might
also release and build command blocks.

The report lun usage does not modify the channel/id/lun, so does not need
the slave_destroy/slave_alloc calls.

IMO the traversal of scsi_devices should be completely transparent
to the user, such as a wrapper or call back function, so we would not 
have to change anything if the underlying data structure changed (the
list of scsi_hosts contains a list of scsi_devices). Namely, for
multi-path  it is useful to have all the scsi_devices on one list, and
not have a host centric view of the scsi_devices.

-- Patrick Mansfield
