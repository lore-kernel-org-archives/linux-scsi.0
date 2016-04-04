From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 3/4] libata: support device-managed ZAC devices
Date: Mon, 4 Apr 2016 14:13:33 +0300
Message-ID: <57024C5D.8070402@cogentembedded.com>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
 <1459763271-125856-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35630 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbcDDLNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 07:13:37 -0400
Received: by mail-lb0-f173.google.com with SMTP id bc4so155083145lbc.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2016 04:13:36 -0700 (PDT)
In-Reply-To: <1459763271-125856-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

Hello.

On 4/4/2016 12:47 PM, Hannes Reinecke wrote:

> Device-managed ZAC devices just set the zoned capabilities field
> in INQUIRY byte 69 (cf ACS-4). This corresponds to the 'zoned'
> field in the block device characteristics VPD page.
> As this is only defined in SPC-5/SBC-4 we also need to update
> the supported SCSI version descriptor.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/ata/libata-scsi.c | 19 ++++++++++---------
>   include/linux/ata.h       |  5 +++++
>   2 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 6db2aaf..ff95ef6 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> @@ -2316,12 +2314,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>   {
>   	int form_factor = ata_id_form_factor(args->id);
>   	int media_rotation_rate = ata_id_rotation_rate(args->id);
> +	u8 zoned = ata_id_zoned_cap(args->id);
>
>   	rbuf[1] = 0xb1;
>   	rbuf[3] = 0x3c;
>   	rbuf[4] = media_rotation_rate >> 8;
>   	rbuf[5] = media_rotation_rate;
>   	rbuf[7] = form_factor;
> +	if (zoned)
> +		rbuf[8] = (zoned << 4);

    Parens not needed here.

[...]

MBR, Sergei

