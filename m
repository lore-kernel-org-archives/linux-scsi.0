From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 add big endian support
Date: Wed, 15 Mar 2006 12:43:19 -0800
Message-ID: <b1bc6a000603151243y5272fa26p663fbd4d0f829b60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10627_20941906.1142455399894"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.183]:56434 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751327AbWCOUn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 15:43:27 -0500
Received: by pproxy.gmail.com with SMTP id w49so94860pyg
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2006 12:43:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

------=_Part_10627_20941906.1142455399894
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The attached patch updates the 3ware 9000 driver:

- Fix 9550SX pchip reset timeout.
- Add big endian support.

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

-Adam

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.c
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.c=092006-03-14 15:27:33.000000000 -0=
800
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c=092006-03-14 15:24:41.00000000=
0 -0800
@@ -2,8 +2,9 @@
    3w-9xxx.c -- 3ware 9000 Storage Controller device driver for Linux.

    Written By: Adam Radford <linuxraid@amcc.com>
+   Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2005 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -62,6 +63,8 @@
    2.26.02.003 - Correctly handle single sgl's with use_sg=3D1.
    2.26.02.004 - Add support for 9550SX controllers.
    2.26.02.005 - Fix use_sg =3D=3D 0 mapping on systems with 4GB or higher=
.
+   2.26.02.006 - Fix 9550SX pchip reset timeout.
+                 Add big endian support.
 */

 #include <linux/module.h>
