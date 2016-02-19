From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] hisi_sas: add hisi_sas_slave_configure()
Date: Fri, 19 Feb 2016 15:31:35 +0100
Message-ID: <56C72747.5070909@suse.de>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-6-git-send-email-john.garry@huawei.com>
 <56C34163.70606@suse.de> <56C354A5.6080503@huawei.com>
 <56C5756A.9060700@suse.de> <56C59922.6070600@huawei.com>
 <56C59D47.30500@suse.de> <56C5A3A6.1090100@huawei.com>
 <56C6F28B.9090000@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422898AbcBSObi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 09:31:38 -0500
In-Reply-To: <56C6F28B.9090000@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linux-kernel@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org

On 02/19/2016 11:46 AM, John Garry wrote:
> On 18/02/2016 10:57, John Garry wrote:
>> On 18/02/2016 10:30, Hannes Reinecke wrote:
>>> On 02/18/2016 11:12 AM, John Garry wrote:
>>>> On 18/02/2016 07:40, Hannes Reinecke wrote:
>>> [ .. ]
>>>>> Well, the classical thing would be to associate each request tag
>>>>> with a SAS task; or, in your case, associate each slot index
>>>>> with a
>>>>> request tag.
>>>>> You probably would need to reserve some slots for TMFs, ie you'd
>>>>> need to decrease the resulting ->can_queue variable by that.
>>>>> But once you've done that you shouldn't hit any QUEUE_FULL issues=
,
>>>>> as the block layer will ensure that no tags will be reused
>>>>> while the
>>>>> command is in flight.
>>>>> Plus this is something you really need to be doing if you ever
>>>>> consider moving to scsi-mq ...
>>>>>
>>>>> Cheers,
>>>>>
>>>>> Hannes
>>>>>
>>>> Hi,
>>>>
>>>> So would you recommend this method under the assumption that the
>>>> can_queue value for the host is similar to the queue depth for the
>>>> device?
>>>>
>>> That depends.
>>> Typically the can_queue setting reflects the number of commands the
>>> _host_ can queue internally (due to hardware limitations etc).
>>> They do not necessarily reflect the queue depth for the device
>>> (unless you have a single device, of course).
>>> So if the host has a hardware limit on the number of commands it ca=
n
>>> queue, it should set the 'can_queue' variable to the appropriate
>>> number; a host-wide shared tag map is always assumed with recent
>>> kernels.
>>>
>>> The queue_depth of an individual device is controlled by the
>>> 'cmd_per_lun' setting, and of course capped by can_queue.
>>>
>>> But yes, I definitely recommend this method.
>>> Is saves one _so much_ time trying to figure out which command slot
>>> to use. Drawback is that you have to have some sort of fixed order
>>> on them slots to do an efficient lookup.
>>>
>>> Cheers,
>>>
>>> Hannes
>>>
>>
>> I would like to make a point on cmd_per_lun before considering
>> tagging slots: For our host the can_queue is considerably greater th=
an
>> cmd_per_lun (even though we initially set the same in the host
>> template, which would be incorrect).
That is common behaviour; most hosts support more than one LUN, and
setting cmd_per_lun to a lower value will attempt to distribute the
available commands across all LUNs.

>> Regardless I find the host cmd_per_lun is effectively ignored for
>> the slave device queue depth as it is reset in
>> sas_slave_configure() to 256 [if this function is used and tagging
>> enabled]. So if we we choose a reasonable cmd_per_lun for our
>> host, it is ignored, right? Or am I missing something?
>>
Basically, yes.
As said above, the cmd_per_lun is a _very_ rough attempt to
distribute commands across several LUNs.
However, in general there's no need to rely on that, as each queue
(which is associated with the LUN) will be controlled individually
via the queue_depth ramp-down/ramp-up mechanism.

> I would like to make another point about why I am making this change
> in case it is not clear. The queue full events are form
> TRANS_TX_CREDIT_TIMEOUT_ERR and TRANS_TX_CLOSE_NORMAL_ERR errors in
> the slot: I want the slot retried when this occurs, so I set status
> as SAS_QUEUE_FULL just so we will report DID_SOFT_ERR to SCSI
> midlayer so we get a retry. I could use SAS_OPEN_REJECT
> alternatively as the error which would have the same affect.
> The queue full are not from all slots being consumed in the HBA.
>=20
Ah, right. So you might be getting those errors even with some free
slots on the HBA. As such they are roughly equivalent to a
QUEUE_FULL SCSI statue, right?
So after reading SPL I guess you are right here; using tags wouldn't
help for this situation.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
