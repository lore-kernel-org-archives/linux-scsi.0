From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Wed, 23 Oct 2002 17:13:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021023171335.B17312@lst.de>
References: <dledford@redhat.com> <200210231416.g9NEGoI01976@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210231416.g9NEGoI01976@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Oct 23, 2002 at 09:16:49AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2002 at 09:16:49AM -0500, James Bottomley wrote:
> This is really exposing our whole detect init attach finish slave_attach mess 
> which Christoph was trying to clean up.
> 
> What happens now (after Christoph's removal of finish) is:
> 
> 1) call detect to see if anyone will attach.  If yes, call slave attach (we 
> adjust the queue depth here if wanted)
> 2) call init (if not inited---done once per upper level driver) --- init is 
> supposed to be for first init of the SCSI upper level device driver to 
> allocate inital resources, so we already have detect called befor init.

Well, I'm working on removing ->init.  With the patch posted yersterday
only sg.c and osst.c are left implementing it.

> 3) call attach but release the commandblocks if sdev->attached comes back zero.
> 
> -> attached, by the way is a semaphore because we can have more than one upper 
> level attachment.  This exposes nicely in the rather icky algorithm of 
> scsi_get_request_dev() which is used to find which upper level driver should 
> process the request in the request function.
> 
> It looks like what we want to have happen is:
> 
> 1) init first
>
> 
> 2) detect is currently superfluous (there will probably be a future time when 
> we need a separate detect for lazy attachment---devices don't attach and 
> consume resources until the operator so instructs)
> 4) call build commandblocks to get a single working command
> 5) attach
> 6) if anything attached do the slave attach or cmd_per_lun adjustment.  If 
> not, release the command blocks.

Completly agreed with that.

