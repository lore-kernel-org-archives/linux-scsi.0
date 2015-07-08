From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/3] sd: do not try to spin-up disks for ALUA
 'transitioning' state
Date: Wed, 8 Jul 2015 11:41:23 +0300
Message-ID: <559CE233.3080809@dev.mellanox.co.il>
References: <1436341268-91432-1-git-send-email-hare@suse.de>
 <1436341268-91432-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37965 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793AbbGHIlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 04:41:13 -0400
Received: by wibdq8 with SMTP id dq8so205399689wib.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 01:41:11 -0700 (PDT)
In-Reply-To: <1436341268-91432-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 7/8/2015 10:41 AM, Hannes Reinecke wrote:
> If a disk reports an ALUA 'transitioning' state we should not
> try to spin up the device.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/sd.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7c0bdaa..180a6e8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1801,6 +1801,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   		if (sense_valid && sshdr.sense_key == NOT_READY) {
>   			if (sshdr.asc == 4 && sshdr.ascq == 3)
>   				break;	/* manual intervention required */
> +			if (sshdr.asc == 4 && sshdr.ascq == 0xa)
> +				break;  /* transitioning */
>   			if (sshdr.asc == 4 && sshdr.ascq == 0xb)
>   				break;	/* standby */
>   			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
>


Hi Hannes,

Just nit-picking, but do you think that these four if statements can be
re-organized to condition (asc == 4) once and OR on the rest?
