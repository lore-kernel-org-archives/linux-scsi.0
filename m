From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Tue, 22 Jul 2008 09:02:41 +0200
Message-ID: <48858611.8020401@suse.de>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:33969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYGVHCp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jul 2008 03:02:45 -0400
In-Reply-To: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Tomo,

=46UJITA Tomonori wrote:
> This is a SCSI driver for HP (Compaq) Smart Array 5xxx controllers.
>=20
YES! Finally!

> SCSI people can skip the following two paragraphs.
>=20
> Currently, a driver for HP (Compaq) Smart Array 5xxx controllers is
> implemented as a block device driver, block/cciss.c (aka, cciss). But
> the controller interface is SCSI-3 compatible. The specification says=
,
> "A controller that supports CISS is considered to be a SCSI storage
> array controller". A scsi driver for the controllers was discussed
> several times.
>=20
> I think that a SCSI cciss driver can be much simpler (and
> maintainable) than the block cciss driver (the majority of the code
> forging SCSI command can go away, we have the proper sysfs entries fo=
r
> free, we can handle scsi tape drives easily etc). It would be helpful
> for distributions too since they don't need stuff specific to cciss
> (such as udev rules).
>=20
Yes.

>=20
> There isn't any easy migration path for users. So I think that we nee=
d
> to keep the block and scsi drivers for cciss for some time (say two
> years).
>=20
> My scsi driver is still in an early stage (I tried to keep the change=
s
> minimum). I can detect logical units, mount a file system, do lots of
> I/Os, however, there are lots of TODOs in the management features.
>=20
> If I can get an ACK from HP about the long-term migration of cciss to
> SCSI, I'm happy to keep working on the SCSI cciss driver and maintain
> it until HP takes over the driver.
>=20
=46irst of all, thanks, Tomo, for doing this.
It's been on my to-do list for about as long as I started looking on
the cciss code. However, some thoughts:

- Having cciss using the SCSI infrastructure is indeed far more logical=
=2E
  Although it looks as if it doesn't support the SCSI spec in full
  (ie no conformity claimed in the INQUIRY data) it certainly implement=
s
  quite a large subset.

- The error handling in the SCSI infrastructure is far better structure=
d
  as that one in the existing cciss driver, so the SCSI driver would
  benefit from this.

- Nevertheless, the cciss driver and the corresponding sysfs / device n=
ode
  layout has become the de-facto standard over the years and it will be
  _hard_ to change that.

- However, given that the sysfs information from the cciss driver is qu=
ite
  rudimentary I doubt if anyone will indeed notice if the _internal_ dr=
iver
  is a SCSI or a block level driver, as long as the _external_ interfac=
e
  (ioctl, device-node layout etc) stays the same.

Having said that I think this is the direction it should take:

- Split the existing cciss driver in two parts, one part for the
  block-level interface and one for the lower-level device handling bit=
s.
- Redo the patch based on that, so that existing code can be shared
  (and fixes there would be included in both drivers).
- Add some hooks/safeguards so that only _one_ interface driver can
  be loaded.

This way we would be able keep the existing functionality and allow
users to play around with the new driver.
Long-term we can start moving the driver itself to SCSI, and keeping
the existing cciss block interface only as a wrapper which adjusts
the major:minor numbers; the device-node layout can be handled by udev.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
