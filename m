From: Douglas Gilbert <dougg@torque.net>
Subject: Re: rounding dxfer_len to 512 bytes boundary in sg.c
Date: Thu, 15 Nov 2007 16:27:59 -0500
Message-ID: <473CB9DF.5030401@torque.net>
References: <1195141083.2607.203.camel@potomac.tworiverlabs.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50554 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbXKOV2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 16:28:11 -0500
In-Reply-To: <1195141083.2607.203.camel@potomac.tworiverlabs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Igor A. Nesterov" <igor.nesterov@usa.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Igor A. Nesterov wrote:
> dxfer_len value provided to SG_IO ioctl as a part of sg_io_hdr_t
> structure is rounded up to the nearest 512 bytes boundary just before
> scatterlist allocation in sg_build_indirect()
> 
>   /* round request up to next highest SG_SECTOR_SZ byte boundary */
>         blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
> 
> I do not understand why is this. From the memory handling point of view
> it seems meaningless because kernel memory for scatterlist is being
> allocated in pages anyway. And from the I/O point of view it results
> into buggy behavior if dxfer_len is bigger then def_reserved_size and is
> not multiple of 512. Roughly, there are two cases handled a little bit
> different in sg.c
> 
> 1) dxfer_len <= def_reserved_size (32k by default)
> 
> in this case sg_start_req() uses preallocated reserved buffer, and calls
> sg_link_reserve(), which truncates the length of the last scatterlist
> element to match original dxfer_len value. Everything goes fine.
> 
> 2) dxfer_len > def_reserved_size || reserved buffer is in use
> 
> in this case sg_start_req() allocates new scatterlist buffer with
> sg_build_indirect() and does NOT truncate the last scatterlist element
> leaving it rounded up to the nearest 512k boundary. Following IO
> operation is screwed up. First, operation is issued to device with a
> transfer length different from what meant by SG_IO originator. Sometimes
> it does not matter, sometimes it does. Even if IO operation is some sort
> of read (like read from a tape) and a device responds correctly,
> residual value from scsi mid-layer is calculated based on rounded up IO
> transfer length, and hence incorrect. When returned back to SG_IO
> originator, it creates a false impression that the actual amount of data
> is less then actually read. For example, when reading a 0x8002-bytes
> tape block with dxfer_len = 0x8002, the actual IO operation issued to
> tape drive has a transfer length 0x8200, and residual length after the
> operation is completed is 510. So the SG_IO originator has a full
> impression that the actual amount of data read is 0x8002 - 510.
> 
> There are different ways to fix this problem. For example, one might
> amend residual length value returned to user, or the last scatterlist
> element length can be fixed. But the first question is why is that
> rounding being done in the first place? I have fixed the problem by
> removing it, and nothing looks broken. What do maintainers think?
> 
> diff -urp a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> --- a/drivers/scsi/sg.c 2007-07-08 19:32:17.000000000 -0400
> +++ b/drivers/scsi/sg.c 2007-11-14 14:54:53.000000000 -0500
> @@ -1846,8 +1846,7 @@ sg_build_indirect(Sg_scatter_hold * schp
>                 return -EFAULT;
>         if (0 == blk_size)
>                 ++blk_size;     /* don't know why */
> -/* round request up to next highest SG_SECTOR_SZ byte boundary */
> -       blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
> +
>         SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d,
> blk_size=%d\n",
>                                    buff_size, blk_size));
>  

That code was there when I inherited the sg driver in 1998
(the original sg drivers dates from around 1993). The reason
is/was that the DMA element of some HBA needed it. I tried
to take it out once (probably in the last millenium) and it
broke somewhere so back in it went :-)

Now the SG_IO ioctl implementation in the block layer
doesn't have that code so perhaps we might assume from
that the HBA is no longer in use or its DMA logic
has been fixed. So perhaps it's time to pull out that
line again and see if anyone screams.

Doug Gilbert


