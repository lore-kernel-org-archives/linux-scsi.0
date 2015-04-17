From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 01/43] hpsa: add masked physical devices into h->dev[]
 array
Date: Fri, 17 Apr 2015 14:52:22 +0200
Message-ID: <55310206.8000707@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134645.30238.22953.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbbDQMwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 08:52:25 -0400
In-Reply-To: <20150416134645.30238.22953.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:46 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> Cache the ioaccel handle so that when we need to abort commands sent
> down the ioaccel2 path, we can look up the LUN ID in h->dev[] instead=
 of
> having to do I/O to the controller.
>=20
> Add a field to elements in h->dev[] to keep track of how the device i=
s exposed
> to the SCSI mid layer: Not at all, without an upper level driver
> (no_uld_attach) or normally exposed.
>=20
> Since masked physical devices are now present in h->dev[] array
> it would be perfectly possible to do
>=20
> 	echo scsi add-single-device 2 2 0 0 > /proc/scsi/scsi
>=20
> and bring them online.  This was previously not allowed for masked
> physical devices.
>=20
> Ensure that the mapping of physical disks to logical drives gets upda=
ted in a
> consistent way when a RAID migration occurs and is not touched until =
updates
> to it are complete.
>=20
> now instead of doing CISS_REPORT_PHYSICAL to get the LUNID for
> the physical disk in hpsa_get_pdisk_of_ioaccel2(), just get
> it out of h->dev[] where we already have it cached.
>=20
> do not touch phys_disk[] for ioaccel enabled logical drives during re=
scan
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
