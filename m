From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi: Return ENODATA on medium error
Date: Thu, 06 Jun 2013 16:40:38 +0200
Message-ID: <51B09F66.5080607@suse.de>
References: <1370416261-57005-1-git-send-email-hare@suse.de> <1370416261-57005-4-git-send-email-hare@suse.de> <51B03FDA.1080705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3FFOkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 10:40:40 -0400
In-Reply-To: <51B03FDA.1080705@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org

On 06/06/2013 09:52 AM, Ren Mingxin wrote:
> Hi, Hannes:
>=20
> On 06/05/2013 03:11 PM, Hannes Reinecke wrote:
>> When a medium error is detected the SCSI stack should return
>> ENODATA to the upper layers.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 7 ++++++-
>>   drivers/scsi/scsi_lib.c   | 5 +++++
>>   include/scsi/scsi.h       | 2 ++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index bf5e61a..2ded10a 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -235,6 +235,7 @@ static inline void
>> scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>>    *    NEEDS_RETRY
>>    *    TARGET_ERROR
>>    *    ALLOC_ERROR
>> + *    MEDIA_FAILURE
>>    *
>>    * Notes:
>>    *    When a deferred error is detected the current command has
>> @@ -375,7 +376,7 @@ static int scsi_check_sense(struct scsi_cmnd
>> *scmd)
>>           if (sshdr.asc =3D=3D 0x11 || /* UNRECOVERED READ ERR */
>>               sshdr.asc =3D=3D 0x13 || /* AMNF DATA FIELD */
>>               sshdr.asc =3D=3D 0x14) { /* RECORD NOT FOUND */
>> -            return TARGET_ERROR;
>> +            return MEDIA_FAILURE;
>>           }
>>           return NEEDS_RETRY;
>>
>> @@ -1598,6 +1599,10 @@ int scsi_decide_disposition(struct
>> scsi_cmnd *scmd)
>>               /* target hit out-of-space condition */
>>               set_host_byte(scmd, DID_ALLOC_FAILURE);
>>               rtn =3D SUCCESS;
>> +        } else if (rtn =3D=3D MEDIA_FAILURE) {
>> +            /* medium error */
>> +            set_host_byte(scmd, DID_MEDIUM_ERROR);
>> +            rtn =3D SUCCESS;
>>           }
>>           /* if rtn =3D=3D FAILED, we have no sense information;
>>            * returning FAILED will wake the error handler thread
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 209a4d5..39d626e 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -711,6 +711,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
>>    * -EREMOTEIO    permanent target failure, do not retry
>>    * -EBADE    permanent nexus failure, retry on other path
>>    * -ENOSPC    No write space available
>> + * -ENODATA    Medium error
>>    */
>>   static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
>> int result)
>>   {
>> @@ -732,6 +733,10 @@ static int __scsi_error_from_host_byte(struct
>> scsi_cmnd *cmd, int result)
>>           set_host_byte(cmd, DID_OK);
>>           error =3D -ENOSPC;
>>           break;
>> +    case DID_MEDIUM_ERROR:
>> +        set_host_byte(cmd, DID_OK);
>> +        error =3D -ENODATA;
>> +        break;
>=20
> It seems that there is a debugging requirement to announce the
> meaning of these new added error codes in the function
> blk_update_request()like this:
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33c33bc..a396eb6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2315,6 +2315,12 @@ bool blk_update_request(struct request *req,
> int error, unsigned int nr_bytes)
>                 case -EBADE:
>                         error_type =3D "critical nexus";
>                         break;
> +               case -ENOSPC:
> +                       error_type =3D "critical space allocation";
> +                       break;
> +               case -ENODATA:
> +                       error_type =3D "critical medium";
> +                       break;
>                 case -EIO:
>                 default:
>                         error_type =3D "I/O";
>=20
And indeed, that's true. I'll be updating the patches.

> # To tell the truth, I'm not understand why this patchset is needed
> # in practice for I've only just got limited info about LSF. I guess
> # this is one of the improvements for SCSI EH. Could you give an
> # example/condition the upper layers interest in?
>=20
No, this is actually related, but independent of the SCSI EH rework.
=46ilesystem folks expressed their interest in these kind of errors.
'ENODATA' is especially of interest, as this mean you will _never_
get the data back. Any other type of error has at least a
theoretical chance to recover the data.

And ENOSPC needs to be differentiated, too, as this is some sort of
'temporary write error'. So when the fs is able to free-up some
space this error might actually be fixed, so it's worth inform the
filesystem about it.

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
