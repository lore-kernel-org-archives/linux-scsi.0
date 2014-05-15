From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] block: Export REQ_FLUSH status via sysfs
Date: Wed, 14 May 2014 17:11:03 -0700
Message-ID: <1400112663.7127.64.camel@haakon3.risingtidesystems.com>
References: <1400107908-16095-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37436 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEOALF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2014 20:11:05 -0400
In-Reply-To: <1400107908-16095-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, 2014-05-14 at 15:51 -0700, Andy Grover wrote:
> Whether this is set or not is important for whether good performance is
> possible, when using the block device as a backstore for the kernel
> target. Exposing this will let kernel target configuration tools provide
> this information to the user when configuring LIO targets.
> 

The whole point is that IBLOCK detects if WCE is enabled on the
underlying block_device at creation time using these same flags, and
sets its own WCE bit automatically without any user interaction.

The user should not be allowed to change the WCE bit to something
different from what the underlying block_device is reporting.

That said, I don't see the point of this patch for target related logic.

--nab


> Reviewed-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  block/genhd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 791f419..258fadc 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -958,6 +958,14 @@ static ssize_t disk_capability_show(struct device *dev,
>  	return sprintf(buf, "%x\n", disk->flags);
>  }
>  
> +static ssize_t req_flush_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct gendisk *disk = dev_to_disk(dev);
> +
> +	return sprintf(buf, "%x\n", !!(disk->queue->flush_flags & REQ_FLUSH));
> +}
> +
>  static ssize_t disk_alignment_offset_show(struct device *dev,
>  					  struct device_attribute *attr,
>  					  char *buf)
> @@ -985,6 +993,7 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
>  static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
>  		   NULL);
>  static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
> +static DEVICE_ATTR(req_flush, S_IRUGO, req_flush_show, NULL);
>  static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
>  static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
> @@ -1006,6 +1015,7 @@ static struct attribute *disk_attrs[] = {
>  	&dev_attr_alignment_offset.attr,
>  	&dev_attr_discard_alignment.attr,
>  	&dev_attr_capability.attr,
> +	&dev_attr_req_flush.attr,
>  	&dev_attr_stat.attr,
>  	&dev_attr_inflight.attr,
>  #ifdef CONFIG_FAIL_MAKE_REQUEST


