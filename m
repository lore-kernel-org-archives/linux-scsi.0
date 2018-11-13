From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 15:44:46 +0000
Message-ID: <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 13/11/2018 15:08, Sabyasachi Gupta wrote:
> Replaced vmalloc + memset with vzalloc
>
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> ---
>  drivers/scsi/fnic/fnic_trace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
> index 8271785..129ab27 100644
> --- a/drivers/scsi/fnic/fnic_trace.c
> +++ b/drivers/scsi/fnic/fnic_trace.c
> @@ -468,14 +468,14 @@ int fnic_trace_buf_init(void)
>  	fnic_max_trace_entries = (trace_max_pages * PAGE_SIZE)/
>  					  FNIC_ENTRY_SIZE_BYTES;
>
> -	fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
> +	fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages *
> +								PAGE_SIZE));

If you remove the extra brackets in vzalloc() argument then you may not 
spill onto the next line.

>  	if (!fnic_trace_buf_p) {
>  		printk(KERN_ERR PFX "Failed to allocate memory "
>  				  "for fnic_trace_buf_p\n");
>  		err = -ENOMEM;
>  		goto err_fnic_trace_buf_init;
>  	}
> -	memset((void *)fnic_trace_buf_p, 0, (trace_max_pages * PAGE_SIZE));
>
>  	fnic_trace_entries.page_offset =
>  		vmalloc(array_size(fnic_max_trace_entries,
>
