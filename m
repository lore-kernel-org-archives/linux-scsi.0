From: Christoph Hellwig <hch@infradead.org>
Subject: Re: cleanup of sd driver in lk2.5
Date: Sun, 7 Apr 2002 19:50:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020407195008.A9452@infradead.org>
References: <3CAD2C8A.595DC7A5@torque.net> <20020405122253.A2038@infradead.org> <3CAE61B7.562CA94A@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3CAE61B7.562CA94A@torque.net>; from dougg@torque.net on Fri, Apr 05, 2002 at 09:47:19PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 05, 2002 at 09:47:19PM -0500, Douglas Gilbert wrote:
> 
> Christoph,
> My major concern in this area is the hot unplugging of
> IDE and 1394 disks. The natural thing for them to do
> is call sd_detach() but from which context? ** Also the
> block subsystem could be just about to send a command
> to that device (I make the assumption if sd_detach()
> is called any scsi packets "in flight" will not 
> call sd_rw_intr() thereafter).
> 
> Data integrity on the hot unplugged device is obviously
> compromised, however fsck can take care of that later.
> The challenge is to make the sd driver robust enough
> not to die a horrible death ...

Hmm, okay - I missed some other users from interrupt context
than just the error handling.

> ** are we sure that couldn't be an interrupt context?
> One thought that crossed my mind is that since all
> scsi hosts have a scsi_eh_<n> thread in 2.5 then some 
> device attaches and detaches could be sent/queued through 
> that thread.

Either this or through keventd is the way to go, IMHO.

> While I am musing, does anyone know whether the driverfs
> structure might be useful to put in Scsi_Host objects?
> It might standardize information about HBAs or, for
> pseudo adapters, what other protocol stack to visit
> for more information.

I think we want driverfs all through the scsi layer, and that
includes Scsi_Host.
