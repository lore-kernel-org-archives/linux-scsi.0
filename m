From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: Wed, 26 Mar 2003 13:33:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030326133308.A5307@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com> <3E80C41F.6000607@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E80C41F.6000607@splentec.com>; from luben@splentec.com on Tue, Mar 25, 2003 at 04:03:27PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2003 at 04:03:27PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:

> >           */
> >  	scsi_host_busy_dec_and_test(host, device);
> > +	spin_lock_irqsave(SCpnt->device->request_queue->queue_lock, flags);
> > +	SCpnt->device->device_busy--;
> > +	spin_unlock_irqrestore(SCpnt->device->request_queue->queue_lock, flags);
> 
> 
> Such acrobatics warrant an atomic variable. I.e. make device_busy an
> atomic_t and avoid all this juggling.
> 
> atomic_dec(SCpnt->device->device_busy);

If we handled all of the SCSI IO completions the same way (got rid of
scsi_retry_command and more), the device_busy-- might happen in
scsi_queue_next_request or a related function, where we might do more than
just decrement device_busy with the lock held. This is related somewhat to
the current handling of scsi_queue_next_request, in that we should always
call it after IO completion.

Having both an atomic_t for device_busy and a lock protecting other
scsi_device and queue data does not appear to give any overall reduction
in executed code (at least on x86, I don't know about other archs). We get
rid of a spin lock/unlock for the above, but we have to add 3
atomic_read's and one atomic_inc in the main line code path - on x86 SMP
four assembler lock instructions (counting in my current tree with all the
lock patches applied).

We should leave this as-is for now, and future SCSI IO completion clean up
could determine how best to protect device_busy.

-- Patrick Mansfield
