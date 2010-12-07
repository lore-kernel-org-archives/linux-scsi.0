From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Tue, 07 Dec 2010 10:30:49 -0600
Message-ID: <1291739449.17668.9.camel@mulgrave.site>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291738348.1638.9.camel@leonhard>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> 2010-12-07 (=ED=99=94), 09:57 -0600, James Bottomley:
> > Um so this is definitely used in the MODULE_DEVICE_TABLE just below=
=2E
> >=20
> > I deduce you have some type of config which causes that to be a nop
> > (say !CONFIG_MODULE)?  In which case, surely the correct fix is in
> > module.h?
> >=20
>=20
> Hi,
>=20
> MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) =
so
> allyesconfig build always emits the warnings. Possible patch for this
> would be wraping it up in #ifdefs but when I sent a same patch to Gre=
g
> KH he didn't want to add more #ifdefs in .c files.

I didn't mean changing any c files.  I meant fixing the module include
to make the table used even in the !MODULE case.  That way we only alte=
r
one file instead of a significant proportion of the drivers.

James

---

diff --git a/include/linux/module.h b/include/linux/module.h
index 7575bbb..d49aa9c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -90,7 +90,10 @@ extern const struct gtype##_id __mod_##gtype##_table=
		\
 extern struct module __this_module;
 #define THIS_MODULE (&__this_module)
 #else  /* !MODULE */
-#define MODULE_GENERIC_TABLE(gtype,name)
+/* Flag name as used to avoid warnings about the unused device id tabl=
e */
+#define MODULE_GENERIC_TABLE(gtype,name)			\
+static const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
 #define THIS_MODULE ((struct module *)0)
 #endif
=20