@@ -85,7 +88,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.005"
+#define TW_DRIVER_VERSION "2.26.02.006"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major =3D -1;
@@ -208,7 +211,7 @@

 =09header =3D (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[requ=
est_id];
 =09tw_dev->posted_request_count--;
-=09aen =3D header->status_block.error;
+=09aen =3D le16_to_cpu(header->status_block.error);
 =09full_command_packet =3D tw_dev->command_packet_virt[request_id];
 =09command_packet =3D &full_command_packet->command.oldcommand;

@@ -305,7 +308,7 @@

 =09=09tw_dev->posted_request_count--;
 =09=09header =3D (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[r=
equest_id];
-=09=09aen =3D header->status_block.error;
+=09=09aen =3D le16_to_cpu(header->status_block.error);
 =09=09queue =3D 0;
 =09=09count++;

@@ -365,7 +368,7 @@
 =09=09=09tw_dev->aen_clobber =3D 1;
 =09}

-=09aen =3D header->status_block.error;
+=09aen =3D le16_to_cpu(header->status_block.error);
 =09memset(event, 0, sizeof(TW_Event));

 =09event->severity =3D TW_SEV_OUT(header->status_block.severity__reserved)=
;
@@ -382,7 +385,7 @@

 =09header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
 =09event->parameter_len =3D strlen(header->err_specific_desc);
-=09memcpy(event->parameter_data, header->err_specific_desc,
event->parameter_len);
+=09memcpy(event->parameter_data, header->err_specific_desc,
event->parameter_len + (error_str[0] =3D=3D '\0' ? 0 : (1 +
strlen(error_str))));
 =09if (event->severity !=3D TW_AEN_SEVERITY_DEBUG)
 =09=09printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
 =09=09       host,
@@ -462,24 +465,24 @@
 =09command_packet =3D &full_command_packet->command.oldcommand;
 =09command_packet->opcode__sgloffset =3D TW_OPSGL_IN(2, TW_OP_SET_PARAM);
 =09command_packet->request_id =3D request_id;
-=09command_packet->byte8_offset.param.sgl[0].address =3D
tw_dev->generic_buffer_phys[request_id];
-=09command_packet->byte8_offset.param.sgl[0].length =3D TW_SECTOR_SIZE;
+=09command_packet->byte8_offset.param.sgl[0].address =3D
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+=09command_packet->byte8_offset.param.sgl[0].length =3D
cpu_to_le32(TW_SECTOR_SIZE);
 =09command_packet->size =3D TW_COMMAND_SIZE;
-=09command_packet->byte6_offset.parameter_count =3D 1;
+=09command_packet->byte6_offset.parameter_count =3D cpu_to_le16(1);

 =09/* Setup the param */
 =09param =3D (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
 =09memset(param, 0, TW_SECTOR_SIZE);
-=09param->table_id =3D TW_TIMEKEEP_TABLE | 0x8000; /* Controller time keep=
 table */
-=09param->parameter_id =3D 0x3; /* SchedulerTime */
-=09param->parameter_size_bytes =3D 4;
+=09param->table_id =3D cpu_to_le16(TW_TIMEKEEP_TABLE | 0x8000); /*
Controller time keep table */
+=09param->parameter_id =3D cpu_to_le16(0x3); /* SchedulerTime */
+=09param->parameter_size_bytes =3D cpu_to_le16(4);

 =09/* Convert system time in UTC to local time seconds since last
            Sunday 12:00AM */
 =09do_gettimeofday(&utc);
 =09local_time =3D (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
 =09schedulertime =3D local_time - (3 * 86400);
-=09schedulertime =3D schedulertime % 604800;
+=09schedulertime =3D cpu_to_le32(schedulertime % 604800);

 =09memcpy(param->data, &schedulertime, sizeof(u32));

@@ -931,26 +934,19 @@
 /* This function will clear the pchip/response queue on 9550SX */
 static int twa_empty_response_queue_large(TW_Device_Extension *tw_dev)
 {
-=09u32 status_reg_value, response_que_value;
-=09int count =3D 0, retval =3D 1;
+=09u32 response_que_value =3D 0;
+=09unsigned long before;
+=09int retval =3D 1;

 =09if (tw_dev->tw_pci_dev->device =3D=3D PCI_DEVICE_ID_3WARE_9550SX) {
-=09=09status_reg_value =3D readl(TW_STATUS_REG_ADDR(tw_dev));
-
-=09=09while (((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) =3D=3D 0=
)
&& (count < TW_MAX_RESPONSE_DRAIN)) {
+=09=09before =3D jiffies;
+=09=09while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) !=3D
TW_9550SX_DRAIN_COMPLETED) {
 =09=09=09response_que_value =3D readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_=
dev));
-=09=09=09if ((response_que_value & TW_9550SX_DRAIN_COMPLETED) =3D=3D
TW_9550SX_DRAIN_COMPLETED) {
-=09=09=09=09/* P-chip settle time */
-=09=09=09=09msleep(500);
-=09=09=09=09retval =3D 0;
+=09=09=09if (time_after(jiffies, before + HZ * 30))
 =09=09=09=09goto out;
-=09=09=09}
-=09=09=09status_reg_value =3D readl(TW_STATUS_REG_ADDR(tw_dev));
-=09=09=09count++;
 =09=09}
-=09=09if (count =3D=3D TW_MAX_RESPONSE_DRAIN)
-=09=09=09goto out;
-=09=09
+=09=09/* P-chip settle time */
+=09=09msleep(500);
 =09=09retval =3D 0;
 =09} else
 =09=09retval =3D 0;
@@ -972,7 +968,7 @@
 =09error_str =3D &(full_command_packet->header.err_specific_desc[strlen(fu=
ll_command_packet->header.err_specific_desc)
+ 1]);

 =09/* Don't print error for Logical unit not supported during rollcall */
-=09error =3D full_command_packet->header.status_block.error;
+=09error =3D le16_to_cpu(full_command_packet->header.status_block.error);
 =09if ((error !=3D TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error !=3D
TW_ERROR_UNIT_OFFLINE)) {
 =09=09if (print_host)
 =09=09=09printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:=
%s.\n",
@@ -1047,18 +1043,18 @@
 =09command_packet->opcode__sgloffset =3D TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 =09command_packet->size              =3D TW_COMMAND_SIZE;
 =09command_packet->request_id        =3D request_id;
-=09command_packet->byte6_offset.block_count =3D 1;
+=09command_packet->byte6_offset.block_count =3D cpu_to_le16(1);

 =09/* Now setup the param */
 =09param =3D (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
 =09memset(param, 0, TW_SECTOR_SIZE);
-=09param->table_id =3D table_id | 0x8000;
-=09param->parameter_id =3D parameter_id;
-=09param->parameter_size_bytes =3D parameter_size_bytes;
+=09param->table_id =3D cpu_to_le16(table_id | 0x8000);
+=09param->parameter_id =3D cpu_to_le16(parameter_id);
+=09param->parameter_size_bytes =3D cpu_to_le16(parameter_size_bytes);
 =09param_value =3D tw_dev->generic_buffer_phys[request_id];

-=09command_packet->byte8_offset.param.sgl[0].address =3D param_value;
-=09command_packet->byte8_offset.param.sgl[0].length =3D TW_SECTOR_SIZE;
+=09command_packet->byte8_offset.param.sgl[0].address =3D
TW_CPU_TO_SGL(param_value);
+=09command_packet->byte8_offset.param.sgl[0].length =3D
cpu_to_le32(TW_SECTOR_SIZE);

 =09/* Post the command packet to the board */
 =09twa_post_command_packet(tw_dev, request_id, 1);
@@ -1107,18 +1103,20 @@
 =09tw_initconnect =3D (TW_Initconnect *)&full_command_packet->command.oldc=
ommand;
 =09tw_initconnect->opcode__reserved =3D TW_OPRES_IN(0, TW_OP_INIT_CONNECTI=
ON);
 =09tw_initconnect->request_id =3D request_id;
-=09tw_initconnect->message_credits =3D message_credits;
+=09tw_initconnect->message_credits =3D cpu_to_le16(message_credits);
 =09tw_initconnect->features =3D set_features;

 =09/* Turn on 64-bit sgl support if we need to */
 =09tw_initconnect->features |=3D sizeof(dma_addr_t) > 4 ? 1 : 0;

+=09tw_initconnect->features =3D cpu_to_le32(tw_initconnect->features);
+
 =09if (set_features & TW_EXTENDED_INIT_CONNECT) {
 =09=09tw_initconnect->size =3D TW_INIT_COMMAND_PACKET_SIZE_EXTENDED;
-=09=09tw_initconnect->fw_srl =3D current_fw_srl;
-=09=09tw_initconnect->fw_arch_id =3D current_fw_arch_id;
-=09=09tw_initconnect->fw_branch =3D current_fw_branch;
-=09=09tw_initconnect->fw_build =3D current_fw_build;
+=09=09tw_initconnect->fw_srl =3D cpu_to_le16(current_fw_srl);
+=09=09tw_initconnect->fw_arch_id =3D cpu_to_le16(current_fw_arch_id);
+=09=09tw_initconnect->fw_branch =3D cpu_to_le16(current_fw_branch);
+=09=09tw_initconnect->fw_build =3D cpu_to_le16(current_fw_build);
 =09} else
 =09=09tw_initconnect->size =3D TW_INIT_COMMAND_PACKET_SIZE;

@@ -1130,11 +1128,11 @@
 =09=09TW_PRINTK(tw_dev->host, TW_DRIVER, 0x15, "No valid response during
init connection");
 =09} else {
 =09=09if (set_features & TW_EXTENDED_INIT_CONNECT) {
-=09=09=09*fw_on_ctlr_srl =3D tw_initconnect->fw_srl;
-=09=09=09*fw_on_ctlr_arch_id =3D tw_initconnect->fw_arch_id;
-=09=09=09*fw_on_ctlr_branch =3D tw_initconnect->fw_branch;
-=09=09=09*fw_on_ctlr_build =3D tw_initconnect->fw_build;
-=09=09=09*init_connect_result =3D tw_initconnect->result;
+=09=09=09*fw_on_ctlr_srl =3D le16_to_cpu(tw_initconnect->fw_srl);
+=09=09=09*fw_on_ctlr_arch_id =3D le16_to_cpu(tw_initconnect->fw_arch_id);
+=09=09=09*fw_on_ctlr_branch =3D le16_to_cpu(tw_initconnect->fw_branch);
+=09=09=09*fw_on_ctlr_build =3D le16_to_cpu(tw_initconnect->fw_build);
+=09=09=09*init_connect_result =3D le32_to_cpu(tw_initconnect->result);
 =09=09}
 =09=09retval =3D 0;
 =09}
@@ -1358,10 +1356,10 @@
 =09=09newcommand =3D &full_command_packet->command.newcommand;
 =09=09newcommand->request_id__lunl =3D
 =09=09=09TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_i=
d);
-=09=09newcommand->sg_list[0].address =3D dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1;
-=09=09newcommand->sg_list[0].length =3D length;
+=09=09newcommand->sg_list[0].address =3D TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
+=09=09newcommand->sg_list[0].length =3D cpu_to_le32(length);
 =09=09newcommand->sgl_entries__lunh =3D
-=09=09=09TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1);
+=09=09=09cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lun=
h), 1));
 =09} else {
 =09=09oldcommand =3D &full_command_packet->command.oldcommand;
 =09=09oldcommand->request_id =3D request_id;
@@ -1369,8 +1367,8 @@
 =09=09if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
 =09=09=09/* Load the sg list */
 =09=09=09sgl =3D (TW_SG_Entry *)((u32
*)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
-=09=09=09sgl->address =3D dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1;
-=09=09=09sgl->length =3D length;
+=09=09=09sgl->address =3D TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_A=
pache) - 1);
+=09=09=09sgl->length =3D cpu_to_le32(length);

 =09=09=09if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
 =09=09=09=09oldcommand->size +=3D 1;
