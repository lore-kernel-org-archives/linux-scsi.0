From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver - 2nd
 request
Date: Sun, 19 Oct 2014 09:44:25 -0400 (EDT)
Message-ID: <298124289.46669934.1413726265963.JavaMail.zimbra@redhat.com>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com> <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi> <753462044.46450262.1413577229927.JavaMail.zimbra@redhat.com> <27E642F6-B018-4D4E-9AFC-9E4669282924@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51249 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaJSNol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 09:44:41 -0400
In-Reply-To: <27E642F6-B018-4D4E-9AFC-9E4669282924@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Hello Kai

Thanks.=20

Here is v3

This patch adds a debug_flag parameter that can be set on module load, =
and allows the DEBUG facility without a module recompile.
Note that now DEBUG 1 is the default with this patch.

Usage: modprobe st debug_flag=3D1

Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nur a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
--- a/Documentation/scsi/st.txt	2014-10-19 09:36:52.243863716 -0400
+++ b/Documentation/scsi/st.txt	2014-10-19 09:43:19.222863447 -0400
@@ -506,9 +506,11 @@
=20
 DEBUGGING HINTS
=20
-To enable debugging messages, edit st.c and #define DEBUG 1. As seen
-above, debugging can be switched off with an ioctl if debugging is
-compiled into the driver. The debugging output is not voluminous.
+Debugging code is now compiled in by default but debugging is turned o=
ff with=20
+the kernel module parameter debug_flag defaulting to 0.
+Debugging can still be switched on and off with an ioctl.
+To enable debug at module load time add debug_flag=3D1 to the module l=
oad=20
+options, the debugging output is not voluminous.
=20
 If the tape seems to hang, I would be very interested to hear where
 the driver is waiting. With the command 'ps -l' you can see the state

diff -Nur a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	2014-10-19 09:35:45.673863756 -0400
+++ b/drivers/scsi/st.c	2014-10-19 09:35:30.621863483 -0400
@@ -56,7 +56,8 @@
=20
 /* The driver prints some debugging information on the console if DEBU=
G
    is defined and non-zero. */
-#define DEBUG 0
+#define DEBUG 1
+#define NO_DEBUG 0
=20
 #define ST_DEB_MSG  KERN_NOTICE
 #if DEBUG
@@ -80,6 +81,7 @@
 static int try_direct_io =3D TRY_DIRECT_IO;
 static int try_rdio =3D 1;
 static int try_wdio =3D 1;
+static int debug_flag =3D 0;
=20
 static struct class st_sysfs_class;
 static const struct attribute_group *st_dev_groups[];
@@ -100,6 +102,9 @@
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segmen=
ts to use (256)");
 module_param_named(try_direct_io, try_direct_io, int, 0);
 MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer an=
d tape drive (1)");
+module_param_named(debug_flag, debug_flag, int, 0);
+MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting debugging=3D=
1");
+
=20
 /* Extra parameters for testing */
 module_param_named(try_rdio, try_rdio, int, 0);
@@ -124,6 +129,9 @@
 	},
 	{
 		"try_direct_io", &try_direct_io
+        },
+        {
+                "debug_flag", &debug_flag
 	}
 };
 #endif
@@ -4309,6 +4317,10 @@
 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
=20
+        debugging =3D (debug_flag > 0) ? debug_flag : NO_DEBUG;
+         if (debugging)
+                printk(KERN_INFO "st: Debugging enabled debug_flag =3D=
 %d\n",debugging);
+
 	err =3D class_register(&st_sysfs_class);
 	if (err) {
 		pr_err("Unable register sysfs class for SCSI tapes\n");


----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "Rob Evers" <revers@redhat.com>, linux-scsi@vger.kernel.org
Sent: Sunday, October 19, 2014 4:54:10 AM
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver - 2=
nd request

Hello,

I am responding to this, but noticed your next, fixed version.

> On 17.10.2014, at 23.20, Laurence Oberman <loberman@redhat.com> wrote=
:
>=20
> Hello Kai
>=20
> You have seen this patch before. The first time around, given that we=
 don't enable DEBUG by default, I let it go.
> However we have been looking into defining DEBUG 1 by default here at=
 Redhat and then setting the default to disabled.
>=20
> Are you open to considering changing the driver based on this patch.
> i.e. default DEFINE 1 and adding this code with default set to off.
>=20
Yes. I certainly think defining DEBUG 1 and changing the default to zer=
o should be done if it is useful for supporting users. The runtime over=
head is negligible and the extra code does not matter nowadays (it did =
matter, at least theoretically, for years ago).

I am not so sure about the module option. When the debugging code is co=
mpiled in, debugging can be enabled and disabled for each device by the=
 MTIOCTOP ioctl (e.g., mtst -f tape_device stsetoptions debug). The mod=
ule option enables debugging for all tape devices. However, if you thin=
k this additional module option is useful, I am not against it. It does=
 not remove the possibility for controlling debugging for each device f=
or those who want to do it that way.

Anyway, you should modify the documentation (Documentation/scsi/st.txt)=
 according to the changes.

> Note that with DEBUG 0, as you know you need to change that and recom=
pile.=20
> That is exactly what I am trying to avoid with Enterprise customers.
>=20
I have also noticed this when someone has asked me about some tape prob=
lems.

> This patch adds a debug_flag parameter that can be set on module load=
, and allows the DEBUG facility without a module recompile.
> Note that now DEBUG 1 is the default with this patch.
>=20
> Usage: modprobe st debug_flag=3D1
>=20
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
>=20
> diff -Nur a/st.c b/st.c
> --- a/st.c	2014-10-17 16:15:54.103810627 -0400
> +++ b/st.c	2014-10-17 16:22:12.303810392 -0400
> @@ -56,7 +56,7 @@
>=20
> /* The driver prints some debugging information on the console if DEB=
UG
>    is defined and non-zero. */
> -#define DEBUG 0
> +#define DEBUG 1
>=20
> #define ST_DEB_MSG  KERN_NOTICE
> #if DEBUG
> @@ -80,6 +80,7 @@
> static int try_direct_io =3D TRY_DIRECT_IO;
> static int try_rdio =3D 1;
> static int try_wdio =3D 1;
> +static int debug_flag =3D 0;
>=20
> static struct class st_sysfs_class;
> static const struct attribute_group *st_dev_groups[];
> @@ -100,6 +101,9 @@
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
> @@ -124,6 +128,9 @@
> 	},
> 	{
> 		"try_direct_io", &try_direct_io
> +        },
> +        {
> +                "debug_flag", &debug_flag
> 	}
> };
> #endif
> @@ -4306,6 +4313,11 @@
>=20
> 	validate_options();
>=20
> +        debugging =3D (debug_flag > 0) ? debug_flag : DEBUG;
> +         if (debugging)
> +                printk(KERN_INFO "st: Debugging enabled debug_flag =3D=
 %d\n",debugging);
> +
> +

I think you have an extra newline here?

I also think that the kernel log would look nicer if the print below wo=
uld be before setting the option. The driver would introduce itself fir=
st and print the debug flag status after that.

> 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
> 		verstr, st_fixed_buffer_size, st_max_sg_segs);

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
