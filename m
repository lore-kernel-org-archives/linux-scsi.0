From: Willem Riede <wrlk@riede.org>
Subject: Re: [RFC] add transfer request length?
Date: Thu, 30 May 2002 06:58:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530105857.GI12126@linnie.riede.org>
References: <20020529230047.D26782@one-eyed-alien.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020529230047.D26782@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Thu, May 30, 2002 at 02:00:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On 2002.05.30 02:00 Matthew Dharm wrote:
> I'd like to add another field to the Scsi_Cmnd structure.  At least, I
> think I need another field to accomplish what I want....
> 
> Right now, a low-level SCSI driver (i.e. HBA) can't actually tell in
> advance how much data will be moved by a command.  The driver can see the
> buffer and the buffer length, and can enforce that the transfer length does
> not exceed that buffer length, but we can't actually algorithmically
> determine the amount of data we expect to move....
> 
> For example, imagine an INQUIRY for 36 bytes issued with a buffer for 256
> bytes.  This actually does happen.
> 
> In this case, it's easy to figure out how much data is requested by reading
> the command.  However, block device commands talk in 'number of blocks',
> which is something that the HBAs shouldn't have to keep track of.
> 
> The worst device is the OnStream driver, which makes allocations in page
> sizes and then transfers a strange number of bytes (n * 4096 + 512 bytes).

Not any more... Turns out that was a problem for the IEEE1394 subsystem,
so I changed it to an exact memory allocation.

> drivers/usb/storage/scsiglue.c has some code to try to figure out how much
> data should be transfered.  This is important for emulated SCSI devices
> (sbp2, usb, etc.).
> 
> So, I'd like to add a field so that high-level drivers (sd, sr, sg, etc.)
> can tell us how many bytes they intend to move.  sg already collects this
> information, but the HBA can't see it.
> 
> Comments?

/*
 * Function:    scsi_do_req
 *
 * Purpose:     Queue a SCSI request
 *
 * Arguments:   SRpnt     - command descriptor.
 *              cmnd      - actual SCSI command to be performed.
 *              buffer    - data buffer.
 *              bufflen   - size of data buffer.
 *              done      - completion function to be run.
 *              timeout   - how long to let it run before timeout.
 *              retries   - number of retries we allow.

The bufflen above is not enough?

Thanks, Willem Riede.
