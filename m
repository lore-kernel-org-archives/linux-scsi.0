From: Matthew Wilcox <willy@debian.org>
Subject: sym2 2.1.18k
Date: Mon, 13 Sep 2004 20:48:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20908 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268890AbUIMTsE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 15:48:04 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C6wnz-0000Ue-LT
	for linux-scsi@vger.kernel.org; Mon, 13 Sep 2004 20:48:03 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


2.1.18k:
 - Relicence from dual BSD/GPL to pure GPL
 - Add my copyright to various files
 - Remove unnecessary MDELAY calls after printfs
 - Rename remaining MDELAY() to mdelay(), delete MDELAY and sym_mdelay
   macros
 - Restructure PCI initialisation to not disable chips that are part
   of Mylex RAID cards.
 - Make SYM_OPT_NVRAM_PRE_READ non-optional.

diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Mon Sep 13 10:02:10 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Mon Sep 13 09:10:31 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM53C8XX_H
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h	Mon Sep 13 10:02:10 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h	Mon Sep 13 09:10:31 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_CONF_H
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Mon Sep 13 09:17:44 2004
@@ -22,38 +22,25 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.1.18j"
+#define SYM_VERSION "2.1.18k"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	Mon Sep 13 09:10:31 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifdef __FreeBSD__
@@ -411,7 +398,6 @@ void sym_fw_bind_script(struct sym_hcb *
 		if (opcode == 0) {
 			printf ("%s: ERROR0 IN SCRIPT at %d.\n",
 				sym_name(np), (int) (cur-start));
-			MDELAY (10000);
 			++cur;
 			continue;
 		};
@@ -455,7 +441,6 @@ void sym_fw_bind_script(struct sym_hcb *
 			if ((tmp1 ^ tmp2) & 3) {
 				printf ("%s: ERROR1 IN SCRIPT at %d.\n",
 					sym_name(np), (int) (cur-start));
-				MDELAY (10000);
 			}
 			/*
 			 *  If PREFETCH feature not enabled, remove 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h	Mon Sep 13 09:10:31 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef	SYM_FW_H
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h	Mon Sep 13 09:10:31 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /*
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h	Mon Sep 13 09:10:32 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 /*
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Sep 13 12:36:39 2004
@@ -3,6 +3,7 @@
  * of PCI-SCSI IO processors.
  *
  * Copyright (C) 1999-2001  Gerard Roudier <groudier@free.fr>
+ * Copyright (c) 2003-2004  Matthew Wilcox <matthew@wil.cx>
  *
  * This driver is derived from the Linux sym53c8xx driver.
  * Copyright (C) 1998-2000  Gerard Roudier
@@ -22,32 +23,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #define SYM_GLUE_C
 
@@ -573,7 +561,6 @@ int sym_setup_data_and_start(struct sym_
 	switch (cp->cdb_buf[0]) {
 	case 0x0A: case 0x2A: case 0xAA:
 		panic("XXXXXXXXXXXXX WRITE NOT YET ALLOWED XXXXXXXXXXXXXX\n");
-		MDELAY(10000);
 		break;
 	default:
 		break;
@@ -1979,39 +1966,14 @@ int __init sym53c8xx_setup(char *str)
 __setup("sym53c8xx=", sym53c8xx_setup);
 #endif
 
-/*
- *  Read and check the PCI configuration for any detected NCR 
- *  boards and save data for attaching after all boards have 
- *  been detected.
- */
-static int __devinit
-sym53c8xx_pci_init(struct pci_dev *pdev, struct sym_device *device)
+static int __devinit sym_check_supported(struct sym_device *device)
 {
 	struct sym_pci_chip *chip;
-	u_long base, base_2; 
-	u_long base_c, base_2_c, io_port; 
-	int i;
-	u_short device_id, status_reg;
+	struct pci_dev *pdev = device->pdev;
 	u_char revision;
-
-	/* Choose some short name for this device */
-	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
-
-	device_id = pdev->device;
-
-	io_port = pdev->resource[0].start;
-
-	base_c = pdev->resource[1].start;
-	i = pci_get_base_address(pdev, 1, &base);
-
-	base_2_c = pdev->resource[i].start;
-	pci_get_base_address(pdev, i, &base_2);
-
-	base	&= PCI_BASE_ADDRESS_MEM_MASK;
-	base_2	&= PCI_BASE_ADDRESS_MEM_MASK;
-
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+	unsigned long io_port = device->s.io_port;
+	unsigned long base = device->s.base;
+	int i;
 
 	/*
 	 *  If user excluded this chip, do not initialize it.
@@ -2019,20 +1981,11 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	if (io_port) {
 		for (i = 0 ; i < 8 ; i++) {
 			if (sym_driver_setup.excludes[i] == io_port)
-				return -1;
+				return -ENODEV;
 		}
 	}
 
 	/*
-	 *  Check if the chip is supported.
-	 */
-	chip = sym_lookup_pci_chip_table(device_id, revision);
-	if (!chip) {
-		printf_info("%s: device not supported\n", sym_name(device));
-		return -1;
-	}
-
-	/*
 	 *  Check if the chip has been assigned resources we need.
 	 *  XXX: can this still happen with Linux 2.6's PCI layer?
 	 */
@@ -2040,66 +1993,84 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	if (!io_port) {
 		printf_info("%s: IO base address disabled.\n",
 			    sym_name(device));
-		return -1;
+		return -ENODEV;
 	}
 #else
 	if (!base) {
 		printf_info("%s: MMIO base address disabled.\n",
 			    sym_name(device));
-		return -1;
+		return -ENODEV;
 	}
 #endif
 
 	/*
-	 *  Ignore Symbios chips controlled by various RAID controllers.
-	 *  These controllers set value 0x52414944 at RAM end - 16.
+	 * Check if the chip is supported.  Then copy the chip description
+	 * to our device structure so we can make it match the actual device
+	 * and options.
 	 */
-#if defined(__i386__)
-	if (base_2_c) {
-		unsigned int ram_size, ram_val;
-		void *ram_ptr;
-
-		if (chip->features & FE_RAM8K)
-			ram_size = 8192;
-		else
-			ram_size = 4096;
-
-		ram_ptr = ioremap(base_2_c, ram_size);
-		if (ram_ptr) {
-			ram_val = readl_raw(ram_ptr + ram_size - 16);
-			iounmap(ram_ptr);
-			if (ram_val == 0x52414944) {
-				printf_info("%s: not initializing, "
-					    "driven by RAID controller.\n",
-					    sym_name(device));
-				return -1;
-			}
-		}
+	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+	chip = sym_lookup_pci_chip_table(pdev->device, revision);
+	if (!chip) {
+		printf_info("%s: device not supported\n", sym_name(device));
+		return -ENODEV;
 	}
-#endif /* i386 and PCI MEMORY accessible */
-
-	/*
-	 *  Copy the chip description to our device structure, 
-	 *  so we can make it match the actual device and options.
-	 */
 	memcpy(&device->chip, chip, sizeof(device->chip));
 	device->chip.revision_id = revision;
 
+	return 0;
+}
+
+/*
+ * Ignore Symbios chips controlled by various RAID controllers.
+ * These controllers set value 0x52414944 at RAM end - 16.
+ */
+static int __devinit sym_check_raid(struct sym_device *device)
+{
+	unsigned long base_2_c = device->s.base_2_c;
+	unsigned int ram_size, ram_val;
+	void *ram_ptr;
+
+	if (!base_2_c)
+		return 0;
+
+	if (device->chip.features & FE_RAM8K)
+		ram_size = 8192;
+	else
+		ram_size = 4096;
+
+	ram_ptr = ioremap(base_2_c, ram_size);
+	if (!ram_ptr)
+		return 0;
+
+	ram_val = readl(ram_ptr + ram_size - 16);
+	iounmap(ram_ptr);
+	if (ram_val != 0x52414944)
+		return 0;
+
+	printf_info("%s: not initializing, driven by RAID controller.\n",
+		    sym_name(device));
+	return -ENODEV;
+}
+
+static int __devinit sym_set_workarounds(struct sym_device *device)
+{
+	struct sym_pci_chip *chip = &device->chip;
+	struct pci_dev *pdev = device->pdev;
+	u_short status_reg;
+
 	/*
-	 *  Some features are required to be enabled in order to 
-	 *  work around some chip problems. :) ;)
 	 *  (ITEM 12 of a DEL about the 896 I haven't yet).
 	 *  We must ensure the chip will use WRITE AND INVALIDATE.
 	 *  The revision number limit is for now arbitrary.
 	 */
-	if (device_id == PCI_DEVICE_ID_NCR_53C896 && revision < 0x4) {
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && chip->revision_id < 0x4) {
 		chip->features	|= (FE_WRIE | FE_CLSE);
 	}
 
 	/* If the chip can do Memory Write Invalidate, enable it */
 	if (chip->features & FE_WRIE) {
 		if (pci_set_mwi(pdev))
-			return -1;
+			return -ENODEV;
 	}
 
 	/*
@@ -2125,21 +2096,39 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 		}
 	}
 
- 	/*
-	 *  Initialise device structure with items required by sym_attach.
-	 */
-	device->pdev		= pdev;
-	device->s.base		= base;
-	device->s.base_2	= base_2;
-	device->s.base_c	= base_c;
-	device->s.base_2_c	= base_2_c;
-	device->s.io_port	= io_port;
-	device->s.irq		= pdev->irq;
-
 	return 0;
 }
 
 /*
+ *  Read and check the PCI configuration for any detected NCR 
+ *  boards and save data for attaching after all boards have 
+ *  been detected.
+ */
+static void __devinit
+sym_init_device(struct pci_dev *pdev, struct sym_device *device)
+{
+	unsigned long base, base_2; 
+	int i;
+
+	device->pdev = pdev;
+	device->s.irq = pdev->irq;
+
+	/* Choose some short name for this device */
+	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
+			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+
+	device->s.io_port = pdev->resource[0].start;
+
+	device->s.base_c = pdev->resource[1].start;
+	i = pci_get_base_address(pdev, 1, &base);
+	device->s.base = base & PCI_BASE_ADDRESS_MEM_MASK;
+
+	device->s.base_2_c = pdev->resource[i].start;
+	pci_get_base_address(pdev, i, &base_2);
+	device->s.base_2 = base_2 & PCI_BASE_ADDRESS_MEM_MASK;
+}
+
+/*
  * The NCR PQS and PDS cards are constructed as a DEC bridge
  * behind which sits a proprietary NCR memory controller and
  * either four or two 53c875s as separate devices.  We can tell
@@ -2215,7 +2204,7 @@ static int sym_detach(struct sym_hcb *np
 	return 1;
 }
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL");
 MODULE_VERSION(SYM_VERSION);
 
 /*
@@ -2252,7 +2241,7 @@ static int __devinit sym2_probe(struct p
 	memset(&nvram, 0, sizeof(nvram));
 
 	if (pci_enable_device(pdev))
-		return -ENODEV;
+		goto leave;
 
 	pci_set_master(pdev);
 
@@ -2260,7 +2249,15 @@ static int __devinit sym2_probe(struct p
 		goto disable;
 
 	sym_dev.host_id = SYM_SETUP_HOST_ID;
-	if (sym53c8xx_pci_init(pdev, &sym_dev))
+
+	sym_init_device(pdev, &sym_dev);
+	if (sym_check_supported(&sym_dev))
+		goto free;
+
+	if (sym_check_raid(&sym_dev))
+		goto leave;	/* Don't disable the device */
+
+	if (sym_set_workarounds(&sym_dev))
 		goto free;
 
 	sym_config_pqs(pdev, &sym_dev);
@@ -2285,6 +2282,7 @@ static int __devinit sym2_probe(struct p
 	pci_release_regions(pdev);
  disable:
 	pci_disable_device(pdev);
+ leave:
 	return -ENODEV;
 }
 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Mon Sep 13 09:16:59 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_GLUE_H
@@ -89,7 +76,6 @@
 
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
-#define SYM_OPT_NVRAM_PRE_READ
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 
@@ -107,10 +93,9 @@
 #define	printf(args...)		printk(args)
 
 /*
- *  Insert a delay in micro-seconds and milli-seconds.
+ *  Insert a delay in micro-seconds
  */
 #define sym_udelay(us)	udelay(us)
-#define sym_mdelay(ms)	mdelay(ms)
 
 /*
  *  A 'read barrier' flushes any data that have been prefetched 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Mon Sep 13 09:17:18 2004
@@ -3,6 +3,7 @@
  * of PCI-SCSI IO processors.
  *
  * Copyright (C) 1999-2001  Gerard Roudier <groudier@free.fr>
+ * Copyright (c) 2003-2004  Matthew Wilcox <matthew@wil.cx>
  *
  * This driver is derived from the Linux sym53c8xx driver.
  * Copyright (C) 1998-2000  Gerard Roudier
@@ -22,32 +23,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -299,7 +287,6 @@ int sym_reset_scsi_bus(hcb_p np, int ena
 	}
 out:
 	OUTB (nc_scntl1, 0);
-	/* MDELAY(100); */
 	return retv;
 }
 
@@ -1955,7 +1942,7 @@ void sym_start_up (hcb_p np, int reason)
 	if (np->features & (FE_ULTRA2|FE_ULTRA3)) {
 		OUTONW (nc_sien, SBMC);
 		if (reason == 0) {
-			MDELAY(100);
+			mdelay(100);
 			INW (nc_sist);
 		}
 		np->scsi_mode = INB (nc_stest4) & SMODE;
@@ -5518,7 +5505,6 @@ void sym_complete_error (hcb_p np, ccb_p
 		printf ("CCB=%lx STAT=%x/%x/%x DEV=%d/%d\n", (unsigned long)cp,
 			cp->host_status, cp->ssss_status, cp->host_flags,
 			cp->target, cp->lun);
-		MDELAY(100);
 	}
 
 	/*
@@ -5746,15 +5732,8 @@ if (resid)
 /*
  *  Soft-attach the controller.
  */
-#ifdef SYM_OPT_NVRAM_PRE_READ
 int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram)
-#else
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw)
-#endif
 {
-#ifndef SYM_OPT_NVRAM_PRE_READ
-	struct sym_nvram nvram_buf, *nvram = &nvram_buf;
-#endif
 	int i;
 
 	/*
@@ -5779,13 +5758,6 @@ int sym_hcb_attach(hcb_p np, struct sym_
 	 *  if the chip is currently active.
 	 */
 	sym_chip_reset (np);
-
-	/*
-	 *  Try to read the user set-up.
-	 */
-#ifndef SYM_OPT_NVRAM_PRE_READ
-	(void) sym_read_nvram(np, nvram);
-#endif
 
 	/*
 	 *  Prepare controller and devices settings, according 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Mon Sep 13 09:10:32 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_HIPD_H
@@ -1121,12 +1108,7 @@ int sym_abort_scsiio(hcb_p np, cam_ccb_p
 int sym_abort_ccb(hcb_p np, ccb_p cp, int timed_out);
 int sym_reset_scsi_target(hcb_p np, int target);
 void sym_hcb_free(hcb_p np);
-
-#ifdef SYM_OPT_NVRAM_PRE_READ
 int sym_hcb_attach(hcb_p np, struct sym_fw *fw, struct sym_nvram *nvram);
-#else
-int sym_hcb_attach(hcb_p np, struct sym_fw *fw);
-#endif
 
 /*
  *  Optionnaly, the driver may handle IO timeouts.
@@ -1350,7 +1332,6 @@ u32 __vtobus_unlocked(m_pool_ident_t dev
 #define PRINT_ADDR	sym_print_addr
 #define PRINT_TARGET	sym_print_target
 #define PRINT_LUN	sym_print_lun
-#define MDELAY		sym_mdelay
 #define UDELAY		sym_udelay
 
 #endif /* SYM_HIPD_H */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_malloc.c	Mon Sep 13 09:10:32 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifdef __FreeBSD__
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Mon Sep 13 09:10:32 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifdef __FreeBSD__
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h	Mon Sep 13 09:10:32 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_MISC_H
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	Mon Sep 13 09:10:33 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include "sym_glue.h"
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	Mon Sep 13 10:02:11 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	Mon Sep 13 09:10:33 2004
@@ -22,32 +22,19 @@
  *
  *-----------------------------------------------------------------------------
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
- * Where this Software is combined with software released under the terms of 
- * the GNU Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef SYM_NVRAM_H

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
