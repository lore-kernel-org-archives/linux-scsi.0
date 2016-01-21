From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi: Fix RCU handling for VPD pages
Date: Thu, 21 Jan 2016 08:40:17 +0100
Message-ID: <56A08B61.6070908@suse.de>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
 <20160121063528.3803.92532.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbcAUHkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2016 02:40:20 -0500
In-Reply-To: <20160121063528.3803.92532.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Duyck <aduyck@mirantis.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de

On 01/21/2016 07:35 AM, Alexander Duyck wrote:
> This patch is meant to fix the RCU handling for VPD pages.  The origi=
nal
> code had a number of issues including the fact that the local variabl=
es
> were being declared as __rcu, the RCU variable being directly accesse=
d
> outside of the RCU locked region, and the fact that length was not
> associated with the data so it would be possible to get a mix and mat=
ch of
> the length for one VPD page with the data from another.
>=20
> Fixes: 09e2b0b14690 ("scsi: rescan VPD attributes")
> Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
> ---
>  drivers/scsi/scsi.c        |   52 +++++++++++++++++++++++-----------=
----------
>  drivers/scsi/scsi_lib.c    |   12 +++++-----
>  drivers/scsi/scsi_sysfs.c  |   14 +++++++-----
>  include/scsi/scsi_device.h |   14 ++++++++----
>  4 files changed, 50 insertions(+), 42 deletions(-)
>=20
Thanks for fixing this up. I didn't really like the two distinct
variables for vpd buffer and length, too, but hadn't thought of
using a struct for here.

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
