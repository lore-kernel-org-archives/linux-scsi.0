From: Ben Hutchings <ben@decadent.org.uk>
Subject: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
Date: Sat, 17 Dec 2011 17:14:28 +0000
Message-ID: <1324142068.2825.341.camel@deadeye>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R5NqGi9cunRJXfPv9ksw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--=-R5NqGi9cunRJXfPv9ksw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

isci requires a parameter blob which is usually found in NVRAM, but it
can fall back to loading with request_firmware().  These files are
taken from the Linux source tree where they were wrongly added in
Linux 3.0.
---
I'm a bit unclear on the purpose and use of isci_firmware.bin.  Is it
needed for production hardware?  Does it need to be customised
per-system, or are module parameters sufficient for that?  (If not, why
isn't it built into the driver?)

probe_roms.h is labelled with a dual BSD/GPLv2 licence but the other
files had no licence header so I've treated them as GPLv2 by default.

Ben.

 WHENCE                 |   12 +++
 isci/Makefile          |   23 +++++
 isci/README            |   36 +++++++
 isci/create_fw.c       |   98 +++++++++++++++++++
 isci/create_fw.h       |   77 +++++++++++++++
 isci/isci_firmware.bin |  Bin 0 -> 232 bytes
 isci/probe_roms.h      |  249 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 7 files changed, 495 insertions(+), 0 deletions(-)
 create mode 100644 isci/Makefile
 create mode 100644 isci/README
 create mode 100644 isci/create_fw.c
 create mode 100644 isci/create_fw.h
 create mode 100644 isci/isci_firmware.bin
 create mode 100644 isci/probe_roms.h

diff --git a/WHENCE b/WHENCE
index dfeac71..c40a3f2 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1844,3 +1844,15 @@ File: ene-ub6250/ms_rdwr.bin
 Licence: Redistributable. See LICENCE.ene_firmware for details.
=20
 --------------------------------------------------------------------------
+
+Driver: isci -- Intel C600 SAS controller driver
+
+File: isci/isci_firmware.bin
+Source: isci/create_fw.c
+Source: isci/create_fw.h
+Source: isci/probe_roms.h
+Source: isci/Makefile
+
+Licence: GPLv2
+
+--------------------------------------------------------------------------
diff --git a/isci/Makefile b/isci/Makefile
new file mode 100644
index 0000000..3849373
--- /dev/null
+++ b/isci/Makefile
@@ -0,0 +1,23 @@
+# Makefile for create_fw
+#
+CC=3Dgcc
+CFLAGS=3D-c -Wall -O2 -g
+LDFLAGS=3D
+SOURCES=3Dcreate_fw.c
+OBJECTS=3D$(SOURCES:.cpp=3D.o)
+EXECUTABLE=3Dcreate_fw
+BLOB=3Disci_firmware.bin
+
+all: $(SOURCES) $(EXECUTABLE) $(BLOB)
+
+$(EXECUTABLE): $(OBJECTS)
+	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
+
+.c.o:
+	$(CC) $(CFLAGS) $< -O $@
+
+$(BLOB): $(EXECUTABLE)
+	./$(EXECUTABLE) >$@
+
+clean:
+	rm -f *.o $(EXECUTABLE)
diff --git a/isci/README b/isci/README
new file mode 100644
index 0000000..8056d2b
--- /dev/null
+++ b/isci/README
@@ -0,0 +1,36 @@
+This defines the temporary binary blow we are to pass to the SCU
+driver to emulate the binary firmware that we will eventually be
+able to access via NVRAM on the SCU controller.
+
+The current size of the binary blob is expected to be 149 bytes or larger
+
+Header Types:
+0x1: Phy Masks
+0x2: Phy Gens
+0x3: SAS Addrs
+0xff: End of Data
+
+ID string - u8[12]: "#SCU MAGIC#\0"
+Version - u8: 1
+SubVersion - u8: 0
+
+Header Type - u8: 0x1
+Size - u8: 8
+Phy Mask - u32[8]
+
+Header Type - u8: 0x2
+Size - u8: 8
+Phy Gen - u32[8]
+
+Header Type - u8: 0x3
+Size - u8: 8
+Sas Addr - u64[8]
+
+Header Type - u8: 0xf
+
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+Place isci_firmware.bin in /lib/firmware
+Be sure to recreate the initramfs image to include the firmware.
+
diff --git a/isci/create_fw.c b/isci/create_fw.c
new file mode 100644
index 0000000..0ad30d8
--- /dev/null
+++ b/isci/create_fw.c
@@ -0,0 +1,98 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <errno.h>
+#include <asm/types.h>
+#include <strings.h>
+#include <stdint.h>
+
+#include "create_fw.h"
+
+int write_blob(struct isci_orom *isci_orom)
+{
+	FILE *fd;
+	int err;
+	size_t count;
+
+	fd =3D fopen(blob_name, "w+");
+	if (!fd) {
+		perror("Open file for write failed");
+		fclose(fd);
+		return -EIO;
+	}
+
+	count =3D fwrite(isci_orom, sizeof(struct isci_orom), 1, fd);
+	if (count !=3D 1) {
+		perror("Write data failed");
+		fclose(fd);
+		return -EIO;
+	}
+
+	fclose(fd);
+
+	return 0;
+}
+
+void set_binary_values(struct isci_orom *isci_orom)
+{
+	int ctrl_idx, phy_idx, port_idx;
+
+	/* setting OROM signature */
+	strncpy(isci_orom->hdr.signature, sig, strlen(sig));
+	isci_orom->hdr.version =3D version;
+	isci_orom->hdr.total_block_length =3D sizeof(struct isci_orom);
+	isci_orom->hdr.hdr_length =3D sizeof(struct sci_bios_oem_param_block_hdr)=
;
+	isci_orom->hdr.num_elements =3D num_elements;
+
+	for (ctrl_idx =3D 0; ctrl_idx < 2; ctrl_idx++) {
+		isci_orom->ctrl[ctrl_idx].controller.mode_type =3D mode_type;
+		isci_orom->ctrl[ctrl_idx].controller.max_concurr_spin_up =3D
+			max_num_concurrent_dev_spin_up;
+		isci_orom->ctrl[ctrl_idx].controller.do_enable_ssc =3D
+			enable_ssc;
+
+		for (port_idx =3D 0; port_idx < 4; port_idx++)
+			isci_orom->ctrl[ctrl_idx].ports[port_idx].phy_mask =3D
+				phy_mask[ctrl_idx][port_idx];
+
+		for (phy_idx =3D 0; phy_idx < 4; phy_idx++) {
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].sas_address.high =3D
+				(__u32)(sas_addr[ctrl_idx][phy_idx] >> 32);
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].sas_address.low =3D
+				(__u32)(sas_addr[ctrl_idx][phy_idx]);
+
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control0 =3D
+				afe_tx_amp_control0;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control1 =3D
+				afe_tx_amp_control1;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control2 =3D
+				afe_tx_amp_control2;
+			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control3 =3D
+				afe_tx_amp_control3;
+		}
+	}
+}
+
+int main(void)
+{
+	int err;
+	struct isci_orom *isci_orom;
+
+	isci_orom =3D malloc(sizeof(struct isci_orom));
+	memset(isci_orom, 0, sizeof(struct isci_orom));
+
+	set_binary_values(isci_orom);
+
+	err =3D write_blob(isci_orom);
+	if (err < 0) {
+		free(isci_orom);
+		return err;
+	}
+
+	free(isci_orom);
+	return 0;
+}
diff --git a/isci/create_fw.h b/isci/create_fw.h
new file mode 100644
index 0000000..78c3ea7
--- /dev/null
+++ b/isci/create_fw.h
@@ -0,0 +1,77 @@
+#ifndef _CREATE_FW_H_
+#define _CREATE_FW_H_
+#include "probe_roms.h"
+
+
+/* we are configuring for 2 SCUs */
+static const int num_elements =3D 2;
+
+/*
+ * For all defined arrays:
+ * elements 0-3 are for SCU0, ports 0-3
+ * elements 4-7 are for SCU1, ports 0-3
+ *
+ * valid configurations for one SCU are:
+ *  P0  P1  P2  P3
+ * ----------------
+ * 0xF,0x0,0x0,0x0 # 1 x4 port
+ * 0x3,0x0,0x4,0x8 # Phys 0 and 1 are a x2 port, phy 2 and phy 3 are each =
x1
+ *                 # ports
+ * 0x1,0x2,0xC,0x0 # Phys 0 and 1 are each x1 ports, phy 2 and phy 3 are a=
 x2
+ *                 # port
+ * 0x3,0x0,0xC,0x0 # Phys 0 and 1 are a x2 port, phy 2 and phy 3 are a x2 =
port
+ * 0x1,0x2,0x4,0x8 # Each phy is a x1 port (this is the default configurat=
ion)
+ *
+ * if there is a port/phy on which you do not wish to override the default
+ * values, use the value assigned to UNINIT_PARAM (255).
+ */
+
+/* discovery mode type (port auto config mode by default ) */
+
+/*
+ * if there is a port/phy on which you do not wish to override the default
+ * values, use the value "0000000000000000". SAS address of zero's is
+ * considered invalid and will not be used.
+ */
+#ifdef MPC
+static const int mode_type =3D SCIC_PORT_MANUAL_CONFIGURATION_MODE;
+static const __u8 phy_mask[2][4] =3D { {1, 2, 4, 8},
+				     {1, 2, 4, 8} };
+static const unsigned long long sas_addr[2][4] =3D { { 0x5FCFFFFFF0000001U=
LL,
+						     0x5FCFFFFFF0000002ULL,
+						     0x5FCFFFFFF0000003ULL,
+						     0x5FCFFFFFF0000004ULL },
+						   { 0x5FCFFFFFF0000005ULL,
+						     0x5FCFFFFFF0000006ULL,
+						     0x5FCFFFFFF0000007ULL,
+						     0x5FCFFFFFF0000008ULL } };
+#else	/* APC (default) */
+static const int mode_type =3D SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE;
+static const __u8 phy_mask[2][4];
+static const unsigned long long sas_addr[2][4] =3D { { 0x5FCFFFFF00000001U=
LL,
+						     0x5FCFFFFF00000001ULL,
+						     0x5FCFFFFF00000001ULL,
+						     0x5FCFFFFF00000001ULL },
+						   { 0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL,
+						     0x5FCFFFFF00000002ULL } };
+#endif
+
+/* Maximum number of concurrent device spin up */
+static const int max_num_concurrent_dev_spin_up =3D 1;
+
+/* enable of ssc operation */
+static const int enable_ssc;
+
+/* AFE_TX_AMP_CONTROL */
+static const unsigned int afe_tx_amp_control0 =3D 0x000bdd08;
+static const unsigned int afe_tx_amp_control1 =3D 0x000ffc00;
+static const unsigned int afe_tx_amp_control2 =3D 0x000b7c09;
+static const unsigned int afe_tx_amp_control3 =3D 0x000afc6e;
+
+static const char blob_name[] =3D "isci_firmware.bin";
+static const char sig[] =3D "ISCUOEMB";
+static const unsigned char version =3D 0x10;
+
+#endif
diff --git a/isci/isci_firmware.bin b/isci/isci_firmware.bin
new file mode 100644
index 0000000000000000000000000000000000000000..963b3793ebdfef3a311f4aaf1b2=
75ac0e221874c
GIT binary patch
literal 232
zcmeYab`JG-^>uo|AR)lO!~h43j1cDk|L5aDOpd$U3=3DDtx88~aW8S?&cF;Gh!*&dMf
J*zBQ(H~<;hJkkIF

literal 0
HcmV?d00001

diff --git a/isci/probe_roms.h b/isci/probe_roms.h
new file mode 100644
index 0000000..2c75248
--- /dev/null
+++ b/isci/probe_roms.h
@@ -0,0 +1,249 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 U=
SA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#ifndef _ISCI_PROBE_ROMS_H_
+#define _ISCI_PROBE_ROMS_H_
+
+#ifdef __KERNEL__
+#include <linux/firmware.h>
+#include <linux/pci.h>
+#include <linux/efi.h>
+#include "isci.h"
+
+#define SCIC_SDS_PARM_NO_SPEED   0
+
+/* generation 1 (i.e. 1.5 Gb/s) */
+#define SCIC_SDS_PARM_GEN1_SPEED 1
+
+/* generation 2 (i.e. 3.0 Gb/s) */
+#define SCIC_SDS_PARM_GEN2_SPEED 2
+
+/* generation 3 (i.e. 6.0 Gb/s) */
+#define SCIC_SDS_PARM_GEN3_SPEED 3
+#define SCIC_SDS_PARM_MAX_SPEED SCIC_SDS_PARM_GEN3_SPEED
+
+/* parameters that can be set by module parameters */
+struct sci_user_parameters {
+	struct sci_phy_user_params {
+		/**
+		 * This field specifies the NOTIFY (ENABLE SPIN UP) primitive
+		 * insertion frequency for this phy index.
+		 */
+		u32 notify_enable_spin_up_insertion_frequency;
+
+		/**
+		 * This method specifies the number of transmitted DWORDs within which
+		 * to transmit a single ALIGN primitive.  This value applies regardless
+		 * of what type of device is attached or connection state.  A value of
+		 * 0 indicates that no ALIGN primitives will be inserted.
+		 */
+		u16 align_insertion_frequency;
+
+		/**
+		 * This method specifies the number of transmitted DWORDs within which
+		 * to transmit 2 ALIGN primitives.  This applies for SAS connections
+		 * only.  A minimum value of 3 is required for this field.
+		 */
+		u16 in_connection_align_insertion_frequency;
+
+		/**
+		 * This field indicates the maximum speed generation to be utilized
+		 * by phys in the supplied port.
+		 * - A value of 1 indicates generation 1 (i.e. 1.5 Gb/s).
+		 * - A value of 2 indicates generation 2 (i.e. 3.0 Gb/s).
+		 * - A value of 3 indicates generation 3 (i.e. 6.0 Gb/s).
+		 */
+		u8 max_speed_generation;
+
+	} phys[SCI_MAX_PHYS];
+
+	/**
+	 * This field specifies the maximum number of direct attached devices
+	 * that can have power supplied to them simultaneously.
+	 */
+	u8 max_concurr_spinup;
+
+	/**
+	 * This field specifies the number of seconds to allow a phy to consume
+	 * power before yielding to another phy.
+	 *
+	 */
+	u8 phy_spin_up_delay_interval;
+
+	/**
+	 * These timer values specifies how long a link will remain open with no
+	 * activity in increments of a microsecond, it can be in increments of
+	 * 100 microseconds if the upper most bit is set.
+	 *
+	 */
+	u16 stp_inactivity_timeout;
+	u16 ssp_inactivity_timeout;
+
+	/**
+	 * These timer values specifies how long a link will remain open in incre=
ments
+	 * of 100 microseconds.
+	 *
+	 */
+	u16 stp_max_occupancy_timeout;
+	u16 ssp_max_occupancy_timeout;
+
+	/**
+	 * This timer value specifies how long a link will remain open with no
+	 * outbound traffic in increments of a microsecond.
+	 *
+	 */
+	u8 no_outbound_task_timeout;
+
+};
+
+#define SCIC_SDS_PARM_PHY_MASK_MIN 0x0
+#define SCIC_SDS_PARM_PHY_MASK_MAX 0xF
+#define MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT 4
+
+struct sci_oem_params;
+int sci_oem_parameters_validate(struct sci_oem_params *oem);
+
+struct isci_orom;
+struct isci_orom *isci_request_oprom(struct pci_dev *pdev);
+enum sci_status isci_parse_oem_parameters(struct sci_oem_params *oem,
+					  struct isci_orom *orom, int scu_index);
+struct isci_orom *isci_request_firmware(struct pci_dev *pdev, const struct=
 firmware *fw);
+struct isci_orom *isci_get_efi_var(struct pci_dev *pdev);
+
+struct isci_oem_hdr {
+	u8 sig[4];
+	u8 rev_major;
+	u8 rev_minor;
+	u16 len;
+	u8 checksum;
+	u8 reserved1;
+	u16 reserved2;
+} __attribute__ ((packed));
+
+#else
+#define SCI_MAX_PORTS 4
+#define SCI_MAX_PHYS 4
+#define SCI_MAX_CONTROLLERS 2
+#endif
+
+#define ISCI_FW_NAME		"isci/isci_firmware.bin"
+
+#define ROMSIGNATURE		0xaa55
+
+#define ISCI_OEM_SIG		"$OEM"
+#define ISCI_OEM_SIG_SIZE	4
+#define ISCI_ROM_SIG		"ISCUOEMB"
+#define ISCI_ROM_SIG_SIZE	8
+
+#define ISCI_EFI_VENDOR_GUID	\
+	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, \
+			0x1a, 0x04, 0xc6)
+#define ISCI_EFI_VAR_NAME	"RstScuO"
+
+/* Allowed PORT configuration modes APC Automatic PORT configuration mode =
is
+ * defined by the OEM configuration parameters providing no PHY_MASK param=
eters
+ * for any PORT. i.e. There are no phys assigned to any of the ports at st=
art.
+ * MPC Manual PORT configuration mode is defined by the OEM configuration
+ * parameters providing a PHY_MASK value for any PORT.  It is assumed that=
 any
+ * PORT with no PHY_MASK is an invalid port and not all PHYs must be assig=
ned.
+ * A PORT_PHY mask that assigns just a single PHY to a port and no other P=
HYs
+ * being assigned is sufficient to declare manual PORT configuration.
+ */
+enum sci_port_configuration_mode {
+	SCIC_PORT_MANUAL_CONFIGURATION_MODE =3D 0,
+	SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE =3D 1
+};
+
+struct sci_bios_oem_param_block_hdr {
+	uint8_t signature[ISCI_ROM_SIG_SIZE];
+	uint16_t total_block_length;
+	uint8_t hdr_length;
+	uint8_t version;
+	uint8_t preboot_source;
+	uint8_t num_elements;
+	uint16_t element_length;
+	uint8_t reserved[8];
+} __attribute__ ((packed));
+
+struct sci_oem_params {
+	struct {
+		uint8_t mode_type;
+		uint8_t max_concurr_spin_up;
+		uint8_t do_enable_ssc;
+		uint8_t reserved;
+	} controller;
+
+	struct {
+		uint8_t phy_mask;
+	} ports[SCI_MAX_PORTS];
+
+	struct sci_phy_oem_params {
+		struct {
+			uint32_t high;
+			uint32_t low;
+		} sas_address;
+
+		uint32_t afe_tx_amp_control0;
+		uint32_t afe_tx_amp_control1;
+		uint32_t afe_tx_amp_control2;
+		uint32_t afe_tx_amp_control3;
+	} phys[SCI_MAX_PHYS];
+} __attribute__ ((packed));
+
+struct isci_orom {
+	struct sci_bios_oem_param_block_hdr hdr;
+	struct sci_oem_params ctrl[SCI_MAX_CONTROLLERS];
+} __attribute__ ((packed));
+
+#endif
--=20
1.7.7.3



--=-R5NqGi9cunRJXfPv9ksw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuzN9Oe/yOyVhhEJAQoPARAAmjafDKdj8IrCdYS0zQdZFU56jskk1OT1
InqxRTTNTQkgle974feL2pILbZJ4GUqo1SZzsnVhTlvgmvJPqs4pNxUNzCrKcYae
fvUUyL5TSIQeMpBY7LTeQFs4BIx8K1IOwyOaySUZZKnh7pbqmaJf3YSbnISPFe0h
HYtR3rWYzjB/k4AN0+0XywvC23h5xzORwb/mYMkcvthdlQVNx4yUgUbkyMzXgCaS
JJHlYmMUGuKxbrGP9vBkJPmcpbtxEwWfajYc4CBwTYfFrHvphzfyw/Y+TEt4E2YV
4jS5epvstDV2+KH9qnWpl1acmUC593T931Wa5ci1LMmCDRnKZnrYM42o1naGlISP
HY3cBzSTvci8f4/8IJx8DFM5upzEpLx3ZBHajJHFw5wJ5N7Rxhzj3zd/KvL9S5Ga
AtCcRQMqQJLSCoes7DaNfUyeUN2ghIrFha6q/pTm2XOrv4CF3eSFQSsYAOj+Z4n7
5Y92vG6COXckVgpaEtV0otR7pamhaQLoiiK9NFddAdaM/a4H8GZFBEFAiYepCcu2
A70KztO0LVIAR44NmdkkAqRCuOchO7ZKb9can9sy44LPZfNdEwU+UidyyPGRHAdH
zcMNrFAWyAT5yyXefgKH+jubTYoLJGFGbPF6z/4ksRdoUa49rfMsZaScYUyOaWHY
0qGPKwKU3ew=
=pUrO
-----END PGP SIGNATURE-----

--=-R5NqGi9cunRJXfPv9ksw--
