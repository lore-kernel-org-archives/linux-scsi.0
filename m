From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Mon, 26 Oct 2015 18:56:48 -0700
Message-ID: <562ED9E0.7050603@acm.org>
References: <562E3E9F.50600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562E3E9F.50600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/26/15 07:54, Peter Oberparleiter wrote:
> Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
> returns the value of that number instead of the number of bytes written.
> This behavior can confuse programs expecting POSIX write() semantics.
> Fix this by returning the number of bytes written instead.
>
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..6b0f292 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
>   		return -EINVAL;
>
>   	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
> -	return period;
> +	return count;
>   }
>
>   static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,

Hello Peter,

Good catch. But please CC the people who introduced this code and also 
"stable" (see also commit 4a84067dbfce436b81779e585bf712b02ceee552).

Thanks,

Bart.
