From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 07/22] scsi: hisi_sas: create hisi_sas_get_fw_info()
Date: Mon, 29 May 2017 12:53:30 +0200
Message-ID: <CAK8P3a1ySYpsa=sWo3xkXA7uBz_zYxfTecXMuX6C3d1HEg=qyg@mail.gmail.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com> <1495713911-80476-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33409 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdE2Kxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2017 06:53:31 -0400
In-Reply-To: <1495713911-80476-8-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, May 25, 2017 at 2:04 PM, John Garry <john.garry@huawei.com> wrote:
> Move the functionality to retrieve the fw info into
> a dedicated device type-agnostic function,
> hisi_sas_get_fw_info().
>
> The reasoning is that this function will be required
> for future pci-based platforms.
>

> -
>         if (device_property_read_u8_array(dev, "sas-addr", hisi_hba->sas_addr,
> -                                         SAS_ADDR_SIZE))
> -               goto err_out;
> +                                         SAS_ADDR_SIZE)) {
> +               dev_err(dev, "could not get property sas-addr\n");
> +               return -ENOENT;
> +       }
>
>         if (np) {
>                 hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(np,
>                                         "hisilicon,sas-syscon");
> -               if (IS_ERR(hisi_hba->ctrl))
> -                       goto err_out;
> +               if (IS_ERR(hisi_hba->ctrl)) {
> +                       dev_err(dev, "could not get syscon\n");
> +                       return -ENOENT;
> +               }

If I read this right, it will fail to work for a PCI-based driver trying to read
"sas-addr" but not the other properties that would now be hardcoded from
the PCI ID.

Maybe you just need

-          if (np) {
+         if (np && is_platform_device) {

       Arnd
