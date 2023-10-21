Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EBCC0032E
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Oct 2023 10:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjJUKWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Oct 2023 06:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjJUKWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2023 06:22:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9491BF
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 03:22:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC7CC433C7;
        Sat, 21 Oct 2023 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697883758;
        bh=ToAEgXlfHA448dyTcRbcIuRZGw4ucPqYueINjAW3PAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUv6KTAbF7QSNJFZavgBBycNL/4PZ8qLx70WfCMG19kUlAX0LLtjBoZX0+C1zOs/Z
         u8o4Q4J84YRjawSarbUbF+sHc5TZflSfXobAVoIjF0bAsPHIS4L3KHXTVDml+LVDQU
         zjrT/txLOnP0d0CX4pEBQFWC/hgZ8wYJIY0ECj7M=
Date:   Sat, 21 Oct 2023 12:22:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com
Subject: Re: [PATCH 5/7] usb-storage,uas: do not convert device_info for
 64-bit platforms
Message-ID: <2023102103-plaything-dispute-b246@gregkh>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
 <20231016072604.40179-6-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016072604.40179-6-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 09:26:02AM +0200, Milan Broz wrote:
> This patch optimizes the previous one for 64-bit platforms, where
> unsigned long is 64-bit, so we do not need to convert quirk flags
> to 32-bit index.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/usb/storage/Makefile  | 3 +++
>  drivers/usb/storage/mkflags.c | 9 +++++++++
>  drivers/usb/storage/usb-ids.h | 4 ++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
> index 612678f108d0..62ebaa76ef95 100644
> --- a/drivers/usb/storage/Makefile
> +++ b/drivers/usb/storage/Makefile
> @@ -57,6 +57,9 @@ $(obj)/usual-tables.o: $(obj)/usb-ids.c
>  $(obj)/uas.o: $(obj)/usb-ids-uas.c
>  clean-files		:= usb-ids.c usb-ids-uas.c
>  HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
> +ifdef CONFIG_64BIT
> +HOSTCFLAGS_mkflags.o	+= -D CONFIG_64BIT
> +endif
>  hostprogs		+= mkflags
>  
>  quiet_cmd_mkflag_storage = FLAGS   $@
> diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
> index 2514ffef0154..08c37d2e52d6 100644
> --- a/drivers/usb/storage/mkflags.c
> +++ b/drivers/usb/storage/mkflags.c
> @@ -89,11 +89,15 @@ static struct svals vals[] = {
>  
>  static unsigned long get_device_info(uint64_t flags, unsigned int idx)
>  {
> +#ifndef CONFIG_64BIT
>  	if (flags < HI32)
>  		return (unsigned long)flags;
>  
>  	/* Use index that will be processed in usb_stor_di2flags */
>  	return HI32 + idx;
> +#else
> +	return flags;
> +#endif

Please try to keep #ifdef out of .c files, it makes maintenance a real
pain and is not the kernel coding style at all.

thanks,

greg k-h
