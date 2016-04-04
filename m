From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 03/14] libata-scsi: sanitize ata_gen_ata_sense()
Date: Mon, 4 Apr 2016 14:26:51 +0300
Message-ID: <57024F7B.20604@cogentembedded.com>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
 <1459763047-125551-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35815 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbcDDL0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 07:26:54 -0400
Received: by mail-lf0-f50.google.com with SMTP id c126so46550410lfb.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2016 04:26:53 -0700 (PDT)
In-Reply-To: <1459763047-125551-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 4/4/2016 12:43 PM, Hannes Reinecke wrote:

> ata_to_sense_error() is called conditionally, so we should be
> generating a default sense if the condition is not met.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/ata/libata-scsi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 6dc2fad..e331077 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1074,6 +1074,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
>   		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
>   				   &sb[1], &sb[2], &sb[3], verbose);
>   		sb[1] &= 0x0f;
> +	} else {
> +		/* Could not decode error */
> +		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",

    "%#x" is equivalent and takes up less space.

[...]

MBR, Sergei

