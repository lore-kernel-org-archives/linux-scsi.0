From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 1/9] [SCSI] Detect overflow of sense data buffer
Date: Wed, 23 Jan 2013 11:44:12 +0100
Message-ID: <50FFBEFC.7040903@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>  <1358526434-1173-2-git-send-email-emilne@redhat.com>  <1358527592.2345.35.camel@dabdike.int.hansenpartnership.com> <1358867323.4420.315.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab3AWKoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 05:44:13 -0500
In-Reply-To: <1358867323.4420.315.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 01/22/2013 04:08 PM, Ewan Milne wrote:
> On Fri, 2013-01-18 at 16:46 +0000, James Bottomley wrote:
>> On Fri, 2013-01-18 at 11:27 -0500, Ewan D. Milne wrote:
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -241,6 +241,9 @@ static int scsi_check_sense(struct scsi_cmnd *s=
cmd)
>>>   	if (! scsi_command_normalize_sense(scmd, &sshdr))
>>>   		return FAILED;	/* no valid sense data */
>>>
>>> +	if (sshdr.overflow)
>>> +		scmd_printk(KERN_WARNING, scmd, "Sense data overflow");
>>> +
>>>   	if (scsi_sense_is_deferred(&sshdr))
>>>   		return NEEDS_RETRY;
>>>
>>> @@ -2059,14 +2062,18 @@ int scsi_normalize_sense(const u8 *sense_bu=
ffer, int sb_len,
>>>   			sshdr->asc =3D sense_buffer[2];
>>>   		if (sb_len > 3)
>>>   			sshdr->ascq =3D sense_buffer[3];
>>> +		if (sb_len > 4)
>>> +			sshdr->overflow =3D ((sense_buffer[4] & 0x80) !=3D 0);
>>>   		if (sb_len > 7)
>>>   			sshdr->additional_length =3D sense_buffer[7];
>>>   	} else {
>>>   		/*
>>>   		 * fixed format
>>>   		 */
>>> -		if (sb_len > 2)
>>> +		if (sb_len > 2) {
>>> +			sshdr->overflow =3D ((sense_buffer[2] & 0x10) !=3D 0);
>>>   			sshdr->sense_key =3D (sense_buffer[2] & 0xf);
>>> +		}
>>>   		if (sb_len > 7) {
>>>   			sb_len =3D (sb_len < (sense_buffer[7] + 8)) ?
>>>   					 sb_len : (sense_buffer[7] + 8);
>>
>> This isn't the right way to do it:  The overflow bit is a recent
>> introduction in SPC-4.  The correct way to tell if we have an overfl=
ow
>> or not is to look at the additional sense length and compare it to t=
he
>> allocation length; this will work for everything.
>
> Unfortunately, I am not sure that the allocation length that was sent
> to the device is always available.  I will look into this more closel=
y
> but it appeared to me that e.g. FC drivers like qla2xxx get the sense
> data automatically from the HBA firmware.  In the case of that driver
> the host sense buffer size looks like it is hard-coded to 32 bytes,
> for all I know the firmware might only asking for 18 bytes.
>
Hmm.

Maybe we should be adding a 'max_sense_len' field to the SCSI host;
that way we could check against this.
Nevertheless, that information would be lost to us in either case.

I wonder how these vendors propose to handle long sense code data;
silently ignoring it doesn't seem to be the correct way.

> Of course, for a normal REQUEST SENSE command where the allocation
> length is in the CDB, it would indeed be easy to add a check against
> the additional sense length.
>
>>
>> I'm not even convinced that overflow is important: for a lot of the
>> sense probes, we deliberately induce overflows by giving the request
>> sense command a short buffer.  Printing a warning in scsi_check_sens=
e
>> will get very noisy very fast.
>
> That would indeed be a problem.  I didn't see this behavior when test=
ing
> the changes but I'll need to investigate this further.
>
> The purpose of detecting the sense data overflow was to provide some
> visibility that a device is returning a large amount of sense data th=
at
> is currently being silently ignored.  In the case of descriptor forma=
t
> sense data, it is possible that a descriptor we want to examine is
> located after one or more other descriptors, and we might not get it
> at all if the buffer isn't large enough.
>
Agreed. but the newest standard won't be adopted to existing=20
devices, so we should figure out a way of dealing with those, too.

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
