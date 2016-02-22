From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Mon, 22 Feb 2016 10:02:16 +0000
Message-ID: <56CADCA8.8030206@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
 <56C34163.70606@suse.de> <56C354A5.6080503@huawei.com>
 <56C5756A.9060700@suse.de> <56C59922.6070600@huawei.com>
 <56C59D47.30500@suse.de> <56C5A3A6.1090100@huawei.com>
 <56C6F28B.9090000@huawei.com> <56C72747.5070909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C72747.5070909@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linux-kernel@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org


>> I would like to make another point about why I am making this change
>> in case it is not clear. The queue full events are form
>> TRANS_TX_CREDIT_TIMEOUT_ERR and TRANS_TX_CLOSE_NORMAL_ERR errors in
>> the slot: I want the slot retried when this occurs, so I set status
>> as SAS_QUEUE_FULL just so we will report DID_SOFT_ERR to SCSI
>> midlayer so we get a retry. I could use SAS_OPEN_REJECT
>> alternatively as the error which would have the same affect.
>> The queue full are not from all slots being consumed in the HBA.
>>
> Ah, right. So you might be getting those errors even with some free
> slots on the HBA. As such they are roughly equivalent to a
> QUEUE_FULL SCSI statue, right?
> So after reading SPL I guess you are right here; using tags wouldn't
> help for this situation.
>

Yes, I think we have 90% of slots free in the host when this occurs for 
one particular test - Our v2 hw has 2K slots, which is >> cmd_per_lun. 
The errors are equivalent to queue full for the device.

Thanks,
John

> Cheers,
>
> Hannes
>
