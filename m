Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F94C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 12:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiD0MaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiD0MaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 08:30:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607724AE31
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 05:27:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q8so1409613plx.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 05:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=sL93LAI/DwRt3nniBBG3i0px1z7k7J2na43aFZg+o0M=;
        b=DV7r9bLRDlt96San7R1GvGrZVEG4cn+ph0eBy983aaIV5evOoUj/bltvJKoIopfQ43
         IfdXN0Zjy8LXPtrCCWkElMHOQtsC6vcZw0JSdqpAyRas7S7m2acXqb/N7CNM9spqMa8E
         IIpYXpuGGsLyaAdqOZduFGo5SZV9QHYBnG9v4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=sL93LAI/DwRt3nniBBG3i0px1z7k7J2na43aFZg+o0M=;
        b=MDn8CO3diwHXoipC0KgokbrewhaYkE9RXgdLl3RtYk2nEfnHq+a4jGXxDvb4P6UNqz
         4+cfSPhejwz0KDH/VcawJoG5MDGC0ALGNTb0DlMXp2VRlLZIBKswC8nzoB/NoifvT301
         Ha6R3yiemYPINToEWx+4QGJCpMRjlcIY4XqSrvWDuZTvRQWvh/HAfdURDD74gh1XW/ll
         catJGYEILAKJKYhDm7GjMxZSQUymLVOMozYB5UVWIlSpI9WsQ+GkVtrdaIvfFVpLNXpW
         bbTn3k4eSA5+RIpmSihYzWxs7gfO+1wgJq2z/9PfBkA+r5uEW7jGreZtK0Q+xjHNthto
         DX4Q==
X-Gm-Message-State: AOAM5308gDoInqJzlCjwK+Tayvd8BHvhAU/Zvs1cQUoLAqOjVumEub77
        n0QfLNJzldN+JpzVgUiRoI9KisMv7WEpkLaSB9CKp9ztlU9rYuvi3ciiviKPxZ7D5V1wbSMzaB6
        gEgRL7IE1K3cdNAHj2OugE5C1I2Go3WsxwhecudajOFkjsXopDgpuT+70jaGx30XEy+sC/Lquj6
        steBZi5uI=
X-Google-Smtp-Source: ABdhPJzXNC0SJiVpLbSubQyYO95SeF8EopcYNTSfvG4/6Y5mbzuKZ7wPl+s/5nSTjkZj3FbslOBFpQ==
X-Received: by 2002:a17:903:213:b0:156:7efe:4783 with SMTP id r19-20020a170903021300b001567efe4783mr28406966plh.126.1651062423381;
        Wed, 27 Apr 2022 05:27:03 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h195-20020a6283cc000000b0050d2c0729b0sm14088296pfe.18.2022.04.27.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 05:27:02 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] uapi: Fix build errors in uapi header scsi_bsg_mpi3mr.h
Date:   Wed, 27 Apr 2022 08:26:22 -0400
Message-Id: <20220427122622.543126-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000047502f05dda1edc9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000047502f05dda1edc9
Content-Transfer-Encoding: 8bit

Fixed build errors reported during x86_64 allmodconfig and few spaces to
tabs conversions.

Fixes: a212ebe7d4b1 ("scsi: mpi3mr: Add support for driver commands")
Fixes: 455aac4f7a13 ("scsi: mpi3mr: Move data structures/definitions from MPI headers to uapi header")

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 include/uapi/scsi/scsi_bsg_mpi3mr.h | 292 ++++++++++++++--------------
 1 file changed, 147 insertions(+), 145 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index 46c33efcff19..fdc3517f9e19 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -10,6 +10,8 @@
 #ifndef SCSI_BSG_MPI3MR_H_INCLUDED
 #define SCSI_BSG_MPI3MR_H_INCLUDED
 
+#include <linux/types.h>
+
 /* Definitions for BSG commands */
 #define MPI3MR_IOCTL_VERSION			0x06
 
