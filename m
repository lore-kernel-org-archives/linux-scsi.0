From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/20] scsi: use 'bool' as return value for scsi_normalize_sense()
Date: Fri, 05 Sep 2014 08:07:14 +0200
Message-ID: <54095312.4090901@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-9-git-send-email-hare@suse.de> <5409092F.4080207@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaIEGHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2014 02:07:17 -0400
In-Reply-To: <5409092F.4080207@hitachi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 09/05/2014 02:51 AM, Yoshihiro YUNOMAE wrote:
> (2014/09/03 19:06), Hannes Reinecke wrote:
>> Convert scsi_normalize_sense() and frieds to return 'bool'
>> instead of an integer.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 14 +++++++-------
>>   drivers/scsi/scsi_lib.c   |  2 +-
>>   include/scsi/scsi_eh.h    | 12 ++++++------
>>   3 files changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 6c99624..8a6d382 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -2408,20 +2408,20 @@ EXPORT_SYMBOL(scsi_reset_provider);
>>    *	responded to a SCSI command with the CHECK_CONDITION status.
>>    *
>>    * Return value:
>> - *	1 if valid sense data information found, else 0;
>> + *	true if valid sense data information found, else false;
>>    */
>> -int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>> -                         struct scsi_sense_hdr *sshdr)
>> +bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>> +			  struct scsi_sense_hdr *sshdr)
>>   {
>>   	if (!sense_buffer || !sb_len)
>> -		return 0;
>> +		return false;
>>  =20
>>   	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
>>  =20
>>   	sshdr->response_code =3D (sense_buffer[0] & 0x7f);
>>  =20
>>   	if (!scsi_sense_valid(sshdr))
>> -		return 0;
>> +		return false;
>>  =20
>>   	if (sshdr->response_code >=3D 0x72) {
>>   		/*
>> @@ -2451,11 +2451,11 @@ int scsi_normalize_sense(const u8 *sense_buf=
fer, int sb_len,
>>   		}
>>   	}
>>  =20
>> -	return 1;
>> +	return true;
>>   }
>>   EXPORT_SYMBOL(scsi_normalize_sense);
>>  =20
>> -int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
>> +bool scsi_command_normalize_sense(struct scsi_cmnd *cmd,
>>   				 struct scsi_sense_hdr *sshdr)
>>   {
>>   	return scsi_normalize_sense(cmd->sense_buffer,
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index de178f7..8cad004 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -830,7 +830,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, u=
nsigned int good_bytes)
>>   	struct request *req =3D cmd->request;
>>   	int error =3D 0;
>>   	struct scsi_sense_hdr sshdr;
>> -	int sense_valid =3D 0;
>> +	bool sense_valid =3D false;
>>   	int sense_deferred =3D 0;
>>   	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>>   	      ACTION_DELAYED_RETRY} action;
>> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
>> index 06a8790..1427a66 100644
>> --- a/include/scsi/scsi_eh.h
>> +++ b/include/scsi/scsi_eh.h
>> @@ -27,7 +27,7 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 =
*/
>>   	u8 additional_length;	/* always 0 for fixed sense format */
>>   };
>>  =20
>> -static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
>> +static inline bool scsi_sense_valid(struct scsi_sense_hdr *sshdr)
>>   {
>>   	if (!sshdr)
>>   		return 0;
>=20
> Should be "return false;"
>=20
Bah. You are correct.

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
