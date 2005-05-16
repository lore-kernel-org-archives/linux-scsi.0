From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 2.6 aacraid: Variable FIB size
Date: Mon, 16 May 2005 10:09:24 -0500
Message-ID: <1116256165.5040.10.camel@mulgrave>
References: <1115763750.10955.5.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3501 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261696AbVEPPJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 11:09:35 -0400
In-Reply-To: <1115763750.10955.5.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, 2005-05-10 at 15:22 -0700, Mark Haverkamp wrote:
>  	rcode = fib_send(RequestAdapterInfo,
> -			fibptr, 
> -			sizeof(struct aac_adapter_info),
> -			FsaNormal, 
> -			1, 1, 
> -			NULL, 
> +		fibptr, 
> +		sizeof(*info),
> +		FsaNormal, 
> +		1, 1, 
> +		NULL, 
> +		NULL);

This is a formatting change that makes the driver harder to read.  If
you want one argument per line, they should at least line up with the
opening bracket of the function.

>  		for (i = 0; i < sg_count; i++) {
> -			psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
> -			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
> -			byte_count += sg_dma_len(sg);
> +			int count = sg_dma_len(sg);
> +			u32 addr = sg_dma_address(sg);
> +			if (host->max_sectors < AAC_MAX_32BIT_SGBCOUNT)
> +			while (count > 65536) {
> +				psg->sg[i].addr = cpu_to_le32(addr);
> +				psg->sg[i].count = cpu_to_le32(65536);
> +				++i;
> +				if (++sg_count > host->sg_tablesize) {
> +					BUG();
> +				}
> +				byte_count += 65536;
> +				addr += 65536;
> +				count -= 65536;
> +			}

This is wrong.  You're basically assuming the block layer is returning
something that goes over your segment descriptor size.

There's no API for this in SCSI, but what you should be doing is

blk_queue_max_segment_size(sdev->request_queue, 65536);

in your slave_configure routine.

James


