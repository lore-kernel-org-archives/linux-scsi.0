From: "Zou, Yi" <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] scsi, fcoe,
 libfc: drop scsi host_lock use from fc_queuecommand
Date: Wed, 1 Sep 2010 00:57:39 -0700
Message-ID: <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	<1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	<4C7DD3E8.9050700@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4C7DD3E8.9050700-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> 
> On 08/31/2010 06:56 PM, Nicholas A. Bellinger wrote:
> >> +	if (host->unlocked_qcmds)
> >> +		spin_unlock_irqrestore(host->host_lock, flags);
> >> +
> >>   	if (unlikely(host->shost_state == SHOST_DEL)) {
> >>   		cmd->result = (DID_NO_CONNECT<<  16);
> >>   		scsi_done(cmd);
> >
> > I don't think it's safe to call scsi_done() for the SHOST_DEL case here
> > with host->unlocked_qcmds=1 w/o holding host_lock, nor would it be safe
> > for the SCSI LLD itself using host->unlocked_qcmds=1 to call the
> > (*scsi_done)() being passed into sht->queuecommand() without
> > host->host_lock being held by either the SCSI ML or the SCSI LLD.
> 
> The host state should be checked under the host lock, but I do not think
> it needs to be held with calling scsi_done. scsi_done just queues up the
> request to be completed in the block softirq, and the block layer
> protects against something like the command getting completed by
> multiple code paths/threads.

It looks safe to me to call scsi_done() w/o host_lock held,  in which case,
there is probably no need for the flag unlocked_qcmds, but just move the 
spin_unlock_ireqrestore() up to just after scsi_cmd_get_serial(), and let
queuecommand() decide when/where if it wants to grab&drop the host lock, where
in the case for fc_queuecomamnd(), we won't grab it at all. Just a thought...

Thanks,
yi
