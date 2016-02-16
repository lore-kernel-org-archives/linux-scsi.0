From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Tue, 16 Feb 2016 16:56:05 +0000
Message-ID: <56C354A5.6080503@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
 <56C34163.70606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C34163.70606@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/02/2016 15:33, Hannes Reinecke wrote:
> On 02/16/2016 01:22 PM, John Garry wrote:
>> In high-datarate aging tests, it is found that
>> the SCSI framework can periodically
>> issue lu resets to the device. This is because scsi
>> commands begin to timeout. It is found that TASK SET
>> FULL may be returned many times for the same command,
>> causing the timeouts.
>> To overcome this, the queue depth for the device needs
>> to be reduced to 64 (from 256, set in
>> sas_slave_configure()).
>>
> Hmm. TASK SET FULL should cause the queue depth to be reduced
> automatically, no?
>
> Cheers,
>
> Hannes
>

I need to double-check if Task set full reduces the depth, I don't think 
it does.

Regardless I found we were getting a combination of commands being 
retried due to Task Set Full and also SAS_QUEUE_FULL errors. For sure 
the SAS_QUEUE_FULL task errors reduce the queue depth in 
scsi_track_queue_full(). However I found it to be very slow in tracking, 
and we were getting commands timing out before the queue depth fell enough.

It would be nice to change default queue depth in sas_slave_configure() 
to a lower value so we can avoid this patch, but I am not sure if other 
vendor's HBA performance would be affected. From looking at the history 
of sas_slave_configure(), it would seem the value of 256 was inherited 
from mpt2sas driver, so I'm not sure.

Cheers,
John