@@ -1828,10 +1826,10 @@
 =09if (srb) {
 =09=09command_packet->unit =3D srb->device->id;
 =09=09command_packet->request_id__lunl =3D
-=09=09=09TW_REQ_LUN_IN(srb->device->lun, request_id);
+=09=09=09cpu_to_le16(TW_REQ_LUN_IN(srb->device->lun, request_id));
 =09} else {
 =09=09command_packet->request_id__lunl =3D
-=09=09=09TW_REQ_LUN_IN(0, request_id);
+=09=09=09cpu_to_le16(TW_REQ_LUN_IN(0, request_id));
 =09=09command_packet->unit =3D 0;
 =09}

@@ -1841,8 +1839,8 @@
 =09=09/* Map sglist from scsi layer to cmd packet */
 =09=09if (tw_dev->srb[request_id]->use_sg =3D=3D 0) {
 =09=09=09if (tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH)=
 {
-=09=09=09=09command_packet->sg_list[0].address =3D
tw_dev->generic_buffer_phys[request_id];
-=09=09=09=09command_packet->sg_list[0].length =3D TW_MIN_SGL_LENGTH;
+=09=09=09=09command_packet->sg_list[0].address =3D
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+=09=09=09=09command_packet->sg_list[0].length =3D cpu_to_le32(TW_MIN_SGL_L=
ENGTH);
 =09=09=09=09if (tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_TO_D=
EVICE
|| tw_dev->srb[request_id]->sc_data_direction =3D=3D DMA_BIDIRECTIONAL)
 =09=09=09=09=09memcpy(tw_dev->generic_buffer_virt[request_id],
tw_dev->srb[request_id]->request_buffer,
tw_dev->srb[request_id]->request_bufflen);
 =09=09=09} else {
@@ -1850,12 +1848,12 @@
 =09=09=09=09if (buffaddr =3D=3D 0)
 =09=09=09=09=09goto out;

-=09=09=09=09command_packet->sg_list[0].address =3D buffaddr;
-=09=09=09=09command_packet->sg_list[0].length =3D
tw_dev->srb[request_id]->request_bufflen;
+=09=09=09=09command_packet->sg_list[0].address =3D TW_CPU_TO_SGL(buffaddr)=
;
+=09=09=09=09command_packet->sg_list[0].length =3D
cpu_to_le32(tw_dev->srb[request_id]->request_bufflen);
 =09=09=09}
-=09=09=09command_packet->sgl_entries__lunh =3D
TW_REQ_LUN_IN((srb->device->lun >> 4), 1);
+=09=09=09command_packet->sgl_entries__lunh =3D
cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4), 1));

