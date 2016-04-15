From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/9] sd: configure ZBC devices
Date: Fri, 15 Apr 2016 08:47:29 -0700
Message-ID: <57110D11.2010201@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:55883
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751269AbcDOPri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 11:47:38 -0400
In-Reply-To: <1459764020-126038-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> +static int
> +sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
> +		    unsigned char *buffer, int bufflen )
> +{
> [ ... ]
> +	put_unaligned_be64(start_lba, &cmd[2]);
> +	put_unaligned_be32(bufflen, &cmd[10]);

The argument "sector_t start_lba" is confusing me. Isn't a number either 
a sector number or an LBA? Shouldn't that number be shifted right by 
ilog2(sdp->sector_size) - 9 before storing it in the CDB?

Bart.
