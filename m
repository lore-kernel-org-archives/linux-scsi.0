From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Sat, 18 Oct 2014 15:32:12 -0500
Message-ID: <5442CE4C.9090301@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu> <544220C3.2010900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <544220C3.2010900@acm.org>
Sender: ceph-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2014 03:11 AM, Bart Van Assche wrote:
> On 10/16/14 07:37, michaelc@cs.wisc.edu wrote:
>> The following patches implement the SCSI command COMPARE_AND_WRITE as
>> a new
>> bio/request type REQ_CMP_AND_WRITE. COMPARE_AND_WRITE is defined in the
>> SCSI SBC (SCSI block command) specs as:
>>
>> The COMPARE AND WRITE command requests that the device server perform the
>> following as an uninterrupted series of actions:
>>
>> 1) perform the following operations:
>>          A) read the specified logical blocks; and
>>          B) transfer the specified number of logical blocks from the
>> Data-Out
>>          Buffer (i.e., the verify instance of the data is transferred
>> from the
>>          Data-Out Buffer);
>>
>> 2) compare the data read from the specified logical blocks with the
>> verify
>> instance of the data; and
>> 3) If the compared data matches, then perform the following operations:
>>          1) transfer the specified number of logical blocks from the
>> Data-Out
>>          Buffer (i.e., the write instance of the data transferred from
>> the
>>          Data-Out Buffer); and
>>          2) write those logical blocks.
> 
> Hello Mike,
> 
> Just below the above text one can find the following additional
> requirement in SBC-4:
> <quote>
> 4) if the compare operation does not indicate a match, then terminate
>    the command with CHECK CONDITION status with the sense key set to
>    MISCOMPARE and the additional sense code set to MISCOMPARE DURING
>    VERIFY OPERATION. In the sense data (see 4.18 and SPC-4) the offset
>    from the start of the Data-Out Buffer to the first byte of data that
>    was not equal shall be reported in the INFORMATION field.
> </quote>
> 
> What I'm wondering now is how requirement (4) can be supported if
> REQ_CMP_AND_WRITE doesn't return the offset of the first byte that
> didn't match ? Additionally, shouldn't compare_and_write_callback() be
> fixed such that it returns the miscompare offset to its caller ?
> 

Yeah, Hannes pointed out that the original LIO code did not support
this. For the original code, I will fix that in another patchset to keep
this one smaller and focused. For what I need, I have been trying to
think of a nice way to pass additional info around. I think the options are:

1. Instead of making it bio/request based, make it a
request_queue->compare_and_write function. We then just stack them and
can add whatever arguments/return values are necessary and do not have
to mess with the bio/request structs and function chains.

2. Add another argument to the end io functions that can be used to pass
back bio/request type specific info.

