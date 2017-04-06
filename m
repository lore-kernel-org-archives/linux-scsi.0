From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/27] scsi: sd: Separate zeroout and discard command
 choices
Date: Thu, 6 Apr 2017 08:17:51 +0200
Message-ID: <84970c9f-b785-f7c7-411f-d932fb5666e1@suse.de>
References: <20170405172125.22600-1-hch@lst.de>
 <20170405172125.22600-27-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405172125.22600-27-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/05/2017 07:21 PM, Christoph Hellwig wrote:
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Now that zeroout and discards are distinct operations we need to
> separate the policy of choosing the appropriate command. Create a
> zeroing_mode which can be one of:
> 
> write:			Zeroout assist not present, use regular WRITE
> writesame:		Allow WRITE SAME(10/16) with a zeroed payload
> writesame_16_unmap:	Allow WRITE SAME(16) with UNMAP
> writesame_10_unmap:	Allow WRITE SAME(10) with UNMAP
> 
> The last two are conditional on the device being thin provisioned with
> LBPRZ=1 and LBPWS=1 or LBPWS10=1 respectively.
> 
> Whether to set the UNMAP bit or not depends on the REQ_NOUNMAP flag. And
> if none of the _unmap variants are supported, regular WRITE SAME will be
> used if the device supports it.
> 
> The zeroout_mode is exported in sysfs and the detected mode for a given
> device can be overridden using the string constants above.
> 
> With this change in place we can now issue WRITE SAME(16) with UNMAP set
> for block zeroing applications that require hard guarantees and
> logical_block_size granularity. And at the same time use the UNMAP
> command with the device's preferred granulary and alignment for discard
> operations.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/sd.h |  8 ++++++++
>  2 files changed, 61 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
