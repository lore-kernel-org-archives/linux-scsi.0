From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Tue, 27 Oct 2015 12:12:11 -0400
Message-ID: <1445962331.4119.28.camel@localhost.localdomain>
References: <562E3E9F.50600@linux.vnet.ibm.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562E3E9F.50600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-10-26 at 15:54 +0100, Peter Oberparleiter wrote:
> Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
> returns the value of that number instead of the number of bytes written.
> This behavior can confuse programs expecting POSIX write() semantics.
> Fix this by returning the number of bytes written instead.
> 
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..6b0f292 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
>  		return -EINVAL;
> 
>  	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
> -	return period;
> +	return count;
>  }
> 
>  static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
