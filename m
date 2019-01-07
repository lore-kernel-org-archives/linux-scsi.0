From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sd: Make protection lookup tables static
Date: Mon, 7 Jan 2019 17:27:58 +0000
Message-ID: <b269a676-8941-4de4-faed-c40ec0d0a45a@huawei.com>
References: <1546872111-5627-1-git-send-email-john.garry@huawei.com>
 <1546880243.83374.12.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546880243.83374.12.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/01/2019 16:57, Bart Van Assche wrote:
> On Mon, 2019-01-07 at 22:41 +0800, John Garry wrote:
>> Currently the protection lookup tables in sd_prot_flag_mask() and
>> sd_prot_op() are declared non-static. As such, they will be rebuilt for
>> each respective function call.
>>
>> Optimise by making them static.
>>
>> This saves ~100B object code for sd.c:
>>
>> Before:
>>    text	   data	    bss	    dec	    hex	filename
>>   25403	   1024	     16	  26443	   674b	drivers/scsi/sd.o
>>
>> After:
>>   text	   data	    bss	    dec	    hex	filename
>>   25299	   1024	     16	  26339	   66e3	drivers/scsi/sd.o
>
> Since the sd_prot_op() function only has a single caller, please move it from sd.h
> into sd.c.

Can do, as long as no one has objection.

Function sd_prot_flag_mask() also has a single caller AFAICS, so this 
could also be relocated.

Cheers,
John

>
> Thanks,
>
> Bart.
>
>
