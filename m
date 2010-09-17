From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
Date: Fri, 17 Sep 2010 11:24:23 -0700
Message-ID: <1284747863.13344.167.camel@haakon2.linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <1284686949.7280.99.camel@schen9-DESK>
	 <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
	 <4C93B2BC.8000404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C93B2BC.8000404@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-09-17 at 14:26 -0400, Jeff Garzik wrote:
> On 09/16/2010 09:31 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2010-09-16 at 18:29 -0700, Tim Chen wrote:
> >> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger<nab@linux-iscsi.org>
> >>>
> >>> Greetings all,
> >>>
> >>> This series contains the first round of a whole-sale conversion for droping
> >>> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> >>> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> >>> that is protected by host_lock is scsi_cmd_get_serial)_.
> >>>
> >>
> >> Maybe we can change the host->cmd_serial_number to atomic and totally
> >> avoid the need to take host_lock.
> >
> > Hmmmm good point, then we would also need an atomic_t for signaling
> > (shost_state == SHOST_DEL) in scsi_dispatch_cmd() to be able to
> > completly drop host_lock usage within scsi_dispatch_cmd().
> >
> > I can take a look at doing this specific part, if you would be willing
> > to have a look at the host->cmd_serial_number conversion piece.  ;)
> 
> But that raises the familiar tale of:  using multiple atomics (w/ their 
> locked instructions) may cost more than a spinlock.

So patch #1 in the v2 series just posted uses the following code:

static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
{
        /*
         * The use of per struct scsi_cmnd->serial_number is disabled by default
         */
        if (!(host->use_serial_number))
                return;
        /*
         * Increment the host->cmd_serial_number by 2 so cmd->serial_number
         * is always odd and wraps to 1 instead of 0.
         */
        cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
}


Note that host->use_serial_number is disabled by default, so for the typical case
no atomic_t reading (or writing) is required.

Best,

--nab
