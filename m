From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: Wed, 13 Oct 2004 14:55:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416D8815.4010808@us.ibm.com>
References: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com>	<416D3536.5030501@us.ibm.com>	<20041013140439.GI16153@parcelfarce.linux.theplanet.co.uk> 	<416D3ABE.6030107@us.ibm.com> <1097682323.2204.142.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:31126 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269377AbUJMT4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 15:56:47 -0400
In-Reply-To: <1097682323.2204.142.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dwmw2@infradead.org

James Bottomley wrote:
> But this isn't a BUG().  It should be a warning followed by a stack
> dump.  However, it looks like the correct fix is to get rid of the
> __bread() in the cam code.

Looks like the BUG() was removed since I originally submitted this patch. I
recreated the original problem with a 2.6.9-rc2 kernel, which has the
change you mention above. It looks like we now survive the __getblk call
from __bread, but __bread promptly dereferences the NULL bh returned by
__getblk by calling buffer_uptodate and we end up oopsing all the same.

> How does the attached work for you?

Not very well. It looks like it blows up in create_buffers() with this patch.
Since the block size (522) is not a multiple of the host page size, we end up
decrementing offset to a negative number in create_buffers, which then hits a BUG()
in set_bh_page. It looks to me like the block layer assumes the device block size
is a multiple of PAGE_SIZE, in more than one place. Here is the latest backtrace:

cpu 0x7: Vector: 300 (Data Access) at [c00000003480b240]
     pc: c0000000000aba20: .create_empty_buffers+0x30/0x10c
     lr: c0000000000aba18: .create_empty_buffers+0x28/0x10c
     sp: c00000003480b4c0
    msr: 8000000000009032
    dar: 0
  dsisr: 40000000
   current = 0xc0000000345982c0
   paca    = 0xc000000000465600
     pid   = 9012, comm = hwscan
7:mon> t
[c00000003480b550] c0000000000afbb0 .block_read_full_page+0x2d4/0x3f8
[c00000003480b670] c0000000000b3bf0 .blkdev_readpage+0x20/0x38
[c00000003480b6f0] c00000000007cf0c .read_cache_page+0xf4/0x25c
[c00000003480b7a0] c0000000000f7d84 .read_dev_sector+0x44/0x148
[c00000003480b830] d000000000080f38 .scsi_bios_ptable+0x50/0xd0 [scsi_mod]
[c00000003480b8d0] d000000000080fe8 .scsicam_bios_param+0x30/0x18c [scsi_mod]
[c00000003480b970] d00000000004b170 .sd_ioctl+0x258/0x28c [sd_mod]
[c00000003480ba30] c000000000249eac .blkdev_ioctl+0xd0/0x9b8
[c00000003480bb90] c0000000000b3c88 .block_ioctl+0x18/0x2c
[c00000003480bc10] c0000000000c3e34 .sys_ioctl+0x3c0/0x5c4
[c00000003480bcd0] c000000000021bb0 .hdio_getgeo+0x40/0xd8
[c00000003480bd70] c0000000000e3438 .compat_sys_ioctl+0x148/0x3dc
[c00000003480be30] c000000000010980 syscall_exit+0x0/0x18


> 
> James
> 
> ===== drivers/scsi/scsicam.c 1.16 vs edited =====
> --- 1.16/drivers/scsi/scsicam.c	2004-06-19 09:45:02 -05:00
> +++ edited/drivers/scsi/scsicam.c	2004-10-13 10:38:25 -05:00
> @@ -29,10 +29,11 @@
>  	unsigned char *res = kmalloc(66, GFP_KERNEL);
>  	if (res) {
>  		struct block_device *bdev = dev->bd_contains;
> -		struct buffer_head *bh = __bread(bdev, 0, block_size(bdev));
> -		if (bh) {
> -			memcpy(res, bh->b_data + 0x1be, 66);
> -			brelse(bh);
> +		Sector sect;
> +		void *data = read_dev_sector(bdev, 0, &sect);
> +		if (data) {
> +			memcpy(res, data + 0x1be, 66);
> +			put_dev_sector(sect);
>  		} else {
>  			kfree(res);
>  			res = NULL;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

