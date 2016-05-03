From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Tue, 03 May 2016 08:36:53 +0200
Message-ID: <12243652.bxSxEgjgfk@wuerfel>
References: <1780465.XdtPJpi8Tt@wuerfel> <2346484.tQ1Ts8bYKc@wuerfel> <20160502163225.8b00a5ef7170a0f2533438e9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160502163225.8b00a5ef7170a0f2533438e9@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

On Monday 02 May 2016 16:32:25 Andrew Morton wrote:
> On Tue, 03 May 2016 01:10:16 +0200 Arnd Bergmann <arnd@arndb.de> wrot=
e:
>=20
> > On Monday 02 May 2016 16:02:18 Andrew Morton wrote:
> > > On Mon, 02 May 2016 23:48:19 +0200 Arnd Bergmann <arnd@arndb.de> =
wrote:
> > >=20
> > > > This is another attempt to avoid a regression in wwn_to_u64() a=
fter
> > > > that started using get_unaligned_be64(), which in turn ran into=
 a
> > > > bug on gcc-4.9 through 6.1.
> > >=20
> > > I'm still getting a couple screenfuls of things like
> > >=20
> > > net/tipc/name_distr.c: In function 'tipc_named_process_backlog':
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'uns=
igned int', but argument 3 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'uns=
igned int', but argument 4 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'uns=
igned int', but argument 5 has type 'unsigned int'
> > > net/tipc/name_distr.c:330: warning: format '%u' expects type 'uns=
igned int', but argument 7 has type 'unsigned int'
> >=20
> > I've built a few thousand kernels (arm32 with gcc-6.1) with the pat=
ch applied,
> > but didn't see this one. What target architecture and compiler vers=
ion produced
> > this? Does it go away if you add a (__u32) cast? I don't even know =
what the
> > warning is trying to tell me.
>=20
> heh, I didn't actually read it.
>=20
> Hopefully we can write this off as a gcc-4.4.4 glitch. 4.8.4 is OK.

Ah, old compiler. I've tried gcc-4.3 now on ARM, and I don't get this w=
arning
(just a lot "may be used uninitialized"), but unlike gcc-4.4, my versio=
n doesn't
actually get into the code path I have changed because __builtin_bswap3=
2 was only
introduced with 4.4.

I don't have gcc-4.4 and 4.5 here, but the warning does show up with 4.=
6, 4.7
and 4.8:

drivers/soc/sunxi/sunxi_sram.c: In function =E2=80=98sunxi_sram_show=E2=
=80=99:
drivers/soc/sunxi/sunxi_sram.c:103:7: warning: format =E2=80=98%x=E2=80=
=99 expects argument of type =E2=80=98unsigned int=E2=80=99, but argume=
nt 3 has type =E2=80=98unsigned int=E2=80=99 [-Wformat=3D]

4.8 is probably still common enough that we should try to address this.
This change addresses the problem for me with ARM gcc-4.8, but adding
two more type casts. This also makes the 16/32/64 bit swaps all
look the same. I would expect this to also have the same effect on 4.4.

Please fold into the previous patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index d737804af181..8f3a8f606fd9 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -97,7 +97,7 @@ static inline __attribute_const__ __u32 __fswahb32(__=
u32 val)
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP16__
-#define __swab16(x) __builtin_bswap16((__u16)(x))
+#define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
 #else
 #define __swab16(x)				\
 	(__builtin_constant_p((__u16)(x)) ?	\
@@ -110,7 +110,7 @@ static inline __attribute_const__ __u32 __fswahb32(=
__u32 val)
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP32__
-#define __swab32(x) __builtin_bswap32((__u32)(x))
+#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
 #else
 #define __swab32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
