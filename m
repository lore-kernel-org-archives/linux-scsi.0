From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 0/3] Separate zone requests from medium access requests
Date: Wed, 1 Mar 2017 12:02:14 +0900
Message-ID: <6f1c8be1-9366-b32e-621e-8b05f22a1753@wdc.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
 <20170228160259.GA22755@lst.de> <yq160jtu2s0.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq160jtu2s0.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Martin,

On 3/1/17 11:52, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> I don't really like this too much - this is too many SCSI
> Christoph> specifics for the block layer to care.  Maybe using bios for
> Christoph> the zone ops was a mistake after all, and we should just have
> Christoph> operations in struct block_device instead..
> 
> Yeah, I'm afraid I don't like this either.
> 
> Short term I still think we should adjust in sd. And then maybe longer
> term revisit whether these hybrid commands should be something other
> than bios.

OK. I will think about it.

The problem remains that the mpt3sas driver needs fixing. As you
suggest, we can do that in sd, or directly in mpt3sas.
I tried to do a clean fix in sd, but always end up consuming a lot of
aspirin because of all the potential corner cases to deal with. So I
would prefer really just a fix in mpt3sas for now and think of the sd
changes (if any) together with a redesign of the zone commands execution
(not as BIOs).

The file sd.h has the inline function scsi_medium_access_command()
defined. We could move that to include/scsi/scsi.h (or scsi_proto.h) and
use it in place of blk_rq_accesses_medium() in the mpt3sas driver to not
force unaligned resid corrections for zone commands. Would that be
acceptable ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
