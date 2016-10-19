From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 1/3] block: Add iocontext priority to request
Date: Wed, 19 Oct 2016 14:05:24 -0400
Message-ID: <20161019180524.GH18532@htj.duckdns.org>
References: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
 <1476728850-2309-2-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476728850-2309-2-git-send-email-adam.manzanares@hgst.com>
Sender: linux-ide-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzananares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Oct 17, 2016 at 11:27:28AM -0700, Adam Manzanares wrote:
> Patch adds an association between iocontext ioprio and the ioprio of a
> request. This is done to enable request based drivers the ability to
> act on priority information stored in the request. An example being
> ATA devices that support command priorities. If the ATA driver discovers
> that the device supports command priorities and the request has valid
> priority information indicating the request is high priority, then a high
> priority command can be sent to the device. This should improve tail
> latencies for high priority IO on any device that queues requests
> internally and can make use of the priority information stored in the
> request.
> 
> The ioprio of the request is set in blk_rq_set_prio which takes the
> request and the ioc as arguments. If the ioc is valid in blk_rq_set_prio
> then the iopriority of the request is set as the iopriority of the ioc.
> In init_request_from_bio a check is made to see if the ioprio of the bio
> is valid and if so then the request prio comes from the bio.
> 
> Signed-off-by: Adam Manzananares <adam.manzanares@wdc.com>

Jens, if you're okay with it, I can route this through
libata/for-4.10, or this can be applied to block and libata tree can
pull from it.

Thanks.

-- 
tejun
