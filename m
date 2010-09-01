From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
	use from fc_queuecommand
Date: Wed, 01 Sep 2010 13:10:21 -0700
Message-ID: <1283371821.32007.636.camel@haakon2.linux-iscsi.org>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	 <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	 <4C7DD3E8.9050700@cs.wisc.edu>
	 <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:28485 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755973Ab0IAUOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2010 16:14:11 -0400
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, Hannes Reinecke <hare@suse.de>, Matthew Wilcox <matthew@wil.cx>

On Wed, 2010-09-01 at 00:57 -0700, Zou, Yi wrote:
> > 
> > On 08/31/2010 06:56 PM, Nicholas A. Bellinger wrote:
> > >> +	if (host->unlocked_qcmds)
> > >> +		spin_unlock_irqrestore(host->host_lock, flags);
> > >> +
> > >>   	if (unlikely(host->shost_state == SHOST_DEL)) {
> > >>   		cmd->result = (DID_NO_CONNECT<<  16);
> > >>   		scsi_done(cmd);
> > >
> > > I don't think it's safe to call scsi_done() for the SHOST_DEL case here
> > > with host->unlocked_qcmds=1 w/o holding host_lock, nor would it be safe
> > > for the SCSI LLD itself using host->unlocked_qcmds=1 to call the
> > > (*scsi_done)() being passed into sht->queuecommand() without
> > > host->host_lock being held by either the SCSI ML or the SCSI LLD.
> > 
> > The host state should be checked under the host lock, but I do not think
> > it needs to be held with calling scsi_done. scsi_done just queues up the
> > request to be completed in the block softirq, and the block layer
> > protects against something like the command getting completed by
> > multiple code paths/threads.
> 
> It looks safe to me to call scsi_done() w/o host_lock held,

Hmmmm, this indeed this appears to be safe now..  For some reason I had
it in my head (and in TCM_Loop virtual SCSI LLD code as well) that
host_lock needed to be held while calling struct scsi_cmnd->scsi_done().

I assume this is some old age relic from the BLK days in the SCSI
completion path, and the subsequent conversion.  I still see a couple of
ancient drivers in drivers/scsi/ that are still doing this, but I
believe I stand corrected in that (all..?) of the modern in-use
drivers/scsi code is indeed *not* holding host_lock while calling struct
scsi_cmnd->scsi_done()..

In that case, I will prepare a patch for TCM_Loop v4 and post it to
linux-scsi.  Thanks for the info..!

>   in which case,
> there is probably no need for the flag unlocked_qcmds, but just move the 
> spin_unlock_ireqrestore() up to just after scsi_cmd_get_serial(), and let
> queuecommand() decide when/where if it wants to grab&drop the host lock, where
> in the case for fc_queuecomamnd(), we won't grab it at all. Just a thought...
> 

Yes, but many existing SCSI LLD's SHT->queuecommand() depends upon
unlocking the host_lock being held, but I don't know how many actually
need to do this to begin with...?

I think initially this patch would need to be able to run the
'optimized' path first with a SCSI LLD like an FCoE or iSCSI software
initiator that knows that SHT->queuecommand() is not held, but still
allow existing LLDs that expect to unlock and lock struct
Scsi_Host->host_lock themselves internally do not immediately all break
and deadlock terribly.

>From that point we could discuss for a v2 patch about converting
everything single LLD queuecommand() caller to not directly touch
host_lock, unless they have some bizarre reason for doing so.  Again,
this is assume that calling SHT->queuecommand() is safe to begin with,
and there are not cases of interaction by the LLDs in
SHT->queuecommand() that when accessing struct Scsi_Host require the
host_lock to be held.

James and Co, any comments here..?

Best,

--nab


