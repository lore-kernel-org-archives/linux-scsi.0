From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 07/17] scsi: ufs: separate device and host quirks
Date: Thu, 22 Oct 2015 00:59:32 +0900
Message-ID: <CAC5umyg1VKi-E_EUNV5PiDi2+ksUE-cLVKoz2A6Auog3SB=++g@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33972 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbbJUP7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 11:59:33 -0400
In-Reply-To: <1442155977-7686-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:

> diff --git a/drivers/scsi/ufs/ufs_quirks.c b/drivers/scsi/ufs/ufs_quirks.c
> new file mode 100644
> index 0000000..b649bbf
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs_quirks.c
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "ufshcd.h"
> +#include "ufs_quirks.h"
> +
> +

Single blank line is enough.

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e5a876c..0803a89 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -39,9 +39,10 @@
>
>  #include <linux/async.h>
>  #include <linux/devfreq.h>
> -
> +#include <linux/nls.h>
>  #include <linux/of.h>
>  #include "ufshcd.h"
> +#include "ufs_quirks.h"
>  #include "unipro.h"
>  #define UFSHCD_REQ_SENSE_SIZE  18
>
> @@ -259,6 +260,16 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
>         }
>  }
>
> +/* replace non-printable or non-ASCII characters with spaces */
> +static inline void ufshcd_remove_non_printable(char *val)
> +{
> +       if (!val)
> +               return;
> +
> +       if (*val < 0x20 || *val > 0x7e)
> +               *val = ' ';
> +}
> +
>  /*
>   * ufshcd_wait_for_register - wait for register value to change
>   * @hba - per-adapter interface
> @@ -2052,6 +2063,82 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
>         return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
>  }
>
> +int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
> +{
> +       return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
> +}
> +EXPORT_SYMBOL(ufshcd_read_device_desc);
> +
> +/**
> + * ufshcd_read_string_desc - read string descriptor
> + * @hba: pointer to adapter instance
> + * @desc_index: descriptor index
> + * @buf: pointer to buffer where descriptor would be read
> + * @size: size of buf
> + * @ascii: if true convert from unicode to ascii characters
> + *
> + * Return 0 in case of success, non-zero otherwise
> + */
> +int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
> +                               u32 size, bool ascii)
> +{
> +       int err = 0;
> +
> +       err = ufshcd_read_desc(hba,
> +                               QUERY_DESC_IDN_STRING, desc_index, buf, size);
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: reading String Desc failed after %d retries. err = %d\n",
> +                       __func__, QUERY_REQ_RETRIES, err);
> +               goto out;
> +       }

I actually tried this patch and ufshcd_read_desc() always returns
-EINVAL due to the following check in the end of ufshcd_read_desc().

        if (ret || (buff_len < ufs_query_desc_max_size[desc_id]) ||
            (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
             ufs_query_desc_max_size[desc_id])
            || (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id)) {
                ...
                if (!ret)
                        ret = -EINVAL;

Could you also include a fix fir ufshcd_read_desc()?
