From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: 05 Mar 2003 10:52:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046883135.1784.23.camel@mulgrave>
References: <20030303221532.GB1587@beaverton.ibm.com>
	<20030304123605.D6452@one-eyed-alien.net>
	<20030304222907.GA1252@beaverton.ibm.com>
	<200303050012.35309.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200303050012.35309.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

On Tue, 2003-03-04 at 17:12, Oliver Neukum wrote:
> It seems to me that there's a race with scan_scsis() and scan_scsis_single()
> which cannot be closed with failing queuecommand, as there's a window where
> the INQUIRY has succeeded but has not yet been evaluated by the SCSI layer.

Consider the offline function as a work in progress.  I think the model
we'll ultimately move to is to use the sysfs refcounting, so we could
call the offline function, have the device refuse all incoming requests,
but still process pending ones (which, if this is a forced remove should
fail).  Then call a remove hook when the outstanding command count drops
to zero.

> I am not quite sure how slave_alloc() is involved into this, but IMHO it's 
> wrong to force LLDDs to know about devices if they are hotpluggable.
> Could you clarify?

By design LLDs need to know about configured devices because they may
(although not all do) need to allocate resources to process them.  The
slave configure/alloc/destroy is the interface for communicating this
information:

slave_alloc informs the LLD that we're about to try the device, so it
should set its internal queues up for an inquiry command.

If inquiry succeeds, we process the info and call slave_configure to
adjust the queue to its initial depth based on the device parameters.

If the inquiry fails, slave_destroy is called to free the allocated
resources.

For a functional device, slave_destroy is called when we remove it to
tell the LLD to destroy the resources it has allocated to handle the
device.

James


