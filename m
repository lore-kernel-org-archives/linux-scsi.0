From: <sreekanth.reddy@lsi.com>
Subject: [v2 PATCH 1/20][SCSI] mpt3sas: Makefile, Kconfig and
 scsi_transport_sas file changes to support new driver mpt3sas
Date: Fri, 30 Nov 2012 07:43:11 +0530
Message-ID: <20121130021311.GA10152@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:51271 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab2K2PPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Nov 2012 10:15:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains the Makefile, Kconfig and 
scsi_transport_sas file changes to support new driver mpt3sas

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e955978..49244f8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -620,6 +620,7 @@ config SCSI_ARCMSR
 
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt2sas/Kconfig"
+source "drivers/scsi/mpt3sas/Kconfig"
 source "drivers/scsi/ufs/Kconfig"
 
 config SCSI_HPTIOP
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1a3368b..88e52bb 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
 obj-$(CONFIG_SCSI_MPT2SAS)	+= mpt2sas/
+obj-$(CONFIG_SCSI_MPT3SAS)	+= mpt3sas/
 obj-$(CONFIG_SCSI_UFSHCD)	+= ufs/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+= esp_scsi.o	sun_esp.o
diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
new file mode 100644
index 0000000..81471bf
--- /dev/null
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -0,0 +1,67 @@
+#
+# Kernel configuration file for the MPT3SAS
+#
+# This code is based on drivers/scsi/mpt3sas/Kconfig
+# Copyright (C) 2012  LSI Corporation
+#  (mailto:DL-MPTFusionLinux@lsi.com)
+
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+# NO WARRANTY
+# THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+# LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+# solely responsible for determining the appropriateness of using and
+# distributing the Program and assumes all risks associated with its
+# exercise of rights under this Agreement, including but not limited to
+# the risks and costs of program errors, damage to or loss of data,
+# programs or equipment, and unavailability or interruption of operations.
+
+# DISCLAIMER OF LIABILITY
+# NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+# DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+# USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+# HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+# USA.
+
+config SCSI_MPT3SAS
+	tristate "LSI MPT Fusion SAS 3.0 Device Driver"
+	depends on PCI && SCSI
+	select SCSI_SAS_ATTRS
+	select RAID_ATTRS
+	---help---
+	This driver supports PCI-Express SAS 12Gb/s Host Adapters.
+
+config SCSI_MPT3SAS_MAX_SGE
+	int "LSI MPT Fusion Max number of SG Entries (16 - 256)"
+	depends on PCI && SCSI && SCSI_MPT3SAS
+	default "128"
+	range 16 256
+	---help---
+	This option allows you to specify the maximum number of scatter-
+	gather entries per I/O. The driver default is 128, which matches
+	MAX_PHYS_SEGMENTS in most kernels.  However in SuSE kernels this
+	can be 256. However, it may decreased down to 16.  Decreasing this
+	parameter will reduce memory requirements on a per controller instance.
+
+config SCSI_MPT3SAS_LOGGING
+	bool "LSI MPT Fusion logging facility"
+	depends on PCI && SCSI && SCSI_MPT3SAS
+	---help---
+	This turns on a logging facility.
diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
new file mode 100644
index 0000000..4c1d2e7
--- /dev/null
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -0,0 +1,8 @@
+# mpt3sas makefile
+obj-m += mpt3sas.o
+mpt3sas-y +=  mpt3sas_base.o     \
+		mpt3sas_config.o \
+		mpt3sas_scsih.o      \
+		mpt3sas_transport.o     \
+		mpt3sas_ctl.o	\
+		mpt3sas_trigger_diag.o
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f7565fc..1b68142 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -151,6 +151,7 @@ static struct {
 	{ SAS_LINK_RATE_1_5_GBPS,	"1.5 Gbit" },
 	{ SAS_LINK_RATE_3_0_GBPS,	"3.0 Gbit" },
 	{ SAS_LINK_RATE_6_0_GBPS,	"6.0 Gbit" },
+	{ SAS_LINK_RATE_12_0_GBPS,	"12.0 Gbit" },
 };
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
 sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 98b3a20..9b8e088 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -36,6 +36,7 @@ enum sas_linkrate {
 	SAS_LINK_RATE_3_0_GBPS = 9,
 	SAS_LINK_RATE_G2 = SAS_LINK_RATE_3_0_GBPS,
 	SAS_LINK_RATE_6_0_GBPS = 10,
+	SAS_LINK_RATE_12_0_GBPS = 11,
 	/* These are virtual to the transport class and may never
 	 * be signalled normally since the standard defined field
 	 * is only 4 bits */
