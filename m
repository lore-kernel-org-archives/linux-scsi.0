From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 1/2] scsi: remove unneeded header search paths
Date: Fri, 25 Jan 2019 16:09:03 +0900
Message-ID: <1548400144-22513-2-git-send-email-yamada.masahiro@socionext.com>
References: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, Hannes Reinecke <hare@suse.com>, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

I was able to build without these extra header search paths.

Especially, the header search path -I. in kernel Makefiles is always
suspicious; it allows the compiler to search for headers in the top
of $(srctree), where obviously no header file exists.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/scsi/aacraid/Makefile  | 2 --
 drivers/scsi/aic7xxx/Makefile  | 1 -
 drivers/scsi/smartpqi/Makefile | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/scsi/aacraid/Makefile b/drivers/scsi/aacraid/Makefile
index 1bd9fd1..3893b95 100644
--- a/drivers/scsi/aacraid/Makefile
+++ b/drivers/scsi/aacraid/Makefile
@@ -4,5 +4,3 @@ obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
 		   dpcsup.o rx.o sa.o rkt.o nark.o src.o
-
-ccflags-y	:= -Idrivers/scsi
diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index c15be25..e0188ec 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -34,7 +34,6 @@ aic79xx-y					+= aic79xx_osm.o	\
 						   aic79xx_proc.o	\
 						   aic79xx_osm_pci.o
 
-ccflags-y += -Idrivers/scsi
 ifdef WARNINGS_BECOME_ERRORS
 ccflags-y += -Werror
 endif
diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makefile
index e6b7799..a03a6ed 100644
--- a/drivers/scsi/smartpqi/Makefile
+++ b/drivers/scsi/smartpqi/Makefile
@@ -1,3 +1,2 @@
-ccflags-y += -I.
 obj-$(CONFIG_SCSI_SMARTPQI) += smartpqi.o
 smartpqi-objs := smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport.o
-- 
2.7.4
