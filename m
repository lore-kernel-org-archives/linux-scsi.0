From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/20] scsi: separate out scsi_retval_string()
Date: Fri, 05 Sep 2014 08:14:19 +0200
Message-ID: <540954BB.6080500@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-17-git-send-email-hare@suse.de> <54091A22.1070900@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaIEGOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2014 02:14:21 -0400
In-Reply-To: <54091A22.1070900@hitachi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 09/05/2014 04:04 AM, Yoshihiro YUNOMAE wrote:
> (2014/09/03 19:06), Hannes Reinecke wrote:
>> Implement scsi_retval_string() to simplify logging.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/constants.c | 28 ++++++++++++++++++++++++++++
>>   drivers/scsi/scsi.c      | 34 ++++++----------------------------
>>   include/scsi/scsi_dbg.h  |  1 +
>>   3 files changed, 35 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 5486816..85d2da0 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1426,6 +1426,34 @@ void scsi_print_sense(struct scsi_cmnd *cmd)
>>   EXPORT_SYMBOL(scsi_print_sense);
>>  =20
>>   #ifdef CONFIG_SCSI_CONSTANTS
>> +static const struct error_info internal_retval_table[] =3D
>> +{
>> +	{ NEEDS_RETRY, "NEEDS_RETRY " },
>> +	{ SUCCESS, "SUCCESS " },
>> +	{ FAILED, "FAILED " },
>> +	{ QUEUED, "QUEUED " },
>> +	{ SOFT_ERROR, "SOFT_ERROR " },
>> +	{ ADD_TO_MLQUEUE, "ADD_TO_MLQUEUE " },
>> +	{ TIMEOUT_ERROR, "TIMEOUT " },
>> +	{ SCSI_RETURN_NOT_HANDLED, "NOT_HANDLED " },
>> +	{ FAST_IO_FAIL, "FAST_IO_FAIL " },
>=20
> We don't need to add space in the last of strings, I think.
> In scsi_log_completion(), the messages inserts line feeds after the
> strings.
>=20
>> +};
>> +#endif
>> +
>> +const char *
>> +scsi_retval_string(unsigned int ret)
>> +{
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +	int i;
>> +
>> +	for (i =3D 0; internal_retval_table[i].text; i++)
>> +		if (internal_retval_table[i].code12 =3D=3D ret)
>> +			return internal_retval_table[i].text;
>> +#endif
>> +	return NULL;
>> +}
>> +
>> +#ifdef CONFIG_SCSI_CONSTANTS
>>  =20
>>   static const char * const hostbyte_table[]=3D{
>>   "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_B=
AD_TARGET",
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 8954036..a1944c8 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -566,35 +566,13 @@ void scsi_log_completion(struct scsi_cmnd *cmd=
, int disposition)
>>   				       SCSI_LOG_MLCOMPLETE_BITS);
>>   		if (((level > 0) && (cmd->result || disposition !=3D SUCCESS)) |=
|
>>   		    (level > 1)) {
>> -			scmd_printk(KERN_INFO, cmd, "Done: ");
>>   			if (level > 2)
>> -				printk("0x%p ", cmd);
>> -			/*
>> -			 * Dump truncated values, so we usually fit within
>> -			 * 80 chars.
>> -			 */
>> -			switch (disposition) {
>> -			case SUCCESS:
>> -				printk("SUCCESS\n");
>> -				break;
>> -			case NEEDS_RETRY:
>> -				printk("RETRY\n");
>> -				break;
>> -			case ADD_TO_MLQUEUE:
>> -				printk("MLQUEUE\n");
>> -				break;
>> -			case FAILED:
>> -				printk("FAILED\n");
>> -				break;
>> -			case TIMEOUT_ERROR:
>> -				/*
>> -				 * If called via scsi_times_out.
>> -				 */
>> -				printk("TIMEOUT\n");
>> -				break;
>> -			default:
>> -				printk("UNKNOWN\n");
>> -			}
>> +				scmd_printk(KERN_INFO, cmd,
>> +					    "Done: 0x%p %s\n", cmd,
>> +					    scsi_retval_string(disposition));
>> +			else
>> +				scmd_printk(KERN_INFO, cmd, "Done: %s",
>=20
> We had better add "\n" in this last strings to indicate the end of li=
ne.
> Structured printk automatically outputs the message in atomic,
> but adding "\n" becomes more readable.
>=20
True, we should be adding the newline.
Although the reasoning is wrong; a newline instructs printk() to
actually ship out the message. Without a newline printk assumes
it'll be line continuation.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
