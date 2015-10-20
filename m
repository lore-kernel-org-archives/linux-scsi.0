From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS
 framework
Date: Tue, 20 Oct 2015 10:09:06 +0100
Message-ID: <562604B2.7060101@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <4269975.xfCo9ut8KK@wuerfel> <56250473.9090700@huawei.com>
 <8738374.sFXdg3OStu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8738374.sFXdg3OStu@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org


>> We could create a work_struct for each event, which would be fine.
>
> Yes, that would be the normal way to do it. You initialize the work
> structures from the initial probe function to have the right
> callbacks, and then you just queue the right one when you need to
> defer an event.
>
> How many different events are there?
>
We currently only support processing 2 events in the workqueue: phy up 
and control phy. However we may want to use more in the future, like
hotplug (for phy down) event.

>> However we would sometimes still need some way of passing data to
>> the event, like the phy control example.
>
> Do you mean the 'int func' argument to hisi_sas_control_phy_work?
Yes
> It sounds like that would again just be more different work_structs.
>
> At some point that might get silly (having 10 or more work structs
> per phy), but then you could restructure the code to use something
> other that work queues to get from interrupt context to process
> context, e.g. a threaded interrupt handler.
I'll check on this. We need to consider how to pass the argument for the 
control phy case.
>
> Note that the current code is not only unusual but also fragile
> because you rely on GFP_ATOMIC memory allocations from the interrupt
> handler, and they tend to eventually fail.
Understood. For what it's worth, I was just following other SAS drivers
as a refernce: see pm8001_handle_event() and mvs_handle_event()

>
> Arnd -- To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
Thanks, John
