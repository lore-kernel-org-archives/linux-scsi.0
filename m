From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [bug report] scsi: arcmsr: Add a function to set date and time to firmware
Date: Mon, 11 Dec 2017 10:52:39 +0800
Message-ID: <CAKiknE_YN-6ddrR_RoL1g_4LCQRThniHbnS-vHwU5d3ikb-ewQ@mail.gmail.com>
References: <20171209124715.tlxmnooiqqxw5q24@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:43575 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdLKCwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Dec 2017 21:52:41 -0500
Received: by mail-lf0-f53.google.com with SMTP id 94so17504963lfy.10
        for <linux-scsi@vger.kernel.org>; Sun, 10 Dec 2017 18:52:40 -0800 (PST)
In-Reply-To: <20171209124715.tlxmnooiqqxw5q24@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dan,

Yeah, secs is never be negative. This checking is redundant and have
to be removed.
Thanks Colin Ian King has done this patch for me on [next].

Thanks,
Ching

2017-12-09 20:47 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Ching Huang,
>
> The patch b416c099472a: "scsi: arcmsr: Add a function to set date and
> time to firmware" from Dec 5, 2017, leads to the following static
> checker warning:
>
>         drivers/scsi/arcmsr/arcmsr_hba.c:3682 arcmsr_set_iop_datetime()
>         warn: unsigned 'secs' is never less than zero.
>
> drivers/scsi/arcmsr/arcmsr_hba.c
>   3658  static void arcmsr_set_iop_datetime(struct timer_list *t)
>   3659  {
>   3660          struct AdapterControlBlock *pacb = from_timer(pacb, t, refresh_timer);
>   3661          unsigned int days, j, i, a, b, c, d, e, m, year, mon, day, hour, min, sec, secs, next_time;
>                 ^^^^^^^^^^^^                                                          ^^^
>
>   3662          struct timeval tv;
>   3663          union {
>   3664                  struct  {
>   3665                  uint16_t        signature;
>   3666                  uint8_t         year;
>   3667                  uint8_t         month;
>   3668                  uint8_t         date;
>   3669                  uint8_t         hour;
>   3670                  uint8_t         minute;
>   3671                  uint8_t         second;
>   3672                  } a;
>   3673                  struct  {
>   3674                  uint32_t        msg_time[2];
>   3675                  } b;
>   3676          } datetime;
>   3677
>   3678          do_gettimeofday(&tv);
>   3679          secs = (u32)(tv.tv_sec - (sys_tz.tz_minuteswest * 60));
>   3680          days = secs / 86400;
>   3681          secs = secs - 86400 * days;
>   3682          if (secs < 0) {
>                     ^^^^^^^^
> Not possible.
>
>   3683                  days = days - 1;
>   3684                  secs = secs + 86400;
>   3685          }
>   3686          j = days / 146097;
>
>
> regards,
> dan carpenter