@@ -93,14 +95,14 @@ enum command {
  * @driver_capabilities: Driver capabilities
  */
 struct mpi3_driver_info_layout {
-	__le32             information_length;
-	u8                 driver_signature[12];
-	u8                 os_name[16];
-	u8                 os_version[12];
-	u8                 driver_name[20];
-	u8                 driver_version[32];
-	u8                 driver_release_date[20];
-	__le32             driver_capabilities;
+	__le32	information_length;
+	__u8	driver_signature[12];
+	__u8	os_name[16];
+	__u8	os_version[12];
+	__u8	driver_name[20];
+	__u8	driver_version[32];
+	__u8	driver_release_date[20];
+	__le32	driver_capabilities;
 };
 
 /**
@@ -125,22 +127,22 @@ struct mpi3_driver_info_layout {
  * @driver_info: Driver Information (Version/Name)
  */
 struct mpi3mr_bsg_in_adpinfo {
-	uint32_t adp_type;
-	uint32_t rsvd1;
-	uint32_t pci_dev_id;
-	uint32_t pci_dev_hw_rev;
-	uint32_t pci_subsys_dev_id;
-	uint32_t pci_subsys_ven_id;
-	uint32_t pci_dev:5;
-	uint32_t pci_func:3;
-	uint32_t pci_bus:8;
-	uint16_t rsvd2;
-	uint32_t pci_seg_id;
-	uint32_t app_intfc_ver;
-	uint8_t adp_state;
-	uint8_t rsvd3;
-	uint16_t rsvd4;
-	uint32_t rsvd5[2];
+	__u32	adp_type;
+	__u32	rsvd1;
+	__u32	pci_dev_id;
+	__u32	pci_dev_hw_rev;
+	__u32	pci_subsys_dev_id;
+	__u32	pci_subsys_ven_id;
+	__u32	pci_dev:5;
+	__u32	pci_func:3;
+	__u32	pci_bus:8;
+	__u16	rsvd2;
+	__u32	pci_seg_id;
+	__u32	app_intfc_ver;
+	__u8	adp_state;
+	__u8	rsvd3;
+	__u16	rsvd4;
+	__u32	rsvd5[2];
 	struct mpi3_driver_info_layout driver_info;
 };
 
@@ -153,9 +155,9 @@ struct mpi3mr_bsg_in_adpinfo {
  * @rsvd2: Reserved
  */
 struct mpi3mr_bsg_adp_reset {
-	uint8_t reset_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
+	__u8	reset_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
 };
 
 /**
@@ -166,8 +168,8 @@ struct mpi3mr_bsg_adp_reset {
  * @rsvd: Reserved
  */
 struct mpi3mr_change_count {
-	uint16_t change_count;
-	uint16_t rsvd;
+	__u16	change_count;
+	__u16	rsvd;
 };
 
 /**
@@ -182,12 +184,12 @@ struct mpi3mr_change_count {
  * @rsvd2: Reserved
  */
 struct mpi3mr_device_map_info {
-	uint16_t handle;
-	uint16_t perst_id;
-	uint32_t target_id;
-	uint8_t bus_id;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
+	__u16	handle;
+	__u16	perst_id;
+	__u32	target_id;
+	__u8	bus_id;
+	__u8	rsvd1;
+	__u16	rsvd2;
 };
 
 /**
@@ -200,9 +202,9 @@ struct mpi3mr_device_map_info {
  * @dmi: Variable length array of mapping information of targets
  */
 struct mpi3mr_all_tgt_info {
-	uint16_t num_devices;
-	uint16_t rsvd1;
-	uint32_t rsvd2;
+	__u16	num_devices;
+	__u16	rsvd1;
+	__u32	rsvd2;
 	struct mpi3mr_device_map_info dmi[1];
 };
 
@@ -215,8 +217,8 @@ struct mpi3mr_all_tgt_info {
  * @rsvd: Reserved
  */
 struct mpi3mr_logdata_enable {
-	uint16_t max_entries;
-	uint16_t rsvd;
+	__u16	max_entries;
+	__u16	rsvd;
 };
 
 /**
@@ -228,9 +230,9 @@ struct mpi3mr_logdata_enable {
  * @rsvd: Reserved
  */
 struct mpi3mr_bsg_out_pel_enable {
-	uint16_t pel_locale;
-	uint8_t pel_class;
-	uint8_t rsvd;
+	__u16	pel_locale;
+	__u8	pel_class;
+	__u8	rsvd;
 };
 
 /**
@@ -243,10 +245,10 @@ struct mpi3mr_bsg_out_pel_enable {
  * @data: Variable length Log entry data
  */
 struct mpi3mr_logdata_entry {
-	uint8_t valid_entry;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint8_t data[1]; /* Variable length Array */
+	__u8	valid_entry;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u8	data[1]; /* Variable length Array */
 };
 
 /**
@@ -274,15 +276,15 @@ struct mpi3mr_bsg_in_log_data {
  * @rsvd4: Reserved
  */
 struct mpi3mr_hdb_entry {
-	uint8_t buf_type;
-	uint8_t status;
-	uint8_t trigger_type;
-	uint8_t rsvd1;
-	uint16_t size;
-	uint16_t rsvd2;
-	uint64_t trigger_data;
-	uint32_t rsvd3;
-	uint32_t rsvd4;
+	__u8	buf_type;
+	__u8	status;
+	__u8	trigger_type;
+	__u8	rsvd1;
+	__u16	size;
+	__u16	rsvd2;
+	__u64	trigger_data;
+	__u32	rsvd3;
+	__u32	rsvd4;
 };
 
 
@@ -300,10 +302,10 @@ struct mpi3mr_hdb_entry {
  * @entry: Variable length Diag buffer status entry array
  */
 struct mpi3mr_bsg_in_hdb_status {
-	uint8_t num_hdb_types;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint32_t rsvd3;
+	__u8	num_hdb_types;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u32	rsvd3;
 	struct mpi3mr_hdb_entry entry[1];
 };
 
@@ -316,9 +318,9 @@ struct mpi3mr_bsg_in_hdb_status {
  * @rsvd2: Reserved
  */
 struct mpi3mr_bsg_out_repost_hdb {
-	uint8_t buf_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
+	__u8	buf_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
 };
 
 /**
@@ -332,11 +334,11 @@ struct mpi3mr_bsg_out_repost_hdb {
  * @length: Length of the buffer to copy
  */
 struct mpi3mr_bsg_out_upload_hdb {
-	uint8_t buf_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint32_t start_offset;
-	uint32_t length;
+	__u8	buf_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u32	start_offset;
+	__u32	length;
 };
 
 /**
@@ -348,9 +350,9 @@ struct mpi3mr_bsg_out_upload_hdb {
  * @rsvd2: Reserved
  */
 struct mpi3mr_bsg_out_refresh_hdb_triggers {
-	uint8_t page_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
+	__u8	page_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
 };
 /**
  * struct mpi3mr_bsg_drv_cmd -  Generic bsg data
@@ -362,10 +364,10 @@ struct mpi3mr_bsg_out_refresh_hdb_triggers {
  * @rsvd2: Reserved
  */
 struct mpi3mr_bsg_drv_cmd {
-	uint8_t mrioc_id;
-	uint8_t opcode;
-	uint16_t rsvd1;
-	uint32_t rsvd2[4];
+	__u8	mrioc_id;
+	__u8	opcode;
+	__u16	rsvd1;
+	__u32	rsvd2[4];
 };
 /**
  * struct mpi3mr_bsg_in_reply_buf - MPI reply buffer returned
@@ -377,10 +379,10 @@ struct mpi3mr_bsg_drv_cmd {
  * @reply_buf: Variable Length buffer based on mpirep type
  */
 struct mpi3mr_bsg_in_reply_buf {
-	uint8_t mpi_reply_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint8_t reply_buf[1];
+	__u8	mpi_reply_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u8	reply_buf[1];
 };
 
 /**
@@ -393,10 +395,10 @@ struct mpi3mr_bsg_in_reply_buf {
  * @buf_len: Buffer length
  */
 struct mpi3mr_buf_entry {
-	uint8_t buf_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint32_t buf_len;
+	__u8	buf_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u32	buf_len;
 };
 /**
  * struct mpi3mr_bsg_buf_entry_list - list of user buffer
@@ -409,10 +411,10 @@ struct mpi3mr_buf_entry {
  * @buf_entry: Variable length array of buffer descriptors
  */
 struct mpi3mr_buf_entry_list {
-	uint8_t num_of_entries;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint32_t rsvd3;
+	__u8	num_of_entries;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u32	rsvd3;
 	struct mpi3mr_buf_entry buf_entry[1];
 };
 /**
@@ -425,10 +427,10 @@ struct mpi3mr_buf_entry_list {
  * @buf_entry_list: Buffer descriptor list
  */
 struct mpi3mr_bsg_mptcmd {
-	uint8_t mrioc_id;
-	uint8_t rsvd1;
-	uint16_t timeout;
-	uint32_t rsvd2;
+	__u8	mrioc_id;
+	__u8	rsvd1;
+	__u16	timeout;
+	__u32	rsvd2;
 	struct mpi3mr_buf_entry_list buf_entry_list;
 };
 
@@ -443,10 +445,10 @@ struct mpi3mr_bsg_mptcmd {
  * @mptcmd: mpt request structure
  */
 struct mpi3mr_bsg_packet {
-	uint8_t cmd_type;
-	uint8_t rsvd1;
-	uint16_t rsvd2;
-	uint32_t rsvd3;
+	__u8	cmd_type;
+	__u8	rsvd1;
+	__u16	rsvd2;
+	__u32	rsvd3;
 	union {
 		struct mpi3mr_bsg_drv_cmd drvrcmd;
 		struct mpi3mr_bsg_mptcmd mptcmd;
@@ -460,32 +462,32 @@ struct mpi3mr_bsg_packet {
 #endif
 
 struct mpi3_nvme_encapsulated_request {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     change_count;
-	__le16                     dev_handle;
-	__le16                     encapsulated_command_length;
-	__le16                     flags;
-	__le32                     data_length;
-	__le32                     reserved14[3];
-	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
+	__le16	host_tag;
+	__u8	ioc_use_only02;
+	__u8	function;
+	__le16	ioc_use_only04;
+	__u8	ioc_use_only06;
+	__u8	msg_flags;
+	__le16	change_count;
+	__le16	dev_handle;
+	__le16	encapsulated_command_length;
+	__le16	flags;
+	__le32	data_length;
+	__le32  reserved14[3];
+	__le32	command[MPI3_NVME_ENCAP_CMD_MAX];
 };
 
 struct mpi3_nvme_encapsulated_error_reply {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     ioc_use_only08;
-	__le16                     ioc_status;
-	__le32                     ioc_log_info;
-	__le32                     nvme_completion_entry[4];
+	__le16	host_tag;
+	__u8	ioc_use_only02;
+	__u8	function;
+	__le16	ioc_use_only04;
+	__u8	ioc_use_only06;
+	__u8	msg_flags;
+	__le16	ioc_use_only08;
+	__le16	ioc_status;
+	__le32	ioc_log_info;
+	__le32	nvme_completion_entry[4];
 };
 
 #define	MPI3MR_NVME_PRP_SIZE		8 /* PRP size */
@@ -498,21 +500,21 @@ struct mpi3_nvme_encapsulated_error_reply {
 
 /* MPI3: task management related definitions */
 struct mpi3_scsi_task_mgmt_request {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     change_count;
-	__le16                     dev_handle;
-	__le16                     task_host_tag;
-	u8                         task_type;
-	u8                         reserved0f;
-	__le16                     task_request_queue_id;
-	__le16                     reserved12;
-	__le32                     reserved14;
-	u8                         lun[8];
+	__le16	host_tag;
+	__u8	ioc_use_only02;
+	__u8	function;
+	__le16	ioc_use_only04;
+	__u8	ioc_use_only06;
+	__u8    msg_flags;
+	__le16	change_count;
+	__le16	dev_handle;
+	__le16	task_host_tag;
+	__u8	task_type;
+	__u8	reserved0f;
+	__le16	task_request_queue_id;
+	__le16	reserved12;
+	__le32	reserved14;
+	__u8	lun[8];
 };
 
 #define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
@@ -527,18 +529,18 @@ struct mpi3_scsi_task_mgmt_request {
 #define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
 #define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
 struct mpi3_scsi_task_mgmt_reply {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     ioc_use_only08;
-	__le16                     ioc_status;
-	__le32                     ioc_log_info;
-	__le32                     termination_count;
-	__le32                     response_data;
-	__le32                     reserved18;
+	__le16	host_tag;
+	__u8	ioc_use_only02;
+	__u8	function;
+	__le16  ioc_use_only04;
+	__u8	ioc_use_only06;
+	__u8	msg_flags;
+	__le16	ioc_use_only08;
+	__le16	ioc_status;
+	__le32	ioc_log_info;
+	__le32	termination_count;
+	__le32	response_data;
+	__le32	reserved18;
 };
 
 #define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
-- 
2.27.0


--00000000000047502f05dda1edc9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPSv1u3aRqyzTUI9pCmSsEzqayRrTs2k
NibynuYZffKXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQy
NzEyMjcwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCCq0i6SZRvLV2UjE7GmLspmzoVT8Kv8roNFlatZTzHavUutDW8
6TjmwtTR9Mu7st4xUnVR2ZWIrhSCkLELoqWuZkYpiaIET3kk+JLL6+3PZvREJX+0F1QcwoGjNmQj
4GzfuVaj81wksw3oDRBedehTc+Lrl5hkW75mBAydV+gb4rupp6mUUfWSD4NlPPOBJmyhPddev4uq
m77ARaMFt+7gTnKdepaO4EXAP1DUYnyWDQaJjPxeDZ/I9Tz4MWEWhHQjAt/aQ1oWEcSOdw4R2cQX
hlWcmQCc3Z3n4RbgzZCpeiR8TVee51ZjyRRoo5xeyUBR+mkmBu4Ug8bmWioMA5GV
--00000000000047502f05dda1edc9--
