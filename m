Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920F9C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 02:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC7F2067D
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 02:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHICiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 22:38:00 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:55698 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbgHICiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 22:38:00 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 8E2EF18224512;
        Sun,  9 Aug 2020 02:37:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: join82_5c010db26fce
X-Filterd-Recvd-Size: 2767
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sun,  9 Aug 2020 02:37:58 +0000 (UTC)
Message-ID: <cd3a39d4ef3da9968026549e285dea3ef4261795.camel@perches.com>
Subject: Re: [PATCH v3 1/3] scsi: 3w-9xxx: Use flexible array members to
 avoid struct padding
From:   Joe Perches <joe@perches.com>
To:     Samuel Holland <samuel@sholland.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 08 Aug 2020 19:37:57 -0700
In-Reply-To: <20200809004727.53107-1-samuel@sholland.org>
References: <20200809004727.53107-1-samuel@sholland.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-08-08 at 19:47 -0500, Samuel Holland wrote:
> In preparation for removing the "#pragma pack(1)" from the driver, fix
> all instances where a trailing array member could be replaced by a
> flexible array member. Since a flexible array member has zero size, it
> introduces no padding, whether or not the struct is packed.
[]
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
[]
> @@ -676,7 +676,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
>  	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
>  
>  	/* Now allocate ioctl buf memory */
> -	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, &dma_handle, GFP_KERNEL);
> +	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted + sizeof(TW_Ioctl_Buf_Apache), &dma_handle, GFP_KERNEL);

Trivia:

It's perhaps more sensible to order the arguments with
the size of the struct first then the data length so
the argument is in the order of the expected content.

	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev,
				      sizeof(TW_Ioctl_Buf_Apache) + data_buffer_length_adjusted,
				      &dma_handle, GFP_KERNEL);

> @@ -685,7 +685,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
>  	tw_ioctl = (TW_Ioctl_Buf_Apache *)cpu_addr;
>  
>  	/* Now copy down the entire ioctl */
> -	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache) - 1))
> +	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache)))

	if (copy_from_user(tw_ioctl, argp, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length))

etc...


