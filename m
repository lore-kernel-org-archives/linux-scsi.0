From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Wed, 12 Feb 2003 13:23:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212212340.GA7488@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030212204634.A17425@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> > That is, eh_* functions of a LLDD should be re-entrant.
> 
> Agreed that they should.  The question on how to implement this
> without breaking drivers remains.  Do you volunteer to do add taking
> the lock into all these methods so the existing lock state remains until a
> maintainer ACKs that his driver doesn't need protection / and or makes
> it reenetrant?
> 
> The other way would be to add an concurrent_eh flag to the host template,
> but I really hate these conditional locking schemes, they just cause confusion.
> 

The host template check may cause confusion, but today we have few
drivers that do not need the host_lock taken so we end up with code
bloat and confustion in the drivers to support a older model:
	- Mid takes lock with flags
	- LLDD drops lock and then grabs it again before return.
	- Mid drops lock with flags.

> > While we are this I'd like to give this idea to you, which I've
> > mentioned before (this will be kind of more formal):
> > 
> > Proposal A: Let's make queuecommand() be void queuecommand().
> > 
> > This will accomplish the following:
> > 	- the only way SCSI Core gives ownership of a scsi command
> > 	structure to a LLDD is by calling queuecommand() -- which
> > 	is currently the case as well.
> > 
> > 	- the only way a LLDD gives ownership back to SCSI Core is
> > 	by calling scsi_done(), and let there be *no* other way.
> > 
> > I completely detest the current dualist approach of also checking
> > the return value of queuecommand().
> 
> That sounds nice to me.  But again, do you think you can do it for 2.5
> without breaking more drivers?  (i.e. fixing everything up)
> 

I like the idea, but for 2.5 cleaning the ~95 queuecommand functions
seems large.

> > As to the eh_* routines:  The current naming technique follws SPI,
> > which is now out of SAM and SPC.  Furthermore newer SCSI devices,
> > not necessarily on a parallel interface, do not define bus_reset,
> > host_reset and sometimes device_reset, because it is not
> > always clear what is the device or host or bus...
> > 
> > Proposal B: let the eh_* become tmf_* where TMF is
> > Task Management Functions.  Those are from SAM-2/3 (all re-entrant):
> > 
> > int tmf_abort_task(scsi command pointer);
> > 	aborts the task sent from this initiator port,
> > 	the LLDD will determine the initiator port.
> > int tmf_abort_task_set(target, lun);
> > 	aborts all tasks sent from this initiator port,
> > 	like sending multiple tmf_abort_task(...).
> > int tmf_clear_aca(target, lun);
> > int tmf_clear_task_set(target, lun);
> > int tmf_lun_reset(target, lun);
> > int tmf_query_task(scsi command struct);
> > int tmf_target_reset(target);
> > int tmf_wakeup(target);
> > 
> > Some of those are optional and depend on the functionality of the
> > device. Others depend on the transport.
> > 
> > The result of the function is the service response which is one of:
> > { TMF_COMPLETE, TMF_SUCC, TMF_REJ } and Service delivery or target failiure.
> > 
> > I think that this framework will also be very convenient for the USB
> > people, since they will not define all of those, but the ones they will
> > define, they can map easily to their own USB infrastructure.
> > 
> > ``target'' is a target identifier (type not known at this point).
> > ``lun'' is a 64 bit quantity.
> 
> It should be the same type as is used for luns in other places of the
> scsi midlayer (whatever that m,ay be when this gets in)
> 
> > All those methods are to be re-entrant and a command could be cancelled
> > all the while the LLDD continues to process commands.  (I've done
> > this myself.)  This would warrant a bit different queueing technique
> > in SCSI Core but slowly we're getting there.
> > 
> > Maybe this is 2.7 stuff, but as long as ideas are popping up, we're doing
> > okay.
> 
> I think that's clearly 2.7 stuff, we've moved scsi a lot forward in 2.5,
> now we need to get most drivers working again and 2.6 out of the door.
> 
> If you have anough time a prototype now won't hurt though - the scsi code
> shouldn't really change during early 2.6.
> 

I also agree about it being a 2.7 item, but I like it as a guide of
where we should consider heading.

-andmike
--
Michael Anderson
andmike@us.ibm.com

