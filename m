From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Wed, 10 May 2006 02:34:05 +0400
Message-ID: <20060509223404.GE7237@mipter.zuzino.mipt.ru>
References: <200605092128.k49LSQ6R024308@mail.hypersurf.com> <20060509215936.GD7237@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:21399 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751241AbWEIWfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 18:35:33 -0400
Received: by nf-out-0910.google.com with SMTP id b2so1297336nfe
        for <linux-scsi@vger.kernel.org>; Tue, 09 May 2006 15:35:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20060509215936.GD7237@mipter.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allen <amah@highpoint-tech.com>
Cc: linux-scsi@vger.kernel.org, 'Andrew Morton' <akpm@osdl.org>, linux-kernel@vger.kernel.org

On Wed, May 10, 2006 at 01:59:36AM +0400, Alexey Dobriyan wrote:
> That plethora of HPT_IOCTL_* defines, where are you using them? What
> arguments are passed in and out?

Argh, sorry for confusion, I've checked several first in the list and wrongly
concluded nothing is used. Anyway, please, remove unused HPT_IOCTL_ defines.

> #ifdef MODULE_LICENSE
> MODULE_LICENSE("GPL");
> #endif

#ifdef is totally unneeded.

Module init and exit functions should be marked with __init and __exit
resp.

Use DMA_??BIT_MASK in calls to pci_set_dma_mask(). See
include/linux/dma-mapping.h for readily available items.

hptiop_get_logical_devices can return -1 and you'll end up with

	for (j = 0; j < -1; j++)

in hptiop_show_devicelist()

u64 things are printed as

	"%llu", (unsigned long long)capacity

Is unsigned long long enough in this case?

I also suggest to use vsnprintf() in hptiop_copy_info() because you use
it with strings.

Funny, that you do

	driveid->model[20] = 0;

when ->model is in fact 40 chars long.

