From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v14 2/3] ata: Add APM X-Gene SoC AHCI SATA host controller driver
Date: Wed, 5 Mar 2014 13:25:05 -0800
Message-ID: <CAPw-ZT=BFjmFeiRL4fdYK8+R7baTWaAmQ4aXrJ-UUtDPqXUSog@mail.gmail.com>
References: <1393306087-2875-1-git-send-email-lho@apm.com>
	<1393306087-2875-2-git-send-email-lho@apm.com>
	<1393306087-2875-3-git-send-email-lho@apm.com>
	<1580977.AbkFy4UXLu@amdc1032>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:33999 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756051AbaCEVZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 16:25:07 -0500
Received: by mail-qc0-f172.google.com with SMTP id i8so1878312qcq.17
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2014 13:25:05 -0800 (PST)
In-Reply-To: <1580977.AbkFy4UXLu@amdc1032>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> +#define pdata_to_ctx(x) container_of(x, struct xgene_ahci_context, plat_data)
>> +
>> +struct xgene_ahci_context {
>> +     struct ahci_platform_data plat_data;
>
> plat_data is used only to get to struct xgene_ahci_context instance
> so it can be removed (especially since we want to remove struct
> ahci_platform_data altogether in the long-term) and hpriv->plat_data
> should be set to point to context instance itself.  Actually, this
> seems to be the case already as hpriv->plat_data is set to hplat_data
> (not to &hplat_data->plat_data) in xgene_ahci_probe() so I wonder how
> does this driver work currently?

I will remove the plat_data. .

>> +/**
>> + * xgene_ahci_read_id - Read ID data from the specified device
>> + * @dev: device
>> + * @tf: proposed taskfile
>> + * @id: data buffer
>> + *
>> + * This custom read ID function is required due to the fact that the HW
>> + * does not support DEVSLP and the controller state machine may get stuck
>> + * after processing the ID query command.
>> + */
>> +static unsigned int xgene_ahci_read_id(struct ata_device *dev,
>> +                                    struct ata_taskfile *tf, u16 *id)
>> +{
>> +     u32 err_mask;
>> +     void __iomem *port_mmio = ahci_port_base(dev->link->ap);
>> +
>> +     err_mask = ata_do_dev_read_id(dev, tf, id);
>> +     if (err_mask)
>> +             return err_mask;
>> +
>> +     /*
>> +      * Mask reserved area. Bit78 spec of Link Power Management
>
> Word78?

Yes...

>
>> +      * bit15-8: reserved
>> +      * bit7: NCQ autosence
>> +      * bit6: Software settings preservation supported
>> +      * bit5: reserved
>> +      * bit4: In-order sata delivery supported
>> +      * bit3: DIPM requests supported
>> +      * bit2: DMA Setup FIS Auto-Activate optimization supported
>> +      * bit1: DMA Setup FIX non-Zero buffer offsets supported
>> +      * bit0: Reserved
>> +      *
>> +      * Clear reserved bit (DEVSLP bit) as we don't support DEVSLP
>> +      */
>> +     id[78] &= 0x00FF;

I will also fix this up by bit mask off.

>> +
>> +     /* HW requires toggle of the clock */
>> +     ahci_platform_disable_clks(hpriv);
>> +     rc = ahci_platform_enable_clks(hpriv);
>
> Why is this needed (extra clocks disable->enable sequence)?

This is an HW errata with the clock. If I don't give the clock an full
cycle, it doesn't work.

-Loc
