From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: retry MODE SENSE on unit attention
Date: Mon, 6 Jul 2015 08:19:07 -0700
Message-ID: <559A9C6B.7060908@sandisk.com>
References: <1436181409-83358-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:1690
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015AbbGFPTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 11:19:12 -0400
In-Reply-To: <1436181409-83358-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/06/2015 04:16 AM, Hannes Reinecke wrote:
> The 'sd' driver is calling scsi_mode_sense() to figure out
> internal details. But scsi_mode_sense() never checks for
> any pending unit attentions, leading to incorrect decisions
> during probing.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Ewan Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b1a2631..4f3c120 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2423,7 +2423,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>   	unsigned char cmd[12];
>   	int use_10_for_ms;
>   	int header_length;
> -	int result;
> +	int result, retry_count = retries;
>   	struct scsi_sense_hdr my_sshdr;
>
>   	memset(data, 0, sizeof(*data));
> @@ -2502,6 +2502,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>   			data->block_descriptor_length = buffer[3];
>   		}
>   		data->header_length = header_length;
> +	} else if ((status_byte(result) == CHECK_CONDITION) &&
> +		   scsi_sense_valid(sshdr) &&
> +		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
> +		retry_count--;
> +		goto retry;
>   	}
>
>   	return result;

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
