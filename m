From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 21:37:52 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10302172136210.3880-100000@master.linux-ide.org>
References: <3E5129F3.2040807@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E5129F3.2040807@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Luben,

You are trying to make the mid-layer to the work of iSCSI where your
driver needs to do it.  Everyone else gets how to do target portal groups
without dorking the kernel.  Maybe you should try harder.

Andre Hedrick
LAD Storage Consulting Group

On Mon, 17 Feb 2003, Luben Tuikov wrote:

> James Bottomley wrote:
> > On Mon, 2003-02-17 at 12:20, Luben Tuikov wrote:
> > 
> >>There is no ``locking hierarchy'' -- i.e. a lock *only* locks its list
> >>manipulation. So, you don't have to have a string of locks to change
> >>a scsi_command, for example.
> > 
> > 
> > If I want to loop over all outstanding commands on a device (say because
> > the FC has just got a LIP removal), how do I do it?  Your design implies
> > I have to loop over all portals, targets and luns.  To do this loop, I'd
> > have to stabilise all the lists by acquiring the three locks that
> > protect them, wouldn't I?
> 
> No, not at all.  If you know the struct scsi_lu, you can just lock
> the pending_cmd_q and loop over the commands.
> 
> struct scsi_target is ``locked'' *implicitly* simply by having
> atomic_read(&target->lu_q_count) != 0.
> 
> struct scsi_portal is ``locked'' *implicitly* simply by having
> atomic_read(&portal->target_q_count) != 0.
> 
> struct scsi_core is ``locked'' *implicitly* simply by having
> atomic_read(&core->portal_q_count) != 0.
> 
> You certainly do not need to lock the the whole hierarchy of locks
> to loop over all pending commands.  Locks protect local data.
> I.e. you just want to protect yourself from someone messing the
> list up while you're traversing it.
> 
> >>When was the last time a SPI HBA set channel/bus to anything different
> >>than 0?
> > 
> > 
> > Channel is a special abstraction for the dual channel chips.  It's
> > really an extension of host number for drivers that need a channel
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Thus it can be abstracted into a ``portal''.
> 
> >>>3. I don't see where the mid-layer has a use for the data.  By and
> >>
> >>Well, how can I contend *that* statement?...  This basically means
> >>that the whole thing I proposed is cr*p.
> > 
> > 
> > This is the key issue.  Complexity should only be introduced in a design
> 
> Well if it were the key issue, you should've just said *that*.
> Nicely done.
> 
> > when it serves a justifiable purpose.  How do the 4 layers you propose
> > simplify the design/improve the throughput or in any other way add
> > benefit over the two layers (host and device) that we already have?
> 
> First of all it's 3 layers -- you're counting scsi_core but you don't
> count it in the current structure. (scsi core pointers you can have as
> ether-pointers, just as is now the practice)
> 
> So there's 3 layers: portal (aka host), target, lu. One more than
> the current structure of scsi_core.
> 
> Look, you *NEED* the target layer, simply /because/ it exists in
> nature. ;-)
> 
> I.e. a TARGET is the _addressable_ entity from a portal, i.e.
> addressable on the fabric, but a LU is *NOT*.
> 
> The reason you get away with it now, is because linux scsi-core
> gets help from the LLDDs.  But you have to understand that an LU
> is a _function_ of the target.  So without this help of the LLDDs
> the current scsi-core will *NOT* be able to address more than one
> LU in a multi-LU target.
> 
> Yes, I know there's the old scan for LUs, but this is only
> because linux scsi LLDD are SPI centric.
> 
> I.e. when you send a scsi command you're sending it to a (target,lu)
> pair and this is what the LLDD does for you, i.e. it separates it
> to a target, lu.
> 
> So, the question is: Is it worth it to abstract Target and LU into
> OO design? Or is it better to leave it clunked up together as it is
> now (device=(target,LU))?
> 
> I'm thinking sysfs here.
> 
> > Because the standards say so isn't enough.  The Mid-layer's job is to
> 
> And I'm not saying that it is enough. I'm just saying that:
> 
> > make efficient use of devices which follow the standards as simply and
> > elegantly as possible, not mirror the SCSI architecture model.
> 
> Right, ``elegantly'' is the key word.
> 
> I don't think you can shrink any more from the 3 layer I proposed,
> unless you go to the current 2 layer.
> 
> Judging from your words, the (host,device) pair is elegant enough?
> If not, do you mind telling what is/would be?
> 
> -- 
> Luben
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

