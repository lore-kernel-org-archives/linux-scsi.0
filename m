From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: protect against races between mmap() and
 SG_SET_RESERVED_SIZE
Date: Tue, 22 Aug 2017 21:48:48 -0400
Message-ID: <8eb2a866-35ce-38c1-2f39-2d1678a3a9fb@interlog.com>
References: <20170816054108.119890-1-toddpoynor@google.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170816054108.119890-1-toddpoynor@google.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 2017-08-16 01:41 AM, Todd Poynor wrote:
> Take f_mutex around mmap() processing to protect against races with
> the SG_SET_RESERVED_SIZE ioctl.  Ensure the reserve buffer length
> remains consistent during the mapping operation, and set the
> "mmap called" flag to prevent further changes to the reserved buffer
> size as an atomic operation with the mapping.
> 
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 3a44b4bc872b..a20718e9f1f4 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1233,6 +1233,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>   	unsigned long req_sz, len, sa;
>   	Sg_scatter_hold *rsv_schp;
>   	int k, length;
> +        int ret = 0;
>   
>   	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
>   		return -ENXIO;
> @@ -1243,8 +1244,11 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>   	if (vma->vm_pgoff)
>   		return -EINVAL;	/* want no offset */
>   	rsv_schp = &sfp->reserve;
> -	if (req_sz > rsv_schp->bufflen)
> -		return -ENOMEM;	/* cannot map more than reserved buffer */
> +	mutex_lock(&sfp->f_mutex);
> +	if (req_sz > rsv_schp->bufflen) {
> +		ret = -ENOMEM;	/* cannot map more than reserved buffer */
> +		goto out;
> +	}
>   
>   	sa = vma->vm_start;
>   	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
> @@ -1258,7 +1262,9 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>   	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>   	vma->vm_private_data = sfp;
>   	vma->vm_ops = &sg_mmap_vm_ops;
> -	return 0;
> +out:
> +	mutex_unlock(&sfp->f_mutex);
> +	return ret;
>   }
>   
>   static void
> 