-=09=09=09if (command_packet->sg_list[0].address & TW_ALIGNMENT_9000_SGL) {
+=09=09=09if (command_packet->sg_list[0].address &
TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 =09=09=09=09TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2d, "Found unaligned addr=
ess
during execute scsi");
 =09=09=09=09goto out;
 =09=09=09}
@@ -1869,35 +1867,35 @@
 =09=09=09=09=09memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->le=
ngth);
 =09=09=09=09=09kunmap_atomic(buf - sg->offset, KM_IRQ0);
 =09=09=09=09}
-=09=09=09=09command_packet->sg_list[0].address =3D
tw_dev->generic_buffer_phys[request_id];
-=09=09=09=09command_packet->sg_list[0].length =3D TW_MIN_SGL_LENGTH;
+=09=09=09=09command_packet->sg_list[0].address =3D
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+=09=09=09=09command_packet->sg_list[0].length =3D cpu_to_le32(TW_MIN_SGL_L=
ENGTH);
 =09=09=09} else {
 =09=09=09=09sg_count =3D twa_map_scsi_sg_data(tw_dev, request_id);
 =09=09=09=09if (sg_count =3D=3D 0)
 =09=09=09=09=09goto out;

 =09=09=09=09for (i =3D 0; i < sg_count; i++) {
-=09=09=09=09=09command_packet->sg_list[i].address =3D sg_dma_address(&sgli=
st[i]);
-=09=09=09=09=09command_packet->sg_list[i].length =3D sg_dma_len(&sglist[i]=
);
-=09=09=09=09=09if (command_packet->sg_list[i].address & TW_ALIGNMENT_9000_=
SGL) {
+=09=09=09=09=09command_packet->sg_list[i].address =3D
TW_CPU_TO_SGL(sg_dma_address(&sglist[i]));
+=09=09=09=09=09command_packet->sg_list[i].length =3D cpu_to_le32(sg_dma_le=
n(&sglist[i]));
+=09=09=09=09=09if (command_packet->sg_list[i].address &
TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 =09=09=09=09=09=09TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligne=
d sgl
address during execute scsi");
 =09=09=09=09=09=09goto out;
 =09=09=09=09=09}
 =09=09=09=09}
 =09=09=09}
-=09=09=09command_packet->sgl_entries__lunh =3D
TW_REQ_LUN_IN((srb->device->lun >> 4),
tw_dev->srb[request_id]->use_sg);
+=09=09=09command_packet->sgl_entries__lunh =3D
cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4),
tw_dev->srb[request_id]->use_sg));
 =09=09}
 =09} else {
 =09=09/* Internal cdb post */
 =09=09for (i =3D 0; i < use_sg; i++) {
-=09=09=09command_packet->sg_list[i].address =3D sglistarg[i].address;
-=09=09=09command_packet->sg_list[i].length =3D sglistarg[i].length;
-=09=09=09if (command_packet->sg_list[i].address & TW_ALIGNMENT_9000_SGL) {
+=09=09=09command_packet->sg_list[i].address =3D TW_CPU_TO_SGL(sglistarg[i]=
.address);
+=09=09=09command_packet->sg_list[i].length =3D cpu_to_le32(sglistarg[i].le=
ngth);
+=09=09=09if (command_packet->sg_list[i].address &
TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 =09=09=09=09TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2f, "Found unaligned sgl
address during internal post");
 =09=09=09=09goto out;
 =09=09=09}
 =09=09}
-=09=09command_packet->sgl_entries__lunh =3D TW_REQ_LUN_IN(0, use_sg);
+=09=09command_packet->sgl_entries__lunh =3D cpu_to_le16(TW_REQ_LUN_IN(0, u=
se_sg));
 =09}

 =09if (srb) {
@@ -2115,8 +2113,8 @@
 =09=09=09=09     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
 =09       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
 =09=09=09=09     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-=09       *(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
-=09=09=09=09     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH));
+=09       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABL=
E,
+=09=09=09=09     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));

 =09/* Now setup the interrupt handler */
 =09retval =3D request_irq(pdev->irq, twa_interrupt, SA_SHIRQ, "3w-9xxx", t=
w_dev);
diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.h
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.h=092006-03-14 15:27:33.000000000 -0=
800
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h=092006-03-14 15:13:16.00000000=
0 -0800
@@ -2,8 +2,9 @@
    3w-9xxx.h -- 3ware 9000 Storage Controller device driver for Linux.

    Written By: Adam Radford <linuxraid@amcc.com>
