From: "Randy.Dunlap" <randy.dunlap@verizon.net>
Subject: [PATCH] reduce stack in qlogicfc.c
Date: Tue, 11 Mar 2003 22:11:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6ECFAD.A4363F5E@verizon.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------02E08463581600A23BAD98CF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verizon.net ([4.64.238.61]) by pop016.verizon.net
          (InterMail vM.5.01.05.27 201-253-122-126-127-20021220) with ESMTP
          id <20030312061412.GXKE8278.pop016.verizon.net@verizon.net>
          for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2003 00:14:12 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------02E08463581600A23BAD98CF
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This is a start on reducing the stack usage in qlogicfc.c::
isp2x00_make_portdb().  I think that the stack reduction portion
of it is fine, but I'm concerned about the function returning
early due to kmalloc() failure, without making the port database.

[reduces stack from 0xc38 to 0x34 bytes (P4 UP, gcc 2.96)]

Can anyone suggest way(s) to have the isp2x00_make_portdb() function
called over and over again until it gets its job done?
Or does anyone even still use this driver?

Thanks,
~Randy
--------------02E08463581600A23BAD98CF
Content-Type: text/plain; charset=us-ascii;
 name="qlogicfc_stack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qlogicfc_stack.patch"

patch_name:	qlogicfc_stack.patch
patch_version:	2003-03-11.21:52:26
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	reduce stack usage in qlogicfc.c::isp2x00_make_portdb()
		from 0xc38 to 0x34 bytes (P4 UP, gcc 2.96);
product:	Linux
product_versions: linux-2564
changelog:	change id_name_map from a large array to a kmalloc-ed area;
requires:	Linux 2.5.64
maintainer:	Erik H. Moe, ehm@cris.com
diffstat:	=
 drivers/scsi/qlogicfc.c |   72 +++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 31 deletions(-)


diff -Naur ./drivers/scsi/qlogicfc.c%QLOGFC ./drivers/scsi/qlogicfc.c
--- ./drivers/scsi/qlogicfc.c%QLOGFC	Tue Mar  4 19:29:32 2003
+++ ./drivers/scsi/qlogicfc.c	Tue Mar 11 21:50:31 2003
@@ -836,14 +836,22 @@
 
 	short param[8];
 	int i, j;
-	struct id_name_map temp[QLOGICFC_MAX_ID + 1];
+	struct id_name_map *map; /* base of array [QLOGICFC_MAX_ID + 1] */
+	struct id_name_map *mapx; /* array entry pointer */
 	struct isp2x00_hostdata *hostdata;
 
-	isp2x00_disable_irqs(host);
-
-	memset(temp, 0, sizeof(temp));
 	hostdata = (struct isp2x00_hostdata *) host->hostdata;
 
