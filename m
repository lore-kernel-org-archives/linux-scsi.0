From: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sun, 17 Feb 2008 13:55:20 +0300
Message-ID: <20080217105520.GA4628@atlas.home>
References: <Pine.LNX.4.44L0.0802161207160.3828-100000@iolanthe.rowland.org> <47B756B5.7070901@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <47B756B5.7070901-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2008 at 04:33:41PM -0500, Andrew Buehler wrote:
> The associated dmesg (obtained yesterday from booting with the
> Flash drive connected) is attached.

This dmesg shows that ACPI is not enabled in your kernel config - most
likely this is the problem.  Try to enable it:

 1) In the "Power management options" submenu enable the "Power
    Management support" option (CONFIG_PM) - if this option is
    disabled, you will not see the option to enable ACPI below.

 2) In the same submenu enable the "ACPI (Advanced Configuration and
    Power Interface) Support" option (CONFIG_ACPI).

Without ACPI support the kernel can use legacy interrupt routing
tables from BIOS, but on new systems these tables are often broken due
to lack of testing (because all modern operating systems use ACPI
instead of these legacy tables).

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHuBKYW82GfkQfsqIRAn7lAKCLI1Hqzb3ZLL6MCaRjfOAIJSknRwCdGUxG
3FPtUeL7NNA+fI9UNNrp0jA=
=CI1M
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
