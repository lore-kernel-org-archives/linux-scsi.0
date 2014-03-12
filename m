From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v16 3/4] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Wed, 12 Mar 2014 12:01:42 -0700
Message-ID: <CAPw-ZTmvG1dMckif4xKrv-rg=8jAode0RWgFBjoi_5OXrB2RHQ@mail.gmail.com>
References: <1394575895-7039-1-git-send-email-lho@apm.com>
	<1394575895-7039-3-git-send-email-lho@apm.com>
	<1394575895-7039-4-git-send-email-lho@apm.com>
	<2172234.huOH9CEWA3@amdc1032>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:49310 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751833AbaCLTBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 15:01:43 -0400
Received: by mail-qg0-f48.google.com with SMTP id j107so30272899qga.7
        for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 12:01:42 -0700 (PDT)
In-Reply-To: <2172234.huOH9CEWA3@amdc1032>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> +MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
>> +
>> +static struct platform_driver xgene_ahci_driver = {
>> +     .probe = xgene_ahci_probe,
>> +     .remove = ata_platform_remove_one,
>
> It is good to use ata_platform_remove_one() here but some code still needs
> to callback ahci_platform_disable_resources() before the driver is removed
> completely.  The way other drivers do it is to define custom ->host_stop
> method and add it to port ops (xgene_ahci_ops in this case).  For X-Gene
> AHCI driver ->host_stop function can be quite simple and look like this:
>
> static void xgene_ahci_host_stop(struct ata_host *host)
> {
>         struct ahci_host_priv *hpriv = host->private_data;
>
>         ahci_platform_disable_resources(hpriv);
> }

Will do.

>
>> +     .driver = {
>> +             .name = "xgene-ahci",
>> +             .owner = THIS_MODULE,
>> +             .of_match_table = xgene_ahci_of_match,
>> +     },
>
> Power Management support is missing for this driver.  If your platform
> doesn't support Suspend to RAM yet it would be good to add a comment
> about this explaining the lack of PM.  Otherwise it should be fixed (you
> can take a look at ahci_imx.c and ahci_sunxi.c for examples).

In order to support PM, I will need an other errata fix in libachi.c.
For now PM, will NOT be support.

>
> Otherwise the driver looks good to me and (FWIW) you can add:
>
>         Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>
> Once the aforementioned issues are fixed.

I will post another version. If you ack'ed that version, Tejun can add
you to the Reviewed-by list.

-Loc
