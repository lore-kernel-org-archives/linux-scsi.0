From: brking@us.ibm.com
Subject: [PATCH 12/15] ipr: Use bitwise types
Date: Mon, 21 Feb 2005 15:09:42 -0600
Message-ID: <200502212109.j1LL9g4l004034@d03av04.boulder.ibm.com>
Received: from e35.co.us.ibm.com ([32.97.110.133]:36073 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262131AbVBUVJq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:46 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL9iLg492360
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:44 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9hSi154286
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:43 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9hHZ004061
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Change to use bitwise types for additional error checking by sparse


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |  166 ++++++++++++------------
 1 files changed, 83 insertions(+), 83 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_bitwise_types drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_bitwise_types	2005-02-21 13:16:22.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:16:22.000000000 -0600
@@ -305,8 +305,8 @@ struct ipr_config_table_entry {
 #define IPR_SUBTYPE_VOLUME_SET		2
 
 	struct ipr_res_addr res_addr;
-	u32 res_handle;
-	u32 reserved4[2];
+	__be32 res_handle;
+	__be32 reserved4[2];
 	struct ipr_std_inq_data std_inq_data;
 }__attribute__ ((packed, aligned (4)));
 
@@ -314,7 +314,7 @@ struct ipr_config_table_hdr {
 	u8 num_entries;
 	u8 flags;
 #define IPR_UCODE_DOWNLOAD_REQ	0x10
-	u16 reserved;
+	__be16 reserved;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_config_table {
@@ -328,7 +328,7 @@ struct ipr_hostrcb_cfg_ch_not {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_supported_device {
-	u16 data_length;
+	__be16 data_length;
 	u8 reserved;
 	u8 num_records;
 	struct ipr_std_inq_vpids vpids;
@@ -337,7 +337,7 @@ struct ipr_supported_device {
 
 /* Command packet structure */
 struct ipr_cmd_pkt {
-	u16 reserved;		/* Reserved by IOA */
+	__be16 reserved;		/* Reserved by IOA */
 	u8 request_type;
 #define IPR_RQTYPE_SCSICDB		0x00
 #define IPR_RQTYPE_IOACMD		0x01
@@ -362,38 +362,38 @@ struct ipr_cmd_pkt {
 #define IPR_FLAGS_LO_ACA_TASK			0x08
 
 	u8 cdb[16];
-	u16 timeout;
+	__be16 timeout;
 }__attribute__ ((packed, aligned(4)));
 
 /* IOA Request Control Block    128 bytes  */
 struct ipr_ioarcb {
-	u32 ioarcb_host_pci_addr;
-	u32 reserved;
-	u32 res_handle;
-	u32 host_response_handle;
-	u32 reserved1;
-	u32 reserved2;
-	u32 reserved3;
-
-	u32 write_data_transfer_length;
-	u32 read_data_transfer_length;
-	u32 write_ioadl_addr;
-	u32 write_ioadl_len;
-	u32 read_ioadl_addr;
-	u32 read_ioadl_len;
-
-	u32 ioasa_host_pci_addr;
-	u16 ioasa_len;
-	u16 reserved4;
+	__be32 ioarcb_host_pci_addr;
+	__be32 reserved;
+	__be32 res_handle;
+	__be32 host_response_handle;
+	__be32 reserved1;
+	__be32 reserved2;
+	__be32 reserved3;
+
+	__be32 write_data_transfer_length;
+	__be32 read_data_transfer_length;
+	__be32 write_ioadl_addr;
+	__be32 write_ioadl_len;
+	__be32 read_ioadl_addr;
+	__be32 read_ioadl_len;
+
+	__be32 ioasa_host_pci_addr;
+	__be16 ioasa_len;
+	__be16 reserved4;
 
 	struct ipr_cmd_pkt cmd_pkt;
 
-	u32 add_cmd_parms_len;
-	u32 add_cmd_parms[10];
+	__be32 add_cmd_parms_len;
+	__be32 add_cmd_parms[10];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioadl_desc {
-	u32 flags_and_data_len;
+	__be32 flags_and_data_len;
 #define IPR_IOADL_FLAGS_MASK		0xff000000
 #define IPR_IOADL_GET_FLAGS(x) (be32_to_cpu(x) & IPR_IOADL_FLAGS_MASK)
 #define IPR_IOADL_DATA_LEN_MASK		0x00ffffff
@@ -404,55 +404,55 @@ struct ipr_ioadl_desc {
 #define IPR_IOADL_FLAGS_WRITE_LAST	0x69000000
 #define IPR_IOADL_FLAGS_LAST		0x01000000
 
-	u32 address;
+	__be32 address;
 }__attribute__((packed, aligned (8)));
 
 struct ipr_ioasa_vset {
-	u32 failing_lba_hi;
-	u32 failing_lba_lo;
-	u32 ioa_data[22];
+	__be32 failing_lba_hi;
+	__be32 failing_lba_lo;
+	__be32 ioa_data[22];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa_af_dasd {
-	u32 failing_lba;
+	__be32 failing_lba;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa_gpdd {
 	u8 end_state;
 	u8 bus_phase;
-	u16 reserved;
-	u32 ioa_data[23];
+	__be16 reserved;
+	__be32 ioa_data[23];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa_raw {
-	u32 ioa_data[24];
+	__be32 ioa_data[24];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa {
-	u32 ioasc;
+	__be32 ioasc;
 #define IPR_IOASC_SENSE_KEY(ioasc) ((ioasc) >> 24)
 #define IPR_IOASC_SENSE_CODE(ioasc) (((ioasc) & 0x00ff0000) >> 16)
 #define IPR_IOASC_SENSE_QUAL(ioasc) (((ioasc) & 0x0000ff00) >> 8)
 #define IPR_IOASC_SENSE_STATUS(ioasc) ((ioasc) & 0x000000ff)
 
-	u16 ret_stat_len;	/* Length of the returned IOASA */
+	__be16 ret_stat_len;	/* Length of the returned IOASA */
 
-	u16 avail_stat_len;	/* Total Length of status available. */
+	__be16 avail_stat_len;	/* Total Length of status available. */
 
-	u32 residual_data_len;	/* number of bytes in the host data */
+	__be32 residual_data_len;	/* number of bytes in the host data */
 	/* buffers that were not used by the IOARCB command. */
 
-	u32 ilid;
+	__be32 ilid;
 #define IPR_NO_ILID			0
 #define IPR_DRIVER_ILID		0xffffffff
 
-	u32 fd_ioasc;
+	__be32 fd_ioasc;
 
-	u32 fd_phys_locator;
+	__be32 fd_phys_locator;
 
-	u32 fd_res_handle;
+	__be32 fd_res_handle;
 
-	u32 ioasc_specific;	/* status code specific field */
+	__be32 ioasc_specific;	/* status code specific field */
 #define IPR_IOASC_SPECIFIC_MASK		0x00ffffff
 #define IPR_FIELD_POINTER_VALID		(0x80000000 >> 8)
 #define IPR_FIELD_POINTER_MASK		0x0000ffff
@@ -500,11 +500,11 @@ struct ipr_dev_bus_entry {
 	u8 extended_reset_delay;
 #define IPR_EXTENDED_RESET_DELAY	7
 
-	u32 max_xfer_rate;
+	__be32 max_xfer_rate;
 
 	u8 spinup_delay;
 	u8 reserved3;
-	u16 reserved4;
+	__be16 reserved4;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_mode_page28 {
@@ -546,7 +546,7 @@ struct ipr_hostrcb_device_data_entry {
 	u8 ioa_last_with_dev_sn[IPR_SERIAL_NUM_LEN];
 	struct ipr_std_inq_vpids cfc_last_with_dev_vpids;
 	u8 cfc_last_with_dev_sn[IPR_SERIAL_NUM_LEN];
-	u32 ioa_data[5];
+	__be32 ioa_data[5];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_array_data_entry {
@@ -557,14 +557,14 @@ struct ipr_hostrcb_array_data_entry {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_ff_error {
-	u32 ioa_data[246];
+	__be32 ioa_data[246];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_01_error {
-	u32 seek_counter;
-	u32 read_counter;
+	__be32 seek_counter;
+	__be32 read_counter;
 	u8 sense_data[32];
-	u32 ioa_data[236];
+	__be32 ioa_data[236];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_02_error {
@@ -576,7 +576,7 @@ struct ipr_hostrcb_type_02_error {
 	u8 ioa_last_attached_to_cfc_sn[IPR_SERIAL_NUM_LEN];
 	struct ipr_std_inq_vpids cfc_last_attached_to_ioa_vpids;
 	u8 cfc_last_attached_to_ioa_sn[IPR_SERIAL_NUM_LEN];
-	u32 ioa_data[3];
+	__be32 ioa_data[3];
 	u8 reserved[844];
 }__attribute__((packed, aligned (4)));
 
@@ -585,8 +585,8 @@ struct ipr_hostrcb_type_03_error {
 	u8 ioa_sn[IPR_SERIAL_NUM_LEN];
 	struct ipr_std_inq_vpids cfc_vpids;
 	u8 cfc_sn[IPR_SERIAL_NUM_LEN];
-	u32 errors_detected;
-	u32 errors_logged;
+	__be32 errors_detected;
+	__be32 errors_logged;
 	u8 ioa_data[12];
 	struct ipr_hostrcb_device_data_entry dev_entry[3];
 	u8 reserved[444];
@@ -599,11 +599,11 @@ struct ipr_hostrcb_type_04_error {
 	u8 cfc_sn[IPR_SERIAL_NUM_LEN];
 	u8 ioa_data[12];
 	struct ipr_hostrcb_array_data_entry array_member[10];
-	u32 exposed_mode_adn;
-	u32 array_id;
+	__be32 exposed_mode_adn;
+	__be32 array_id;
 	struct ipr_std_inq_vpids incomp_dev_vpids;
 	u8 incomp_dev_sn[IPR_SERIAL_NUM_LEN];
-	u32 ioa_data2;
+	__be32 ioa_data2;
 	struct ipr_hostrcb_array_data_entry array_member2[8];
 	struct ipr_res_addr last_func_vset_res_addr;
 	u8 vset_serial_num[IPR_SERIAL_NUM_LEN];
@@ -612,10 +612,10 @@ struct ipr_hostrcb_type_04_error {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_error {
-	u32 failing_dev_ioasc;
+	__be32 failing_dev_ioasc;
 	struct ipr_res_addr failing_dev_res_addr;
-	u32 failing_dev_res_handle;
-	u32 prc;
+	__be32 failing_dev_res_handle;
+	__be32 prc;
 	union {
 		struct ipr_hostrcb_type_ff_error type_ff_error;
 		struct ipr_hostrcb_type_01_error type_01_error;
@@ -626,7 +626,7 @@ struct ipr_hostrcb_error {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_raw {
-	u32 data[sizeof(struct ipr_hostrcb_error)/sizeof(u32)];
+	__be32 data[sizeof(struct ipr_hostrcb_error)/sizeof(__be32)];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hcam {
@@ -658,10 +658,10 @@ struct ipr_hcam {
 #define IPR_HOST_RCB_OVERLAY_ID_DEFAULT			0xFF
 
 	u8 reserved1[3];
-	u32 ilid;
-	u32 time_since_last_ioa_reset;
-	u32 reserved2;
-	u32 length;
+	__be32 ilid;
+	__be32 time_since_last_ioa_reset;
+	__be32 reserved2;
+	__be32 length;
 
 	union {
 		struct ipr_hostrcb_error error;
@@ -678,8 +678,8 @@ struct ipr_hostrcb {
 
 /* IPR smart dump table structures */
 struct ipr_sdt_entry {
-	u32 bar_str_offset;
-	u32 end_offset;
+	__be32 bar_str_offset;
+	__be32 end_offset;
 	u8 entry_byte;
 	u8 reserved[3];
 
@@ -688,14 +688,14 @@ struct ipr_sdt_entry {
 #define IPR_SDT_VALID_ENTRY	0x20
 
 	u8 resv;
-	u16 priority;
+	__be16 priority;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_sdt_header {
-	u32 state;
-	u32 num_entries;
-	u32 num_entries_used;
-	u32 dump_size;
+	__be32 state;
+	__be32 num_entries;
+	__be32 num_entries_used;
+	__be32 dump_size;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_sdt {
@@ -802,7 +802,7 @@ struct ipr_trace_entry {
 #define IPR_TRACE_FINISH		0xff
 	u16 cmd_index;
 
-	u32 res_handle;
+	__be32 res_handle;
 	union {
 		u32 ioasc;
 		u32 add_data;
@@ -887,15 +887,15 @@ struct ipr_ioa_cfg {
 	struct list_head hostrcb_free_q;
 	struct list_head hostrcb_pending_q;
 
-	u32 *host_rrq;
+	__be32 *host_rrq;
 	dma_addr_t host_rrq_dma;
 #define IPR_HRRQ_REQ_RESP_HANDLE_MASK	0xfffffffc
 #define IPR_HRRQ_RESP_BIT_SET			0x00000002
 #define IPR_HRRQ_TOGGLE_BIT				0x00000001
 #define IPR_HRRQ_REQ_RESP_HANDLE_SHIFT	2
-	volatile u32 *hrrq_start;
-	volatile u32 *hrrq_end;
-	volatile u32 *hrrq_curr;
+	volatile __be32 *hrrq_start;
+	volatile __be32 *hrrq_end;
+	volatile __be32 *hrrq_curr;
 	volatile u32 toggle_bit;
 
 	struct ipr_bus_attributes bus_attr[IPR_MAX_NUM_BUSES];
@@ -1040,7 +1040,7 @@ struct ipr_driver_dump {
 struct ipr_ioa_dump {
 	struct ipr_dump_entry_header hdr;
 	struct ipr_sdt sdt;
-	u32 *ioa_data[IPR_MAX_NUM_DUMP_PAGES];
+	__be32 *ioa_data[IPR_MAX_NUM_DUMP_PAGES];
 	u32 reserved;
 	u32 next_page_index;
 	u32 page_offset;
@@ -1064,19 +1064,19 @@ struct ipr_error_table_t {
 };
 
 struct ipr_software_inq_lid_info {
-	u32 load_id;
-	u32 timestamp[3];
+	__be32 load_id;
+	__be32 timestamp[3];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ucode_image_header {
-	u32 header_length;
-	u32 lid_table_offset;
+	__be32 header_length;
+	__be32 lid_table_offset;
 	u8 major_release;
 	u8 card_type;
 	u8 minor_release[2];
 	u8 reserved[20];
 	char eyecatcher[16];
-	u32 num_lids;
+	__be32 num_lids;
 	struct ipr_software_inq_lid_info lid[1];
 }__attribute__((packed, aligned (4)));
 
_
