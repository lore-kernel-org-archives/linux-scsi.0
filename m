From: Hannes Reinecke <hare@suse.de>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 02 Nov 2011 13:44:24 +0100
Message-ID: <4EB13B28.6010704@suse.de>
References: <4E96E2FF.6070601@linux.vnet.ibm.com> <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com> <4E9BEB68.1050707@ce.jp.nec.com> <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com> <4E9D7FA8.9000000@ce.jp.nec.com> <20111018154542.GB3869@osiris.boeblingen.de.ibm.com> <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com> <20111031100557.GA2621@osiris.boeblingen.de.ibm.com> <1320057746.2964.1.camel@dabdike> <4EAE8A7E.8000504@ce.jp.nec.com> <20111031130004.GB4768@osiris.boeblingen.de.ibm.com> <4EB13972.30308@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1KBMo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2011 08:44:27 -0400
In-Reply-To: <4EB13972.30308@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Mike Snitzer <snitzer@redhat.com>, gmuelas@de.ibm.com

On 11/02/2011 01:37 PM, Jun'ichi Nomura wrote:
> On 10/31/11 22:00, Heiko Carstens wrote:
>> On Mon, Oct 31, 2011 at 08:46:06PM +0900, Jun'ichi Nomura wrote:
>>> Hm, dm_softirq_done is generic completion code of original
>>> request in dm-multipath.
>>> So oops here might be another manifestation of use-after-free.
>>>
>>> Do you always hit the oops at the same address?
>>
>> I think we saw this bug the first time. But before that the scsi
>> logging level was higher. Gonzalo is trying to recreate it with
>> the same (old) scsi logging level.
>> Afterwards we will try with barrier=3D0.
>>
>> Both on v3.0.7 btw.
>>
>>> Could you find corresponding source code line for
>>> the crashed address, dm_softirq_done+0x72/0x140,
>>> and which pointer was invalid?
>>
>> It crashes in the inlined function dm_done() when trying to
>> dereference tio (aka clone->end_io_data):
>>
>> static void dm_done(struct request *clone, int error, bool mapped)
>> {
>>          int r =3D error;
>>          struct dm_rq_target_io *tio =3D clone->end_io_data;
>>          dm_request_endio_fn rq_end_io =3D tio->ti->type->rq_end_io;
>
> Thank you. But, hmm. I have no idea about scenario.
>
> struct dm_rq_target_io is a container of clone request
> and clone->end_io_data points to its container.
>
>    struct dm_rq_target_io {
>          struct mapped_device *md;
>          struct dm_target *ti;
>          struct request *orig, clone;
>          int error;
>          union map_info info;
>    };
>
> If clone can be dereferenced, clone->end_io_data should be, too.
>
Well, actually it _always_ can be dereferenced.

At the very least we'd need to do an integrity check, ie
if the pointer 'clone->end_io_data' is indeed of the
required type.
More to the point, the end_io_data pointer could've been
assigned to something else; so even though the pointer is set
(which we don't check, either), it might not be pointing
to a 'struct dm_rq_target_io'.

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
