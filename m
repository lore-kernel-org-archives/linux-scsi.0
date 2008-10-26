From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Timeout regression introduced by
	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Sun, 26 Oct 2008 10:15:05 -0500
Message-ID: <1225034105.3958.4.camel@localhost.localdomain>
References: <49043C7C.8050207@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49043C7C.8050207@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
> Hello, Jens.
> 
> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
> regression for libata.  The second timeout gives puts different
> pointer from the issued command onto eh_cmd_q breaking libata EH
> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
> command processing or causes oops later depending on circumstances.
> 
> Here are logs with induced timeouts (patch attached).  In commit
> 242f9dcb8, the XXX messages for the second timeout shows different
> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
> ata_scsi_qc_new() during command translation.

I can't see a way we could be getting a different command passed in from
the actual one, since the only way to lose the command from the request
is to go through the command completion routines which free it (and end
the request).

However, since the WARN_ON is specifically comparing the command with
the one found by the active tag, could this actually be a problem caused
by block tags?  I note that libata still uses its own array of
outstanding tags (ap->qcmd[tag]) instead of finding them using
blk_queue_find_tag() (or scsi_find_tag()).

James


