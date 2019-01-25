From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/2] scsi: prefix header search paths with $(srctree)/
Date: Fri, 25 Jan 2019 16:09:04 +0900
Message-ID: <1548400144-22513-3-git-send-email-yamada.masahiro@socionext.com>
References: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/scsi/cxgbi/Makefile  | 2 +-
 drivers/scsi/pcmcia/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index a73781a..f78c9cc 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,4 +1,4 @@
-ccflags-y += -Idrivers/net/ethernet/chelsio/libcxgb
+ccflags-y += -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
 
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libcxgbi.o cxgb3i/
 obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libcxgbi.o cxgb4i/
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index faa87a4..a5a24dd 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ccflags-y		:= -Idrivers/scsi
+ccflags-y		:= -I $(srctree)/drivers/scsi
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
-- 
2.7.4
