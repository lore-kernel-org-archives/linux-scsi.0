From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 10/25] hpsa: correct check for non-disk devices
Date: Fri, 30 Oct 2015 09:01:01 +0100
Message-ID: <563323BD.4090904@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220530.5323.72852.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633AbbJ3IBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:01:03 -0400
In-Reply-To: <20151028220530.5323.72852.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:05 PM, Don Brace wrote:
> The driver is using two MACROs which seemingly are looking in
> the wrong location for the device_flags returned from
> CISS_REPORT_PHYS. Both MACROs, NON_DISK_PHYS_DEV and
> PHYS_IOACCEL, are using the pointer returned from figure_lunaddrbytes
> which is the address of the LUN.lunid element in
> the extended CISS_REPORT_PHYS.  But the MACROS are using offsets
> beyond the range of the element (offset 17 of an 8 byte element).
>=20
> These MACROs actually are looking at the correct location but
> they fail static checker analysis. It also will not work
> if any new elements are added to the extended LUN structure.
>=20
> Change the code to use the structure elements directly
> since this MACRO is only used in one location.
>=20
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |   28 +++++++++++++++-------------
>  drivers/scsi/hpsa_cmd.h |    2 --
>  2 files changed, 15 insertions(+), 15 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
