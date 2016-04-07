From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 4/4] dm mpath: eliminate use of spinlock in IO
 fast-paths
Date: Thu, 7 Apr 2016 17:03:50 +0200
Message-ID: <570676D6.6090401@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-5-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbcDGPDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 11:03:52 -0400
In-Reply-To: <1459454666-76428-5-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, sagig@dev.mellanox.co.il

On 03/31/2016 10:04 PM, Mike Snitzer wrote:
> The primary motivation of this commit is to improve the scalability o=
f
> DM multipath on large NUMA systems where m->lock spinlock contention =
has
> been proven to be a serious bottleneck on really fast storage.
>=20
> The ability to atomically read a pointer, using lockless_dereference(=
),
> is leveraged in this commit.  But all pointer writes are still protec=
ted
> by the m->lock spinlock (which is fine since these all now occur in t=
he
> slow-path).
>=20
> The following functions no longer require the m->lock spinlock in the=
ir
> fast-path: multipath_busy(), __multipath_map(), and do_end_io()
>=20
> And choose_pgpath() is modified to _not_ update m->current_pgpath unl=
ess
> it also switches the path-group.  This is done to avoid needing to ta=
ke
> the m->lock everytime __multipath_map() calls choose_pgpath().
> But m->current_pgpath will be reset if it is failed via fail_path().
>=20
> Suggested-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 170 +++++++++++++++++++++++++++-------------=
----------
>  1 file changed, 93 insertions(+), 77 deletions(-)
>=20
I really like this :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Hannes Reinecke <hare@suse.com>

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