+	map = kmalloc((QLOGICFC_MAX_ID + 1) * sizeof(struct id_name_map), GFP_ATOMIC);
+	if (!map) {
+	        printk("qlogicfc%d : error getting memory -- cannot make port database.\n",
+				hostdata->host_id);
+		goto fini;
+	}
+	memset(map, 0, (QLOGICFC_MAX_ID + 1) * sizeof(struct id_name_map));
+
+	isp2x00_disable_irqs(host);
+
 #if ISP2x00_FABRIC
 	for (i = 0x81; i < QLOGICFC_MAX_ID; i++) {
 		param[0] = MBOX_PORT_LOGOUT;
@@ -868,72 +876,74 @@
 	if (param[0] == MBOX_COMMAND_COMPLETE) {
 		hostdata->port_id = ((u_int) param[3]) << 16;
 		hostdata->port_id |= param[2];
-		temp[0].loop_id = param[1];
-		temp[0].wwn = hostdata->wwn;
+		map->loop_id = param[1];
+		map->wwn = hostdata->wwn;
 	}
 	else {
 	        printk("qlogicfc%d : error getting scsi id.\n", hostdata->host_id);
 	}
 
-        for (i = 0; i <=QLOGICFC_MAX_ID; i++)
-                temp[i].loop_id = temp[0].loop_id;
+        for (i = 0, mapx = map; i <= QLOGICFC_MAX_ID; i++, mapx++)
+                mapx->loop_id = map->loop_id;
    
-        for (i = 0, j = 1; i <= QLOGICFC_MAX_LOOP_ID; i++) {
+        for (i = 0, j = 1, mapx = map + 1; i <= QLOGICFC_MAX_LOOP_ID; i++) {
                 param[0] = MBOX_GET_PORT_NAME;
 		param[1] = (i << 8) & 0xff00;
 
 		isp2x00_mbox_command(host, param);
 
 		if (param[0] == MBOX_COMMAND_COMPLETE) {
-			temp[j].loop_id = i;
-			temp[j].wwn = ((u64) (param[2] & 0xff)) << 56;
-			temp[j].wwn |= ((u64) ((param[2] >> 8) & 0xff)) << 48;
-			temp[j].wwn |= ((u64) (param[3] & 0xff)) << 40;
-			temp[j].wwn |= ((u64) ((param[3] >> 8) & 0xff)) << 32;
-			temp[j].wwn |= ((u64) (param[6] & 0xff)) << 24;
-			temp[j].wwn |= ((u64) ((param[6] >> 8) & 0xff)) << 16;
-			temp[j].wwn |= ((u64) (param[7] & 0xff)) << 8;
-			temp[j].wwn |= ((u64) ((param[7] >> 8) & 0xff));
+			mapx->loop_id = i;
+			mapx->wwn = ((u64) (param[2] & 0xff)) << 56;
+			mapx->wwn |= ((u64) ((param[2] >> 8) & 0xff)) << 48;
+			mapx->wwn |= ((u64) (param[3] & 0xff)) << 40;
+			mapx->wwn |= ((u64) ((param[3] >> 8) & 0xff)) << 32;
+			mapx->wwn |= ((u64) (param[6] & 0xff)) << 24;
+			mapx->wwn |= ((u64) ((param[6] >> 8) & 0xff)) << 16;
+			mapx->wwn |= ((u64) (param[7] & 0xff)) << 8;
+			mapx->wwn |= ((u64) ((param[7] >> 8) & 0xff));
 
 			j++;
-
+			mapx++;
 		}
 	}
 
 
 #if ISP2x00_FABRIC
-	isp2x00_init_fabric(host, temp, j);
+	isp2x00_init_fabric(host, map, j);
 #endif
 
-	for (i = 0; i <= QLOGICFC_MAX_ID; i++) {
-		if (temp[i].wwn != hostdata->port_db[i].wwn) {
-			for (j = 0; j <= QLOGICFC_MAX_ID; j++) {
-				if (temp[j].wwn == hostdata->port_db[i].wwn) {
-					hostdata->port_db[i].loop_id = temp[j].loop_id;
+	for (i = 0, mapx = map; i <= QLOGICFC_MAX_ID; i++, mapx++) {
+		struct id_name_map *tmap; /* second array entry pointer */
+		if (mapx->wwn != hostdata->port_db[i].wwn) {
+			for (j = 0, tmap = map; j <= QLOGICFC_MAX_ID; j++, tmap++) {
+				if (tmap->wwn == hostdata->port_db[i].wwn) {
+					hostdata->port_db[i].loop_id = tmap->loop_id;
 					break;
 				}
 			}
 			if (j == QLOGICFC_MAX_ID + 1)
-				hostdata->port_db[i].loop_id = temp[0].loop_id;
+				hostdata->port_db[i].loop_id = map->loop_id;
 
 			for (j = 0; j <= QLOGICFC_MAX_ID; j++) {
-				if (hostdata->port_db[j].wwn == temp[i].wwn || !hostdata->port_db[j].wwn) {
+				if (hostdata->port_db[j].wwn == mapx->wwn || !hostdata->port_db[j].wwn) {
 					break;
 				}
 			}
 			if (j == QLOGICFC_MAX_ID + 1)
 				printk("qlogicfc%d : Too many scsi devices, no more room in port map.\n", hostdata->host_id);
 			if (!hostdata->port_db[j].wwn) {
-				hostdata->port_db[j].loop_id = temp[i].loop_id;
-				hostdata->port_db[j].wwn = temp[i].wwn;
+				hostdata->port_db[j].loop_id = mapx->loop_id;
+				hostdata->port_db[j].wwn = mapx->wwn;
 			}
 		} else
-			hostdata->port_db[i].loop_id = temp[i].loop_id;
+			hostdata->port_db[i].loop_id = mapx->loop_id;
 
 	}
 
 	isp2x00_enable_irqs(host);
-
+	kfree(map);
+fini:
 	return 0;
 }
 

--------------02E08463581600A23BAD98CF--

