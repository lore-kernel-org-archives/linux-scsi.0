From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Build Failure (Was Re: 2.6.23-mm1)
Date: Fri, 12 Oct 2007 15:12:31 +0530
Message-ID: <20071012094231.GA15012@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:47652 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXJLJtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Oct 2007 05:49:36 -0400
Content-Disposition: inline
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ballabio_dario@emc.com, linux-scsi@vger.kernel.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
>=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/=
2.6.23-mm1/
>=20

Hi Andrew

My compile just failed with=20

drivers/scsi/gdth.c: In function =E2=80=98gdth_search_dev=E2=80=99:
drivers/scsi/gdth.c:646: warning: =E2=80=98pci_find_device=E2=80=99 is =
deprecated
(declared at include/linux/pci.h:482)
drivers/scsi/gdth.c: In function =E2=80=98gdth_init_isa=E2=80=99:
drivers/scsi/gdth.c:857: error: =E2=80=98gdth_irq_tab=E2=80=99 undeclar=
ed (first use in
this function)
drivers/scsi/gdth.c:857: error: (Each undeclared identifier is reported
only once
drivers/scsi/gdth.c:857: error: for each function it appears in.)
drivers/scsi/gdth.c: In function =E2=80=98gdth_copy_internal_data=E2=80=
=99:
drivers/scsi/gdth.c:2362: warning: unused variable =E2=80=98sg=E2=80=99
make[2]: *** [drivers/scsi/gdth.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
[dhaval@gondor linux-2.6.23]$

Looking into the code I notice that gdth_irq_tab is not declared with
CONFIG_ISA=3Dy and !CONFIG_EISA.

The values seem to be same in 2.6.23 (I am not sure why it has been put
with #ifdefs in -mm) so I have just modified the #ifdef to take care of
CONFIG_ISA as well.

(Compile tested only)

Thanks,

--

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


Index: linux-2.6.23/drivers/scsi/gdth.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.23.orig/drivers/scsi/gdth.c	2007-10-12 14:07:28.000000000=
 +0530
+++ linux-2.6.23/drivers/scsi/gdth.c	2007-10-12 15:06:47.000000000 +053=
0
@@ -288,7 +288,7 @@ static struct timer_list gdth_timer;
 #ifdef CONFIG_ISA
 static unchar   gdth_drq_tab[4] =3D {5,6,7,7};            /* DRQ table=
 */
 #endif
-#ifdef CONFIG_EISA
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_irq_tab[6] =3D {0,10,11,12,14,0};    /* IRQ table=
 */
 #endif
 static unchar   gdth_polling;                           /* polling if =
TRUE */

--=20
regards,
Dhaval
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
