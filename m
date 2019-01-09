From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: sd: Make protection lookup tables static and
 relocate functions
Date: Tue, 8 Jan 2019 18:42:35 -0800
Message-ID: <29616f54-5c48-96da-e3b4-c211fd28d82e@acm.org>
References: <1546960492-218420-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546960492-218420-1-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/8/19 7:14 AM, John Garry wrote:
> Currently the protection lookup tables in sd_prot_flag_mask() and
> sd_prot_op() are declared as non-static. As such, they will be rebuilt
> for each respective function call.
> 
> Optimise by making them static.
> 
> This saves ~100B object code for sd.c:
> 
> Before:
>     text	   data	    bss	    dec	    hex	filename
>    25403	   1024	     16	  26443	   674b	drivers/scsi/sd.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>    25299	   1024	     16	  26339	   66e3	drivers/scsi/sd.o
> 
> In addition, since those same functions are declared in sd.h, but each are
> only referenced in sd.c, relocate them to that same c file.
> 
> The inline specifier is dropped also, since gcc should be able to make the
> decision to inline.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
