From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 5/6] scsi_debug: uuid for lu name
Date: Tue, 31 May 2016 15:57:40 +0300
Message-ID: <CAHp75VfEbLdGhL851RZdM5+UHNKFNqu31VNH=2a5SWc3LjrMsA@mail.gmail.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
	<1462509629-24282-6-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34656 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbcEaM5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 08:57:41 -0400
Received: by mail-oi0-f67.google.com with SMTP id r64so30330876oie.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2016 05:57:41 -0700 (PDT)
In-Reply-To: <1462509629-24282-6-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Winkler <tomas.winkler@intel.com>, emilne@redhat.com, bart.vanassche@sandisk.com

On Fri, May 6, 2016 at 7:40 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> Permit changing of a LU name from a (fake) IEEE registered NAA (5)
> to a locally assigned UUID. Using a UUID (RFC 4122) for a SCSI
> designation descriptor (e.g. a LU name) was added in spc5r08.pdf
> (a draft INCITS standard) on 25 January 2016. Add parameter
> uuid_ctl to use a separate UUID for each LU (storage device) name.
> Additional option for all LU names to have the same UUID (since
> their storage is shared). Previous action of using NAA identifier
> for LU name remains the default.

> @@ -3503,6 +3520,9 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
>         sdebug_q_cmd_complete(sd_dp);
>  }
>
> +static bool got_shared_uuid;
> +static uuid_be shared_uuid;

So, the assignment to them is non-atomic, is it a problem here?

> @@ -3510,6 +3530,17 @@ static struct sdebug_dev_info *sdebug_device_create(
>
>         devip = kzalloc(sizeof(*devip), flags);
>         if (devip) {
> +               if (sdebug_uuid_ctl == 1)
> +                       uuid_be_gen(&devip->lu_name);
> +               else if (sdebug_uuid_ctl == 2) {
> +                       if (got_shared_uuid)
> +                               devip->lu_name = shared_uuid;
> +                       else {
> +                               uuid_be_gen(&shared_uuid);
> +                               got_shared_uuid = true;
> +                               devip->lu_name = shared_uuid;
> +                       }
> +               }

Perhaps
                       if (got_shared_uuid == false)
                               uuid_be_gen(&shared_uuid);
                               got_shared_uuid = true;
                       }
                       devip->lu_name = shared_uuid;

>                 devip->sdbg_host = sdbg_host;
>                 list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
>         }

> @@ -4150,6 +4182,8 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
>  MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
>  MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
>  MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
> +MODULE_PARM_DESC(uuid_ctl,
> +                "1->use uuid for lu name, 0->don't, 2->all use same (def=0)");

Why not on one line?

>  MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size_mb)");
>  MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
>  MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
> @@ -4787,6 +4821,12 @@ static ssize_t strict_store(struct device_driver *ddp, const char *buf,
>  }
>  static DRIVER_ATTR_RW(strict);
>
> +static ssize_t uuid_ctl_show(struct device_driver *ddp, char *buf)
> +{
> +       return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_uuid_ctl);

It will never show the difference between 1 and 2. Was it on purpose?

> +}
> +static DRIVER_ATTR_RO(uuid_ctl);

-- 
With Best Regards,
Andy Shevchenko
