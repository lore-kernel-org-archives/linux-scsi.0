From: Benny Halevy <bhalevy@tonian.com>
Subject: Re: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 12:05:38 +0200
Message-ID: <CAEMWVhvzANfj7iM6CjeFUh_RSWmoOtVjRKYfQm8cATOTPshn6w@mail.gmail.com>
References: <20130130070602.GB12396@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40308 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3A3KF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 05:05:59 -0500
Received: by mail-ob0-f177.google.com with SMTP id wc18so1433693obb.36
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2013 02:05:59 -0800 (PST)
In-Reply-To: <20130130070602.GB12396@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Jan 30, 2013 at 9:06 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> There wasn't any error handling for this kzalloc().
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index c06b8e5..d8293f2 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>         odi->osdname_len = get_attrs[a].len;
>         /* Avoid NULL for memcmp optimization 0-length is good enough */
>         odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
> +       if (!odi->osdname) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }

good catch!

Benny

>         if (odi->osdname_len)
>                 memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>         OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
