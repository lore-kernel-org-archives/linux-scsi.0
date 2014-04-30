From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: 3.2.57 regression: isci driver broken: Unable to reset I T
 nexus?
Date: Wed, 30 Apr 2014 13:30:50 +0100
Message-ID: <1398861050.11833.5.camel@deadeye.wl.decadent.org.uk>
References: <201404281303.24977.linux@rainbow-software.org>
	 <57283945f737477b90e5ae31b9403799@fmsmsx156.amr.corp.intel.com>
	 <1398703903.97992.10.camel@djiang5-desk1.amr.corp.intel.com>
	 <201404281922.19399.linux@rainbow-software.org>
	 <CAPcyv4hzaDq61aM2eYayKbW1FX9KC-X32rvHXqYqePGXgo2xQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lxJRy3YvC3j6Ydqci9cU"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hzaDq61aM2eYayKbW1FX9KC-X32rvHXqYqePGXgo2xQQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-lxJRy3YvC3j6Ydqci9cU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm adding this revert to 3.2.58, taking your 'drop commit 584ec1226519'
as an ack.

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 30 Apr 2014 13:22:22 +0100
Subject: Revert "isci: fix reset timeout handling"

This reverts commit 584ec12265192bf49dfa270d517380f6723a6956, which
was commit ddfadd7736b677de2d4ca2cd5b4b655368c85a7a upstream.  It
causes boot failure on 3.2 although no such problem occurs upstream.

Reported-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -610,6 +610,13 @@ static void sci_apc_agent_link_up(struct
 		sci_apc_agent_configure_ports(ihost, port_agent, iphy, true);
 	} else {
 		/* the phy is already the part of the port */
+		u32 port_state =3D iport->sm.current_state_id;
+
+		/* if the PORT'S state is resetting then the link up is from
+		 * port hard reset in this case, we need to tell the port
+		 * that link up is recieved
+		 */
+		BUG_ON(port_state !=3D SCI_PORT_RESETTING);
 		port_agent->phy_ready_mask |=3D 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1390,7 +1390,7 @@ int isci_task_I_T_nexus_reset(struct dom
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
=20
 	if (!idev || !test_bit(IDEV_EH, &idev->flags)) {
-		ret =3D -ENODEV;
+		ret =3D TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}
=20

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-lxJRy3YvC3j6Ydqci9cU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU2DtBOe/yOyVhhEJAQpatBAAvHxq9tx94qtTRtKLloBy7PAc4nWqzz6p
Ce0Lw6C3P/uswayHvMlc2mDlFOdP8h0unQk+KxXzlp4EDCI3j939lIFDo5VKJmQw
SbgJFyjQXVqloFUiui9+x7NrWgFZP3odtGJ76bIPcerupODVQkcazyD48Ox/TsvG
MZuKNUW7WzkTYzPD80WLh+FaVnx1vs3mMHrvnOHi9zQNqd/hs1IFMHIZenPU5ZC4
iqYLzCAaVXNXt6VSR9aNVl84Qyz35LMFSLiJ8bDDqdpb1dQpvrSPwY4El7voUFtk
3KXtKblnyq8oeTeRAURa/HVA2Uh+ZQ4tPBQjYB+6MKxr4Ot8KxCMZhb6ZQlZ7mHn
s/NqyjQdXVohnJewL23bUSSLWZKrIcplzMtcv53uzpWHs/Q88ZHYqmFxBheNv/T1
bFpAh2fw4eALjsLgL3Ro4dQluc4Cwd8W0bPXKSSm3cuvdXvVbI1PKcgv7yqVMDIg
wpWJ3hKGuxEhINi/FGND/u9rL1Eb+/Pa2HoieXfjNkb3TZ5ywWdnKcAPafstjLKj
qRBOJC9mD77mEgQQ/l3bHNK69HSSroezXIfFkbG8w4RQNbPW/vxId1e8dLAgEFqp
qq1KAIdeWIBbob0sheVDPp/fscRIb6znN45K1Nmd99Wn0ib/olvoY5FQmbFK7kkW
YpYmIaoWtUU=
=K3ZA
-----END PGP SIGNATURE-----

--=-lxJRy3YvC3j6Ydqci9cU--
