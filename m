From: Hannes Reinecke <hare@suse.de>
Subject: Re: blk-merge: BIO front merge size check for chunked devices
Date: Tue, 2 Feb 2016 08:46:05 +0100
Message-ID: <56B05EBD.8030308@suse.de>
References: <7A8F97E9-36F4-43C8-9646-895B818C632A@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbcBBHqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 02:46:08 -0500
In-Reply-To: <7A8F97E9-36F4-43C8-9646-895B818C632A@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 02/02/2016 08:06 AM, Damien Le Moal wrote:
>=20
> Hello,
>=20
> In ll_front_merge_fn, the request size result of the eventual front
> merge of a BIO with a request is checked against the maximum
> size allowed for the request using blk_rq_get_max_sectors. This
> function will also check that the merge result will not span block
> chunks for chunked block devices using the function blk_max_size_offs=
et.
>=20
> However, blk_rq_get_max_sectors always calls blk_max_size_offset usin=
g
> the request sector position, which in the case of a front merge is no=
t
> the position at which the merged request would be issued: the sector
> position to use must be that of the BIO, and not that of the request.
>=20
> This problem can trigger a =E2=80=9Cboundary violation error=E2=80=9D=
 for write
> requests on ZAC/ZBC host-managed SMR disks as the last write BIO
> of a zone (a chunk) can end up being front-merged with the first
> request of the following zone (chunk).
>=20
> The attached patch against linux-4.5-rc2 fixes this problem by adding
> an offset argument to the function blk_rq_get_max_sectors.
>=20

Reviewed-by: Hannes Reinecke <hare@suse.com>

I can easily respin this as a proper patch if required.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