+   Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2005 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -287,9 +288,6 @@
 #define TW_STATUS_UNEXPECTED_BITS=09       0x00F00000
 #define TW_STATUS_VALID_INTERRUPT              0x00DF0000

-/* RESPONSE QUEUE BIT DEFINITIONS */
-#define TW_RESPONSE_ID_MASK=09=09       0x00000FF0
-
 /* PCI related defines */
 #define TW_NUMDEVICES 1
 #define TW_PCI_CLEAR_PARITY_ERRORS 0xc100
@@ -471,6 +469,7 @@
 #define TW_APACHE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 72 : 109)
 #define TW_ESCALADE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 41 : 62)
 #define TW_PADDING_LENGTH (sizeof(dma_addr_t) > 4 ? 8 : 0)
+#define TW_CPU_TO_SGL(x) (sizeof(dma_addr_t) > 4 ? cpu_to_le64(x) :
cpu_to_le32(x))

 #pragma pack(1)

@@ -614,13 +613,6 @@
 =09u32 value;
 } TW_Response_Queue;

-typedef struct TAG_TW_Info {
-=09char *buffer;
-=09int length;
-=09int offset;
-=09int position;
-} TW_Info;
-
 /* Compatibility information structure */
 typedef struct TAG_TW_Compatibility_Info
 {
@@ -636,6 +628,8 @@
 =09unsigned short driver_build_low;
 } TW_Compatibility_Info;

+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
 =09u32                     __iomem *base_addr;
 =09unsigned long=09       =09*generic_buffer_virt[TW_Q_LENGTH];
@@ -679,7 +673,5 @@
 =09unsigned short=09=09working_build;
 } TW_Device_Extension;

-#pragma pack()
-
 #endif /* _3W_9XXX_H */

------=_Part_10627_20941906.1142455399894
Content-Type: text/x-patch; name=3ware_scsi_misc_2.6.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_eku4cjr2
Content-Disposition: attachment; filename="3ware_scsi_misc_2.6.patch"

diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.c scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.c	2006-03-14 15:27:33.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c	2006-03-14 15:24:41.000000000 -0800
@@ -2,8 +2,9 @@
    3w-9xxx.c -- 3ware 9000 Storage Controller device driver for Linux.
 
    Written By: Adam Radford <linuxraid@amcc.com>
+   Modifications By: Tom Couch <linuxraid@amcc.com>
 
-   Copyright (C) 2004-2005 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -62,6 +63,8 @@
    2.26.02.003 - Correctly handle single sgl's with use_sg=1.
    2.26.02.004 - Add support for 9550SX controllers.
    2.26.02.005 - Fix use_sg == 0 mapping on systems with 4GB or higher.
+   2.26.02.006 - Fix 9550SX pchip reset timeout.
+                 Add big endian support.
 */
 
 #include <linux/module.h>
@@ -85,7 +88,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.005"
+#define TW_DRIVER_VERSION "2.26.02.006"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -208,7 +211,7 @@
 
 	header = (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[request_id];
 	tw_dev->posted_request_count--;
-	aen = header->status_block.error;
+	aen = le16_to_cpu(header->status_block.error);
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 	command_packet = &full_command_packet->command.oldcommand;
 
@@ -305,7 +308,7 @@
 
 		tw_dev->posted_request_count--;
 		header = (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[request_id];
-		aen = header->status_block.error;
+		aen = le16_to_cpu(header->status_block.error);
 		queue = 0;
 		count++;
 
@@ -365,7 +368,7 @@
 			tw_dev->aen_clobber = 1;
 	}
 
-	aen = header->status_block.error;
+	aen = le16_to_cpu(header->status_block.error);
 	memset(event, 0, sizeof(TW_Event));
 
 	event->severity = TW_SEV_OUT(header->status_block.severity__reserved);
@@ -382,7 +385,7 @@
 
 	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
 	event->parameter_len = strlen(header->err_specific_desc);
-	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len);
+	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + (error_str[0] == '\0' ? 0 : (1 + strlen(error_str))));
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
 		printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
 		       host,
