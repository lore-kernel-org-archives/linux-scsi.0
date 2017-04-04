From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi: ses: don't get power status of SES device slot on probe
Date: Tue, 4 Apr 2017 14:07:55 -0700
Message-ID: <CAPcyv4jqgh97JVnWMFC5kLJDeu6zaY2zZtaYAHTM0w2a0hBmSw@mail.gmail.com>
References: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36622 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbdDDVH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 17:07:56 -0400
Received: by mail-oi0-f53.google.com with SMTP id r203so178392056oib.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Apr 2017 14:07:56 -0700 (PDT)
In-Reply-To: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, gpiccoli@linux.vnet.ibm.com

On Wed, Mar 29, 2017 at 6:02 PM, Mauricio Faria de Oliveira
<mauricfo@linux.vnet.ibm.com> wrote:
> The commit 08024885a2a3 ("ses: Add power_status to SES device slot")
> introduced the 'power_status' attribute to enclosure components and
> the associated callbacks.
>
> There are 2 callbacks available to get the power status of a device:
> 1) ses_get_power_status() for 'struct enclosure_component_callbacks'
> 2) get_component_power_status() for the sysfs device attribute
> (these are available for kernel-space and user-space, respectively.)
>
> However, despite both methods being available to get power status
> on demand, that commit also introduced a call to get power status
> in ses_enclosure_data_process().
>
> This dramatically increased the total probe time for SCSI devices
> on larger configurations, because ses_enclosure_data_process() is
> called several times during the SCSI devices probe and loops over
> the component devices (but that is another problem, another patch).
>
> That results in a tremendous continuous hammering of SCSI Receive
> Diagnostics commands to the enclosure-services device, which does
> delay the total probe time for the SCSI devices __significantly__:
>
>   Originally, ~34 minutes on a system attached to ~170 disks:
>
>     [ 9214.490703] mpt3sas version 13.100.00.00 loaded
>     ...
>     [11256.580231] scsi 17:0:177:0: qdepth(16), tagged(1), simple(0),
>                    ordered(0), scsi_level(6), cmd_que(1)
>
>   With this patch, it decreased to ~2.5 minutes -- a 13.6x faster
>
>     [ 1002.992533] mpt3sas version 13.100.00.00 loaded
>     ...
>     [ 1151.978831] scsi 11:0:177:0: qdepth(16), tagged(1), simple(0),
>                    ordered(0), scsi_level(6), cmd_que(1)
>
> Another downside is that the SCSI device class lock is held during
> the executions of ses_enclosure_data_process() since it's a callee
> of ses_intf_add(), which is executed under that lock in device_add().
> This ends up blocking the parallel SCSI scan functionality because
> device_add() depends on that lock, and also the removal of devices
> via device_del() (e.g., during an enclosure reboot).
>
> Back to the commit discussion.. on the ses_get_power_status() call
> introduced in ses_enclosure_data_process(): impact of removing it.
>
> That may possibly be in place to initialize the power status value
> on device probe.  However, those 2 functions available to retrieve
> that value _do_ automatically refresh/update it.  So the potential
> benefit would be a direct access of the 'power_status' field which
> does not use the callbacks...
>
> But the only reader of 'struct enclosure_component::power_status'
> is the get_component_power_status() callback for sysfs attribute,
> and it _does_ check for and call the .get_power_status callback,
> (which indeed is defined and implemented by that commit), so the
> power status value is, again, automatically updated.
>
> So, the remaining potential for a direct/non-callback access to
> the power_status attribute would be out-of-tree modules -- well,
> for those, if they are for whatever reason interested in values
> that are set during device probe and not up-to-date by the time
> they need it.. well, that would be curious.
>
> So, for out-of-tree modules and people still interested in this
> behavior (in case I might have missed something about it, other
> than the total probe time impact): let's add a module parameter
> to keep that check turned on (disabled by default).
>
> Also, to handle that more properly, set the initial power state
> value to '-1' (i.e., uninitialized) instead of '1' (power 'on'),
> and check for it in that callback which may do an direct access
> to the field value _if_ a callback function is not defined.
>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Fixes: 08024885a2a3 ("ses: Add power_status to SES device slot")
> ---
>  drivers/misc/enclosure.c | 6 +++++-
>  drivers/scsi/ses.c       | 9 ++++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 65fed7146e9b..d3a8a13c4247 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -148,7 +148,7 @@ struct enclosure_device *
>         for (i = 0; i < components; i++) {
>                 edev->component[i].number = -1;
>                 edev->component[i].slot = -1;
> -               edev->component[i].power_status = 1;
> +               edev->component[i].power_status = -1;
>         }
>
>         mutex_lock(&container_list_lock);
> @@ -594,6 +594,10 @@ static ssize_t get_component_power_status(struct device *cdev,
>
>         if (edev->cb->get_power_status)
>                 edev->cb->get_power_status(edev, ecomp);
> +
> +       if (ecomp->power_status == -1)
> +               return -EINVAL;
> +

Can we ever hit this if get_power_status is non-null?

>         return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off");
>  }
>
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 50adabbb5808..2fafefd419c1 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -36,6 +36,12 @@
>
>  #include <scsi/scsi_transport_sas.h>
>
> +static bool power_status_on_probe;     /* default: false, 0. */
> +module_param(power_status_on_probe, bool, 0644);
> +MODULE_PARM_DESC(power_status_on_probe, "get power status of SES device slots "
> +                                       "(enclosure components) at probe time "
> +                                       "(warning: may delay total probe time)");
> +

I don't think we need this module parameter as long as the only way to
read the power status is through sysfs. We can always just leave it to
be read on-demand when needed.
