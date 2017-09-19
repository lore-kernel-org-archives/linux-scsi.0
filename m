From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: SSDs can timeout during FS init because of too
 many unmaps
Date: Tue, 19 Sep 2017 12:13:43 -0400
Message-ID: <1505837623.4100.253.camel@localhost.localdomain>
References: <1505826137-35001-1-git-send-email-William.Kuzeja@stratus.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751881AbdISQNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 12:13:45 -0400
In-Reply-To: <1505826137-35001-1-git-send-email-William.Kuzeja@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <William.Kuzeja@stratus.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2017-09-19 at 09:02 -0400, Bill Kuzeja wrote:
> I encountered this issue putting XFS on several brands of SSDs on my
> system. During initialization, I would see a bunch of timeouts on
> WRITE_SAME_16 commands, which would get aborted, reissued, and complete.
> The logs look like this:
> 
> kernel: sd 2:0:1:0: attempting task abort! scmd(ffff88086ca0c8c0)
> kernel: sd 1:0:1:0: attempting task abort! scmd(ffff88086c7f2bc0)
> kernel: sd 1:0:1:0: [sds] CDB: Write same(16) 93 08 00 00 00 00 24 04
> 07 b8 00 7f ff ff 00 00
> kernel: sd 2:0:1:0: [sdt] CDB: Write same(16) 93 08 00 00 00 00 24 04
> 07 b8 00 7f ff ff 00 00
> 
> And so on (there are many, many more of these)...
> 
> The interesting thing to note as that these are WS16 commands with the
> unmap bit set (this drive's version of UNMAP) with length 0x7fffff.
> This is over 8.3 million blocks to be unmapped at once. Since there are
> many concurrent "unmaps", the drive can get overwhelmed and time out.

There is another problem as well.  There are some enterprise storage
arrays that are rejecting large WRITE SAME(16) commands w/UNMAP set
with ILLEGAL REQUEST / INVALID FIELD IN CDB.  As far as I can tell,
T10 SBC says that the MAXIMUM WRITE SAME LENGTH field in the block
limits VPD page should describe the limit for these commands, but
the arrays appear to reject anything large than MAXIMUM UNMAP LBA COUNT.
i.e. they are treating WRITE SAME(16) w/UNMAP the same as an UNMAP CDB.

I had come up with something similar, see my comment on your patch below.

> 
> Why does this happen? Initializing the device with a filesystem (in my
> experience XFS) creates one huge discard for the SSD. This gets
> broken apart into smaller unmap seqments, which get sent down to the
> drive. For the SSDs that I've been working with (lbpws is always set), 
> UNMAPs always gettranslated to WS16 with the unmap bit set.
> 
> The size of these segments is determined when the drive is set up
> initially. Early on, in the routine sd_read_block_limits, we read the
> Block Limits VPD page (page 0xb0). Among other things, this page gives
> us the drive's MAX UNMAP LBA count as well as the MAX WRITE SAME LENGTH.
> In my experience, every SSD returns zero for MAX WRITE SAME length but
> does have a real value for MAX_UNMAP LBA count.
> 
> The way the code is structured, because we read in zero for
> MAX WRITE SAME, we assume there is no limit for write same commands.
> This *may* be true, but unmap/discard commands translate into write
> same commands with the unmap bit set. Technically, this makes them
> no longer write same commands.
> 
> Currently, the max discard size is actually based off of max_ws_blocks.
> When configuring max discard size later, we default to
> SD_MAX_WS16_BLOCKS (0x7fffff) because max_ws_blocks is currently
> always zero:
> 
>              max_blocks = min_not_zero(sdkp->max_ws_blocks,
>                                           (u32)SD_MAX_WS16_BLOCKS);
> 
> A reasonable fix for this would be to use the MAX UNMAP LBA count
> (stored as max_unmap_blocks) instead of max_ws_blocks in the case where
> we're defaulting to WS16 for unmaps.
> 
> After discussing this issue with an SSD vendor's firmware team, they
> confirmed that this was a good way to proceed. That is, it made sense to
> use the max_unmap_blocks count instead of the default SD_MAX_WS16_BLOCKS
> value because 1) max_ws_blocks is always zero, 2) these are really
> unmap commands we're issuing, and 3) the SSD can handle a few unmaps
> the size of SD_MAX_WS16_BLOCKS but not necessarily a barrage of them.
> 
> The largest max unmap size I've seen from returned from a drive (from
> the Block Limits VPD page) is 0x270000 or about 30% of SD_MAX_WS16_BLOCKS. 
> Other sizes are much smaller, typically 0x80000 or about 6% of the 
> previous max value.
> 
> I've also done performance testing for this change. The only impact I've
> seen on SSDs is during filesystem initialization time, which would be 
> expected since that's most likely the only time we'd be doing really large 
> unmaps. Even so, the impact on FS init is fairly minimal, 10% for some 
> models of SSDs, others no noticeable difference at all.
> 
> ----
> 
> Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
> ---
>  drivers/scsi/sd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 11c1738..f24c4f2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -715,8 +715,13 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  		break;
>  
>  	case SD_LBP_WS16:
> -		max_blocks = min_not_zero(sdkp->max_ws_blocks,
> -					  (u32)SD_MAX_WS16_BLOCKS);
> +		/* If no value given, use unmap limit - WS16 default too large */
> +		if (!sdkp->max_ws_blocks)
> +			max_blocks = min_not_zero(sdkp->max_unmap_blocks,
> +						  (u32)SD_MAX_WS16_BLOCKS);
> +		else
> +			max_blocks = min_not_zero(sdkp->max_ws_blocks,
> +						  (u32)SD_MAX_WS16_BLOCKS);
>  		break;
>  
>  	case SD_LBP_WS10:

I've been testing a similar patch, your patch does not change the
WRITE SAME(10) case, and it does not do anything if max_ws_blocks is
nonzero, but larger than max_unmap_blocks.  It might address your SSD
issue, but it may not handle the other cases I've had reported to me.

I'll post my version for comparison and review.

-Ewan
