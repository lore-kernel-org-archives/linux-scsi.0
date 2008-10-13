From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Mon, 13 Oct 2008 15:20:06 -0400
Message-ID: <1223925606.5566.20.camel@localhost.localdomain>
References: <1223909115.5566.13.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59832 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755921AbYJMTUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 15:20:11 -0400
In-Reply-To: <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2008-10-13 at 10:22 -0700, Linus Torvalds wrote:
>=20
> On Mon, 13 Oct 2008, James Bottomley wrote:
> >
> > This represents all the pieces of SCSI which were depending on the
> > already merged block tree.
>=20
> Grr. And it doesn't actually compile.
>=20
>   drivers/scsi/sd.c:579:27: error: macro "sd_dif_op" passed 4 argumen=
ts, but takes just 3
>   drivers/scsi/sd.c: In function =E2=80=98sd_prep_fn=E2=80=99:
>   drivers/scsi/sd.c:578: error: =E2=80=98sd_dif_op=E2=80=99 undeclare=
d (first use in this function)
>   drivers/scsi/sd.c:578: error: (Each undeclared identifier is report=
ed only once
>   drivers/scsi/sd.c:578: error: for each function it appears in.)
>=20
> Hmm? Was this testedt AT ALL? It can never compile unless that idioti=
c=20
> CONFIG_BLK_DEV_INTEGRITY option is set that no sane person would set =
right=20
> now, and which is even documented to not be enabled by default:
>=20
>   If in doubt, say N.
>=20
> yet it looks like it has not compiled since a commit that was put in =
in=20
> the middle of September!
>=20
> What part of "This is total untested crap" are we missing here?

OK, you caught me; I'm relying on linux-next to test randomly built
configs because I don't have a compile farm available to me where I can
test every permutation of the options (and obviously, I usually compile
with them all on to test the actual feature code).

> Yeah, I'm grumpy. I expect to not be fed shit like this. It has appar=
ently=20
> been rebased several times, and all apparently with no testing=20
> what-so-ever!

Not exactly.  It has to be rebased to run as a postmerge tree, but it
does get tested by me (admittedly on my limited set of machines, which
don't include any actual devices that do block integrity) every time I
rebase.

However, does this work for you?  It fixes the problem for me.

James

---

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index a92b991..75638e7 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -97,7 +97,7 @@ struct sd_dif_tuple {
        __be32 ref_tag;		/* Target LBA or indirect LBA */
 };
=20
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
+#ifdef CONFIG_BLK_DEV_INTEGRITY
=20
 extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int, =
unsigned int);
 extern void sd_dif_config_host(struct scsi_disk *);
@@ -106,10 +106,19 @@ extern void sd_dif_complete(struct scsi_cmnd *, u=
nsigned int);
=20
 #else /* CONFIG_BLK_DEV_INTEGRITY */
=20
-#define sd_dif_op(a, b, c)			do { } while (0)
-#define sd_dif_config_host(a)			do { } while (0)
-#define sd_dif_prepare(a, b, c)			(0)
-#define sd_dif_complete(a, b)			(0)
+static inline void sd_dif_op(struct scsi_cmnd *cmd, unsigned int a, un=
signed int b, unsigned int c)
+{
+}
+static inline void sd_dif_config_host(struct scsi_disk *disk)
+{
+}
+static inline int sd_dif_prepare(struct request *rq, sector_t s, unsig=
ned int a)
+{
+	return 0;
+}
+static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int=
 a)
+{
+}
=20
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
=20


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
