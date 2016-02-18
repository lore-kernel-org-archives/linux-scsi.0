From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Thu, 18 Feb 2016 08:40:26 +0100
Message-ID: <56C5756A.9060700@suse.de>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
 <56C34163.70606@suse.de> <56C354A5.6080503@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C354A5.6080503@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/16/2016 05:56 PM, John Garry wrote:
> On 16/02/2016 15:33, Hannes Reinecke wrote:
>> On 02/16/2016 01:22 PM, John Garry wrote:
>>> In high-datarate aging tests, it is found that
>>> the SCSI framework can periodically
>>> issue lu resets to the device. This is because scsi
>>> commands begin to timeout. It is found that TASK SET
>>> FULL may be returned many times for the same command,
>>> causing the timeouts.
>>> To overcome this, the queue depth for the device needs
>>> to be reduced to 64 (from 256, set in
>>> sas_slave_configure()).
>>>
>> Hmm. TASK SET FULL should cause the queue depth to be reduced
>> automatically, no?
>>
>> Cheers,
>>
>> Hannes
>>
>=20
> I need to double-check if Task set full reduces the depth, I don't
> think it does.
>=20
> Regardless I found we were getting a combination of commands being
> retried due to Task Set Full and also SAS_QUEUE_FULL errors. For
> sure the SAS_QUEUE_FULL task errors reduce the queue depth in
> scsi_track_queue_full(). However I found it to be very slow in
> tracking, and we were getting commands timing out before the queue
> depth fell enough.
>=20
> It would be nice to change default queue depth in
> sas_slave_configure() to a lower value so we can avoid this patch,
> but I am not sure if other vendor's HBA performance would be
> affected. From looking at the history of sas_slave_configure(), it
> would seem the value of 256 was inherited from mpt2sas driver, so
> I'm not sure.
>=20
Well, the classical thing would be to associate each request tag
with a SAS task; or, in your case, associate each slot index with a
request tag.
You probably would need to reserve some slots for TMFs, ie you'd
need to decrease the resulting ->can_queue variable by that.
But once you've done that you shouldn't hit any QUEUE_FULL issues,
as the block layer will ensure that no tags will be reused while the
command is in flight.
Plus this is something you really need to be doing if you ever
consider moving to scsi-mq ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
