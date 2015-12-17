From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 3/3] block: Export max_dev_sectors_kb in sysfs
Date: Thu, 17 Dec 2015 08:27:37 -0500
Message-ID: <1450358857.22151.4.camel@localhost.localdomain>
References: <1450306433-20166-1-git-send-email-martin.petersen@oracle.com>
	 <1450306433-20166-3-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbbLQN1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 08:27:38 -0500
In-Reply-To: <1450306433-20166-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Wed, 2015-12-16 at 17:53 -0500, Martin K. Petersen wrote:
> Some storage devices report a maximum transfer length which indicates
> the maximum size of an I/O request that the device can process. This
> limit is enforced in combination with the controller's max_hw_sectors
> and DMA constraints to ensure that we do not issue a command too big for
> the device.
> 
> Export the max_dev_sectors_kb queue limit in sysfs and update the
> documentation accordingly.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  Documentation/ABI/testing/sysfs-block |  9 +++++++++
>  Documentation/block/queue-sysfs.txt   | 11 +++++++++--
>  block/blk-settings.c                  |  4 +++-
>  block/blk-sysfs.c                     | 13 +++++++++++++
>  4 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> index 71d184dbb70d..4f284d38c085 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -235,3 +235,12 @@ Description:
>  		write_same_max_bytes is 0, write same is not supported
>  		by the device.
>  
> +What:		/sys/block/<disk>/queue/max_dev_sectors_kb
> +Date:		December 2015
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Some storage devices report the maximum size that the
> +		device can process in a single READ or WRITE
> +		request. This limit is used in combination with
> +		constraints set by the controller driver to limit the
> +		size of filesystem requests.
> diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
> index e5d914845be6..a078995f3eae 100644
> --- a/Documentation/block/queue-sysfs.txt
> +++ b/Documentation/block/queue-sysfs.txt
> @@ -55,9 +55,15 @@ logical_block_size (RO)
>  -----------------------
>  This is the logcal block size of the device, in bytes.
>  
> +max_dev_sectors_kb (R)
> +----------------------
> +This is the maximum number of kilobytes supported by the storage device
> +for a READ or WRITE request.
> +
>  max_hw_sectors_kb (RO)
>  ----------------------
> -This is the maximum number of kilobytes supported in a single data transfer.
> +This is the maximum number of kilobytes supported by the storage
> +controller in a single data transfer.
>  
>  max_integrity_segments (RO)
>  ---------------------------
> @@ -68,7 +74,8 @@ max_sectors_kb (RW)
>  -------------------
>  This is the maximum number of kilobytes that the block layer will allow
>  for a filesystem request. Must be smaller than or equal to the maximum
> -size allowed by the hardware.
> +size allowed by the storage controller (max_hw_sectors_kb) and the
> +maximum size allowed by the storage device (max_dev_sectors_kb).
>  
>  max_segments (RO)
>  -----------------
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index dd4973583978..362b0179c86a 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -232,7 +232,9 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
>   *    max_sectors is a soft limit imposed by the block layer for
>   *    filesystem type requests.  This value can be overridden on a
>   *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
> - *    The soft limit can not exceed max_hw_sectors.
> + *
> + *    The soft limit's lower bound is the page cache size and it can not
> + *    exceed neither max_hw_sectors, nor max_dev_sectors.
>   **/
>  void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
>  {
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index e140cc487ce1..c289f9f6dcd9 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -225,6 +225,13 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
>  	return queue_var_show(max_hw_sectors_kb, (page));
>  }
>  
> +static ssize_t queue_max_dev_sectors_show(struct request_queue *q, char *page)
> +{
> +	int max_dev_sectors_kb = q->limits.max_dev_sectors >> 1;

Consider adding inline queue_max_dev_sectors() to blkdev.h and using it
in the line above?

> +
> +	return queue_var_show(max_dev_sectors_kb, (page));
> +}
> +
>  #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
>  static ssize_t								\
>  queue_show_##name(struct request_queue *q, char *page)			\
> @@ -371,6 +378,11 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
>  	.show = queue_max_hw_sectors_show,
>  };
>  
> +static struct queue_sysfs_entry queue_max_dev_sectors_entry = {
> +	.attr = {.name = "max_dev_sectors_kb", .mode = S_IRUGO },
> +	.show = queue_max_dev_sectors_show,
> +};
> +
>  static struct queue_sysfs_entry queue_max_segments_entry = {
>  	.attr = {.name = "max_segments", .mode = S_IRUGO },
>  	.show = queue_max_segments_show,
> @@ -483,6 +495,7 @@ static struct attribute *default_attrs[] = {
>  	&queue_requests_entry.attr,
>  	&queue_ra_entry.attr,
>  	&queue_max_hw_sectors_entry.attr,
> +	&queue_max_dev_sectors_entry.attr,
>  	&queue_max_sectors_entry.attr,
>  	&queue_max_segments_entry.attr,
>  	&queue_max_integrity_segments_entry.attr,

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

