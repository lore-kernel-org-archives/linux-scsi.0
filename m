From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Mon, 20 Oct 2014 10:18:24 +0300
Message-ID: <5444B740.5040700@dev.mellanox.co.il>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu> <544220C3.2010900@acm.org> <5442CE4C.9090301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5442CE4C.9090301@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2014 11:32 PM, Mike Christie wrote:
> On 10/18/2014 03:11 AM, Bart Van Assche wrote:
>> On 10/16/14 07:37, michaelc@cs.wisc.edu wrote:
>>> The following patches implement the SCSI command COMPARE_AND_WRITE as
>>> a new
>>> bio/request type REQ_CMP_AND_WRITE. COMPARE_AND_WRITE is defined in the
>>> SCSI SBC (SCSI block command) specs as:
>>>
>>> The COMPARE AND WRITE command requests that the device server perform the
>>> following as an uninterrupted series of actions:
>>>
>>> 1) perform the following operations:
>>>           A) read the specified logical blocks; and
>>>           B) transfer the specified number of logical blocks from the
>>> Data-Out
>>>           Buffer (i.e., the verify instance of the data is transferred
>>> from the
>>>           Data-Out Buffer);
>>>
>>> 2) compare the data read from the specified logical blocks with the
>>> verify
>>> instance of the data; and
>>> 3) If the compared data matches, then perform the following operations:
>>>           1) transfer the specified number of logical blocks from the
>>> Data-Out
>>>           Buffer (i.e., the write instance of the data transferred from
>>> the
>>>           Data-Out Buffer); and
>>>           2) write those logical blocks.
>>
>> Hello Mike,
>>
>> Just below the above text one can find the following additional
>> requirement in SBC-4:
>> <quote>
>> 4) if the compare operation does not indicate a match, then terminate
>>     the command with CHECK CONDITION status with the sense key set to
>>     MISCOMPARE and the additional sense code set to MISCOMPARE DURING
>>     VERIFY OPERATION. In the sense data (see 4.18 and SPC-4) the offset
>>     from the start of the Data-Out Buffer to the first byte of data that
>>     was not equal shall be reported in the INFORMATION field.
>> </quote>
>>
>> What I'm wondering now is how requirement (4) can be supported if
>> REQ_CMP_AND_WRITE doesn't return the offset of the first byte that
>> didn't match ? Additionally, shouldn't compare_and_write_callback() be
>> fixed such that it returns the miscompare offset to its caller ?
>>
>
> Yeah, Hannes pointed out that the original LIO code did not support
> this. For the original code, I will fix that in another patchset to keep
> this one smaller and focused. For what I need, I have been trying to
> think of a nice way to pass additional info around. I think the options are:
>

Thanks Bart for bringing this up,

Actually Mike the lio code does support providing information field with
offset sector in sense data. I added it for PI but it can be used for
other errors such as miscompare (checkout
transport_send_check_condition_and_sense for
TCM_LOGICAL_BLOCK_[GUARD|APP_TAG|REF_TAG]_CHECK_FAILED error codes).

> 1. Instead of making it bio/request based, make it a
> request_queue->compare_and_write function. We then just stack them and
> can add whatever arguments/return values are necessary and do not have
> to mess with the bio/request structs and function chains.
>
> 2. Add another argument to the end io functions that can be used to pass
> back bio/request type specific info.

I'm for (2), can we standardize the way to provide the extra info?
so target iblock code can do the same thing for all?

Sagi.
