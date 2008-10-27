From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Timeout regression introduced by
	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Mon, 27 Oct 2008 14:30:06 -0700
Message-ID: <20081027213006.GB17946@linux.vnet.ibm.com>
References: <49043C7C.8050207@kernel.org> <1225034105.3958.4.camel@localhost.localdomain> <49051EA4.3040403@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49051EA4.3040403@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:
> James Bottomley wrote:
> > On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
> >> Hello, Jens.
> >>
> >> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
> >> regression for libata.  The second timeout gives puts different
> >> pointer from the issued command onto eh_cmd_q breaking libata EH
> >> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
> >> command processing or causes oops later depending on circumstances.
> >>
> >> Here are logs with induced timeouts (patch attached).  In commit
> >> 242f9dcb8, the XXX messages for the second timeout shows different
> >> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
> >> ata_scsi_qc_new() during command translation.
> > 
> > I can't see a way we could be getting a different command passed in from
> > the actual one, since the only way to lose the command from the request
> > is to go through the command completion routines which free it (and end
> > the request).
> 
> I have no idea either.  It's something in the timeout logic because on
> the issue path the scmd pointer is identical but on tiemout pointer
> for another scmd is queued on eh_cmd_q, which doesn't make much sense.
> 

I was trying to recreate this error using ata_ram wth v2.6.28-rc2.
Currently I am not able to see this error on timeout recovery using this
setup. Does IO load (or other factors) effect the error being seen?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
