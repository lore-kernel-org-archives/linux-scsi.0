From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 08/13] libsas: libsas.force_hard_reset module parameter
Date: Fri, 10 Feb 2012 00:45:20 -0800
Message-ID: <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

It is possible for a host to get "locked out" from talking to sata
devices in the domain if, for example, its sas address changes but the
expander topology has existing affiliations with the old address.  If
the system is booted userspace can write to
/sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, however
if this condition exists for the root device the module parameter can be
used to promote all ata resets to hard resets.

After the system is booted this state can be cleared via
/sys/module/libsas/parameters/force_hard_reset

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/scsi/libsas/sas_init.c      |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81c287f..ffefa3b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1283,6 +1283,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	libsas.force_hard_reset=
+			[LIBSAS] Clear SATA affiliations with every reset, for
+			cases where affiliation errors are causing boot
+			failures, otherwise use sysfs hard_reset interface to
+			clear individual phys.
+
 	memblock=debug	[KNL] Enable memblock debug messages.
 
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 120bff6..2fc23d3 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -293,6 +293,10 @@ static int sas_phy_enable(struct sas_phy *phy, int enable)
 	return ret;
 }
 
+static bool force_hard_reset;
+module_param(force_hard_reset, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(force_hard_reset, "clear sata affiliations on every reset");
+
 int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 {
 	int ret;
@@ -301,7 +305,7 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	if (!phy->enabled)
 		return -ENODEV;
 
-	if (hard_reset)
+	if (hard_reset || force_hard_reset)
 		reset_type = PHY_FUNC_HARD_RESET;
 	else
 		reset_type = PHY_FUNC_LINK_RESET;

