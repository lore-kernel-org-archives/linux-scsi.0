From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 12/25] scsi: hisi_sas: add v1 HW initialisation code
Date: Tue, 13 Oct 2015 13:44:26 +0100
Message-ID: <561CFCAA.8030003@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-13-git-send-email-john.garry@huawei.com>
 <147982224.OvBbMyp8ci@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147982224.OvBbMyp8ci@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 12/10/2015 19:46, Arnd Bergmann wrote:
> On Monday 12 October 2015 23:20:24 John Garry wrote:
>> @@ -387,6 +392,21 @@ static int hisi_sas_probe(struct platform_device *pdev)
>>          }
>>
>>          hisi_sas_init_add(hisi_hba);
>> +
>> +       rc = hw_init_v1_hw(hisi_hba);
>> +       if (rc)
>> +               goto err_out_ha;
>> +
>> +       rc = interrupt_init_v1_hw(hisi_hba);
>> +       if (rc)
>> +               goto err_out_ha;
>> +
>> +       rc = interrupt_openall_v1_hw(hisi_hba);
>> +       if (rc)
>> +               goto err_out_ha;
>> +
>> +       phys_init_v1_hw(hisi_hba);
>> +
>>          rc = scsi_add_host(shost, &pdev->dev);
>>          if (rc)
>>                  goto err_out_ha;
>>
>
> As the probe function matches against the "hisilicon,sas-controller-v1"
> compatible string and contains mostly code that is specific to v1, I
> think it would be cleaner to move that to the hisi_sas_v1_hw.c as well
> and make the functions above static but make the common functions
> called here (hisi_sas_init_add etc) global.
>
> That would also include the hisi_sas_driver structure.
>
> 	Arnd
>
> .
>
Hello,

Just to be clear, are you saying that you would prefer hisi_sas_probe() 
and struct hisi_sas_driver to be relocated to hisi_sas_v1_hw.c?

I wanted to keep hisi_sas_v1_hw.c containing only code which accesses HW.

I could consoldate the calls of hw_init_v1_hw(), interrupt_init_v1_hw(), 
interrupt_openall_v1_hw(), and phys_init_v1_hw() to a single function hw 
init function call. Then most of the code in the probe function will not 
be specific to v1.

Regards,
John
