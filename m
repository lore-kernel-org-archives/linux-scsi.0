From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/17] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 May 2015 11:10:43 +0200
Message-ID: <55531513.5080003@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-15-git-send-email-hare@suse.de> <20150511134914.GA7795@lst.de> <5550B5B4.4070605@suse.de> <20150512081659.GB27168@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbbEMJKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 05:10:45 -0400
In-Reply-To: <20150512081659.GB27168@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/12/2015 10:16 AM, Christoph Hellwig wrote:
> So how about the following idea for GTPG and STPG handling:
>=20
>  - we keep a single thread workqueue, but per target group instead
>    of global to avoid concurrency issues hitting us too badly, after
>    all workqueues are cheap these days.

Okay.

>  - GTPG keeps the per-group work_item, but instead of the separate
>    lsit for STPG we just add the work item to the alua_queue_data
>    structure, which at the point might also get a new name relecting
>    the use a bit better.  STPG remains synchronous.
>=20
Well, I don't think that'll work.
qdata is per sdev, and STPG is per port group.

While it's true that we need to run STPG once a qdata item
has been created, it's not necessarily true that we need to
run STPG for _every_ qdata item; if we have more than one
path per group we need to run STPG only for one of them.
(Which is why there is a qdata structure in the first place.)

What I can do, though, is to split off stpg and rtpg in two
different routines, each with its own workqueue item.
That way the actual implementation becomes easier to follow.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
