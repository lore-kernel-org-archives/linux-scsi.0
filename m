From: "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH 2.6.23] 3w-xxxx: Fix bad unaligned accesses on alpha SMP
Date: Fri, 7 Dec 2007 14:39:56 -0800
Message-ID: <b1bc6a000712071439r510142b4k530607dc0d9b8118@mail.gmail.com>
References: <15555.216.228.112.21.1196993221.squirrel@penguintown.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:65429 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbXLGWj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 17:39:57 -0500
Received: by rv-out-0910.google.com with SMTP id k20so848398rvb
        for <linux-scsi@vger.kernel.org>; Fri, 07 Dec 2007 14:39:56 -0800 (PST)
In-Reply-To: <15555.216.228.112.21.1196993221.squirrel@penguintown.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriele Gorla <gorlik@penguintown.net>
Cc: linuxraid@amcc.com, linux-scsi@vger.kernel.org

On Dec 6, 2007 6:07 PM, Gabriele Gorla <gorlik@penguintown.net> wrote:
> disable packing of the TAG_TW_Device_Extension
> structure to prevent kernel unaligned accesses when
> accessing the spinlock inside the ioctl_wqueue structure.
> Fixes smartmontools kernel panic on alpha SMP
>
> Signed-off-by: Gabriele Gorla <gorlik@yahoo.com>
> ---
>
> --- linux-2.6.23/drivers/scsi/3w-xxxx.h 2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23a/drivers/scsi/3w-xxxx.h 2007-12-06 17:46:05.000000000 -0800
> @@ -392,6 +392,8 @@
>         unsigned char padding[12];
>  } TW_Passthru;
>
> +#pragma pack()
> +
>  typedef struct TAG_TW_Device_Extension {
>         u32             base_addr;
>         unsigned long           *alignment_virtual_address[TW_Q_LENGTH];
> @@ -430,6 +432,4 @@
>         wait_queue_head_t       ioctl_wqueue;
>  } TW_Device_Extension;
>
> -#pragma pack()
> -
>  #endif /* _3W_XXXX_H */
>
>
>

ACK....  James, please apply.

-Adam
