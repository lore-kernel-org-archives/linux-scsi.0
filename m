From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Wed, 23 Oct 2002 09:16:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210231416.g9NEGoI01976@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA28665
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 07:16:54 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Tue, 22 Oct 2002 19:30:05 EDT." <20021022233005.GD31295@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> It appears after looking at this with Patrick that in drivers where
> slave_attach is is not calling scsi_adjust_queue_depth the
> scsi_build_commandblocks will not be called. In my case ips.c and in
> James case 53c700.c. 

> If post calling slave_attach the new_queue_depth is 0 and the device
> is not offline we should ensure there is at least a new_queue_depth of
> 1 which is what your patch does by later on calling
> scsi_build_commandblocks directly. 

> Actually, prior to the scsi_scan changes, the code always made sure
> that  it was at least 1 after the scan.  Maybe that got lost
> somehow... 

This is really exposing our whole detect init attach finish slave_attach mess 
which Christoph was trying to clean up.

What happens now (after Christoph's removal of finish) is:

1) call detect to see if anyone will attach.  If yes, call slave attach (we 
adjust the queue depth here if wanted)
2) call init (if not inited---done once per upper level driver) --- init is 
supposed to be for first init of the SCSI upper level device driver to 
allocate inital resources, so we already have detect called befor init.
3) call attach but release the commandblocks if sdev->attached comes back zero.

-> attached, by the way is a semaphore because we can have more than one upper 
level attachment.  This exposes nicely in the rather icky algorithm of 
scsi_get_request_dev() which is used to find which upper level driver should 
process the request in the request function.

It looks like what we want to have happen is:

1) init first
2) detect is currently superfluous (there will probably be a future time when 
we need a separate detect for lazy attachment---devices don't attach and 
consume resources until the operator so instructs)
4) call build commandblocks to get a single working command
5) attach
6) if anything attached do the slave attach or cmd_per_lun adjustment.  If 
not, release the command blocks.

The net effect should be that if a device has no upper level driver, it can 
appear in /proc/scsi/scsi, but it's consuming no other system resources.

James


