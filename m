From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: Fixup fixed sense generation
Date: Fri, 31 Jul 2015 07:05:48 -0700
Message-ID: <55BB80BC.5080109@sandisk.com>
References: <1438347903-106697-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:47306
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754566AbbGaOFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 10:05:53 -0400
In-Reply-To: <1438347903-106697-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 07/31/15 06:05, Hannes Reinecke wrote:
> Fixed sense reserves only 32 bits for the 'information' field,
> so we need to restrict the 'information' value to avoid sense
> data corruption.
> Also the sense key is only 4 bits.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_error.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 106884a..ba7ffc4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2510,13 +2510,13 @@ void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
>   {
>   	if (desc) {
>   		buf[0] = 0x72;	/* descriptor, current */
> -		buf[1] = key;
> +		buf[1] = key & 0x0f;
>   		buf[2] = asc;
>   		buf[3] = ascq;
>   		buf[7] = 0;
>   	} else {
>   		buf[0] = 0x70;	/* fixed, current */
> -		buf[2] = key;
> +		buf[2] = key & 0x0f;
>   		buf[7] = 0xa;
>   		buf[12] = asc;
>   		buf[13] = ascq;

Please split these changes into two separate patches - one patch for the 
scsi_build_sense_buffer() changes and another patch for the 
scsi_set_sense_information() changes. Please also add a statement that 
triggers a kernel warning if an out-of-range key value is passed to 
scsi_build_sense_buffer() instead of ignoring out-of-range sense key 
values silently.

Thanks,

Bart.