@@ -462,24 +465,24 @@
 	command_packet = &full_command_packet->command.oldcommand;
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_SET_PARAM);
 	command_packet->request_id = request_id;
-	command_packet->byte8_offset.param.sgl[0].address = tw_dev->generic_buffer_phys[request_id];
-	command_packet->byte8_offset.param.sgl[0].length = TW_SECTOR_SIZE;
+	command_packet->byte8_offset.param.sgl[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+	command_packet->byte8_offset.param.sgl[0].length = cpu_to_le32(TW_SECTOR_SIZE);
 	command_packet->size = TW_COMMAND_SIZE;
-	command_packet->byte6_offset.parameter_count = 1;
+	command_packet->byte6_offset.parameter_count = cpu_to_le16(1);
 
 	/* Setup the param */
 	param = (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
 	memset(param, 0, TW_SECTOR_SIZE);
-	param->table_id = TW_TIMEKEEP_TABLE | 0x8000; /* Controller time keep table */
-	param->parameter_id = 0x3; /* SchedulerTime */
-	param->parameter_size_bytes = 4;
+	param->table_id = cpu_to_le16(TW_TIMEKEEP_TABLE | 0x8000); /* Controller time keep table */
+	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
+	param->parameter_size_bytes = cpu_to_le16(4);
 
 	/* Convert system time in UTC to local time seconds since last 
            Sunday 12:00AM */
 	do_gettimeofday(&utc);
 	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
 	schedulertime = local_time - (3 * 86400);
-	schedulertime = schedulertime % 604800;
+	schedulertime = cpu_to_le32(schedulertime % 604800);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
 
@@ -931,26 +934,19 @@
 /* This function will clear the pchip/response queue on 9550SX */
 static int twa_empty_response_queue_large(TW_Device_Extension *tw_dev)
 {
-	u32 status_reg_value, response_que_value;
-	int count = 0, retval = 1;
+	u32 response_que_value = 0;
+	unsigned long before;
+	int retval = 1;
 
 	if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9550SX) {
-		status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
-
-		while (((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) && (count < TW_MAX_RESPONSE_DRAIN)) {
+		before = jiffies;
+		while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) != TW_9550SX_DRAIN_COMPLETED) {
 			response_que_value = readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
-			if ((response_que_value & TW_9550SX_DRAIN_COMPLETED) == TW_9550SX_DRAIN_COMPLETED) {
-				/* P-chip settle time */
-				msleep(500);
-				retval = 0;
+			if (time_after(jiffies, before + HZ * 30))
 				goto out;
-			}
-			status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
-			count++;
 		}
-		if (count == TW_MAX_RESPONSE_DRAIN)
-			goto out;
-		
+		/* P-chip settle time */
+		msleep(500);
 		retval = 0;
 	} else
 		retval = 0;
@@ -972,7 +968,7 @@
 	error_str = &(full_command_packet->header.err_specific_desc[strlen(full_command_packet->header.err_specific_desc) + 1]);
 
 	/* Don't print error for Logical unit not supported during rollcall */
-	error = full_command_packet->header.status_block.error;
+	error = le16_to_cpu(full_command_packet->header.status_block.error);
 	if ((error != TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error != TW_ERROR_UNIT_OFFLINE)) {
 		if (print_host)
 			printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
@@ -1047,18 +1043,18 @@
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 	command_packet->size              = TW_COMMAND_SIZE;
 	command_packet->request_id        = request_id;
-	command_packet->byte6_offset.block_count = 1;
+	command_packet->byte6_offset.block_count = cpu_to_le16(1);
 
 	/* Now setup the param */
 	param = (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
 	memset(param, 0, TW_SECTOR_SIZE);
-	param->table_id = table_id | 0x8000;
-	param->parameter_id = parameter_id;
-	param->parameter_size_bytes = parameter_size_bytes;
+	param->table_id = cpu_to_le16(table_id | 0x8000);
+	param->parameter_id = cpu_to_le16(parameter_id);
+	param->parameter_size_bytes = cpu_to_le16(parameter_size_bytes);
 	param_value = tw_dev->generic_buffer_phys[request_id];
 
-	command_packet->byte8_offset.param.sgl[0].address = param_value;
-	command_packet->byte8_offset.param.sgl[0].length = TW_SECTOR_SIZE;
+	command_packet->byte8_offset.param.sgl[0].address = TW_CPU_TO_SGL(param_value);
+	command_packet->byte8_offset.param.sgl[0].length = cpu_to_le32(TW_SECTOR_SIZE);
 
 	/* Post the command packet to the board */
 	twa_post_command_packet(tw_dev, request_id, 1);
@@ -1107,18 +1103,20 @@
 	tw_initconnect = (TW_Initconnect *)&full_command_packet->command.oldcommand;
 	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
 	tw_initconnect->request_id = request_id;
-	tw_initconnect->message_credits = message_credits;
+	tw_initconnect->message_credits = cpu_to_le16(message_credits);
 	tw_initconnect->features = set_features;
 
 	/* Turn on 64-bit sgl support if we need to */
 	tw_initconnect->features |= sizeof(dma_addr_t) > 4 ? 1 : 0;
 
+	tw_initconnect->features = cpu_to_le32(tw_initconnect->features);
+
 	if (set_features & TW_EXTENDED_INIT_CONNECT) {
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE_EXTENDED;
-		tw_initconnect->fw_srl = current_fw_srl;
-		tw_initconnect->fw_arch_id = current_fw_arch_id;
-		tw_initconnect->fw_branch = current_fw_branch;
-		tw_initconnect->fw_build = current_fw_build;
+		tw_initconnect->fw_srl = cpu_to_le16(current_fw_srl);
+		tw_initconnect->fw_arch_id = cpu_to_le16(current_fw_arch_id);
+		tw_initconnect->fw_branch = cpu_to_le16(current_fw_branch);
+		tw_initconnect->fw_build = cpu_to_le16(current_fw_build);
 	} else 
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE;
 
@@ -1130,11 +1128,11 @@
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x15, "No valid response during init connection");
 	} else {
 		if (set_features & TW_EXTENDED_INIT_CONNECT) {
-			*fw_on_ctlr_srl = tw_initconnect->fw_srl;
-			*fw_on_ctlr_arch_id = tw_initconnect->fw_arch_id;
-			*fw_on_ctlr_branch = tw_initconnect->fw_branch;
-			*fw_on_ctlr_build = tw_initconnect->fw_build;
-			*init_connect_result = tw_initconnect->result;
+			*fw_on_ctlr_srl = le16_to_cpu(tw_initconnect->fw_srl);
+			*fw_on_ctlr_arch_id = le16_to_cpu(tw_initconnect->fw_arch_id);
+			*fw_on_ctlr_branch = le16_to_cpu(tw_initconnect->fw_branch);
+			*fw_on_ctlr_build = le16_to_cpu(tw_initconnect->fw_build);
+			*init_connect_result = le32_to_cpu(tw_initconnect->result);
 		}
 		retval = 0;
 	}
@@ -1358,10 +1356,10 @@
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl = 
 			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id);
-		newcommand->sg_list[0].address = dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1;
-		newcommand->sg_list[0].length = length;
+		newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+		newcommand->sg_list[0].length = cpu_to_le32(length);
 		newcommand->sgl_entries__lunh =
-			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1);
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1));
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;
@@ -1369,8 +1367,8 @@
 		if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
 			/* Load the sg list */
 			sgl = (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
-			sgl->address = dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1;
-			sgl->length = length;
+			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			sgl->length = cpu_to_le32(length);
 
 			if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
 				oldcommand->size += 1;
@@ -1828,10 +1826,10 @@
 	if (srb) {
 		command_packet->unit = srb->device->id;
 		command_packet->request_id__lunl =
-			TW_REQ_LUN_IN(srb->device->lun, request_id);
+			cpu_to_le16(TW_REQ_LUN_IN(srb->device->lun, request_id));
 	} else {
 		command_packet->request_id__lunl =
-			TW_REQ_LUN_IN(0, request_id);
+			cpu_to_le16(TW_REQ_LUN_IN(0, request_id));
 		command_packet->unit = 0;
 	}
 
@@ -1841,8 +1839,8 @@
 		/* Map sglist from scsi layer to cmd packet */
 		if (tw_dev->srb[request_id]->use_sg == 0) {
 			if (tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH) {
-				command_packet->sg_list[0].address = tw_dev->generic_buffer_phys[request_id];
-				command_packet->sg_list[0].length = TW_MIN_SGL_LENGTH;
+				command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+				command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
 				if (tw_dev->srb[request_id]->sc_data_direction == DMA_TO_DEVICE || tw_dev->srb[request_id]->sc_data_direction == DMA_BIDIRECTIONAL)
 					memcpy(tw_dev->generic_buffer_virt[request_id], tw_dev->srb[request_id]->request_buffer, tw_dev->srb[request_id]->request_bufflen);
 			} else {
@@ -1850,12 +1848,12 @@
 				if (buffaddr == 0)
 					goto out;
 
-				command_packet->sg_list[0].address = buffaddr;
-				command_packet->sg_list[0].length = tw_dev->srb[request_id]->request_bufflen;
+				command_packet->sg_list[0].address = TW_CPU_TO_SGL(buffaddr);
+				command_packet->sg_list[0].length = cpu_to_le32(tw_dev->srb[request_id]->request_bufflen);
 			}
-			command_packet->sgl_entries__lunh = TW_REQ_LUN_IN((srb->device->lun >> 4), 1);
+			command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4), 1));
 
