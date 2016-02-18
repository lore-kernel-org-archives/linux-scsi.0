From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Thu, 18 Feb 2016 10:57:42 +0000
Message-ID: <56C5A3A6.1090100@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
 <56C34163.70606@suse.de> <56C354A5.6080503@huawei.com>
 <56C5756A.9060700@suse.de> <56C59922.6070600@huawei.com>
 <56C59D47.30500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C59D47.30500@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 18/02/2016 10:30, Hannes Reinecke wrote:
> On 02/18/2016 11:12 AM, John Garry wrote:
>> On 18/02/2016 07:40, Hannes Reinecke wrote:
> [ .. ]
>>> Well, the classical thing would be to associate each request tag
>>> with a SAS task; or, in your case, associate each slot index with a
>>> request tag.
>>> You probably would need to reserve some slots for TMFs, ie you'd
>>> need to decrease the resulting ->can_queue variable by that.
>>> But once you've done that you shouldn't hit any QUEUE_FULL issues,
>>> as the block layer will ensure that no tags will be reused while the
>>> command is in flight.
>>> Plus this is something you really need to be doing if you ever
>>> consider moving to scsi-mq ...
>>>
>>> Cheers,
>>>
>>> Hannes
>>>
>> Hi,
>>
>> So would you recommend this method under the assumption that the
>> can_queue value for the host is similar to the queue depth for the
>> device?
>>
> That depends.
> Typically the can_queue setting reflects the number of commands the
> _host_ can queue internally (due to hardware limitations etc).
> They do not necessarily reflect the queue depth for the device
> (unless you have a single device, of course).
> So if the host has a hardware limit on the number of commands it can
> queue, it should set the 'can_queue' variable to the appropriate
> number; a host-wide shared tag map is always assumed with recent
> kernels.
>
> The queue_depth of an individual device is controlled by the
> 'cmd_per_lun' setting, and of course capped by can_queue.
>
> But yes, I definitely recommend this method.
> Is saves one _so much_ time trying to figure out which command slot
> to use. Drawback is that you have to have some sort of fixed order
> on them slots to do an efficient lookup.
>
> Cheers,
>
> Hannes
>

I would like to make a point on cmd_per_lun before considering tagging 
slots: For our host the can_queue is considerably greater than 
cmd_per_lun (even though we initially set the same in the host template, 
which would be incorrect). Regardless I find the host cmd_per_lun is 
effectively ignored for the slave device queue depth as it is reset in 
sas_slave_configure() to 256 [if this function is used and tagging 
enabled]. So if we we choose a reasonable cmd_per_lun for our host, it 
is ignored, right? Or am I missing something?

Thanks,
John
