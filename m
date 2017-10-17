From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v9 09/10] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Tue, 17 Oct 2017 18:43:22 +0800
Message-ID: <20171017104321.GC17898@ming.t460p>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-10-bart.vanassche@wdc.com>
 <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757684AbdJQKnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 06:43:50 -0400
Content-Disposition: inline
In-Reply-To: <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, Oct 17, 2017 at 08:33:36AM +0200, Hannes Reinecke wrote:
> On 10/17/2017 01:29 AM, Bart Van Assche wrote:
> > The contexts from which a SCSI device can be quiesced or resumed are:
> > * Writing into /sys/class/scsi_device/*/device/state.
> > * SCSI parallel (SPI) domain validation.
> > * The SCSI device power management methods. See also scsi_bus_pm_ops.
> > 
> > It is essential during suspend and resume that neither the filesystem
> > state nor the filesystem metadata in RAM changes. This is why while
> > the hibernation image is being written or restored that SCSI devices
> > are quiesced. The SCSI core quiesces devices through scsi_device_quiesce()
> > and scsi_device_resume(). In the SDEV_QUIESCE state execution of
> > non-preempt requests is deferred. This is realized by returning
> > BLKPREP_DEFER from inside scsi_prep_state_check() for quiesced SCSI
> > devices. Avoid that a full queue prevents power management requests
> > to be submitted by deferring allocation of non-preempt requests for
> > devices in the quiesced state. This patch has been tested by running
> > the following commands and by verifying that after resume the fio job
> > is still running:
> > 
> (We've discussed this at ALPSS already:)
> 
> How do you ensure that PREEMPT requests are not stuck in the queue
> _behind_ non-PREEMPT requests?

Once the PREEMP_ONLY flag is set, blk_mq_freeze_queue() is called for
draining up all requests in queue first, and new requests are prevented
from being allocated meantime.

So looks no such issue?

> Once they are in the queue the request are already allocated, so your
> deferred allocation won't work.
> _And_ deferred requests will be re-inserted at the head of the queue.
> Consequently the PREEMPT request will never ever scheduled during quiesce.
> How do you avoid such a scenario?

>From the implementation, no any PREEMPT request can be allocated once
scsi_device_quiesce() returns.

Also not see deferred requests in this patch, could you explain it a bit?


-- 
Ming
