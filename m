From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH 1/2] scsi_dh_alua: ALUA check sense should retry device
 internal reset unit attention
Date: Tue, 21 Jan 2014 23:46:13 +0000
Message-ID: <1390347972.7608.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <1390347399-20393-1-git-send-email-sean.stewart@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:57884 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaAUXqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 18:46:14 -0500
In-Reply-To: <1390347399-20393-1-git-send-email-sean.stewart@netapp.com>
Content-Language: en-US
Content-ID: <754231C8C0A72D4DB4294E1D7CA3CE4C@hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>

Please disregard. Accidentally resent this patch via a script :)

Thanks,
Sean

On Tue, 2014-01-21 at 17:36 -0600, Sean Stewart wrote:
> When the scsi_dh_alua handler issues an RTPG during initialization, if
> it gets 0x06/0x29/0x04 as the sense, it will fail to attach the handler.
> NetApp E-Series returns 0x29/0x00 for power on, and 0x29/0x04 for
> conditions that cause the controller to reboot again.  These conditions
> should be treated identically within the handler.
> 
> Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 68adb89..78205cc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -481,6 +481,11 @@ static int alua_check_sense(struct scsi_device *sdev,
>  			 * Power On, Reset, or Bus Device Reset, just retry.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
> +			/*
> +			 * Device internal reset
> +			 */
> +			return ADD_TO_MLQUEUE;
>  		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
>  			/*
>  			 * Mode Parameters Changed


