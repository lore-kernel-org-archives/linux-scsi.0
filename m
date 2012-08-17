From: Jeff Garzik <jgarzik@pobox.com>
Subject: Enabling FUA for SATA drives (was Re: [RFC][PATCH] libata: enable
 SATA disk fua detection on default)
Date: Fri, 17 Aug 2012 14:06:39 -0400
Message-ID: <502E882F.6090500@pobox.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2HQSGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2012 14:06:44 -0400
In-Reply-To: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>

On 05/07/2012 11:24 PM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> Currently, SATA disk fua detection is disabled on default because most of
> devices don't support this feature at that time.  With the development of
> technology, more and more SATA disks support this feature.  So now we can enable
> this detection on default.
>
> Although fua detection is defined as a kernel module parameter, it is too hard
> to set its value because it must be loaded and set before system starts up.
> That needs to modify initrd file.  So it is inconvenient for administrator who
> needs to manage a huge number of servers.
>
> CC: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>   drivers/ata/libata-core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 23763a1..3627251 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -133,9 +133,9 @@ int atapi_passthru16 = 1;
>   module_param(atapi_passthru16, int, 0444);
>   MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>
> -int libata_fua = 0;
> +int libata_fua = 1;
>   module_param_named(fua, libata_fua, int, 0444);
> -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");

Applied.  Let's see how far down the rabbit hole we go ;-)

The FUA decision, as previously indicated, was based on early SATA 
drives, and perhaps better ones are available now.  Only testing will 
tell, at this point.

The larger questions, raised by Christoph and others remain unaddressed 
(though perhaps we can start addressing them now, with this patch):

* what is smart flushing policy for ATA devices with FUA?

* ATA NCQ's flush is not queued

* ATA NCQ always had the FUA bit...

* ...but mixing ATA NCQ FUA and !FUA in a queue is not fully supported 
by the existing code

and probably a few other details I forgot :)

	Jeff







