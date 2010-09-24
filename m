From: matt mooney <mfm@muteddisk.com>
Subject: [PATCH 21/24] scsi: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:31 -0700
Message-ID: <a2fd5831df37b0a306ab4ca51d2e86ea7ee06425.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
 <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
 <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
 <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
 <8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
 <e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
 <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
 <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
 <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
 <f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
 <0472f95473283ce75285e458b22b86ff791d7a42.1285355033.git.mfm@muteddisk.com>
 <75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
 <30c1ad7f4200136e00723fd76da1e58200e6e5b0.1285355033.git.mfm@muteddisk.com>
 <06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/scsi/aacraid/Makefile |    2 +-
 drivers/scsi/aic94xx/Makefile |    4 +---
 drivers/scsi/cxgb3i/Kbuild    |    2 +-
 drivers/scsi/libsas/Makefile  |    6 ++----
 drivers/scsi/lpfc/Makefile    |    6 ++----
 drivers/scsi/mvsas/Makefile   |    4 +---
 drivers/scsi/pcmcia/Makefile  |    2 +-
 7 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/Makefile b/drivers/scsi/aacraid/Makefile
index f1cca4e..92df4d6 100644
--- a/drivers/scsi/aacraid/Makefile
+++ b/drivers/scsi/aacraid/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
 		   dpcsup.o rx.o sa.o rkt.o nark.o
 
-EXTRA_CFLAGS	:= -Idrivers/scsi
+ccflags-y	:= -Idrivers/scsi
diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefile
index e78ce0f..c0a15c7 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -22,9 +22,7 @@
 # along with the aic94xx driver; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
-ifeq ($(CONFIG_AIC94XX_DEBUG),y)
-	EXTRA_CFLAGS += -DASD_DEBUG -DASD_ENTER_EXIT
-endif
+ccflags-$(CONFIG_AIC94XX_DEBUG) := -DASD_DEBUG -DASD_ENTER_EXIT
 
 obj-$(CONFIG_SCSI_AIC94XX) += aic94xx.o
 aic94xx-y += aic94xx_init.o \
diff --git a/drivers/scsi/cxgb3i/Kbuild b/drivers/scsi/cxgb3i/Kbuild
index 70d060b..914ce3a 100644
--- a/drivers/scsi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgb3i/Kbuild
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb3
+ccflags-y := -I$(srctree)/drivers/net/cxgb3
 
 cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o cxgb3i_ddp.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 1ad1323..c62aa7b 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -21,9 +21,7 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
-ifeq ($(CONFIG_SCSI_SAS_LIBSAS_DEBUG),y)
-	EXTRA_CFLAGS += -DSAS_DEBUG
-endif
+ccflags-$(CONFIG_SCSI_SAS_LIBSAS_DEBUG) := -DSAS_DEBUG
 
 obj-$(CONFIG_SCSI_SAS_LIBSAS) += libsas.o
 libsas-y +=  sas_init.o     \
@@ -36,4 +34,4 @@ libsas-y +=  sas_init.o     \
 		sas_scsi_host.o \
 		sas_task.o
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
-libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
\ No newline at end of file
+libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index ad05d6e..14de249 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -19,10 +19,8 @@
 # *******************************************************************/
 ######################################################################
 
-ifneq ($(GCOV),)
-  EXTRA_CFLAGS += -fprofile-arcs -ftest-coverage
-  EXTRA_CFLAGS += -O0
-endif
+ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
+ccflags-$(GCOV) += -O0
 
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 52ac426..ffbf759 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -21,9 +21,7 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
-ifeq ($(CONFIG_SCSI_MVSAS_DEBUG),y)
-	EXTRA_CFLAGS += -DMV_DEBUG
-endif
+ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
 
 obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
 mvsas-y +=  mv_init.o  \
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index eca3790..683bf14 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,5 +1,5 @@
 
-EXTRA_CFLAGS		+= -Idrivers/scsi
+ccflags-y		:= -Idrivers/scsi
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
-- 
1.7.2.1
