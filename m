Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13151C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 08:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFCE2073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 08:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGFIZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 04:25:28 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2426 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgGFIZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 04:25:28 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2647FDF7C0ACF08E4473;
        Mon,  6 Jul 2020 09:25:26 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.142) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 6 Jul 2020
 09:25:24 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
Date:   Mon, 6 Jul 2020 09:23:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.142]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/2020 11:23, Kashyap Desai wrote:
>>
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Fusion adapters can steer completions to individual queues, and we now
> have
>> support for shared host-wide tags.
>> So we can enable multiqueue support for fusion adapters and drop the
> hand-
>> crafted interrupt affinity settings.
> 
> Shared host tag is primarily introduced for completeness of CPU hotplug as
> discussed earlier -
> https://lwn.net/Articles/819419/
> 
> How shall I test CPU hotplug on megaraid_sas driver ?

I have scripts like this:

----8<-----

# hotplug.sh
# enable all cpus in the system
./enable_all.sh

for((i = 0; i < 50 ; i++))
do
echo "Looping ... number $i"
# run fio on all cpus with 40 second runtime
./create_fio_task_cpu.sh 4k read 2048 1&
echo "short sleep, then disable"
sleep 5
# disable some set of cpus which means managed interrupts get shutdown
# like cpu1-50 from 0-63
./disable_all.sh
echo "long sleep $i"
sleep 50
echo "long sleep over number $i"
./enable_all.sh
sleep 3
done

----->8-----

# enable_all.sh
for((i=0; i<63; i++))
do
echo 1 > /sys/devices/system/cpu/cpu$i/online
done

--->8----

I hope to add such a test to blktests when I get a chance.

> My understanding is
> - This RFC + patch set from above link is required for it. I could not see
> above series is committed.

It is committed and part of 5.8-rc1

The latest rc should have some scheduler fixes also.

I also note that there has been much churn on blk-mq tag code lately, 
and something may be broken, so I plan to verify latest rc myself soon.

> Am I missing anything. ?

You could also add this from Hannes (and add megaraid sas support):

https://lore.kernel.org/linux-scsi/20200629072021.9864-1-hare@suse.de/T/#t

That is, if it is required. I am not sure if megaraid sas uses 
"internal" commands which needs to be guarded against cpu hotplug. Nor 
would any of these commands be used during a test. For hisi_sas testing, 
I did not bother adding support, and I guess that you don't need to either.

> 
> We do not want to completely move to shared host tag. It will be shared
> host tag support by default, but user should have choice to go back to
> legacy path.
> We will completely move to shared host tag path once it is stable and no
> more field issue observed over a period of time. -
> 
> Updated <megaraid_sas> patch will looks like this -
> 
> diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
> index 0066833..3b503cb 100644
> --- a/megaraid_sas_base.c
> +++ b/megaraid_sas_base.c
> @@ -37,6 +37,7 @@
>   #include <linux/poll.h>
>   #include <linux/vmalloc.h>
>   #include <linux/irq_poll.h>
> +#include <linux/blk-mq-pci.h>
> 
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
> @@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
>   module_param(enable_sdev_max_qd, int, 0444);
>   MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue.
> Default: 0");
> 
> +int host_tagset_disabled = 0;
> +module_param(host_tagset_disabled, int, 0444);
> +MODULE_PARM_DESC(host_tagset_disabled, "Shared host tagset enable/disable
> Default: enable(1)");

The logic seems inverted here: for passing 1, I would expect Shared host 
tagset enabled, while it actually means to disable, right?

> +
>   MODULE_LICENSE("GPL");
>   MODULE_VERSION(MEGASAS_VERSION);
>   MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
> @@ -3115,6 +3120,18 @@ megasas_bios_param(struct scsi_device *sdev, struct
> block_device *bdev,
>          return 0;
>   }
> 
> +static int megasas_map_queues(struct Scsi_Host *shost)
> +{
> +       struct megasas_instance *instance;
> +       instance = (struct megasas_instance *)shost->hostdata;
> +
> +       if (instance->host->nr_hw_queues == 1)
> +               return 0;
> +
> +       return
> blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +                       instance->pdev,
> instance->low_latency_index_start);
> +}
> +
>   static void megasas_aen_polling(struct work_struct *work);
> 
>   /**
> @@ -3423,8 +3440,10 @@ static struct scsi_host_template megasas_template =
> {
>          .eh_timed_out = megasas_reset_timer,
>          .shost_attrs = megaraid_host_attrs,
>          .bios_param = megasas_bios_param,
> +       .map_queues = megasas_map_queues,
>          .change_queue_depth = scsi_change_queue_depth,
>          .max_segment_size = 0xffffffff,
> +       .host_tagset = 1,

Is your intention to always have this set for Scsi_Host, and just change 
nr_hw_queues?

>   };
> 
>   /**
> @@ -6793,7 +6812,21 @@ static int megasas_io_attach(struct
> megasas_instance *instance)
>          host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
>          host->max_lun = MEGASAS_MAX_LUN;
>          host->max_cmd_len = 16;
> +       host->nr_hw_queues = 1;
> 
> +       /* Use shared host tagset only for fusion adaptors
> +        * if there are more than one managed interrupts.
> +        */
> +       if ((instance->adapter_type != MFI_SERIES) &&
> +               (instance->msix_vectors > 0) &&
> +               !host_tagset_disabled &&
> +               instance->smp_affinity_enable)
> +               host->nr_hw_queues = instance->msix_vectors -
> +                       instance->low_latency_index_start;
> +
> +       dev_info(&instance->pdev->dev, "Max firmware commands: %d"
> +               " for nr_hw_queues = %d\n", instance->max_fw_cmds,
> +               host->nr_hw_queues);

note: it may be good for us to add a nr_hw_queues file to scsi host 
sysfs folder

>          /*
>           * Notify the mid-layer about the new controller
>           */
> @@ -8842,6 +8875,7 @@ static int __init megasas_init(void)
>                  msix_vectors = 1;
>                  rdpq_enable = 0;
>                  dual_qdepth_disable = 1;
> +               host_tagset_disabled = 1;
>          }
> 

Thanks,
John
