From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 08/32] scsi: hisi_sas: add hisi_sas_remove
Date: Tue, 10 Nov 2015 10:55:02 +0000
Message-ID: <5641CD06.7030001@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
 <1447086757-147706-9-git-send-email-john.garry@huawei.com>
 <5641690E.10303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5641690E.10303@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "fangwei (I)" <fangwei1@huawei.com>
Cc: "JBottomley@odin.com" <JBottomley@odin.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "pawel.moll@arm.com" <pawel.moll@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "galak@codeaurora.org" <galak@codeaurora.org>, "arnd@arndb.de" <arnd@arndb.de>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry2@mail.dcu.ie" <john.garry2@mail.dcu.ie>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "hare@suse.de" <hare@suse.de>, "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
List-Id: linux-scsi@vger.kernel.org


>> +int hisi_sas_remove(struct platform_device *pdev)
>> +{
>> +	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
>> +	struct hisi_hba *hisi_hba = sha->lldd_ha;
>> +
>> +	sas_unregister_ha(sha);
>> +	sas_remove_host(sha->core.shost);
>> +	scsi_remove_host(sha->core.shost);
>
> scsi host should be removed before detaching SAS transport.
>
> See more information:
> http://www.spinics.net/lists/linux-scsi/msg90088.html
>
> Thanks,
> Wei
>
OK, I can make this minor change.

Thanks,
John

>> +	hisi_sas_free(hisi_hba);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(hisi_sas_remove);
>> +
>>   static __init int hisi_sas_init(void)
>>   {
>>   	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
>>
>
>
> .
>
