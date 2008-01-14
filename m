From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 1/2] don't zero out sense_buffer in queuecommand
Date: Mon, 14 Jan 2008 05:14:12 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA870@ADPE2K703.adaptec.com>
References: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:51681 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYANNOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 08:14:17 -0500
In-Reply-To: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'FUJITA Tomonori' <tomof@acm.org>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'fujita.tomonori@lab.ntt.co.jp'" <fujita.tomonori@lab.ntt.co.jp>

ACK on ips bits.

Sincerely -- Mark Salyzyn
. . .
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index e54d30c..b1b2295 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -2736,8 +2736,6 @@ ips_next(ips_ha_t * ha, int intr)
>                 SC->result = DID_OK;
>                 SC->host_scribble = NULL;
>
> -               memset(SC->sense_buffer, 0, sizeof
> (SC->sense_buffer));
> -
>                 scb->target_id = SC->device->id;
>                 scb->lun = SC->device->lun;
>                 scb->bus = SC->device->channel;
> @@ -3821,7 +3819,6 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>                         /* attempted, a Check Condition
> occurred, and Sense   */
>                         /* Data indicating an Invalid CDB
> OpCode is returned. */
>                         sp = (char *) scb->scsi_cmd->sense_buffer;
> -                       memset(sp, 0, sizeof
> (scb->scsi_cmd->sense_buffer));
>
>                         sp[0] = 0x70;   /* Error Code               */
>                         sp[2] = ILLEGAL_REQUEST;        /*
> Sense Key 5 Illegal Req. */
. . .
