From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY
 framework
Date: Thu, 27 Feb 2014 15:34:27 -0600
Message-ID: <20140227213427.GG5375@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
 <20140227190102.GB4862@saruman.home>
 <CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
 <20140227205039.GE5375@saruman.home>
 <CAPw-ZT=7cu1NoxrBL48RUJV04ofrnNkF=p=23VFfu8ZZWmkQWQ@mail.gmail.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oOB74oR0WcNeq9Zb"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZT=7cu1NoxrBL48RUJV04ofrnNkF=p=23VFfu8ZZWmkQWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Cc: balbi-l0cyMroinI0@public.gmane.org, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--oOB74oR0WcNeq9Zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 01:09:57PM -0800, Loc Ho wrote:
> >> >> This patch adds function set_speed to the generic PHY framework ope=
ration
> >> >> structure. This function can be called to instruct the PHY underlyi=
ng layer
> >> >> at specified lane to configure for specified speed in hertz.
> >> >
> >> > why ? looks like clk_set_rate() is your friend here. Can you be more
> >> > descriptive of the use case ? When will this be used ?
> >> >
> >>
> >> The phy_set_speed is used to configure the operation speed of the PHY
> >> at run-time. The clock interface in general is used to configure the
> >> clock input to the IP. I don't believe they are the same thing. Maybe
> >> it will be clear in my response to your second email
> >
> > The problem with this is that you end up adding SATA-specific details to
> > something which is supposed to be generic.
>=20
> Setting the operation speed is pretty generic from an interface point
> of view. An generic multi-purpose PHY can support multiple speed. If

no it's not. Specially when you consider that your "speed" argument can
be just about anything and depending on the underlying bus, it *will* be
treated differently. Note that e.g. in OMAP devices the exact *same* PHY
IP is used for PCIe, SATA and USB... now, let's assume for the sake of
argument that we were to implement ->set_speed() in that environment,
how do you plan to do that ? a 6MHz arguments isn't valid from USB stand
point and could mean different things in PCIe or SATA.

> the upper layer wish to operate at an specified speed (say for testing
> purpose and etc), it can be allowed.

anything for testing purposes, should be limited to test scenarios.

> > After negoatiation, don't you
> > get any interrupt from your PHY indicating that link speed negotiation
> > is done ? Or is that IRQ only on AHCI IP ?
>=20
> There is NO interrupt from the PHY. The IRQ is assoicated with the
> AHCI IP. With SATA host flow, it starts off with an COMRESET to start
> the link negotiation. At that point, it will poll for completion.
>=20
> Any other concerns?

hey, calm down... just trying to prevent us from applying something
which isn't truly generic and I don't think "->set_speed" is generic
enough. The semantics of the "speed" argument won't be valid for all use
cases.

I can already see people using that to pass
USB_SPEED_{LOW,FULL,HIGH,SUPER}, instead of actual speed numbers. We wil
end up with a mess to handle from a PHY driver, specially in cases such
as OMAP where, as mentioned above, the same IP is used for SATA, PCIe
and USB3.

--=20
balbi

--oOB74oR0WcNeq9Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD69jAAoJEIaOsuA1yqREjRQP/3zOaoRV1q6LjlvOuuYRq012
4huAXl/RXNqGAigKfSYT9FcccrLkHXReG4mhgX3lXE0TQYEIi6MmOSguFJsOXpFr
Txz2wr4fuyOk4bGEx3jXySaUmhwC09FnY8vX5I1kkEMtS6+4tqUWv6D7s/xEJT5d
nugCqzX7uvp6C2hcUPr2dNJ5tCy4vJhCL/DgagZo+3QXr1whskM5iC/qe7mTo80U
omaVBuK7Xut3URwa83xUeIPTI1k8lffMUSbfnA3rBfdVwH8g+u+z1IHXGGKPCXyL
xy5rTSHVTmQtZG/F+Aa+Xsu7ygJioQE2xQmAI0ouz4nEpUeNjtu+DxLKmAGosjGI
no0TUJQJ1GGqiCvI+JAXRDcUEIg5yUu3NHMmXmzfIBs6Zmm1Ky1k/CMAOkW4PEEt
Y85ecf3t27a+CGZQaUUQuoJlEh85rgmNdT0T2kbE72+ivgyRjiygEypqoalyPn2R
S5KXz0wmkKNidSgPWtJOvBqBLu3QYLD+bk49mfaTA9jhhAQJvyX6BN/p67rG2CjH
EzoH11o4vUST7njl6S7PXhZFh1tNV9mSOj1VcXq8xvkaM4R2KdeaSflfRWQJJnhH
HMdu6UgPNYF8bbhX0hBq2+uSCSgS2DYHEYMCYQCwj3HG+LFLNPrl4Q1gXR77O1rl
t7CSsEh87kUliJljAuFD
=ztsC
-----END PGP SIGNATURE-----

--oOB74oR0WcNeq9Zb--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
