From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 02 Oct 2014 08:51:20 +0200
Message-ID: <542CF5E8.3030601@suse.de>
References: <1411991272-129962-1-git-send-email-hare@suse.de> <542C4D33.2030401@hp.com> <20141001211003.GA24820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJBGvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 02:51:23 -0400
In-Reply-To: <20141001211003.GA24820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Webb Scales <webbnh@hp.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 10/01/2014 11:10 PM, Christoph Hellwig wrote:
> On Wed, Oct 01, 2014 at 02:51:31PM -0400, Webb Scales wrote:
>> Hannes,
>>
>> In megasas_change_queue_type(), is it possible for sdev->queue_depth=
 to be
>> greater than 256?
>>
>> Unless I'm misunderstanding the SCSI code, we can request a
>> queue-depth/tag-map-size which is greater than 256, but, since the
>> scsi_cmnd::tag field is an unsigned char, depths greater than 256 ma=
y
>> overflow the field when high-numbered tags are used...do I have that=
 right?
>=20
> Yes, we really need to increase the size of the tag field.  SAM allow=
s
> a transport specific limit of up to 64 _bytes_ for it, although I don=
't
> know implementation that large.  Given that the block layer can gener=
ate
> up to 32-bit tags both for the old blk-tag.c code and the new
> blk-mq-tag.c version it would be good to use a u32 there.  Can you se=
nd
> me a patch?
>=20
Weeelll ...

I'm afraid it's not _that_ easy.
SCSI-II tagged queueing has some specific tag values:

#define SIMPLE_QUEUE_TAG    0x20
#define HEAD_OF_QUEUE_TAG   0x21
#define ORDERED_QUEUE_TAG   0x22

drivers/scsi/vmw_pvscsi.c:
	e->tag =3D SIMPLE_QUEUE_TAG;
	if (sdev->tagged_supported &&
	    (cmd->tag =3D=3D HEAD_OF_QUEUE_TAG ||
	     cmd->tag =3D=3D ORDERED_QUEUE_TAG))
		e->tag =3D cmd->tag;

So we cannot translate between them easily.
Unless we move the SCSI-II values to negative and use the positive
values for 'real' tag numbers.

The recommendation here is to use 'scmd->request->tag' whenever
you want to get to the tag number, and 'scmd->tag' if you have to
play around with SCSI-II TCQ.
But if not I would strongly advise to leave 'scmd->tag' alone.

Speaking of which:
We have

drivers/scsi/scsi_lib.c:scsi_get_cmd_from_request()

        /* pull a tag out of the request if we have one */
        cmd->tag =3D req->tag;
        cmd->request =3D req;

What would happen if the block layer decides to use tag number 0x22?
Wouldn't that completely bugger up the TCQ logic?
Why do we need to pull the request tag into the scmd tag, anyway?
I'd rather leave that alone, so that the SCSI midlayer can insert
whatever magic it'll decide to do here ...

James?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
