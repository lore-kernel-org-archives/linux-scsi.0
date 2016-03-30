From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] sd: Fix excessive capacity printing on devices with
 blocks bigger than 512 bytes
Date: Wed, 30 Mar 2016 10:06:25 +0200
Message-ID: <56FB8901.2040600@suse.de>
References: <1458656217.17965.48.camel@localhost.localdomain>
 <1459214336-12668-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbcC3IG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 04:06:27 -0400
In-Reply-To: <1459214336-12668-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 03/29/2016 03:18 AM, Martin K. Petersen wrote:
> During revalidate we check whether device capacity has changed before=
 we
> decide whether to output disk information or not.
>=20
> The check for old capacity failed to take into account that we scaled
> sdkp->capacity based on the reported logical block size. And therefor=
e
> the capacity test would always fail for devices with sectors bigger t=
han
> 512 bytes and we would print several copies of the same discovery
> information.
>=20
> Avoid scaling sdkp->capacity and instead adjust the value on the fly
> when setting the block device capacity and generating fake C/H/S
> geometry.
>=20
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 28 ++++++++--------------------
>  drivers/scsi/sd.h |  7 ++++++-
>  2 files changed, 14 insertions(+), 21 deletions(-)
>=20
After some testing I do prefer this version over mine.
Especially as I need the exported version of logical_to_sectors for
my SMR patchset :-)

So:

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
