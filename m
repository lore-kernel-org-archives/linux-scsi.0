From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: For iblock at default writecache enable.
Date: Tue, 29 Jan 2013 11:03:18 -0800
Message-ID: <1359486198.23290.1409.camel@haakon2.linux-iscsi.org>
References: <201301250958101278740@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40347 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3A2TDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 14:03:20 -0500
In-Reply-To: <201301250958101278740@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Hi majianpeng,

On Fri, 2013-01-25 at 09:58 +0800, majianpeng wrote:
> Like the harddisk, at default write cache is enable.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/target/target_core_iblock.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index b526d23..69c2f2d 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -125,6 +125,9 @@ static int iblock_configure_device(struct se_device *dev)
>  	dev->dev_attrib.hw_max_sectors = UINT_MAX;
>  	dev->dev_attrib.hw_queue_depth = q->nr_requests;
>  
> +	/*Default enable write cache*/
> +	dev->dev_attrib.emulate_write_cache = 1;
> +

So enabling emulate_write_cache=1 in the case when the underlying device
has not enabled it is incorrect.

I'd like to enable this bit when we know the underlying device has WCE=1
set, but currently there is not a way to determine this (generically)
from struct block_device.

So NACK for applying this until there is a method to determine what the
hardware below is doing.

--nab

>  	/*
>  	 * Check if the underlying struct block_device request_queue supports
>  	 * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
> -- 
> 1.7.9.5


