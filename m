From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Tue, 22 Mar 2016 08:14:48 +0100
Message-ID: <56F0F0E8.6060302@suse.de>
References: <1458563249-91200-1-git-send-email-hare@suse.de>
 <yq1a8lr5n2y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbcCVHOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2016 03:14:51 -0400
In-Reply-To: <yq1a8lr5n2y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/22/2016 02:16 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> in sd_read_capacity() the sdkp->capacity field changes its
> Hannes> meaning: after the call to read_capacity_XX() it carries the
> Hannes> _unscaled_ values, making the comparison between the original
> Hannes> value and the new value always false for drives with a sector
> Hannes> size !=3D 512.  So introduce a 'new_capacity' carrying the ne=
w,
> Hannes> scaled, capacity.
>=20
> I agree with Christoph.
>=20
> How about something like this instead?
>=20
I've coded it somewhat different, but this one works as well.
But please modify the description in sd.h, as with this patch
'sdkp->capacity' is the _unscaled_ value.
Might lead to confusion otherwise.

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5f2a84a..5ed7434 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -65,7 +65,7 @@ struct scsi_disk {
        struct device   dev;
        struct gendisk  *disk;
        atomic_t        openers;
-       sector_t        capacity;       /* size in 512-byte sectors */
+       sector_t        capacity;       /* size in logical sectors */
        u32             max_xfer_blocks;
        u32             opt_xfer_blocks;
        u32             max_ws_blocks;

(Apologies for the mangled patch)

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
