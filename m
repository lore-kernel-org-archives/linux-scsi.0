From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 12:33:37 +0200
Message-ID: <20080716103337.GA22931@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:37853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbYGPKdw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 06:33:52 -0400
Content-Disposition: inline
In-Reply-To: <20080716101634.GA8494@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> The problem is this aspect of that change:
>=20
> | @@ -9,6 +9,7 @@
> |  #define _SCSI_SCSI_H
> |
> |  #include <linux/types.h>
> | +#include <scsi/scsi_cmnd.h>
> |
> |  /*
> |   * The maximum number of SG segments that we will put inside a
>=20
> scsi_cmnd.h depends on symbols defined in blkdev.h. The fix is to=20
> include blkdev.h as well.

that wont work - a better replacement fix is the one below. The problem=
=20
is that scsi.h is included even on !CONFIG_BLOCK and then the=20
BLK_MAX_CDB symbol is meaningless.

	Ingo

----------->
commit 7c2bc6236e6c787ab9962cfc6fad04551d9c4057
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 16 11:56:08 2008 +0200

    scsi: fix build error in fs/compat_ioctl.c
   =20
    -tip testing found that the build broke in fs/compat_ioctl.c:
   =20
    ----------->
    In file included from include/scsi/scsi.h:12,
                     from fs/compat_ioctl.c:72:
    include/scsi/scsi_cmnd.h:27:25: warning: "BLK_MAX_CDB" is not defin=
ed
    include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can n=
ot be bigger than BLK_MAX_CDB
    In file included from include/scsi/scsi.h:12,
                     from fs/compat_ioctl.c:72:
    include/scsi/scsi_cmnd.h: In function =E2=80=98scsi_bidi_cmnd=E2=80=
=99:
    include/scsi/scsi_cmnd.h:182: error: implicit declaration of functi=
on =E2=80=98blk_bidi_rq=E2=80=99
    include/scsi/scsi_cmnd.h:183: error: dereferencing pointer to incom=
plete type
    include/scsi/scsi_cmnd.h: In function =E2=80=98scsi_in=E2=80=99:
    include/scsi/scsi_cmnd.h:189: error: dereferencing pointer to incom=
plete type
    <-----------
   =20
    with this config:
   =20
      http://redhat.com/~mingo/misc/config-Wed_Jul_16_11_32_32_CEST_200=
8.bad
   =20
    I have bisected it down to:
   =20
    | feac6a07c4a3578bffd6769bb4927e8a7e1f3ffe is first bad commit
    | commit feac6a07c4a3578bffd6769bb4927e8a7e1f3ffe
    | Author: Martin Petermann <martin@linux.vnet.ibm.com>
    | Date:   Wed Jul 2 10:56:35 2008 +0200
    |
    |    [SCSI] zfcp: Move status accessors from zfcp to SCSI include f=
ile.
    |
    |    Move the accessor functions for the scsi_cmnd status from zfcp=
 to the
    |    SCSI include file. Change the interface to the functions to pa=
ss the
    |    scsi_cmnd pointer instead of the status pointer.
    |
    |    Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
    |    Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
    |    Signed-off-by: James Bottomley <James.Bottomley@HansenPartners=
hip.com>
   =20
    The problem is due to this aspect of that change:
   =20
    | @@ -9,6 +9,7 @@
    |  #define _SCSI_SCSI_H
    |
    |  #include <linux/types.h>
    | +#include <scsi/scsi_cmnd.h>
    |
    |  /*
    |   * The maximum number of SG segments that we will put inside a
   =20
    scsi_cmnd.h depends on symbols defined in blkdev.h but those symbol=
s
    are not available if !CONFIG_BLOCK.
   =20
    Only include scsi/scsi_cmnd.h if on CONFIG_BLOCK.
    (those methods are not used when CONFIG_BLOCK is off anyway).
   =20
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/scsi/scsi.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 00137a7..b212859 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -9,7 +9,10 @@
 #define _SCSI_SCSI_H
=20
 #include <linux/types.h>
-#include <scsi/scsi_cmnd.h>
+
+#ifdef CONFIG_BLOCK
+# include <scsi/scsi_cmnd.h>
+#endif
=20
 /*
  * The maximum number of SG segments that we will put inside a

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
