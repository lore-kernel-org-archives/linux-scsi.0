From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 5/7] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Mon, 23 Mar 2015 20:52:44 +0000
Message-ID: <BLUPR03MB4072A440762751DBDA54808CE0D0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1427144760-11875-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-5-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1427144801-11920-5-git-send-email-kys@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Monday, March 23, 2015 2:07 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> vkuznets@redhat.com; jasowang@redhat.com
> Cc: stable@vger.kernel.org
> Subject: [PATCH 5/7] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
> 
> We may exit this function without properly freeing up the maapings we may
> have acquired. Fix the bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>

> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/storvsc_drv.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 5c13eec..88f5d79 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -754,21 +754,22 @@ static unsigned int copy_to_bounce_buffer(struct
> scatterlist *orig_sgl,
>  			if (bounce_sgl[j].length == PAGE_SIZE) {
>  				/* full..move to next entry */
>  				sg_kunmap_atomic(bounce_addr);
> +				bounce_addr = 0;
>  				j++;
> +			}
> 
> -				/* if we need to use another bounce buffer */
> -				if (srclen || i != orig_sgl_count - 1)
> -					bounce_addr =
> sg_kmap_atomic(bounce_sgl,j);
> +			/* if we need to use another bounce buffer */
> +			if (srclen && bounce_addr == 0)
> +				bounce_addr = sg_kmap_atomic(bounce_sgl,
> j);
> 
> -			} else if (srclen == 0 && i == orig_sgl_count - 1) {
> -				/* unmap the last bounce that is < PAGE_SIZE
> */
> -				sg_kunmap_atomic(bounce_addr);
> -			}
>  		}
> 
>  		sg_kunmap_atomic(src_addr - orig_sgl[i].offset);
>  	}
> 
> +	if (bounce_addr)
> +		sg_kunmap_atomic(bounce_addr);
> +
>  	local_irq_restore(flags);
> 
>  	return total_copied;
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
