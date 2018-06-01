From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 8/8] scsi: libsas: support SATA phy link rate unmatch the
 pathway
Date: Fri, 1 Jun 2018 11:13:39 +0100
Message-ID: <6c2486cc-54d2-3a6e-c448-c1b77d0dcdd4@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-9-yanaijie@huawei.com>
 <ed533ab2-018d-0bda-568f-0034dac1e332@huawei.com>
 <5B109FA8.9010402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B109FA8.9010402@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, chenqilin <chenqilin2@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/06/2018 02:21, Jason Yan wrote:
>
>
> On 2018/6/1 0:05, John Garry wrote:
>> On 29/05/2018 03:23, Jason Yan wrote:
>>> If a SATA disk attached to a expander phy and it's linkrate is greater
>>> than the expander host phy's linkrate, the disk will failed to discover.
>>> The topology is like below:
>>>
>>>    +----------+           +----------+
>>>    |          |           |          |
>>>    |          |-- 3.0 G --|          |-- 6.0 G -- SAS  disk
>>>    |          |           |          |
>>>    |          |-- 3.0 G --|          |-- 6.0 G -- SAS  disk
>>>    |initiator |           |          |
>>>    | device   |-- 3.0 G --| Expander |-- 6.0 G -- SAS  disk
>>>    |          |           |          |
>>>    |          |-- 3.0 G --|          |-- 6.0 G -- SATA disk  -->failed
>>> to connect
>>>    |          |           |          |
>>>    |          |           |          |-- 6.0 G -- SATA disk  -->failed
>>> to connect
>>>    |          |           |          |
>>>    +----------+           +----------+
>>>
>>> And when we check the sas protocal spec, this scenario is described as
>>> this:
>>>
>>> 7.13 Rate matching
>>> ......
>>> If an expander phy attached to a SATA phy is using a physical link rate
>>> greater than the maximum connection rate supported by the pathway from
>>> an STP initiator port, a management application client should use the
>>> SMP PHY CONTROL function (see 10.4.3.10) to set the PROGRAMMED MAXIMUM
>>> PHYSICAL LINK RATE field of the expander phy to the maximum connection
>>> rate supported by the pathway from that STP initiator port.
>>>
>>> In order to support this scenario, checking the SATA disk's linkrate
>>> to see if it is greater than any phy's linkrate it may pass through.
>>> Remember the minimum linkrate of the pathway and set the SATA phy
>>> linkrate to it using the SMP PHY CONTROL function.
>>
>> As we (re)discover the tree, can we keep track of the min pathway to the
>> root PHY dynamically (per expander), and then take action for any SATA
>> devices attached which have a negotiated linkrate greater (than the
>> expanders min pathway)? This would be an alternate to your approach of
>> finishing discovery and then checking the min pathway as a whole new
>> step.
>>
>
> Seems better, I will have a try to see if it works. Thanks.

Fine, it seems the tricky part here is to figure out when to issue the 
linkrate change request.
