From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: remove fake "address-of" expression
Date: Thu, 5 Aug 2010 13:17:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1008051315150.1944-100000@iolanthe.rowland.org>
References: <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43295 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758969Ab0HERRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 13:17:10 -0400
In-Reply-To: <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

=46ake "address-of" expressions that evaluate to NULL generally confuse
readers and can provoke compiler warnings.  This patch (as1411)
removes one such fake expression, using an "#ifdef" in its place.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Resend.  I forgot to set the Subject line in the original message.

On Wed, 4 Aug 2010, Linus Torvalds wrote:

> On Tue, Aug 3, 2010 at 9:13 PM, James Bottomley <James.Bottomley@suse=
=2Ede> wrote:
> >
> > Alan Stern (3):
> > =A0 =A0 =A0sd: add support for runtime PM
> > =A0 =A0 =A0implement runtime Power Management
> > =A0 =A0 =A0convert to the new PM framework
>=20
> Guys, these kind of crazy games really aren't appropriate:
>=20
>   +/* scsi_pm.c */
>   +#ifdef CONFIG_PM_OPS
>   +extern const struct dev_pm_ops scsi_bus_pm_ops;
>   +#else
>   +#define scsi_bus_pm_ops                (*NULL)
>   +#endif
>=20
> that's just crazy. Yes, I see how it's then used (address-of operator
> turns it back into NULL), but the compiler warns about it
> ("drivers/scsi/scsi_sysfs.c:384: warning: dereferencing =91void *=92
> pointer") and I think the compiler is 100% correct about warning abou=
t
> it.
>=20
> It's not just the (*NULL) games, btw. The above can cause confusion.
> It's ugly not just because it causes the compiler to warn, but becaus=
e
> you use a very subtle and non-standard way of using #define's, so tha=
t
> when you look at the source code where this is used, it's not at all
> obvious what is going on. The code looks like
>=20
>     .pm             =3D &scsi_bus_pm_ops,
>=20
> and dammit, it would be rather understandable if some _human_ that
> reads that is also confused and thinks that the above means that the
> .pm pointer can never be NULL. The address-of would certainly throw
> me, and not necessarily at all make me grep for "could that possibly
> be some crazy way to say NULL".
>=20
> And there is absolutely no reason to play games like that. It would
> have been entirely understandable if you just put the #ifdef in the C
> code itself, or if you used a #define that just said
>=20
>   #ifdef CONFIG_PM_OPS
>   #define SCSI_BUS_PM_OPS &scsi_bus_pm_ops
>   #else
>   #define SCSI_BUS_PM_OPS NULL
>   #endif
>=20
> and I think it would be less confusing, and it wouldn't upset the com=
piler.
>=20
> Yes, yes, I realize that we do these kinds of things for function
> pointers all the time, so I do understand where the pattern comes
> from. At the same time, I rather think that function pointers are a
> bit different, and they don't have the whole address-of problem.
>=20
> I guess I should be happy that you didn't use some linker tricks to
> make "&scsi_bus_pm_ops" turn into NULL at link time. That could be
> done too, and would have been even more subtly confusing.

In my opinion this is the simplest and easiest-to-understand approach. =
=20
The two of you can fight over who merges it first.  :-)

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_priv.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-2.6.orig/drivers/scsi/scsi_priv.h
+++ usb-2.6/drivers/scsi/scsi_priv.h
@@ -148,8 +148,6 @@ static inline void scsi_netlink_exit(voi
 /* scsi_pm.c */
 #ifdef CONFIG_PM_OPS
 extern const struct dev_pm_ops scsi_bus_pm_ops;
-#else /* CONFIG_PM_OPS */
-#define scsi_bus_pm_ops		(*NULL)
 #endif
 #ifdef CONFIG_PM_RUNTIME
 extern void scsi_autopm_get_target(struct scsi_target *);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -382,7 +382,9 @@ struct bus_type scsi_bus_type =3D {
         .name		=3D "scsi",
         .match		=3D scsi_bus_match,
 	.uevent		=3D scsi_bus_uevent,
+#ifdef CONFIG_PM_OPS
 	.pm		=3D &scsi_bus_pm_ops,
+#endif
 };
 EXPORT_SYMBOL_GPL(scsi_bus_type);
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
