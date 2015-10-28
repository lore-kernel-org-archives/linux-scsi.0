From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [RESEND PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Wed, 28 Oct 2015 17:12:17 -0500
Message-ID: <12B06B0F-E672-439E-A7F0-5B8F77BF3358@linux.vnet.ibm.com>
References: <562F48C2.1070803@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562F48C2.1070803@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Vasu Dev <vasu.dev@intel.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

> On Oct 27, 2015, at 4:49 AM, Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
> Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
> returns the value of that number instead of the number of bytes written.
> This behavior can confuse programs expecting POSIX write() semantics.
> Fix this by returning the number of bytes written instead.
> 
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: stable@vger.kernel.org
> ---
> drivers/scsi/scsi_sysfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..6b0f292 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
> 		return -EINVAL;
> 
> 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
> -	return period;
> +	return count;
> }
> 
> static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
