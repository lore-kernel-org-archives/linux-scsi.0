Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCECC433F8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F1120719
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgG0TSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:18:37 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:38247 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgG0TSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:18:37 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N4yuK-1kyoJi1ap2-010reW; Mon, 27 Jul 2020 21:18:34 +0200
Received: by mail-qk1-f172.google.com with SMTP id b14so14647372qkn.4;
        Mon, 27 Jul 2020 12:18:34 -0700 (PDT)
X-Gm-Message-State: AOAM5315TarJ964jIzA0jkckVQjgHvwvmD9Z6JJjIamE3Zd6/6EMrXDy
        B+Jc0wRqz2acYj+Cqi5OsE8WNaqqNhDvKkMTfUA=
X-Google-Smtp-Source: ABdhPJyPyuOhSSKcN3s0PoPWgWpIsASyjJkBJWTfjnn06ZQrJGvrqqFPGvwBi9CaJlGj78PTXJEf6kW9xdQMA/GJnj4=
X-Received: by 2002:a05:620a:2444:: with SMTP id h4mr25459006qkn.352.1595877513159;
 Mon, 27 Jul 2020 12:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200726191428.26767-1-samuel@sholland.org>
In-Reply-To: <20200726191428.26767-1-samuel@sholland.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 27 Jul 2020 21:18:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3yj=ySNCn7YtEXxWiRK0FtG+5ftkV+vb3s82yRi7cdLw@mail.gmail.com>
Message-ID: <CAK8P3a3yj=ySNCn7YtEXxWiRK0FtG+5ftkV+vb3s82yRi7cdLw@mail.gmail.com>
Subject: Re: [PATCH] scsi: 3w-9xxx: Fix endianness issues found by sparse
To:     Samuel Holland <samuel@sholland.org>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UTGN9kH981sad+tzK2dGq9L2NaYVeEeMZy6v6a2LlDQ9ci+Wn6/
 YTtyH2IsyOhjgLd4lo8vq1iZPrOC0Q4APJAJVDAO/S1p5vV+hxLsyP51feGlHi81GSSON12
 NhchqazUdiae6HxhWyxO7odDe+aKGwc5avTQIQi/stGOfLxkmcMn0foU1FHE6dTkoYHUaOx
 m8hi0FJHBEifpYx38s6AQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WY/a3fnxwng=:NU9/9WsxwVggoUJLyMB5bi
 QOoRm9smivL+qrAIICUGoNBwgRs21vTHrL1pETKVrwTVpViLiFmeCEyNCpS6WxP77m6YQmwIf
 VMPuTNJBa6HH2jPIAIo77ijtBRFtkbqXY6s/lS8ha+cauuoFyz4tP6caPCNMuJdOEFOySLH/M
 H9VGZzB8uhJyecBa5WS2JHkGixmw7sqFszZwaFr24LXXrsq1z+O+vJPxydeuYv3d5hK/bsN7t
 v1xqFg9rKpHsSiSE2g904eg/UpRAvXRE5Y0t6atgwx2jXssHGB/D8jkv9qrKAUzbgO/zq6yuD
 u76deoNWur84eZO4/hG8L4mrrojdUdSAjfXjH8qN0UtWMfZLPydYYCrWcF7G50KEf5+5VUUe/
 Eiit7CZFHyDGALJoQ9ScP7TogOd3eEYk0qUWZLHY73sKpjNGWVtJa0mnomrFvpv8/zFe3Y5Zd
 7nR0NG3MYrmwTvCleAqG5rkq0XxUjKhHbf6UzBaMbSASY+9JsG+yVZRWCX/iLzLv67ZO426Qm
 C79g0SVeUVa9Uh0Dujkas8L4AUn4LgD48dZhypnOUQfTtKhg/Xju0jr6Igxp4tj521PNtpYxo
 7nalHVUA5JQyE0MxvKqQbl/zSvIpByu6Cq0QtccTHwlPWs2o9FrDg1ipPTpE/hJwoM1HoPBEn
 9n+DLs1Iy1aczVcYqkn72613nCV0BwSgLgptmuMCVEd3I7HlR7zaClxyxSKPyiqXPX0mb8Ucc
 QEA1BKCU32gfir6xjpD2pTa+yc7PXTmkHEfezBj45ImLrXnAhYYkns+rHiCdBu+fT1E8zHaJi
 TecCER1YaldxTx1IGFwEIU06szaryIxK/dOq5OxDYFqqtADCCWDMntA9cxT2vx0clGuBoML
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 26, 2020 at 9:15 PM Samuel Holland <samuel@sholland.org> wrote:
>
> The main issue observed was at the call to scsi_set_resid, where the
> byteswapped parameter would eventually trigger the alignment check at
> drivers/scsi/sd.c:2009. At that point, the kernel would continuously
> complain about an "Unaligned partial completion", and no further I/O
> could occur.
>
> This gets the controller working on big endian powerpc64.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  drivers/scsi/3w-9xxx.c | 35 +++++++++++++++++------------------
>  drivers/scsi/3w-9xxx.h |  6 +++++-
>  2 files changed, 22 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 3337b1e80412..95e25fda1f90 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -303,10 +303,10 @@ static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
>
>         /* Initialize sglist */
>         memset(&sglist, 0, sizeof(TW_SG_Entry));
> -       sglist[0].length = TW_SECTOR_SIZE;
> -       sglist[0].address = tw_dev->generic_buffer_phys[request_id];
> +       sglist[0].length = cpu_to_le32(TW_SECTOR_SIZE);
> +       sglist[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);

This looks like it would add a sparse warning, not fix one, unless you also
change the types of the target structure.

> @@ -501,7 +501,7 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
>             Sunday 12:00AM */
>         local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
>         div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
> -       schedulertime = cpu_to_le32(schedulertime % 604800);
> +       cpu_to_le32p(&schedulertime);
>
>         memcpy(param->data, &schedulertime, sizeof(u32));

You dropped the '%' operation, and the result of the byteswap?

> @@ -1004,7 +1004,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>                                full_command_packet->header.status_block.error,
>                                error_str[0] == '\0' ?
>                                twa_string_lookup(twa_error_table,
> -                                                full_command_packet->header.status_block.error) : error_str,
> +                                                le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,
>                                full_command_packet->header.err_specific_desc);
>                 else

This looks correct, but the error value has already been copied into the local
'error' variable, which you could use for simplification. As 'status_block' is
defined as a native_endian structure, this also introduced a sparse warning.

> @@ -1012,7 +1012,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>                                full_command_packet->header.status_block.error,
>                                error_str[0] == '\0' ?
>                                twa_string_lookup(twa_error_table,
> -                                                full_command_packet->header.status_block.error) : error_str,
> +                                                le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,

Same here

       Arnd
