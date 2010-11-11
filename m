From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd
 numbered atomic_t counter
Date: Thu, 11 Nov 2010 09:53:03 -0600
Message-ID: <1289490783.2982.33.camel@mulgrave.site>
References: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-11-11 at 02:46 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts struct scsi_host->cmd_serial_number to a 'odd incremented by 2'
> atomic_t counter in scsi_cmd_get_serial(), and moves the host_lock held call in
> jgarzik's DEF_SCSI_QCMD() wrapper back into it's original location in scsi_dispatch_cmd().

Actually, no ... this isn't really a good idea; you're lengthening our
critical path here (an atomic costs a lot more than a simple add under
spinlock).

There are only a few drivers left that actually make use of a serial
number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
megaraid.

So the next logical step seems to be eliminate the overloading of the
serial number zero value, which removes the last mid-layer use (dpt_i2o
seems to abuse this unnecessarily as well), then the serial number code
can be pushed down into the queuecommand routines of only those drivers
that actually use it.  None of the modern ones seems to have a
legitimate use, so I think their uses can mostly be eliminated.  Thus,
we might be able to get away with a simple queuecommand push down and
never bother with atomics for this (since it's unlikely the legacy users
would convert away from a lock wrapping their queuecommand routines).

James
