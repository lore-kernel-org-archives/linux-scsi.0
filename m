From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] target-pscsi: query tape blocksize using
	scsi_execute_req
Date: Thu, 25 Nov 2010 23:22:21 -0800
Message-ID: <1290756141.16160.66.camel@haakon2.linux-iscsi.org>
References: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
	 <1290755672-19819-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40952 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0KZH1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2010 02:27:53 -0500
In-Reply-To: <1290755672-19819-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

On Thu, 2010-11-25 at 23:14 -0800, Nicholas A. Bellinger wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Use the native Linux scsi execution support instead of the target passthrough
> support to get the tape blocksize
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pscsi.c |   66 ++++++++++++++++--------------------
>  1 files changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index b14fe35..773ff83 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -181,6 +181,33 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
>  	return 1;
>  }
>  
> +static void pscsi_tape_read_blocksize(struct se_device *dev,
> +		struct scsi_device *sdev)
> +{
> +	unsigned char cdb[MAX_COMMAND_SIZE], *buf;
> +
> +	buf = kzalloc(12, GFP_KERNEL);
> +	if (!buf)
> +		return;
> +
> +	memset(cdb, 0, MAX_COMMAND_SIZE);
> +	cdb[0] = MODE_SENSE;
> +	cdb[4] = 0x0c; /* 12 bytes */
> +
> +	if (!scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
> +			HZ, 1, NULL))
> +		goto out_free;
> +

Hrrrmmm, missed the bugfix for the proper return value of
scsi_execute_req() here.

Committed the following incremental patch as 4793c9f04ba.

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 9cc6bc4..defde22 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -185,6 +185,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
                struct scsi_device *sdev)
 {
        unsigned char cdb[MAX_COMMAND_SIZE], *buf;
+       int ret;

        buf = kzalloc(12, GFP_KERNEL);
        if (!buf)
@@ -194,8 +195,9 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
        cdb[0] = MODE_SENSE;
        cdb[4] = 0x0c; /* 12 bytes */

-       if (!scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-                       HZ, 1, NULL))
+       ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
+                       HZ, 1, NULL);
+       if (ret)
                goto out_free;

        /*
-- 
1.5.6.5


