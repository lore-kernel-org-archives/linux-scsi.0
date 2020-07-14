Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA82C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33707217BA
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CvsXyd4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGNIGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:06:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34662 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgGNIGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 04:06:10 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200714080607euoutp025534f44ca963dfa8d0fb7de8dace05ce~hj_dsvre61171011710euoutp02G
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 08:06:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200714080607euoutp025534f44ca963dfa8d0fb7de8dace05ce~hj_dsvre61171011710euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594713967;
        bh=Ua9oZ5pZd8RYAwxiYpZ0yf7db5J1tmVHCQS8Ej5ZmjY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CvsXyd4GJNGFTd0FcqPQlCr8T2VSb6yZeumVuztK3IBDBInI0UcuAuVX4UPrOn2cm
         ZvsLt1ntjL8yq+K8ozzB3vWawMNJBCak9PlLMTA3lrSEJEdI/bxN3ujeyWH5VcJf3w
         sDW9CADQAa0ojSz1aohzP9aSEZuAcXEcwGu8W17g=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200714080606eucas1p1f3d16ec505f6be9b0fee7588830c9430~hj_dfwKH71725517255eucas1p1u;
        Tue, 14 Jul 2020 08:06:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 86.F6.06318.E676D0F5; Tue, 14
        Jul 2020 09:06:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200714080606eucas1p2cefa066eb51d5c48788f37545d7c3882~hj_dJvX492478724787eucas1p29;
        Tue, 14 Jul 2020 08:06:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200714080606eusmtrp29641c778d16acdb0baef31baccb43889~hj_dJJJki0873708737eusmtrp2V;
        Tue, 14 Jul 2020 08:06:06 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-2c-5f0d676e53e6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7B.12.06314.E676D0F5; Tue, 14
        Jul 2020 09:06:06 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200714080606eusmtip228984c2f89f5375abeee145991451854~hj_cqOHGe2804728047eusmtip2n;
        Tue, 14 Jul 2020 08:06:06 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     tasleson@redhat.com
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
Date:   Tue, 14 Jul 2020 10:06:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsWy7djP87p56bzxBt/Wm1s0L17PZrH3lrbF
        sR2PmCy6r+9gs7h47ya7A6vH/rlr2D3e77vK5vF5k1wAcxSXTUpqTmZZapG+XQJXxsxFu1gK
        HsZVPJ57kLWB8bprFyMnh4SAicTPz3fYuxi5OIQEVjBKbNs9nQnC+cIosXbjO2YI5zOjxPxT
        IBmIlgnfG1khEssZJa7/eA/lvGWU6J69E6iFg0NYwE5i8c9CkAYRAXGJewvXgE1iFuhklPj5
        aA8zSIJNwEpiYvsqRhCbF6j+b+tJsDiLgKrE8f5esLioQITEpweHWSFqBCVOznzCAmJzAtXP
        vnaaDcRmBlpw68l8JghbXmL72zlgyyQEprNLrHgxBepsF4n181cwQ9jCEq+Ob2GHsGUk/u+c
        zwTRsI5R4m/HC6ju7YwSyyf/Y4Oospa4c+4XG8hrzAKaEut36UOEHSXuHnnHAhKWEOCTuPFW
        EOIIPolJ26YzQ4R5JTrahCCq1SQ2LNvABrO2a+dK5gmMSrOQvDYLyTuzkLwzC2HvAkaWVYzi
        qaXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIHJ5fS/4193MO77k3SIUYCDUYmHV8KfJ16INbGs
        uDL3EKMEB7OSCK/T2dNxQrwpiZVVqUX58UWlOanFhxilOViUxHmNF72MFRJITyxJzU5NLUgt
        gskycXBKNTCm690x1P8wVT1XI3fLh8sTFA825N9eMH+tXN/WT38Tyl85bT+le8Gj9XkIc8dq
        gef/7v3t2fKm3j9uyaumOQk/etfXWy9jEJDOP+97M0n+64MN9f5ly83j9rKvOT9z8/wFbi2c
        jFfqP+o+mM1qlHhMWPr8xn4ty1kPb03Z7SKT8/zgpZu3L9ZEKbEUZyQaajEXFScCAFWzjeUq
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xe7p56bzxBvP3yVk0L17PZrH3lrbF
        sR2PmCy6r+9gs7h47ya7A6vH/rlr2D3e77vK5vF5k1wAc5SeTVF+aUmqQkZ+cYmtUrShhZGe
        oaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexsxFu1gKHsZVPJ57kLWB8bprFyMnh4SA
        icSE742sXYxcHEICSxklNlxfz9bFyAGUkJE4vr4MokZY4s+1LjaImteMEk9fdzOB1AgL2Eks
        /lkIUiMiIC5xb+EaZpAaZoFORokXe58wQzQsY5L49OEmE0gVm4CVxMT2VYwgNi9Q89/Wk8wg
        NouAqsTx/l6wuKhAhMThHbOgagQlTs58wgJicwLVz752mg3EZhZQl/gz7xIzhC0ucevJfCYI
        W15i+9s5zBMYhWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIyl
        bcd+bt7BeGlj8CFGAQ5GJR5eCX+eeCHWxLLiytxDjBIczEoivE5nT8cJ8aYkVlalFuXHF5Xm
        pBYfYjQFem4is5Rocj4wzvNK4g1NDc0tLA3Njc2NzSyUxHk7BA7GCAmkJ5akZqemFqQWwfQx
        cXBKNTBWr1u8Xj0/fOYJBzMV2ZXspxT/aH9Y+pHrySq5+u3Pv7pmb8r4KpGxeBHbmW0Zko4T
        y1+K3OzrKbe/devgo7ULjj9LPXxX6reg7cOd1gcdfjlc+tcaHlVUlZNqtHdhd4rZivfL88IO
        iYTvXGjxqWbSEQOXXwGnNBa+vpUjJ5Ws3zOvrXVu1q4JSizFGYmGWsxFxYkAo3mrtrsCAAA=
