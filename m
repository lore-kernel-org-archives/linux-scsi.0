From: Arjan van de Ven <arjanv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Wed, 7 Jan 2004 19:42:22 +0100
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <20040107184222.GA14191@devserv.devel.redhat.com>
References: <3FFC4C09.3020103@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3FFC4C09.3020103-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>
Errors-To: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
List-Help: <mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJuMTnGGMi8c9@public.gmane.org>
List-Post: <mailto:linux-aacraid-devel-8PEkshWhKlo@public.gmane.org>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJhLjRD9WNpgrmSKB9SHqsyg@public.gmane.org>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJt/CJOUnrhF+9vnX9k1QryA@public.gmane.org>
List-Archive: <http://lists.us.dell.com/pipermail/linux-aacraid-devel/>
To: Xose Vazquez Perez <xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>
Cc: linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2004 at 07:28:01PM +0100, Xose Vazquez Perez wrote:
> hi,
>=20
> here goes latest aacraid driver, it was sent for 2.4 kernel
> inclusion. CHANGELOG has an extensive list of changes.

+#define aac_spin_lock_irqsave(host_lock, cpu_flags)            spin_lock_i=
rqsave(&io_request_lock, cpu_flags)
+#define aac_spin_lock_irq(host_lock)                           spin_lock_i=
rq(&io_request_lock)
+#define aac_spin_unlock_irqrestore(host_lock, cpu_flags)       spin_unlock=
_irqrestore(&io_request_lock, cpu_flags)
+#define aac_spin_unlock_irq(host_lock)                         spin_unlock=
_irq(&io_request_lock)
                                                                           =
                                            =20
ewwww


+#ifdef AAC_DETAILED_STATUS_INFO
 static char *aac_get_status_string(u32 status);
+#endif

there's no need for ifdefs around prototypes, they just clutter the code

+        *      Only enable DAC mode if the dma_addr_t is larger than 32
+        * bit addressing, and we have more than 32 bit addressing worth of
+        * memory and if the controller supports 64 bit scatter gather elem=
ents.
+        */
+       if( (sizeof(dma_addr_t) > 4) && (num_physpages > (0xFFFFFFFFULL >> =
PAGE_SHIFT)) && (dev->adapter_info.options &
+               dev->dac_support =3D 1;
        }

that looks broken, at least drivers should never need to check num_physpage=
s etc etc


+static void get_sd_devname(int disknum, char *buffer)
+{
+.....


why on earth is that in a driver?????

+# define strlcpy(s1,s2,n) strncpy(s1,s2,n);s1[n-1]=3D'\0'


this is very broken; consider

if (foo)
    bar(foo);
else
    strlcpy(foo,bar,3);


+# ifndef min
+#  define min(a,b) (((a)<(b))?(a):(b))
+# endif

that is quite broken..... arguments get evaluated multiple times



 struct fib_ioctl
 {
-       char    *fibctx;
-       int     wait;
-       char    *fib;
+       u32     fibctx;
+       s32     wait;
+#if (defined(__x86_64__))
+       u64     fib;
+#else
+       u32     fib;
+#endif
 };


that looks really fishy; __x86_64__ most certainly is not the only 64 bit a=
rchitecture out there



this driver "update" appears to intruduce quite a few nastys... doesn't loo=
k like a good idea to me

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE//FMNxULwo51rQBIRAtTRAJ42BTNRLiTc1vdYJjM3wVOmm07fLgCbB6K6
sXdCL1dGhNQDIjPBbZMPyI8=
=6Yo/
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