-			if (command_packet->sg_list[0].address & TW_ALIGNMENT_9000_SGL) {
+			if (command_packet->sg_list[0].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2d, "Found unaligned address during execute scsi");
 				goto out;
 			}
@@ -1869,35 +1867,35 @@
 					memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->length);
 					kunmap_atomic(buf - sg->offset, KM_IRQ0);
 				}
-				command_packet->sg_list[0].address = tw_dev->generic_buffer_phys[request_id];
-				command_packet->sg_list[0].length = TW_MIN_SGL_LENGTH;
+				command_packet->sg_list[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+				command_packet->sg_list[0].length = cpu_to_le32(TW_MIN_SGL_LENGTH);
 			} else {
 				sg_count = twa_map_scsi_sg_data(tw_dev, request_id);
 				if (sg_count == 0)
 					goto out;
 
 				for (i = 0; i < sg_count; i++) {
-					command_packet->sg_list[i].address = sg_dma_address(&sglist[i]);
-					command_packet->sg_list[i].length = sg_dma_len(&sglist[i]);
-					if (command_packet->sg_list[i].address & TW_ALIGNMENT_9000_SGL) {
+					command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(&sglist[i]));
+					command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(&sglist[i]));
+					if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligned sgl address during execute scsi");
 						goto out;
 					}
 				}
 			}
