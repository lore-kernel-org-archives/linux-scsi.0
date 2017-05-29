From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 07/22] scsi: hisi_sas: create hisi_sas_get_fw_info()
Date: Mon, 29 May 2017 12:18:05 +0100
Message-ID: <25de582f-ad54-c30a-f0e5-6de54f04917f@huawei.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
 <1495713911-80476-8-git-send-email-john.garry@huawei.com>
 <CAK8P3a1ySYpsa=sWo3xkXA7uBz_zYxfTecXMuX6C3d1HEg=qyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1ySYpsa=sWo3xkXA7uBz_zYxfTecXMuX6C3d1HEg=qyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

  is
On 29/05/2017 11:53, Arnd Bergmann wrote:
> On Thu, May 25, 2017 at 2:04 PM, John Garry <john.garry@huawei.com> wrote:
>> Move the functionality to retrieve the fw info into
>> a dedicated device type-agnostic function,
>> hisi_sas_get_fw_info().
>>
>> The reasoning is that this function will be required
>> for future pci-based platforms.
>>
>
>> -
>>         if (device_property_read_u8_array(dev, "sas-addr", hisi_hba->sas_addr,
>> -                                         SAS_ADDR_SIZE))
>> -               goto err_out;
>> +                                         SAS_ADDR_SIZE)) {
>> +               dev_err(dev, "could not get property sas-addr\n");
>> +               return -ENOENT;
>> +       }
>>
>>         if (np) {
>>                 hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(np,
>>                                         "hisilicon,sas-syscon");
>> -               if (IS_ERR(hisi_hba->ctrl))
>> -                       goto err_out;
>> +               if (IS_ERR(hisi_hba->ctrl)) {
>> +                       dev_err(dev, "could not get syscon\n");
>> +                       return -ENOENT;
>> +               }
>
> If I read this right, it will fail to work for a PCI-based driver trying to read
> "sas-addr" but not the other properties that would now be hardcoded from
> the PCI ID.
>
> Maybe you just need

Hi Arnd,

So we only require these properties for platform device with DT 
firmware. This code is same as before (apart from adding the comments), 
but I'll consider adding a verbose comment.

As for the check, effectively I already have what you recommend in how 
np is evaluated:
+	struct platform_device *pdev = hisi_hba->platform_dev;
+	struct device_node *np = pdev ? pdev->dev.of_node : NULL;
  	struct clk *refclk;

Much appreciated,
John



>
> -          if (np) {
> +         if (np && is_platform_device) {
>
>        Arnd
>
> .
>
