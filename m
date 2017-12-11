From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH][next] scsi: arcmsr: remove redundant check for secs < 0
Date: Mon, 11 Dec 2017 10:41:03 +0800
Message-ID: <CAKiknE8NSv_QMK-SzXa2SL0Vx9Ttt9NxDP2aF0wRhJGs8L4WVQ@mail.gmail.com>
References: <20171209003414.17332-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171209003414.17332-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Colin,

You are right. That's checking is redundant. secs is never be negative.
Thanks for your correction and patch.

Regards,
Ching

2017-12-09 8:34 GMT+08:00 Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> The check for secs being less than zero is redundant for two reasons.
> Firstly, secs is unsigned so the check is always going to be false.
> Secondly, if secs was signed the proceeding calculation of secs is
> never going to be negative.  Hence we can remove this redundant check
> and day and secs re-adjustment.
>
> Detected by static analysis with smatch:
> arcmsr_set_iop_datetime() warn: unsigned 'secs' is never less than zero.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 0707a60bf5c0..e4258b69f4be 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -3679,10 +3679,6 @@ static void arcmsr_set_iop_datetime(struct timer_list *t)
>         secs = (u32)(tv.tv_sec - (sys_tz.tz_minuteswest * 60));
>         days = secs / 86400;
>         secs = secs - 86400 * days;
> -       if (secs < 0) {
> -               days = days - 1;
> -               secs = secs + 86400;
> -       }
>         j = days / 146097;
>         i = days - 146097 * j;
>         a = i + 719468;
> --
> 2.14.1
>
