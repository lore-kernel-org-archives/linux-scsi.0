From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] isci: kill dead data structurs in scic_io_request.h
Date: Thu, 31 Mar 2011 11:01:39 -0400
Message-ID: <20110331150139.GA8497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab1CaPBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 11:01:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/scic_io_request.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_io_request.h	2011-03-30 20:31:31.631658840 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_io_request.h	2011-03-30 20:33:29.867732865 +0200
@@ -72,186 +72,6 @@ struct scic_sds_remote_device;
 struct scic_sds_controller;
 
 /**
- * struct scic_io_parameters - This structure contains additional optional
- *    parameters for SSP IO requests.  These parameters are utilized with the
- *    scic_io_request_construct_advanced_ssp() method.
- *
- * Add Block-guard/DIF, TLR
- */
-struct scic_io_parameters {
-	/**
-	 * This sub-structure contains SCSI specific features (for use with SSP
-	 * IO requests).
-	 */
-	struct {
-		/**
-		 * Data Integrity Format (DIF) is also known as protection information
-		 * or block-guard.  This sub-structure contains DIF specific feature
-		 * information for SSP IO requests.
-		 */
-		struct {
-			void *placeholder;
-		} dif;
-
-		/**
-		 * Transport Layer Retries (TLR) is an SSP protocol specific feature.
-		 * This sub-structure contains Transport Layer Retries (TLR) specific
-		 * feature information for SSP IO requests.
-		 */
-		struct {
-			void *placeholder;
-		} tlr;
-
-	} scsi;
-
-};
-
-/**
- * struct scic_passthru_request_callbacks - This structure contains the pointer
- *    to the callback functions for constructing the passthrough request common
- *    to SSP, SMP and STP. This structure must be set by the win sci layer
- *    before the passthrough build is called
- *
- *
- */
-struct scic_passthru_request_callbacks {
-	/**
-	 * Function pointer to get the phy identifier for passthrough request.
-	 */
-	u32 (*scic_cb_passthru_get_phy_identifier)(void *, u8 *);
-	/**
-	 * Function pointer to get the port identifier for passthrough request.
-	 */
-	u32 (*scic_cb_passthru_get_port_identifier)(void *, u8 *);
-	/**
-	 * Function pointer to get the connection rate for passthrough request.
-	 */
-	u32 (*scic_cb_passthru_get_connection_rate)(void *, void *);
-	/**
-	 * Function pointer to get the destination sas address for passthrough request.
-	 */
-	void (*scic_cb_passthru_get_destination_sas_address)(void *, u8 **);
-	/**
-	 * Function pointer to get the transfer length for passthrough request.
-	 */
-	u32 (*scic_cb_passthru_get_transfer_length)(void *);
-	/**
-	 * Function pointer to get the data direction for passthrough request.
-	 */
-	u32 (*scic_cb_passthru_get_data_direction)(void *);
-
-};
-
-/**
- * struct scic_ssp_passthru_request_callbacks - This structure contains the
- *    pointer to the callback functions for constructing the passthrough
- *    request specific to SSP. This structure must be set by the win sci layer
- *    before the passthrough build is called
- *
- *
- */
-struct scic_ssp_passthru_request_callbacks {
-	/**
-	 * Common callbacks for all Passthru requests
-	 */
-	struct scic_passthru_request_callbacks common_callbacks;
-	/**
-	 * Function pointer to get the lun for passthrough request.
-	 */
-	void (*scic_cb_ssp_passthru_get_lun)(void *, u8 **);
-	/**
-	 * Function pointer to get the cdb
-	 */
-	void (*scic_cb_ssp_passthru_get_cdb)(void *, u32 *, u8 **, u32 *, u8 **);
-	/**
-	 * Function pointer to get the task attribute for passthrough request.
-	 */
-	u32 (*scic_cb_ssp_passthru_get_task_attribute)(void *);
-};
-
-/**
- * struct scic_stp_passthru_request_callbacks - This structure contains the
- *    pointer to the callback functions for constructing the passthrough
- *    request specific to STP. This structure must be set by the win sci layer
- *    before the passthrough build is called
- *
- *
- */
-struct scic_stp_passthru_request_callbacks {
-	/**
-	 * Common callbacks for all Passthru requests
-	 */
-	struct scic_passthru_request_callbacks common_callbacks;
-	/**
-	 * Function pointer to get the protocol for passthrough request.
-	 */
-	u8 (*scic_cb_stp_passthru_get_protocol)(void *);
-	/**
-	 * Function pointer to get the resgister fis
-	 */
-	void (*scic_cb_stp_passthru_get_register_fis)(void *, u8 **);
-	/**
-	 * Function pointer to get the MULTIPLE_COUNT (bits 5,6,7 in Byte 1 in the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_multiplecount)(void *);
-	/**
-	 * Function pointer to get the EXTEND (bit 0 in Byte 1 the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_extend)(void *);
-	/**
-	 * Function pointer to get the CK_COND (bit 5 in Byte 2 the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_ckcond)(void *);
-	/**
-	 * Function pointer to get the T_DIR (bit 3 in Byte 2 the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_tdir)(void *);
-	/**
-	 * Function pointer to get the BYTE_BLOCK (bit 2 in Byte 2 the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_byteblock)(void *);
-	/**
-	 * Function pointer to get the T_LENGTH (bits 0,1 in Byte 2 the SAT-specific SCSI extenstion in ATA Pass-through (0x85))
-	 */
-	u8 (*scic_cb_stp_passthru_get_tlength)(void *);
-
-};
-
-/**
- * struct scic_smp_passthru_request_callbacks - This structure contains the
- *    pointer to the callback functions for constructing the passthrough
- *    request specific to SMP. This structure must be set by the win sci layer
- *    before the passthrough build is called
- *
- *
- */
-struct scic_smp_passthru_request_callbacks {
-	/**
-	 * Common callbacks for all Passthru requests
-	 */
-	struct scic_passthru_request_callbacks common_callbacks;
-
-	/**
-	 * Function pointer to get the length of the smp request and its length
-	 */
-	u32 (*scic_cb_smp_passthru_get_request)(void *, u8 **);
-	/**
-	 * Function pointer to get the frame type of the smp request
-	 */
-	u8 (*scic_cb_smp_passthru_get_frame_type)(void *);
-	/**
-	 * Function pointer to get the function in the the smp request
-	 */
-	u8 (*scic_cb_smp_passthru_get_function)(void *);
-
-	/**
-	 * Function pointer to get the "allocated response length" in the the smp request
-	 */
-	u8 (*scic_cb_smp_passthru_get_allocated_response_length)(void *);
-
-};
-
-/**
  * This enumeration specifies the transport protocol utilized for the request.
  *
  *
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_request.h	2011-03-30 20:32:31.295162747 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.h	2011-03-30 20:32:42.071158159 +0200
@@ -176,10 +176,6 @@ enum sci_status scic_sds_stp_pio_request
 	u8 sat_protocol,
 	bool copy_rx_frame);
 
-enum sci_status scic_sds_stp_pio_request_construct_pass_through(
-	struct scic_sds_request *scic_io_request,
-	struct scic_stp_passthru_request_callbacks *passthru_cb);
-
 enum sci_status scic_sds_stp_udma_request_construct(
 	struct scic_sds_request *this_request,
 	u32 transfer_length,
