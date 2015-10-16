From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS
 framework
Date: Fri, 16 Oct 2015 14:29:55 +0100
Message-ID: <5620FBD3.2020902@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-14-git-send-email-john.garry@huawei.com>
 <3757591.KXgD8p0a1E@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3757591.KXgD8p0a1E@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 16/10/2015 13:55, Arnd Bergmann wrote:
> On Monday 12 October 2015 23:20:25 John Garry wrote:
>> @@ -804,6 +818,16 @@ static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
>>                  phy->identify.target_port_protocols =
>>                          SAS_PROTOCOL_SMP;
>>
>> +       wq = kmalloc(sizeof(*wq), GFP_ATOMIC);
>> +       if (!wq)
>> +               goto end;
>> +
>> +       wq->event = PHYUP;
>> +       wq->hisi_hba = hisi_hba;
>> +       wq->phy_no = phy_no;
>> +
>> +       INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
>> +       queue_work(hisi_hba->wq, &wq->work_struct);
>>
>>   end:
>>          hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
>>
>
> While rereading some other parts of the code, I stumbled over this piece.
> You should generally not allocate work structs dynamically. Why not embed
> the work struct inside of the phy structure and then just queue that?
>
> 	Arnd
>
> .
>

It could be considered.

A potential issue I see is with hisi_sas_control_phy() for 
PHY_FUNC_HARD_RESET: this allocates a hisi_sas_wq struct and processes 
the reset in the queue work. When we re-enable the phy for the reset, 
the phyup irq will want to use the same hisi_sas_wq struct which may be 
in use.

hisi_sas_control_phy() is added in 23/35.

John
