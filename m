From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 05 Aug 2010 16:52:15 +0200
Message-ID: <4C5AD01F.2060602@suse.de>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45188 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126Ab0HEOwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 10:52:20 -0400
In-Reply-To: <20100805133225.GF29846@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@>

Chris Mason wrote:
> On Thu, Aug 05, 2010 at 05:11:56PM +0400, Vladislav Bolkhovitin wrote=
:
>> Chris Mason, on 08/02/2010 09:39 PM wrote:
>>> I regret putting the ordering into the original barrier code...it
>>> definitely did help reiserfs back in the day but it stinks of magic=
 and
>>> voodoo.
>> But if the ordering isn't in the common (block) code, how to
>> implement the "hardware offload" for ordering, i.e. ORDERED
>> commands, in an acceptable way?
>>
>> I believe, the decision was right, but the flags and magic requests
>> based interface (and, hence, implementation) was wrong. That's it
>> which stinks of magic and voodoo.
>=20
> The interface definitely has flaws.  We didn't expand it because Jame=
s
> popped up with a long list of error handling problems.  Basically how
> do the hardware and the kernel deal with a failed request at the star=
t
> of the chain.  Somehow the easy way of failing them all turned out to=
 be
> extremely difficult.
>=20
> Even if that part had been refined, I think trusting the ordering dow=
n
> to the lower layers was a doomed idea.  The list of ways it could go
> wrong is much much longer (and harder to debug) than the list of
> benefits.
>=20
> With all of that said, I did go ahead and benchmark real ordered tags
> extensively on a scsi drive in the initial implementation.  There was
> very little performance difference.
>=20
Care to dig it up?
I'd wanted to give it a try, and if someone already did some work in
that area it'll make things easier here.

I still think that implementing ordered tags is the correct way of
doing things, implementation details notwithstanding.

It looks better conceptually than using FUA, and would be easier
from the request-queue side of things.
(Or course, as the entire logic is pushed down to the SCSI layer :-)

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