X-CMS-MailID: 20200714080606eucas1p2cefa066eb51d5c48788f37545d7c3882
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
References: <20200623191749.115200-1-tasleson@redhat.com>
        <20200623191749.115200-6-tasleson@redhat.com>
        <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
        <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
        <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Tony,

On 7/9/20 11:18 PM, Tony Asleson wrote:
> Hi Bartlomiej,
> 
> On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
>> The root source of problem is that libata transport uses different
>> naming scheme for ->tdev devices (please see dev_set_name() in
>> ata_t{dev,link,port}_add()) than libata core for its logging
>> functionality (ata_{dev,link,port}_printk()).
>>
>> Since libata transport is part of sysfs ABI we should be careful
>> to not break it so one idea for solving the issue is to convert
>> ata_t{dev,link,port}_add() to use libata logging naming scheme and
>> at the same time add sysfs symlinks for the old libata transport
>> naming scheme.
> 
> I tried doing as you suggested.  I've included what I've done so far.  I
> haven't been able to get all the needed parts for the symlinks to
> maintain compatibility.
> 
> The /sys/class/.. seems OK, eg.
> 
> $  ls -x -w 70 /sys/class/ata_[dl]*
> /sys/class/ata_device:
> ata1.00  ata2.00  ata3.00  ata4.00  ata5.00  ata6.00  ata7.00
> ata7.01  ata8.00  ata8.01  dev1.0   dev2.0   dev3.0   dev4.0
> dev5.0   dev6.0   dev7.0   dev7.1   dev8.0   dev8.1
> 
> /sys/class/ata_link:
> ata1   ata2   ata3   ata4   ata5   ata6   ata7  ata8  link1  link2
> link3  link4  link5  link6  link7  link8
> 
> but the implementation is a hack, see device.h, core.c changes.  There
> must be a better way?
> 
> Also I'm missing part of the full path, eg.
> 
> /sys/devices/pci0000:00/0000:00:01.1/ata7/link7/dev7.0/ata_device/dev7.0/gscr
> 
> becomes
> 
> /sys/devices/pci0000:00/0000:00:01.1/ata7/ata7/ata7.01/ata_device/ata7.01/gscr
> 
> but the compatibility symlinks added only get me to
> 
> /sys/devices/pci0000:00/0000:00:01.1/ata7/link7/dev7.0/ata_device/
> 
> I haven't found the right spot to get the last symlink included.
> 
> If you or anyone else has suggestions to correct the incomplete symlink
> and/or correct the implementation to set the
> /sys/class/ata_device it would be greatly appreciated.

