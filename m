From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: retry MODE SENSE on unit attention
Date: Fri, 12 Jun 2015 08:27:31 +0200
Message-ID: <557A7BD3.7040607@suse.de>
References: <1434020506-41897-1-git-send-email-hare@suse.de> <1434035231.27387.111.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbbFLG1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 02:27:35 -0400
In-Reply-To: <1434035231.27387.111.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>

On 06/11/2015 05:07 PM, Ewan Milne wrote:
> On Thu, 2015-06-11 at 13:01 +0200, Hannes Reinecke wrote:
>> The 'sd' driver is calling scsi_mode_sense() to figure out
>> internal details. But scsi_mode_sense() never checks for
>> any pending unit attentions, so we're getting annoying error
>> messages like:
>>
>> MODE SENSE: unimplemented page/subpage: 0x00/0x00
>>
>> and a possible wrong decision for device cache handling.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi_lib.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 2428d96..d7915c8 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2423,7 +2423,7 @@ scsi_mode_sense(struct scsi_device *sdev, int =
dbd, int modepage,
>>  	unsigned char cmd[12];
>>  	int use_10_for_ms;
>>  	int header_length;
>> -	int result;
>> +	int result, retry_count =3D retries;
>>  	struct scsi_sense_hdr my_sshdr;
>> =20
>>  	memset(data, 0, sizeof(*data));
>> @@ -2502,6 +2502,11 @@ scsi_mode_sense(struct scsi_device *sdev, int=
 dbd, int modepage,
>>  			data->block_descriptor_length =3D buffer[3];
>>  		}
>>  		data->header_length =3D header_length;
>> +	} else if ((status_byte(result) =3D=3D CHECK_CONDITION) &&
>> +		   scsi_sense_valid(sshdr) &&
>> +		   sshdr->sense_key =3D=3D UNIT_ATTENTION && retry_count) {
>> +		retry_count--;
>> +		goto retry;
>>  	}
>> =20
>>  	return result;
>=20
> Great, but shouldn't we be doing this more generally?  What about
> scsi_mode_select()?
>=20
I haven't seen any issues with scsi_mode_select() as of now, so I
didn't do anything about this :-)

> (And, with the number of status changes that can get reported by
>  UAs, we might want to think about increasing the retry count on
>  these commands up from 3 at some point.)
>=20
Hmm. _Actually_, we're not getting _more_ UAs (neither the number
nor the situation at which UAs are being send has changed).
It's just that we're trying to _use_ UAs so these things pop up.
But yeah, raising the number or retries to eg 5 is probably a good idea=
=2E

> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>=20
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
