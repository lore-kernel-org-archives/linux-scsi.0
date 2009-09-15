From: "jack wang" <jack_wang@usish.com>
Subject: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Tue, 15 Sep 2009 11:10:33 +0800
Message-ID: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001C_01CA35F5.26FD8910"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53332 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbZIODKn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 23:10:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, lindar_liu@usish.com, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, jack_wang@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_001C_01CA35F5.26FD8910
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, James
Sorry for the late response. Here is our driver next send with review input
from Matthew:
1 Big endian support is added but not test because lack of equipment.
2 IOCTL interface is replaced by sysfs.
3 Delete some unused debug info
4 Move Vendor id to pci_ids.h
5 Kconfig && Makefile modification
Any comments and reviews will be appreciated
Best wishes,
Jack

------=_NextPart_000_001C_01CA35F5.26FD8910
Content-Type: application/octet-stream;
	name="pm8001.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="pm8001.patch"

=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
Signed-off-by: Kevin Ao <aoqingyun@usish.com>=0A=
---=0A=
 MAINTAINERS                        |    7 +=0A=
 drivers/scsi/Kconfig               |    8 +=0A=
 drivers/scsi/Makefile              |    1 +=0A=
 drivers/scsi/pm8001/Makefile       |   12 +=0A=
 drivers/scsi/pm8001/pm8001_chips.h |   89 +=0A=
 drivers/scsi/pm8001/pm8001_ctl.c   |  584 +++++=0A=
 drivers/scsi/pm8001/pm8001_ctl.h   |   67 +=0A=
 drivers/scsi/pm8001/pm8001_defs.h  |  114 +=0A=
 drivers/scsi/pm8001/pm8001_hwi.c   | 4288 =
++++++++++++++++++++++++++++++++++++=0A=
 drivers/scsi/pm8001/pm8001_hwi.h   | 1011 +++++++++=0A=
 drivers/scsi/pm8001/pm8001_init.c  |  885 ++++++++=0A=
 drivers/scsi/pm8001/pm8001_sas.c   | 1107 ++++++++++=0A=
 drivers/scsi/pm8001/pm8001_sas.h   |  487 ++++=0A=
 include/linux/pci_ids.h            |    2 +=0A=
 14 files changed, 8662 insertions(+), 0 deletions(-)=0A=
 create mode 100644 drivers/scsi/pm8001/Makefile=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_chips.h=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_ctl.c=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_ctl.h=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_defs.h=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_hwi.c=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_hwi.h=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_init.c=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_sas.c=0A=
 create mode 100644 drivers/scsi/pm8001/pm8001_sas.h=0A=
=0A=
diff --git a/MAINTAINERS b/MAINTAINERS=0A=
index e8fabf8..61a1422 100644=0A=
--- a/MAINTAINERS=0A=
+++ b/MAINTAINERS=0A=
@@ -3978,6 +3978,13 @@ W:	http://www.pmc-sierra.com/=0A=
 S:	Supported=0A=
 F:	drivers/scsi/pmcraid.*=0A=
 =0A=
+PMC SIERRA PM8001 DRIVER=0A=
+M:	jack_wang@usish.com=0A=
+M:	lindar_liu@usish.com=0A=
+L:	linux-scsi@vger.kernel.org=0A=
+S:	Supported=0A=
+F:	drivers/scsi/pm8001/*.*=0A=
+=0A=
 POSIX CLOCKS and TIMERS=0A=
 M:	Thomas Gleixner <tglx@linutronix.de>=0A=
 S:	Supported=0A=
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig=0A=
index 82bb3b2..a5281c9 100644=0A=
--- a/drivers/scsi/Kconfig=0A=
+++ b/drivers/scsi/Kconfig=0A=
@@ -1817,6 +1817,14 @@ config SCSI_PMCRAID=0A=
 	---help---=0A=
 	  This driver supports the PMC SIERRA MaxRAID adapters.=0A=
 =0A=
+config SCSI_PM8001=0A=
+	tristate "PMC-Sierra SPC 8001 SAS/SATA Based Host Adapter driver"=0A=
+	depends on PCI && SCSI=0A=
+	select SCSI_SAS_LIBSAS=0A=
+	help=0A=
+	  This driver supports PMC-Sierra PCIE SAS/SATA 8x6G SPC 8001 chip=0A=
+	  based host adapters.=0A=
+=0A=
 config SCSI_SRP=0A=
 	tristate "SCSI RDMA Protocol helper library"=0A=
 	depends on SCSI && PCI=0A=
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile=0A=
index 61a94af..f39fa61 100644=0A=
--- a/drivers/scsi/Makefile=0A=
+++ b/drivers/scsi/Makefile=0A=
@@ -70,6 +70,7 @@ obj-$(CONFIG_SCSI_AIC79XX)	+=3D aic7xxx/=0A=
 obj-$(CONFIG_SCSI_AACRAID)	+=3D aacraid/=0A=
 obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+=3D aic7xxx_old.o=0A=
 obj-$(CONFIG_SCSI_AIC94XX)	+=3D aic94xx/=0A=
+obj-$(CONFIG_SCSI_PM8001)	+=3D pm8001/=0A=
 obj-$(CONFIG_SCSI_IPS)		+=3D ips.o=0A=
 obj-$(CONFIG_SCSI_FD_MCS)	+=3D fd_mcs.o=0A=
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+=3D fdomain.o=0A=
diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile=0A=
new file mode 100644=0A=
index 0000000..52f0429=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/Makefile=0A=
@@ -0,0 +1,12 @@=0A=
+#=0A=
+# Kernel configuration file for the PM8001 SAS/SATA 8x6G based HBA =
driver=0A=
+#=0A=
+# Copyright (C) 2008-2009  USI Co., Ltd.=0A=
+=0A=
+=0A=
+obj-$(CONFIG_SCSI_PM8001) +=3D pm8001.o=0A=
+pm8001-y +=3D pm8001_init.o \=0A=
+		pm8001_sas.o  \=0A=
+		pm8001_ctl.o  \=0A=
+		pm8001_hwi.o=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_chips.h =
b/drivers/scsi/pm8001/pm8001_chips.h=0A=
new file mode 100644=0A=
index 0000000..b306929=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_chips.h=0A=
@@ -0,0 +1,89 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#ifndef _PM8001_CHIPS_H_=0A=
+#define _PM8001_CHIPS_H_=0A=
+=0A=
+#define READ_32(ADDR32, DMA_ADDR, OFFSET)	\=0A=
+	(*((u32 *)ADDR32)) =3D (*((u32 *)(((u8 *)DMA_ADDR) + (OFFSET))))=0A=
+=0A=
+#define WRITE_32(DMA_ADDR, OFFSET, VALUE32)	\=0A=
+	(*((u32 *)(((u8 *)DMA_ADDR)+(OFFSET)))) =3D (u32)(VALUE32)=0A=
+=0A=
+=0A=
+static inline u32 pm8001_cr32(struct pm8001_hba_info *pm8001_ha, u32 =
bar,=0A=
+		u32 addr)=0A=
+{=0A=
+	return readl(pm8001_ha->io_mem[bar].memvirtaddr + addr);=0A=
+}=0A=
+=0A=
+static inline void pm8001_cw32(struct pm8001_hba_info *pm8001_ha, u32 =
bar,=0A=
+		u32 addr, u32 val)=0A=
+{=0A=
+	writel(val, pm8001_ha->io_mem[bar].memvirtaddr + addr);=0A=
+}=0A=
+static inline u32 pm8001_mr32(dma_addr_t addr, u32 offset)=0A=
+{=0A=
+	return readl((void *)addr + offset);=0A=
+}=0A=
+static inline void pm8001_mw32(dma_addr_t addr, u32 offset, u32 val)=0A=
+{=0A=
+	writel(val, (void *)addr + offset);=0A=
+}=0A=
+static inline u32 get_pci_bar_index(u32 pcibar)=0A=
+{=0A=
+		switch (pcibar) {=0A=
+		case 0x10:=0A=
+		case 0x14:=0A=
+			return 0;=0A=
+		case 0x18:=0A=
+		case 0x1C:=0A=
+			return 1;=0A=
+		case 0x20:=0A=
+			return 2;=0A=
+		case 0x24:=0A=
+			return 3;=0A=
+		default:=0A=
+			return 0;=0A=
+	}=0A=
+}=0A=
+=0A=
+#endif  /* _PM8001_CHIPS_H_ */=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_ctl.c =
b/drivers/scsi/pm8001/pm8001_ctl.c=0A=
new file mode 100644=0A=
index 0000000..a2c9f93=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_ctl.c=0A=
@@ -0,0 +1,584 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+#include <linux/firmware.h>=0A=
+#include "pm8001_sas.h"=0A=
+#include "pm8001_ctl.h"=0A=
+=0A=
+/* scsi host attributes */=0A=
+=0A=
+/**=0A=
+ * pm8001_ctl_mpi_interface_rev_show - MPI interface revision number=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_mpi_interface_rev_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%d\n",=0A=
+	pm8001_ha->cfg_data.interface_rev);=0A=
+}=0A=
+static=0A=
+DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, =
NULL);=0A=
+=0A=
+/**=0A=
+ * pm8001_ctl_fw_version_show - firmware version=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_fw_version_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",=0A=
+	(pm8001_ha->cfg_data.firmware_rev & 0xFF000000) >> 24,=0A=
+	(pm8001_ha->cfg_data.firmware_rev & 0x00FF0000) >> 16,=0A=
+	(pm8001_ha->cfg_data.firmware_rev & 0x0000FF00) >> 8,=0A=
+	pm8001_ha->cfg_data.firmware_rev & 0x000000FF);=0A=
+}=0A=
+static DEVICE_ATTR(fw_version, S_IRUGO, pm8001_ctl_fw_version_show, =
NULL);=0A=
+/**=0A=
+ * pm8001_ctl_max_out_io_show - max outstanding io supported=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_max_out_io_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%d\n",=0A=
+	pm8001_ha->cfg_data.max_out_io);=0A=
+}=0A=
+static DEVICE_ATTR(max_out_io, S_IRUGO, pm8001_ctl_max_out_io_show, =
NULL);=0A=
+/**=0A=
+ * pm8001_ctl_max_devices_show - max devices support=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_max_devices_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%04d\n",=0A=
+	(pm8001_ha->cfg_data.max_sgl & 0xFFFF0000)>>16);=0A=
+}=0A=
+static DEVICE_ATTR(max_devices, S_IRUGO, pm8001_ctl_max_devices_show, =
NULL);=0A=
+/**=0A=
+ * pm8001_ctl_max_sg_list_show - max sg list supported iff not 0.0 for =
no=0A=
+ * hardware limitation=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_max_sg_list_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%04d\n",=0A=
+	pm8001_ha->cfg_data.max_sgl & 0x0000FFFF);=0A=
+}=0A=
+static DEVICE_ATTR(max_sg_list, S_IRUGO, pm8001_ctl_max_sg_list_show, =
NULL);=0A=
+=0A=
+#define SAS_1_0 0x1=0A=
+#define SAS_1_1 0x2=0A=
+#define SAS_2_0 0x4=0A=
+=0A=
+static ssize_t=0A=
+show_sas_spec_support_status(unsigned int mode, char *buf)=0A=
+{=0A=
+	ssize_t len =3D 0;=0A=
+=0A=
+	if (mode & SAS_1_1)=0A=
+		len =3D sprintf(buf, "%s", "SAS1.1");=0A=
+=0A=
+	if (mode & SAS_2_0)=0A=
+		len +=3D sprintf(buf + len, "%s%s", len ? ", " : "", "SAS2.0");=0A=
+=0A=
+	len +=3D sprintf(buf + len, "\n");=0A=
+=0A=
+	return len;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_ctl_sas_spec_support_show - sas spec supported=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_sas_spec_support_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	unsigned int mode;=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	mode =3D (pm8001_ha->cfg_data.ctrl_cap_flag & 0xfe000000)>>25;=0A=
+	return show_sas_spec_support_status(mode, buf);=0A=
+}=0A=
+static DEVICE_ATTR(sas_spec_support, S_IRUGO,=0A=
+		   pm8001_ctl_sas_spec_support_show, NULL);=0A=
+=0A=
+/**=0A=
+ * pm8001_ctl_sas_address_show - sas address=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * This is the controller sas address=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_host_sas_address_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",=0A=
+			be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));=0A=
+}=0A=
+static DEVICE_ATTR(host_sas_address, S_IRUGO,=0A=
+		   pm8001_ctl_host_sas_address_show, NULL);=0A=
+=0A=
+/**=0A=
+ * pm8001_ctl_logging_level_show - logging level=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read/write' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_logging_level_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "%08xh\n", pm8001_ha->logging_level);=0A=
+}=0A=
+static ssize_t pm8001_ctl_logging_level_store(struct device *cdev,=0A=
+	struct device_attribute *attr, const char *buf, size_t count)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	int val =3D 0;=0A=
+=0A=
+	if (sscanf(buf, "%x", &val) !=3D 1)=0A=
+		return -EINVAL;=0A=
+=0A=
+	pm8001_ha->logging_level =3D val;=0A=
+	return strlen(buf);=0A=
+}=0A=
+=0A=
+static DEVICE_ATTR(logging_level, S_IRUGO | S_IWUSR,=0A=
+	pm8001_ctl_logging_level_show, pm8001_ctl_logging_level_store);=0A=
+/**=0A=
+ * pm8001_ctl_aap_log_show - aap1 event log=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	int i;=0A=
+	char *str =3D buf;=0A=
+	int max =3D 2;=0A=
+	for (i =3D 0; i < max; i++) {=0A=
+		str +=3D sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"=0A=
+			       "0x%08x 0x%08x\n",=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr +=0A=
+		i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 4 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 8 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 12 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 16 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 20 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 24 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr=0A=
+		+ 28 + i * 32));=0A=
+	}=0A=
+=0A=
+	return str - buf;=0A=
+}=0A=
+static DEVICE_ATTR(aap_log, S_IRUGO, pm8001_ctl_aap_log_show, NULL);=0A=
+/**=0A=
+ * pm8001_ctl_aap_log_show - IOP event log=0A=
+ * @cdev - pointer to embedded class device=0A=
+ * @buf - the buffer returned=0A=
+ *=0A=
+ * A sysfs 'read-only' shost attribute.=0A=
+ */=0A=
+static ssize_t pm8001_ctl_iop_log_show(struct device *cdev,=0A=
+	struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	int i;=0A=
+	char *str =3D buf;=0A=
+	int max =3D 2;=0A=
+	for (i =3D 0; i < max; i++) {=0A=
+		str +=3D sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x"=0A=
+			       "0x%08x 0x%08x\n",=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 4 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 8 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 12 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 16 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 20 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 24 + i * 32),=0A=
+		*(u32 *)((u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr=0A=
+		+ 28 + i * 32));=0A=
+	}=0A=
+=0A=
+	return str - buf;=0A=
+}=0A=
+static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);=0A=
+=0A=
+#define FLASH_CMD_NONE      0x00=0A=
+#define FLASH_CMD_UPDATE    0x01=0A=
+#define FLASH_CMD_SET_NVMD    0x02=0A=
+=0A=
+struct flash_command {=0A=
+     u8      command[8];=0A=
+     int     code;=0A=
+};=0A=
+=0A=
+static struct flash_command flash_command_table[] =3D=0A=
+{=0A=
+     {"set_nvmd",    FLASH_CMD_SET_NVMD},=0A=
+     {"update",      FLASH_CMD_UPDATE},=0A=
+     {"",            FLASH_CMD_NONE} /* Last entry should be NULL. */=0A=
+};=0A=
+=0A=
+struct error_fw {=0A=
+     char    *reason;=0A=
+     int     err_code;=0A=
+};=0A=
+=0A=
+static struct error_fw flash_error_table[] =3D=0A=
+{=0A=
+     {"Failed to open fw image file",	FAIL_OPEN_BIOS_FILE},=0A=
+     {"image header mismatch",		FLASH_UPDATE_HDR_ERR},=0A=
+     {"image offset mismatch",		FLASH_UPDATE_OFFSET_ERR},=0A=
+     {"image CRC Error",		FLASH_UPDATE_CRC_ERR},=0A=
+     {"image length Error.",		FLASH_UPDATE_LENGTH_ERR},=0A=
+     {"Failed to program flash chip",	FLASH_UPDATE_HW_ERR},=0A=
+     {"Flash chip not supported.",	FLASH_UPDATE_DNLD_NOT_SUPPORTED},=0A=
+     {"Flash update disabled.",		FLASH_UPDATE_DISABLED},=0A=
+     {"Flash in progress",		FLASH_IN_PROGRESS},=0A=
+     {"Image file size Error",		FAIL_FILE_SIZE},=0A=
+     {"Input parameter error",		FAIL_PARAMETERS},=0A=
+     {"Out of memory",			FAIL_OUT_MEMORY},=0A=
+     {"OK", 0}	/* Last entry err_code =3D 0. */=0A=
+};=0A=
+=0A=
+static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	struct pm8001_ioctl_payload	*payload;=0A=
+	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	u8		*ioctlbuffer =3D NULL;=0A=
+	u32		length =3D 0;=0A=
+	u32		ret =3D 0;=0A=
+=0A=
+	length =3D 1024 * 5 + sizeof(*payload) - 1;=0A=
+	ioctlbuffer =3D kzalloc(length, GFP_KERNEL);=0A=
+	if (!ioctlbuffer)=0A=
+		return -ENOMEM;=0A=
+	if ((pm8001_ha->fw_image->size <=3D 0) ||=0A=
+	    (pm8001_ha->fw_image->size > 4096)) {=0A=
+		ret =3D FAIL_FILE_SIZE;=0A=
+		goto out;=0A=
+	}=0A=
+	payload =3D (struct pm8001_ioctl_payload *)ioctlbuffer;=0A=
+	memcpy((u8 *)payload->func_specific, (u8 *)pm8001_ha->fw_image->data,=0A=
+				pm8001_ha->fw_image->size);=0A=
+	payload->length =3D pm8001_ha->fw_image->size;=0A=
+	payload->id =3D 0;=0A=
+	pm8001_ha->nvmd_completion =3D &completion;=0A=
+	ret =3D PM8001_CHIP_DISP->set_nvmd_req(pm8001_ha, payload);=0A=
+	wait_for_completion(&completion);=0A=
+out:=0A=
+	kfree(ioctlbuffer);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	struct pm8001_ioctl_payload	*payload;=0A=
+	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	u8		*ioctlbuffer =3D NULL;=0A=
+	u32		length =3D 0;=0A=
+	struct fw_control_info	*fwControl;=0A=
+	u32		loopNumber, loopcount =3D 0;=0A=
+	u32		sizeRead =3D 0;=0A=
+	u32		partitionSize, partitionSizeTmp;=0A=
+	u32		ret =3D 0;=0A=
+	u32		partitionNumber =3D 0;=0A=
+	struct pm8001_fw_image_header *image_hdr;=0A=
+=0A=
+	length =3D 1024 * 16 + sizeof(*payload) - 1;=0A=
+	ioctlbuffer =3D kzalloc(length, GFP_KERNEL);=0A=
+	image_hdr =3D (struct pm8001_fw_image_header =
*)pm8001_ha->fw_image->data;=0A=
+	if (!ioctlbuffer)=0A=
+		return -ENOMEM;=0A=
+	if (pm8001_ha->fw_image->size < 28) {=0A=
+		ret =3D FAIL_FILE_SIZE;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	while (sizeRead < pm8001_ha->fw_image->size) {=0A=
+		partitionSizeTmp =3D=0A=
+			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);=0A=
+		partitionSize =3D be32_to_cpu(partitionSizeTmp);=0A=
+		loopcount =3D (partitionSize + HEADER_LEN)/IOCTL_BUF_SIZE;=0A=
+		if (loopcount % IOCTL_BUF_SIZE)=0A=
+			loopcount++;=0A=
+		if (loopcount =3D=3D 0)=0A=
+			loopcount++;=0A=
+		for (loopNumber =3D 0; loopNumber < loopcount; loopNumber++) {=0A=
+			payload =3D (struct pm8001_ioctl_payload *)ioctlbuffer;=0A=
+			payload->length =3D 1024*16;=0A=
+			payload->id =3D 0;=0A=
+			fwControl =3D=0A=
+			      (struct fw_control_info *)payload->func_specific;=0A=
+			fwControl->len =3D IOCTL_BUF_SIZE;   /* IN */=0A=
+			fwControl->size =3D partitionSize + HEADER_LEN;/* IN */=0A=
+			fwControl->retcode =3D 0;/* OUT */=0A=
+			fwControl->offset =3D loopNumber * IOCTL_BUF_SIZE;/*OUT */=0A=
+=0A=
+		/* for the last chunk of data in case file size is not even with=0A=
+		4k, load only the rest*/=0A=
+		if (((loopcount-loopNumber) =3D=3D 1) &&=0A=
+			((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {=0A=
+			fwControl->len =3D=0A=
+				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;=0A=
+			memcpy((u8 *)fwControl->buffer,=0A=
+				(u8 *)pm8001_ha->fw_image->data + sizeRead,=0A=
+				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE);=0A=
+			sizeRead +=3D=0A=
+				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;=0A=
+		} else {=0A=
+			memcpy((u8 *)fwControl->buffer,=0A=
+				(u8 *)pm8001_ha->fw_image->data + sizeRead,=0A=
+				IOCTL_BUF_SIZE);=0A=
+			sizeRead +=3D IOCTL_BUF_SIZE;=0A=
+		}=0A=
+=0A=
+		pm8001_ha->nvmd_completion =3D &completion;=0A=
+		ret =3D PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);=0A=
+		wait_for_completion(&completion);=0A=
+		if (ret || (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS)) {=0A=
+			ret =3D fwControl->retcode;=0A=
+			kfree(ioctlbuffer);=0A=
+			ioctlbuffer =3D NULL;=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	if (ret)=0A=
+		break;=0A=
+	partitionNumber++;=0A=
+}=0A=
+out:=0A=
+	kfree(ioctlbuffer);=0A=
+	return ret;=0A=
+}=0A=
+static ssize_t pm8001_store_update_fw(struct device *cdev,=0A=
+				      struct device_attribute *attr,=0A=
+				      const char *buf, size_t count)=0A=
+{=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	char *cmd_ptr, *filename_ptr;=0A=
+	int res, i;=0A=
+	int flash_command =3D FLASH_CMD_NONE;=0A=
+	int err =3D 0;=0A=
+	if (!capable(CAP_SYS_ADMIN))=0A=
+		return -EACCES;=0A=
+=0A=
+	cmd_ptr =3D kzalloc(count*2, GFP_KERNEL);=0A=
+=0A=
+	if (!cmd_ptr) {=0A=
+		err =3D FAIL_OUT_MEMORY;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	filename_ptr =3D cmd_ptr + count;=0A=
+	res =3D sscanf(buf, "%s %s", cmd_ptr, filename_ptr);=0A=
+	if (res !=3D 2) {=0A=
+		err =3D FAIL_PARAMETERS;=0A=
+		goto out1;=0A=
+	}=0A=
+=0A=
+	for (i =3D 0; flash_command_table[i].code !=3D FLASH_CMD_NONE; i++) {=0A=
+		if (!memcmp(flash_command_table[i].command,=0A=
+				 cmd_ptr, strlen(cmd_ptr))) {=0A=
+			flash_command =3D flash_command_table[i].code;=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	if (flash_command =3D=3D FLASH_CMD_NONE) {=0A=
+		err =3D FAIL_PARAMETERS;=0A=
+		goto out1;=0A=
+	}=0A=
+=0A=
+	if (pm8001_ha->fw_status =3D=3D FLASH_IN_PROGRESS) {=0A=
+		err =3D FLASH_IN_PROGRESS;=0A=
+		goto out1;=0A=
+	}=0A=
+	err =3D request_firmware(&pm8001_ha->fw_image,=0A=
+			       filename_ptr,=0A=
+			       pm8001_ha->dev);=0A=
+=0A=
+	if (err) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("Failed to load firmware image file %s,"=0A=
+			" error %d\n", filename_ptr, err));=0A=
+		err =3D FAIL_OPEN_BIOS_FILE;=0A=
+		goto out1;=0A=
+	}=0A=
+=0A=
+	switch (flash_command) {=0A=
+	case FLASH_CMD_UPDATE:=0A=
+		pm8001_ha->fw_status =3D FLASH_IN_PROGRESS;=0A=
+		err =3D pm8001_update_flash(pm8001_ha);=0A=
+		break;=0A=
+	case FLASH_CMD_SET_NVMD:=0A=
+		pm8001_ha->fw_status =3D FLASH_IN_PROGRESS;=0A=
+		err =3D pm8001_set_nvmd(pm8001_ha);=0A=
+		break;=0A=
+	default:=0A=
+		pm8001_ha->fw_status =3D FAIL_PARAMETERS;=0A=
+		break;=0A=
+	}=0A=
+	release_firmware(pm8001_ha->fw_image);=0A=
+out1:=0A=
+	kfree(cmd_ptr);=0A=
+out:=0A=
+	pm8001_ha->fw_status =3D err;=0A=
+=0A=
+	if (!err)=0A=
+		return count;=0A=
+	else=0A=
+		return -err;=0A=
+}=0A=
+=0A=
+static ssize_t pm8001_show_update_fw(struct device *cdev,=0A=
+				     struct device_attribute *attr, char *buf)=0A=
+{=0A=
+	int i;=0A=
+	struct Scsi_Host *shost =3D class_to_shost(cdev);=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+=0A=
+	for (i =3D 0; flash_error_table[i].err_code !=3D 0; i++) {=0A=
+		if (flash_error_table[i].err_code =3D=3D pm8001_ha->fw_status)=0A=
+			break;=0A=
+	}=0A=
+	if (pm8001_ha->fw_status !=3D FLASH_IN_PROGRESS)=0A=
+		pm8001_ha->fw_status =3D FLASH_OK;=0A=
+=0A=
+	return snprintf(buf, PAGE_SIZE, "status=3D%x %s\n",=0A=
+			flash_error_table[i].err_code,=0A=
+			flash_error_table[i].reason);=0A=
+}=0A=
+=0A=
+static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,=0A=
+	pm8001_show_update_fw, pm8001_store_update_fw);=0A=
+struct device_attribute *pm8001_host_attrs[] =3D {=0A=
+	&dev_attr_interface_rev,=0A=
+	&dev_attr_fw_version,=0A=
+	&dev_attr_update_fw,=0A=
+	&dev_attr_aap_log,=0A=
+	&dev_attr_iop_log,=0A=
+	&dev_attr_max_out_io,=0A=
+	&dev_attr_max_devices,=0A=
+	&dev_attr_max_sg_list,=0A=
+	&dev_attr_sas_spec_support,=0A=
+	&dev_attr_logging_level,=0A=
+	&dev_attr_host_sas_address,=0A=
+	NULL,=0A=
+};=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h =
b/drivers/scsi/pm8001/pm8001_ctl.h=0A=
new file mode 100644=0A=
index 0000000..22644de=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_ctl.h=0A=
@@ -0,0 +1,67 @@=0A=
+ /*=0A=
+  * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+  *=0A=
+  * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+  * All rights reserved.=0A=
+  *=0A=
+  * Redistribution and use in source and binary forms, with or without=0A=
+  * modification, are permitted provided that the following conditions=0A=
+  * are met:=0A=
+  * 1. Redistributions of source code must retain the above copyright=0A=
+  *    notice, this list of conditions, and the following disclaimer,=0A=
+  *    without modification.=0A=
+  * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+  *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+  *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+  *    including a substantially similar Disclaimer requirement for =
further=0A=
+  *    binary redistribution.=0A=
+  * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+  *    of any contributors may be used to endorse or promote products =
derived=0A=
+  *    from this software without specific prior written permission.=0A=
+  *=0A=
+  * Alternatively, this software may be distributed under the terms of =
the=0A=
+  * GNU General Public License ("GPL") version 2 as published by the =
Free=0A=
+  * Software Foundation.=0A=
+  *=0A=
+  * NO WARRANTY=0A=
+  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+  * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS =
FOR=0A=
+  * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+  * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+  * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS =
INTERRUPTION)=0A=
+  * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+  * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) =
ARISING=0A=
+  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+  * POSSIBILITY OF SUCH DAMAGES.=0A=
+  *=0A=
+  */=0A=
+=0A=
+#ifndef PM8001_CTL_H_INCLUDED=0A=
+#define PM8001_CTL_H_INCLUDED=0A=
+=0A=
+#define IOCTL_BUF_SIZE		4096=0A=
+#define HEADER_LEN			28=0A=
+#define SIZE_OFFSET			16=0A=
+=0A=
+struct pm8001_ioctl_payload {=0A=
+	u32	signature;=0A=
+	u16	major_function;=0A=
+	u16	minor_function;=0A=
+	u16	length;=0A=
+	u16	status;=0A=
+	u16	offset;=0A=
+	u16	id;=0A=
+	u8	func_specific[1];=0A=
+};=0A=
+=0A=
+#define FLASH_OK                        0x000000=0A=
+#define FAIL_OPEN_BIOS_FILE             0x000100=0A=
+#define FAIL_FILE_SIZE                  0x000a00=0A=
+#define FAIL_PARAMETERS                 0x000b00=0A=
+#define FAIL_OUT_MEMORY                 0x000c00=0A=
+#define FLASH_IN_PROGRESS               0x001000=0A=
+=0A=
+#endif /* PM8001_CTL_H_INCLUDED */=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_defs.h =
b/drivers/scsi/pm8001/pm8001_defs.h=0A=
new file mode 100644=0A=
index 0000000..bb3be05=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_defs.h=0A=
@@ -0,0 +1,114 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#ifndef _PM8001_DEFS_H_=0A=
+#define _PM8001_DEFS_H_=0A=
+=0A=
+enum chip_flavors {=0A=
+	chip_8001,=0A=
+};=0A=
+#define USI_MAX_MEMCNT			9=0A=
+#define PM8001_MAX_DMA_SG		SG_ALL=0A=
+=0A=
+#define	PHY_SPEED_60			0x04=0A=
+#define	PHY_SPEED_30			0x02=0A=
+#define	PHY_SPEED_15			0x01=0A=
+=0A=
+#define  DATA_DIR_BYRECIPIENT		4	/* UNSPECIFIED */=0A=
+#define  DATA_DIR_OUT			2	/* OUTBOUND */=0A=
+#define  DATA_DIR_IN			1	/* INBOUND */=0A=
+#define  DATA_DIR_NONE			0	/* NO TRANSFER */=0A=
+#if (BITS_PER_LONG =3D=3D 64)=0A=
+#define LOW_32_BITS(addr)	(u32)(addr & 0xffffffff)=0A=
+#define HIGH_32_BITS(addr)	(u32)((addr >> 32) & 0xffffffff)=0A=
+#else=0A=
+#define LOW_32_BITS(addr)	(u32)addr=0A=
+#define HIGH_32_BITS(addr)	0=0A=
+#endif=0A=
+enum port_type {=0A=
+	PORT_TYPE_SAS =3D (1L << 1),=0A=
+	PORT_TYPE_SATA =3D (1L << 0),=0A=
+};=0A=
+=0A=
+/* driver compile-time configuration */=0A=
+enum driver_configuration {=0A=
+	PM8001_MAX_CCB		=3D 512,	/* max ccbs supported */=0A=
+	PM8001_MAX_INB_NUM	=3D 1,=0A=
+	PM8001_MAX_OUTB_NUM	=3D 1,=0A=
+	PM8001_CAN_QUEUE	=3D 128,	/* SCSI Queue depth */=0A=
+};=0A=
+=0A=
+/* unchangeable hardware details */=0A=
+enum hardware_details {=0A=
+	PM8001_MAX_PHYS		=3D 8,	/* max. possible phys */=0A=
+	PM8001_MAX_PORTS	=3D 8,	/* max. possible ports */=0A=
+	PM8001_MAX_DEVICES	=3D 1024,	/* max supported device */=0A=
+};=0A=
+#define AAP1			0x00=0A=
+#define IOP			0x01=0A=
+#define  CI			0x02=0A=
+#define  PI			0x03=0A=
+#define  IB			0x04=0A=
+#define  OB			0x05=0A=
+#define  NVMD			0x06=0A=
+#define  DEV_MEM		0x07=0A=
+#define  CCB_MEM		0x08=0A=
+=0A=
+ /*error code*/=0A=
+#define MPI_IO_STATUS_SUCCESS	0=0A=
+#define MPI_IO_STATUS_BUSY	1=0A=
+#define MPI_IO_STATUS_FAIL	-1=0A=
+/**=0A=
+ * Phy Control constants=0A=
+ */=0A=
+#define PHY_LINK_RESET			0x01=0A=
+#define PHY_HARD_RESET			0x02=0A=
+#define PHY_GET_ERROR_COUNTS		0x03=0A=
+#define PHY_CLEAR_ERROR_COUNTS		0x04=0A=
+#define PHY_NOTIFY_ENABLE_SPINUP	0x10=0A=
+#define PHY_BROADCAST_ASYNCH_EVENT	0x12=0A=
+#define PHY_COMINIT_OOB			0x20=0A=
+=0A=
+enum pm8001_hba_info_flags {=0A=
+	PM8001F_INIT_TIME		=3D (1U << 0),=0A=
+	PM8001F_RUN_TIME		=3D (1U << 1),=0A=
+};=0A=
+=0A=
+#endif=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
new file mode 100644=0A=
index 0000000..93728ca=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -0,0 +1,4288 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+ #include "pm8001_sas.h"=0A=
+ #include "pm8001_hwi.h"=0A=
+ #include "pm8001_chips.h"=0A=
+ #include "pm8001_ctl.h"=0A=
+=0A=
+/**=0A=
+ * read_main_config_table - read the configure table and update it to =
hba=0A=
+ * structure.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	dma_addr_t address =3D pm8001_ha->cfg_addr;=0A=
+	pm8001_ha->cfg_data.signature		=3D pm8001_mr32(address, 0x00);=0A=
+	pm8001_ha->cfg_data.interface_rev	=3D pm8001_mr32(address, 0x04);=0A=
+	pm8001_ha->cfg_data.firmware_rev	=3D pm8001_mr32(address, 0x08);=0A=
+	pm8001_ha->cfg_data.max_out_io		=3D pm8001_mr32(address, 0x0C);=0A=
+	pm8001_ha->cfg_data.max_sgl		=3D pm8001_mr32(address, 0x10);=0A=
+	pm8001_ha->cfg_data.ctrl_cap_flag	=3D pm8001_mr32(address, 0x14);=0A=
+	pm8001_ha->cfg_data.gst_offset		=3D pm8001_mr32(address, 0x18);=0A=
+	pm8001_ha->cfg_data.inbound_queue_offset =3D pm8001_mr32(address, =
0x1C);=0A=
+	pm8001_ha->cfg_data.outbound_queue_offset =3D pm8001_mr32(address, =
0x20);=0A=
+	pm8001_ha->cfg_data.hda_mode_flag	=3D=0A=
+		pm8001_mr32(address, MAIN_HDA_FLAGS_OFFSET);=0A=
+=0A=
+	/* read analog Setting offset from the configuration table */=0A=
+	pm8001_ha->cfg_data.anolog_setup_table_offset =3D=0A=
+		pm8001_mr32(address, MAIN_ANALOG_SETUP_OFFSET);=0A=
+=0A=
+	/* read Error Dump Offset and Length */=0A=
+	pm8001_ha->cfg_data.fatal_err_dump_offset0 =3D=0A=
+		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_OFFSET);=0A=
+	pm8001_ha->cfg_data.fatal_err_dump_length0 =3D=0A=
+		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP0_LENGTH);=0A=
+	pm8001_ha->cfg_data.fatal_err_dump_offset1 =3D=0A=
+		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_OFFSET);=0A=
+	pm8001_ha->cfg_data.fatal_err_dump_length1 =3D=0A=
+		pm8001_mr32(address, MAIN_FATAL_ERROR_RDUMP1_LENGTH);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * read_general_status_table - read the general status table and update =
it to=0A=
+ * hba structure.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void read_general_status_table(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	dma_addr_t address =3D pm8001_ha->gst_addr;=0A=
+	pm8001_ha->gst_data.gst_len_mpistate	=3D pm8001_mr32(address, 0x00);=0A=
+	pm8001_ha->gst_data.iq_freeze_state0	=3D pm8001_mr32(address, 0x04);=0A=
+	pm8001_ha->gst_data.iq_freeze_state1	=3D pm8001_mr32(address, 0x08);=0A=
+	pm8001_ha->gst_data.msgu_tcnt		=3D pm8001_mr32(address, 0x0C);=0A=
+	pm8001_ha->gst_data.iop_tcnt		=3D pm8001_mr32(address, 0x10);=0A=
+	pm8001_ha->gst_data.reserved		=3D pm8001_mr32(address, 0x14);=0A=
+	pm8001_ha->gst_data.phy_state[0]	=3D pm8001_mr32(address, 0x18);=0A=
+	pm8001_ha->gst_data.phy_state[1]	=3D pm8001_mr32(address, 0x1C);=0A=
+	pm8001_ha->gst_data.phy_state[2]	=3D pm8001_mr32(address, 0x20);=0A=
+	pm8001_ha->gst_data.phy_state[3]	=3D pm8001_mr32(address, 0x24);=0A=
+	pm8001_ha->gst_data.phy_state[4]	=3D pm8001_mr32(address, 0x28);=0A=
+	pm8001_ha->gst_data.phy_state[5]	=3D pm8001_mr32(address, 0x2C);=0A=
+	pm8001_ha->gst_data.phy_state[6]	=3D pm8001_mr32(address, 0x30);=0A=
+	pm8001_ha->gst_data.phy_state[7]	=3D pm8001_mr32(address, 0x34);=0A=
+	pm8001_ha->gst_data.reserved1		=3D pm8001_mr32(address, 0x38);=0A=
+	pm8001_ha->gst_data.reserved2		=3D pm8001_mr32(address, 0x3C);=0A=
+	pm8001_ha->gst_data.reserved3		=3D pm8001_mr32(address, 0x40);=0A=
+	pm8001_ha->gst_data.recover_err_info[0]	=3D pm8001_mr32(address, 0x44);=0A=
+	pm8001_ha->gst_data.recover_err_info[1]	=3D pm8001_mr32(address, 0x48);=0A=
+	pm8001_ha->gst_data.recover_err_info[2]	=3D pm8001_mr32(address, 0x4C);=0A=
+	pm8001_ha->gst_data.recover_err_info[3]	=3D pm8001_mr32(address, 0x50);=0A=
+	pm8001_ha->gst_data.recover_err_info[4]	=3D pm8001_mr32(address, 0x54);=0A=
+	pm8001_ha->gst_data.recover_err_info[5]	=3D pm8001_mr32(address, 0x58);=0A=
+	pm8001_ha->gst_data.recover_err_info[6]	=3D pm8001_mr32(address, 0x5C);=0A=
+	pm8001_ha->gst_data.recover_err_info[7]	=3D pm8001_mr32(address, 0x60);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * read_inbound_queue_table - read the inbound queue table and update =
it to hba=0A=
+ * structure.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void read_inbound_queue_table(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	int inbQ_num =3D 1;=0A=
+	u32 offset;=0A=
+	int i;=0A=
+	dma_addr_t address =3D pm8001_ha->inb_addr;=0A=
+	for (i =3D 0; i < inbQ_num; i++) {=0A=
+		offset =3D i * 0x24;=0A=
+		pm8001_ha->inb_data[i].pi_pci_bar =3D=0A=
+		get_pci_bar_index(pm8001_mr32(address, (offset + 0x14)));=0A=
+		pm8001_ha->inb_data[i].pi_offset =3D=0A=
+		pm8001_mr32(address, (offset + 0x18));=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * read_outbound_queue_table - read the outbound queue table and update =
it to=0A=
+ * hba structure.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void read_outbound_queue_table(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	int outbQ_num =3D 1;=0A=
+	u32 offset;=0A=
+	int i;=0A=
+	dma_addr_t address =3D pm8001_ha->outb_addr;=0A=
+	for (i =3D 0; i < outbQ_num; i++) {=0A=
+		offset =3D i * 0x24;=0A=
+		pm8001_ha->outb_data[i].ci_pci_bar =3D=0A=
+		get_pci_bar_index(pm8001_mr32(address, (offset + 0x14)));=0A=
+		pm8001_ha->outb_data[i].ci_offset =3D=0A=
+		pm8001_mr32(address, (offset + 0x18));=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * init_default_table_values - init the default table.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void  init_default_table_values(struct pm8001_hba_info =
*pm8001_ha)=0A=
+{=0A=
+	int qn =3D 1;=0A=
+	int i;=0A=
+	u32 offsetib, offsetob;=0A=
+	dma_addr_t addressib =3D pm8001_ha->inb_addr;=0A=
+	dma_addr_t addressob =3D pm8001_ha->outb_addr;=0A=
+=0A=
+	pm8001_ha->cfg_data.inbound_q_nppd_hppd			=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_hw_event_pid0_3 		=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_hw_event_pid4_7		=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_ncq_event_pid0_3		=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_ncq_event_pid4_7		=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_ITNexus_event_pid0_3	=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_ITNexus_event_pid4_7	=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_ssp_event_pid0_3	=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_ssp_event_pid4_7	=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_smp_event_pid0_3	=3D 0;=0A=
+	pm8001_ha->cfg_data.outbound_tgt_smp_event_pid4_7	=3D 0;=0A=
+=0A=
+	pm8001_ha->cfg_data.upper_event_log_addr		=3D=0A=
+		pm8001_ha->memoryMap.region[AAP1].phys_addr_hi;=0A=
+	pm8001_ha->cfg_data.lower_event_log_addr		=3D=0A=
+		pm8001_ha->memoryMap.region[AAP1].phys_addr_lo;=0A=
+	pm8001_ha->cfg_data.event_log_size			=3D 128*1024;=0A=
+	pm8001_ha->cfg_data.event_log_option			=3D 0x01;=0A=
+	pm8001_ha->cfg_data.upper_iop_event_log_addr		=3D=0A=
+		pm8001_ha->memoryMap.region[IOP].phys_addr_hi;=0A=
+	pm8001_ha->cfg_data.lower_iop_event_log_addr		=3D=0A=
+		pm8001_ha->memoryMap.region[IOP].phys_addr_lo;=0A=
+	pm8001_ha->cfg_data.iop_event_log_size			=3D 128*1024;=0A=
+	pm8001_ha->cfg_data.iop_event_log_option		=3D 0x01;=0A=
+	pm8001_ha->cfg_data.fatal_err_interrupt			=3D 0x01;=0A=
+	for (i =3D 0; i < qn; i++) {=0A=
+		pm8001_ha->inb_data[i].element_pri_size_cnt	=3D=0A=
+			0x00000100 | (0x00000040 << 16) | (0x00<<30);=0A=
+		pm8001_ha->inb_data[i].upper_base_addr		=3D=0A=
+			pm8001_ha->memoryMap.region[IB].phys_addr_hi;=0A=
+		pm8001_ha->inb_data[i].lower_base_addr		=3D=0A=
+		pm8001_ha->memoryMap.region[IB].phys_addr_lo;=0A=
+		pm8001_ha->inb_data[i].base_virt		=3D=0A=
+			(u8 *)pm8001_ha->memoryMap.region[IB].virt_ptr;=0A=
+		pm8001_ha->inb_data[i].total_length		=3D=0A=
+			pm8001_ha->memoryMap.region[IB].total_len;=0A=
+		pm8001_ha->inb_data[i].ci_upper_base_addr	=3D=0A=
+			pm8001_ha->memoryMap.region[CI].phys_addr_hi;=0A=
+		pm8001_ha->inb_data[i].ci_lower_base_addr	=3D=0A=
+			pm8001_ha->memoryMap.region[CI].phys_addr_lo;=0A=
+		pm8001_ha->inb_data[i].ci_virt			=3D=0A=
+			(u8 *)pm8001_ha->memoryMap.region[CI].virt_ptr;=0A=
+		offsetib =3D i * 0x20;=0A=
+		pm8001_ha->inb_data[i].pi_pci_bar		=3D=0A=
+			get_pci_bar_index(pm8001_mr32(addressib,=0A=
+				(offsetib + 0x14)));=0A=
+		pm8001_ha->inb_data[i].pi_offset		=3D=0A=
+			pm8001_mr32(addressib, (offsetib + 0x18));=0A=
+		pm8001_ha->inb_data[i].producer_idx		=3D 0;=0A=
+		pm8001_ha->inb_data[i].consumer_index		=3D 0;=0A=
+	}=0A=
+	for (i =3D 0; i < qn; i++) {=0A=
+		pm8001_ha->outb_data[i].element_size_cnt	=3D=0A=
+			256 | (64 << 16) | (1<<30);=0A=
+		pm8001_ha->outb_data[i].upper_base_addr		=3D=0A=
+			pm8001_ha->memoryMap.region[OB].phys_addr_hi;=0A=
+		pm8001_ha->outb_data[i].lower_base_addr		=3D=0A=
+			pm8001_ha->memoryMap.region[OB].phys_addr_lo;=0A=
+		pm8001_ha->outb_data[i].base_virt		=3D=0A=
+			(u8 *)pm8001_ha->memoryMap.region[OB].virt_ptr;=0A=
+		pm8001_ha->outb_data[i].total_length		=3D=0A=
+			pm8001_ha->memoryMap.region[OB].total_len;=0A=
+		pm8001_ha->outb_data[i].pi_upper_base_addr	=3D=0A=
+			pm8001_ha->memoryMap.region[PI].phys_addr_hi;=0A=
+		pm8001_ha->outb_data[i].pi_lower_base_addr	=3D=0A=
+			pm8001_ha->memoryMap.region[PI].phys_addr_lo;=0A=
+		pm8001_ha->outb_data[i].interrup_vec_cnt_delay	=3D=0A=
+			0 | (0 << 16) | (0 << 24);=0A=
+		pm8001_ha->outb_data[i].pi_virt			=3D=0A=
+			(u8 *)pm8001_ha->memoryMap.region[PI].virt_ptr;=0A=
+		offsetob =3D i * 0x24;=0A=
+		pm8001_ha->outb_data[i].ci_pci_bar		=3D=0A=
+			get_pci_bar_index(pm8001_mr32(addressob,=0A=
+			offsetob + 0x14));=0A=
+		pm8001_ha->outb_data[i].ci_offset		=3D=0A=
+			pm8001_mr32(addressob, (offsetob + 0x18));=0A=
+		pm8001_ha->outb_data[i].consumer_idx		=3D 0;=0A=
+		pm8001_ha->outb_data[i].producer_index		=3D 0;=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * update_main_config_table - update the main default table to the HBA.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	dma_addr_t address =3D pm8001_ha->cfg_addr;=0A=
+	pm8001_mw32(address, 0x24, pm8001_ha->cfg_data.inbound_q_nppd_hppd);=0A=
+	pm8001_mw32(address, 0x28,=0A=
+		pm8001_ha->cfg_data.outbound_hw_event_pid0_3);=0A=
+	pm8001_mw32(address, 0x2C,=0A=
+		pm8001_ha->cfg_data.outbound_hw_event_pid4_7);=0A=
+	pm8001_mw32(address, 0x30,=0A=
+		pm8001_ha->cfg_data.outbound_ncq_event_pid0_3);=0A=
+	pm8001_mw32(address, 0x34,=0A=
+		pm8001_ha->cfg_data.outbound_ncq_event_pid4_7);=0A=
+	pm8001_mw32(address, 0x38,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_ITNexus_event_pid0_3);=0A=
+	pm8001_mw32(address, 0x3C,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_ITNexus_event_pid4_7);=0A=
+	pm8001_mw32(address, 0x40,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_ssp_event_pid0_3);=0A=
+	pm8001_mw32(address, 0x44,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_ssp_event_pid4_7);=0A=
+	pm8001_mw32(address, 0x48,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_smp_event_pid0_3);=0A=
+	pm8001_mw32(address, 0x4C,=0A=
+		pm8001_ha->cfg_data.outbound_tgt_smp_event_pid4_7);=0A=
+	pm8001_mw32(address, 0x50,=0A=
+		pm8001_ha->cfg_data.upper_event_log_addr);=0A=
+	pm8001_mw32(address, 0x54, pm8001_ha->cfg_data.lower_event_log_addr);=0A=
+	pm8001_mw32(address, 0x58, pm8001_ha->cfg_data.event_log_size);=0A=
+	pm8001_mw32(address, 0x5C, pm8001_ha->cfg_data.event_log_option);=0A=
+	pm8001_mw32(address, 0x60,=0A=
+		pm8001_ha->cfg_data.upper_iop_event_log_addr);=0A=
+	pm8001_mw32(address, 0x64,=0A=
+		pm8001_ha->cfg_data.lower_iop_event_log_addr);=0A=
+	pm8001_mw32(address, 0x68, pm8001_ha->cfg_data.iop_event_log_size);=0A=
+	pm8001_mw32(address, 0x6C, pm8001_ha->cfg_data.iop_event_log_option);=0A=
+	pm8001_mw32(address, 0x70, pm8001_ha->cfg_data.fatal_err_interrupt);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * update_inbound_queue_table - update the inbound queue table to the =
HBA.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+update_inbound_queue_table(struct pm8001_hba_info *pm8001_ha, int =
number)=0A=
+{=0A=
+	dma_addr_t address =3D pm8001_ha->inb_addr;=0A=
+	u16 offset =3D number * 0x20;=0A=
+	pm8001_mw32(address, offset + 0x00,=0A=
+		pm8001_ha->inb_data[number].element_pri_size_cnt);=0A=
+	pm8001_mw32(address, offset + 0x04,=0A=
+		pm8001_ha->inb_data[number].upper_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x08,=0A=
+		pm8001_ha->inb_data[number].lower_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x0C,=0A=
+		pm8001_ha->inb_data[number].ci_upper_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x10,=0A=
+		pm8001_ha->inb_data[number].ci_lower_base_addr);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * update_outbound_queue_table - update the outbound queue table to the =
HBA.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+update_outbound_queue_table(struct pm8001_hba_info *pm8001_ha, int =
number)=0A=
+{=0A=
+	dma_addr_t address =3D pm8001_ha->outb_addr;=0A=
+	u16 offset =3D number * 0x24;=0A=
+	pm8001_mw32(address, offset + 0x00,=0A=
+		pm8001_ha->outb_data[number].element_size_cnt);=0A=
+	pm8001_mw32(address, offset + 0x04,=0A=
+		pm8001_ha->outb_data[number].upper_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x08,=0A=
+		pm8001_ha->outb_data[number].lower_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x0C,=0A=
+		pm8001_ha->outb_data[number].pi_upper_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x10,=0A=
+		pm8001_ha->outb_data[number].pi_lower_base_addr);=0A=
+	pm8001_mw32(address, offset + 0x1C,=0A=
+		pm8001_ha->outb_data[number].interrup_vec_cnt_delay);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * mpi_init_check - notify firmware update finished and check =
initialization=0A=
+ * status.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 max_wait_time, max_wait_count;=0A=
+	u32 value;=0A=
+	u32 gst_len_mpistate;=0A=
+	/* Write bit0=3D1 to Inbound DoorBell Register to tell the SPC FW the=0A=
+	table is updated */=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPC_MSGU_CFG_TABLE_UPDATE);=0A=
+	/* wait until Inbound DoorBell Clear Register toggled */=0A=
+	max_wait_time =3D 1 * 1000 * 1000;/* 1 sec */=0A=
+	max_wait_count =3D max_wait_time/10;=0A=
+	do {=0A=
+		udelay(10);=0A=
+		value =3D pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);=0A=
+		value &=3D SPC_MSGU_CFG_TABLE_UPDATE;=0A=
+	} while ((value !=3D 0) && (--max_wait_count));=0A=
+=0A=
+	if (!max_wait_count)=0A=
+		return -1;=0A=
+	/* check the MPI-State for initialization */=0A=
+	gst_len_mpistate =3D=0A=
+		pm8001_mr32(pm8001_ha->gst_addr, GST_GSTLEN_MPIS_OFFSET);=0A=
+	if (GST_MPI_STATE_INIT !=3D (gst_len_mpistate & GST_MPI_STATE_MASK))=0A=
+		return -1;=0A=
+	/* check MPI Initialization error */=0A=
+	gst_len_mpistate =3D gst_len_mpistate >> 16;=0A=
+	if (0x0000 !=3D gst_len_mpistate)=0A=
+		return -1;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * check_fw_ready - The LLDD check if the FW is ready, if not,wait as =
long=0A=
+ * as 1 seccond and return error.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 value, value1;=0A=
+	u32 max_wait_time, max_wait_count;=0A=
+	/* check error state */=0A=
+	value =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);=0A=
+	value1 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);=0A=
+	/* check AAP error */=0A=
+	if (SCRATCH_PAD1_ERR =3D=3D (value & SCRATCH_PAD_STATE_MASK)) {=0A=
+		/* error state */=0A=
+		value =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* check IOP error */=0A=
+	if (SCRATCH_PAD2_ERR =3D=3D (value1 & SCRATCH_PAD_STATE_MASK)) {=0A=
+		/* error state */=0A=
+		value1 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* bit 4-31 of scratch pad1 should be zeros if it is not=0A=
+	in error state*/=0A=
+	if (value & SCRATCH_PAD1_STATE_MASK) {=0A=
+		/* error case */=0A=
+		pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* bit 2, 4-31 of scratch pad2 should be zeros if it is not=0A=
+	in error state */=0A=
+	if (value1 & SCRATCH_PAD2_STATE_MASK) {=0A=
+		/* error case */=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	max_wait_time =3D 1 * 1000 * 1000;/* 1 sec timeout */=0A=
+	max_wait_count =3D max_wait_time/10;=0A=
+=0A=
+	/* wait until scratch pad 1 and 2 registers in ready state  */=0A=
+	do {=0A=
+		mdelay(10);=0A=
+		value =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1)=0A=
+			& SCRATCH_PAD1_RDY;=0A=
+		value1 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)=0A=
+			& SCRATCH_PAD2_RDY;=0A=
+		if ((--max_wait_count) =3D=3D 0)=0A=
+			break;=0A=
+	} while ((value !=3D SCRATCH_PAD1_RDY) || (value1 !=3D =
SCRATCH_PAD2_RDY));=0A=
+=0A=
+	if (!max_wait_count)=0A=
+		return -1;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/* Initialize pci space address eg: mpi offset */=0A=
+static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	dma_addr_t 	cfg_addr;=0A=
+	u32	value;=0A=
+	u32	offset;=0A=
+	u32	pcibar;=0A=
+	u32	pcilogic;=0A=
+=0A=
+	value =3D pm8001_cr32(pm8001_ha, 0, 0x44);=0A=
+	offset =3D value & 0x03FFFFFF;=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("Scratchpad 0 Offset:  %x \n", offset));=0A=
+	pcilogic =3D (value & 0xFC000000) >> 26;=0A=
+	pcibar =3D get_pci_bar_index(pcilogic);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("Scratchpad 0 PCI BAR: %d \n", pcibar));=0A=
+	pm8001_ha->cfg_addr =3D cfg_addr =3D=0A=
+		(dma_addr_t)pm8001_ha->io_mem[pcibar].memvirtaddr + offset;=0A=
+	pm8001_ha->gst_addr =3D=0A=
+		cfg_addr + pm8001_cr32(pm8001_ha, pcibar, (u32)offset + 0x18);=0A=
+	pm8001_ha->inb_addr =3D=0A=
+		cfg_addr + pm8001_cr32(pm8001_ha, pcibar, (u32)offset + 0x1C);=0A=
+	pm8001_ha->outb_addr =3D=0A=
+		cfg_addr + pm8001_cr32(pm8001_ha, pcibar, (u32)offset + 0x20);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_init - the main init function that initialize whole =
PM8001 chip.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static int __devinit pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	/* check the firmware status */=0A=
+	if (-1 =3D=3D check_fw_ready(pm8001_ha)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("Firmware is not ready!\n"));=0A=
+		return -EBUSY;=0A=
+	}=0A=
+=0A=
+	/* Initialize pci space address eg: mpi offset */=0A=
+	init_pci_device_addresses(pm8001_ha);=0A=
+	init_default_table_values(pm8001_ha);=0A=
+	read_main_config_table(pm8001_ha);=0A=
+	read_general_status_table(pm8001_ha);=0A=
+	read_inbound_queue_table(pm8001_ha);=0A=
+	read_outbound_queue_table(pm8001_ha);=0A=
+	/* update main config table ,inbound table and outbound table */=0A=
+	update_main_config_table(pm8001_ha);=0A=
+	update_inbound_queue_table(pm8001_ha, 0);=0A=
+	update_outbound_queue_table(pm8001_ha, 0);=0A=
+=0A=
+	/* notify firmware update finished and check initialization status */=0A=
+	if (0 =3D=3D mpi_init_check(pm8001_ha)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("MPI initialize successful!\n"));=0A=
+	} else=0A=
+		return -EBUSY;=0A=
+	/*This register is a 16-bit timer with a resolution of 1us. This is the=0A=
+	timer used for interrupt delay/coalescing in the PCIe Application =
Layer.=0A=
+	Zero is not a valid value.A value of 1 in the register will cause the=0A=
+	interrupts to be normal. A value greater than 1 will cause coalescing=0A=
+	delays.*/=0A=
+	pm8001_cw32(pm8001_ha, 1, 0x0033c0, 0x1);=0A=
+	pm8001_cw32(pm8001_ha, 1, 0x0033c4, 0x0);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ *Function to do BAR shifting function is called to shift BAR base =
address=0A=
+ *=0A=
+ *  @pm8001_ha handles for this instance of SAS/SATA hardware=0A=
+ *  @shiftValue shifting value=0A=
+ *=0A=
+ *  return success or fail=0A=
+ */=0A=
+static u32 bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)=0A=
+{=0A=
+	u32 regVal;=0A=
+	u32 max_wait_time;=0A=
+	u32 max_wait_count;=0A=
+=0A=
+	/* program the inbound AXI translation Lower Address */=0A=
+	pm8001_cw32(pm8001_ha, 1, SPC_IBW_AXI_TRANSLATION_LOW, shiftValue);=0A=
+=0A=
+	/* confirm the setting is written */=0A=
+	max_wait_time =3D 1 * 1000 * 1000;  /* 1 sec */=0A=
+	max_wait_count =3D max_wait_time;=0A=
+	do {=0A=
+		mdelay(1);=0A=
+		regVal =3D pm8001_cr32(pm8001_ha, 1, SPC_IBW_AXI_TRANSLATION_LOW);=0A=
+	} while ((regVal !=3D shiftValue) && (--max_wait_count));=0A=
+=0A=
+	if (!max_wait_count) {=0A=
+		PM8001_INIT_DBG(pm8001_ha,=0A=
+			pm8001_printk("TIMEOUT:SPC_IBW_AXI_TRANSLATION_LOW"=0A=
+			" =3D 0x%x\n", regVal));=0A=
+		return -1;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 max_wait_time, max_wait_count;=0A=
+	u32 value;=0A=
+	u32 gst_len_mpistate;=0A=
+	init_pci_device_addresses(pm8001_ha);=0A=
+	/* Write bit1=3D1 to Inbound DoorBell Register to tell the SPC FW the=0A=
+	table is stop */=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPC_MSGU_CFG_TABLE_RESET);=0A=
+=0A=
+	/* wait until Inbound DoorBell Clear Register toggled */=0A=
+	max_wait_time =3D 1 * 1000 * 1000;/* 1 sec */=0A=
+	max_wait_count =3D max_wait_time/10;=0A=
+	do {=0A=
+		udelay(20);=0A=
+		value =3D pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);=0A=
+		value &=3D SPC_MSGU_CFG_TABLE_RESET;=0A=
+	} while ((value !=3D 0) && (--max_wait_count));=0A=
+=0A=
+	if (!max_wait_count) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("TIMEOUT:IBDB value/=3D0x%x\n", value));=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* check the MPI-State for termination in progress */=0A=
+	/* wait until Inbound DoorBell Clear Register toggled */=0A=
+	max_wait_time =3D 1 * 1000 * 1000;  /* 1 sec */=0A=
+	max_wait_count =3D max_wait_time/10;=0A=
+	do {=0A=
+		udelay(20);=0A=
+		gst_len_mpistate =3D pm8001_mr32(pm8001_ha->gst_addr,=0A=
+			GST_GSTLEN_MPIS_OFFSET);=0A=
+		if (GST_MPI_STATE_UNINIT =3D=3D=0A=
+			(gst_len_mpistate & GST_MPI_STATE_MASK))=0A=
+			break;=0A=
+	} while (--max_wait_count);=0A=
+	if (!max_wait_count) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk(" TIME OUT MPI State =3D 0x%x\n",=0A=
+				gst_len_mpistate & GST_MPI_STATE_MASK));=0A=
+		return -1;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+* soft_reset_ready_check - Function to check FW is ready for soft reset.=0A=
+* @pm8001_ha: our hba card information=0A=
+*/=0A=
+static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 regVal, regVal1, regVal2;=0A=
+	if (mpi_uninit_check(pm8001_ha) !=3D 0) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("MPI state is not ready\n"));=0A=
+		return -1;=0A=
+	}=0A=
+	/* read the scratch pad 2 register bit 2 */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)=0A=
+		& SCRATCH_PAD2_FWRDY_RST;=0A=
+	if (regVal =3D=3D SCRATCH_PAD2_FWRDY_RST) {=0A=
+		PM8001_INIT_DBG(pm8001_ha,=0A=
+			pm8001_printk("Firmware is ready for reset .\n"));=0A=
+	} else {=0A=
+	/* Trigger NMI twice via RB6 */=0A=
+		if (-1 =3D=3D bar4_shift(pm8001_ha, RB6_ACCESS_REG)) {=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+					RB6_ACCESS_REG));=0A=
+			return -1;=0A=
+		}=0A=
+		pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET,=0A=
+			RB6_MAGIC_NUMBER_RST);=0A=
+		pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET, RB6_MAGIC_NUMBER_RST);=0A=
+		/* wait for 100 ms */=0A=
+		mdelay(100);=0A=
+		regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2) &=0A=
+			SCRATCH_PAD2_FWRDY_RST;=0A=
+		if (regVal !=3D SCRATCH_PAD2_FWRDY_RST) {=0A=
+			regVal1 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);=0A=
+			regVal2 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC TIMEOUT:MSGU_SCRATCH_PAD1"=0A=
+				"=3D0x%x,MSGU_SCRATCH_PAD2=3D0x%x\n",=0A=
+				regVal1, regVal2));=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD0 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD3 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));=0A=
+			return -1;=0A=
+		}=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+* pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear =
all=0A=
+* the FW register status to the originated status.=0A=
+* @pm8001_ha: our hba card information=0A=
+* @signature: signature in host scratch pad0 register.=0A=
+*/=0A=
+static int=0A=
+pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha, u32 signature)=0A=
+{=0A=
+	u32	regVal, toggleVal;=0A=
+	u32	max_wait_time;=0A=
+	u32	max_wait_count;=0A=
+	u32	regVal1, regVal2, regVal3;=0A=
+=0A=
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("SPC soft_reset : start\n"));=0A=
+=0A=
+	/* step1: Check FW is ready for soft reset */=0A=
+	if (soft_reset_ready_check(pm8001_ha) !=3D 0) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+		pm8001_printk("SPC soft_reset : FW is not ready\n"));=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* step 2: clear NMI status register on AAP1 and IOP, write the same=0A=
+	value to clear */=0A=
+	/* map 0x60000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, MBIC_AAP1_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			MBIC_AAP1_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_IOP);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("MBIC(A) - NMI Enable VPE0 (IOP): =3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_IOP, 0x0);=0A=
+	/* map 0x70000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, MBIC_IOP_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			MBIC_IOP_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_AAP1);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("MBIC(A) - NMI Enable VPE0 (AAP1): =3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_AAP1, 0x0);=0A=
+=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT_ENABLE);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("PCIE -Event Interrupt Enable Register:=3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT_ENABLE, 0x0);=0A=
+=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("PCIE - Event Interrupt Register: =3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT, regVal);=0A=
+=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT_ENABLE);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("PCIE -Error Interrupt Enable Register:=3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT_ENABLE, 0x0);=0A=
+=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("PCIE - Error Interrupt Register: =3D 0x%x\n",=0A=
+		regVal));=0A=
+	pm8001_cw32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT, regVal);=0A=
+=0A=
+	/* read the scratch pad 1 register bit 2 */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1)=0A=
+		& SCRATCH_PAD1_RST;=0A=
+	toggleVal =3D regVal ^ SCRATCH_PAD1_RST;=0A=
+=0A=
+	/* set signature in host scratch pad0 register to tell SPC that the=0A=
+	host performs the soft reset */=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_0, signature);=0A=
+=0A=
+	/* read required registers for confirmming */=0A=
+	/* map 0x0700000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			GSM_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x0(0x00007b88)-GSM Configuration and"=0A=
+		" Reset =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));=0A=
+=0A=
+	/* step 3: host read GSM Configuration and Reset register */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET);=0A=
+	/* Put those bits to low */=0A=
+	/* GSM XCBI offset =3D 0x70 0000=0A=
+	0x00 Bit 13 COM_SLV_SW_RSTB 1=0A=
+	0x00 Bit 12 QSSP_SW_RSTB 1=0A=
+	0x00 Bit 11 RAAE_SW_RSTB 1=0A=
+	0x00 Bit 9   RB_1_SW_RSTB 1=0A=
+	0x00 Bit 8   SM_SW_RSTB 1=0A=
+	*/=0A=
+	regVal &=3D ~(0x00003b00);=0A=
+	/* host write GSM Configuration and Reset register */=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_CONFIG_RESET, regVal);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x0 (0x00007b88 =3D=3D> 0x00004088) - GSM "=0A=
+		"Configuration and Reset is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));=0A=
+=0A=
+	/* step 4: */=0A=
+	/* disable GSM - Read Address Parity Check */=0A=
+	regVal1 =3D pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700038 - Read Address Parity Check "=0A=
+		"Enable =3D 0x%x\n", regVal1));=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK, 0x0);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700038 - Read Address Parity Check Enable"=0A=
+		"is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK)));=0A=
+=0A=
+	/* disable GSM - Write Address Parity Check */=0A=
+	regVal2 =3D pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700040 - Write Address Parity Check"=0A=
+		" Enable =3D 0x%x\n", regVal2));=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK, 0x0);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700040 - Write Address Parity Check "=0A=
+		"Enable is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK)));=0A=
+=0A=
+	/* disable GSM - Write Data Parity Check */=0A=
+	regVal3 =3D pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x300048 - Write Data Parity Check"=0A=
+		" Enable =3D 0x%x\n", regVal3));=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, 0x0);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x300048 - Write Data Parity Check Enable"=0A=
+		"is set to =3D 0x%x\n",=0A=
+	pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK)));=0A=
+=0A=
+	/* step 5: delay 10 usec */=0A=
+	udelay(10);=0A=
+	/* step 5-b: set GPIO-0 output control to tristate anyway */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, GPIO_ADDR_BASE)) {=0A=
+		PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("Shift Bar4 to 0x%x failed\n",=0A=
+				GPIO_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET);=0A=
+		PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("GPIO Output Control Register:"=0A=
+				" =3D 0x%x\n", regVal));=0A=
+	/* set GPIO-0 output control to tri-state */=0A=
+	regVal &=3D 0xFFFFFFFC;=0A=
+	pm8001_cw32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET, regVal);=0A=
+=0A=
+	/* Step 6: Reset the IOP and AAP1 */=0A=
+	/* map 0x00000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			SPC_TOP_LEVEL_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("Top Register before resetting IOP/AAP1"=0A=
+		":=3D 0x%x\n", regVal));=0A=
+	regVal &=3D ~(SPC_REG_RESET_PCS_IOP_SS | SPC_REG_RESET_PCS_AAP1_SS);=0A=
+	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* step 7: Reset the BDMA/OSSP */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("Top Register before resetting BDMA/OSSP"=0A=
+		": =3D 0x%x\n", regVal));=0A=
+	regVal &=3D ~(SPC_REG_RESET_BDMA_CORE | SPC_REG_RESET_OSSP);=0A=
+	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* step 8: delay 10 usec */=0A=
+	udelay(10);=0A=
+=0A=
+	/* step 9: bring the BDMA and OSSP out of reset */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("Top Register before bringing up BDMA/OSSP"=0A=
+		":=3D 0x%x\n", regVal));=0A=
+	regVal |=3D (SPC_REG_RESET_BDMA_CORE | SPC_REG_RESET_OSSP);=0A=
+	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* step 10: delay 10 usec */=0A=
+	udelay(10);=0A=
+=0A=
+	/* step 11: reads and sets the GSM Configuration and Reset Register */=0A=
+	/* map 0x0700000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			GSM_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x0 (0x00007b88)-GSM Configuration and "=0A=
+		"Reset =3D 0x%x\n", pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET);=0A=
+	/* Put those bits to high */=0A=
+	/* GSM XCBI offset =3D 0x70 0000=0A=
+	0x00 Bit 13 COM_SLV_SW_RSTB 1=0A=
+	0x00 Bit 12 QSSP_SW_RSTB 1=0A=
+	0x00 Bit 11 RAAE_SW_RSTB 1=0A=
+	0x00 Bit 9   RB_1_SW_RSTB 1=0A=
+	0x00 Bit 8   SM_SW_RSTB 1=0A=
+	*/=0A=
+	regVal |=3D (GSM_CONFIG_RESET_VALUE);=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_CONFIG_RESET, regVal);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM (0x00004088 =3D=3D> 0x00007b88) - GSM"=0A=
+		" Configuration and Reset is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));=0A=
+=0A=
+	/* step 12: Restore GSM - Read Address Parity Check */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK);=0A=
+	/* just for debugging */=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700038 - Read Address Parity Check Enable"=0A=
+		" =3D 0x%x\n", regVal));=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK, regVal1);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700038 - Read Address Parity"=0A=
+		" Check Enable is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK)));=0A=
+	/* Restore GSM - Write Address Parity Check */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK);=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK, regVal2);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700040 - Write Address Parity Check"=0A=
+		" Enable is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK)));=0A=
+	/* Restore GSM - Write Data Parity Check */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);=0A=
+	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, regVal3);=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("GSM 0x700048 - Write Data Parity Check Enable"=0A=
+		"is set to =3D 0x%x\n",=0A=
+		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK)));=0A=
+=0A=
+	/* step 13: bring the IOP and AAP1 out of reset */=0A=
+	/* map 0x00000 to BAR4(0x20), BAR2(win) */=0A=
+	if (-1 =3D=3D bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",=0A=
+			SPC_TOP_LEVEL_ADDR_BASE));=0A=
+		return -1;=0A=
+	}=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);=0A=
+	regVal |=3D (SPC_REG_RESET_PCS_IOP_SS | SPC_REG_RESET_PCS_AAP1_SS);=0A=
+	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* step 14: delay 10 usec - Normal Mode */=0A=
+	udelay(10);=0A=
+	/* check Soft Reset Normal mode or Soft Reset HDA mode */=0A=
+	if (signature =3D=3D SPC_SOFT_RESET_SIGNATURE) {=0A=
+		/* step 15 (Normal Mode): wait until scratch pad1 register=0A=
+		bit 2 toggled */=0A=
+		max_wait_time =3D 2 * 1000 * 1000;/* 2 sec */=0A=
+		max_wait_count =3D max_wait_time/10;=0A=
+		do {=0A=
+			udelay(10);=0A=
+			regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1) &=0A=
+				SCRATCH_PAD1_RST;=0A=
+		} while ((regVal !=3D toggleVal) && (--max_wait_count));=0A=
+=0A=
+		if (!max_wait_count) {=0A=
+			regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC TIMEOUT:ToggleVal 0x%x,"=0A=
+				"MSGU_SCRATCH_PAD1 =3D 0x%x\n",=0A=
+				toggleVal, regVal));=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("SPC SCRATCH_PAD0 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD2 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)));=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD3 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));=0A=
+			return -1;=0A=
+		}=0A=
+=0A=
+		/* step 16 (Normal) - Clear ODMR and ODCR */=0A=
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);=0A=
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);=0A=
+=0A=
+		/* step 17 (Normal Mode): wait for the FW and IOP to get=0A=
+		ready - 1 sec timeout */=0A=
+		/* Wait for the SPC Configuration Table to be ready */=0A=
+		if (check_fw_ready(pm8001_ha) =3D=3D -1) {=0A=
+			regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);=0A=
+			/* return error if MPI Configuration Table not ready */=0A=
+			PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC FW not ready SCRATCH_PAD1"=0A=
+				" =3D 0x%x\n", regVal));=0A=
+			regVal =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);=0A=
+			/* return error if MPI Configuration Table not ready */=0A=
+			PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC FW not ready SCRATCH_PAD2"=0A=
+				" =3D 0x%x\n", regVal));=0A=
+			PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD0 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));=0A=
+			PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("SPC SCRATCH_PAD3 value =3D 0x%x\n",=0A=
+				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));=0A=
+			return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("SPC soft reset Complete\n"));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void pm8001_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 i;=0A=
+	u32 regVal;=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("chip reset start\n"));=0A=
+=0A=
+	/* do SPC chip reset. */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, SPC_REG_RESET);=0A=
+	regVal &=3D ~(SPC_REG_RESET_DEVICE);=0A=
+	pm8001_cw32(pm8001_ha, 1, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* delay 10 usec */=0A=
+	udelay(10);=0A=
+=0A=
+	/* bring chip reset out of reset */=0A=
+	regVal =3D pm8001_cr32(pm8001_ha, 1, SPC_REG_RESET);=0A=
+	regVal |=3D SPC_REG_RESET_DEVICE;=0A=
+	pm8001_cw32(pm8001_ha, 1, SPC_REG_RESET, regVal);=0A=
+=0A=
+	/* delay 10 usec */=0A=
+	udelay(10);=0A=
+=0A=
+	/* wait for 20 msec until the firmware gets reloaded */=0A=
+	i =3D 20;=0A=
+	do {=0A=
+		udelay(1000);=0A=
+	} while ((--i) !=3D 0);=0A=
+=0A=
+	PM8001_INIT_DBG(pm8001_ha,=0A=
+		pm8001_printk("chip reset finished\n"));=0A=
+}=0A=
+=0A=
+/**=0A=
+* pm8001_chip_iounmap - unmap the virtual address to HBA high register =
address=0A=
+* which maped when initilized.=0A=
+* @pm8001_ha: our hba card information=0A=
+*/=0A=
+static void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	s8 bar, logical =3D 0;=0A=
+	for (bar =3D 0; bar < 6; bar++) {=0A=
+		/*=0A=
+		** logical BARs for SPC:=0A=
+		** bar 0 and 1 - logical BAR0=0A=
+		** bar 2 and 3 - logical BAR1=0A=
+		** bar4 - logical BAR2=0A=
+		** bar5 - logical BAR3=0A=
+		** Skip the appropriate assignments:=0A=
+		*/=0A=
+		if ((bar =3D=3D 1) || (bar =3D=3D 3))=0A=
+			continue;=0A=
+		if (pm8001_ha->io_mem[logical].memvirtaddr) {=0A=
+			iounmap(pm8001_ha->io_mem[logical].memvirtaddr);=0A=
+			logical++;=0A=
+		}=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);=0A=
+}=0A=
+=0A=
+ /**=0A=
+  * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt=0A=
+  * @pm8001_ha: our hba card information=0A=
+  */=0A=
+static void=0A=
+pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_msix_interrupt_enable(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 int_vec_idx)=0A=
+{=0A=
+	u32 msi_index;=0A=
+	u32 value;=0A=
+	msi_index =3D int_vec_idx * MSIX_TABLE_ELEMENT_SIZE;=0A=
+	msi_index +=3D MSIX_TABLE_BASE;=0A=
+	pm8001_cw32(pm8001_ha, 0, msi_index, MSIX_INTERRUPT_ENABLE);=0A=
+	value  =3D (1 << int_vec_idx);=0A=
+	pm8001_cw32(pm8001_ha, 0,  MSGU_ODCR, value);=0A=
+=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_msix_interrupt_disable - disable PM8001 chip interrupt=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 int_vec_idx)=0A=
+{=0A=
+	u32 msi_index;=0A=
+	msi_index =3D int_vec_idx * MSIX_TABLE_ELEMENT_SIZE;=0A=
+	msi_index +=3D MSIX_TABLE_BASE;=0A=
+	pm8001_cw32(pm8001_ha, 0,  msi_index, MSIX_INTERRUPT_DISABLE);=0A=
+=0A=
+}=0A=
+/**=0A=
+ * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	pm8001_chip_msix_interrupt_enable(pm8001_ha, 0);=0A=
+	return;=0A=
+#endif=0A=
+	pm8001_chip_intx_interrupt_enable(pm8001_ha);=0A=
+=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt=0A=
+ * @pm8001_ha: our hba card information=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	pm8001_chip_msix_interrupt_disable(pm8001_ha, 0);=0A=
+	return;=0A=
+#endif=0A=
+	pm8001_chip_intx_interrupt_disable(pm8001_ha);=0A=
+=0A=
+}=0A=
+=0A=
+/**=0A=
+ * mpi_msg_free_get- get the free message buffer for transfer inbound =
queue.=0A=
+ * @circularQ: the inbound queue  we want to transfer to HBA.=0A=
+ * @messageSize: the message size of this transfer, normally it is 64 =
bytes=0A=
+ * @messagePtr: the pointer to message.=0A=
+ */=0A=
+static u32 mpi_msg_free_get(struct inbound_queue_table *circularQ,=0A=
+			    u16 messageSize, void **messagePtr)=0A=
+{=0A=
+	u32 offset, consumer_index;=0A=
+	struct mpi_msg_hdr *msgHeader;=0A=
+	u8 bcCount =3D 1; /* only support single buffer */=0A=
+=0A=
+	/* Checks is the requested message size can be allocated in this =
queue*/=0A=
+	if (messageSize > 64) {=0A=
+		*messagePtr =3D NULL;=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* Stores the new consumer index */=0A=
+	READ_32(&consumer_index, circularQ->ci_virt, 0);=0A=
+	circularQ->consumer_index =3D cpu_to_le32(consumer_index);=0A=
+	if (((circularQ->producer_idx + bcCount) % 256) =3D=3D=0A=
+		circularQ->consumer_index) {=0A=
+		*messagePtr =3D NULL;=0A=
+		return -1;=0A=
+	}=0A=
+	/* get memory IOMB buffer address */=0A=
+	offset =3D circularQ->producer_idx * 64;=0A=
+	/* increment to next bcCount element */=0A=
+	circularQ->producer_idx =3D (circularQ->producer_idx + bcCount) % 256;=0A=
+	/* Adds that distance to the base of the region virtual address plus=0A=
+	the message header size*/=0A=
+	msgHeader =3D (struct mpi_msg_hdr *)(((u8 *)(circularQ->base_virt))=0A=
+			+ offset);=0A=
+	*messagePtr =3D ((void *)msgHeader) + sizeof(struct mpi_msg_hdr);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * mpi_build_cmd- build the message queue for transfer, update the PI =
to FW=0A=
+ * to tell the fw to get this message from IOMB.=0A=
+ * @circularQ: the inbound queue we want to transfer to HBA.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @opCode: the operation code represents commands which LLDD and fw =
recognized.=0A=
+ * @payload: the command payload of each operation command.=0A=
+ */=0A=
+static u32 mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,=0A=
+			 struct inbound_queue_table *circularQ,=0A=
+			 u32 opCode, void *payload)=0A=
+{=0A=
+	u32 Header =3D 0, hpriority =3D 0, bc =3D 1, category =3D 0x02;=0A=
+	u32 responseQueue =3D 0;=0A=
+	void *pMessage;=0A=
+=0A=
+	if (mpi_msg_free_get(circularQ, 64, &pMessage) < 0) {=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("mpi_msg_free_get no free mpibuffer \n"));=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/*Copy to the payload*/=0A=
+	memcpy(pMessage, payload, (64 - sizeof(struct mpi_msg_hdr)));=0A=
+=0A=
+	/*Build the header*/=0A=
+	Header =3D ((1 << 31) | (hpriority << 30) | ((bc & 0x1f) << 24)=0A=
+		| ((responseQueue & 0x3F) << 16)=0A=
+		| ((category & 0xF) << 12) | (opCode & 0xFFF));=0A=
+=0A=
+	WRITE_32((pMessage - 4), 0, cpu_to_le32(Header));=0A=
+	/*Update the PI to the firmware*/=0A=
+	pm8001_cw32(pm8001_ha, circularQ->pi_pci_bar,=0A=
+		circularQ->pi_offset, circularQ->producer_idx);=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("after PI=3D %d CI=3D %d \n", circularQ->producer_idx,=0A=
+		circularQ->consumer_index));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static u32 mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha,=0A=
+			    struct outbound_queue_table *circularQ, u8 bc)=0A=
+{=0A=
+	u32 producer_index;=0A=
+	/* free the circular queue buffer elements associated with the =
message*/=0A=
+	circularQ->consumer_idx =3D (circularQ->consumer_idx + bc) % 256;=0A=
+	/* update the CI of outbound queue */=0A=
+	pm8001_cw32(pm8001_ha, circularQ->ci_pci_bar, circularQ->ci_offset,=0A=
+		circularQ->consumer_idx);=0A=
+	/* Update the producer index from SPC*/=0A=
+	READ_32(&producer_index,=0A=
+		circularQ->pi_virt, 0);=0A=
+	circularQ->producer_index =3D cpu_to_le32(producer_index);=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk(" CI=3D%d PI=3D%d\n", circularQ->consumer_idx,=0A=
+		circularQ->producer_index));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * mpi_msg_consume- get the MPI message from  outbound queue message =
table.=0A=
+ * @circularQ: the outbound queue  table.=0A=
+ * @messagePtr1: the message contents of this outbound message.=0A=
+ * @pBC: the message size.=0A=
+ */=0A=
+static u32 mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,=0A=
+			   struct outbound_queue_table *circularQ,=0A=
+			   void **messagePtr1, u8 *pBC)=0A=
+{=0A=
+	struct mpi_msg_hdr	*msgHeader;=0A=
+	__le32	msgHeader_tmp;=0A=
+	u32 header_tmp;=0A=
+	do {=0A=
+		/* If there are not-yet-delivered messages ... */=0A=
+		if (circularQ->producer_index !=3D circularQ->consumer_idx) {=0A=
+			PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk("process an IOMB\n"));=0A=
+			/*Get the pointer to the circular queue buffer element*/=0A=
+			msgHeader =3D (struct mpi_msg_hdr *)=0A=
+			((u8 *)(circularQ->base_virt)+=0A=
+			circularQ->consumer_idx * 64);=0A=
+			/* read header */=0A=
+			READ_32(&header_tmp, msgHeader, 0);=0A=
+			msgHeader_tmp =3D cpu_to_le32(header_tmp);=0A=
+			if (0 !=3D (msgHeader_tmp & 0x80000000)) {=0A=
+				if (OPC_OUB_SKIP_ENTRY !=3D=0A=
+					(msgHeader_tmp & 0xfff)) {=0A=
+					*messagePtr1 =3D=0A=
+						((u8 *)msgHeader) +=0A=
+						sizeof(struct mpi_msg_hdr);=0A=
+					*pBC =3D (u8)((msgHeader_tmp >> 24) &=0A=
+						0x1f);=0A=
+					PM8001_IO_DBG(pm8001_ha,=0A=
+						pm8001_printk("mpi_msg_consume"=0A=
+						": CI=3D%d PI=3D%d msgHeader=3D%x\n",=0A=
+						circularQ->consumer_idx,=0A=
+						circularQ->producer_index,=0A=
+						msgHeader_tmp));=0A=
+					return MPI_IO_STATUS_SUCCESS;=0A=
+				} else {=0A=
+					u32 producer_index;=0A=
+					/* free the circular queue buffer=0A=
+					elements associated with the message*/=0A=
+					circularQ->consumer_idx =3D=0A=
+					(circularQ->consumer_idx +=0A=
+					((msgHeader_tmp >> 24) & 0x1f)) % 256;=0A=
+					/* update the CI of outbound queue */=0A=
+					pm8001_cw32(pm8001_ha,=0A=
+						circularQ->ci_pci_bar,=0A=
+						circularQ->ci_offset,=0A=
+						circularQ->consumer_idx);=0A=
+					/* Update the producer index from SPC */=0A=
+					READ_32(&producer_index,=0A=
+						circularQ->pi_virt, 0);=0A=
+					circularQ->producer_index =3D=0A=
+						cpu_to_le32(producer_index);=0A=
+				}=0A=
+			} else=0A=
+				return MPI_IO_STATUS_FAIL;=0A=
+		}=0A=
+	} while (circularQ->producer_index !=3D circularQ->consumer_idx);=0A=
+	/* while we don't have any more not-yet-delivered message */=0A=
+	/* report empty */=0A=
+	return MPI_IO_STATUS_BUSY;=0A=
+}=0A=
+=0A=
+static void pm8001_work_queue(struct work_struct *work)=0A=
+{=0A=
+	struct delayed_work *dw =3D container_of(work, struct delayed_work, =
work);=0A=
+	struct pm8001_wq *wq =3D container_of(dw, struct pm8001_wq, work_q);=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct domain_device	*dev;=0A=
+=0A=
+	switch (wq->handler) {=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		pm8001_dev =3D wq->data;=0A=
+		dev =3D pm8001_dev->sas_device;=0A=
+		pm8001_I_T_nexus_reset(dev);=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:=0A=
+		pm8001_dev =3D wq->data;=0A=
+		dev =3D pm8001_dev->sas_device;=0A=
+		pm8001_I_T_nexus_reset(dev);=0A=
+		break;=0A=
+	case IO_DS_IN_ERROR:=0A=
+		pm8001_dev =3D wq->data;=0A=
+		dev =3D pm8001_dev->sas_device;=0A=
+		pm8001_I_T_nexus_reset(dev);=0A=
+		break;=0A=
+	case IO_DS_NON_OPERATIONAL:=0A=
+		pm8001_dev =3D wq->data;=0A=
+		dev =3D pm8001_dev->sas_device;=0A=
+		pm8001_I_T_nexus_reset(dev);=0A=
+		break;=0A=
+	}=0A=
+	list_del(&wq->entry);=0A=
+	kfree(wq);=0A=
+}=0A=
+=0A=
+static int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void =
*data,=0A=
+			       int handler)=0A=
+{=0A=
+	struct pm8001_wq *wq;=0A=
+	int ret =3D 0;=0A=
+=0A=
+	wq =3D kmalloc(sizeof(struct pm8001_wq), GFP_ATOMIC);=0A=
+	if (wq) {=0A=
+		wq->pm8001_ha =3D pm8001_ha;=0A=
+		wq->data =3D data;=0A=
+		wq->handler =3D handler;=0A=
+		INIT_DELAYED_WORK(&wq->work_q, pm8001_work_queue);=0A=
+		list_add_tail(&wq->entry, &pm8001_ha->wq_list);=0A=
+		schedule_delayed_work(&wq->work_q, 0);=0A=
+	} else=0A=
+		ret =3D -ENOMEM;=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+/**=0A=
+ * mpi_ssp_completion- this function deal with the event that FW =
response to=0A=
+ * the SSP request. When FW has completed a ssp request for example a IO=0A=
+ * request, after it has filled the SG data with the data, it will =
trigger this=0A=
+ * event represent that he has finished the job,please check the =
coresponding=0A=
+ * buffer. So we will tell the caller who maybe waiting the result=0A=
+ * to tell him that the task has been finished.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: the message contents of this outbound message.=0A=
+ */=0A=
+static int=0A=
+mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)=0A=
+{=0A=
+	struct sas_task *t;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	unsigned long flags;=0A=
+	u32 status;=0A=
+	u32 param;=0A=
+	u32 tag;=0A=
+	struct ssp_completion_resp *psspPayload;=0A=
+	struct task_status_struct *ts;=0A=
+	struct ssp_response_iu *iu;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	psspPayload =3D (struct ssp_completion_resp *)((u8*)piomb + 4);=0A=
+	status =3D le32_to_cpu(psspPayload->status);=0A=
+	tag =3D le32_to_cpu(psspPayload->tag);=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	param =3D le32_to_cpu(psspPayload->param);=0A=
+=0A=
+	PM8001_IO_DBG(pm8001_ha, pm8001_printk("OPC_OUB_SSP_COMP\n"));=0A=
+	t =3D ccb->task;=0A=
+=0A=
+	if (status)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("sas IO status 0x%x\n", status));=0A=
+	if (unlikely(!t || !t->lldd_task || !t->dev))=0A=
+		return -1;=0A=
+	ts =3D &t->task_status;=0A=
+	switch (status) {=0A=
+	case IO_SUCCESS:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"=0A=
+			",param =3D %d \n", param));=0A=
+		if (param =3D=3D 0) {=0A=
+			ts->resp =3D SAS_TASK_COMPLETE;=0A=
+			ts->stat =3D SAM_GOOD;=0A=
+		} else {=0A=
+			ts->resp =3D SAS_TASK_COMPLETE;=0A=
+			ts->stat =3D SAS_PROTO_RESPONSE;=0A=
+			ts->residual =3D param;=0A=
+			iu =3D &psspPayload->ssp_resp_iu;=0A=
+			sas_ssp_task_response(pm8001_ha->dev, t, iu);=0A=
+		}=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_ABORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_ABORTED IOMB Tag \n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_ABORTED_TASK;=0A=
+		break;=0A=
+	case IO_UNDERFLOW:=0A=
+		/* SSP Completion with error */=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW"=0A=
+			",param =3D %d \n", param));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_UNDERRUN;=0A=
+		ts->residual =3D param;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_NO_DEVICE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_NO_DEVICE\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_PHY_DOWN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PHY_NOT_READY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_EPROTO;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_CONT0;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		if (!t->uldd_task)=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_BAD_DEST;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"=0A=
+			"NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_CONN_RATE;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_WRONG_DEST;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_NAK_RECEIVED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_DMA:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("IO_XFER_ERROR_DMA\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_XFER_OPEN_RETRY_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_OFFSET_MISMATCH:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_PORT_IN_RESET:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_PORT_IN_RESET\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_DS_NON_OPERATIONAL:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		if (!t->uldd_task)=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_DS_NON_OPERATIONAL);=0A=
+		break;=0A=
+	case IO_DS_IN_RECOVERY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_IN_RECOVERY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_TM_TAG_NOT_FOUND:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_TM_TAG_NOT_FOUND\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_SSP_EXT_IU_ZERO_LEN_ERROR:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_SSP_EXT_IU_ZERO_LEN_ERROR\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+	default:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown status 0x%x\n", status));=0A=
+		/* not allowed case. Therefore, return failed status */=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	}=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("scsi_satus =3D %x \n ",=0A=
+		psspPayload->ssp_resp_iu.status));=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"=0A=
+			" io_status 0x%x resp 0x%x "=0A=
+			"stat 0x%x but aborted by upper layer!\n",=0A=
+			t, status, ts->resp, ts->stat));=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/* locked operation in order to force CPU ordering */=0A=
+		t->task_done(t);=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/*See the comments for mpi_ssp_completion */=0A=
+static int mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void =
*piomb)=0A=
+{=0A=
+#if 0=0A=
+	struct sas_task *t;=0A=
+	unsigned long flags;=0A=
+	struct task_status_struct *ts;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct ssp_event_resp *psspPayload =3D=0A=
+		(struct ssp_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 event =3D le32_to_cpu(psspPayload->event);=0A=
+	u32 tag =3D le32_to_cpu(psspPayload->tag);=0A=
+	u32 port_id =3D le32_to_cpu(psspPayload->port_id);=0A=
+	u32 dev_id =3D le32_to_cpu(psspPayload->device_id);=0A=
+=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	t =3D ccb->task;=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	if (event)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("sas IO status 0x%x\n", event));=0A=
+	if (unlikely(!t || !t->lldd_task || !t->dev))=0A=
+		return -1;=0A=
+	ts =3D &t->task_status;=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("port_id =3D %x,device_id =3D %x\n",=0A=
+		port_id, dev_id));=0A=
+	switch (event) {=0A=
+	case IO_OVERFLOW:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n");)=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		ts->residual =3D 0;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_INTERRUPTED;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PHY_NOT_READY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"=0A=
+			"_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_EPROTO;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_CONT0;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		if (!t->uldd_task)=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_BAD_DEST;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"=0A=
+			"NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_CONN_RATE;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_WRONG_DEST;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_NAK_RECEIVED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_OPEN_RETRY_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_UNEXPECTED_PHASE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_RDY_OVERRUN:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_OFFSET_MISMATCH:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	case IO_XFER_CMD_FRAME_ISSUED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("  IO_XFER_CMD_FRAME_ISSUED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown status 0x%x\n", event));=0A=
+		/* not allowed case. Therefore, return failed status */=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		break;=0A=
+	}=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"=0A=
+			" event 0x%x resp 0x%x "=0A=
+			"stat 0x%x but aborted by upper layer!\n",=0A=
+			t, event, ts->resp, ts->stat));=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/* locked operation in order to force CPU ordering */=0A=
+		t->task_done(t);=0A=
+	}=0A=
+#endif=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/*See the comments for mpi_ssp_completion */=0A=
+static int=0A=
+mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct sas_task *t;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	unsigned long flags;=0A=
+	u32 param;=0A=
+	u32 status;=0A=
+	u32 tag;=0A=
+	struct sata_completion_resp *psataPayload;=0A=
+	struct task_status_struct *ts;=0A=
+	struct ata_task_resp *resp ;=0A=
+	u32 *sata_resp;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+=0A=
+	psataPayload =3D (struct sata_completion_resp *)((u8 *)piomb + 4);=0A=
+	status =3D le32_to_cpu(psataPayload->status);=0A=
+	tag =3D le32_to_cpu(psataPayload->tag);=0A=
+=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	param =3D le32_to_cpu(psataPayload->param);=0A=
+	t =3D ccb->task;=0A=
+	ts =3D &t->task_status;=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	if (status)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("sata IO status 0x%x\n", status));=0A=
+	if (unlikely(!t || !t->lldd_task || !t->dev))=0A=
+		return -1;=0A=
+=0A=
+	switch (status) {=0A=
+	case IO_SUCCESS:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));=0A=
+		if (param =3D=3D 0) {=0A=
+			ts->resp =3D SAS_TASK_COMPLETE;=0A=
+			ts->stat =3D SAM_GOOD;=0A=
+		} else {=0A=
+			u8 len;=0A=
+			ts->resp =3D SAS_TASK_COMPLETE;=0A=
+			ts->stat =3D SAS_PROTO_RESPONSE;=0A=
+			ts->residual =3D param;=0A=
+			PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk("SAS_PROTO_RESPONSE len =3D %d\n",=0A=
+				param));=0A=
+			sata_resp =3D &psataPayload->sata_resp[0];=0A=
+			resp =3D (struct ata_task_resp *)ts->buf;=0A=
+			if (t->ata_task.dma_xfer =3D=3D 0 &&=0A=
+			t->data_dir =3D=3D PCI_DMA_FROMDEVICE) {=0A=
+				len =3D sizeof(struct pio_setup_fis);=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk("PIO read len =3D %d\n", len));=0A=
+			} else if (t->ata_task.use_ncq) {=0A=
+				len =3D sizeof(struct set_dev_bits_fis);=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+					pm8001_printk("FPDMA len =3D %d\n", len));=0A=
+			} else {=0A=
+				len =3D sizeof(struct dev_to_host_fis);=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk("other len =3D %d\n", len));=0A=
+			}=0A=
+			if (SAS_STATUS_BUF_SIZE >=3D sizeof(*resp)) {=0A=
+				resp->frame_len =3D len;=0A=
+				memcpy(&resp->ending_fis[0], sata_resp, len);=0A=
+				ts->buf_valid_size =3D sizeof(*resp);=0A=
+			} else=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+					pm8001_printk("response to large \n"));=0A=
+		}=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_ABORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_ABORTED IOMB Tag \n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_ABORTED_TASK;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+		/* following cases are to do cases */=0A=
+	case IO_UNDERFLOW:=0A=
+		/* SATA Completion with error */=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_UNDERFLOW param =3D %d\n", param));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_UNDERRUN;=0A=
+		ts->residual =3D  param;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_NO_DEVICE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_NO_DEVICE\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_PHY_DOWN;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_INTERRUPTED;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PHY_NOT_READY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"=0A=
+			"_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_EPROTO;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_CONT0;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+			ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_BAD_DEST;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+			ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"=0A=
+			"NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_CONN_RATE;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_STP_RESOURCES"=0A=
+			"_BUSY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);=0A=
+			ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_WRONG_DEST;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_NAK_RECEIVED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_DMA:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_DMA\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_ABORTED_TASK;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_SATA_LINK_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_SATA_LINK_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_REJECTED_NCQ_MODE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_UNDERRUN;=0A=
+		break;=0A=
+	case IO_XFER_OPEN_RETRY_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_PORT_IN_RESET:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_PORT_IN_RESET\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	case IO_DS_NON_OPERATIONAL:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha, pm8001_dev,=0A=
+				    IO_DS_NON_OPERATIONAL);=0A=
+			ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_DS_IN_RECOVERY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("  IO_DS_IN_RECOVERY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	case IO_DS_IN_ERROR:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_IN_ERROR\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha, pm8001_dev,=0A=
+				    IO_DS_IN_ERROR);=0A=
+			ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+	default:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown status 0x%x\n", status));=0A=
+		/* not allowed case. Therefore, return failed status */=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	}=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("task 0x%p done with io_status 0x%x"=0A=
+			" resp 0x%x stat 0x%x but aborted by upper layer!\n",=0A=
+			t, status, ts->resp, ts->stat));=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/* in order to force CPU ordering */=0A=
+		t->task_done(t);=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/*See the comments for mpi_ssp_completion */=0A=
+static int mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void =
*piomb)=0A=
+{=0A=
+	struct sas_task *t;=0A=
+	unsigned long flags;=0A=
+	struct task_status_struct *ts;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct sata_event_resp *psataPayload =3D=0A=
+		(struct sata_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 event =3D le32_to_cpu(psataPayload->event);=0A=
+	u32 tag =3D le32_to_cpu(psataPayload->tag);=0A=
+	u32 port_id =3D le32_to_cpu(psataPayload->port_id);=0A=
+	u32 dev_id =3D le32_to_cpu(psataPayload->device_id);=0A=
+=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	t =3D ccb->task;=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	if (event)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("sata IO status 0x%x\n", event));=0A=
+	if (unlikely(!t || !t->lldd_task || !t->dev))=0A=
+		return -1;=0A=
+	ts =3D &t->task_status;=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("port_id =3D %x,device_id =3D %x\n",=0A=
+		port_id, dev_id));=0A=
+	switch (event) {=0A=
+	case IO_OVERFLOW:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		ts->residual =3D 0;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_INTERRUPTED;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PHY_NOT_READY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"=0A=
+			"_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_EPROTO;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_CONT0;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		if (!t->uldd_task) {=0A=
+			pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+			ts->resp =3D SAS_TASK_COMPLETE;=0A=
+			ts->stat =3D SAS_QUEUE_FULL;=0A=
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+			mb();/* in order to force CPU ordering */=0A=
+			t->task_done(t);=0A=
+			return 0;=0A=
+		}=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_BAD_DEST;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"=0A=
+			"NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_CONN_RATE;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_WRONG_DEST;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_NAK_RECEIVED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PEER_ABORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PEER_ABORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_NAK_R_ERR;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_REJECTED_NCQ_MODE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_UNDERRUN;=0A=
+		break;=0A=
+	case IO_XFER_OPEN_RETRY_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_UNEXPECTED_PHASE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_RDY_OVERRUN:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_OFFSET_MISMATCH:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	case IO_XFER_CMD_FRAME_ISSUED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_CMD_FRAME_ISSUED\n"));=0A=
+		break;=0A=
+	case IO_XFER_PIO_SETUP_ERROR:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_PIO_SETUP_ERROR\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown status 0x%x\n", event));=0A=
+		/* not allowed case. Therefore, return failed status */=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_TO;=0A=
+		break;=0A=
+	}=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("task 0x%p done with io_status 0x%x"=0A=
+			" resp 0x%x stat 0x%x but aborted by upper layer!\n",=0A=
+			t, event, ts->resp, ts->stat));=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/* in order to force CPU ordering */=0A=
+		t->task_done(t);=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/*See the comments for mpi_ssp_completion */=0A=
+static int=0A=
+mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	u32 param;=0A=
+	struct sas_task *t;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	unsigned long flags;=0A=
+	u32 status;=0A=
+	u32 tag;=0A=
+	struct smp_completion_resp *psmpPayload;=0A=
+	struct task_status_struct *ts;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+=0A=
+	psmpPayload =3D (struct smp_completion_resp *)((u8 *)piomb + 4);=0A=
+	status =3D le32_to_cpu(psmpPayload->status);=0A=
+	tag =3D le32_to_cpu(psmpPayload->tag);=0A=
+=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	param =3D le32_to_cpu(psmpPayload->param);=0A=
+	t =3D ccb->task;=0A=
+	ts =3D &t->task_status;=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	if (status)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("smp IO status 0x%x\n", status));=0A=
+	if (unlikely(!t || !t->lldd_task || !t->dev))=0A=
+		return -1;=0A=
+=0A=
+	switch (status) {=0A=
+	case IO_SUCCESS:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAM_GOOD;=0A=
+	if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_ABORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_ABORTED IOMB\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_ABORTED_TASK;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_OVERFLOW:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DATA_OVERRUN;=0A=
+		ts->residual =3D 0;=0A=
+		if (pm8001_dev)=0A=
+			pm8001_dev->running_req--;=0A=
+		break;=0A=
+	case IO_NO_DEVICE:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_PHY_DOWN;=0A=
+		break;=0A=
+	case IO_ERROR_HW_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_ERROR_HW_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAM_BUSY;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAM_BUSY;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_PHY_NOT_READY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAM_BUSY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BREAK:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_CONT0;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_UNKNOWN;=0A=
+		pm8001_handle_event(pm8001_ha,=0A=
+				pm8001_dev,=0A=
+				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_BAD_DEST;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"=0A=
+			"NOT_SUPPORTED\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_CONN_RATE;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_WRONG_DEST;=0A=
+		break;=0A=
+	case IO_XFER_ERROR_RX_FRAME:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_ERROR_RX_FRAME\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	case IO_XFER_OPEN_RETRY_TIMEOUT:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_ERROR_INTERNAL_SMP_RESOURCE:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_ERROR_INTERNAL_SMP_RESOURCE\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_QUEUE_FULL;=0A=
+		break;=0A=
+	case IO_PORT_IN_RESET:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_PORT_IN_RESET\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_DS_NON_OPERATIONAL:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		break;=0A=
+	case IO_DS_IN_RECOVERY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_DS_IN_RECOVERY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_OPEN_REJECT;=0A=
+		ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown status 0x%x\n", status));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAS_DEV_NO_RESPONSE;=0A=
+		/* not allowed case. Therefore, return failed status */=0A=
+		break;=0A=
+	}=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"=0A=
+			" io_status 0x%x resp 0x%x "=0A=
+			"stat 0x%x but aborted by upper layer!\n",=0A=
+			t, status, ts->resp, ts->stat));=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+	} else {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/* in order to force CPU ordering */=0A=
+		t->task_done(t);=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void=0A=
+mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct set_dev_state_resp *pPayload =3D=0A=
+		(struct set_dev_state_resp *)((u8 *)piomb + 4);=0A=
+	u32 tag =3D le32_to_cpu(pPayload->tag);=0A=
+	struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	struct pm8001_device *pm8001_dev =3D ccb->device;=0A=
+	u32 status =3D le32_to_cpu(pPayload->status);=0A=
+	u32 device_id =3D le32_to_cpu(pPayload->device_id);=0A=
+	u8 pds =3D le32_to_cpu(pPayload->pds_nds) | PDS_BITS;=0A=
+	u8 nds =3D le32_to_cpu(pPayload->pds_nds) | NDS_BITS;=0A=
+	PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Set device id =3D 0x%x state =
"=0A=
+		"from 0x%x to 0x%x status =3D 0x%x!\n",=0A=
+		device_id, pds, nds, status));=0A=
+	complete(pm8001_dev->setds_completion);=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, tag);=0A=
+}=0A=
+=0A=
+static void=0A=
+mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct get_nvm_data_resp *pPayload =3D=0A=
+		(struct get_nvm_data_resp *)((u8 *)piomb + 4);=0A=
+	u32 tag =3D le32_to_cpu(pPayload->tag);=0A=
+	struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	u32 dlen_status =3D le32_to_cpu(pPayload->dlen_status);=0A=
+	complete(pm8001_ha->nvmd_completion);=0A=
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));=0A=
+	if ((dlen_status & NVMD_STAT) !=3D 0) {=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Set nvm data error!\n"));=0A=
+		return;=0A=
+	}=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, tag);=0A=
+}=0A=
+=0A=
+static void=0A=
+mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct fw_control_ex	*fw_control_context;=0A=
+	struct get_nvm_data_resp *pPayload =3D=0A=
+		(struct get_nvm_data_resp *)((u8*)piomb + 4);=0A=
+	u32 tag =3D le32_to_cpu(pPayload->tag);=0A=
+	struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	u32 dlen_status =3D le32_to_cpu(pPayload->dlen_status);=0A=
+	u32 ir_tds_bn_dps_das_nvm =3D=0A=
+		le32_to_cpu(pPayload->ir_tda_bn_dps_das_nvm);=0A=
+	void *virt_addr;=0A=
+	fw_control_context =3D ccb->fw_control_context;=0A=
+=0A=
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Get nvm data complete!\n"));=0A=
+	if ((dlen_status & NVMD_STAT) !=3D 0) {=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Get nvm data error!\n"));=0A=
+		complete(pm8001_ha->nvmd_completion);=0A=
+		return;=0A=
+	}=0A=
+=0A=
+	if (ir_tds_bn_dps_das_nvm & IPMode) {=0A=
+		/* indirect mode - IR bit set */=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Get NVMD success, IR=3D1\n"));=0A=
+		if ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D TWI_DEVICE) {=0A=
+			if (ir_tds_bn_dps_das_nvm =3D=3D 0x80a80200) {=0A=
+				virt_addr =3D=0A=
+				pm8001_ha->memoryMap.region[NVMD].virt_ptr;=0A=
+				memcpy(pm8001_ha->sas_addr,=0A=
+				((u8 *)virt_addr + 4),=0A=
+				SAS_ADDR_SIZE);=0A=
+				PM8001_MSG_DBG(pm8001_ha,=0A=
+				pm8001_printk("Get SAS address successfully"=0A=
+				" from VPD!\n"));=0A=
+			}=0A=
+		} else if (((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D C_SEEPROM)=0A=
+			|| ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D VPD_FLASH) ||=0A=
+			((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D EXPAN_ROM)) {=0A=
+				;=0A=
+		} else if (((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D AAP1_RDUMP)=0A=
+			|| ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) =3D=3D IOP_RDUMP)) {=0A=
+			;=0A=
+		} else {=0A=
+			/* Should not be happened*/=0A=
+			PM8001_MSG_DBG(pm8001_ha,=0A=
+				pm8001_printk("(IR=3D1)Wrong Device type 0x%x\n",=0A=
+				ir_tds_bn_dps_das_nvm));=0A=
+		}=0A=
+	} else /* direct mode */{=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Get NVMD success, IR=3D0, dataLen=3D%d\n",=0A=
+			(dlen_status & NVMD_LEN) >> 24));=0A=
+	}=0A=
+	memcpy((void *)(fw_control_context->usrAddr),=0A=
+		(void *)(pm8001_ha->memoryMap.region[NVMD].virt_ptr),=0A=
+		fw_control_context->len);=0A=
+	complete(pm8001_ha->nvmd_completion);=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, tag);=0A=
+}=0A=
+=0A=
+static int mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void =
*piomb)=0A=
+{=0A=
+	struct local_phy_ctl_resp *pPayload =3D=0A=
+		(struct local_phy_ctl_resp *)((u8 *)piomb + 4);=0A=
+	u32 status =3D le32_to_cpu(pPayload->status);=0A=
+	u32 phy_id =3D le32_to_cpu(pPayload->phyop_phyid) & ID_BITS;=0A=
+	u32 phy_op =3D le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;=0A=
+	if (status !=3D 0) {=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("%x phy execute %x phy op failed! \n",=0A=
+			phy_id, phy_op));=0A=
+	} else=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("%x phy execute %x phy op success! \n",=0A=
+			phy_id, phy_op));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_bytes_dmaed - one of the interface function communication =
with libsas=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @i: which phy that received the event.=0A=
+ *=0A=
+ * when HBA driver received the identify done event or initiate FIS =
received=0A=
+ * event(for SATA), it will invoke this function to notify the sas =
layer that=0A=
+ * the sas toplogy has formed, please discover the the whole sas domain,=0A=
+ * while receive a broadcast(change) primitive just tell the sas=0A=
+ * layer to discover the changed domain rather than the whole domain.=0A=
+ */=0A=
+static void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)=0A=
+{=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[i];=0A=
+	struct asd_sas_phy *sas_phy =3D &phy->sas_phy;=0A=
+	struct sas_ha_struct *sas_ha;=0A=
+	if (!phy->phy_attached)=0A=
+		return;=0A=
+=0A=
+	sas_ha =3D pm8001_ha->sas;=0A=
+	if (sas_phy->phy) {=0A=
+		struct sas_phy *sphy =3D sas_phy->phy;=0A=
+		sphy->negotiated_linkrate =3D sas_phy->linkrate;=0A=
+		sphy->minimum_linkrate =3D phy->minimum_linkrate;=0A=
+		sphy->minimum_linkrate_hw =3D SAS_LINK_RATE_1_5_GBPS;=0A=
+		sphy->maximum_linkrate =3D phy->maximum_linkrate;=0A=
+		sphy->maximum_linkrate_hw =3D phy->maximum_linkrate;=0A=
+	}=0A=
+=0A=
+	if (phy->phy_type & PORT_TYPE_SAS) {=0A=
+		struct sas_identify_frame *id;=0A=
+		id =3D (struct sas_identify_frame *)phy->frame_rcvd;=0A=
+		id->dev_type =3D phy->identify.device_type;=0A=
+		id->initiator_bits =3D SAS_PROTOCOL_ALL;=0A=
+		id->target_bits =3D phy->identify.target_port_protocols;=0A=
+	} else if (phy->phy_type & PORT_TYPE_SATA) {=0A=
+		/*Nothing*/=0A=
+	}=0A=
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("phy %d byte dmaded.\n", i));=0A=
+=0A=
+	sas_phy->frame_rcvd_size =3D phy->frame_rcvd_size;=0A=
+	pm8001_ha->sas->notify_port_event(sas_phy, PORTE_BYTES_DMAED);=0A=
+}=0A=
+=0A=
+/* Get the link rate speed  */=0A=
+static void get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)=0A=
+{=0A=
+	struct sas_phy *sas_phy =3D phy->sas_phy.phy;=0A=
+=0A=
+	switch (link_rate) {=0A=
+	case PHY_SPEED_60:=0A=
+		phy->sas_phy.linkrate =3D SAS_LINK_RATE_6_0_GBPS;=0A=
+		phy->sas_phy.phy->negotiated_linkrate =3D SAS_LINK_RATE_6_0_GBPS;=0A=
+		break;=0A=
+	case PHY_SPEED_30:=0A=
+		phy->sas_phy.linkrate =3D SAS_LINK_RATE_3_0_GBPS;=0A=
+		phy->sas_phy.phy->negotiated_linkrate =3D SAS_LINK_RATE_3_0_GBPS;=0A=
+		break;=0A=
+	case PHY_SPEED_15:=0A=
+		phy->sas_phy.linkrate =3D SAS_LINK_RATE_1_5_GBPS;=0A=
+		phy->sas_phy.phy->negotiated_linkrate =3D SAS_LINK_RATE_1_5_GBPS;=0A=
+		break;=0A=
+	}=0A=
+	sas_phy->negotiated_linkrate =3D phy->sas_phy.linkrate;=0A=
+	sas_phy->maximum_linkrate_hw =3D SAS_LINK_RATE_6_0_GBPS;=0A=
+	sas_phy->minimum_linkrate_hw =3D SAS_LINK_RATE_1_5_GBPS;=0A=
+	sas_phy->maximum_linkrate =3D SAS_LINK_RATE_6_0_GBPS;=0A=
+	sas_phy->minimum_linkrate =3D SAS_LINK_RATE_1_5_GBPS;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * asd_get_attached_sas_addr -- extract/generate attached SAS address=0A=
+ * @phy: pointer to asd_phy=0A=
+ * @sas_addr: pointer to buffer where the SAS address is to be written=0A=
+ *=0A=
+ * This function extracts the SAS address from an IDENTIFY frame=0A=
+ * received.  If OOB is SATA, then a SAS address is generated from the=0A=
+ * HA tables.=0A=
+ *=0A=
+ * LOCKING: the frame_rcvd_lock needs to be held since this parses the =
frame=0A=
+ * buffer.=0A=
+ */=0A=
+static void pm8001_get_attached_sas_addr(struct pm8001_phy *phy,=0A=
+	u8 *sas_addr)=0A=
+{=0A=
+	if (phy->sas_phy.frame_rcvd[0] =3D=3D 0x34=0A=
+		&& phy->sas_phy.oob_mode =3D=3D SATA_OOB_MODE) {=0A=
+		struct pm8001_hba_info *pm8001_ha =3D phy->sas_phy.ha->lldd_ha;=0A=
+		/* FIS device-to-host */=0A=
+		u64 addr =3D be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr);=0A=
+		addr +=3D phy->sas_phy.id;=0A=
+		*(__be64 *)sas_addr =3D cpu_to_be64(addr);=0A=
+	} else {=0A=
+		struct sas_identify_frame *idframe =3D=0A=
+			(void *) phy->sas_phy.frame_rcvd;=0A=
+		memcpy(sas_addr, idframe->sas_addr, SAS_ADDR_SIZE);=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_hw_event_ack_req- For PM8001,some events need to acknowage to =
FW.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @Qnum: the outbound queue message number.=0A=
+ * @SEA: source of event to ack=0A=
+ * @port_id: port id.=0A=
+ * @phyId: phy id.=0A=
+ * @param0: parameter 0.=0A=
+ * @param1: parameter 1.=0A=
+ */=0A=
+static void pm8001_hw_event_ack_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 Qnum, u32 SEA, u32 port_id, u32 phyId, u32 param0, u32 param1)=0A=
+{=0A=
+	struct hw_event_ack_req	 payload;=0A=
+	u32 opc =3D OPC_INB_SAS_HW_EVENT_ACK;=0A=
+=0A=
+	struct inbound_queue_table *circularQ;=0A=
+=0A=
+	memset((u8 *)&payload, 0, sizeof(payload));=0A=
+	circularQ =3D &pm8001_ha->inb_data[Qnum];=0A=
+	payload.tag =3D 1;=0A=
+	payload.sea_phyid_portid =3D cpu_to_le32(((SEA & 0xFFFF) << 8) |=0A=
+		((phyId & 0x0F) << 4) | (port_id & 0x0F));=0A=
+	payload.param0 =3D cpu_to_le32(param0);=0A=
+	payload.param1 =3D cpu_to_le32(param1);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+}=0A=
+=0A=
+static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 phyId, u32 phy_op);=0A=
+=0A=
+/**=0A=
+ * hw_event_sas_phy_up -FW tells me a SAS phy up event.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ */=0A=
+static void=0A=
+hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct hw_event_resp *pPayload =3D=0A=
+		(struct hw_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 lr_evt_status_phyid_portid =3D=0A=
+		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
+	u8 link_rate =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);=0A=
+	u8 phy_id =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
+	unsigned long flags;=0A=
+	u8 deviceType =3D pPayload->sas_identify.dev_type;=0A=
+=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("HW_EVENT_SAS_PHY_UP \n"));=0A=
+=0A=
+	switch (deviceType) {=0A=
+	case SAS_PHY_UNUSED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("device type no device.\n"));=0A=
+		break;=0A=
+	case SAS_END_DEVICE:=0A=
+		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));=0A=
+		pm8001_chip_phy_ctl_req(pm8001_ha, phy_id,=0A=
+			PHY_NOTIFY_ENABLE_SPINUP);=0A=
+		get_lrate_mode(phy, link_rate);=0A=
+		break;=0A=
+	case SAS_EDGE_EXPANDER_DEVICE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("expander device.\n"));=0A=
+		get_lrate_mode(phy, link_rate);=0A=
+		break;=0A=
+	case SAS_FANOUT_EXPANDER_DEVICE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("fanout expander device.\n"));=0A=
+		get_lrate_mode(phy, link_rate);=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("unkown device type(%x)\n", deviceType));=0A=
+		break;=0A=
+	}=0A=
+	phy->phy_type |=3D PORT_TYPE_SAS;=0A=
+	phy->identify.device_type =3D deviceType;=0A=
+	phy->phy_attached =3D 1;=0A=
+	if (phy->identify.device_type =3D=3D SAS_END_DEV)=0A=
+		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SSP;=0A=
+	else if (phy->identify.device_type !=3D NO_DEVICE)=0A=
+		phy->identify.target_port_protocols =3D SAS_PROTOCOL_SMP;=0A=
+	phy->sas_phy.oob_mode =3D SAS_OOB_MODE;=0A=
+	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);=0A=
+	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);=0A=
+	memcpy(phy->frame_rcvd, &pPayload->sas_identify,=0A=
+		sizeof(struct sas_identify_frame)-4);=0A=
+	phy->frame_rcvd_size =3D sizeof(struct sas_identify_frame) - 4;=0A=
+	pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);=0A=
+	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);=0A=
+	if (pm8001_ha->flags =3D=3D PM8001F_RUN_TIME)=0A=
+		mdelay(200);/*delay a moment to wait disk to spinup*/=0A=
+	pm8001_bytes_dmaed(pm8001_ha, phy_id);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * hw_event_sata_phy_up -FW tells me a SATA phy up event.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ */=0A=
+static void=0A=
+hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct hw_event_resp *pPayload =3D=0A=
+		(struct hw_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 lr_evt_status_phyid_portid =3D=0A=
+		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
+	u8 link_rate =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0xF0000000) >> 28);=0A=
+	u8 phy_id =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
+	unsigned long flags;=0A=
+	get_lrate_mode(phy, link_rate);=0A=
+	phy->phy_type |=3D PORT_TYPE_SATA;=0A=
+	phy->phy_attached =3D 1;=0A=
+	phy->sas_phy.oob_mode =3D SATA_OOB_MODE;=0A=
+	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);=0A=
+	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);=0A=
+	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),=0A=
+		sizeof(struct dev_to_host_fis));=0A=
+	phy->frame_rcvd_size =3D sizeof(struct dev_to_host_fis);=0A=
+	phy->identify.target_port_protocols =3D SAS_PROTOCOL_SATA;=0A=
+	phy->identify.device_type =3D SATA_DEV;=0A=
+	pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);=0A=
+	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);=0A=
+	pm8001_bytes_dmaed(pm8001_ha, phy_id);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * hw_event_phy_down -we should notify the libsas the phy is down.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ */=0A=
+static void=0A=
+hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct hw_event_resp *pPayload =3D=0A=
+		(struct hw_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 lr_evt_status_phyid_portid =3D=0A=
+		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
+	u8 port_id =3D (u8)(lr_evt_status_phyid_portid & 0x0000000F);=0A=
+	u8 phy_id =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	u32 npip_portstate =3D le32_to_cpu(pPayload->npip_portstate);=0A=
+	u8 portstate =3D (u8)(npip_portstate & 0x0000000F);=0A=
+=0A=
+	switch (portstate) {=0A=
+	case PORT_VALID:=0A=
+		break;=0A=
+	case PORT_INVALID:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" PortInvalid portID %d \n", port_id));=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" Last phy Down and port invalid\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		break;=0A=
+	case PORT_IN_RESET:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" PortInReset portID %d \n", port_id));=0A=
+		break;=0A=
+	case PORT_NOT_ESTABLISHED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" phy Down and PORT_NOT_ESTABLISHED\n"));=0A=
+		break;=0A=
+	case PORT_LOSTCOMM:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" phy Down and PORT_LOSTCOMM\n"));=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" Last phy Down and port invalid\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" phy Down and(default) =3D %x\n",=0A=
+			portstate));=0A=
+		break;=0A=
+=0A=
+	}=0A=
+}=0A=
+=0A=
+/**=0A=
+ * mpi_reg_resp -process register device ID response.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ *=0A=
+ * when sas layer find a device it will notify LLDD, then the driver =
register=0A=
+ * the domain device to FW, this event is the return device ID which =
the FW=0A=
+ * has assigned, from now,inter-communication with FW is no longer =
using the=0A=
+ * SAS address, use device ID which FW assigned.=0A=
+ */=0A=
+static int mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	u32 status;=0A=
+	u32 device_id;=0A=
+	u32 htag;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct dev_reg_resp *registerRespPayload =3D=0A=
+		(struct dev_reg_resp *)((u8*)piomb + 4);=0A=
+=0A=
+	htag =3D le32_to_cpu(registerRespPayload->tag);=0A=
+	ccb =3D &pm8001_ha->ccb_info[registerRespPayload->tag];=0A=
+	pm8001_dev =3D ccb->device;=0A=
+	status =3D le32_to_cpu(registerRespPayload->status);=0A=
+	device_id =3D le32_to_cpu(registerRespPayload->device_id);=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk(" register device is status =3D %d\n", status));=0A=
+	switch (status) {=0A=
+	case DEVREG_SUCCESS:=0A=
+		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("DEVREG_SUCCESS\n"));=0A=
+		pm8001_dev->device_id =3D device_id;=0A=
+		break;=0A=
+	case DEVREG_FAILURE_OUT_OF_RESOURCE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("DEVREG_FAILURE_OUT_OF_RESOURCE\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_INVALID_PHY_ID:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("DEVREG_FAILURE_INVALID_PHY_ID\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_PORT_NOT_VALID_STATE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("DEVREG_FAILURE_PORT_NOT_VALID_STATE\n"));=0A=
+		break;=0A=
+	case DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID\n"));=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_UNSORPORTED\n"));=0A=
+		break;=0A=
+	}=0A=
+	complete(pm8001_dev->dcompletion);=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, htag);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void =
*piomb)=0A=
+{=0A=
+	u32 status;=0A=
+	u32 device_id;=0A=
+	struct dev_reg_resp *registerRespPayload =3D=0A=
+		(struct dev_reg_resp *)((u8 *)piomb + 4);=0A=
+=0A=
+	status =3D le32_to_cpu(registerRespPayload->status);=0A=
+	device_id =3D le32_to_cpu(registerRespPayload->device_id);=0A=
+	if (status !=3D 0)=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(" deregister device failed ,status =3D %x"=0A=
+			",device_id  =3D %x\n", status, device_id));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	u32 status;=0A=
+	struct fw_control_ex	fw_control_context;=0A=
+	struct fw_flash_Update_resp *ppayload =3D=0A=
+		(struct fw_flash_Update_resp *)((u8 *)piomb + 4);=0A=
+	u32 tag =3D le32_to_cpu(ppayload->tag);=0A=
+	struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	status =3D le32_to_cpu(ppayload->status);=0A=
+	memcpy(&fw_control_context,=0A=
+		ccb->fw_control_context,=0A=
+		sizeof(fw_control_context));=0A=
+	switch (status) {=0A=
+	case FLASH_UPDATE_COMPLETE_PENDING_REBOOT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk(": FLASH_UPDATE_COMPLETE_PENDING_REBOOT\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_IN_PROGRESS:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_IN_PROGRESS\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_HDR_ERR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_HDR_ERR\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_OFFSET_ERR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_OFFSET_ERR\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_CRC_ERR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_CRC_ERR\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_LENGTH_ERR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_LENGTH_ERR\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_HW_ERR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_HW_ERR\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_DNLD_NOT_SUPPORTED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_DNLD_NOT_SUPPORTED\n"));=0A=
+		break;=0A=
+	case FLASH_UPDATE_DISABLED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk(": FLASH_UPDATE_DISABLED\n"));=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("No matched status =3D %d\n", status));=0A=
+		break;=0A=
+	}=0A=
+	ccb->fw_control_context->fw_control->retcode =3D status;=0A=
+	pci_free_consistent(pm8001_ha->pdev,=0A=
+			fw_control_context.len,=0A=
+			fw_control_context.virtAddr,=0A=
+			fw_control_context.phys_addr);=0A=
+	complete(pm8001_ha->nvmd_completion);=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, tag);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)=0A=
+{=0A=
+	u32 status;=0A=
+	int i;=0A=
+	struct general_event_resp *pPayload =3D=0A=
+		(struct general_event_resp *)((u8 *)piomb + 4);=0A=
+	status =3D le32_to_cpu(pPayload->status);=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk(" status =3D 0x%x\n", status));=0A=
+	for (i =3D 0; i < GENERAL_EVENT_PAYLOAD; i++)=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("inb_IOMB_payload[0x%x] 0x%x, \n", i,=0A=
+		pPayload->inb_IOMB_payload[i]));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)=0A=
+{=0A=
+	struct sas_task *t;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	unsigned long flags;=0A=
+	u32 status ;=0A=
+	u32 tag, scp;=0A=
+	struct task_status_struct *ts;=0A=
+=0A=
+	struct task_abort_resp *pPayload =3D=0A=
+		(struct task_abort_resp *)((u8 *)piomb + 4);=0A=
+	ccb =3D &pm8001_ha->ccb_info[pPayload->tag];=0A=
+	t =3D ccb->task;=0A=
+	ts =3D &t->task_status;=0A=
+=0A=
+	if (t =3D=3D NULL)=0A=
+		return -1;=0A=
+=0A=
+	status =3D le32_to_cpu(pPayload->status);=0A=
+	tag =3D le32_to_cpu(pPayload->tag);=0A=
+	scp =3D le32_to_cpu(pPayload->scp);=0A=
+	PM8001_IO_DBG(pm8001_ha,=0A=
+		pm8001_printk(" status =3D 0x%x\n", status));=0A=
+	if (status !=3D 0)=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("task abort failed tag =3D 0x%x,"=0A=
+			" scp=3D 0x%x\n", tag, scp));=0A=
+	switch (status) {=0A=
+	case IO_SUCCESS:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));=0A=
+		ts->resp =3D SAS_TASK_COMPLETE;=0A=
+		ts->stat =3D SAM_GOOD;=0A=
+		break;=0A=
+	case IO_NOT_VALID:=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NOT_VALID\n"));=0A=
+		ts->resp =3D TMF_RESP_FUNC_FAILED;=0A=
+		break;=0A=
+	}=0A=
+	spin_lock_irqsave(&t->task_state_lock, flags);=0A=
+	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;=0A=
+	t->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;=0A=
+	t->task_state_flags |=3D SAS_TASK_STATE_DONE;=0A=
+	spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+	pm8001_ccb_task_free(pm8001_ha, t, ccb, pPayload->tag);=0A=
+	mb();=0A=
+	t->task_done(t);=0A=
+	return 0;=0A=
+}=0A=
+/**=0A=
+ * mpi_hw_event -The hw event has come.=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ */=0A=
+static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)=0A=
+{=0A=
+	unsigned long flags;=0A=
+	struct hw_event_resp *pPayload =3D=0A=
+		(struct hw_event_resp *)((u8 *)piomb + 4);=0A=
+	u32 lr_evt_status_phyid_portid =3D=0A=
+		le32_to_cpu(pPayload->lr_evt_status_phyid_portid);=0A=
+	u8 port_id =3D (u8)(lr_evt_status_phyid_portid & 0x0000000F);=0A=
+	u8 phy_id =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0x000000F0) >> 4);=0A=
+	u16 eventType =3D=0A=
+		(u16)((lr_evt_status_phyid_portid & 0x00FFFF00) >> 8);=0A=
+	u8 status =3D=0A=
+		(u8)((lr_evt_status_phyid_portid & 0x0F000000) >> 24);=0A=
+	struct sas_ha_struct *sas_ha =3D pm8001_ha->sas;=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
+	struct asd_sas_phy *sas_phy =3D sas_ha->sas_phy[phy_id];=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("outbound queue HW event & event type : "));=0A=
+	switch (eventType) {=0A=
+	case HW_EVENT_PHY_START_STATUS:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("HW_EVENT_PHY_START_STATUS"=0A=
+			" status =3D %x\n", status));=0A=
+		if (status =3D=3D 0) {=0A=
+			phy->phy_state =3D 1;=0A=
+			if (pm8001_ha->flags =3D=3D PM8001F_RUN_TIME)=0A=
+				complete(phy->enable_completion);=0A=
+		}=0A=
+		break;=0A=
+	case HW_EVENT_SAS_PHY_UP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PHY_START_STATUS \n"));=0A=
+		hw_event_sas_phy_up(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case HW_EVENT_SATA_PHY_UP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_SATA_PHY_UP \n"));=0A=
+		hw_event_sata_phy_up(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case HW_EVENT_PHY_STOP_STATUS:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PHY_STOP_STATUS "=0A=
+			"status =3D %x\n", status));=0A=
+		if (status =3D=3D 0)=0A=
+			phy->phy_state =3D 0;=0A=
+		break;=0A=
+	case HW_EVENT_SATA_SPINUP_HOLD:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD \n"));=0A=
+		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);=0A=
+		break;=0A=
+	case HW_EVENT_PHY_DOWN:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PHY_DOWN \n"));=0A=
+		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);=0A=
+		phy->phy_attached =3D 0;=0A=
+		phy->phy_state =3D 0;=0A=
+		hw_event_phy_down(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case HW_EVENT_PORT_INVALID:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PORT_INVALID\n"));=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	/* the broadcast change primitive received, tell the LIBSAS this event=0A=
+	to revalidate the sas domain*/=0A=
+	case HW_EVENT_BROADCAST_CHANGE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_BROADCAST_CHANGE\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_BROADCAST_CHANGE,=0A=
+			port_id, phy_id, 1, 0);=0A=
+		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_phy->sas_prim =3D HW_EVENT_BROADCAST_CHANGE;=0A=
+		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);=0A=
+		break;=0A=
+	case HW_EVENT_PHY_ERROR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PHY_ERROR\n"));=0A=
+		sas_phy_disconnected(&phy->sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);=0A=
+		break;=0A=
+	case HW_EVENT_BROADCAST_EXP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_BROADCAST_EXP\n"));=0A=
+		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_phy->sas_prim =3D HW_EVENT_BROADCAST_EXP;=0A=
+		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);=0A=
+		break;=0A=
+	case HW_EVENT_LINK_ERR_INVALID_DWORD:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_LINK_ERR_INVALID_DWORD\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_LINK_ERR_DISPARITY_ERROR\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_LINK_ERR_DISPARITY_ERROR,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_LINK_ERR_CODE_VIOLATION:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_LINK_ERR_CODE_VIOLATION\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_LINK_ERR_CODE_VIOLATION,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_MALFUNCTION:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_MALFUNCTION\n"));=0A=
+		break;=0A=
+	case HW_EVENT_BROADCAST_SES:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_BROADCAST_SES\n"));=0A=
+		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_phy->sas_prim =3D HW_EVENT_BROADCAST_SES;=0A=
+		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);=0A=
+		break;=0A=
+	case HW_EVENT_INBOUND_CRC_ERROR:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("HW_EVENT_INBOUND_CRC_ERROR\n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_INBOUND_CRC_ERROR,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		break;=0A=
+	case HW_EVENT_HARD_RESET_RECEIVED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_HARD_RESET_RECEIVED\n"));=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);=0A=
+		break;=0A=
+	case HW_EVENT_ID_FRAME_TIMEOUT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_ID_FRAME_TIMEOUT\n"));=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED \n"));=0A=
+		pm8001_hw_event_ack_req(pm8001_ha, 0,=0A=
+			HW_EVENT_LINK_ERR_PHY_RESET_FAILED,=0A=
+			port_id, phy_id, 0, 0);=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_PORT_RESET_TIMER_TMO:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO \n"));=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO \n"));=0A=
+		sas_phy_disconnected(sas_phy);=0A=
+		phy->phy_attached =3D 0;=0A=
+		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);=0A=
+		break;=0A=
+	case HW_EVENT_PORT_RECOVER:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PORT_RECOVER \n"));=0A=
+		break;=0A=
+	case HW_EVENT_PORT_RESET_COMPLETE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE \n"));=0A=
+		break;=0A=
+	case EVENT_BROADCAST_ASYNCH_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("EVENT_BROADCAST_ASYNCH_EVENT\n"));=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown event type =3D %x\n", eventType));=0A=
+		break;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * process_one_iomb - process one outbound Queue memory block=0A=
+ * @pm8001_ha: our hba card information=0A=
+ * @piomb: IO message buffer=0A=
+ */=0A=
+static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void =
*piomb)=0A=
+{=0A=
+	u32 pHeader =3D (u32)*(u32 *)piomb;=0A=
+	u8  opc =3D (u8)((le32_to_cpu(pHeader)) & 0xFFF);=0A=
+=0A=
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:\n"));=0A=
+=0A=
+	switch (opc) {=0A=
+	case OPC_OUB_ECHO:=0A=
+		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("OPC_OUB_ECHO \n"));=0A=
+		break;=0A=
+	case OPC_OUB_HW_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_HW_EVENT \n"));=0A=
+		mpi_hw_event(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SSP_COMP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SSP_COMP \n"));=0A=
+		mpi_ssp_completion(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SMP_COMP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SMP_COMP \n"));=0A=
+		mpi_smp_completion(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_LOCAL_PHY_CNTRL:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_LOCAL_PHY_CNTRL\n"));=0A=
+		mpi_local_phy_ctl(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_DEV_REGIST:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_DEV_REGIST \n"));=0A=
+		mpi_reg_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_DEREG_DEV:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("unresgister the deviece \n"));=0A=
+		mpi_dereg_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_GET_DEV_HANDLE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GET_DEV_HANDLE \n"));=0A=
+		break;=0A=
+	case OPC_OUB_SATA_COMP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SATA_COMP \n"));=0A=
+		mpi_sata_completion(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SATA_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SATA_EVENT \n"));=0A=
+		mpi_sata_event(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SSP_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SSP_EVENT\n"));=0A=
+		mpi_ssp_event(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_DEV_HANDLE_ARRIV:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_DEV_HANDLE_ARRIV\n"));=0A=
+		/*This is for target*/=0A=
+		break;=0A=
+	case OPC_OUB_SSP_RECV_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SSP_RECV_EVENT\n"));=0A=
+		/*This is for target*/=0A=
+		break;=0A=
+	case OPC_OUB_DEV_INFO:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_DEV_INFO\n"));=0A=
+		break;=0A=
+	case OPC_OUB_FW_FLASH_UPDATE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_FW_FLASH_UPDATE\n"));=0A=
+		mpi_fw_flash_update_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_GPIO_RESPONSE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GPIO_RESPONSE\n"));=0A=
+		break;=0A=
+	case OPC_OUB_GPIO_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GPIO_EVENT\n"));=0A=
+		break;=0A=
+	case OPC_OUB_GENERAL_EVENT:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GENERAL_EVENT\n"));=0A=
+		mpi_general_event(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SSP_ABORT_RSP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SSP_ABORT_RSP\n"));=0A=
+		mpi_task_abort_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SATA_ABORT_RSP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SATA_ABORT_RSP\n"));=0A=
+		mpi_task_abort_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SAS_DIAG_MODE_START_END:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SAS_DIAG_MODE_START_END\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SAS_DIAG_EXECUTE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SAS_DIAG_EXECUTE\n"));=0A=
+		break;=0A=
+	case OPC_OUB_GET_TIME_STAMP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GET_TIME_STAMP\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SAS_HW_EVENT_ACK:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SAS_HW_EVENT_ACK\n"));=0A=
+		break;=0A=
+	case OPC_OUB_PORT_CONTROL:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_PORT_CONTROL\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SMP_ABORT_RSP:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SMP_ABORT_RSP\n"));=0A=
+		mpi_task_abort_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_GET_NVMD_DATA:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GET_NVMD_DATA\n"));=0A=
+		mpi_get_nvmd_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_SET_NVMD_DATA:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SET_NVMD_DATA\n"));=0A=
+		mpi_set_nvmd_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_DEVICE_HANDLE_REMOVAL:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_DEVICE_HANDLE_REMOVAL\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SET_DEVICE_STATE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SET_DEVICE_STATE\n"));=0A=
+		mpi_set_dev_state_resp(pm8001_ha, piomb);=0A=
+		break;=0A=
+	case OPC_OUB_GET_DEVICE_STATE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_GET_DEVICE_STATE\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SET_DEV_INFO:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SET_DEV_INFO\n"));=0A=
+		break;=0A=
+	case OPC_OUB_SAS_RE_INITIALIZE:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("OPC_OUB_SAS_RE_INITIALIZE\n"));=0A=
+		break;=0A=
+	default:=0A=
+		PM8001_MSG_DBG(pm8001_ha,=0A=
+			pm8001_printk("Unknown outbound Queue IOMB OPC =3D %x\n",=0A=
+			opc));=0A=
+		break;=0A=
+	}=0A=
+}=0A=
+=0A=
+static int process_oq(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	struct outbound_queue_table *circularQ;=0A=
+	void *pMsg1 =3D NULL;=0A=
+	u8 bc =3D 0;=0A=
+	u32 ret =3D MPI_IO_STATUS_FAIL, processedMsgCount =3D 0;=0A=
+=0A=
+	circularQ =3D &pm8001_ha->outb_data[0];=0A=
+	do {=0A=
+		ret =3D mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);=0A=
+		if (MPI_IO_STATUS_SUCCESS =3D=3D ret) {=0A=
+			/* process the outbound message */=0A=
+			process_one_iomb(pm8001_ha, (void *)((u8 *)pMsg1 - 4));=0A=
+			/* free the message from the outbound circular buffer */=0A=
+			mpi_msg_free_set(pm8001_ha, circularQ, bc);=0A=
+			processedMsgCount++;=0A=
+		}=0A=
+		if (MPI_IO_STATUS_BUSY =3D=3D ret) {=0A=
+			u32 producer_index;=0A=
+			/* Update the producer index from SPC */=0A=
+			READ_32(&producer_index,=0A=
+				circularQ->pi_virt, 0);=0A=
+			circularQ->producer_index =3D cpu_to_le32(producer_index);=0A=
+			if (circularQ->producer_index =3D=3D=0A=
+				circularQ->consumer_idx)=0A=
+				/* OQ is empty */=0A=
+				break;=0A=
+		}=0A=
+	} while (100 > processedMsgCount);/*end message processing if hit the=0A=
+	count*/=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/* PCI_DMA_... to our direction translation. */=0A=
+static const u8 data_dir_flags[] =3D {=0A=
+	[PCI_DMA_BIDIRECTIONAL] =3D DATA_DIR_BYRECIPIENT,/* UNSPECIFIED */=0A=
+	[PCI_DMA_TODEVICE]	=3D DATA_DIR_OUT,/* OUTBOUND */=0A=
+	[PCI_DMA_FROMDEVICE]	=3D DATA_DIR_IN,/* INBOUND */=0A=
+	[PCI_DMA_NONE]		=3D DATA_DIR_NONE,/* NO TRANSFER */=0A=
+};=0A=
+static void=0A=
+pm8001_chip_make_sg(struct scatterlist *scatter, int nr, void *prd)=0A=
+{=0A=
+	int i;=0A=
+	struct scatterlist *sg;=0A=
+	struct pm8001_prd *buf_prd =3D prd;=0A=
+=0A=
+	for_each_sg(scatter, sg, nr, i) {=0A=
+		buf_prd->addr =3D cpu_to_le64(sg_dma_address(sg));=0A=
+		buf_prd->im_len.len =3D cpu_to_le32(sg_dma_len(sg));=0A=
+		buf_prd->im_len.e =3D 0;=0A=
+		buf_prd++;=0A=
+	}=0A=
+}=0A=
+=0A=
+static void build_smp_cmd(u32 deviceID, u32 hTag, struct smp_req =
*psmp_cmd)=0A=
+{=0A=
+	psmp_cmd->tag =3D cpu_to_le32(hTag);=0A=
+	psmp_cmd->device_id =3D cpu_to_le32(deviceID);=0A=
+	psmp_cmd->len_ip_ir =3D cpu_to_le32(1|(1 << 1));=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_smp_req - send a SMP task to FW=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @ccb: the ccb information this request used.=0A=
+ */=0A=
+static int pm8001_chip_smp_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	int elem, rc;=0A=
+	struct sas_task *task =3D ccb->task;=0A=
+	struct domain_device *dev =3D task->dev;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	struct scatterlist *sg_req, *sg_resp;=0A=
+	u32 req_len, resp_len;=0A=
+	struct smp_req smp_cmd;=0A=
+	u32 opc;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+=0A=
+	memset(&smp_cmd, 0, sizeof(smp_cmd));=0A=
+	/*=0A=
+	 * DMA-map SMP request, response buffers=0A=
+	 */=0A=
+	sg_req =3D &task->smp_task.smp_req;=0A=
+	elem =3D dma_map_sg(pm8001_ha->dev, sg_req, 1, PCI_DMA_TODEVICE);=0A=
+	if (!elem)=0A=
+		return -ENOMEM;=0A=
+	req_len =3D sg_dma_len(sg_req);=0A=
+=0A=
+	sg_resp =3D &task->smp_task.smp_resp;=0A=
+	elem =3D dma_map_sg(pm8001_ha->dev, sg_resp, 1, PCI_DMA_FROMDEVICE);=0A=
+	if (!elem) {=0A=
+		rc =3D -ENOMEM;=0A=
+		goto err_out;=0A=
+	}=0A=
+	resp_len =3D sg_dma_len(sg_resp);=0A=
+	/* must be in dwords */=0A=
+	if ((req_len & 0x3) || (resp_len & 0x3)) {=0A=
+		rc =3D -EINVAL;=0A=
+		goto err_out_2;=0A=
+	}=0A=
+=0A=
+	opc =3D OPC_INB_SMP_REQUEST;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	smp_cmd.tag =3D cpu_to_le32(ccb->ccb_tag);=0A=
+	smp_cmd.long_smp_req.long_req_addr =3D=0A=
+		cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));=0A=
+	smp_cmd.long_smp_req.long_req_size =3D=0A=
+		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_req)-4);=0A=
+	smp_cmd.long_smp_req.long_resp_addr =3D=0A=
+		cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_resp));=0A=
+	smp_cmd.long_smp_req.long_resp_size =3D=0A=
+		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);=0A=
+	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd);=0A=
+	return 0;=0A=
+=0A=
+err_out_2:=0A=
+	dma_unmap_sg(pm8001_ha->dev, &ccb->task->smp_task.smp_resp, 1,=0A=
+			PCI_DMA_FROMDEVICE);=0A=
+err_out:=0A=
+	dma_unmap_sg(pm8001_ha->dev, &ccb->task->smp_task.smp_req, 1,=0A=
+			PCI_DMA_TODEVICE);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_ssp_io_req - send a SSP task to FW=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @ccb: the ccb information this request used.=0A=
+ */=0A=
+static int pm8001_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	struct sas_task *task =3D ccb->task;=0A=
+	struct domain_device *dev =3D task->dev;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	struct ssp_ini_io_start_req ssp_cmd;=0A=
+	u32 tag =3D ccb->ccb_tag;=0A=
+	__le64 phys_addr;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 opc =3D OPC_INB_SSPINIIOSTART;=0A=
+	memset(&ssp_cmd, 0, sizeof(ssp_cmd));=0A=
+	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);=0A=
+	ssp_cmd.dir_m_tlr =3D data_dir_flags[task->data_dir] << 8 | 0x0;/*0 for=0A=
+	SAS 1.1 compatible TLR*/=0A=
+	ssp_cmd.data_len =3D cpu_to_le32(task->total_xfer_len);=0A=
+	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);=0A=
+	ssp_cmd.tag =3D cpu_to_le32(tag);=0A=
+	if (task->ssp_task.enable_first_burst)=0A=
+		ssp_cmd.ssp_iu.efb_prio_attr |=3D 0x80;=0A=
+	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_prio << 3);=0A=
+	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);=0A=
+	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cdb, 16);=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+=0A=
+	/* fill in PRD (scatter/gather) table, if any */=0A=
+	if (task->num_scatter > 1) {=0A=
+		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);=0A=
+		phys_addr =3D cpu_to_le64(virt_to_bus((void *)(ccb->buf_prd)));=0A=
+		ssp_cmd.addr_low =3D LOW_32_BITS(phys_addr);=0A=
+		ssp_cmd.addr_high =3D HIGH_32_BITS(phys_addr);=0A=
+		ssp_cmd.esgl =3D cpu_to_le32(1<<31);=0A=
+	} else if (task->num_scatter =3D=3D 1) {=0A=
+		__le64 dma_addr =3D cpu_to_le64(sg_dma_address(task->scatter));=0A=
+		ssp_cmd.addr_low =3D LOW_32_BITS(dma_addr);=0A=
+		ssp_cmd.addr_high =3D HIGH_32_BITS(dma_addr);=0A=
+		ssp_cmd.len =3D cpu_to_le32(task->total_xfer_len);=0A=
+		ssp_cmd.esgl =3D 0;=0A=
+	} else if (task->num_scatter =3D=3D 0) {=0A=
+		ssp_cmd.addr_low =3D 0;=0A=
+		ssp_cmd.addr_high =3D 0;=0A=
+		ssp_cmd.len =3D cpu_to_le32(task->total_xfer_len);=0A=
+		ssp_cmd.esgl =3D 0;=0A=
+	}=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	struct sas_task *task =3D ccb->task;=0A=
+	struct domain_device *dev =3D task->dev;=0A=
+	struct pm8001_device *pm8001_ha_dev =3D dev->lldd_dev;=0A=
+	u32 tag =3D ccb->ccb_tag;=0A=
+	struct sata_start_req sata_cmd;=0A=
+	u32 hdr_tag, ncg_tag =3D 0;=0A=
+	__le64 phys_addr;=0A=
+	u32 ATAP =3D 0x0;=0A=
+	u32 dir;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32  opc =3D OPC_INB_SATA_HOST_OPSTART;=0A=
+	memset(&sata_cmd, 0, sizeof(sata_cmd));=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	if (task->data_dir =3D=3D PCI_DMA_NONE) {=0A=
+		ATAP =3D 0x04;  /* no data*/=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data \n"));=0A=
+	} else if (likely(!task->ata_task.device_control_reg_update)) {=0A=
+		if (task->ata_task.dma_xfer) {=0A=
+			ATAP =3D 0x06; /* DMA */=0A=
+			PM8001_IO_DBG(pm8001_ha, pm8001_printk("DMA \n"));=0A=
+		} else {=0A=
+			ATAP =3D 0x05; /* PIO*/=0A=
+			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO \n"));=0A=
+		}=0A=
+		if (task->ata_task.use_ncq &&=0A=
+			dev->sata_dev.command_set !=3D ATAPI_COMMAND_SET) {=0A=
+			ATAP =3D 0x07; /* FPDMA */=0A=
+			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA \n"));=0A=
+		}=0A=
+	}=0A=
+	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag))=0A=
+		ncg_tag =3D cpu_to_le32(hdr_tag);=0A=
+	dir =3D data_dir_flags[task->data_dir] << 8;=0A=
+	sata_cmd.tag =3D cpu_to_le32(tag);=0A=
+	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);=0A=
+	sata_cmd.data_len =3D cpu_to_le32(task->total_xfer_len);=0A=
+	sata_cmd.ncqtag_atap_dir_m =3D=0A=
+		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);=0A=
+	sata_cmd.sata_fis =3D task->ata_task.fis;=0A=
+	if (likely(!task->ata_task.device_control_reg_update))=0A=
+		sata_cmd.sata_fis.flags |=3D 0x80;/* C=3D1: update ATA cmd reg */=0A=
+	sata_cmd.sata_fis.flags &=3D 0xF0;/* PM_PORT field shall be 0 */=0A=
+	/* fill in PRD (scatter/gather) table, if any */=0A=
+	if (task->num_scatter > 1) {=0A=
+		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);=0A=
+		phys_addr =3D cpu_to_le64(virt_to_bus((void *)(ccb->buf_prd)));=0A=
+		sata_cmd.addr_low =3D LOW_32_BITS(phys_addr);=0A=
+		sata_cmd.addr_high =3D HIGH_32_BITS(phys_addr);=0A=
+		sata_cmd.esgl =3D cpu_to_le32(1 << 31);=0A=
+	} else if (task->num_scatter =3D=3D 1) {=0A=
+		__le64 dma_addr =3D cpu_to_le64(sg_dma_address(task->scatter));=0A=
+		sata_cmd.addr_low =3D LOW_32_BITS(dma_addr);=0A=
+		sata_cmd.addr_high =3D HIGH_32_BITS(dma_addr);=0A=
+		sata_cmd.len =3D cpu_to_le32(task->total_xfer_len);=0A=
+		sata_cmd.esgl =3D 0;=0A=
+	} else if (task->num_scatter =3D=3D 0) {=0A=
+		sata_cmd.addr_low =3D 0;=0A=
+		sata_cmd.addr_high =3D 0;=0A=
+		sata_cmd.len =3D cpu_to_le32(task->total_xfer_len);=0A=
+		sata_cmd.esgl =3D 0;=0A=
+	}=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_phy_start_req - start phy via PHY_START COMMAND=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @num: the inbound queue number=0A=
+ * @phy_id: the phy id which we wanted to start up.=0A=
+ */=0A=
+static int=0A=
+pm8001_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)=0A=
+{=0A=
+	struct phy_start_req payload;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 tag =3D 0x01;=0A=
+	u32 opcode =3D OPC_INB_PHYSTART;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memset(&payload, 0, sizeof(payload));=0A=
+	payload.tag =3D cpu_to_le32(tag);=0A=
+	/*=0A=
+	 ** [0:7]   PHY Identifier=0A=
+	 ** [8:11]  link rate 1.5G, 3G, 6G=0A=
+	 ** [12:13] link mode 01b SAS mode; 10b SATA mode; 11b both=0A=
+	 ** [14]    0b disable spin up hold; 1b enable spin up hold=0A=
+	 */=0A=
+	payload.ase_sh_lm_slr_phyid =3D cpu_to_le32(SPINHOLD_DISABLE |=0A=
+		LINKMODE_AUTO |	LINKRATE_15 |=0A=
+		LINKRATE_30 | LINKRATE_60 | phy_id);=0A=
+	payload.sas_identify.dev_type =3D SAS_END_DEV;=0A=
+	payload.sas_identify.initiator_bits =3D SAS_PROTOCOL_ALL;=0A=
+	memcpy(payload.sas_identify.sas_addr,=0A=
+		pm8001_ha->sas_addr, SAS_ADDR_SIZE);=0A=
+	payload.sas_identify.phy_id =3D phy_id;=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_phy_stop_req - start phy via PHY_STOP COMMAND=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @num: the inbound queue number=0A=
+ * @phy_id: the phy id which we wanted to start up.=0A=
+ */=0A=
+static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	u8 phy_id)=0A=
+{=0A=
+	struct phy_stop_req payload;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 tag =3D 0x01;=0A=
+	u32 opcode =3D OPC_INB_PHYSTOP;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memset(&payload, 0, sizeof(payload));=0A=
+	payload.tag =3D cpu_to_le32(tag);=0A=
+	payload.phy_id =3D cpu_to_le32(phy_id);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * see comments on mpi_reg_resp.=0A=
+ */=0A=
+static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_device *pm8001_dev, u32 flag)=0A=
+{=0A=
+	struct reg_dev_req payload;=0A=
+	u32	opc;=0A=
+	u32 stp_sspsmp_sata =3D 0x4;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 linkrate, phy_id;=0A=
+	u32 rc, tag =3D 0xdeadbeef;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	u8 retryFlag =3D 0x1;=0A=
+	u16 firstBurstSize =3D 0;=0A=
+	u16 ITNT =3D 2000;=0A=
+	struct domain_device *dev =3D pm8001_dev->sas_device;=0A=
+	struct domain_device *parent_dev =3D dev->parent;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+=0A=
+	memset(&payload, 0, sizeof(payload));=0A=
+	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (rc)=0A=
+		return rc;=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	ccb->device =3D pm8001_dev;=0A=
+	ccb->ccb_tag =3D tag;=0A=
+	payload.tag =3D cpu_to_le32(tag);=0A=
+	if (flag =3D=3D 1)=0A=
+		stp_sspsmp_sata =3D 0x02; /*direct attached sata */=0A=
+	else {=0A=
+		if (pm8001_dev->dev_type =3D=3D SATA_DEV)=0A=
+			stp_sspsmp_sata =3D 0x00; /* stp*/=0A=
+		else if (pm8001_dev->dev_type =3D=3D SAS_END_DEV ||=0A=
+			pm8001_dev->dev_type =3D=3D EDGE_DEV ||=0A=
+			pm8001_dev->dev_type =3D=3D FANOUT_DEV)=0A=
+			stp_sspsmp_sata =3D 0x01; /*ssp or smp*/=0A=
+	}=0A=
+	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))=0A=
+		phy_id =3D parent_dev->ex_dev.ex_phy->phy_id;=0A=
+	else=0A=
+		phy_id =3D pm8001_dev->attached_phy;=0A=
+	opc =3D OPC_INB_REG_DEV;=0A=
+	linkrate =3D pm8001_dev->sas_device->linkrate;=0A=
+	payload.phyid_portid =3D=0A=
+		cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0x0F) |=0A=
+		((phy_id & 0x0F) << 4));=0A=
+	payload.dtype_dlr_retry =3D cpu_to_le32((retryFlag & 0x01) |=0A=
+		((linkrate & 0x0F) * 0x1000000) |=0A=
+		((stp_sspsmp_sata & 0x03) * 0x10000000));=0A=
+	payload.firstburstsize_ITNexustimeout =3D=0A=
+		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));=0A=
+	memcpy(&payload.sas_addr_hi, pm8001_dev->sas_device->sas_addr,=0A=
+		SAS_ADDR_SIZE);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * see comments on mpi_reg_resp.=0A=
+ */=0A=
+static int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 device_id)=0A=
+{=0A=
+	struct dereg_dev_req payload;=0A=
+	u32 opc =3D OPC_INB_DEREG_DEV_HANDLE;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memset((u8 *)&payload, 0, sizeof(payload));=0A=
+	payload.tag =3D 1;=0A=
+	payload.device_id =3D cpu_to_le32(device_id);=0A=
+	PM8001_MSG_DBG(pm8001_ha,=0A=
+		pm8001_printk("unregister device device_id =3D %d\n", device_id));=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_phy_ctl_req - support the local phy operation=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @num: the inbound queue number=0A=
+ * @phy_id: the phy id which we wanted to operate=0A=
+ * @phy_op:=0A=
+ */=0A=
+static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	u32 phyId, u32 phy_op)=0A=
+{=0A=
+	struct local_phy_ctl_req payload;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 opc =3D OPC_INB_LOCAL_PHY_CONTROL;=0A=
+	memset((u8 *)&payload, 0, sizeof(payload));=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	payload.tag =3D 1;=0A=
+	payload.phyop_phyid =3D=0A=
+		cpu_to_le32(((phy_op & 0xff) << 8) | (phyId & 0x0F));=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info =
*pm8001_ha)=0A=
+{=0A=
+	u32 value;=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	return 1;=0A=
+#endif=0A=
+	value =3D pm8001_cr32(pm8001_ha, 0, MSGU_ODR);=0A=
+	if (value)=0A=
+		return 1;=0A=
+	return 0;=0A=
+=0A=
+}=0A=
+=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_isr - PM8001 isr handler.=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @irq: irq number.=0A=
+ * @stat: stat.=0A=
+ */=0A=
+static void=0A=
+pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	pm8001_chip_interrupt_disable(pm8001_ha);=0A=
+	process_oq(pm8001_ha);=0A=
+	pm8001_chip_interrupt_enable(pm8001_ha);=0A=
+}=0A=
+=0A=
+static int send_task_abort(struct pm8001_hba_info *pm8001_ha, u32 opc,=0A=
+	u32 dev_id, u8 flag, u32 task_tag, u32 cmd_tag)=0A=
+{=0A=
+	struct task_abort_req task_abort;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memset(&task_abort, 0, sizeof(task_abort));=0A=
+	if (ABORT_SINGLE =3D=3D (flag & ABORT_MASK)) {=0A=
+		task_abort.abort_all =3D 0;=0A=
+		task_abort.device_id =3D cpu_to_le32(dev_id);=0A=
+		task_abort.tag_to_abort =3D cpu_to_le32(task_tag);=0A=
+		task_abort.tag =3D cpu_to_le32(cmd_tag);=0A=
+	} else if (ABORT_ALL =3D=3D (flag & ABORT_MASK)) {=0A=
+		task_abort.abort_all =3D cpu_to_le32(1);=0A=
+		task_abort.device_id =3D cpu_to_le32(dev_id);=0A=
+		task_abort.tag =3D cpu_to_le32(cmd_tag);=0A=
+	}=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_abort_task - SAS abort task when error or exception =
happened.=0A=
+ * @task: the task we wanted to aborted.=0A=
+ * @flag: the abort flag.=0A=
+ */=0A=
+static int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_device *pm8001_dev, u8 flag, u32 task_tag, u32 cmd_tag)=0A=
+{=0A=
+	u32 opc, device_id;=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	PM8001_IO_DBG(pm8001_ha, pm8001_printk("Abort tag[%x]", task_tag));=0A=
+	if (pm8001_dev->dev_type =3D=3D SAS_END_DEV)=0A=
+		opc =3D OPC_INB_SSP_ABORT;=0A=
+	else if (pm8001_dev->dev_type =3D=3D SATA_DEV)=0A=
+		opc =3D OPC_INB_SATA_ABORT;=0A=
+	else=0A=
+		opc =3D OPC_INB_SMP_ABORT;/* SMP */=0A=
+	device_id =3D pm8001_dev->device_id;=0A=
+	rc =3D send_task_abort(pm8001_ha, opc, device_id, flag,=0A=
+		task_tag, cmd_tag);=0A=
+	if (rc !=3D TMF_RESP_FUNC_COMPLETE)=0A=
+		PM8001_IO_DBG(pm8001_ha, pm8001_printk("rc=3D %d\n", rc));=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_ssp_tm_req - built the task managment command.=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @ccb: the ccb information.=0A=
+ * @tmf: task management function.=0A=
+ */=0A=
+static int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb, struct pm8001_tmf_task *tmf)=0A=
+{=0A=
+	struct sas_task *task =3D ccb->task;=0A=
+	struct domain_device *dev =3D task->dev;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	u32 opc =3D OPC_INB_SSPINITMSTART;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	struct ssp_ini_tm_start_req sspTMCmd;=0A=
+=0A=
+	memset(&sspTMCmd, 0, sizeof(sspTMCmd));=0A=
+	sspTMCmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);=0A=
+	sspTMCmd.relate_tag =3D cpu_to_le32(tmf->tag_of_task_to_be_managed);=0A=
+	sspTMCmd.tmf =3D cpu_to_le32(tmf->tmf);=0A=
+	sspTMCmd.ds_ads_m =3D cpu_to_le32(1 << 2);=0A=
+	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);=0A=
+	sspTMCmd.tag =3D cpu_to_le32(ccb->ccb_tag);=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	void *payload)=0A=
+{=0A=
+	u32 opc =3D OPC_INB_GET_NVMD_DATA;=0A=
+	u32 nvmd_type;=0A=
+	u32 rc;=0A=
+	u32 tag;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	struct get_nvm_data_req nvmd_req;=0A=
+	struct fw_control_ex *fw_control_context;=0A=
+	struct pm8001_ioctl_payload *ioctl_payload =3D payload;=0A=
+=0A=
+	nvmd_type =3D ioctl_payload->minor_function;=0A=
+	fw_control_context =3D kzalloc(sizeof(struct fw_control_ex), =
GFP_KERNEL);=0A=
+	fw_control_context->usrAddr =3D (u8 *)&ioctl_payload->func_specific[0];=0A=
+	fw_control_context->len =3D ioctl_payload->length;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memset(&nvmd_req, 0, sizeof(nvmd_req));=0A=
+	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (rc)=0A=
+		return rc;=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	ccb->ccb_tag =3D tag;=0A=
+	ccb->fw_control_context =3D fw_control_context;=0A=
+	nvmd_req.tag =3D cpu_to_le32(tag);=0A=
+=0A=
+	switch (nvmd_type) {=0A=
+	case TWI_DEVICE: {=0A=
+		u32 twi_addr, twi_page_size;=0A=
+		twi_addr =3D 0xa8;=0A=
+		twi_page_size =3D 2;=0A=
+=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | twi_addr << 16 |=0A=
+			twi_page_size << 8 | TWI_DEVICE);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	}=0A=
+	case C_SEEPROM: {=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | C_SEEPROM);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	}=0A=
+	case VPD_FLASH: {=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | VPD_FLASH);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	}=0A=
+	case EXPAN_ROM: {=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | EXPAN_ROM);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	}=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	void *payload)=0A=
+{=0A=
+	u32 opc =3D OPC_INB_SET_NVMD_DATA;=0A=
+	u32 nvmd_type;=0A=
+	u32 rc;=0A=
+	u32 tag;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	struct set_nvm_data_req nvmd_req;=0A=
+	struct fw_control_ex *fw_control_context;=0A=
+	struct pm8001_ioctl_payload *ioctl_payload =3D payload;=0A=
+=0A=
+	nvmd_type =3D ioctl_payload->minor_function;=0A=
+	fw_control_context =3D kzalloc(sizeof(struct fw_control_ex), =
GFP_KERNEL);=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,=0A=
+		ioctl_payload->func_specific,=0A=
+		ioctl_payload->length);=0A=
+	memset(&nvmd_req, 0, sizeof(nvmd_req));=0A=
+	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (rc)=0A=
+		return rc;=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	ccb->fw_control_context =3D fw_control_context;=0A=
+	ccb->ccb_tag =3D tag;=0A=
+	nvmd_req.tag =3D cpu_to_le32(tag);=0A=
+	switch (nvmd_type) {=0A=
+	case TWI_DEVICE: {=0A=
+		u32 twi_addr, twi_page_size;=0A=
+		twi_addr =3D 0xa8;=0A=
+		twi_page_size =3D 2;=0A=
+		nvmd_req.reserved[0] =3D cpu_to_le32(0xFEDCBA98);=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | twi_addr << 16 |=0A=
+			twi_page_size << 8 | TWI_DEVICE);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	}=0A=
+	case C_SEEPROM:=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | C_SEEPROM);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.reserved[0] =3D cpu_to_le32(0xFEDCBA98);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	case VPD_FLASH:=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | VPD_FLASH);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.reserved[0] =3D cpu_to_le32(0xFEDCBA98);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	case EXPAN_ROM:=0A=
+		nvmd_req.len_ir_vpdd =3D cpu_to_le32(IPMode | EXPAN_ROM);=0A=
+		nvmd_req.resp_len =3D cpu_to_le32(ioctl_payload->length);=0A=
+		nvmd_req.reserved[0] =3D cpu_to_le32(0xFEDCBA98);=0A=
+		nvmd_req.resp_addr_hi =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);=0A=
+		nvmd_req.resp_addr_lo =3D=0A=
+		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_chip_fw_flash_update_build - support the firmware update =
operation=0A=
+ * @pm8001_ha: our hba card information.=0A=
+ * @fw_flash_updata_info: firmware flash update param=0A=
+ */=0A=
+static int=0A=
+pm8001_chip_fw_flash_update_build(struct pm8001_hba_info *pm8001_ha,=0A=
+	void *fw_flash_updata_info, u32 tag)=0A=
+{=0A=
+	struct fw_flash_Update_req payload;=0A=
+	struct fw_flash_updata_info *info;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	u32 opc =3D OPC_INB_FW_FLASH_UPDATE;=0A=
+=0A=
+	memset((u8 *)&payload, 0, sizeof(struct fw_flash_Update_req));=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	info =3D fw_flash_updata_info;=0A=
+	payload.tag =3D cpu_to_le32(tag);=0A=
+	payload.cur_image_len =3D cpu_to_le32(info->cur_image_len);=0A=
+	payload.cur_image_offset =3D cpu_to_le32(info->cur_image_offset);=0A=
+	payload.total_image_len =3D cpu_to_le32(info->total_image_len);=0A=
+	payload.len =3D info->sgl.im_len.len ;=0A=
+	payload.sgl_addr_lo =3D LOW_32_BITS(info->sgl.addr);=0A=
+	payload.sgl_addr_hi =3D HIGH_32_BITS(info->sgl.addr);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	void *payload)=0A=
+{=0A=
+	struct fw_flash_updata_info flash_update_info;=0A=
+	struct fw_control_info *fw_control;=0A=
+	struct fw_control_ex *fw_control_context;=0A=
+	u32 rc;=0A=
+	u32 tag;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	void *buffer =3D NULL;=0A=
+	dma_addr_t phys_addr;=0A=
+	u32 phys_addr_hi;=0A=
+	u32 phys_addr_lo;=0A=
+	struct pm8001_ioctl_payload *ioctl_payload =3D payload;=0A=
+=0A=
+	fw_control_context =3D kzalloc(sizeof(struct fw_control_ex), =
GFP_KERNEL);=0A=
+	fw_control =3D (struct fw_control_info =
*)&ioctl_payload->func_specific[0];=0A=
+	if (fw_control->len !=3D 0) {=0A=
+		if (pm8001_mem_alloc(pm8001_ha->pdev,=0A=
+			(void **)&buffer,=0A=
+			&phys_addr,=0A=
+			&phys_addr_hi,=0A=
+			&phys_addr_lo,=0A=
+			fw_control->len, 0) !=3D 0) {=0A=
+				PM8001_FAIL_DBG(pm8001_ha,=0A=
+					pm8001_printk("Mem alloc failure\n"));=0A=
+				return -ENOMEM;=0A=
+		}=0A=
+	}=0A=
+	memset((void *)buffer, 0, fw_control->len);=0A=
+	memcpy((void *)buffer, fw_control->buffer, fw_control->len);=0A=
+	flash_update_info.sgl.addr =3D cpu_to_le64(phys_addr);=0A=
+	flash_update_info.sgl.im_len.len =3D cpu_to_le32(fw_control->len);=0A=
+	flash_update_info.sgl.im_len.e =3D 0;=0A=
+	flash_update_info.cur_image_offset =3D fw_control->offset;=0A=
+	flash_update_info.cur_image_len =3D fw_control->len;=0A=
+	flash_update_info.total_image_len =3D fw_control->size;=0A=
+	fw_control_context->fw_control =3D fw_control;=0A=
+	fw_control_context->virtAddr =3D buffer;=0A=
+	fw_control_context->len =3D fw_control->len;=0A=
+	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (rc)=0A=
+		return rc;=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	ccb->fw_control_context =3D fw_control_context;=0A=
+	ccb->ccb_tag =3D tag;=0A=
+	pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info, tag);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_device *pm8001_dev, u32 state)=0A=
+{=0A=
+	struct set_dev_state_req payload;=0A=
+	struct inbound_queue_table *circularQ;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	u32 rc;=0A=
+	u32 tag;=0A=
+	u32 opc =3D OPC_INB_SET_DEVICE_STATE;=0A=
+	memset((u8 *)&payload, 0, sizeof(payload));=0A=
+	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (rc)=0A=
+		return -1;=0A=
+	ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+	ccb->ccb_tag =3D tag;=0A=
+	ccb->device =3D pm8001_dev;=0A=
+	circularQ =3D &pm8001_ha->inb_data[0];=0A=
+	payload.tag =3D cpu_to_le32(tag);=0A=
+	payload.device_id =3D cpu_to_le32(pm8001_dev->device_id);=0A=
+	payload.nds =3D cpu_to_le32(state);=0A=
+	mpi_build_cmd(pm8001_ha, circularQ, opc, &payload);=0A=
+	return 0;=0A=
+=0A=
+}=0A=
+=0A=
+const struct pm8001_dispatch pm8001_8001_dispatch =3D {=0A=
+	.name			=3D "pmc8001",=0A=
+	.chip_init		=3D pm8001_chip_init,=0A=
+	.chip_soft_rst		=3D pm8001_chip_soft_rst,=0A=
+	.chip_rst		=3D pm8001_hw_chip_rst,=0A=
+	.chip_iounmap		=3D pm8001_chip_iounmap,=0A=
+	.isr			=3D pm8001_chip_isr,=0A=
+	.is_our_interupt	=3D pm8001_chip_is_our_interupt,=0A=
+	.isr_process_oq		=3D process_oq,=0A=
+	.interrupt_enable 	=3D pm8001_chip_interrupt_enable,=0A=
+	.interrupt_disable	=3D pm8001_chip_interrupt_disable,=0A=
+	.make_prd		=3D pm8001_chip_make_sg,=0A=
+	.smp_req		=3D pm8001_chip_smp_req,=0A=
+	.ssp_io_req		=3D pm8001_chip_ssp_io_req,=0A=
+	.sata_req		=3D pm8001_chip_sata_req,=0A=
+	.phy_start_req		=3D pm8001_chip_phy_start_req,=0A=
+	.phy_stop_req		=3D pm8001_chip_phy_stop_req,=0A=
+	.reg_dev_req		=3D pm8001_chip_reg_dev_req,=0A=
+	.dereg_dev_req		=3D pm8001_chip_dereg_dev_req,=0A=
+	.phy_ctl_req		=3D pm8001_chip_phy_ctl_req,=0A=
+	.task_abort		=3D pm8001_chip_abort_task,=0A=
+	.ssp_tm_req		=3D pm8001_chip_ssp_tm_req,=0A=
+	.get_nvmd_req		=3D pm8001_chip_get_nvmd_req,=0A=
+	.set_nvmd_req		=3D pm8001_chip_set_nvmd_req,=0A=
+	.fw_flash_update_req	=3D pm8001_chip_fw_flash_update_req,=0A=
+	.set_dev_state_req	=3D pm8001_chip_set_dev_state_req,=0A=
+};=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h =
b/drivers/scsi/pm8001/pm8001_hwi.h=0A=
new file mode 100644=0A=
index 0000000..3690a2b=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.h=0A=
@@ -0,0 +1,1011 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+#ifndef _PMC8001_REG_H_=0A=
+#define _PMC8001_REG_H_=0A=
+=0A=
+#include <linux/types.h>=0A=
+#include <scsi/libsas.h>=0A=
+=0A=
+=0A=
+/* for Request Opcode of IOMB */=0A=
+#define OPC_INB_ECHO				1	/* 0x000 */=0A=
+#define OPC_INB_PHYSTART			4	/* 0x004 */=0A=
+#define OPC_INB_PHYSTOP				5	/* 0x005 */=0A=
+#define OPC_INB_SSPINIIOSTART			6	/* 0x006 */=0A=
+#define OPC_INB_SSPINITMSTART			7	/* 0x007 */=0A=
+#define OPC_INB_SSPINIEXTIOSTART		8	/* 0x008 */=0A=
+#define OPC_INB_DEV_HANDLE_ACCEPT		9	/* 0x009 */=0A=
+#define OPC_INB_SSPTGTIOSTART			10	/* 0x00A */=0A=
+#define OPC_INB_SSPTGTRSPSTART			11	/* 0x00B */=0A=
+#define OPC_INB_SSPINIEDCIOSTART		12	/* 0x00C */=0A=
+#define OPC_INB_SSPINIEXTEDCIOSTART		13	/* 0x00D */=0A=
+#define OPC_INB_SSPTGTEDCIOSTART		14	/* 0x00E */=0A=
+#define OPC_INB_SSP_ABORT			15	/* 0x00F */=0A=
+#define OPC_INB_DEREG_DEV_HANDLE		16	/* 0x010 */=0A=
+#define OPC_INB_GET_DEV_HANDLE			17	/* 0x011 */=0A=
+#define OPC_INB_SMP_REQUEST			18	/* 0x012 */=0A=
+/* SMP_RESPONSE is removed */=0A=
+#define OPC_INB_SMP_RESPONSE			19	/* 0x013 */=0A=
+#define OPC_INB_SMP_ABORT			20	/* 0x014 */=0A=
+#define OPC_INB_REG_DEV				22	/* 0x016 */=0A=
+#define OPC_INB_SATA_HOST_OPSTART		23	/* 0x017 */=0A=
+#define OPC_INB_SATA_ABORT			24	/* 0x018 */=0A=
+#define OPC_INB_LOCAL_PHY_CONTROL		25	/* 0x019 */=0A=
+#define OPC_INB_GET_DEV_INFO			26	/* 0x01A */=0A=
+#define OPC_INB_FW_FLASH_UPDATE			32	/* 0x020 */=0A=
+#define OPC_INB_GPIO				34	/* 0x022 */=0A=
+#define OPC_INB_SAS_DIAG_MODE_START_END		35	/* 0x023 */=0A=
+#define OPC_INB_SAS_DIAG_EXECUTE		36	/* 0x024 */=0A=
+#define OPC_INB_SAS_HW_EVENT_ACK		37	/* 0x025 */=0A=
+#define OPC_INB_GET_TIME_STAMP			38	/* 0x026 */=0A=
+#define OPC_INB_PORT_CONTROL			39	/* 0x027 */=0A=
+#define OPC_INB_GET_NVMD_DATA			40	/* 0x028 */=0A=
+#define OPC_INB_SET_NVMD_DATA			41	/* 0x029 */=0A=
+#define OPC_INB_SET_DEVICE_STATE		42	/* 0x02A */=0A=
+#define OPC_INB_GET_DEVICE_STATE		43	/* 0x02B */=0A=
+#define OPC_INB_SET_DEV_INFO			44	/* 0x02C */=0A=
+#define OPC_INB_SAS_RE_INITIALIZE		45	/* 0x02D */=0A=
+=0A=
+/* for Response Opcode of IOMB */=0A=
+#define OPC_OUB_ECHO				1	/* 0x001 */=0A=
+#define OPC_OUB_HW_EVENT			4	/* 0x004 */=0A=
+#define OPC_OUB_SSP_COMP			5	/* 0x005 */=0A=
+#define OPC_OUB_SMP_COMP			6	/* 0x006 */=0A=
+#define OPC_OUB_LOCAL_PHY_CNTRL			7	/* 0x007 */=0A=
+#define OPC_OUB_DEV_REGIST			10	/* 0x00A */=0A=
+#define OPC_OUB_DEREG_DEV			11	/* 0x00B */=0A=
+#define OPC_OUB_GET_DEV_HANDLE			12	/* 0x00C */=0A=
+#define OPC_OUB_SATA_COMP			13	/* 0x00D */=0A=
+#define OPC_OUB_SATA_EVENT			14	/* 0x00E */=0A=
+#define OPC_OUB_SSP_EVENT			15	/* 0x00F */=0A=
+#define OPC_OUB_DEV_HANDLE_ARRIV		16	/* 0x010 */=0A=
+/* SMP_RECEIVED Notification is removed */=0A=
+#define OPC_OUB_SMP_RECV_EVENT			17	/* 0x011 */=0A=
+#define OPC_OUB_SSP_RECV_EVENT			18	/* 0x012 */=0A=
+#define OPC_OUB_DEV_INFO			19	/* 0x013 */=0A=
+#define OPC_OUB_FW_FLASH_UPDATE			20	/* 0x014 */=0A=
+#define OPC_OUB_GPIO_RESPONSE			22	/* 0x016 */=0A=
+#define OPC_OUB_GPIO_EVENT			23	/* 0x017 */=0A=
+#define OPC_OUB_GENERAL_EVENT			24	/* 0x018 */=0A=
+#define OPC_OUB_SSP_ABORT_RSP			26	/* 0x01A */=0A=
+#define OPC_OUB_SATA_ABORT_RSP			27	/* 0x01B */=0A=
+#define OPC_OUB_SAS_DIAG_MODE_START_END		28	/* 0x01C */=0A=
+#define OPC_OUB_SAS_DIAG_EXECUTE		29	/* 0x01D */=0A=
+#define OPC_OUB_GET_TIME_STAMP			30	/* 0x01E */=0A=
+#define OPC_OUB_SAS_HW_EVENT_ACK		31	/* 0x01F */=0A=
+#define OPC_OUB_PORT_CONTROL			32	/* 0x020 */=0A=
+#define OPC_OUB_SKIP_ENTRY			33	/* 0x021 */=0A=
+#define OPC_OUB_SMP_ABORT_RSP			34	/* 0x022 */=0A=
+#define OPC_OUB_GET_NVMD_DATA			35	/* 0x023 */=0A=
+#define OPC_OUB_SET_NVMD_DATA			36	/* 0x024 */=0A=
+#define OPC_OUB_DEVICE_HANDLE_REMOVAL		37	/* 0x025 */=0A=
+#define OPC_OUB_SET_DEVICE_STATE		38	/* 0x026 */=0A=
+#define OPC_OUB_GET_DEVICE_STATE		39	/* 0x027 */=0A=
+#define OPC_OUB_SET_DEV_INFO			40	/* 0x028 */=0A=
+#define OPC_OUB_SAS_RE_INITIALIZE		41	/* 0x029 */=0A=
+=0A=
+/* for phy start*/=0A=
+#define SPINHOLD_DISABLE		(0x00 << 14)=0A=
+#define SPINHOLD_ENABLE			(0x01 << 14)=0A=
+#define LINKMODE_SAS			(0x01 << 12)=0A=
+#define LINKMODE_DSATA			(0x02 << 12)=0A=
+#define LINKMODE_AUTO			(0x03 << 12)=0A=
+#define LINKRATE_15			(0x01 << 8)=0A=
+#define LINKRATE_30			(0x02 << 8)=0A=
+#define LINKRATE_60			(0x04 << 8)=0A=
+=0A=
+struct mpi_msg_hdr{=0A=
+	__le32	header;	/* Bits [11:0]  - Message operation code */=0A=
+	/* Bits [15:12] - Message Category */=0A=
+	/* Bits [21:16] - Outboundqueue ID for the=0A=
+	operation completion message */=0A=
+	/* Bits [23:22] - Reserved */=0A=
+	/* Bits [28:24] - Buffer Count, indicates how=0A=
+	many buffer are allocated for the massage */=0A=
+	/* Bits [30:29] - Reserved */=0A=
+	/* Bits [31] - Message Valid bit */=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of PHY Start Command=0A=
+ * use to describe enable the phy (64 bytes)=0A=
+ */=0A=
+struct phy_start_req {=0A=
+	__le32	tag;=0A=
+	__le32	ase_sh_lm_slr_phyid;=0A=
+	struct sas_identify_frame sas_identify;=0A=
+	u32	reserved[5];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of PHY Start Command=0A=
+ * use to disable the phy (64 bytes)=0A=
+ */=0A=
+struct phy_stop_req {=0A=
+	__le32	tag;=0A=
+	__le32	phy_id;=0A=
+	u32	reserved[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/* set device bits fis - device to host */=0A=
+struct  set_dev_bits_fis {=0A=
+	u8	fis_type;	/* 0xA1*/=0A=
+	u8	n_i_pmport;=0A=
+	/* b7 : n Bit. Notification bit. If set device needs attention. */=0A=
+	/* b6 : i Bit. Interrupt Bit */=0A=
+	/* b5-b4: reserved2 */=0A=
+	/* b3-b0: PM Port */=0A=
+	u8 	status;=0A=
+	u8	error;=0A=
+	u32	_r_a;=0A=
+} __attribute__ ((packed));=0A=
+/* PIO setup FIS - device to host */=0A=
+struct  pio_setup_fis {=0A=
+	u8	fis_type;	/* 0x5f */=0A=
+	u8	i_d_pmPort;=0A=
+	/* b7 : reserved */=0A=
+	/* b6 : i bit. Interrupt bit */=0A=
+	/* b5 : d bit. data transfer direction. set to 1 for device to host=0A=
+	xfer */=0A=
+	/* b4 : reserved */=0A=
+	/* b3-b0: PM Port */=0A=
+	u8	status;=0A=
+	u8	error;=0A=
+	u8	lbal;=0A=
+	u8	lbam;=0A=
+	u8	lbah;=0A=
+	u8	device;=0A=
+	u8	lbal_exp;=0A=
+	u8	lbam_exp;=0A=
+	u8	lbah_exp;=0A=
+	u8	_r_a;=0A=
+	u8	sector_count;=0A=
+	u8	sector_count_exp;=0A=
+	u8	_r_b;=0A=
+	u8	e_status;=0A=
+	u8	_r_c[2];=0A=
+	u8	transfer_count;=0A=
+} __attribute__ ((packed));=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SATA Completion Response=0A=
+ * use to discribe the sata task response (64 bytes)=0A=
+ */=0A=
+struct sata_completion_resp {=0A=
+	__le32	tag;=0A=
+	__le32	status;=0A=
+	__le32	param;=0A=
+	u32	sata_resp[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SAS HW Event Notification=0A=
+ * use to alert the host about the hardware event(64 bytes)=0A=
+ */=0A=
+struct hw_event_resp {=0A=
+	__le32	lr_evt_status_phyid_portid;=0A=
+	__le32	evt_param;=0A=
+	__le32	npip_portstate;=0A=
+	struct sas_identify_frame	sas_identify;=0A=
+	struct dev_to_host_fis	sata_fis;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of  REGISTER DEVICE Command=0A=
+ * use to describe MPI REGISTER DEVICE Command (64 bytes)=0A=
+ */=0A=
+=0A=
+struct reg_dev_req {=0A=
+	__le32	tag;=0A=
+	__le32	phyid_portid;=0A=
+	__le32	dtype_dlr_retry;=0A=
+	__le32	firstburstsize_ITNexustimeout;=0A=
+	u32	sas_addr_hi;=0A=
+	u32	sas_addr_low;=0A=
+	__le32	upper_device_id;=0A=
+	u32	reserved[8];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of  DEREGISTER DEVICE Command=0A=
+ * use to request spc to remove all internal resources associated=0A=
+ * with the device id (64 bytes)=0A=
+ */=0A=
+=0A=
+struct dereg_dev_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	u32	reserved[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of DEVICE_REGISTRATION Response=0A=
+ * use to notify the completion of the device registration  (64 bytes)=0A=
+ */=0A=
+=0A=
+struct dev_reg_resp {=0A=
+	__le32	tag;=0A=
+	__le32	status;=0A=
+	__le32	device_id;=0A=
+	u32	reserved[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of Local PHY Control Command=0A=
+ * use to issue PHY CONTROL to local phy (64 bytes)=0A=
+ */=0A=
+struct local_phy_ctl_req {=0A=
+	__le32	tag;=0A=
+	__le32	phyop_phyid;=0A=
+	u32	reserved1[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of Local Phy Control Response=0A=
+ * use to describe MPI Local Phy Control Response (64 bytes)=0A=
+ */=0A=
+struct local_phy_ctl_resp {=0A=
+	__le32	tag;=0A=
+	__le32	phyop_phyid;=0A=
+	__le32	status;=0A=
+	u32	reserved[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define OP_BITS 0x0000FF00=0A=
+#define ID_BITS 0x0000000F=0A=
+=0A=
+/*=0A=
+ * brief the data structure of PORT Control Command=0A=
+ * use to control port properties (64 bytes)=0A=
+ */=0A=
+=0A=
+struct port_ctl_req {=0A=
+	__le32	tag;=0A=
+	__le32	portop_portid;=0A=
+	__le32	param0;=0A=
+	__le32	param1;=0A=
+	u32	reserved1[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of HW Event Ack Command=0A=
+ * use to acknowledge receive HW event (64 bytes)=0A=
+ */=0A=
+=0A=
+struct hw_event_ack_req {=0A=
+	__le32	tag;=0A=
+	__le32	sea_phyid_portid;=0A=
+	__le32	param0;=0A=
+	__le32	param1;=0A=
+	u32	reserved1[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SSP Completion Response=0A=
+ * use to indicate a SSP Completion  (n bytes)=0A=
+ */=0A=
+struct ssp_completion_resp {=0A=
+	__le32	tag;=0A=
+	__le32	status;=0A=
+	__le32	param;=0A=
+	__le32	ssptag_rescv_rescpad;=0A=
+	struct ssp_response_iu  ssp_resp_iu;=0A=
+	__le32	residual_count;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define SSP_RESCV_BIT	0x00010000=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SATA EVNET esponse=0A=
+ * use to indicate a SATA Completion  (64 bytes)=0A=
+ */=0A=
+=0A=
+struct sata_event_resp {=0A=
+	__le32	tag;=0A=
+	__le32	event;=0A=
+	__le32	port_id;=0A=
+	__le32	device_id;=0A=
+	u32	reserved[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SSP EVNET esponse=0A=
+ * use to indicate a SSP Completion  (64 bytes)=0A=
+ */=0A=
+=0A=
+struct ssp_event_resp {=0A=
+	__le32	tag;=0A=
+	__le32	event;=0A=
+	__le32	port_id;=0A=
+	__le32	device_id;=0A=
+	u32	reserved[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/**=0A=
+ * brief the data structure of General Event Notification Response=0A=
+ * use to describe MPI General Event Notification Response (64 bytes)=0A=
+ */=0A=
+struct general_event_resp {=0A=
+	__le32	status;=0A=
+	__le32	inb_IOMB_payload[14];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define GENERAL_EVENT_PAYLOAD	14=0A=
+#define OPCODE_BITS	0x00000fff=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SMP Request Command=0A=
+ * use to describe MPI SMP REQUEST Command (64 bytes)=0A=
+ */=0A=
+struct smp_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	len_ip_ir;=0A=
+	/* Bits [0]  - Indirect response */=0A=
+	/* Bits [1] - Indirect Payload */=0A=
+	/* Bits [15:2] - Reserved */=0A=
+	/* Bits [23:16] - direct payload Len */=0A=
+	/* Bits [31:24] - Reserved */=0A=
+	u8	smp_req16[16];=0A=
+	union {=0A=
+		u8	smp_req[32];=0A=
+		struct {=0A=
+			__le64 long_req_addr;/* sg dma address, LE */=0A=
+			__le32 long_req_size;/* LE */=0A=
+			u32	_r_a;=0A=
+			__le64 long_resp_addr;/* sg dma address, LE */=0A=
+			__le32 long_resp_size;/* LE */=0A=
+			u32	_r_b;=0A=
+			} long_smp_req;/* sequencer extension */=0A=
+	};=0A=
+} __attribute__((packed, aligned(4)));=0A=
+/*=0A=
+ * brief the data structure of SMP Completion Response=0A=
+ * use to describe MPI SMP Completion Response (64 bytes)=0A=
+ */=0A=
+struct smp_completion_resp {=0A=
+	__le32	tag;=0A=
+	__le32	status;=0A=
+	__le32	param;=0A=
+	__le32	_r_a[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/*=0A=
+ *brief the data structure of SSP SMP SATA Abort Command=0A=
+ * use to describe MPI SSP SMP & SATA Abort Command (64 bytes)=0A=
+ */=0A=
+struct task_abort_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	tag_to_abort;=0A=
+	__le32	abort_all;=0A=
+	u32	reserved[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/* These flags used for SSP SMP & SATA Abort */=0A=
+#define ABORT_MASK		0x3=0A=
+#define ABORT_SINGLE		0x0=0A=
+#define ABORT_ALL		0x1=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SSP SATA SMP Abort Response=0A=
+ * use to describe SSP SMP & SATA Abort Response ( 64 bytes)=0A=
+ */=0A=
+struct task_abort_resp {=0A=
+	__le32	tag;=0A=
+	__le32	status;=0A=
+	__le32	scp;=0A=
+	u32	reserved[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SAS Diagnostic Start/End Command=0A=
+ * use to describe MPI SAS Diagnostic Start/End Command (64 bytes)=0A=
+ */=0A=
+struct sas_diag_start_end_req {=0A=
+	__le32	tag;=0A=
+	__le32	operation_phyid;=0A=
+	u32	reserved[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SAS Diagnostic Execute Command=0A=
+ * use to describe MPI SAS Diagnostic Execute Command (64 bytes)=0A=
+ */=0A=
+struct sas_diag_execute_req{=0A=
+	__le32	tag;=0A=
+	__le32	cmdtype_cmddesc_phyid;=0A=
+	__le32	pat1_pat2;=0A=
+	__le32	threshold;=0A=
+	__le32	codepat_errmsk;=0A=
+	__le32	pmon;=0A=
+	__le32	pERF1CTL;=0A=
+	u32	reserved[8];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define SAS_DIAG_PARAM_BYTES 24=0A=
+=0A=
+/*=0A=
+ * brief the data structure of Set Device State Command=0A=
+ * use to describe MPI Set Device State Command (64 bytes)=0A=
+ */=0A=
+struct set_dev_state_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	nds;=0A=
+	u32	reserved[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/*=0A=
+ * brief the data structure of SATA Start Command=0A=
+ * use to describe MPI SATA IO Start Command (64 bytes)=0A=
+ */=0A=
+=0A=
+struct sata_start_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	data_len;=0A=
+	__le32	ncqtag_atap_dir_m;=0A=
+	struct host_to_dev_fis	sata_fis;=0A=
+	u32	reserved1;=0A=
+	u32	reserved2;=0A=
+	u32	addr_low;=0A=
+	u32	addr_high;=0A=
+	__le32	len;=0A=
+	__le32	esgl;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SSP INI TM Start Command=0A=
+ * use to describe MPI SSP INI TM Start Command (64 bytes)=0A=
+ */=0A=
+struct ssp_ini_tm_start_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	relate_tag;=0A=
+	__le32	tmf;=0A=
+	u8	lun[8];=0A=
+	__le32	ds_ads_m;=0A=
+	u32	reserved[8];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+struct ssp_info_unit {=0A=
+	u8	lun[8];/* SCSI Logical Unit Number */=0A=
+	u8	reserved1;/* reserved */=0A=
+	u8	efb_prio_attr;=0A=
+	/* B7   : enabledFirstBurst */=0A=
+	/* B6-3 : taskPriority */=0A=
+	/* B2-0 : taskAttribute */=0A=
+	u8	reserved2;	/* reserved */=0A=
+	u8	additional_cdb_len;=0A=
+	/* B7-2 : additional_cdb_len */=0A=
+	/* B1-0 : reserved */=0A=
+	u8	cdb[16];/* The SCSI CDB up to 16 bytes length */=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SSP INI IO Start Command=0A=
+ * use to describe MPI SSP INI IO Start Command (64 bytes)=0A=
+ */=0A=
+struct ssp_ini_io_start_req {=0A=
+	__le32	tag;=0A=
+	__le32	device_id;=0A=
+	__le32	data_len;=0A=
+	__le32	dir_m_tlr;=0A=
+	struct ssp_info_unit	ssp_iu;=0A=
+	__le32	addr_low;=0A=
+	__le32	addr_high;=0A=
+	__le32	len;=0A=
+	__le32	esgl;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of Firmware download=0A=
+ * use to describe MPI FW DOWNLOAD Command (64 bytes)=0A=
+ */=0A=
+struct fw_flash_Update_req {=0A=
+	__le32	tag;=0A=
+	__le32	cur_image_offset;=0A=
+	__le32	cur_image_len;=0A=
+	__le32	total_image_len;=0A=
+	u32	reserved0[7];=0A=
+	__le32	sgl_addr_lo;=0A=
+	__le32	sgl_addr_hi;=0A=
+	__le32	len;=0A=
+	__le32	ext_reserved;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define FWFLASH_IOMB_RESERVED_LEN 0x07=0A=
+/**=0A=
+ * brief the data structure of FW_FLASH_UPDATE Response=0A=
+ * use to describe MPI FW_FLASH_UPDATE Response (64 bytes)=0A=
+ *=0A=
+ */=0A=
+struct fw_flash_Update_resp {=0A=
+	dma_addr_t	tag;=0A=
+	__le32	status;=0A=
+	u32	reserved[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of Get NVM Data Command=0A=
+ * use to get data from NVM in HBA(64 bytes)=0A=
+ */=0A=
+struct get_nvm_data_req {=0A=
+	__le32	tag;=0A=
+	__le32	len_ir_vpdd;=0A=
+	__le32	vpd_offset;=0A=
+	u32	reserved[8];=0A=
+	__le32	resp_addr_lo;=0A=
+	__le32	resp_addr_hi;=0A=
+	__le32	resp_len;=0A=
+	u32	reserved1;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+struct set_nvm_data_req {=0A=
+	__le32	tag;=0A=
+	__le32	len_ir_vpdd;=0A=
+	__le32	vpd_offset;=0A=
+	u32	reserved[8];=0A=
+	__le32	resp_addr_lo;=0A=
+	__le32	resp_addr_hi;=0A=
+	__le32	resp_len;=0A=
+	u32	reserved1;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define TWI_DEVICE	0x0=0A=
+#define C_SEEPROM	0x1=0A=
+#define VPD_FLASH	0x4=0A=
+#define AAP1_RDUMP	0x5=0A=
+#define IOP_RDUMP	0x6=0A=
+#define EXPAN_ROM	0x7=0A=
+=0A=
+#define IPMode		0x80000000=0A=
+#define NVMD_TYPE	0x0000000F=0A=
+#define NVMD_STAT	0x0000FFFF=0A=
+#define NVMD_LEN	0xFF000000=0A=
+/**=0A=
+ * brief the data structure of Get NVMD Data Response=0A=
+ * use to describe MPI Get NVMD Data Response (64 bytes)=0A=
+ */=0A=
+struct get_nvm_data_resp {=0A=
+	__le32		tag;=0A=
+	__le32		ir_tda_bn_dps_das_nvm;=0A=
+	__le32		dlen_status;=0A=
+	__le32		nvm_data[12];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SAS Diagnostic Start/End Response=0A=
+ * use to describe MPI SAS Diagnostic Start/End Response (64 bytes)=0A=
+ *=0A=
+ */=0A=
+struct sas_diag_start_end_resp {=0A=
+	__le32		tag;=0A=
+	__le32		status;=0A=
+	u32		reserved[13];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of SAS Diagnostic Execute Response=0A=
+ * use to describe MPI SAS Diagnostic Execute Response (64 bytes)=0A=
+ *=0A=
+ */=0A=
+struct sas_diag_execute_resp {=0A=
+	__le32		tag;=0A=
+	__le32		cmdtype_cmddesc_phyid;=0A=
+	__le32		Status;=0A=
+	__le32		ReportData;=0A=
+	u32		reserved[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+/**=0A=
+ * brief the data structure of Set Device State Response=0A=
+ * use to describe MPI Set Device State Response (64 bytes)=0A=
+ *=0A=
+ */=0A=
+struct set_dev_state_resp {=0A=
+	__le32		tag;=0A=
+	__le32		status;=0A=
+	__le32		device_id;=0A=
+	__le32		pds_nds;=0A=
+	u32		reserved[11];=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+=0A=
+#define NDS_BITS 0x0F=0A=
+#define PDS_BITS 0xF0=0A=
+=0A=
+/*=0A=
+ * HW Events type=0A=
+ */=0A=
+=0A=
+#define HW_EVENT_RESET_START			0x01=0A=
+#define HW_EVENT_CHIP_RESET_COMPLETE		0x02=0A=
+#define HW_EVENT_PHY_STOP_STATUS		0x03=0A=
+#define HW_EVENT_SAS_PHY_UP			0x04=0A=
+#define HW_EVENT_SATA_PHY_UP			0x05=0A=
+#define HW_EVENT_SATA_SPINUP_HOLD		0x06=0A=
+#define HW_EVENT_PHY_DOWN			0x07=0A=
+#define HW_EVENT_PORT_INVALID			0x08=0A=
+#define HW_EVENT_BROADCAST_CHANGE		0x09=0A=
+#define HW_EVENT_PHY_ERROR			0x0A=0A=
+#define HW_EVENT_BROADCAST_SES			0x0B=0A=
+#define HW_EVENT_INBOUND_CRC_ERROR		0x0C=0A=
+#define HW_EVENT_HARD_RESET_RECEIVED		0x0D=0A=
+#define HW_EVENT_MALFUNCTION			0x0E=0A=
+#define HW_EVENT_ID_FRAME_TIMEOUT		0x0F=0A=
+#define HW_EVENT_BROADCAST_EXP			0x10=0A=
+#define HW_EVENT_PHY_START_STATUS		0x11=0A=
+#define HW_EVENT_LINK_ERR_INVALID_DWORD		0x12=0A=
+#define HW_EVENT_LINK_ERR_DISPARITY_ERROR	0x13=0A=
+#define HW_EVENT_LINK_ERR_CODE_VIOLATION	0x14=0A=
+#define HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH	0x15=0A=
+#define HW_EVENT_LINK_ERR_PHY_RESET_FAILED	0x16=0A=
+#define HW_EVENT_PORT_RECOVERY_TIMER_TMO	0x17=0A=
+#define HW_EVENT_PORT_RECOVER			0x18=0A=
+#define HW_EVENT_PORT_RESET_TIMER_TMO		0x19=0A=
+#define HW_EVENT_PORT_RESET_COMPLETE		0x20=0A=
+#define EVENT_BROADCAST_ASYNCH_EVENT		0x21=0A=
+=0A=
+/* port state */=0A=
+#define PORT_NOT_ESTABLISHED			0x00=0A=
+#define PORT_VALID				0x01=0A=
+#define PORT_LOSTCOMM				0x02=0A=
+#define PORT_IN_RESET				0x04=0A=
+#define PORT_INVALID				0x08=0A=
+=0A=
+/*=0A=
+ * SSP/SMP/SATA IO Completion Status values=0A=
+ */=0A=
+=0A=
+#define IO_SUCCESS				0x00=0A=
+#define IO_ABORTED				0x01=0A=
+#define IO_OVERFLOW				0x02=0A=
+#define IO_UNDERFLOW				0x03=0A=
+#define IO_FAILED				0x04=0A=
+#define IO_ABORT_RESET				0x05=0A=
+#define IO_NOT_VALID				0x06=0A=
+#define IO_NO_DEVICE				0x07=0A=
+#define IO_ILLEGAL_PARAMETER			0x08=0A=
+#define IO_LINK_FAILURE				0x09=0A=
+#define IO_PROG_ERROR				0x0A=0A=
+#define IO_EDC_IN_ERROR				0x0B=0A=
+#define IO_EDC_OUT_ERROR			0x0C=0A=
+#define IO_ERROR_HW_TIMEOUT			0x0D=0A=
+#define IO_XFER_ERROR_BREAK			0x0E=0A=
+#define IO_XFER_ERROR_PHY_NOT_READY		0x0F=0A=
+#define IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED	0x10=0A=
+#define IO_OPEN_CNX_ERROR_ZONE_VIOLATION		0x11=0A=
+#define IO_OPEN_CNX_ERROR_BREAK				0x12=0A=
+#define IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS			0x13=0A=
+#define IO_OPEN_CNX_ERROR_BAD_DESTINATION		0x14=0A=
+#define IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED	0x15=0A=
+#define IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY		0x16=0A=
+#define IO_OPEN_CNX_ERROR_WRONG_DESTINATION		0x17=0A=
+#define IO_OPEN_CNX_ERROR_UNKNOWN_ERROR			0x18=0A=
+#define IO_XFER_ERROR_NAK_RECEIVED			0x19=0A=
+#define IO_XFER_ERROR_ACK_NAK_TIMEOUT			0x1A=0A=
+#define IO_XFER_ERROR_PEER_ABORTED			0x1B=0A=
+#define IO_XFER_ERROR_RX_FRAME				0x1C=0A=
+#define IO_XFER_ERROR_DMA				0x1D=0A=
+#define IO_XFER_ERROR_CREDIT_TIMEOUT			0x1E=0A=
+#define IO_XFER_ERROR_SATA_LINK_TIMEOUT			0x1F=0A=
+#define IO_XFER_ERROR_SATA				0x20=0A=
+#define IO_XFER_ERROR_ABORTED_DUE_TO_SRST		0x22=0A=
+#define IO_XFER_ERROR_REJECTED_NCQ_MODE			0x21=0A=
+#define IO_XFER_ERROR_ABORTED_NCQ_MODE			0x23=0A=
+#define IO_XFER_OPEN_RETRY_TIMEOUT			0x24=0A=
+#define IO_XFER_SMP_RESP_CONNECTION_ERROR		0x25=0A=
+#define IO_XFER_ERROR_UNEXPECTED_PHASE			0x26=0A=
+#define IO_XFER_ERROR_XFER_RDY_OVERRUN			0x27=0A=
+#define IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED		0x28=0A=
+=0A=
+#define IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT		0x30=0A=
+#define IO_XFER_ERROR_CMD_ISSUE_BREAK_BEFORE_ACK_NAK	0x31=0A=
+#define IO_XFER_ERROR_CMD_ISSUE_PHY_DOWN_BEFORE_ACK_NAK	0x32=0A=
+=0A=
+#define IO_XFER_ERROR_OFFSET_MISMATCH			0x34=0A=
+#define IO_XFER_ERROR_XFER_ZERO_DATA_LEN		0x35=0A=
+#define IO_XFER_CMD_FRAME_ISSUED			0x36=0A=
+#define IO_ERROR_INTERNAL_SMP_RESOURCE			0x37=0A=
+#define IO_PORT_IN_RESET				0x38=0A=
+#define IO_DS_NON_OPERATIONAL				0x39=0A=
+#define IO_DS_IN_RECOVERY				0x3A=0A=
+#define IO_TM_TAG_NOT_FOUND				0x3B=0A=
+#define IO_XFER_PIO_SETUP_ERROR				0x3C=0A=
+#define IO_SSP_EXT_IU_ZERO_LEN_ERROR			0x3D=0A=
+#define IO_DS_IN_ERROR					0x3E=0A=
+#define IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY		0x3F=0A=
+#define IO_ABORT_IN_PROGRESS				0x40=0A=
+#define IO_ABORT_DELAYED				0x41=0A=
+#define IO_INVALID_LENGTH				0x42=0A=
+=0A=
+/* WARNING: This error code must always be the last number.=0A=
+ * If you add error code, modify this code also=0A=
+ * It is used as an index=0A=
+ */=0A=
+#define IO_ERROR_UNKNOWN_GENERIC			0x43=0A=
+=0A=
+/* MSGU CONFIGURATION  TABLE*/=0A=
+=0A=
+#define SPC_MSGU_CFG_TABLE_UPDATE		0x01/* Inbound doorbell bit0 */=0A=
+#define SPC_MSGU_CFG_TABLE_RESET		0x02/* Inbound doorbell bit1 */=0A=
+#define SPC_MSGU_CFG_TABLE_FREEZE		0x04/* Inbound doorbell bit2 */=0A=
+#define SPC_MSGU_CFG_TABLE_UNFREEZE		0x08/* Inbound doorbell bit4 */=0A=
+#define MSGU_IBDB_SET				0x04=0A=
+#define MSGU_HOST_INT_STATUS			0x08=0A=
+#define MSGU_HOST_INT_MASK			0x0C=0A=
+#define MSGU_IOPIB_INT_STATUS			0x18=0A=
+#define MSGU_IOPIB_INT_MASK			0x1C=0A=
+#define MSGU_IBDB_CLEAR				0x20/* RevB - Host not use */=0A=
+#define MSGU_MSGU_CONTROL			0x24=0A=
+#define MSGU_ODR				0x3C/* RevB */=0A=
+#define MSGU_ODCR				0x40/* RevB */=0A=
+#define MSGU_SCRATCH_PAD_0			0x44=0A=
+#define MSGU_SCRATCH_PAD_1			0x48=0A=
+#define MSGU_SCRATCH_PAD_2			0x4C=0A=
+#define MSGU_SCRATCH_PAD_3			0x50=0A=
+#define MSGU_HOST_SCRATCH_PAD_0			0x54=0A=
+#define MSGU_HOST_SCRATCH_PAD_1			0x58=0A=
+#define MSGU_HOST_SCRATCH_PAD_2			0x5C=0A=
+#define MSGU_HOST_SCRATCH_PAD_3			0x60=0A=
+#define MSGU_HOST_SCRATCH_PAD_4			0x64=0A=
+#define MSGU_HOST_SCRATCH_PAD_5			0x68=0A=
+#define MSGU_HOST_SCRATCH_PAD_6			0x6C=0A=
+#define MSGU_HOST_SCRATCH_PAD_7			0x70=0A=
+#define MSGU_ODMR				0x74/* RevB */=0A=
+=0A=
+/* bit definition for ODMR register */=0A=
+#define ODMR_MASK_ALL				0xFFFFFFFF/* mask all=0A=
+					interrupt vector */=0A=
+#define ODMR_CLEAR_ALL				0/* clear all=0A=
+					interrupt vector */=0A=
+/* bit definition for ODCR register */=0A=
+#define ODCR_CLEAR_ALL		0xFFFFFFFF   /* mask all=0A=
+					interrupt vector*/=0A=
+/* MSIX Interupts */=0A=
+#define MSIX_TABLE_OFFSET		0x2000=0A=
+#define MSIX_TABLE_ELEMENT_SIZE		0x10=0A=
+#define MSIX_INTERRUPT_CONTROL_OFFSET	0xC=0A=
+#define MSIX_TABLE_BASE	  (MSIX_TABLE_OFFSET + =
MSIX_INTERRUPT_CONTROL_OFFSET)=0A=
+#define MSIX_INTERRUPT_DISABLE		0x1=0A=
+#define MSIX_INTERRUPT_ENABLE		0x0=0A=
+=0A=
+=0A=
+/* state definition for Scratch Pad1 register */=0A=
+#define SCRATCH_PAD1_POR		0x00  /* power on reset state */=0A=
+#define SCRATCH_PAD1_SFR		0x01  /* soft reset state */=0A=
+#define SCRATCH_PAD1_ERR		0x02  /* error state */=0A=
+#define SCRATCH_PAD1_RDY		0x03  /* ready state */=0A=
+#define SCRATCH_PAD1_RST		0x04  /* soft reset toggle flag */=0A=
+#define SCRATCH_PAD1_AAP1RDY_RST	0x08  /* AAP1 ready for soft reset */=0A=
+#define SCRATCH_PAD1_STATE_MASK		0xFFFFFFF0   /* ScratchPad1=0A=
+ Mask, bit1-0 State, bit2 Soft Reset, bit3 FW RDY for Soft Reset */=0A=
+#define SCRATCH_PAD1_RESERVED		0x000003F8   /* Scratch Pad1=0A=
+ Reserved bit 3 to 9 */=0A=
+=0A=
+ /* state definition for Scratch Pad2 register */=0A=
+#define SCRATCH_PAD2_POR		0x00  /* power on state */=0A=
+#define SCRATCH_PAD2_SFR		0x01  /* soft reset state */=0A=
+#define SCRATCH_PAD2_ERR		0x02  /* error state */=0A=
+#define SCRATCH_PAD2_RDY		0x03  /* ready state */=0A=
+#define SCRATCH_PAD2_FWRDY_RST		0x04  /* FW ready for soft reset flag*/=0A=
+#define SCRATCH_PAD2_IOPRDY_RST		0x08  /* IOP ready for soft reset */=0A=
+#define SCRATCH_PAD2_STATE_MASK		0xFFFFFFF4 /* ScratchPad 2=0A=
+ Mask, bit1-0 State */=0A=
+#define SCRATCH_PAD2_RESERVED		0x000003FC   /* Scratch Pad1=0A=
+ Reserved bit 2 to 9 */=0A=
+=0A=
+#define SCRATCH_PAD_ERROR_MASK		0xFFFFFC00   /* Error mask bits */=0A=
+#define SCRATCH_PAD_STATE_MASK		0x00000003   /* State Mask bits */=0A=
+=0A=
+/* main configuration offset - byte offset */=0A=
+#define MAIN_SIGNATURE_OFFSET		0x00/* DWORD 0x00 */=0A=
+#define MAIN_INTERFACE_REVISION		0x04/* DWORD 0x01 */=0A=
+#define MAIN_FW_REVISION		0x08/* DWORD 0x02 */=0A=
+#define MAIN_MAX_OUTSTANDING_IO_OFFSET	0x0C/* DWORD 0x03 */=0A=
+#define MAIN_MAX_SGL_OFFSET		0x10/* DWORD 0x04 */=0A=
+#define MAIN_CNTRL_CAP_OFFSET		0x14/* DWORD 0x05 */=0A=
+#define MAIN_GST_OFFSET			0x18/* DWORD 0x06 */=0A=
+#define MAIN_IBQ_OFFSET			0x1C/* DWORD 0x07 */=0A=
+#define MAIN_OBQ_OFFSET			0x20/* DWORD 0x08 */=0A=
+#define MAIN_IQNPPD_HPPD_OFFSET		0x24/* DWORD 0x09 */=0A=
+#define MAIN_OB_HW_EVENT_PID03_OFFSET	0x28/* DWORD 0x0A */=0A=
+#define MAIN_OB_HW_EVENT_PID47_OFFSET	0x2C/* DWORD 0x0B */=0A=
+#define MAIN_OB_NCQ_EVENT_PID03_OFFSET	0x30/* DWORD 0x0C */=0A=
+#define MAIN_OB_NCQ_EVENT_PID47_OFFSET	0x34/* DWORD 0x0D */=0A=
+#define MAIN_TITNX_EVENT_PID03_OFFSET	0x38/* DWORD 0x0E */=0A=
+#define MAIN_TITNX_EVENT_PID47_OFFSET	0x3C/* DWORD 0x0F */=0A=
+#define MAIN_OB_SSP_EVENT_PID03_OFFSET	0x40/* DWORD 0x10 */=0A=
+#define MAIN_OB_SSP_EVENT_PID47_OFFSET	0x44/* DWORD 0x11 */=0A=
+#define MAIN_OB_SMP_EVENT_PID03_OFFSET	0x48/* DWORD 0x12 */=0A=
+#define MAIN_OB_SMP_EVENT_PID47_OFFSET	0x4C/* DWORD 0x13 */=0A=
+#define MAIN_EVENT_LOG_ADDR_HI		0x50/* DWORD 0x14 */=0A=
+#define MAIN_EVENT_LOG_ADDR_LO		0x54/* DWORD 0x15 */=0A=
+#define MAIN_EVENT_LOG_BUFF_SIZE	0x58/* DWORD 0x16 */=0A=
+#define MAIN_EVENT_LOG_OPTION		0x5C/* DWORD 0x17 */=0A=
+#define MAIN_IOP_EVENT_LOG_ADDR_HI	0x60/* DWORD 0x18 */=0A=
+#define MAIN_IOP_EVENT_LOG_ADDR_LO	0x64/* DWORD 0x19 */=0A=
+#define MAIN_IOP_EVENT_LOG_BUFF_SIZE	0x68/* DWORD 0x1A */=0A=
+#define MAIN_IOP_EVENT_LOG_OPTION	0x6C/* DWORD 0x1B */=0A=
+#define MAIN_FATAL_ERROR_INTERRUPT	0x70/* DWORD 0x1C */=0A=
+#define MAIN_FATAL_ERROR_RDUMP0_OFFSET	0x74/* DWORD 0x1D */=0A=
+#define MAIN_FATAL_ERROR_RDUMP0_LENGTH	0x78/* DWORD 0x1E */=0A=
+#define MAIN_FATAL_ERROR_RDUMP1_OFFSET	0x7C/* DWORD 0x1F */=0A=
+#define MAIN_FATAL_ERROR_RDUMP1_LENGTH	0x80/* DWORD 0x20 */=0A=
+#define MAIN_HDA_FLAGS_OFFSET		0x84/* DWORD 0x21 */=0A=
+#define MAIN_ANALOG_SETUP_OFFSET	0x88/* DWORD 0x22 */=0A=
+=0A=
+/* Gereral Status Table offset - byte offset */=0A=
+#define GST_GSTLEN_MPIS_OFFSET		0x00=0A=
+#define GST_IQ_FREEZE_STATE0_OFFSET	0x04=0A=
+#define GST_IQ_FREEZE_STATE1_OFFSET	0x08=0A=
+#define GST_MSGUTCNT_OFFSET		0x0C=0A=
+#define GST_IOPTCNT_OFFSET		0x10=0A=
+#define GST_PHYSTATE_OFFSET		0x18=0A=
+#define GST_PHYSTATE0_OFFSET		0x18=0A=
+#define GST_PHYSTATE1_OFFSET		0x1C=0A=
+#define GST_PHYSTATE2_OFFSET		0x20=0A=
+#define GST_PHYSTATE3_OFFSET		0x24=0A=
+#define GST_PHYSTATE4_OFFSET		0x28=0A=
+#define GST_PHYSTATE5_OFFSET		0x2C=0A=
+#define GST_PHYSTATE6_OFFSET		0x30=0A=
+#define GST_PHYSTATE7_OFFSET		0x34=0A=
+#define GST_RERRINFO_OFFSET		0x44=0A=
+=0A=
+/* General Status Table - MPI state */=0A=
+#define GST_MPI_STATE_UNINIT		0x00=0A=
+#define GST_MPI_STATE_INIT		0x01=0A=
+#define GST_MPI_STATE_TERMINATION	0x02=0A=
+#define GST_MPI_STATE_ERROR		0x03=0A=
+#define GST_MPI_STATE_MASK		0x07=0A=
+=0A=
+#define MBIC_NMI_ENABLE_VPE0_IOP	0x000418=0A=
+#define MBIC_NMI_ENABLE_VPE0_AAP1	0x000418=0A=
+/* PCIE registers - BAR2(0x18), BAR1(win) 0x010000 */=0A=
+#define PCIE_EVENT_INTERRUPT_ENABLE	0x003040=0A=
+#define PCIE_EVENT_INTERRUPT		0x003044=0A=
+#define PCIE_ERROR_INTERRUPT_ENABLE	0x003048=0A=
+#define PCIE_ERROR_INTERRUPT		0x00304C=0A=
+/* signature defintion for host scratch pad0 register */=0A=
+#define SPC_SOFT_RESET_SIGNATURE	0x252acbcd=0A=
+/* Signature for Soft Reset */=0A=
+=0A=
+/* SPC Reset register - BAR4(0x20), BAR2(win) (need dynamic mapping) */=0A=
+#define SPC_REG_RESET			0x000000/* reset register */=0A=
+=0A=
+/* bit difination for SPC_RESET register */=0A=
+#define   SPC_REG_RESET_OSSP		0x00000001=0A=
+#define   SPC_REG_RESET_RAAE		0x00000002=0A=
+#define   SPC_REG_RESET_PCS_SPBC	0x00000004=0A=
+#define   SPC_REG_RESET_PCS_IOP_SS	0x00000008=0A=
+#define   SPC_REG_RESET_PCS_AAP1_SS	0x00000010=0A=
+#define   SPC_REG_RESET_PCS_AAP2_SS	0x00000020=0A=
+#define   SPC_REG_RESET_PCS_LM		0x00000040=0A=
+#define   SPC_REG_RESET_PCS		0x00000080=0A=
+#define   SPC_REG_RESET_GSM		0x00000100=0A=
+#define   SPC_REG_RESET_DDR2		0x00010000=0A=
+#define   SPC_REG_RESET_BDMA_CORE	0x00020000=0A=
+#define   SPC_REG_RESET_BDMA_SXCBI	0x00040000=0A=
+#define   SPC_REG_RESET_PCIE_AL_SXCBI	0x00080000=0A=
+#define   SPC_REG_RESET_PCIE_PWR	0x00100000=0A=
+#define   SPC_REG_RESET_PCIE_SFT	0x00200000=0A=
+#define   SPC_REG_RESET_PCS_SXCBI	0x00400000=0A=
+#define   SPC_REG_RESET_LMS_SXCBI	0x00800000=0A=
+#define   SPC_REG_RESET_PMIC_SXCBI	0x01000000=0A=
+#define   SPC_REG_RESET_PMIC_CORE	0x02000000=0A=
+#define   SPC_REG_RESET_PCIE_PC_SXCBI	0x04000000=0A=
+#define   SPC_REG_RESET_DEVICE		0x80000000=0A=
+=0A=
+/* registers for BAR Shifting - BAR2(0x18), BAR1(win) */=0A=
+#define SPC_IBW_AXI_TRANSLATION_LOW	0x003258=0A=
+=0A=
+#define MBIC_AAP1_ADDR_BASE		0x060000=0A=
+#define MBIC_IOP_ADDR_BASE		0x070000=0A=
+#define GSM_ADDR_BASE			0x0700000=0A=
+/* Dynamic map through Bar4 - 0x00700000 */=0A=
+#define GSM_CONFIG_RESET		0x00000000=0A=
+#define RAM_ECC_DB_ERR			0x00000018=0A=
+#define GSM_READ_ADDR_PARITY_INDIC	0x00000058=0A=
+#define GSM_WRITE_ADDR_PARITY_INDIC	0x00000060=0A=
+#define GSM_WRITE_DATA_PARITY_INDIC	0x00000068=0A=
+#define GSM_READ_ADDR_PARITY_CHECK	0x00000038=0A=
+#define GSM_WRITE_ADDR_PARITY_CHECK	0x00000040=0A=
+#define GSM_WRITE_DATA_PARITY_CHECK	0x00000048=0A=
+=0A=
+#define RB6_ACCESS_REG			0x6A0000=0A=
+#define HDAC_EXEC_CMD			0x0002=0A=
+#define HDA_C_PA			0xcb=0A=
+#define HDA_SEQ_ID_BITS			0x00ff0000=0A=
+#define HDA_GSM_OFFSET_BITS		0x00FFFFFF=0A=
+#define MBIC_AAP1_ADDR_BASE		0x060000=0A=
+#define MBIC_IOP_ADDR_BASE		0x070000=0A=
+#define GSM_ADDR_BASE			0x0700000=0A=
+#define SPC_TOP_LEVEL_ADDR_BASE		0x000000=0A=
+#define GSM_CONFIG_RESET_VALUE          0x00003b00=0A=
+#define GPIO_ADDR_BASE                  0x00090000=0A=
+#define GPIO_GPIO_0_0UTPUT_CTL_OFFSET   0x0000010c=0A=
+=0A=
+/* RB6 offset */=0A=
+#define SPC_RB6_OFFSET			0x80C0=0A=
+/* Magic number of  soft reset for RB6 */=0A=
+#define RB6_MAGIC_NUMBER_RST		0x1234=0A=
+=0A=
+/* Device Register status */=0A=
+#define DEVREG_SUCCESS					0x00=0A=
+#define DEVREG_FAILURE_OUT_OF_RESOURCE			0x01=0A=
+#define DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED	0x02=0A=
+#define DEVREG_FAILURE_INVALID_PHY_ID			0x03=0A=
+#define DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED	0x04=0A=
+#define DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE		0x05=0A=
+#define DEVREG_FAILURE_PORT_NOT_VALID_STATE		0x06=0A=
+#define DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID		0x07=0A=
+=0A=
+#endif=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_init.c =
b/drivers/scsi/pm8001/pm8001_init.c=0A=
new file mode 100644=0A=
index 0000000..64ac111=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_init.c=0A=
@@ -0,0 +1,885 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#include "pm8001_sas.h"=0A=
+#include "pm8001_chips.h"=0A=
+=0A=
+static struct scsi_transport_template *pm8001_stt;=0A=
+=0A=
+static const struct pm8001_chip_info pm8001_chips[] =3D {=0A=
+	[chip_8001] =3D {  8, &pm8001_8001_dispatch,},=0A=
+};=0A=
+static int pm8001_id;=0A=
+=0A=
+LIST_HEAD(hba_list);=0A=
+=0A=
+/**=0A=
+ * The main structure which LLDD must register for scsi core.=0A=
+ */=0A=
+static struct scsi_host_template pm8001_sht =3D {=0A=
+	.module			=3D THIS_MODULE,=0A=
+	.name			=3D DRV_NAME,=0A=
+	.queuecommand		=3D sas_queuecommand,=0A=
+	.target_alloc		=3D sas_target_alloc,=0A=
+	.slave_configure	=3D pm8001_slave_configure,=0A=
+	.slave_destroy		=3D sas_slave_destroy,=0A=
+	.scan_finished		=3D pm8001_scan_finished,=0A=
+	.scan_start		=3D pm8001_scan_start,=0A=
+	.change_queue_depth	=3D sas_change_queue_depth,=0A=
+	.change_queue_type	=3D sas_change_queue_type,=0A=
+	.bios_param		=3D sas_bios_param,=0A=
+	.can_queue		=3D 1,=0A=
+	.cmd_per_lun		=3D 1,=0A=
+	.this_id		=3D -1,=0A=
+	.sg_tablesize		=3D SG_ALL,=0A=
+	.max_sectors		=3D SCSI_DEFAULT_MAX_SECTORS,=0A=
+	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
+	.eh_device_reset_handler =3D sas_eh_device_reset_handler,=0A=
+	.eh_bus_reset_handler	=3D sas_eh_bus_reset_handler,=0A=
+	.slave_alloc		=3D pm8001_slave_alloc,=0A=
+	.target_destroy		=3D sas_target_destroy,=0A=
+	.ioctl			=3D sas_ioctl,=0A=
+	.shost_attrs		=3D pm8001_host_attrs,=0A=
+};=0A=
+=0A=
+/**=0A=
+ * Sas layer call this function to execute specific task.=0A=
+ */=0A=
+static struct sas_domain_function_template pm8001_transport_ops =3D {=0A=
+	.lldd_dev_found		=3D pm8001_dev_found,=0A=
+	.lldd_dev_gone		=3D pm8001_dev_gone,=0A=
+=0A=
+	.lldd_execute_task	=3D pm8001_queue_command,=0A=
+	.lldd_control_phy	=3D pm8001_phy_control,=0A=
+=0A=
+	.lldd_abort_task	=3D pm8001_abort_task,=0A=
+	.lldd_abort_task_set	=3D pm8001_abort_task_set,=0A=
+	.lldd_clear_aca		=3D pm8001_clear_aca,=0A=
+	.lldd_clear_task_set	=3D pm8001_clear_task_set,=0A=
+	.lldd_I_T_nexus_reset   =3D pm8001_I_T_nexus_reset,=0A=
+	.lldd_lu_reset		=3D pm8001_lu_reset,=0A=
+	.lldd_query_task	=3D pm8001_query_task,=0A=
+};=0A=
+=0A=
+/**=0A=
+ *pm8001_phy_init - initiate our adapter phys=0A=
+ *@pm8001_ha: our hba structure.=0A=
+ *@phy_id: phy id.=0A=
+ */=0A=
+static void __devinit pm8001_phy_init(struct pm8001_hba_info *pm8001_ha,=0A=
+	int phy_id)=0A=
+{=0A=
+	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];=0A=
+	struct asd_sas_phy *sas_phy =3D &phy->sas_phy;=0A=
+	phy->phy_state =3D 0;=0A=
+	phy->pm8001_ha =3D pm8001_ha;=0A=
+	sas_phy->enabled =3D (phy_id < pm8001_ha->chip->n_phy) ? 1 : 0;=0A=
+	sas_phy->class =3D SAS;=0A=
+	sas_phy->iproto =3D SAS_PROTOCOL_ALL;=0A=
+	sas_phy->tproto =3D 0;=0A=
+	sas_phy->type =3D PHY_TYPE_PHYSICAL;=0A=
+	sas_phy->role =3D PHY_ROLE_INITIATOR;=0A=
+	sas_phy->oob_mode =3D OOB_NOT_CONNECTED;=0A=
+	sas_phy->linkrate =3D SAS_LINK_RATE_UNKNOWN;=0A=
+	sas_phy->id =3D phy_id;=0A=
+	sas_phy->sas_addr =3D &pm8001_ha->sas_addr[0];=0A=
+	sas_phy->frame_rcvd =3D &phy->frame_rcvd[0];=0A=
+	sas_phy->ha =3D (struct sas_ha_struct *)pm8001_ha->shost->hostdata;=0A=
+	sas_phy->lldd_phy =3D phy;=0A=
+}=0A=
+=0A=
+/**=0A=
+ *pm8001_free - free hba=0A=
+ *@pm8001_ha:	our hba structure.=0A=
+ *=0A=
+ */=0A=
+static void pm8001_free(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	int i;=0A=
+	struct pm8001_wq *wq;=0A=
+=0A=
+	if (!pm8001_ha)=0A=
+		return;=0A=
+=0A=
+	for (i =3D 0; i < USI_MAX_MEMCNT; i++) {=0A=
+		if (pm8001_ha->memoryMap.region[i].virt_ptr !=3D NULL) {=0A=
+			pci_free_consistent(pm8001_ha->pdev,=0A=
+				pm8001_ha->memoryMap.region[i].element_size,=0A=
+				pm8001_ha->memoryMap.region[i].virt_ptr,=0A=
+				pm8001_ha->memoryMap.region[i].phys_addr);=0A=
+			}=0A=
+	}=0A=
+	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);=0A=
+	if (pm8001_ha->shost)=0A=
+		scsi_host_put(pm8001_ha->shost);=0A=
+	list_for_each_entry(wq, &pm8001_ha->wq_list, entry)=0A=
+		cancel_delayed_work(&wq->work_q);=0A=
+	kfree(pm8001_ha->tags);=0A=
+	kfree(pm8001_ha);=0A=
+}=0A=
+=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+static void pm8001_tasklet(unsigned long opaque)=0A=
+{=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	pm8001_ha =3D (struct pm8001_hba_info *)opaque;;=0A=
+	if (unlikely(!pm8001_ha))=0A=
+		BUG_ON(1);=0A=
+	PM8001_CHIP_DISP->isr(pm8001_ha);=0A=
+}=0A=
+#endif=0A=
+=0A=
+=0A=
+ /**=0A=
+  * pm8001_interrupt - when HBA originate a interrupt,we should invoke =
this=0A=
+  * dispatcher to handle each case.=0A=
+  * @irq: irq number.=0A=
+  * @opaque: the passed general host adapter struct=0A=
+  */=0A=
+static irqreturn_t pm8001_interrupt(int irq, void *opaque)=0A=
+{=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	irqreturn_t ret =3D IRQ_HANDLED;=0A=
+	struct sas_ha_struct *sha =3D opaque;=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	if (unlikely(!pm8001_ha))=0A=
+		return IRQ_NONE;=0A=
+	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))=0A=
+		return IRQ_NONE;=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+	tasklet_schedule(&pm8001_ha->tasklet);=0A=
+#else=0A=
+	ret =3D PM8001_CHIP_DISP->isr(pm8001_ha);=0A=
+#endif=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_alloc - initiate our hba structure and 6 DMAs area.=0A=
+ * @pm8001_ha:our hba structure.=0A=
+ *=0A=
+ */=0A=
+static int __devinit pm8001_alloc(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	int i;=0A=
+	spin_lock_init(&pm8001_ha->lock);=0A=
+	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++)=0A=
+		pm8001_phy_init(pm8001_ha, i);=0A=
+=0A=
+	pm8001_ha->tags =3D kmalloc(sizeof(unsigned long)*PM8001_MAX_DEVICES,=0A=
+		GFP_KERNEL);=0A=
+=0A=
+	/* MPI Memory region 1 for AAP Event Log for fw */=0A=
+	pm8001_ha->memoryMap.region[AAP1].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[AAP1].element_size =3D 128*1024;=0A=
+	pm8001_ha->memoryMap.region[AAP1].total_len =3D 128*1024;=0A=
+	pm8001_ha->memoryMap.region[AAP1].alignment =3D 32;=0A=
+=0A=
+	/* MPI Memory region 2 for IOP Event Log for fw */=0A=
+	pm8001_ha->memoryMap.region[IOP].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[IOP].element_size =3D 128*1024;=0A=
+	pm8001_ha->memoryMap.region[IOP].total_len =3D 128*1024;=0A=
+	pm8001_ha->memoryMap.region[IOP].alignment =3D 32;=0A=
+=0A=
+	/* MPI Memory region 3 for consumer Index of inbound queues */=0A=
+	pm8001_ha->memoryMap.region[CI].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[CI].element_size =3D 4;=0A=
+	pm8001_ha->memoryMap.region[CI].total_len =3D 4;=0A=
+	pm8001_ha->memoryMap.region[CI].alignment =3D 4;=0A=
+=0A=
+	/* MPI Memory region 4 for producer Index of outbound queues */=0A=
+	pm8001_ha->memoryMap.region[PI].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[PI].element_size =3D 4;=0A=
+	pm8001_ha->memoryMap.region[PI].total_len =3D 4;=0A=
+	pm8001_ha->memoryMap.region[PI].alignment =3D 4;=0A=
+=0A=
+	/* MPI Memory region 5 inbound queues */=0A=
+	pm8001_ha->memoryMap.region[IB].num_elements =3D 256;=0A=
+	pm8001_ha->memoryMap.region[IB].element_size =3D 64;=0A=
+	pm8001_ha->memoryMap.region[IB].total_len =3D 256*64;=0A=
+	pm8001_ha->memoryMap.region[IB].alignment =3D 64;=0A=
+=0A=
+	/* MPI Memory region 6 inbound queues */=0A=
+	pm8001_ha->memoryMap.region[OB].num_elements =3D 256;=0A=
+	pm8001_ha->memoryMap.region[OB].element_size =3D 64;=0A=
+	pm8001_ha->memoryMap.region[OB].total_len =3D 256*64;=0A=
+	pm8001_ha->memoryMap.region[OB].alignment =3D 64;=0A=
+=0A=
+	/* Memory region write DMA*/=0A=
+	pm8001_ha->memoryMap.region[NVMD].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[NVMD].element_size =3D 4096;=0A=
+	pm8001_ha->memoryMap.region[NVMD].total_len =3D 4096;=0A=
+	/* Memory region for devices*/=0A=
+	pm8001_ha->memoryMap.region[DEV_MEM].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[DEV_MEM].element_size =3D 1024*=0A=
+		sizeof(struct pm8001_device);=0A=
+	pm8001_ha->memoryMap.region[DEV_MEM].total_len =3D 1024*=0A=
+		sizeof(struct pm8001_device);=0A=
+=0A=
+	/* Memory region for ccb_info*/=0A=
+	pm8001_ha->memoryMap.region[CCB_MEM].num_elements =3D 1;=0A=
+	pm8001_ha->memoryMap.region[CCB_MEM].element_size =3D PM8001_MAX_CCB*=0A=
+		sizeof(struct pm8001_ccb_info);=0A=
+	pm8001_ha->memoryMap.region[CCB_MEM].total_len =3D PM8001_MAX_CCB*=0A=
+		sizeof(struct pm8001_ccb_info);=0A=
+=0A=
+	for (i =3D 0; i < USI_MAX_MEMCNT; i++) {=0A=
+		if (pm8001_mem_alloc(pm8001_ha->pdev,=0A=
+			&pm8001_ha->memoryMap.region[i].virt_ptr,=0A=
+			&pm8001_ha->memoryMap.region[i].phys_addr,=0A=
+			&pm8001_ha->memoryMap.region[i].phys_addr_hi,=0A=
+			&pm8001_ha->memoryMap.region[i].phys_addr_lo,=0A=
+			pm8001_ha->memoryMap.region[i].total_len,=0A=
+			pm8001_ha->memoryMap.region[i].alignment) !=3D 0) {=0A=
+				PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("Mem allocate failure %d \n", i));=0A=
+				goto err_out;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	pm8001_ha->devices =3D pm8001_ha->memoryMap.region[DEV_MEM].virt_ptr;=0A=
+	for (i =3D 0; i < PM8001_MAX_DEVICES; i++) {=0A=
+		pm8001_ha->devices[i].dev_type =3D NO_DEVICE;=0A=
+		pm8001_ha->devices[i].id =3D i;=0A=
+		pm8001_ha->devices[i].device_id =3D PM8001_MAX_DEVICES;=0A=
+		pm8001_ha->devices[i].running_req =3D 0;=0A=
+	}=0A=
+	pm8001_ha->ccb_info =3D pm8001_ha->memoryMap.region[CCB_MEM].virt_ptr;=0A=
+	for (i =3D 0; i < PM8001_MAX_CCB; i++)=0A=
+		++pm8001_ha->tags_num;=0A=
+	pm8001_ha->flags =3D PM8001F_INIT_TIME;=0A=
+	/* Initialize tags */=0A=
+	pm8001_tag_init(pm8001_ha);=0A=
+	return 0;=0A=
+err_out:=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_ioremap - remap the pci high physical address to kernal =
virtual=0A=
+ * address so that we can access them.=0A=
+ * @pm8001_ha:our hba structure.=0A=
+ */=0A=
+=0A=
+static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u32 bar;=0A=
+	u32 logicalBar =3D 0;=0A=
+	struct pci_dev *pdev;=0A=
+=0A=
+	pdev =3D pm8001_ha->pdev;=0A=
+	/* map pci mem (PMC pci base 0-3)*/=0A=
+	for (bar =3D 0; bar < 6; bar++) {=0A=
+		/*=0A=
+		** logical BARs for SPC:=0A=
+		** bar 0 and 1 - logical BAR0=0A=
+		** bar 2 and 3 - logical BAR1=0A=
+		** bar4 - logical BAR2=0A=
+		** bar5 - logical BAR3=0A=
+		** Skip the appropriate assignments:=0A=
+		*/=0A=
+		if ((bar =3D=3D 1) || (bar =3D=3D 3))=0A=
+			continue;=0A=
+		if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {=0A=
+			pm8001_ha->io_mem[logicalBar].membase =3D=0A=
+				pci_resource_start(pdev, bar);=0A=
+			pm8001_ha->io_mem[logicalBar].membase &=3D=0A=
+				(u32)PCI_BASE_ADDRESS_MEM_MASK;=0A=
+			pm8001_ha->io_mem[logicalBar].memsize =3D=0A=
+				pci_resource_len(pdev, bar);=0A=
+			pm8001_ha->io_mem[logicalBar].memvirtaddr =3D=0A=
+				ioremap(pm8001_ha->io_mem[logicalBar].membase,=0A=
+				pm8001_ha->io_mem[logicalBar].memsize);=0A=
+			PM8001_INIT_DBG(pm8001_ha,=0A=
+				pm8001_printk("PCI: bar %d,logicalBar %d "=0A=
+				"virt_addr=3D%lx,len=3D%d\n", bar, logicalBar,=0A=
+				(unsigned long)=0A=
+				pm8001_ha->io_mem[logicalBar].memvirtaddr,=0A=
+				pm8001_ha->io_mem[logicalBar].memsize));=0A=
+		} else {=0A=
+			pm8001_ha->io_mem[logicalBar].membase	=3D 0;=0A=
+			pm8001_ha->io_mem[logicalBar].memsize	=3D 0;=0A=
+			pm8001_ha->io_mem[logicalBar].memvirtaddr =3D 0;=0A=
+		}=0A=
+		logicalBar++;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_pci_alloc - initialize our ha card structure=0A=
+ * @pdev: pci device.=0A=
+ * @ent: ent=0A=
+ * @shost: scsi host struct which has been initialized before.=0A=
+ */=0A=
+static struct pm8001_hba_info *__devinit=0A=
+pm8001_pci_alloc(struct pci_dev *pdev, u32 chip_id, struct Scsi_Host =
*shost)=0A=
+{=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+=0A=
+=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	if (!pm8001_ha)=0A=
+		return NULL;=0A=
+=0A=
+	pm8001_ha->pdev =3D pdev;=0A=
+	pm8001_ha->dev =3D &pdev->dev;=0A=
+	pm8001_ha->chip_id =3D chip_id;=0A=
+	pm8001_ha->chip =3D &pm8001_chips[pm8001_ha->chip_id];=0A=
+	pm8001_ha->irq =3D pdev->irq;=0A=
+	pm8001_ha->sas =3D sha;=0A=
+	pm8001_ha->shost =3D shost;=0A=
+	pm8001_ha->id =3D pm8001_id++;=0A=
+	INIT_LIST_HEAD(&pm8001_ha->wq_list);=0A=
+	pm8001_ha->logging_level =3D 0x01;=0A=
+	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,=0A=
+		(unsigned long)pm8001_ha);=0A=
+#endif=0A=
+	pm8001_ioremap(pm8001_ha);=0A=
+	if (!pm8001_alloc(pm8001_ha))=0A=
+		return pm8001_ha;=0A=
+	pm8001_free(pm8001_ha);=0A=
+	return NULL;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pci_go_44 - pm8001 specified, its DMA is 44 bit rather than 64 bit=0A=
+ * @pdev: pci device.=0A=
+ */=0A=
+static int pci_go_44(struct pci_dev *pdev)=0A=
+{=0A=
+	int rc;=0A=
+=0A=
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(44))) {=0A=
+		rc =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(44));=0A=
+		if (rc) {=0A=
+			rc =3D pci_set_consistent_dma_mask(pdev,=0A=
+				DMA_BIT_MASK(32));=0A=
+			if (rc) {=0A=
+				dev_printk(KERN_ERR, &pdev->dev,=0A=
+					"44-bit DMA enable failed\n");=0A=
+				return rc;=0A=
+			}=0A=
+		}=0A=
+	} else {=0A=
+		rc =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
+		if (rc) {=0A=
+			dev_printk(KERN_ERR, &pdev->dev,=0A=
+				"32-bit DMA enable failed\n");=0A=
+			return rc;=0A=
+		}=0A=
+		rc =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
+		if (rc) {=0A=
+			dev_printk(KERN_ERR, &pdev->dev,=0A=
+				"32-bit consistent DMA enable failed\n");=0A=
+			return rc;=0A=
+		}=0A=
+	}=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_prep_sas_ha_init - allocate sas_phy and sas_port struct in =
general=0A=
+ * hba struct,allocate our special hba struct in general hba struct.=0A=
+ * @shost: scsi host which has been allocated outside.=0A=
+ * @chip_info: our ha struct.=0A=
+ */=0A=
+static int __devinit pm8001_prep_sas_ha_init(struct Scsi_Host * shost,=0A=
+	const struct pm8001_chip_info *chip_info)=0A=
+{=0A=
+	int phy_nr, port_nr;=0A=
+	struct asd_sas_phy **arr_phy;=0A=
+	struct asd_sas_port **arr_port;=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+=0A=
+	phy_nr =3D chip_info->n_phy;=0A=
+	port_nr =3D phy_nr;=0A=
+	memset(sha, 0x00, sizeof(*sha));=0A=
+	arr_phy =3D kcalloc(phy_nr, sizeof(void *), GFP_KERNEL);=0A=
+	if (!arr_phy)=0A=
+		goto exit;=0A=
+	arr_port =3D kcalloc(port_nr, sizeof(void *), GFP_KERNEL);=0A=
+	if (!arr_port)=0A=
+		goto exit_free2;=0A=
+=0A=
+	sha->sas_phy =3D arr_phy;=0A=
+	sha->sas_port =3D arr_port;=0A=
+	sha->lldd_ha =3D kzalloc(sizeof(struct pm8001_hba_info), GFP_KERNEL);=0A=
+	if (!sha->lldd_ha)=0A=
+		goto exit_free1;=0A=
+=0A=
+	shost->transportt =3D pm8001_stt;=0A=
+	shost->max_id =3D PM8001_MAX_DEVICES;=0A=
+	shost->max_lun =3D 8;=0A=
+	shost->max_channel =3D 0;=0A=
+	shost->unique_id =3D pm8001_id;=0A=
+	shost->max_cmd_len =3D 16;=0A=
+	shost->can_queue =3D PM8001_CAN_QUEUE;=0A=
+	shost->cmd_per_lun =3D 32;=0A=
+	return 0;=0A=
+exit_free1:=0A=
+	kfree(arr_port);=0A=
+exit_free2:=0A=
+	kfree(arr_phy);=0A=
+exit:=0A=
+	return -1;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_post_sas_ha_init - initialize general hba struct which is =
defined=0A=
+ * in libsas=0A=
+ * @shost: scsi host which has been allocated outside=0A=
+ * @chip_info: our ha struct.=0A=
+ */=0A=
+static void  __devinit pm8001_post_sas_ha_init(struct Scsi_Host *shost,=0A=
+	const struct pm8001_chip_info *chip_info)=0A=
+{=0A=
+	int i =3D 0;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	for (i =3D 0; i < chip_info->n_phy; i++) {=0A=
+		sha->sas_phy[i] =3D &pm8001_ha->phy[i].sas_phy;=0A=
+		sha->sas_port[i] =3D &pm8001_ha->port[i].sas_port;=0A=
+	}=0A=
+	sha->sas_ha_name =3D DRV_NAME;=0A=
+	sha->dev =3D pm8001_ha->dev;=0A=
+=0A=
+	sha->lldd_module =3D THIS_MODULE;=0A=
+	sha->sas_addr =3D &pm8001_ha->sas_addr[0];=0A=
+	sha->num_phys =3D chip_info->n_phy;=0A=
+	sha->lldd_max_execute_num =3D 1;=0A=
+	sha->lldd_queue_size =3D PM8001_CAN_QUEUE;=0A=
+	sha->core.shost =3D shost;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_init_sas_add - initialize sas address=0A=
+ * @chip_info: our ha struct.=0A=
+ *=0A=
+ * Currently we just set the fixed SAS address to our HBA,for =
manufacture,=0A=
+ * it should read from the EEPROM=0A=
+ */=0A=
+static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	u8 i;=0A=
+#ifdef PM8001_READ_VPD=0A=
+	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	pm8001_ha->nvmd_completion =3D &completion;=0A=
+	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, 0, 0);=0A=
+	wait_for_completion(&completion);=0A=
+	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {=0A=
+		memcpy(&pm8001_ha->phy[i].dev_sas_addr, pm8001_ha->sas_addr,=0A=
+			SAS_ADDR_SIZE);=0A=
+		PM8001_INIT_DBG(pm8001_ha,=0A=
+			pm8001_printk("phy %d sas_addr =3D %x \n", i,=0A=
+			(u64)pm8001_ha->phy[i].dev_sas_addr));=0A=
+	}=0A=
+#else=0A=
+	for (i =3D 0; i < pm8001_ha->chip->n_phy; i++) {=0A=
+		pm8001_ha->phy[i].dev_sas_addr =3D 0x500e004010000004ULL;=0A=
+		pm8001_ha->phy[i].dev_sas_addr =3D=0A=
+			cpu_to_be64((u64)=0A=
+				(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));=0A=
+	}=0A=
+	memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,=0A=
+		SAS_ADDR_SIZE);=0A=
+#endif=0A=
+}=0A=
+=0A=
+#ifdef PM8001_USE_MSIX=0A=
+/**=0A=
+ * pm8001_setup_msix - enable MSI-X interrupt=0A=
+ * @chip_info: our ha struct.=0A=
+ * @irq_handler: irq_handler=0A=
+ */=0A=
+static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,=0A=
+	irq_handler_t irq_handler)=0A=
+{=0A=
+	u32 i =3D 0, j =3D 0;=0A=
+	u32 number_of_intr =3D 1;=0A=
+	int flag =3D 0;=0A=
+	u32 max_entry;=0A=
+	int rc;=0A=
+	max_entry =3D sizeof(pm8001_ha->msix_entries) /=0A=
+		sizeof(pm8001_ha->msix_entries[0]);=0A=
+	flag |=3D IRQF_DISABLED;=0A=
+	for (i =3D 0; i < max_entry ; i++)=0A=
+		pm8001_ha->msix_entries[i].entry =3D i;=0A=
+	rc =3D pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,=0A=
+		number_of_intr);=0A=
+	pm8001_ha->number_of_intr =3D number_of_intr;=0A=
+	if (!rc) {=0A=
+		for (i =3D 0; i < number_of_intr; i++) {=0A=
+			if (request_irq(pm8001_ha->msix_entries[i].vector,=0A=
+				irq_handler, flag, DRV_NAME,=0A=
+				SHOST_TO_SAS_HA(pm8001_ha->shost))) {=0A=
+				for (j =3D 0; j < i; j++)=0A=
+					free_irq(=0A=
+					pm8001_ha->msix_entries[j].vector,=0A=
+					SHOST_TO_SAS_HA(pm8001_ha->shost));=0A=
+				pci_disable_msix(pm8001_ha->pdev);=0A=
+				break;=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+	return rc;=0A=
+}=0A=
+#endif=0A=
+=0A=
+/**=0A=
+ * pm8001_request_irq - register interrupt=0A=
+ * @chip_info: our ha struct.=0A=
+ */=0A=
+static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	struct pci_dev *pdev;=0A=
+	irq_handler_t irq_handler =3D pm8001_interrupt;=0A=
+	u32 rc;=0A=
+=0A=
+	pdev =3D pm8001_ha->pdev;=0A=
+=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))=0A=
+		return pm8001_setup_msix(pm8001_ha, irq_handler);=0A=
+	else=0A=
+		goto intx;=0A=
+#endif=0A=
+=0A=
+intx:=0A=
+	/* intialize the INT-X interrupt */=0A=
+	rc =3D request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME,=0A=
+		SHOST_TO_SAS_HA(pm8001_ha->shost));=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_pci_probe - probe supported device=0A=
+ * @pdev: pci device which kernel has been prepared for.=0A=
+ * @ ent: ent=0A=
+ *=0A=
+ * This function is the main initialization function, when register a =
new=0A=
+ * pci driver it is invoked, all struct an hardware initilization =
should be done=0A=
+ * here, also, register interrupt=0A=
+ */=0A=
+static int __devinit pm8001_pci_probe(struct pci_dev *pdev,=0A=
+	const struct pci_device_id *ent)=0A=
+{=0A=
+	unsigned int rc;=0A=
+	u32	pci_reg;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct Scsi_Host *shost =3D NULL;=0A=
+	const struct pm8001_chip_info *chip;=0A=
+=0A=
+	dev_printk(KERN_INFO, &pdev->dev,=0A=
+		"pm8001: driver version %s\n", DRV_VERSION);=0A=
+	rc =3D pci_enable_device(pdev);=0A=
+	if (rc)=0A=
+		goto err_out_enable;=0A=
+	pci_set_master(pdev);=0A=
+	/*=0A=
+	 * Enable pci slot busmaster by setting pci command register.=0A=
+	 * This is required by FW for Cyclone card.=0A=
+	 */=0A=
+=0A=
+	pci_read_config_dword(pdev, PCI_COMMAND, &pci_reg);=0A=
+	pci_reg |=3D 0x157;=0A=
+	pci_write_config_dword(pdev, PCI_COMMAND, pci_reg);=0A=
+	rc =3D pci_request_regions(pdev, DRV_NAME);=0A=
+	if (rc)=0A=
+		goto err_out_disable;=0A=
+	rc =3D pci_go_44(pdev);=0A=
+	if (rc)=0A=
+		goto err_out_regions;=0A=
+=0A=
+	shost =3D scsi_host_alloc(&pm8001_sht, sizeof(void *));=0A=
+	if (!shost) {=0A=
+		rc =3D -ENOMEM;=0A=
+		goto err_out_regions;=0A=
+	}=0A=
+	chip =3D &pm8001_chips[ent->driver_data];=0A=
+	SHOST_TO_SAS_HA(shost) =3D=0A=
+		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);=0A=
+	if (!SHOST_TO_SAS_HA(shost)) {=0A=
+		rc =3D -ENOMEM;=0A=
+		goto err_out_free_host;=0A=
+	}=0A=
+=0A=
+	rc =3D pm8001_prep_sas_ha_init(shost, chip);=0A=
+	if (rc) {=0A=
+		rc =3D -ENOMEM;=0A=
+		goto err_out_free;=0A=
+	}=0A=
+	pci_set_drvdata(pdev, SHOST_TO_SAS_HA(shost));=0A=
+	pm8001_ha =3D pm8001_pci_alloc(pdev, chip_8001, shost);=0A=
+	if (!pm8001_ha) {=0A=
+		rc =3D -ENOMEM;=0A=
+		goto err_out_free;=0A=
+	}=0A=
+	list_add_tail(&pm8001_ha->list, &hba_list);=0A=
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);=0A=
+	rc =3D PM8001_CHIP_DISP->chip_init(pm8001_ha);=0A=
+	if (rc)=0A=
+		goto err_out_ha_free;=0A=
+=0A=
+	rc =3D scsi_add_host(shost, &pdev->dev);=0A=
+	if (rc)=0A=
+		goto err_out_ha_free;=0A=
+	rc =3D pm8001_request_irq(pm8001_ha);=0A=
+	if (rc)=0A=
+		goto err_out_shost;=0A=
+=0A=
+	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha);=0A=
+	pm8001_init_sas_add(pm8001_ha);=0A=
+	pm8001_post_sas_ha_init(shost, chip);=0A=
+	rc =3D sas_register_ha(SHOST_TO_SAS_HA(shost));=0A=
+	if (rc)=0A=
+		goto err_out_shost;=0A=
+	scsi_scan_host(pm8001_ha->shost);=0A=
+	return 0;=0A=
+=0A=
+err_out_shost:=0A=
+	scsi_remove_host(pm8001_ha->shost);=0A=
+err_out_ha_free:=0A=
+	pm8001_free(pm8001_ha);=0A=
+err_out_free:=0A=
+	kfree(SHOST_TO_SAS_HA(shost));=0A=
+err_out_free_host:=0A=
+	kfree(shost);=0A=
+err_out_regions:=0A=
+	pci_release_regions(pdev);=0A=
+err_out_disable:=0A=
+	pci_disable_device(pdev);=0A=
+err_out_enable:=0A=
+	return rc;=0A=
+}=0A=
+static void __devexit pm8001_pci_remove(struct pci_dev *pdev)=0A=
+{=0A=
+	struct sas_ha_struct *sha =3D pci_get_drvdata(pdev);=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	int i;=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	pci_set_drvdata(pdev, NULL);=0A=
+	sas_unregister_ha(sha);=0A=
+	sas_remove_host(pm8001_ha->shost);=0A=
+	list_del(&pm8001_ha->list);=0A=
+	scsi_remove_host(pm8001_ha->shost);=0A=
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);=0A=
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);=0A=
+=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	for (i =3D 0; i < pm8001_ha->number_of_intr; i++)=0A=
+		synchronize_irq(pm8001_ha->msix_entries[i].vector);=0A=
+	for (i =3D 0; i < pm8001_ha->number_of_intr; i++)=0A=
+		free_irq(pm8001_ha->msix_entries[i].vector, sha);=0A=
+	pci_disable_msix(pdev);=0A=
+#else=0A=
+	free_irq(pm8001_ha->irq, sha);=0A=
+#endif=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+	tasklet_kill(&pm8001_ha->tasklet);=0A=
+#endif=0A=
+	pm8001_free(pm8001_ha);=0A=
+	kfree(sha->sas_phy);=0A=
+	kfree(sha->sas_port);=0A=
+	kfree(sha);=0A=
+	pci_release_regions(pdev);=0A=
+	pci_disable_device(pdev);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_pci_suspend - power management suspend main entry point=0A=
+ * @pdev: PCI device struct=0A=
+ * @state: PM state change to (usually PCI_D3)=0A=
+ *=0A=
+ * Returns 0 success, anything else error.=0A=
+ */=0A=
+static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
+{=0A=
+	struct sas_ha_struct *sha =3D pci_get_drvdata(pdev);=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	int i , pos;=0A=
+	u32 device_state;=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	flush_scheduled_work();=0A=
+	scsi_block_requests(pm8001_ha->shost);=0A=
+	pos =3D pci_find_capability(pdev, PCI_CAP_ID_PM);=0A=
+	if (pos =3D=3D 0) {=0A=
+		printk(KERN_ERR " PCI PM not supported\n");=0A=
+		return -ENODEV;=0A=
+	}=0A=
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);=0A=
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	for (i =3D 0; i < pm8001_ha->number_of_intr; i++)=0A=
+		synchronize_irq(pm8001_ha->msix_entries[i].vector);=0A=
+	for (i =3D 0; i < pm8001_ha->number_of_intr; i++)=0A=
+		free_irq(pm8001_ha->msix_entries[i].vector, sha);=0A=
+	pci_disable_msix(pdev);=0A=
+#else=0A=
+	free_irq(pm8001_ha->irq, sha);=0A=
+#endif=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+	tasklet_kill(&pm8001_ha->tasklet);=0A=
+#endif=0A=
+	device_state =3D pci_choose_state(pdev, state);=0A=
+	pm8001_printk("pdev=3D0x%p, slot=3D%s, entering "=0A=
+		      "operating state [D%d]\n", pdev,=0A=
+		      pm8001_ha->name, device_state);=0A=
+	pci_save_state(pdev);=0A=
+	pci_disable_device(pdev);=0A=
+	pci_set_power_state(pdev, device_state);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+ * pm8001_pci_resume - power management resume main entry point=0A=
+ * @pdev: PCI device struct=0A=
+ *=0A=
+ * Returns 0 success, anything else error.=0A=
+ */=0A=
+static int pm8001_pci_resume(struct pci_dev *pdev)=0A=
+{=0A=
+	struct sas_ha_struct *sha =3D pci_get_drvdata(pdev);=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	int rc;=0A=
+	u32 device_state;=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	device_state =3D pdev->current_state;=0A=
+=0A=
+	pm8001_printk("pdev=3D0x%p, slot=3D%s, resuming from previous "=0A=
+		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);=0A=
+=0A=
+	pci_set_power_state(pdev, PCI_D0);=0A=
+	pci_enable_wake(pdev, PCI_D0, 0);=0A=
+	pci_restore_state(pdev);=0A=
+	rc =3D pci_enable_device(pdev);=0A=
+	if (rc) {=0A=
+		pm8001_printk("slot=3D%s Enable device failed during resume\n",=0A=
+			      pm8001_ha->name);=0A=
+		goto err_out_enable;=0A=
+	}=0A=
+=0A=
+	pci_set_master(pdev);=0A=
+	rc =3D pci_go_44(pdev);=0A=
+	if (rc)=0A=
+		goto err_out_disable;=0A=
+=0A=
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);=0A=
+	rc =3D PM8001_CHIP_DISP->chip_init(pm8001_ha);=0A=
+	if (rc)=0A=
+		goto err_out_disable;=0A=
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);=0A=
+	rc =3D pm8001_request_irq(pm8001_ha);=0A=
+	if (rc)=0A=
+		goto err_out_disable;=0A=
+	#ifdef PM8001_USE_TASKLET=0A=
+	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,=0A=
+		    (unsigned long)pm8001_ha);=0A=
+	#endif=0A=
+	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha);=0A=
+	scsi_unblock_requests(pm8001_ha->shost);=0A=
+	return 0;=0A=
+=0A=
+err_out_disable:=0A=
+	scsi_remove_host(pm8001_ha->shost);=0A=
+	pci_disable_device(pdev);=0A=
+err_out_enable:=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+static struct pci_device_id __devinitdata pm8001_pci_table[] =3D {=0A=
+	{=0A=
+		PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001=0A=
+	},=0A=
+	{=0A=
+		PCI_DEVICE(0x117c, 0x0042),=0A=
+		.driver_data =3D chip_8001=0A=
+	},=0A=
+	{} /* terminate list */=0A=
+};=0A=
+=0A=
+static struct pci_driver pm8001_pci_driver =3D {=0A=
+	.name		=3D DRV_NAME,=0A=
+	.id_table	=3D pm8001_pci_table,=0A=
+	.probe		=3D pm8001_pci_probe,=0A=
+	.remove		=3D __devexit_p(pm8001_pci_remove),=0A=
+	.suspend	=3D pm8001_pci_suspend,=0A=
+	.resume		=3D pm8001_pci_resume,=0A=
+};=0A=
+=0A=
+/**=0A=
+ *	pm8001_init - initialize scsi transport template=0A=
+ */=0A=
+static int __init pm8001_init(void)=0A=
+{=0A=
+	int rc;=0A=
+	pm8001_id =3D 0;=0A=
+	pm8001_stt =3D sas_domain_attach_transport(&pm8001_transport_ops);=0A=
+	if (!pm8001_stt)=0A=
+		return -ENOMEM;=0A=
+	rc =3D pci_register_driver(&pm8001_pci_driver);=0A=
+	if (rc)=0A=
+		goto err_out;=0A=
+	return 0;=0A=
+err_out:=0A=
+	sas_release_transport(pm8001_stt);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+static void __exit pm8001_exit(void)=0A=
+{=0A=
+	pci_unregister_driver(&pm8001_pci_driver);=0A=
+	sas_release_transport(pm8001_stt);=0A=
+}=0A=
+=0A=
+module_init(pm8001_init);=0A=
+module_exit(pm8001_exit);=0A=
+=0A=
+MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");=0A=
+MODULE_DESCRIPTION("PMC-Sierra PM8001 SAS/SATA controller driver");=0A=
+MODULE_VERSION(DRV_VERSION);=0A=
+MODULE_LICENSE("GPL");=0A=
+MODULE_DEVICE_TABLE(pci, pm8001_pci_table);=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
new file mode 100644=0A=
index 0000000..5631462=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -0,0 +1,1107 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#include "pm8001_sas.h"=0A=
+=0A=
+/**=0A=
+ * pm8001_find_tag - from sas task to find out  tag that belongs to =
this task=0A=
+ * @task: the task sent to the LLDD=0A=
+ * @tag: the found tag associated with the task=0A=
+ */=0A=
+static int pm8001_find_tag(struct sas_task *task, u32 *tag)=0A=
+{=0A=
+	if (task->lldd_task) {=0A=
+		struct pm8001_ccb_info *ccb;=0A=
+		ccb =3D task->lldd_task;=0A=
+		*tag =3D ccb->ccb_tag;=0A=
+		return 1;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_tag_clear - clear the tags bitmap=0A=
+  * @pm8001_ha: our hba struct=0A=
+  * @tag: the found tag associated with the task=0A=
+  */=0A=
+static void pm8001_tag_clear(struct pm8001_hba_info *pm8001_ha, u32 tag)=0A=
+{=0A=
+	void *bitmap =3D pm8001_ha->tags;=0A=
+	clear_bit(tag, bitmap);=0A=
+}=0A=
+=0A=
+static void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)=0A=
+{=0A=
+	pm8001_tag_clear(pm8001_ha, tag);=0A=
+}=0A=
+=0A=
+static void pm8001_tag_set(struct pm8001_hba_info *pm8001_ha, u32 tag)=0A=
+{=0A=
+	void *bitmap =3D pm8001_ha->tags;=0A=
+	set_bit(tag, bitmap);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_tag_alloc - allocate a empty tag for task used.=0A=
+  * @pm8001_ha: our hba struct=0A=
+  * @tag_out: the found empty tag .=0A=
+  */=0A=
+inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 =
*tag_out)=0A=
+{=0A=
+	unsigned int index, tag;=0A=
+	void *bitmap =3D pm8001_ha->tags;=0A=
+=0A=
+	index =3D find_first_zero_bit(bitmap, pm8001_ha->tags_num);=0A=
+	tag =3D index;=0A=
+	if (tag >=3D pm8001_ha->tags_num)=0A=
+		return -SAS_QUEUE_FULL;=0A=
+	pm8001_tag_set(pm8001_ha, tag);=0A=
+	*tag_out =3D tag;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)=0A=
+{=0A=
+	int i;=0A=
+	for (i =3D 0; i < pm8001_ha->tags_num; ++i)=0A=
+		pm8001_tag_clear(pm8001_ha, i);=0A=
+}=0A=
+=0A=
+ /**=0A=
+  * pm8001_mem_alloc - allocate memery for pm8001.=0A=
+  * @pdev: pci device.=0A=
+  * @virt_addr: the allocated virtual address=0A=
+  * @pphys_addr_hi: the physical address high byte address.=0A=
+  * @pphys_addr_lo: the physical address low byte address.=0A=
+  * @mem_size: memery size.=0A=
+  */=0A=
+int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,=0A=
+	dma_addr_t *pphys_addr, u32 *pphys_addr_hi,=0A=
+	u32  *pphys_addr_lo, u32  mem_size, u32 align)=0A=
+{=0A=
+	caddr_t mem_virt_alloc;=0A=
+	dma_addr_t mem_dma_handle;=0A=
+	u64     phys_align;=0A=
+	u64     align_offset =3D 0;=0A=
+	if (align)=0A=
+		align_offset =3D (dma_addr_t)align - 1;=0A=
+	mem_virt_alloc =3D=0A=
+		pci_alloc_consistent(pdev, mem_size + align, &mem_dma_handle);=0A=
+	if (!mem_virt_alloc) {=0A=
+		pm8001_printk("memory allocation error\n");=0A=
+		return -1;=0A=
+	}=0A=
+	memset((void *)mem_virt_alloc, 0, mem_size+align);=0A=
+	*pphys_addr =3D mem_dma_handle;=0A=
+	phys_align =3D (*pphys_addr + align_offset) & ~align_offset;=0A=
+	*virt_addr =3D (void *)mem_virt_alloc + phys_align - *pphys_addr;=0A=
+	*pphys_addr_hi  =3D HIGH_32_BITS(phys_align);=0A=
+	*pphys_addr_lo =3D LOW_32_BITS(phys_align);=0A=
+	return 0;=0A=
+}=0A=
+/**=0A=
+  * pm8001_find_ha_by_dev - from domain device which come from sas =
layer to=0A=
+  * find out our hba struct.=0A=
+  * @dev: the domain device which from sas layer.=0A=
+  */=0A=
+static=0A=
+struct pm8001_hba_info *pm8001_find_ha_by_dev(struct domain_device *dev)=0A=
+{=0A=
+	struct sas_ha_struct *sha =3D dev->port->ha;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;=0A=
+	return pm8001_ha;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_phy_control - this function should be registered to=0A=
+  * sas_domain_function_template to provide libsas used, note: this is =
just=0A=
+  * control the HBA phy rather than other expander phy if you want =
control=0A=
+  * other phy, you should use SMP command.=0A=
+  * @sas_phy: which phy in HBA phys.=0A=
+  * @func: the operation.=0A=
+  * @funcdata: always NULL.=0A=
+  */=0A=
+int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,=0A=
+	void *funcdata)=0A=
+{=0A=
+	int rc =3D 0, phy_id =3D sas_phy->id;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D NULL;=0A=
+	struct sas_phy_linkrates *rates;=0A=
+	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	pm8001_ha =3D sas_phy->ha->lldd_ha;=0A=
+	pm8001_ha->phy[phy_id].enable_completion =3D &completion;=0A=
+	switch (func) {=0A=
+	case PHY_FUNC_SET_LINK_RATE:=0A=
+		rates =3D funcdata;=0A=
+		if (rates->minimum_linkrate) {=0A=
+			pm8001_ha->phy[phy_id].minimum_linkrate =3D=0A=
+				rates->minimum_linkrate;=0A=
+		}=0A=
+		if (rates->maximum_linkrate) {=0A=
+			pm8001_ha->phy[phy_id].maximum_linkrate =3D=0A=
+				rates->maximum_linkrate;=0A=
+		}=0A=
+		if (pm8001_ha->phy[phy_id].phy_state =3D=3D 0) {=0A=
+			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);=0A=
+			wait_for_completion(&completion);=0A=
+		}=0A=
+		PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,=0A=
+					      PHY_LINK_RESET);=0A=
+		break;=0A=
+	case PHY_FUNC_HARD_RESET:=0A=
+		if (pm8001_ha->phy[phy_id].phy_state =3D=3D 0) {=0A=
+			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);=0A=
+			wait_for_completion(&completion);=0A=
+		}=0A=
+		PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,=0A=
+					      PHY_HARD_RESET);=0A=
+		break;=0A=
+	case PHY_FUNC_LINK_RESET:=0A=
+		if (pm8001_ha->phy[phy_id].phy_state =3D=3D 0) {=0A=
+			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);=0A=
+			wait_for_completion(&completion);=0A=
+		}=0A=
+		PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,=0A=
+					      PHY_LINK_RESET);=0A=
+		break;=0A=
+	case PHY_FUNC_RELEASE_SPINUP_HOLD:=0A=
+		PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,=0A=
+					      PHY_LINK_RESET);=0A=
+		break;=0A=
+	case PHY_FUNC_DISABLE:=0A=
+		PM8001_CHIP_DISP->phy_stop_req(pm8001_ha, phy_id);=0A=
+		break;=0A=
+	default:=0A=
+		rc =3D -EOPNOTSUPP;=0A=
+	}=0A=
+	msleep(300);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+int pm8001_slave_alloc(struct scsi_device *scsi_dev)=0A=
+{=0A=
+	struct domain_device *dev =3D sdev_to_domain_dev(scsi_dev);=0A=
+	if (dev_is_sata(dev)) {=0A=
+		/* We don't need to rescan targets=0A=
+		* if REPORT_LUNS request is failed=0A=
+		*/=0A=
+		if (scsi_dev->lun > 0)=0A=
+			return -ENXIO;=0A=
+		scsi_dev->tagged_supported =3D 1;=0A=
+	}=0A=
+	return sas_slave_alloc(scsi_dev);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_scan_start - we should enable all HBA phys by sending the =
phy_start=0A=
+  * command to HBA.=0A=
+  * @shost: the scsi host data.=0A=
+  */=0A=
+void pm8001_scan_start(struct Scsi_Host *shost)=0A=
+{=0A=
+	int i;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);=0A=
+	pm8001_ha =3D sha->lldd_ha;=0A=
+	for (i =3D 0; i < pm8001_ha->chip->n_phy; ++i)=0A=
+		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);=0A=
+}=0A=
+=0A=
+int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)=0A=
+{=0A=
+	/* give the phy enabling interrupt event time to come in (1s=0A=
+	* is empirically about all it takes) */=0A=
+	if (time < HZ)=0A=
+		return 0;=0A=
+	/* Wait for discovery to finish */=0A=
+	scsi_flush_work(shost);=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_task_prep_smp - the dispatcher function, prepare data for =
smp task=0A=
+  * @pm8001_ha: our hba card information=0A=
+  * @ccb: the ccb which attached to smp task=0A=
+  */=0A=
+static int pm8001_task_prep_smp(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	return PM8001_CHIP_DISP->smp_req(pm8001_ha, ccb);=0A=
+}=0A=
+=0A=
+u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)=0A=
+{=0A=
+	struct ata_queued_cmd *qc =3D task->uldd_task;=0A=
+	if (qc) {=0A=
+		if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||=0A=
+			qc->tf.command =3D=3D ATA_CMD_FPDMA_READ) {=0A=
+			*tag =3D qc->tag;=0A=
+			return 1;=0A=
+		}=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_task_prep_ata - the dispatcher function, prepare data for =
sata task=0A=
+  * @pm8001_ha: our hba card information=0A=
+  * @ccb: the ccb which attached to sata task=0A=
+  */=0A=
+static int pm8001_task_prep_ata(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	return PM8001_CHIP_DISP->sata_req(pm8001_ha, ccb);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_task_prep_ssp_tm - the dispatcher function, prepare task =
management data=0A=
+  * @pm8001_ha: our hba card information=0A=
+  * @ccb: the ccb which attached to TM=0A=
+  * @tmf: the task management IU=0A=
+  */=0A=
+static int pm8001_task_prep_ssp_tm(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb, struct pm8001_tmf_task *tmf)=0A=
+{=0A=
+	return PM8001_CHIP_DISP->ssp_tm_req(pm8001_ha, ccb, tmf);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_task_prep_ssp - the dispatcher function,prepare ssp data for =
ssp task=0A=
+  * @pm8001_ha: our hba card information=0A=
+  * @ccb: the ccb which attached to ssp task=0A=
+  */=0A=
+static int pm8001_task_prep_ssp(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_ccb_info *ccb)=0A=
+{=0A=
+	return PM8001_CHIP_DISP->ssp_io_req(pm8001_ha, ccb);=0A=
+}=0A=
+int pm8001_slave_configure(struct scsi_device *sdev)=0A=
+{=0A=
+	struct domain_device *dev =3D sdev_to_domain_dev(sdev);=0A=
+	int ret =3D sas_slave_configure(sdev);=0A=
+	if (ret)=0A=
+		return ret;=0A=
+	if (dev_is_sata(dev)) {=0A=
+	#ifdef PM8001_DISABLE_NCQ=0A=
+		struct ata_port *ap =3D dev->sata_dev.ap;=0A=
+		struct ata_device *adev =3D ap->link.device;=0A=
+		adev->flags |=3D ATA_DFLAG_NCQ_OFF;=0A=
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);=0A=
+	#endif=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+/**=0A=
+  * pm8001_task_exec -execute the task which come from upper level, =
send the=0A=
+  * command or data to DMA area and then increase CI,for =
queuecommand(ssp),=0A=
+  * it is from upper layer and for smp command,it is from libsas,=0A=
+  * for ata command it is from libata.=0A=
+  * @task: the task to be execute.=0A=
+  * @num: if can_queue great than 1, the task can be queued up. for SMP =
task,=0A=
+  * we always execute one one time.=0A=
+  * @gfp_flags: gfp_flags.=0A=
+  * @is tmf: if it is task management task.=0A=
+  * @tmf: the task management IU=0A=
+  */=0A=
+#define DEV_IS_GONE(pm8001_dev)	\=0A=
+	((!pm8001_dev || (pm8001_dev->dev_type =3D=3D NO_DEVICE)))=0A=
+static int pm8001_task_exec(struct sas_task *task, const int num,=0A=
+	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)=0A=
+{=0A=
+	struct domain_device *dev =3D task->dev;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct sas_task *t =3D task;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	u32 tag =3D 0xdeadbeef, rc, n_elem =3D 0;=0A=
+	u32 n =3D num;=0A=
+	unsigned long flags =3D 0;=0A=
+=0A=
+	if (!dev->port) {=0A=
+		struct task_status_struct *tsm =3D &t->task_status;=0A=
+		tsm->resp =3D SAS_TASK_UNDELIVERED;=0A=
+		tsm->stat =3D SAS_PHY_DOWN;=0A=
+		if (dev->dev_type !=3D SATA_DEV)=0A=
+			t->task_done(t);=0A=
+		return 0;=0A=
+	}=0A=
+	pm8001_ha =3D pm8001_find_ha_by_dev(task->dev);=0A=
+	PM8001_IO_DBG(pm8001_ha, pm8001_printk("pm8001_task_exec device \n "));=0A=
+	spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+	do {=0A=
+		dev =3D t->dev;=0A=
+		pm8001_dev =3D dev->lldd_dev;=0A=
+		if (DEV_IS_GONE(pm8001_dev)) {=0A=
+			if (pm8001_dev) {=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+					pm8001_printk("device %d not ready.\n",=0A=
+					pm8001_dev->device_id));=0A=
+			} else {=0A=
+				PM8001_IO_DBG(pm8001_ha,=0A=
+					pm8001_printk("device %016llx not "=0A=
+					"ready.\n", SAS_ADDR(dev->sas_addr)));=0A=
+			}=0A=
+		rc =3D SAS_PHY_DOWN;=0A=
+			goto out_done;=0A=
+		}=0A=
+		rc =3D pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+		if (rc)=0A=
+			goto err_out;=0A=
+		ccb =3D &pm8001_ha->ccb_info[tag];=0A=
+=0A=
+		if (!sas_protocol_ata(t->task_proto)) {=0A=
+			if (t->num_scatter) {=0A=
+				n_elem =3D dma_map_sg(pm8001_ha->dev,=0A=
+					t->scatter,=0A=
+					t->num_scatter,=0A=
+					t->data_dir);=0A=
+				if (!n_elem) {=0A=
+					rc =3D -ENOMEM;=0A=
+					goto err_out;=0A=
+				}=0A=
+			}=0A=
+		} else {=0A=
+			n_elem =3D t->num_scatter;=0A=
+		}=0A=
+=0A=
+		t->lldd_task =3D NULL;=0A=
+		ccb->n_elem =3D n_elem;=0A=
+		ccb->ccb_tag =3D tag;=0A=
+		ccb->task =3D t;=0A=
+		switch (t->task_proto) {=0A=
+		case SAS_PROTOCOL_SMP:=0A=
+			rc =3D pm8001_task_prep_smp(pm8001_ha, ccb);=0A=
+			break;=0A=
+		case SAS_PROTOCOL_SSP:=0A=
+			if (is_tmf)=0A=
+				rc =3D pm8001_task_prep_ssp_tm(pm8001_ha,=0A=
+					ccb, tmf);=0A=
+			else=0A=
+				rc =3D pm8001_task_prep_ssp(pm8001_ha, ccb);=0A=
+			break;=0A=
+		case SAS_PROTOCOL_SATA:=0A=
+		case SAS_PROTOCOL_STP:=0A=
+		case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:=0A=
+			rc =3D pm8001_task_prep_ata(pm8001_ha, ccb);=0A=
+			break;=0A=
+		default:=0A=
+			dev_printk(KERN_ERR, pm8001_ha->dev,=0A=
+				"unknown sas_task proto: 0x%x\n",=0A=
+				t->task_proto);=0A=
+			rc =3D -EINVAL;=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		if (rc) {=0A=
+			PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk("rc is %x\n", rc));=0A=
+			goto err_out_tag;=0A=
+		}=0A=
+		t->lldd_task =3D ccb;=0A=
+		/* TODO: select normal or high priority */=0A=
+		spin_lock(&t->task_state_lock);=0A=
+		t->task_state_flags |=3D SAS_TASK_AT_INITIATOR;=0A=
+		spin_unlock(&t->task_state_lock);=0A=
+		pm8001_dev->running_req++;=0A=
+		if (n > 1)=0A=
+			t =3D list_entry(t->list.next, struct sas_task, list);=0A=
+	} while (--n);=0A=
+	rc =3D 0;=0A=
+	goto out_done;=0A=
+=0A=
+err_out_tag:=0A=
+	pm8001_tag_free(pm8001_ha, tag);=0A=
+err_out:=0A=
+	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);=0A=
+	if (!sas_protocol_ata(t->task_proto))=0A=
+		if (n_elem)=0A=
+			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,=0A=
+				t->data_dir);=0A=
+out_done:=0A=
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_queue_command - register for upper layer used, all IO =
commands sent=0A=
+  * to HBA are from this interface.=0A=
+  * @task: the task to be execute.=0A=
+  * @num: if can_queue great than 1, the task can be queued up. for SMP =
task,=0A=
+  * we always execute one one time=0A=
+  * @gfp_flags: gfp_flags=0A=
+  */=0A=
+int pm8001_queue_command(struct sas_task *task, const int num,=0A=
+		gfp_t gfp_flags)=0A=
+{=0A=
+	return pm8001_task_exec(task, num, gfp_flags, 0, NULL);=0A=
+}=0A=
+=0A=
+void pm8001_ccb_free(struct pm8001_hba_info *pm8001_ha, u32 ccb_idx)=0A=
+{=0A=
+	pm8001_tag_clear(pm8001_ha, ccb_idx);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_ccb_task_free - free the sg for ssp and smp command, free =
the ccb.=0A=
+  * @pm8001_ha: our hba card information=0A=
+  * @ccb: the ccb which attached to ssp task=0A=
+  * @task: the task to be free.=0A=
+  * @ccb_idx: ccb index.=0A=
+  */=0A=
+void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)=0A=
+{=0A=
+	if (!ccb->task)=0A=
+		return;=0A=
+	if (!sas_protocol_ata(task->task_proto))=0A=
+		if (ccb->n_elem)=0A=
+			dma_unmap_sg(pm8001_ha->dev, task->scatter,=0A=
+				task->num_scatter, task->data_dir);=0A=
+=0A=
+	switch (task->task_proto) {=0A=
+	case SAS_PROTOCOL_SMP:=0A=
+		dma_unmap_sg(pm8001_ha->dev, &task->smp_task.smp_resp, 1,=0A=
+			PCI_DMA_FROMDEVICE);=0A=
+		dma_unmap_sg(pm8001_ha->dev, &task->smp_task.smp_req, 1,=0A=
+			PCI_DMA_TODEVICE);=0A=
+		break;=0A=
+=0A=
+	case SAS_PROTOCOL_SATA:=0A=
+	case SAS_PROTOCOL_STP:=0A=
+	case SAS_PROTOCOL_SSP:=0A=
+	default:=0A=
+		/* do nothing */=0A=
+		break;=0A=
+	}=0A=
+	task->lldd_task =3D NULL;=0A=
+	ccb->task =3D NULL;=0A=
+	ccb->ccb_tag =3D 0xFFFFFFFF;=0A=
+	pm8001_ccb_free(pm8001_ha, ccb_idx);=0A=
+}=0A=
+=0A=
+ /**=0A=
+  * pm8001_alloc_dev - find the empty pm8001_device structure, allocate =
and=0A=
+  * return it for use.=0A=
+  * @pm8001_ha: our hba card information=0A=
+  */=0A=
+struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info =
*pm8001_ha)=0A=
+{=0A=
+	u32 dev;=0A=
+	for (dev =3D 0; dev < PM8001_MAX_DEVICES; dev++) {=0A=
+		if (pm8001_ha->devices[dev].dev_type =3D=3D NO_DEVICE) {=0A=
+			pm8001_ha->devices[dev].id =3D dev;=0A=
+			return &pm8001_ha->devices[dev];=0A=
+		}=0A=
+	}=0A=
+	if (dev =3D=3D PM8001_MAX_DEVICES) {=0A=
+		PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("max support %d devices, ignore ..\n",=0A=
+			PM8001_MAX_DEVICES));=0A=
+	}=0A=
+	return NULL;=0A=
+}=0A=
+=0A=
+static void pm8001_free_dev(struct pm8001_device *pm8001_dev)=0A=
+{=0A=
+	u32 id =3D pm8001_dev->id;=0A=
+	memset(pm8001_dev, 0, sizeof(*pm8001_dev));=0A=
+	pm8001_dev->id =3D id;=0A=
+	pm8001_dev->dev_type =3D NO_DEVICE;=0A=
+	pm8001_dev->device_id =3D PM8001_MAX_DEVICES;=0A=
+	pm8001_dev->sas_device =3D NULL;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_dev_found_notify - when libsas find a sas domain device, it =
should=0A=
+  * tell the LLDD that device is found, and then LLDD register this =
device to=0A=
+  * HBA FW by the command "OPC_INB_REG_DEV", after that the HBA will =
assign=0A=
+  * a device ID(according to device's sas address) and returned it to =
LLDD.from=0A=
+  * now on, we communicate with HBA FW with the device ID which HBA =
assigned=0A=
+  * rather than sas address. it is the neccessary step for our HBA but =
it is=0A=
+  * the optional for other HBA driver.=0A=
+  * @dev: the device structure which sas layer used.=0A=
+  */=0A=
+static int pm8001_dev_found_notify(struct domain_device *dev)=0A=
+{=0A=
+	unsigned long flags =3D 0;=0A=
+	int res =3D 0;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D NULL;=0A=
+	struct domain_device *parent_dev =3D dev->parent;=0A=
+	struct pm8001_device *pm8001_device;=0A=
+	DECLARE_COMPLETION_ONSTACK(completion);=0A=
+	u32 flag =3D 0;=0A=
+	pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+	spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+=0A=
+	pm8001_device =3D pm8001_alloc_dev(pm8001_ha);=0A=
+	pm8001_device->sas_device =3D dev;=0A=
+	if (!pm8001_device) {=0A=
+		res =3D -1;=0A=
+		goto found_out;=0A=
+	}=0A=
+	dev->lldd_dev =3D pm8001_device;=0A=
+	pm8001_device->dev_type =3D dev->dev_type;=0A=
+	pm8001_device->dcompletion =3D &completion;=0A=
+	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {=0A=
+		int phy_id;=0A=
+		struct ex_phy *phy;=0A=
+		for (phy_id =3D 0; phy_id < parent_dev->ex_dev.num_phys;=0A=
+		phy_id++) {=0A=
+			phy =3D &parent_dev->ex_dev.ex_phy[phy_id];=0A=
+			if (SAS_ADDR(phy->attached_sas_addr)=0A=
+				=3D=3D SAS_ADDR(dev->sas_addr)) {=0A=
+				pm8001_device->attached_phy =3D phy_id;=0A=
+				break;=0A=
+			}=0A=
+		}=0A=
+		if (phy_id =3D=3D parent_dev->ex_dev.num_phys) {=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+			pm8001_printk("Error: no attached dev:%016llx"=0A=
+			" at ex:%016llx.\n", SAS_ADDR(dev->sas_addr),=0A=
+				SAS_ADDR(parent_dev->sas_addr)));=0A=
+			res =3D -1;=0A=
+		}=0A=
+	} else {=0A=
+		if (dev->dev_type =3D=3D SATA_DEV) {=0A=
+			pm8001_device->attached_phy =3D=0A=
+				dev->rphy->identify.phy_identifier;=0A=
+				flag =3D 1; /* directly sata*/=0A=
+		}=0A=
+	} /*register this device to HBA*/=0A=
+	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device \n"));=0A=
+	PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);=0A=
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+	wait_for_completion(&completion);=0A=
+	if (dev->dev_type =3D=3D SAS_END_DEV)=0A=
+		msleep(50);=0A=
+	pm8001_ha->flags =3D PM8001F_RUN_TIME ;=0A=
+	return 0;=0A=
+found_out:=0A=
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+	return res;=0A=
+}=0A=
+=0A=
+int pm8001_dev_found(struct domain_device *dev)=0A=
+{=0A=
+	return pm8001_dev_found_notify(dev);=0A=
+}=0A=
+=0A=
+=0A=
+=0A=
+/**=0A=
+  * pm8001_alloc_task - allocate a task structure for TMF=0A=
+  */=0A=
+static struct sas_task *pm8001_alloc_task(void)=0A=
+{=0A=
+	struct sas_task *task =3D kzalloc(sizeof(*task), GFP_KERNEL);=0A=
+	if (task) {=0A=
+		INIT_LIST_HEAD(&task->list);=0A=
+		spin_lock_init(&task->task_state_lock);=0A=
+		task->task_state_flags =3D SAS_TASK_STATE_PENDING;=0A=
+		init_timer(&task->timer);=0A=
+		init_completion(&task->completion);=0A=
+	}=0A=
+	return task;=0A=
+}=0A=
+=0A=
+static void pm8001_free_task(struct sas_task *task)=0A=
+{=0A=
+	if (task) {=0A=
+		BUG_ON(!list_empty(&task->list));=0A=
+		kfree(task);=0A=
+	}=0A=
+}=0A=
+=0A=
+static void pm8001_task_done(struct sas_task *task)=0A=
+{=0A=
+	if (!del_timer(&task->timer))=0A=
+		return;=0A=
+	complete(&task->completion);=0A=
+}=0A=
+=0A=
+static void pm8001_tmf_timedout(unsigned long data)=0A=
+{=0A=
+	struct sas_task *task =3D (struct sas_task *)data;=0A=
+=0A=
+	task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;=0A=
+	complete(&task->completion);=0A=
+}=0A=
+=0A=
+#define PM8001_TASK_TIMEOUT 20=0A=
+/**=0A=
+  * pm8001_exec_internal_tmf_task - when errors or exception happened, =
we may=0A=
+  * want to do something, for example abort issued task which result in =
this=0A=
+  * execption, this is by calling this function, note it is also with =
the task=0A=
+  * execute interface.=0A=
+  * @dev: the wanted device.=0A=
+  * @tmf: which task management wanted to be take.=0A=
+  * @para_len: para_len.=0A=
+  * @parameter: ssp task parameter.=0A=
+  */=0A=
+static int pm8001_exec_internal_tmf_task(struct domain_device *dev,=0A=
+	void *parameter, u32 para_len, struct pm8001_tmf_task *tmf)=0A=
+{=0A=
+	int res, retry;=0A=
+	struct sas_task *task =3D NULL;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+=0A=
+	for (retry =3D 0; retry < 3; retry++) {=0A=
+		task =3D pm8001_alloc_task();=0A=
+		if (!task)=0A=
+			return -ENOMEM;=0A=
+=0A=
+		task->dev =3D dev;=0A=
+		task->task_proto =3D dev->tproto;=0A=
+		memcpy(&task->ssp_task, parameter, para_len);=0A=
+		task->task_done =3D pm8001_task_done;=0A=
+		task->timer.data =3D (unsigned long)task;=0A=
+		task->timer.function =3D pm8001_tmf_timedout;=0A=
+		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT*HZ;=0A=
+		add_timer(&task->timer);=0A=
+=0A=
+		res =3D pm8001_task_exec(task, 1, GFP_KERNEL, 1, tmf);=0A=
+=0A=
+		if (res) {=0A=
+			del_timer(&task->timer);=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("Executing internal task "=0A=
+				"failed\n"));=0A=
+			goto ex_err;=0A=
+		}=0A=
+		wait_for_completion(&task->completion);=0A=
+		res =3D -TMF_RESP_FUNC_FAILED;=0A=
+		/* Even TMF timed out, return direct. */=0A=
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {=0A=
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {=0A=
+				PM8001_FAIL_DBG(pm8001_ha,=0A=
+					pm8001_printk("TMF task[%x]timeout.\n",=0A=
+					tmf->tmf));=0A=
+				goto ex_err;=0A=
+			}=0A=
+		}=0A=
+=0A=
+		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&=0A=
+			task->task_status.stat =3D=3D SAM_GOOD) {=0A=
+			res =3D TMF_RESP_FUNC_COMPLETE;=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&=0A=
+		task->task_status.stat =3D=3D SAS_DATA_UNDERRUN) {=0A=
+			/* no error, but return the number of bytes of=0A=
+			* underrun */=0A=
+			res =3D task->task_status.residual;=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&=0A=
+			task->task_status.stat =3D=3D SAS_DATA_OVERRUN) {=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("Blocked task error.\n"));=0A=
+			res =3D -EMSGSIZE;=0A=
+			break;=0A=
+		} else {=0A=
+			PM8001_IO_DBG(pm8001_ha,=0A=
+			pm8001_printk(" Task to dev %016llx response: 0x%x"=0A=
+				"status 0x%x\n",=0A=
+				SAS_ADDR(dev->sas_addr),=0A=
+				task->task_status.resp,=0A=
+				task->task_status.stat));=0A=
+			pm8001_free_task(task);=0A=
+			task =3D NULL;=0A=
+		}=0A=
+	}=0A=
+ex_err:=0A=
+	BUG_ON(retry =3D=3D 3 && task !=3D NULL);=0A=
+	if (task !=3D NULL)=0A=
+		pm8001_free_task(task);=0A=
+	return res;=0A=
+}=0A=
+=0A=
+static int=0A=
+pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct pm8001_device *pm8001_dev, struct domain_device *dev, u32 flag,=0A=
+	u32 task_tag)=0A=
+{=0A=
+	int res, retry;=0A=
+	u32 rc, ccb_tag;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct sas_task *task =3D NULL;=0A=
+=0A=
+	for (retry =3D 0; retry < 3; retry++) {=0A=
+		task =3D pm8001_alloc_task();=0A=
+		if (!task)=0A=
+			return -ENOMEM;=0A=
+=0A=
+		task->dev =3D dev;=0A=
+		task->task_proto =3D dev->tproto;=0A=
+		task->task_done =3D pm8001_task_done;=0A=
+		task->timer.data =3D (unsigned long)task;=0A=
+		task->timer.function =3D pm8001_tmf_timedout;=0A=
+		task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT*HZ;=0A=
+		add_timer(&task->timer);=0A=
+=0A=
+		rc =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);=0A=
+		if (rc)=0A=
+			return rc;=0A=
+		ccb =3D &pm8001_ha->ccb_info[ccb_tag];=0A=
+		ccb->device =3D pm8001_dev;=0A=
+		ccb->ccb_tag =3D ccb_tag;=0A=
+		ccb->task =3D task;=0A=
+=0A=
+		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,=0A=
+			pm8001_dev, flag, task_tag, ccb_tag);=0A=
+=0A=
+		if (res) {=0A=
+			del_timer(&task->timer);=0A=
+			PM8001_FAIL_DBG(pm8001_ha,=0A=
+				pm8001_printk("Executing internal task "=0A=
+				"failed\n"));=0A=
+			goto ex_err;=0A=
+		}=0A=
+		wait_for_completion(&task->completion);=0A=
+		res =3D TMF_RESP_FUNC_FAILED;=0A=
+		/* Even TMF timed out, return direct. */=0A=
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {=0A=
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {=0A=
+				PM8001_FAIL_DBG(pm8001_ha,=0A=
+					pm8001_printk("TMF task timeout.\n"));=0A=
+				goto ex_err;=0A=
+			}=0A=
+		}=0A=
+=0A=
+		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&=0A=
+			task->task_status.stat =3D=3D SAM_GOOD) {=0A=
+			res =3D TMF_RESP_FUNC_COMPLETE;=0A=
+			break;=0A=
+=0A=
+		} else {=0A=
+			PM8001_IO_DBG(pm8001_ha,=0A=
+				pm8001_printk(" Task to dev %016llx response: "=0A=
+					"0x%x status 0x%x\n",=0A=
+				SAS_ADDR(dev->sas_addr),=0A=
+				task->task_status.resp,=0A=
+				task->task_status.stat));=0A=
+			pm8001_free_task(task);=0A=
+			task =3D NULL;=0A=
+		}=0A=
+	}=0A=
+ex_err:=0A=
+	BUG_ON(retry =3D=3D 3 && task !=3D NULL);=0A=
+	if (task !=3D NULL)=0A=
+		pm8001_free_task(task);=0A=
+	return res;=0A=
+}=0A=
+=0A=
+/**=0A=
+  * pm8001_dev_gone_notify - see the comments for =
"pm8001_dev_found_notify"=0A=
+  * @dev: the device structure which sas layer used.=0A=
+  */=0A=
+static void pm8001_dev_gone_notify(struct domain_device *dev)=0A=
+{=0A=
+	unsigned long flags =3D 0;=0A=
+	u32 tag;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	u32 device_id =3D pm8001_dev->device_id;=0A=
+	pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+	spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+	pm8001_tag_alloc(pm8001_ha, &tag);=0A=
+	if (pm8001_dev) {=0A=
+		PM8001_DISC_DBG(pm8001_ha,=0A=
+			pm8001_printk("found dev[%d:%x] is gone.\n",=0A=
+			pm8001_dev->device_id, pm8001_dev->dev_type));=0A=
+		if (pm8001_dev->running_req) {=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,=0A=
+				dev, 1, 0);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+		}=0A=
+		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);=0A=
+		pm8001_free_dev(pm8001_dev);=0A=
+	} else {=0A=
+		PM8001_DISC_DBG(pm8001_ha,=0A=
+			pm8001_printk("Found dev has gone.\n"));=0A=
+	}=0A=
+	dev->lldd_dev =3D NULL;=0A=
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+}=0A=
+=0A=
+void pm8001_dev_gone(struct domain_device *dev)=0A=
+{=0A=
+	pm8001_dev_gone_notify(dev);=0A=
+}=0A=
+=0A=
+static int pm8001_issue_ssp_tmf(struct domain_device *dev,=0A=
+	u8 *lun, struct pm8001_tmf_task *tmf)=0A=
+{=0A=
+	struct sas_ssp_task ssp_task;=0A=
+	if (!(dev->tproto & SAS_PROTOCOL_SSP))=0A=
+		return TMF_RESP_FUNC_ESUPP;=0A=
+=0A=
+	strncpy((u8 *)&ssp_task.LUN, lun, 8);=0A=
+	return pm8001_exec_internal_tmf_task(dev, &ssp_task, sizeof(ssp_task),=0A=
+		tmf);=0A=
+}=0A=
+=0A=
+/**=0A=
+  * Standard mandates link reset for ATA  (type 0) and hard reset for=0A=
+  * SSP (type 1) , only for RECOVERY=0A=
+  */=0A=
+int pm8001_I_T_nexus_reset(struct domain_device *dev)=0A=
+{=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	struct sas_phy *phy;=0A=
+	if (!dev || !dev->lldd_dev)=0A=
+		return -1;=0A=
+=0A=
+	pm8001_dev =3D dev->lldd_dev;=0A=
+	pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+	phy =3D sas_find_local_phy(dev);=0A=
+=0A=
+	if (dev_is_sata(dev)) {=0A=
+		DECLARE_COMPLETION_ONSTACK(completion_setstate);=0A=
+		rc =3D sas_phy_reset(phy, 1);=0A=
+		msleep(2000);=0A=
+		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,=0A=
+			dev, 1, 0);=0A=
+		pm8001_dev->setds_completion =3D &completion_setstate;=0A=
+		rc =3D PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,=0A=
+			pm8001_dev, 0x01);=0A=
+		wait_for_completion(&completion_setstate);=0A=
+	} else{=0A=
+	rc =3D sas_phy_reset(phy, 1);=0A=
+	msleep(2000);=0A=
+	}=0A=
+	PM8001_EH_DBG(pm8001_ha, pm8001_printk(" for device[%x]:rc=3D%d\n",=0A=
+		pm8001_dev->device_id, rc));=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+=0A=
+/* mandatory SAM-3, the task reset the specified LUN*/=0A=
+int pm8001_lu_reset(struct domain_device *dev, u8 *lun)=0A=
+{=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+	if (dev_is_sata(dev)) {=0A=
+		struct sas_phy *phy =3D sas_find_local_phy(dev);=0A=
+		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,=0A=
+			dev, 1, 0);=0A=
+		rc =3D sas_phy_reset(phy, 1);=0A=
+		rc =3D PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,=0A=
+			pm8001_dev, 0x01);=0A=
+		msleep(2000);=0A=
+	} else {=0A=
+		tmf_task.tmf =3D TMF_LU_RESET;=0A=
+		rc =3D pm8001_issue_ssp_tmf(dev, lun, &tmf_task);=0A=
+	}=0A=
+	/* If failed, fall-through I_T_Nexus reset */=0A=
+	PM8001_EH_DBG(pm8001_ha, pm8001_printk("for device[%x]:rc=3D%d\n",=0A=
+		pm8001_dev->device_id, rc));=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/* optional SAM-3 */=0A=
+int pm8001_query_task(struct sas_task *task)=0A=
+{=0A=
+	u32 tag =3D 0xdeadbeef;=0A=
+	int i =3D 0;=0A=
+	struct scsi_lun lun;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	if (unlikely(!task || !task->lldd_task || !task->dev))=0A=
+		return rc;=0A=
+=0A=
+	if (task->task_proto & SAS_PROTOCOL_SSP) {=0A=
+		struct scsi_cmnd *cmnd =3D task->uldd_task;=0A=
+		struct domain_device *dev =3D task->dev;=0A=
+		struct pm8001_hba_info *pm8001_ha =3D=0A=
+			pm8001_find_ha_by_dev(dev);=0A=
+=0A=
+		int_to_scsilun(cmnd->device->lun, &lun);=0A=
+		rc =3D pm8001_find_tag(task, &tag);=0A=
+		if (rc =3D=3D 0) {=0A=
+			rc =3D TMF_RESP_FUNC_FAILED;=0A=
+			return rc;=0A=
+		}=0A=
+		PM8001_EH_DBG(pm8001_ha, pm8001_printk("Query:["));=0A=
+		for (i =3D 0; i < 16; i++)=0A=
+			printk(KERN_INFO "%02x ", cmnd->cmnd[i]);=0A=
+		printk(KERN_INFO "]\n");=0A=
+		tmf_task.tmf =3D 	TMF_QUERY_TASK;=0A=
+		tmf_task.tag_of_task_to_be_managed =3D tag;=0A=
+=0A=
+		rc =3D pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);=0A=
+		switch (rc) {=0A=
+		/* The task is still in Lun, release it then */=0A=
+		case TMF_RESP_FUNC_SUCC:=0A=
+			PM8001_EH_DBG(pm8001_ha,=0A=
+				pm8001_printk("The task is still in Lun \n"));=0A=
+		/* The task is not in Lun or failed, reset the phy */=0A=
+		case TMF_RESP_FUNC_FAILED:=0A=
+		case TMF_RESP_FUNC_COMPLETE:=0A=
+			PM8001_EH_DBG(pm8001_ha,=0A=
+			pm8001_printk("The task is not in Lun or failed,"=0A=
+			" reset the phy \n"));=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+	pm8001_printk(":rc=3D %d\n", rc);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+/*  mandatory SAM-3, still need free task/ccb info, abord the specified =
task */=0A=
+int pm8001_abort_task(struct sas_task *task)=0A=
+{=0A=
+	unsigned long flags;=0A=
+	u32 tag =3D 0xdeadbeef;=0A=
+	u32 device_id;=0A=
+	struct domain_device *dev ;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D NULL;=0A=
+	struct pm8001_ccb_info *ccb;=0A=
+	struct scsi_lun lun;=0A=
+	struct pm8001_device *pm8001_dev;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	if (unlikely(!task || !task->lldd_task || !task->dev))=0A=
+		return rc;=0A=
+	spin_lock_irqsave(&task->task_state_lock, flags);=0A=
+	if (task->task_state_flags & SAS_TASK_STATE_DONE) {=0A=
+		spin_unlock_irqrestore(&task->task_state_lock, flags);=0A=
+		rc =3D TMF_RESP_FUNC_COMPLETE;=0A=
+		goto out;=0A=
+	}=0A=
+	spin_unlock_irqrestore(&task->task_state_lock, flags);=0A=
+	if (task->task_proto & SAS_PROTOCOL_SSP) {=0A=
+		struct scsi_cmnd *cmnd =3D task->uldd_task;=0A=
+		dev =3D task->dev;=0A=
+		ccb =3D task->lldd_task;=0A=
+		pm8001_dev =3D dev->lldd_dev;=0A=
+		pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+		int_to_scsilun(cmnd->device->lun, &lun);=0A=
+		rc =3D pm8001_find_tag(task, &tag);=0A=
+		if (rc =3D=3D 0) {=0A=
+			printk(KERN_INFO "No such tag in %s\n", __func__);=0A=
+			rc =3D TMF_RESP_FUNC_FAILED;=0A=
+			return rc;=0A=
+		}=0A=
+		device_id =3D pm8001_dev->device_id;=0A=
+		PM8001_EH_DBG(pm8001_ha,=0A=
+		pm8001_printk("abort io to device_id =3D %d\n", device_id));=0A=
+		tmf_task.tmf =3D 	TMF_ABORT_TASK;=0A=
+		tmf_task.tag_of_task_to_be_managed =3D tag;=0A=
+		rc =3D pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);=0A=
+		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,=0A=
+			pm8001_dev->sas_device, 0, tag);=0A=
+	} else if (task->task_proto & SAS_PROTOCOL_SATA ||=0A=
+		task->task_proto & SAS_PROTOCOL_STP) {=0A=
+		dev =3D task->dev;=0A=
+		pm8001_dev =3D dev->lldd_dev;=0A=
+		pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+		rc =3D pm8001_find_tag(task, &tag);=0A=
+		if (rc =3D=3D 0) {=0A=
+			printk(KERN_INFO "No such tag in %s\n", __func__);=0A=
+			rc =3D TMF_RESP_FUNC_FAILED;=0A=
+			return rc;=0A=
+		}=0A=
+		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,=0A=
+			pm8001_dev->sas_device, 0, tag);=0A=
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {=0A=
+		/* SMP */=0A=
+		dev =3D task->dev;=0A=
+		pm8001_dev =3D dev->lldd_dev;=0A=
+		pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+		rc =3D pm8001_find_tag(task, &tag);=0A=
+		if (rc =3D=3D 0) {=0A=
+			printk(KERN_INFO "No such tag in %s\n", __func__);=0A=
+			rc =3D TMF_RESP_FUNC_FAILED;=0A=
+			return rc;=0A=
+		}=0A=
+		rc =3D pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,=0A=
+			pm8001_dev->sas_device, 0, tag);=0A=
+=0A=
+	}=0A=
+out:=0A=
+	if (rc !=3D TMF_RESP_FUNC_COMPLETE)=0A=
+		pm8001_printk("rc=3D %d\n", rc);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+int pm8001_abort_task_set(struct domain_device *dev, u8 *lun)=0A=
+{=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+=0A=
+	tmf_task.tmf =3D TMF_ABORT_TASK_SET;=0A=
+	rc =3D pm8001_issue_ssp_tmf(dev, lun, &tmf_task);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+int pm8001_clear_aca(struct domain_device *dev, u8 *lun)=0A=
+{=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+=0A=
+	tmf_task.tmf =3D TMF_CLEAR_ACA;=0A=
+	rc =3D pm8001_issue_ssp_tmf(dev, lun, &tmf_task);=0A=
+=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)=0A=
+{=0A=
+	int rc =3D TMF_RESP_FUNC_FAILED;=0A=
+	struct pm8001_tmf_task tmf_task;=0A=
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;=0A=
+	struct pm8001_hba_info *pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
+=0A=
+	PM8001_EH_DBG(pm8001_ha,=0A=
+		pm8001_printk("I_T_L_Q clear task set[%x]\n",=0A=
+		pm8001_dev->device_id));=0A=
+	tmf_task.tmf =3D TMF_CLEAR_TASK_SET;=0A=
+	rc =3D pm8001_issue_ssp_tmf(dev, lun, &tmf_task);=0A=
+	return rc;=0A=
+}=0A=
+=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.h =
b/drivers/scsi/pm8001/pm8001_sas.h=0A=
new file mode 100644=0A=
index 0000000..3cd8e6c=0A=
--- /dev/null=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.h=0A=
@@ -0,0 +1,487 @@=0A=
+/*=0A=
+ * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver=0A=
+ *=0A=
+ * Copyright (c) 2008-2009 USI Co., Ltd.=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * Redistribution and use in source and binary forms, with or without=0A=
+ * modification, are permitted provided that the following conditions=0A=
+ * are met:=0A=
+ * 1. Redistributions of source code must retain the above copyright=0A=
+ *    notice, this list of conditions, and the following disclaimer,=0A=
+ *    without modification.=0A=
+ * 2. Redistributions in binary form must reproduce at minimum a =
disclaimer=0A=
+ *    substantially similar to the "NO WARRANTY" disclaimer below=0A=
+ *    ("Disclaimer") and any redistribution must be conditioned upon=0A=
+ *    including a substantially similar Disclaimer requirement for =
further=0A=
+ *    binary redistribution.=0A=
+ * 3. Neither the names of the above-listed copyright holders nor the =
names=0A=
+ *    of any contributors may be used to endorse or promote products =
derived=0A=
+ *    from this software without specific prior written permission.=0A=
+ *=0A=
+ * Alternatively, this software may be distributed under the terms of =
the=0A=
+ * GNU General Public License ("GPL") version 2 as published by the Free=0A=
+ * Software Foundation.=0A=
+ *=0A=
+ * NO WARRANTY=0A=
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS=0A=
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT=0A=
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR=0A=
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT=0A=
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL=0A=
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS=0A=
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)=0A=
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,=0A=
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING=0A=
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE=0A=
+ * POSSIBILITY OF SUCH DAMAGES.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#ifndef _PM8001_SAS_H_=0A=
+#define _PM8001_SAS_H_=0A=
+=0A=
+#include <linux/kernel.h>=0A=
+#include <linux/module.h>=0A=
+#include <linux/spinlock.h>=0A=
+#include <linux/delay.h>=0A=
+#include <linux/types.h>=0A=
+#include <linux/ctype.h>=0A=
+#include <linux/dma-mapping.h>=0A=
+#include <linux/pci.h>=0A=
+#include <linux/interrupt.h>=0A=
+#include <linux/smp_lock.h>=0A=
+#include <scsi/libsas.h>=0A=
+#include <scsi/scsi_tcq.h>=0A=
+#include <scsi/sas_ata.h>=0A=
+#include <asm/atomic.h>=0A=
+#include "pm8001_defs.h"=0A=
+=0A=
+#define DRV_NAME		"pm8001"=0A=
+#define DRV_VERSION		"0.1.36"=0A=
+#define PM8001_FAIL_LOGGING	0x01 /* libsas EH function logging */=0A=
+#define PM8001_INIT_LOGGING	0x02 /* driver init logging */=0A=
+#define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */=0A=
+#define PM8001_IO_LOGGING	0x08 /* I/O path logging */=0A=
+#define PM8001_EH_LOGGING	0x10 /* Error message logging */=0A=
+#define PM8001_IOCTL_LOGGING	0x20 /* IOCTL message logging */=0A=
+#define PM8001_MSG_LOGGING	0x40 /* misc message logging */=0A=
+#define pm8001_printk(format, arg...)	printk(KERN_INFO "%s %d:" format,\=0A=
+				__func__, __LINE__, ## arg)=0A=
+#define PM8001_CHECK_LOGGING(HBA, LEVEL, CMD)	\=0A=
+do {						\=0A=
+	if (unlikely(HBA->logging_level & LEVEL))	\=0A=
+		do {					\=0A=
+			CMD;				\=0A=
+		} while (0);				\=0A=
+} while (0);=0A=
+=0A=
+#define PM8001_EH_DBG(HBA, CMD)			\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_EH_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_INIT_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_INIT_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_DISC_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_DISC_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_IO_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_IO_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_FAIL_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_FAIL_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_IOCTL_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_IOCTL_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_MSG_DBG(HBA, CMD)		\=0A=
+	PM8001_CHECK_LOGGING(HBA, PM8001_MSG_LOGGING, CMD)=0A=
+=0A=
+#define PM8001_DISABLE_NCQ=0A=
+#define PM8001_USE_TASKLET=0A=
+#define PM8001_USE_MSIX=0A=
+=0A=
+=0A=
+#define DEV_IS_EXPANDER(type)	((type =3D=3D EDGE_DEV) || (type =3D=3D =
FANOUT_DEV))=0A=
+=0A=
+#define PM8001_NAME_LENGTH		32/* generic length of strings */=0A=
+extern struct list_head hba_list;=0A=
+extern const struct pm8001_dispatch pm8001_8001_dispatch;=0A=
+=0A=
+struct pm8001_hba_info;=0A=
+struct pm8001_ccb_info;=0A=
+struct pm8001_device;=0A=
+struct pm8001_tmf_task;=0A=
+struct pm8001_dispatch {=0A=
+	char *name;=0A=
+	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);=0A=
+	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha, u32 signature);=0A=
+	void (*chip_rst)(struct pm8001_hba_info *pm8001_ha);=0A=
+	int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);=0A=
+	void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);=0A=
+	void (*isr)(struct pm8001_hba_info *pm8001_ha);=0A=
+	u32 (*is_our_interupt)(struct pm8001_hba_info *pm8001_ha);=0A=
+	int (*isr_process_oq)(struct pm8001_hba_info *pm8001_ha);=0A=
+	void (*interrupt_enable)(struct pm8001_hba_info *pm8001_ha);=0A=
+	void (*interrupt_disable)(struct pm8001_hba_info *pm8001_ha);=0A=
+	void (*make_prd)(struct scatterlist *scatter, int nr, void *prd);=0A=
+	int (*smp_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_ccb_info *ccb);=0A=
+	int (*ssp_io_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_ccb_info *ccb);=0A=
+	int (*sata_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_ccb_info *ccb);=0A=
+	int (*phy_start_req)(struct pm8001_hba_info *pm8001_ha,	u8 phy_id);=0A=
+	int (*phy_stop_req)(struct pm8001_hba_info *pm8001_ha, u8 phy_id);=0A=
+	int (*reg_dev_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_device *pm8001_dev, u32 flag);=0A=
+	int (*dereg_dev_req)(struct pm8001_hba_info *pm8001_ha, u32 device_id);=0A=
+	int (*phy_ctl_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		u32 phy_id, u32 phy_op);=0A=
+	int (*task_abort)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_device *pm8001_dev, u8 flag, u32 task_tag,=0A=
+		u32 cmd_tag);=0A=
+	int (*ssp_tm_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_ccb_info *ccb, struct pm8001_tmf_task *tmf);=0A=
+	int (*get_nvmd_req)(struct pm8001_hba_info *pm8001_ha, void *payload);=0A=
+	int (*set_nvmd_req)(struct pm8001_hba_info *pm8001_ha, void *payload);=0A=
+	int (*fw_flash_update_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		void *payload);=0A=
+	int (*set_dev_state_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		struct pm8001_device *pm8001_dev, u32 state);=0A=
+	int (*sas_diag_start_end_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		u32 state);=0A=
+	int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,=0A=
+		u32 state);=0A=
+};=0A=
+=0A=
+struct pm8001_chip_info {=0A=
+	u32	n_phy;=0A=
+	const struct pm8001_dispatch	*dispatch;=0A=
+};=0A=
+#define PM8001_CHIP_DISP	(pm8001_ha->chip->dispatch)=0A=
+=0A=
+struct pm8001_port {=0A=
+	struct asd_sas_port	sas_port;=0A=
+};=0A=
+=0A=
+struct pm8001_phy {=0A=
+	struct pm8001_hba_info	*pm8001_ha;=0A=
+	struct pm8001_port	*port;=0A=
+	struct asd_sas_phy	sas_phy;=0A=
+	struct sas_identify	identify;=0A=
+	struct scsi_device	*sdev;=0A=
+	u64			dev_sas_addr;=0A=
+	u32			phy_type;=0A=
+	struct completion	*enable_completion;=0A=
+	u32			frame_rcvd_size;=0A=
+	u8			frame_rcvd[32];=0A=
+	u8			phy_attached;=0A=
+	u8			phy_state;=0A=
+	enum sas_linkrate	minimum_linkrate;=0A=
+	enum sas_linkrate	maximum_linkrate;=0A=
+};=0A=
+=0A=
+struct pm8001_device {=0A=
+	enum sas_dev_type	dev_type;=0A=
+	struct domain_device	*sas_device;=0A=
+	u32			attached_phy;=0A=
+	u32			id;=0A=
+	struct completion	*dcompletion;=0A=
+	struct completion	*setds_completion;=0A=
+	u32			device_id;=0A=
+	u32			running_req;=0A=
+};=0A=
+=0A=
+struct pm8001_prd_imt {=0A=
+	__le32			len;=0A=
+	__le32			e;=0A=
+};=0A=
+=0A=
+struct pm8001_prd {=0A=
+	__le64			addr;		/* 64-bit buffer address */=0A=
+	struct pm8001_prd_imt	im_len;		/* 64-bit length */=0A=
+} __attribute__ ((packed));=0A=
+/*=0A=
+ * CCB(Command Control Block)=0A=
+ */=0A=
+struct pm8001_ccb_info {=0A=
+	struct list_head	entry;=0A=
+	struct sas_task		*task;=0A=
+	u32			n_elem;=0A=
+	u32			ccb_tag;=0A=
+	struct pm8001_device	*device;=0A=
+	struct pm8001_prd	buf_prd[PM8001_MAX_DMA_SG];=0A=
+	struct fw_control_ex	*fw_control_context;=0A=
+};=0A=
+=0A=
+struct mpi_mem {=0A=
+	/* Virtual pointer to the memory region */=0A=
+	void			*virt_ptr;=0A=
+	dma_addr_t		phys_addr;=0A=
+	/* Upper 32 bits of physical address */=0A=
+	u32			phys_addr_hi;=0A=
+	/* Lower 32 bits of physical address*/=0A=
+	u32			phys_addr_lo;=0A=
+	/* Total length in bytes allocated */=0A=
+	u32			total_len;=0A=
+	/* Number of elements */=0A=
+	u32			num_elements;=0A=
+	/* Size in bytes of an element */=0A=
+	u32			element_size;=0A=
+	u32			alignment;=0A=
+};=0A=
+=0A=
+struct mpi_mem_req {=0A=
+	/* The number of element in the  mpiMemory array */=0A=
+	u32			count;=0A=
+	/* The array of structures that define memroy regions*/=0A=
+	struct mpi_mem		region[USI_MAX_MEMCNT];=0A=
+};=0A=
+=0A=
+struct main_cfg_table {=0A=
+	u32			signature;=0A=
+	u32			interface_rev;=0A=
+	u32			firmware_rev;=0A=
+	u32			max_out_io;=0A=
+	u32			max_sgl;=0A=
+	u32			ctrl_cap_flag;=0A=
+	u32			gst_offset;=0A=
+	u32			inbound_queue_offset;=0A=
+	u32			outbound_queue_offset;=0A=
+	u32			inbound_q_nppd_hppd;=0A=
+	u32			outbound_hw_event_pid0_3;=0A=
+	u32			outbound_hw_event_pid4_7;=0A=
+	u32			outbound_ncq_event_pid0_3;=0A=
+	u32			outbound_ncq_event_pid4_7;=0A=
+	u32			outbound_tgt_ITNexus_event_pid0_3;=0A=
+	u32			outbound_tgt_ITNexus_event_pid4_7;=0A=
+	u32			outbound_tgt_ssp_event_pid0_3;=0A=
+	u32			outbound_tgt_ssp_event_pid4_7;=0A=
+	u32			outbound_tgt_smp_event_pid0_3;=0A=
+	u32			outbound_tgt_smp_event_pid4_7;=0A=
+	u32			upper_event_log_addr;=0A=
+	u32			lower_event_log_addr;=0A=
+	u32			event_log_size;=0A=
+	u32			event_log_option;=0A=
+	u32			upper_iop_event_log_addr;=0A=
+	u32			lower_iop_event_log_addr;=0A=
+	u32			iop_event_log_size;=0A=
+	u32			iop_event_log_option;=0A=
+	u32			fatal_err_interrupt;=0A=
+	u32			fatal_err_dump_offset0;=0A=
+	u32			fatal_err_dump_length0;=0A=
+	u32			fatal_err_dump_offset1;=0A=
+	u32			fatal_err_dump_length1;=0A=
+	u32			hda_mode_flag;=0A=
+	u32			anolog_setup_table_offset;=0A=
+};=0A=
+struct general_status_table {=0A=
+	u32			gst_len_mpistate;=0A=
+	u32			iq_freeze_state0;=0A=
+	u32			iq_freeze_state1;=0A=
+	u32			msgu_tcnt;=0A=
+	u32			iop_tcnt;=0A=
+	u32			reserved;=0A=
+	u32			phy_state[8];=0A=
+	u32			reserved1;=0A=
+	u32			reserved2;=0A=
+	u32			reserved3;=0A=
+	u32			recover_err_info[8];=0A=
+};=0A=
+struct inbound_queue_table {=0A=
+	u32			element_pri_size_cnt;=0A=
+	u32			upper_base_addr;=0A=
+	u32			lower_base_addr;=0A=
+	u32			ci_upper_base_addr;=0A=
+	u32			ci_lower_base_addr;=0A=
+	u32			pi_pci_bar;=0A=
+	u32			pi_offset;=0A=
+	u32			total_length;=0A=
+	void			*base_virt;=0A=
+	void			*ci_virt;=0A=
+	u32			reserved;=0A=
+	__le32			consumer_index;=0A=
+	u32			producer_idx;=0A=
+};=0A=
+struct outbound_queue_table {=0A=
+	u32			element_size_cnt;=0A=
+	u32			upper_base_addr;=0A=
+	u32			lower_base_addr;=0A=
+	void			*base_virt;=0A=
+	u32			pi_upper_base_addr;=0A=
+	u32			pi_lower_base_addr;=0A=
+	u32			ci_pci_bar;=0A=
+	u32			ci_offset;=0A=
+	u32			total_length;=0A=
+	void			*pi_virt;=0A=
+	u32			interrup_vec_cnt_delay;=0A=
+	u32			dinterrup_to_pci_offset;=0A=
+	__le32			producer_index;=0A=
+	u32			consumer_idx;=0A=
+};=0A=
+struct pm8001_hba_memspace {=0A=
+	void __iomem  		*memvirtaddr;=0A=
+	u64			membase;=0A=
+	u32			memsize;=0A=
+};=0A=
+struct pm8001_hba_info {=0A=
+	char			name[PM8001_NAME_LENGTH];=0A=
+	struct list_head	list;=0A=
+	unsigned long		flags;=0A=
+	spinlock_t		lock;/* host-wide lock */=0A=
+	struct pci_dev		*pdev;/* our device */=0A=
+	struct device		*dev;=0A=
+	struct pm8001_hba_memspace io_mem[6];=0A=
+	struct mpi_mem_req	memoryMap;=0A=
+	dma_addr_t		mur_addr;/*Message Unit Register Base Address*/=0A=
+	dma_addr_t		cfg_addr;/*Main Configuration Table Address*/=0A=
+	dma_addr_t		gst_addr;/*General Status Table Address*/=0A=
+	dma_addr_t		inb_addr;/*Inbound Queue Configuration Table=0A=
+	Addess*/=0A=
+	dma_addr_t		outb_addr;/*Outbound Queue Configuration Table=0A=
+	Address*/=0A=
+	struct main_cfg_table	cfg_data;=0A=
+	struct general_status_table	gst_data;=0A=
+	struct inbound_queue_table	inb_data[PM8001_MAX_INB_NUM];=0A=
+	struct outbound_queue_table	outb_data[PM8001_MAX_OUTB_NUM];=0A=
+	u8			sas_addr[SAS_ADDR_SIZE];=0A=
+	struct sas_ha_struct	*sas;/* SCSI/SAS glue */=0A=
+	struct Scsi_Host	*shost;=0A=
+	u32			chip_id;=0A=
+	const struct pm8001_chip_info	*chip;=0A=
+	struct completion	*nvmd_completion;=0A=
+	int			tags_num;=0A=
+	unsigned long		*tags;=0A=
+	struct pm8001_phy	phy[PM8001_MAX_PHYS];=0A=
+	struct pm8001_port	port[PM8001_MAX_PHYS];=0A=
+	u32			id;=0A=
+	u32			irq;=0A=
+	struct pm8001_device	*devices;=0A=
+	struct pm8001_ccb_info	*ccb_info;=0A=
+#ifdef PM8001_USE_MSIX=0A=
+	struct msix_entry	msix_entries[16];/*for msi-x interrupt*/=0A=
+	int			number_of_intr;/*will be used in remove()*/=0A=
+#endif=0A=
+#ifdef PM8001_USE_TASKLET=0A=
+	struct tasklet_struct	tasklet;=0A=
+#endif=0A=
+	struct list_head wq_list;=0A=
+	u32			logging_level;=0A=
+	u32			fw_status;=0A=
+	const struct firmware 	*fw_image;=0A=
+};=0A=
+=0A=
+struct pm8001_wq {=0A=
+	struct delayed_work work_q;=0A=
+	struct pm8001_hba_info *pm8001_ha;=0A=
+	void *data;=0A=
+	int handler;=0A=
+	struct list_head entry;=0A=
+};=0A=
+=0A=
+struct pm8001_fw_image_header {=0A=
+	u8 vender_id[8];=0A=
+	u8 product_id;=0A=
+	u8 hardware_rev;=0A=
+	u8 dest_partition;=0A=
+	u8 reserved;=0A=
+	u8 fw_rev[4];=0A=
+	__be32  image_length;=0A=
+	__be32 image_crc;=0A=
+	__be32 startup_entry;=0A=
+} __attribute__((packed, aligned(4)));=0A=
+=0A=
+/* define task management IU */=0A=
+struct pm8001_tmf_task {=0A=
+	u8			tmf;=0A=
+	u32			tag_of_task_to_be_managed;=0A=
+};=0A=
+/**=0A=
+ * FW Flash Update status values=0A=
+ */=0A=
+#define FLASH_UPDATE_COMPLETE_PENDING_REBOOT	0x00=0A=
+#define FLASH_UPDATE_IN_PROGRESS		0x01=0A=
+#define FLASH_UPDATE_HDR_ERR			0x02=0A=
+#define FLASH_UPDATE_OFFSET_ERR			0x03=0A=
+#define FLASH_UPDATE_CRC_ERR			0x04=0A=
+#define FLASH_UPDATE_LENGTH_ERR			0x05=0A=
+#define FLASH_UPDATE_HW_ERR			0x06=0A=
+#define FLASH_UPDATE_DNLD_NOT_SUPPORTED		0x10=0A=
+#define FLASH_UPDATE_DISABLED			0x11=0A=
+=0A=
+/**=0A=
+ * brief param structure for firmware flash update.=0A=
+ */=0A=
+struct fw_flash_updata_info {=0A=
+	u32			cur_image_offset;=0A=
+	u32			cur_image_len;=0A=
+	u32			total_image_len;=0A=
+	struct pm8001_prd	sgl;=0A=
+};=0A=
+=0A=
+struct fw_control_info {=0A=
+	u32			retcode;/*ret code (status)*/=0A=
+	u32			phase;/*ret code phase*/=0A=
+	u32			phaseCmplt;/*percent complete for the current=0A=
+	update phase */=0A=
+	u32			version;/*Hex encoded firmware version number*/=0A=
+	u32			offset;/*Used for downloading firmware	*/=0A=
+	u32			len; /*len of buffer*/=0A=
+	u32			size;/* Used in OS VPD and Trace get size=0A=
+	operations.*/=0A=
+	u32			reserved;/* padding required for 64 bit=0A=
+	alignment */=0A=
+	u8			buffer[1];/* Start of buffer */=0A=
+};=0A=
+struct fw_control_ex {=0A=
+	struct fw_control_info *fw_control;=0A=
+	void			*buffer;/* keep buffer pointer to be=0A=
+	freed when the responce comes*/=0A=
+	void			*virtAddr;/* keep virtual address of the data */=0A=
+	void			*usrAddr;/* keep virtual address of the=0A=
+	user data */=0A=
+	dma_addr_t		phys_addr;=0A=
+	u32			len; /* len of buffer  */=0A=
+	void			*payload; /* pointer to IOCTL Payload */=0A=
+	u8			inProgress;/*if 1 - the IOCTL request is in=0A=
+	progress */=0A=
+	void			*param1;=0A=
+	void			*param2;=0A=
+	void			*param3;=0A=
+};=0A=
+=0A=
+/******************** function prototype *********************/=0A=
+int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);=0A=
+void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);=0A=
+u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);=0A=
+void pm8001_ccb_free(struct pm8001_hba_info *pm8001_ha, u32 ccb_idx);=0A=
+void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,=0A=
+	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);=0A=
+int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,=0A=
+	void *funcdata);=0A=
+int pm8001_slave_alloc(struct scsi_device *scsi_dev);=0A=
+int pm8001_slave_configure(struct scsi_device *sdev);=0A=
+void pm8001_scan_start(struct Scsi_Host *shost);=0A=
+int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time);=0A=
+int pm8001_queue_command(struct sas_task *task, const int num,=0A=
+	gfp_t gfp_flags);=0A=
+int pm8001_abort_task(struct sas_task *task);=0A=
+int pm8001_abort_task_set(struct domain_device *dev, u8 *lun);=0A=
+int pm8001_clear_aca(struct domain_device *dev, u8 *lun);=0A=
+int pm8001_clear_task_set(struct domain_device *dev, u8 *lun);=0A=
+int pm8001_dev_found(struct domain_device *dev);=0A=
+void pm8001_dev_gone(struct domain_device *dev);=0A=
+int pm8001_lu_reset(struct domain_device *dev, u8 *lun);=0A=
+int pm8001_I_T_nexus_reset(struct domain_device *dev);=0A=
+int pm8001_query_task(struct sas_task *task);=0A=
+int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,=0A=
+	dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,=0A=
+	u32 mem_size, u32 align);=0A=
+=0A=
+=0A=
+/* ctl shared API */=0A=
+extern struct device_attribute *pm8001_host_attrs[];=0A=
+=0A=
+#endif=0A=
+=0A=
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h=0A=
index 73b46b6..14cebbc 100644=0A=
--- a/include/linux/pci_ids.h=0A=
+++ b/include/linux/pci_ids.h=0A=
@@ -1573,6 +1573,8 @@=0A=
 #define PCI_VENDOR_ID_COMPEX		0x11f6=0A=
 #define PCI_DEVICE_ID_COMPEX_ENET100VG4	0x0112=0A=
 =0A=
+#define PCI_VENDOR_ID_PMC_Sierra	0x11f8=0A=
+=0A=
 #define PCI_VENDOR_ID_RP		0x11fe=0A=
 #define PCI_DEVICE_ID_RP32INTF		0x0001=0A=
 #define PCI_DEVICE_ID_RP8INTF		0x0002=0A=

------=_NextPart_000_001C_01CA35F5.26FD8910--