Unfortunately I know too little about sysfs class-es handling to help
(I've added linux-{scsi,block} MLs & Greg to Cc:).

PS If libata support turns out to be blocking the patchset progress you
may consider concentrating on getting SCSI & NVME support merged first..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Thanks,
> -Tony
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index beca5f91bb4c..2aa230ad813e 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6444,7 +6444,7 @@ void ata_port_printk(const struct ata_port *ap,
> const char *level,
>         vaf.fmt = fmt;
>         vaf.va = &args;
> 
> -       printk("%sata%u: %pV", level, ap->print_id, &vaf);
> +       dev_printk(level, &ap->tdev, "%pV", &vaf);
> 
>         va_end(args);
>  }
> @@ -6461,12 +6461,7 @@ void ata_link_printk(const struct ata_link *link,
> const char *level,
>         vaf.fmt = fmt;
>         vaf.va = &args;
> 
> -       if (sata_pmp_attached(link->ap) || link->ap->slave_link)
> -               printk("%sata%u.%02u: %pV",
> -                      level, link->ap->print_id, link->pmp, &vaf);
> -       else
> -               printk("%sata%u: %pV",
> -                      level, link->ap->print_id, &vaf);
> +       dev_printk(level, &link->tdev, "%pV", &vaf);
> 
>         va_end(args);
>  }
> @@ -6483,9 +6478,7 @@ void ata_dev_printk(const struct ata_device *dev,
> const char *level,
>         vaf.fmt = fmt;
>         vaf.va = &args;
> 
> -       printk("%sata%u.%02u: %pV",
> -              level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
> -              &vaf);
> +       dev_printk(level, &dev->tdev,"%pV", &vaf);
> 
>         va_end(args);
>  }
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index 6a40e3c6cf49..e5870f9b2b21 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -288,7 +288,7 @@ int ata_tport_add(struct device *parent,
>         dev->parent = parent;
>         ata_host_get(ap->host);
>         dev->release = ata_tport_release;
> -       dev_set_name(dev, "ata%d", ap->print_id);
> +       dev_set_name(dev, "ata%u", ap->print_id);
>         transport_setup_device(dev);
>         ata_acpi_bind_port(ap);
>         error = device_add(dev);
> @@ -374,6 +374,46 @@ static int ata_tlink_match(struct
> attribute_container *cont,
>         return &i->link_attr_cont.ac == cont;
>  }
> 
> +static struct device* tlink_to_symlink(struct device *dev) {
> +       struct ata_internal* i =
> to_ata_internal(ata_scsi_transport_template);
> +       return
> attribute_container_find_class_device(&i->link_attr_cont.ac, dev);
> +}
> +
> +void ata_tlink_symlink_add_del(struct ata_link *link, int add) {
> +       struct device *dev = &link->tdev;
> +       struct ata_port *ap = link->ap;
> +       char lname[64];
> +       struct device *devp = tlink_to_symlink(dev);
> +
> +       if (ata_is_host_link(link)) {
> +               snprintf(lname, sizeof(lname),
> +                       "link%d", ap->print_id);
> +       } else {
> +               snprintf(lname, sizeof(lname),
> +                       "link%d.%d", ap->print_id, link->pmp);
> +       }
> +
> +       if (add) {
> +               int e;
> +
> +               e = device_add_class_symlinks_additional(devp, lname);
> +               if (e) {
> +                        dev_warn(devp, "Error %d tlink symlink
> class\n", e);
> +               }
> +
> +               e = sysfs_create_link(&dev->parent->kobj, &dev->kobj,
> lname);
> +               if (e) {
> +                        dev_warn(dev, "Error %d tlink symlink\n", e);
> +               }
> +       } else {
> +               sysfs_delete_link(&dev->parent->kobj, &dev->kobj, lname);
> +               device_delete_class_symlinks_additional(devp, lname);
> +       }
> +}
> +
> +#define ata_tlink_symlink_add(x) ata_tlink_symlink_add_del(x, 1)
> +#define ata_tlink_symlink_del(x) ata_tlink_symlink_add_del(x, 0)
> +
>  /**
>   * ata_tlink_delete  --  remove ATA LINK
>   * @port:      ATA LINK to remove
> @@ -389,6 +429,7 @@ void ata_tlink_delete(struct ata_link *link)
>                 ata_tdev_delete(ata_dev);
>         }
> 
> +       ata_tlink_symlink_del(link);
>         transport_remove_device(dev);
>         device_del(dev);
>         transport_destroy_device(dev);
> @@ -415,9 +456,9 @@ int ata_tlink_add(struct ata_link *link)
>         dev->parent = &ap->tdev;
>         dev->release = ata_tlink_release;
>         if (ata_is_host_link(link))
> -               dev_set_name(dev, "link%d", ap->print_id);
> -        else
> -               dev_set_name(dev, "link%d.%d", ap->print_id, link->pmp);
> +               dev_set_name(dev, "ata%u", ap->print_id);
> +       else
> +               dev_set_name(dev, "ata%u.%02u", ap->print_id, link->pmp);
> 
>         transport_setup_device(dev);
> 
> @@ -429,6 +470,8 @@ int ata_tlink_add(struct ata_link *link)
>         transport_add_device(dev);
>         transport_configure_device(dev);
> 
> +       ata_tlink_symlink_add(link);
> +
>         ata_for_each_dev(ata_dev, link, ALL) {
>                 error = ata_tdev_add(ata_dev);
>                 if (error) {
> @@ -440,6 +483,7 @@ int ata_tlink_add(struct ata_link *link)
>         while (--ata_dev >= link->device) {
>                 ata_tdev_delete(ata_dev);
>         }
> +       ata_tlink_symlink_del(link);
>         transport_remove_device(dev);
>         device_del(dev);
>    tlink_err:
> @@ -630,6 +674,44 @@ static void ata_tdev_free(struct ata_device *dev)
>         put_device(&dev->tdev);
>  }
> 
> +static struct device* tdev_to_symlink(struct device *dev) {
> +       struct ata_internal* i =
> to_ata_internal(ata_scsi_transport_template);
> +       return
> attribute_container_find_class_device(&i->dev_attr_cont.ac, dev);
> +}
> +
> +void ata_tdev_symlink_add_del(struct ata_device *ata_dev, int add) {
> +       struct device *dev = &ata_dev->tdev;
> +       struct ata_link *link = ata_dev->link;
> +       struct ata_port *ap = link->ap;
> +       char dname[64];
> +
> +       struct device *devp = tdev_to_symlink(dev);
> +
> +       if (ata_is_host_link(link))
> +               snprintf(dname, sizeof(dname), "dev%d.%d",
> ap->print_id,ata_dev->devno);
> +       else
> +               snprintf(dname, sizeof(dname), "dev%d.%d.0",
> ap->print_id, link->pmp);
> +
> +       if (add) {
> +               int e;
> +               e = device_add_class_symlinks_additional(devp, dname);
> +               if (e) {
> +                        dev_warn(devp, "Error %d tdev symlink class\n", e);
> +               }
> +
> +               e = sysfs_create_link(&dev->parent->kobj, &dev->kobj,
> dname);
> +               if (e) {
> +                        dev_warn(dev, "Error %d tdev symlink\n", e);
> +               }
> +       } else {
> +               sysfs_delete_link(&dev->parent->kobj, &dev->kobj, dname);
> +               device_delete_class_symlinks_additional(devp, dname);
> +       }
> +}
> +
> +#define ata_tdev_symlink_add(x) ata_tdev_symlink_add_del(x, 1)
> +#define ata_tdev_symlink_del(x) ata_tdev_symlink_add_del(x, 0)
> +
>  /**
>   * ata_tdev_delete  --  remove ATA device
>   * @port:      ATA PORT to remove
> @@ -640,6 +722,7 @@ static void ata_tdev_delete(struct ata_device *ata_dev)
>  {
>         struct device *dev = &ata_dev->tdev;
> 
> +       ata_tdev_symlink_del(ata_dev);
>         transport_remove_device(dev);
>         device_del(dev);
>         ata_tdev_free(ata_dev);
> @@ -665,10 +748,8 @@ static int ata_tdev_add(struct ata_device *ata_dev)
>         device_initialize(dev);
>         dev->parent = &link->tdev;
>         dev->release = ata_tdev_release;
> -       if (ata_is_host_link(link))
> -               dev_set_name(dev, "dev%d.%d", ap->print_id,ata_dev->devno);
> -        else
> -               dev_set_name(dev, "dev%d.%d.0", ap->print_id, link->pmp);
> +
> +       dev_set_name(dev, "ata%u.%02u", ap->print_id, link->pmp +
> ata_dev->devno);
> 
>         transport_setup_device(dev);
>         ata_acpi_bind_dev(ata_dev);
> @@ -680,6 +761,8 @@ static int ata_tdev_add(struct ata_device *ata_dev)
> 
>         transport_add_device(dev);
>         transport_configure_device(dev);
> +
> +       ata_tdev_symlink_add(ata_dev);
>         return 0;
>  }
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index c2439d12608d..bc060000837c 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2269,6 +2269,16 @@ static int device_add_class_symlinks(struct
> device *dev)
>         return error;
>  }
> 
> +int device_add_class_symlinks_additional(struct device *dev, char *name) {
> +       return sysfs_create_link(&dev->class->p->subsys.kobj,
> &dev->kobj, name);
> +}
> +EXPORT_SYMBOL_GPL(device_add_class_symlinks_additional);
> +
> +void device_delete_class_symlinks_additional(struct device *dev, char
> *name) {
> +       sysfs_delete_link(&dev->class->p->subsys.kobj, &dev->kobj, name);
> +}
> +EXPORT_SYMBOL_GPL(device_delete_class_symlinks_additional);
> +
>  static void device_remove_class_symlinks(struct device *dev)
>  {
>         if (dev_of_node(dev))
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 281755404c21..4827d86116ab 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -656,6 +656,10 @@ static inline const char *dev_name(const struct
> device *dev)
>  extern __printf(2, 3)
>  int dev_set_name(struct device *dev, const char *name, ...);
> 
> +
> +int device_add_class_symlinks_additional(struct device *dev, char *name);
> +void device_delete_class_symlinks_additional(struct device *dev, char
> *name);
> +
>  int dev_durable_name(const struct device *d, char *buffer, size_t len);
> 
>  #ifdef CONFIG_NUMA
> 
