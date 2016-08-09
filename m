From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: fix upper bounds check of sense key in
 scsi_sense_key_string()
Date: Tue, 9 Aug 2016 13:08:15 -0700
Message-ID: <998bca14-1871-0b9e-a748-68dd39a0b634@sandisk.com>
References: <1470346337-20034-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0041.outbound.protection.outlook.com ([104.47.36.41]:45224
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbcHIUI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2016 16:08:26 -0400
In-Reply-To: <1470346337-20034-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On 08/04/2016 02:32 PM, Tyrel Datwyler wrote:
> Commit 655ee63cf371 added a "Completed" sense string with key 0xF to
> snstext[], but failed to updated the upper bounds check of the sense key in
> scsi_sense_key_string().
>
> Fixes: 655ee63cf371 ("[SCSI] scsi constants: command, sense key + additional sense strings")
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/constants.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 83458f7..70d8dc4 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -362,7 +362,7 @@ static const char * const snstext[] = {
>  /* Get sense key string or NULL if not available */
>  const char *
>  scsi_sense_key_string(unsigned char key) {
> -	if (key <= 0xE)
> +	if (key <= 0xF)
>  		return snstext[key];
>  	return NULL;
>  }

Hello Tyrel,

Please move the opening brace ("{") to a line of its own.

If you change "<= 0xF" into "< ARRAY_SIZE(snstext)" then you are welcome 
to add:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Thanks,

Bart.
