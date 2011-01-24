From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Mon, 24 Jan 2011 09:04:15 +0100
Message-ID: <4D3D327F.1040807@suse.de>
References: <4D385C0A.3000901@suse.de>  <4D385F69.5060209@interlog.com> <1295541361.3014.8.camel@mulgrave.site> <4D3C100C.1010609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1AXH5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 02:57:08 -0500
In-Reply-To: <4D3C100C.1010609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 01/23/2011 12:25 PM, Boaz Harrosh wrote:
> On 01/20/2011 06:36 PM, James Bottomley wrote:
>> On Thu, 2011-01-20 at 17:14 +0100, Douglas Gilbert wrote:
>>> On 11-01-20 05:00 PM, Hannes Reinecke wrote:
>>>> Agenda topic proposal:
>>>>
>>>> SCSI referrals support has already been discussed at last year's L=
SF
>>>> conference. However, the solution proposed there would not support
>>>> failover and would require quite a lot of changes to multipathing.
>>>>
>>>> To enable failover it might be an idea to handle the LUN directly =
in
>>>> multipathing. This would require eg:
>>>> - request splitting
>>>> - I/O alignment handling
>>>> - SCSI unit attention handling
>>>>
>>>> I would be giving a short overview/presentation of the current
>>>> state of the art, the shortcomings on the original proposal,
>>>> and would like to invite a discussion on how to best support
>>>> SCSI referrals.
>>>
>>> IMO a worrying aspect of the changes associated with SCSI
>>> referrals is that sense data can now be returned with any
>>> SCSI status (i.e. not just CHECK CONDITION). How well would
>>> the SCSI subsystem cope with that? I know that the sg driver
>>> (and probably bsg) would need changes, as would my libsgutils
>>> library used by sg3_utils.
>>
>> Well, not necessarily.  It scuppers plans to try to use the sense bu=
ffer
>> more efficiently, but right at the moment, we can receive sense for =
any
>> command.  We only actually look at it on a check condition return, b=
ut
>> that's easily updated.
>>
>> As I read the standard, referrals sense data on successfully complet=
ed
>> commands is only really relevant to mp implementations, so it looks =
like
>> the mid-layer should ignore it anyway (as it would now) but provide =
a
>> hook for the device handlers to see it if they wanted.
>>
>> James
>>
> Something like:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index eafeeda..454e562 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -722,20 +722,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, =
unsigned int good_bytes)
>  			sense_deferred =3D scsi_sense_is_deferred(&sshdr);
>  	}
> =20
> +	if (req->sense) {
> +		/*
> +		 * SG_IO wants current and deferred errors
> +		 */
> +		int len =3D 8 + cmd->sense_buffer[7];
> +
> +		if (unlikely(len)) {
> +			if (len > SCSI_SENSE_BUFFERSIZE)
> +				len =3D SCSI_SENSE_BUFFERSIZE;
> +			memcpy(req->sense, cmd->sense_buffer,  len);
> +			req->sense_len =3D len;
> +		}
> +	}
> +
>  	if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from b=
lock level */
>  		req->errors =3D result;
>  		if (result) {
> -			if (sense_valid && req->sense) {
> -				/*
> -				 * SG_IO wants current and deferred errors
> -				 */
> -				int len =3D 8 + cmd->sense_buffer[7];
> -
> -				if (len > SCSI_SENSE_BUFFERSIZE)
> -					len =3D SCSI_SENSE_BUFFERSIZE;
> -				memcpy(req->sense, cmd->sense_buffer,  len);
> -				req->sense_len =3D len;
> -			}
>  			if (!sense_deferred)
>  				error =3D -EIO;
>  		}
>=20
> Then an interested user can just look at req->sense_len. The reset of=
 the stack will
> ignore all that because it looks for status/error-code.
>=20
Ah, if it were so easy. Currently sense codes have two problems:

- They are limited to 96 bytes. Anything larger than that will just
  be discarded (or crash with your patch above :-)
- They inherit the same lifetime than the scsi command. But for any
  decent handling you really need to push them into some
  asynchronous context as you might well be within an interrupt
  handler here.

I'm currently working on a handling framework using relayfs
(basically blktrace for SCSI Unit Attention); I can be doing a short
presentation at LSF if requested.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
