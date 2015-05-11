From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Mon, 11 May 2015 15:59:34 +0200
Message-ID: <5550B5C6.9010303@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-9-git-send-email-hare@suse.de> <20150511065523.GG30516@lst.de> <55507D74.1070908@suse.de> <20150511135026.GB7795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbbEKN7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 09:59:36 -0400
In-Reply-To: <20150511135026.GB7795@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 05/11/2015 03:50 PM, Christoph Hellwig wrote:
> On Mon, May 11, 2015 at 11:59:16AM +0200, Hannes Reinecke wrote:
>> This is just an intermediate step, before the entire thing moves off
>> to a workqueue and becomes asynchronous again.
>> It's not meant to be as a standalone patch; I've just split it off
>> for easier review.
>=20
> It actually made the review a bit harder.  Also I don't really undert=
and
> what the benfit of running a synchronous STPG in a workqueue is over
> running it asynchronously.
>=20
Because STPG might fail, at which point we need to re-run RTPG to
figure out the current status.
But that might clash with a scheduled RTPG from another task.
_And_ issuing RTPG while STPG is active is pointless, too, as
the information is pretty much guaranteed to be incorrect.

Hence the use of a workqueue to serialize RTPG and STPG against each
other.

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
