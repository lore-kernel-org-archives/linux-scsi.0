From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question: request tag usage
Date: Fri, 26 Sep 2014 10:20:43 +0200
Message-ID: <542521DB.1020605@suse.de>
References: <542507C9.2060901@suse.de> <20140926080308.GA21137@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaIZIUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 04:20:45 -0400
In-Reply-To: <20140926080308.GA21137@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <elliott@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 09/26/2014 10:03 AM, Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 08:29:29AM +0200, Hannes Reinecke wrote:
>> Hi Christoph,
>>
>> as discussed it would make sense to use the request->tag in eg
>> scmd_printk() to identify the command.
>> Which I duly did, only to figure out that the tag is always '-1', ie
>> tagging is not in use.
>> (Which is okay from the SCSI side, seeing the TCQ is basically a
>> SCSI parallel thing).
>=20
> tag are still a live part of SAM for every transport, they've only
> been renamed to "command identifier" in SAM-4 to confuse everyone.
>=20
>> Looking closer I found plenty of code for handling tags in the block
>> layer (and the blk-mq stuff, of course), but virtually none of the
>> non-SPI driver seems to be using them.
>=20
> A quick grep for scsi_activate_tcq disagrees with you.
>=20
Yeah, I've noticed after I've written the mail.
However, main point still stands: using 'tag' to identify commands
is pointless if not all of the LLDDs use tagging ...

>> Which makes the original idea a bit pointless, seeing that we need
>> to identify the command _always_, and not just if the host happens
>> to support tagging.
>>
>> Which leads me to some questions:
>> - Is the stuff in blk-mq supposed to work as a superset of SCSI TCQ?
>=20
> Yes.
>=20
>> - If so, should any HBAs with a queue depth > 1 (which does not
>>   support TCQ) set the tag of a command?
>>   (that's what I've initially thought would happen ...)
>> - If not (and the ->tag field is basically unused), can't we
>>   have the HBA to fill in a value here?
>=20
> blk-mq will always provide, and does rely on a valid request->tag.
> A LLDD can still use it's own internal tagging or mess with scmd->tag=
,
> although in general it should benefit from using the block layer
> tagging.
>=20
I know. But I was asking about non-mq LLDDs.

>> Which apparently was too much to hope for ...
>=20
> I guess for now we'll need to stay with the command pointer address.
> We can revisit this once the old request layer is gone.
>=20
Too bad. The tags would have provided a really nice concise way
of identifying the command...

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
