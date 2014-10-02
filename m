From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 02 Oct 2014 14:14:19 +0200
Message-ID: <542D419B.5080406@suse.de>
References: <1411991272-129962-1-git-send-email-hare@suse.de>	 <542C4D33.2030401@hp.com> <20141001211003.GA24820@infradead.org>	 <542CF5E8.3030601@suse.de> <1412251542.6343.6.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaJBMOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 08:14:21 -0400
In-Reply-To: <1412251542.6343.6.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "webbnh@hp.com" <webbnh@hp.com>

On 10/02/2014 02:05 PM, James Bottomley wrote:
> On Thu, 2014-10-02 at 08:51 +0200, Hannes Reinecke wrote:
>> On 10/01/2014 11:10 PM, Christoph Hellwig wrote:
>>> On Wed, Oct 01, 2014 at 02:51:31PM -0400, Webb Scales wrote:
>>>> Hannes,
>>>>
>>>> In megasas_change_queue_type(), is it possible for sdev->queue_dep=
th to be
>>>> greater than 256?
>>>>
>>>> Unless I'm misunderstanding the SCSI code, we can request a
>>>> queue-depth/tag-map-size which is greater than 256, but, since the
>>>> scsi_cmnd::tag field is an unsigned char, depths greater than 256 =
may
>>>> overflow the field when high-numbered tags are used...do I have th=
at right?
>>>
>>> Yes, we really need to increase the size of the tag field.  SAM all=
ows
>>> a transport specific limit of up to 64 _bytes_ for it, although I d=
on't
>>> know implementation that large.  Given that the block layer can gen=
erate
>>> up to 32-bit tags both for the old blk-tag.c code and the new
>>> blk-mq-tag.c version it would be good to use a u32 there.  Can you =
send
>>> me a patch?
>>>
>> Weeelll ...
>>
>> I'm afraid it's not _that_ easy.
>> SCSI-II tagged queueing has some specific tag values:
>>
>> #define SIMPLE_QUEUE_TAG    0x20
>> #define HEAD_OF_QUEUE_TAG   0x21
>> #define ORDERED_QUEUE_TAG   0x22
>>
>> drivers/scsi/vmw_pvscsi.c:
>> 	e->tag =3D SIMPLE_QUEUE_TAG;
>> 	if (sdev->tagged_supported &&
>> 	    (cmd->tag =3D=3D HEAD_OF_QUEUE_TAG ||
>> 	     cmd->tag =3D=3D ORDERED_QUEUE_TAG))
>> 		e->tag =3D cmd->tag;
>=20
> A SCSI-2 tag is a SPI two byte message.  The first byte is the messag=
e
> type.  The values you have above identify the message type for simple=
,
> ordered and head of queue tags.  The *second* byte is the tag value.
>=20
> See page 55 and 56 of the SCSI-2 standard.  There's no connection (or
> shouldn't be) between the message type and the tag value, so it looks
> like a bug in the pvscsi driver.
>=20
It is. I've already sent a patch.

But that just proves the scmd->tag is essentially a duplicate
and we should be removing it.

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
