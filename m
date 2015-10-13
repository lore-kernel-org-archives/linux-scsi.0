From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 04/25] scsi: hisi_sas: add scsi host registration
Date: Tue, 13 Oct 2015 10:16:55 +0100
Message-ID: <561CCC07.2090901@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-5-git-send-email-john.garry@huawei.com>
 <5053179.dHmgEztyeB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5053179.dHmgEztyeB@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 12/10/2015 16:21, Arnd Bergmann wrote:
> On Monday 12 October 2015 23:20:16 John Garry wrote:
>> +
>> +       shost = scsi_host_alloc(&hisi_sas_sht, sizeof(void *));
>> +       if (!shost)
>> +               return -ENOMEM;
>> +
>> +       hisi_hba = hisi_sas_hba_alloc(pdev, shost, np);
>> +       if (!hisi_hba) {
>> +               rc = -ENOMEM;
>> +               goto err_out_ha;
>> +       }
>
> You can collapse the allocations into one and just pass sizeof(*hisi_hba)
> instead of sizeof(void *) above.
>
Will address.

>
>> +       sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
>> +       platform_set_drvdata(pdev, sha);
>> +
>> +       phy_nr = port_nr = HISI_SAS_MAX_PHYS;
>> +
>> +       arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
>> +       arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
>> +       if (!arr_phy || !arr_port)
>> +               return -ENOMEM;
>
> And since these are fixed-size arrays, they can be moved in there as well.
>
In a later patch we set as follows:
phy_nr = port_nr = hisi_hba->n_phy;

You did say in our earlier private review that we could add statically 
to hba strcut, but I commented that other vendors do similar so I would 
wait for more input.

> 	Arnd
>
> .
>

Thanks,
John
