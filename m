From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] [SCSI] dpt_i2o: use proper pci driver
Date: Thu, 18 Feb 2016 09:19:30 +0100
Message-ID: <20160218081930.GM18134@c203.arch.suse.de>
References: <1455711614-5185-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160217142732.6dcad24c@lxorguk.ukuu.org.uk>
 <56C496AB.2070200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424759AbcBRITe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 03:19:34 -0500
Content-Disposition: inline
In-Reply-To: <56C496AB.2070200@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Feb 17, 2016 at 09:20:03PM +0530, Sudip Mukherjee wrote:
> On Wednesday 17 February 2016 07:57 PM, One Thousand Gnomes wrote:
> >On Wed, 17 Feb 2016 17:50:14 +0530
> >Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >
> >>This is a pci device but was not done in the usual way a pci driver=
 is
> >>done. Convert the driver into a proper pci driver.
> >
> >This looks completely wrong. Please read the I2O 1.5 specification
> >document before playing with that code. You can't simply convert it =
to a
> >standard PCI driver as all the IOPs are supposed to be detected and =
then
> >the correct initialization sequence executed across the set of IOPs.=
 IOPs
> >are allowed to talk to one another and the system table binds it all
> >together.
>=20
> Yes, thanks for letting me know about the spec. It is saying
> "The host locates each IOP, adds it
> to the system configuration table, and initializes the IOP=E2=80=99s =
outbound
> message queue. The host then
> provides each IOP with a list of all IOPs and the physical location o=
f their
> inbound message queue."
>=20
> >
> >If you do hot plug then you need to follow the specification and do
> >all the extra notifications. Unless you've got multiple FC909/FC920
> >fibechannel cards or similar to test with I would just leave this we=
ll
> >alone.
>=20
> point noted.
>=20
> >Your original simple patch is *MUCH* safer in this specific case.
>=20
> The original patch is already having NACK from Johannes. So i better =
leave
> this code here.

Nah, wasn't a hard NACK. I'm OK with the original code, just was reluct=
ant to
the #ifdefs. I agree I didn't know the I2O specifics and thought a "nor=
mal"
PCI driver fitting nicely in the driver model would be the way to go.

Please resend your v1 with my Reviewed-by

>=20
> regards
> sudip

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
