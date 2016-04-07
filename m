From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Thu, 7 Apr 2016 16:58:31 +0200
Message-ID: <57067597.4080103@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbcDGO6e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 10:58:34 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, sagig@dev.mellanox.co.il

On 03/31/2016 10:04 PM, Mike Snitzer wrote:
> I developed these changes some weeks ago but have since focused on
> regression and performance testing on larger NUMA systems.
>=20
> For regression testing I've been using mptest:
> https://github.com/snitm/mptest
>=20
> For performance testing I've been using a null_blk device (with
> various configuration permutations, e.g. pinning memory to a
> particular NUMA node, and varied number of submit_queues).
>=20
> By eliminating multipath's heavy use of the m->lock spinlock in the
> fast IO paths serious performance improvements are realized.
>=20
[ .. ]
> Jeff Moyer has been helping review these changes (and has graciously
> labored over _really_ understanding all the concurrency at play in DM
> mpath) -- his review isn't yet complete but I wanted to get this
> patchset out now to raise awareness about how I think DM multipath
> will be changing (for inclussion during the Linux 4.7 merge window).
>=20
> Mike Snitzer (4):
>   dm mpath: switch to using bitops for state flags
>   dm mpath: use atomic_t for counting members of 'struct multipath'
>   dm mpath: move trigger_event member to the end of 'struct multipath=
'
>   dm mpath: eliminate use of spinlock in IO fast-paths
>=20
>  drivers/md/dm-mpath.c | 351 ++++++++++++++++++++++++++++------------=
----------
>  1 file changed, 195 insertions(+), 156 deletions(-)
>=20
=46inally got around to test this.
The performance is comparable to the previous (RCU-ified) patchset,
however, this one is the far superious approach.
In fact, the first two are pretty much identical to what I've
already had, but I've shirked at modifying the path selectors.
So well done here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
