From: Arjan van de Ven <arjanv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Wed, 7 Jan 2004 21:51:21 +0100
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <20040107205121.GA19162@devserv.devel.redhat.com>
References: <C2CB6D8BA015124783C0EB9B33D24FFD047F90@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C2CB6D8BA015124783C0EB9B33D24FFD047F90-b070rUroPABnRV3uFxCcHmPGcypz5H/V@public.gmane.org>
Errors-To: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
List-Help: <mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJuMTnGGMi8c9@public.gmane.org>
List-Post: <mailto:linux-aacraid-devel-8PEkshWhKlo@public.gmane.org>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJhLjRD9WNpgrmSKB9SHqsyg@public.gmane.org>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJt/CJOUnrhF+9vnX9k1QryA@public.gmane.org>
List-Archive: <http://lists.us.dell.com/pipermail/linux-aacraid-devel/>
To: "Salyzyn, Mark" <mark_salyzyn-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
Cc: 'Xose Vazquez Perez' <xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>, "'linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org'" <linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org>, 'linux-scsi' <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Wed, Jan 07, 2004 at 03:12:44PM -0500, Salyzyn, Mark wrote:
> +#define aac_spin_lock_irq(host_lock)
> spin_lock_irq(&io_request_lock)
> +#define aac_spin_unlock_irqrestore(host_lock, cpu_flags)
> spin_unlock_irqrestore(&io_request_lock, cpu_flags)
> +#define aac_spin_unlock_irq(host_lock)
> spin_unlock_irq(&io_request_lock)
> =20
>=20
> ewwww
>=20
> mgs> In Adaptec's version of the code, this is part of a kernel versioning
> mgs> ifdef, to use the `host_lock' passed in, or the io_request_lock glob=
al
> mgs> Better here than at each locale. However, I think I chose the wrong
> mgs> side of the ifdef, doesn't 2.4.25-pre4 use host->host_lock?

there are other, cleaner ways to achieve this imo

> +        * bit addressing, and we have more than 32 bit addressing worth =
of
> +        * memory and if the controller supports 64 bit scatter gather
> elements.
> +        */
> +       if( (sizeof(dma_addr_t) > 4) && (num_physpages > (0xFFFFFFFFULL >>
> PAGE_SHIFT)) && (dev->adapter_info.options &
> +               dev->dac_support =3D 1;
>         }
>=20
> that looks broken, at least drivers should never need to check num_physpa=
ges
> etc etc
>=20
> mgs> If the system has less than 4G of memory, it is in the interest of
> mgs> performance to use the 32 bit variants of the adapter packets. Small=
er
> mgs> frames, and capable of a larger number of scatter-gather elements.

oh sure; imo the pci_set_dma_mask() function should check this, not the
driver.

> why on earth is that in a driver?????
>=20
> mgs> The management tools issue ioctls to query for the information. RAID
> mgs> drivers require management tool support.


sounds like a really really broken ioctl interface then. Is the source of
these tools public so that we can fix them ?

>=20
> +# define strlcpy(s1,s2,n) strncpy(s1,s2,n);s1[n-1]=3D'\0'
>=20
>=20
> this is very broken; consider
>=20
> if (foo)
>     bar(foo);
> else
>     strlcpy(foo,bar,3);
>=20
> mgs> this is `good enough' for the driver, s1 in the driver context is
> mgs> not a value of null.

ehm read again. My example was not of the foo=3D=3DNULL case but that your
define had 2 statements where the "else" will only apply to the first

> mgs> This is in here for compatibility reasons (should be in compat.h),
> mgs> could be dropped as min is defined by the include framework. This
> mgs> `minimal' definition is good enough for the driver since locally
> mgs> both a and b are `constants'.

then use the exact 2.4/2.6  definition in a compat.h or so...


> mgs> Only the __x86_64__ architecture has the register_ioctl32_conversion
> mgs> handler. This is reflection of what has been tested with the current=
ly
> mgs> available management tools. The only 64 bit architecture that has
> mgs> the management tools compiled as a 64 bit applications is for the AM=
D64
> mgs> right now. I have not yet determined how to figure out if a 32 bit
> mgs> legacy app or a 64 bit updated app has issued the ioctl call to the
> mgs> driver under other architectures.

yep that's what I call fishy ;)
broken ioctls for a broken interface ;(


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE//HFIxULwo51rQBIRAllyAJ932m+2TEQUY14hhkPJaM4v5acIMwCbB6IC
xNQC8UzpwHJ7ZCuLFEJwJj0=
=UNZX
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
