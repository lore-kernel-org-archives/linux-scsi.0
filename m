From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: UASP: updates and merges
Date: Wed, 2 Mar 2011 11:05:05 -0800 (PST)
Message-ID: <147799.16314.qm@web31802.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I've merged the latest master (dd9c154). The UASP driver saw the follow=
ing update:

    [USB] UASP: Unlock device after reset; EP updates
   =20
    * Unlock the device after reset.
   =20
    * Initialize urb->ep directly. struct
      uasp_tport_info already records the struct
      usb_host_endpoint which makes it easy to
      directly initialize urb->ep. This anticipates
      when drivers would have to initialize the ep in
      the urb directly as opposed to the USB core
      having to use pipes.
   =20
    * Use the UAS pipe macros throughout the code for
      endpoint indexes.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=3Dlinux-usb&m=3D129165511732388&w=3D2

    Luben


--- On Thu, 1/13/11, Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> Subject: UASP: updates and merges
> To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-u=
sb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Greg KH" <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
> Date: Thursday, January 13, 2011, 2:45 AM
> The UASP driver allows you to connect
> to UAS devices and use them
> as SCSI devices.
>=20
> I've merged latest master (f87813) and resolved a conflict
> in drivers/scsi/sd.c by adding back the truncation of the
> mode sense data.
>=20
> The UASP driver saw the following update:
>=20
> =A0 =A0 [USB] UASP: factor out GFP flags and make
> them GFP_ATOMIC
> =A0 =A0=20
> =A0 =A0 Factor out the GFP flags and make them
> atomic:
> =A0 =A0 1) The SCSI subsystem uses GFP_ATOMIC, e.g.
> before
> =A0 =A0 calling the host's slave_alloc callback (at
> the
> =A0 =A0 time of this commit).
> =A0 =A0 2) As we are a storage driver doing I/O, we
> should
> =A0 =A0 use the lowest denominator (highest
> priority)
> =A0 =A0 allocation, and of course we shouldn't sleep,
> thus
> =A0 =A0 use GFP_ATOMIC.
>=20
> The branch can be found here (off of master):
> https://github.com/ltuikov/linux-2.6
>=20
> Original posting of the UASP driver can be found here:
> http://marc.info/?l=3Dlinux-usb&m=3D129165511732388&w=3D2
>=20
> =A0=A0=A0Luben
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
