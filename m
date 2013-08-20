From: dl9pf@gmx.de
Subject: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 23:19:06 +0200
Message-ID: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20=
120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon M=C3=B6ller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx" =
(outsw likewise);
  GNU as accepts both forms.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

CC: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
CC: PaX Team <pageexec@freemail.hu>
CC: Behan Webster <behanw@converseincode.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/in2000.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
index 5821e1f..cd8d852 100644
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -72,7 +72,7 @@ int __dummy_1,__dummy_2; \
    orl %%ecx, %%ecx       \n \
    jz 1f                  \n \
    rep                    \n \
-   insw (%%dx),%%es:(%%edi) \n \
+   insw %%dx,%%es:(%%edi) \n \
 1: "                       \
    : "=3DD" (sp) ,"=3Dc" (__dummy_1) ,"=3Dd" (__dummy_2)  /* output */=
   \
    : "2" (f), "0" (sp), "1" (i)  /* input */    \
@@ -87,7 +87,7 @@ int __dummy_1,__dummy_2; \
    orl %%ecx, %%ecx       \n \
    jz 1f                  \n \
    rep                    \n \
-   outsw %%ds:(%%esi),(%%dx) \n \
+   outsw %%ds:(%%esi),%%dx \n \
 1: "                       \
    : "=3DS" (sp) ,"=3Dc" (__dummy_1) ,"=3Dd" (__dummy_2)/* output */  =
 \
    : "2" (f), "0" (sp), "1" (i)  /* input */    \
--=20
1.8.1.4
