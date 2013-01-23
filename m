From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 1/9] [SCSI] Detect overflow of sense data buffer
Date: Wed, 23 Jan 2013 08:16:57 +0100
Message-ID: <50FF8E69.5060001@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>  <1358526434-1173-2-git-send-email-emilne@redhat.com>  <1358527592.2345.35.camel@dabdike.int.hansenpartnership.com>  <50FCEDB4.8080801@suse.de> <1358867446.4420.317.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3AWHRE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 02:17:04 -0500
In-Reply-To: <1358867446.4420.317.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 01/22/2013 04:10 PM, Ewan Milne wrote:
> On Mon, 2013-01-21 at 08:26 +0100, Hannes Reinecke wrote:
>> On 01/18/2013 05:46 PM, James Bottomley wrote:
>>> On Fri, 2013-01-18 at 11:27 -0500, Ewan D. Milne wrote:
>>>> --- a/drivers/scsi/scsi_error.c
>>>> +++ b/drivers/scsi/scsi_error.c
>>>> @@ -241,6 +241,9 @@ static int scsi_check_sense(struct scsi_cmnd *=
scmd)
>>>>    	if (! scsi_command_normalize_sense(scmd, &sshdr))
>>>>    		return FAILED;	/* no valid sense data */
>>>>
>>>> +	if (sshdr.overflow)
>>>> +		scmd_printk(KERN_WARNING, scmd, "Sense data overflow");
>>>> +
>>>>    	if (scsi_sense_is_deferred(&sshdr))
>>>>    		return NEEDS_RETRY;
>>>>
>>>> @@ -2059,14 +2062,18 @@ int scsi_normalize_sense(const u8 *sense_b=
uffer, int sb_len,
>>>>    			sshdr->asc =3D sense_buffer[2];
>>>>    		if (sb_len > 3)
>>>>    			sshdr->ascq =3D sense_buffer[3];
>>>> +		if (sb_len > 4)
>>>> +			sshdr->overflow =3D ((sense_buffer[4] & 0x80) !=3D 0);
>>>>    		if (sb_len > 7)
>>>>    			sshdr->additional_length =3D sense_buffer[7];
>>>>    	} else {
>>>>    		/*
>>>>    		 * fixed format
>>>>    		 */
>>>> -		if (sb_len > 2)
>>>> +		if (sb_len > 2) {
>>>> +			sshdr->overflow =3D ((sense_buffer[2] & 0x10) !=3D 0);
>>>>    			sshdr->sense_key =3D (sense_buffer[2] & 0xf);
>>>> +		}
>>>>    		if (sb_len > 7) {
>>>>    			sb_len =3D (sb_len < (sense_buffer[7] + 8)) ?
>>>>    					 sb_len : (sense_buffer[7] + 8);
>>>
>>> This isn't the right way to do it:  The overflow bit is a recent
>>> introduction in SPC-4.  The correct way to tell if we have an overf=
low
>>> or not is to look at the additional sense length and compare it to =
the
>>> allocation length; this will work for everything.
>>>
>>> I'm not even convinced that overflow is important: for a lot of the
>>> sense probes, we deliberately induce overflows by giving the reques=
t
>>> sense command a short buffer.  Printing a warning in scsi_check_sen=
se
>>> will get very noisy very fast.
>>>
>> And indeed I would rather prefer to have it the other way round;
>> we're using a fixed sense_buffer within the SCSI stack, which might
>> not be large enough to hold all sense data.
>> So I would prefer to have an indicator on whether _the internal_
>> sense buffer overflowed; this would even give us some valid use-case
>> now.
>
> So, if I understand what you're saying, we could check for overflow i=
f
> (sense_data[7] + 8) > SCSI_SENSE_BUFFERSIZE
>
Precisely.

> We could do that, certainly.  I think, though, that overflow of sense
> data is more likely to occur if a sense buffer smaller than
> SCSI_SENSE_BUFFERSIZE bytes is used, e.g. by a call to
> scsi_eh_prep_cmnd(), which is an exported symbol.
>
> The existing 96-byte SCSI_SENSE_BUFFERSIZE may well be big enough.
> (I did increase it to the SPC-4 defined value of 252 bytes in a later
> patch in the series if the appropriate kernel config option is enable=
d.)
>
Indeed, it _may_.

I just would like to have an indicator on whether it actually _is_.
Currently we have no way of telling.
Seeing that we want to implement _real_ sense code handling we
really want to know whether we've missed some information.

Relying on the SPC-defined values doesn't really cut it, as it's=20
only in the very latest draft and it'll be ages until we're seeing
these devices in the field. So we have to find a way of handling
older devices, which may yet send us large sense data.
(Think of referrals ...)

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
