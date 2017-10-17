From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 09/10] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Tue, 17 Oct 2017 08:33:36 +0200
Message-ID: <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-10-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-10-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 01:29 AM, Bart Van Assche wrote:
> The contexts from which a SCSI device can be quiesced or resumed are:
> * Writing into /sys/class/scsi_device/*/device/state.
> * SCSI parallel (SPI) domain validation.
> * The SCSI device power management methods. See also scsi_bus_pm_ops.
> 
> It is essential during suspend and resume that neither the filesystem
> state nor the filesystem metadata in RAM changes. This is why while
> the hibernation image is being written or restored that SCSI devices
> are quiesced. The SCSI core quiesces devices through scsi_device_quiesce()
> and scsi_device_resume(). In the SDEV_QUIESCE state execution of
> non-preempt requests is deferred. This is realized by returning
> BLKPREP_DEFER from inside scsi_prep_state_check() for quiesced SCSI
> devices. Avoid that a full queue prevents power management requests
> to be submitted by deferring allocation of non-preempt requests for
> devices in the quiesced state. This patch has been tested by running
> the following commands and by verifying that after resume the fio job
> is still running:
> 
(We've discussed this at ALPSS already:)

How do you ensure that PREEMPT requests are not stuck in the queue
_behind_ non-PREEMPT requests?
Once they are in the queue the request are already allocated, so your
deferred allocation won't work.
_And_ deferred requests will be re-inserted at the head of the queue.
Consequently the PREEMPT request will never ever scheduled during quiesce.
How do you avoid such a scenario?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
