From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [Q] 2.4.x: how to handle driver aborts in sd/sr
Date: Wed, 8 May 2002 09:07:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020508090729.A5368@eng2.beaverton.ibm.com>
References: <OF789CF225.896237A6-ONC1256BB1.004E87CD@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g48G7iiT045250
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2002 12:07:44 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.11.1m3/NCO/VER6.1) with ESMTP id g48G7XZ132624
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2002 10:07:33 -0600
In-Reply-To: <OF789CF225.896237A6-ONC1256BB1.004E87CD@de.ibm.com>; from Stefan.Bader@de.ibm.com on Wed, May 08, 2002 at 01:35:52PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Stefan,

Why not return DID_SOFT_ERROR? Disks (SCpnt->allowed > 0) will retry the
IO some limited number of times, and tape (SCpnt->allowed == 0) will complete
the IO with DID_SOFT_ERROR in the result.

Or, do you have to handle an arbitrary numbers of retries?

-- Patrick

On Wed, May 08, 2002 at 01:35:52PM +0200, Stefan Bader wrote:
> Hi,
> 
> I've got some sort of error handling design question which I need some 
> advice whether
> this might be done the way I think.
> In some error situations our low-level driver has to abort all currently 
> active commands.
> The device may work if the requests are retried. This works for disk for 
> now by triggering
> the mid-layer retry mechanism. This is ok for disks but a big problem for 
> tapes which need
> to handle this situation with more effort.
> Now for that, the low-level driver can (and probably should) return 
> DID_ABORT and let the
> upper layer handle the situation. But then the sd driver would fail the 
> request(s) because it
> takes a result != 0 (aside from MEDIUM_ERROR) as 'no successful sectors' 
> (which wouldn't
> hurt) and there is no special catch for the condition in 
> scsi_io_completion() from scsi_lib.c.
> The desired action for the the abort case for disks would be just to 
> requeue the whole request
> (as it is done in the case of DID_RESET). 
> The only two highlevel drivers that seem to use scsi_io-completion seem to 
> be sd.c and sr.c
> and in the reset case the request would just requeued as well. So, would 
> there be a problem
> in adding this to scsi_lib.c?
> 
> /Stefan Bader
