From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
	use from fc_queuecommand
Date: Wed, 01 Sep 2010 14:38:41 -0700
Message-ID: <1283377121.5598.23.camel@haakon2.linux-iscsi.org>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	 <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	 <4C7DD3E8.9050700@cs.wisc.edu>
	 <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
	 <1283371821.32007.636.camel@haakon2.linux-iscsi.org>
	 <1283375187.30431.71.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:30691 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752962Ab0IAVmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2010 17:42:37 -0400
In-Reply-To: <1283375187.30431.71.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "Zou, Yi" <yi.zou@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, Hannes Reinecke <hare@suse.de>

On Wed, 2010-09-01 at 14:06 -0700, Vasu Dev wrote:
> On Wed, 2010-09-01 at 13:10 -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2010-09-01 at 00:57 -0700, Zou, Yi wrote:
> > > > 
> > > > On 08/31/2010 06:56 PM, Nicholas A. Bellinger wrote:
> > > > >> +	if (host->unlocked_qcmds)
> > > > >> +		spin_unlock_irqrestore(host->host_lock, flags);
> > > > >> +
> > > > >>   	if (unlikely(host->shost_state == SHOST_DEL)) {
> > > > >>   		cmd->result = (DID_NO_CONNECT<<  16);
> > > > >>   		scsi_done(cmd);
> > > > >
> > > > > I don't think it's safe to call scsi_done() for the SHOST_DEL case here
> > > > > with host->unlocked_qcmds=1 w/o holding host_lock, nor would it be safe
> > > > > for the SCSI LLD itself using host->unlocked_qcmds=1 to call the
> > > > > (*scsi_done)() being passed into sht->queuecommand() without
> > > > > host->host_lock being held by either the SCSI ML or the SCSI LLD.
> > > > 
> > > > The host state should be checked under the host lock, but I do not think
> > > > it needs to be held with calling scsi_done. scsi_done just queues up the
> > > > request to be completed in the block softirq, and the block layer
> > > > protects against something like the command getting completed by
> > > > multiple code paths/threads.
> > > 
> > > It looks safe to me to call scsi_done() w/o host_lock held,
> > 
> > Hmmmm, this indeed this appears to be safe now..  For some reason I had
> > it in my head (and in TCM_Loop virtual SCSI LLD code as well) that
> > host_lock needed to be held while calling struct scsi_cmnd->scsi_done().
> > 
> > I assume this is some old age relic from the BLK days in the SCSI
> > completion path, and the subsequent conversion.  I still see a couple of
> > ancient drivers in drivers/scsi/ that are still doing this, but I
> > believe I stand corrected in that (all..?) of the modern in-use
> > drivers/scsi code is indeed *not* holding host_lock while calling struct
> > scsi_cmnd->scsi_done()..
> > 
> 
> fcoe/libfc moved to scsi_done w/o holding scsi host_lock a while ago
> around dec, 09 and it was done after discussion with Mathew and Chris
> Leech from fcoe side at that time, they may have more to comment on
> this.
> 

Very good to know..  Thanks for this info!!

/me queues up patch  8-)

>  
> > In that case, I will prepare a patch for TCM_Loop v4 and post it to
> > linux-scsi.  Thanks for the info..!
> 
> > >   in which case,
> > > there is probably no need for the flag unlocked_qcmds, but just move the 
> > > spin_unlock_ireqrestore() up to just after scsi_cmd_get_serial(), and let
> > > queuecommand() decide when/where if it wants to grab&drop the host lock, where
> > > in the case for fc_queuecomamnd(), we won't grab it at all. Just a thought...
> > > 
> > 
> > Yes, but many existing SCSI LLD's SHT->queuecommand() depends upon
> > unlocking the host_lock being held, but I don't know how many actually
> > need to do this to begin with...?
> > 
> > I think initially this patch would need to be able to run the
> > 'optimized' path first with a SCSI LLD like an FCoE or iSCSI software
> > initiator that knows that SHT->queuecommand() is not held, but still
> > allow existing LLDs that expect to unlock and lock struct
> > Scsi_Host->host_lock themselves internally do not immediately all break
> > and deadlock terribly.
> > 
> 
> I fully agree on this approach. I had same intent with this patch to not
> impact existing LLD doing queuecommand under host lock, having such LLD
> to re-acquire this lock would pose same perf issue as fcoe is having now
> since lock still needed inside scsi_dispatch_cmd for shost_state
> checking as indicated above by Nab and Mike beside needed for
> scsi_cmd_get_serial there.
> 
> I'll restore lock for shost_state and for this unlikely SHOST_DEL case
> have this lock dropped later, however still have fc_queuecommand w/o
> host lock held, so change would be as:-
> 
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ad0ed21..ce504e5 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -749,11 +749,16 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>         if (unlikely(host->shost_state == SHOST_DEL)) {
>                 cmd->result = (DID_NO_CONNECT << 16);
>                 scsi_done(cmd);
> +               spin_unlock_irqrestore(host->host_lock, flags);
>         } else {
>                 trace_scsi_dispatch_cmd_start(cmd);
> +               if (!host->unlocked_qcmds)
> +                       spin_unlock_irqrestore(host->host_lock, flags);
>                 rtn = host->hostt->queuecommand(cmd, scsi_done);
> +               if (host->unlocked_qcmds)
> +                       spin_unlock_irqrestore(host->host_lock, flags);
>         }
> -       spin_unlock_irqrestore(host->host_lock, flags);
> +
>         if (rtn) {
>                 trace_scsi_dispatch_cmd_error(cmd, rtn);
>                 if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> 
> 
> Maybe two additional checks here is not so neat but not too bad either
> as just two additional checks here, I excluded this unlocked_qcmd checks
> from scsi_error queuecommand calling to not clutter its code there with
> these additional checks  w/o any good case for that code path.
> 

Hmmmm, handing off the locking like this between ML and LLD gets ugly
pretty quick, so I am not sure exactly sure if this is the right way to
go about it..

Mabye in code terms we might need to consider converting some (or
all..?) struct Scsi_Host->host_lock accesses to some form of Linux/SCSI
Host specific lock and unlock wrapper that is aware of the current
->queuecommand() LLD lock status..?  Obviously this would only need to
cover the queuecommand path here first, but perhaps would be useful in
other areas as well..?

This would at least (I think) allow ML and LLD code to be a tad bit
cleaner than something like the example above where host->unlocked_qcmds
TRUE/FALSE conditionals exist directly within ML and LLD code.

Any other comments here from the Linux/SCSI folks..?

Thanks!

--nab


