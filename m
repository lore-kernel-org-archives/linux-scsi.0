From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Fri, 08 Jan 2010 21:47:55 +0100
Message-ID: <4B4799FB.9030208@googlemail.com>
References: <4B3BDB66.6000008@googlemail.com>  <4B4632BF.4070806@pobox.com> <1262964519.3025.614.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:8914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0AHUrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2010 15:47:36 -0500
In-Reply-To: <1262964519.3025.614.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On 01/08/10 16:28, James Bottomley wrote:
> On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>> On 12/30/2009 05:59 PM, Ren=C3=A9 Bolldorf wrote:
>>> We don't need this ;-).
>>>
>>> Best regards Ren=C3=A9 Bolldorf&  a happy new year in advance.
>>>
>>> --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
>>> +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
>>> @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
>>>
>>> DPRINTK("ATAPI request sense\n");
>>>
>>> - /* FIXME: is this needed? */
>>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>>
>> I need a little bit more detail than an unqualified statement...  Di=
d
>> you audit all paths leading to this code point?
>
> There are two code paths coming into here.  One directly from the scs=
i
> sense buffer:
>
> 		if (!(qc->ap->pflags&  ATA_PFLAG_FROZEN)) {
> 			tmp =3D atapi_eh_request_sense(qc->dev,
> 						qc->scsicmd->sense_buffer,
> 						qc->result_tf.feature>>  4);
>
> Which is fine because SCSI zeros the sense buffer.
>
> But one also here:
>
> 		u8 *sense_buffer =3D dev->link->ap->sector_buf;
> 		[...]
> 		err_mask =3D atapi_eh_request_sense(dev, sense_buffer, sense_key);
>
> Which doesn't look OK because it looks like the sector_buf isn't clea=
red
> (and it is reused).
>
> James
>
>

Thank's, you're right. I have overseen this, sry for that.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
