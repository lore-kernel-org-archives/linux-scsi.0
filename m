From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] libata: fix probe_ent alloc/free bugs
Date: Sat, 17 Feb 2007 20:43:48 +0300
Message-ID: <45D73ED4.80505@ru.mvista.com>
References: <45D710E8.3090104@gmail.com> <1171725374.3379.15.camel@mulgrave.il.steeleye.com> <45D73A55.90008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45D73A55.90008@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:
> ata_probe_ent_alloc() had a temporary hack such that devm_kzalloc()
> was used for allocation if devres had been previously initialized on
> the device; otherwise, plain kzalloc() was used.  This was to make the
> code useable from both the old and devres-aware libata drivers during
> transition.  This hack made ata_sas_port_alloc() unable to determine
> how the probe_ent is allocated, causing double free in some cases.
> 
> Remove the now-unneeded hack and make ata_sas_port_alloc() use
> devm_kfree().

[...]

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 2cf8251..c34e0b4 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5891,11 +5891,7 @@ ata_probe_ent_alloc(struct device *dev, const 
> struct ata_port_info *port)
> {
>     struct ata_probe_ent *probe_ent;
> 
> -    /* XXX - the following if can go away once all LLDs are managed */
> -    if (!list_empty(&dev->devres_head))
> -        probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
> -    else
> -        probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
> +    probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
>     if (!probe_ent) {
>         printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
>                kobject_name(&(dev->kobj)));
[...]

    The patch certainly looks mangled tab-wise. :-)

MBR, Sergei