-			command_packet->sgl_entries__lunh = TW_REQ_LUN_IN((srb->device->lun >> 4), tw_dev->srb[request_id]->use_sg);
+			command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4), tw_dev->srb[request_id]->use_sg));
 		}
 	} else {
 		/* Internal cdb post */
 		for (i = 0; i < use_sg; i++) {
-			command_packet->sg_list[i].address = sglistarg[i].address;
-			command_packet->sg_list[i].length = sglistarg[i].length;
-			if (command_packet->sg_list[i].address & TW_ALIGNMENT_9000_SGL) {
+			command_packet->sg_list[i].address = TW_CPU_TO_SGL(sglistarg[i].address);
+			command_packet->sg_list[i].length = cpu_to_le32(sglistarg[i].length);
+			if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2f, "Found unaligned sgl address during internal post");
 				goto out;
 			}
 		}
-		command_packet->sgl_entries__lunh = TW_REQ_LUN_IN(0, use_sg);
+		command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN(0, use_sg));
 	}
 
 	if (srb) {
@@ -2115,8 +2113,8 @@
 				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
 	       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
 				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-	       *(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
-				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH));
+	       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
+				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
 
 	/* Now setup the interrupt handler */
 	retval = request_irq(pdev->irq, twa_interrupt, SA_SHIRQ, "3w-9xxx", tw_dev);
diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.h scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.h	2006-03-14 15:27:33.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h	2006-03-14 15:13:16.000000000 -0800
@@ -2,8 +2,9 @@
    3w-9xxx.h -- 3ware 9000 Storage Controller device driver for Linux.
 
    Written By: Adam Radford <linuxraid@amcc.com>
+   Modifications By: Tom Couch <linuxraid@amcc.com>
 
-   Copyright (C) 2004-2005 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -287,9 +288,6 @@
 #define TW_STATUS_UNEXPECTED_BITS	       0x00F00000
 #define TW_STATUS_VALID_INTERRUPT              0x00DF0000
 
-/* RESPONSE QUEUE BIT DEFINITIONS */
-#define TW_RESPONSE_ID_MASK		       0x00000FF0
-
 /* PCI related defines */
 #define TW_NUMDEVICES 1
 #define TW_PCI_CLEAR_PARITY_ERRORS 0xc100
@@ -471,6 +469,7 @@
 #define TW_APACHE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 72 : 109)
 #define TW_ESCALADE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 41 : 62)
 #define TW_PADDING_LENGTH (sizeof(dma_addr_t) > 4 ? 8 : 0)
+#define TW_CPU_TO_SGL(x) (sizeof(dma_addr_t) > 4 ? cpu_to_le64(x) : cpu_to_le32(x))
 
 #pragma pack(1)
 
@@ -614,13 +613,6 @@
 	u32 value;
 } TW_Response_Queue;
 
-typedef struct TAG_TW_Info {
-	char *buffer;
-	int length;
-	int offset;
-	int position;
-} TW_Info;
-
 /* Compatibility information structure */
 typedef struct TAG_TW_Compatibility_Info
 {
@@ -636,6 +628,8 @@
 	unsigned short driver_build_low;
 } TW_Compatibility_Info;
 
+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
 	u32                     __iomem *base_addr;
 	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
@@ -679,7 +673,5 @@
 	unsigned short		working_build;
 } TW_Device_Extension;
 
-#pragma pack()
-
 #endif /* _3W_9XXX_H */
 

------=_Part_10627_20941906.1142455399894--
