From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 16:53:39 +0100
Message-ID: <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
 <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 13/11/2018 16:44, John Garry wrote:
> On 13/11/2018 15:08, Sabyasachi Gupta wrote:
>> Replaced vmalloc + memset with vzalloc
>>
>> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
>> ---
>>  drivers/scsi/fnic/fnic_trace.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/fnic/fnic_trace.c
>> b/drivers/scsi/fnic/fnic_trace.c
>> index 8271785..129ab27 100644
>> --- a/drivers/scsi/fnic/fnic_trace.c
>> +++ b/drivers/scsi/fnic/fnic_trace.c
>> @@ -468,14 +468,14 @@ int fnic_trace_buf_init(void)
>>      fnic_max_trace_entries = (trace_max_pages * PAGE_SIZE)/
>>                        FNIC_ENTRY_SIZE_BYTES;
>>
>> -    fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages *
>> PAGE_SIZE));
>> +    fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages *
>> +                                PAGE_SIZE));
> 
> If you remove the extra brackets in vzalloc() argument then you may not
> spill onto the next line.

And remove the unnecessary cast. vzalloc() (just like vmalloc()) returns
a void*, so no reason to cast it.

-- 
Johannes Thumshirn                                        SUSE Labs
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
