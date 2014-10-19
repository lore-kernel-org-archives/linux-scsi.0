From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver - 2nd request
Date: Sun, 19 Oct 2014 22:37:21 +0300
Message-ID: <2239FF81-72E8-44F1-A7FC-CCAC19AF59DC@kolumbus.fi>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com> <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi> <753462044.46450262.1413577229927.JavaMail.zimbra@redhat.com> <27E642F6-B018-4D4E-9AFC-9E4669282924@kolumbus.fi> <298124289.46669934.1413726265963.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:52160 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaJSThd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 15:37:33 -0400
In-Reply-To: <298124289.46669934.1413726265963.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org


> On 19.10.2014, at 16.44, Laurence Oberman <loberman@redhat.com> wrote=
:
>=20
> Hello Kai
>=20
> Thanks.=20
>=20
> Here is v3
>=20
> This patch adds a debug_flag parameter that can be set on module load=
, and allows the DEBUG facility without a module recompile.
> Note that now DEBUG 1 is the default with this patch.
>=20
> Usage: modprobe st debug_flag=3D1
>=20
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

>=20
> diff -Nur a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
> --- a/Documentation/scsi/st.txt	2014-10-19 09:36:52.243863716 -0400
> +++ b/Documentation/scsi/st.txt	2014-10-19 09:43:19.222863447 -0400
> @@ -506,9 +506,11 @@
>=20
> DEBUGGING HINTS
>=20
> -To enable debugging messages, edit st.c and #define DEBUG 1. As seen
> -above, debugging can be switched off with an ioctl if debugging is
> -compiled into the driver. The debugging output is not voluminous.
> +Debugging code is now compiled in by default but debugging is turned=
 off with=20
> +the kernel module parameter debug_flag defaulting to 0.
> +Debugging can still be switched on and off with an ioctl.
> +To enable debug at module load time add debug_flag=3D1 to the module=
 load=20
> +options, the debugging output is not voluminous.
>=20
> If the tape seems to hang, I would be very interested to hear where
> the driver is waiting. With the command 'ps -l' you can see the state
>=20
> diff -Nur a/drivers/scsi/st.c b/drivers/scsi/st.c
> --- a/drivers/scsi/st.c	2014-10-19 09:35:45.673863756 -0400
> +++ b/drivers/scsi/st.c	2014-10-19 09:35:30.621863483 -0400
> @@ -56,7 +56,8 @@
>=20
> /* The driver prints some debugging information on the console if DEB=
UG
>    is defined and non-zero. */
> -#define DEBUG 0
> +#define DEBUG 1
> +#define NO_DEBUG 0
>=20
> #define ST_DEB_MSG  KERN_NOTICE
> #if DEBUG
> @@ -80,6 +81,7 @@
> static int try_direct_io =3D TRY_DIRECT_IO;
> static int try_rdio =3D 1;
> static int try_wdio =3D 1;
> +static int debug_flag =3D 0;
>=20
> static struct class st_sysfs_class;
> static const struct attribute_group *st_dev_groups[];
> @@ -100,6 +102,9 @@
> MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segme=
nts to use (256)");
> module_param_named(try_direct_io, try_direct_io, int, 0);
> MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer a=
nd tape drive (1)");
> +module_param_named(debug_flag, debug_flag, int, 0);
> +MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting debuggin=
g=3D1");
> +
>=20
> /* Extra parameters for testing */
> module_param_named(try_rdio, try_rdio, int, 0);
> @@ -124,6 +129,9 @@
> 	},
> 	{
> 		"try_direct_io", &try_direct_io
> +        },
> +        {
> +                "debug_flag", &debug_flag
> 	}
> };
> #endif
> @@ -4309,6 +4317,10 @@
> 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
> 		verstr, st_fixed_buffer_size, st_max_sg_segs);
>=20
> +        debugging =3D (debug_flag > 0) ? debug_flag : NO_DEBUG;
> +         if (debugging)
> +                printk(KERN_INFO "st: Debugging enabled debug_flag =3D=
 %d\n",debugging);
> +
> 	err =3D class_register(&st_sysfs_class);
> 	if (err) {
> 		pr_err("Unable register sysfs class for SCSI tapes\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
