From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Date: Wed, 26 Jun 2019 10:14:23 -0400
Message-ID: <65e5ad25-a475-989a-ce3d-400a8c90cb61@interlog.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 2019-06-26 9:51 a.m., Paolo Bonzini wrote:
> On 30/05/19 13:28, Paolo Bonzini wrote:
>> This allows a list of requests to be issued, with the LLD only writing
>> the hardware doorbell when necessary, after the last request was prepared.
>> This is more efficient if we have lists of requests to issue, particularly
>> on virtualized hardware, where writing the doorbell is more expensive than
>> on real hardware.
>>
>> This applies to any HBA, either singlequeue or multiqueue; the second
>> patch implements it for virtio-scsi.
>>
>> Paolo
>>
>> Paolo Bonzini (2):
>>    scsi_host: add support for request batching
>>    virtio_scsi: implement request batching
>>
>>   drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
>>   drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>>   include/scsi/scsi_cmnd.h   |  1 +
>>   include/scsi/scsi_host.h   | 16 +++++++++--
>>   4 files changed, 89 insertions(+), 20 deletions(-)
>>
> 
> 
> Ping?  Are there any more objections?

I have no objections, just a few questions.

To implement this is the scsi_debug driver, a per device queue would
need to be added, correct? Then a 'commit_rqs' call would be expected
at some later point and it would drain that queue and submit each
command. Or is the queue draining ongoing in the LLD and 'commit_rqs'
means: don't return until that queue is empty?

So does that mean in the normal (i.e. non request batching) case
there are two calls to the LLD for each submitted command? Or is
'commit_rqs' optional, a sync-ing type command?

Doug Gilbert
