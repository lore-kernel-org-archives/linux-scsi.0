From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 0/9] New EH command timeout handler
Date: Mon, 02 Sep 2013 11:59:52 +0200
Message-ID: <52246198.6070306@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <20130902082728.GA15554@infradead.org> <52245235.9020408@suse.de> <20130902093129.GA17201@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab3IBJ74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 05:59:56 -0400
In-Reply-To: <20130902093129.GA17201@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On 09/02/2013 11:31 AM, Christoph Hellwig wrote:
> On Mon, Sep 02, 2013 at 10:54:13AM +0200, Hannes Reinecke wrote:
>> I don't mind. Having talked to the various SCSI folks everyone
>> agreed that calling abort asynchronously shouldn't do any harm.
>> At least as far as the SCSI spec goes.
>>
>> As for documentation: I didn't document it it currently as with my
>> implementation it's pretty much an optional thing.
>> But if we were to enable it globally it surely should be documented.
>>
>> So if there is a consensus I surely can enable it globally and
>> update the documentation.
>=20
> I would defintively love enabling it globally.  As a fallback we shou=
ld
> probably keep the old code for a while and prepare a way to disable
> the async code by a flag in the host template.  If no reason to enabl=
e
> it shows up after a year ore two we can remove the old code entirely.
>=20
> I.e change the tail of scsi_times_out into something like:
>=20
>=20
> 	if (rtn =3D=3D BLK_EH_NOT_HANDLED && !shost->hostt->no_async_abort) =
{
> 		if (scsi_abort_command(scmd))
> 			return BLK_EH_NOT_HANDLED;
> 	}
>=20
> 	scmd->result |=3D DID_TIME_OUT << 16;
> 	...
>=20
> That way we don't even need the new BLK_EH_SCHEDULED return value and
> have all the handling in scsi_error.c
>=20
Right. Will be doing it.

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
