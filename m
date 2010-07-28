From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:11:08 +0200
Message-ID: <4C4FF42C.1050701@suse.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41618 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0G1JLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 05:11:11 -0400
In-Reply-To: <20100728090025.GA9252@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig wrote:
> On Wed, Jul 28, 2010 at 10:58:30AM +0200, Tejun Heo wrote:
>> I see.  It probably would be good to have ordering requirements
>> carried in the bio / request, so that filesystems can mix and match
>> barriers of different strengths as necesasry.  As you seem to be
>> already working on it, are you interested in pursuing that direction=
?
>=20
> I've been working on that for a while, but it got a lot more urgent
> as there's been an application hit particularly hard by the barrier
> semantics on cache less devices and people started getting angry
> about it.  That's why fixing this for cache less devices has become
> a higher priority than solving the big picture.
>=20
My idea here is to use the 'META' request tag to emulate FUA.
=46rom what I've seen, the META request tag is only ever used on gfs2,
and even that is using is for tagging journal requests on write.

Once you've tagged all bios/requests with correctly it trivial to
set the FUA bit.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
