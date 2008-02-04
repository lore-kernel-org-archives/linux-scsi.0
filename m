From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/24][RFC] firewire & ieee1394: Simple convert to new
 scsi_eh_cpy_sense.
Date: Mon, 04 Feb 2008 17:37:11 +0100
Message-ID: <47A73F37.7090704@s5r6.in-berlin.de>
References: 47A72A7F.1050301@panasas.com <1202140606-4629-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41781 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYBDQhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:37:13 -0500
In-Reply-To: <1202140606-4629-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Boaz Harrosh wrote:
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -1672,8 +1673,11 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
>   * Translates SBP-2 status into SCSI sense data for check conditions
>   */
>  static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
> -					      unchar *sense_data)
> +					      struct scsi_cmnd *SCpnt)
>  {
> +	u8 sense_data[16];
> +
> +	memset(sense_data, 0, sizeof(sense_data));
>  	/* OK, it's pretty ugly... ;-) */
>  	sense_data[0] = 0x70;
>  	sense_data[1] = 0x0;
> @@ -1691,6 +1695,7 @@ static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
>  	sense_data[13] = sbp2_status[11];
>  	sense_data[14] = sbp2_status[20];
>  	sense_data[15] = sbp2_status[21];
> +	scsi_eh_cpy_sense(SCpnt, sense_data, sizeof(sense_data));
>  
>  	return sbp2_status[8] & 0x3f;
>  }

You don't need the memset.

Also, here and in drivers/firewire/fw-sbp2.c, the SCSI sense data could
AFAICS be rewritten in-place in sbp2_status.  But I don't know if this
is a worthwhile optimization; it would reduce readability.
-- 
Stefan Richter
-=====-==--- --=- --=--
http://arcgraph.de/sr/
