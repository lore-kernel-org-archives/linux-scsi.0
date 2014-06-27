From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] [scsi] 3w-xxxx: fix mis-aligned struct accesses
Date: Fri, 27 Jun 2014 16:32:53 -0700
Message-ID: <CAHtARFH4mHKSUEm--JxraXW3yq4ZctZVnj3yMkQM1h4O8g6qNA@mail.gmail.com>
References: <4791230.CGnay5CMcb@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:41441 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaF0Xcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 19:32:54 -0400
Received: by mail-yh0-f41.google.com with SMTP id z6so3520390yhz.14
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 16:32:53 -0700 (PDT)
In-Reply-To: <4791230.CGnay5CMcb@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Adam Radford <linuxraid@lsi.com>

On Thu, Jun 26, 2014 at 5:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Building an allmodconfig ARM kernel, I get multiple such
> warnings because of a spinlock contained in packed structure
> in the 3w-xxxx driver:
>
> ../drivers/scsi/3w-xxxx.c: In function 'tw_chrdev_ioctl':
> ../drivers/scsi/3w-xxxx.c:1001:68: warning: mis-aligned access used for structure member [-fstrict-volatile-bitfields]
>     timeout = wait_event_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
>                                                                     ^
> ../drivers/scsi/3w-xxxx.c:1001:68: note: when a volatile object spans multiple type-sized locations, the compiler must choose between using a single mis-aligned access to preserve the volatility, or using multiple aligned accesses to avoid runtime faults; this code may fail at runtime if the hardware does not allow this access
>
> The same bug apparently was present in 3w-sas and 3w-9xxx, but has been
> fixed in the past. This patch uses the same fix by moving the pragma
> in front of the TW_Device_Extension definition, so it only covers
> hardware structures.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Adam Radford <linuxraid@lsi.com>
> ---
> diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
> index 49dcf03..29b0b84e 100644
> --- a/drivers/scsi/3w-xxxx.h
> +++ b/drivers/scsi/3w-xxxx.h
> @@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
>         unsigned char padding[12];
>  } TW_Passthru;
>
> +#pragma pack()
> +
>  typedef struct TAG_TW_Device_Extension {
>         u32                     base_addr;
>         unsigned long           *alignment_virtual_address[TW_Q_LENGTH];
> @@ -430,6 +432,4 @@ typedef struct TAG_TW_Device_Extension {
>         wait_queue_head_t       ioctl_wqueue;
>  } TW_Device_Extension;
>
> -#pragma pack()
> -
>  #endif /* _3W_XXXX_H */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Arnd,

Thanks for the patch to 3w-xxxx.  This looks good to me.

Acked-by: Adam Radford <aradford@gmail.com>

-Adam
