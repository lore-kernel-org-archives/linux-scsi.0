From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 10/10] isci/core: common definitions and utility functions
Date: Thu, 10 Mar 2011 02:55:11 -0800
Message-ID: <20110310105511.6485.41512.stgit@localhost6.localdomain6>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51920 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1CJKxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:55 -0500
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Many of these want to be deleted in favor of the in-kernel equivalent.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/core/intel_ata.h                |  554 ++++++++++++
 drivers/scsi/isci/core/intel_sas.h                |  948 +++++++++++++++++++++
 drivers/scsi/isci/core/intel_sat.h                |   95 ++
 drivers/scsi/isci/core/intel_sata.h               |  280 ++++++
 drivers/scsi/isci/core/intel_scsi.h               |  474 +++++++++++
 drivers/scsi/isci/core/sati_device.h              |  156 +++
 drivers/scsi/isci/core/sati_translator_sequence.h |  304 +++++++
 drivers/scsi/isci/core/sati_types.h               |  145 +++
 drivers/scsi/isci/core/sci_pool.h                 |  199 ++++
 drivers/scsi/isci/core/sci_status.h               |  409 +++++++++
 drivers/scsi/isci/core/sci_util.c                 |  101 ++
 drivers/scsi/isci/core/sci_util.h                 |  108 ++
 drivers/scsi/isci/core/scic_config_parameters.h   |  346 ++++++++
 drivers/scsi/isci/core/scic_sds_pci.h             |   94 ++
 14 files changed, 4213 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/intel_ata.h
 create mode 100644 drivers/scsi/isci/core/intel_sas.h
 create mode 100644 drivers/scsi/isci/core/intel_sat.h
 create mode 100644 drivers/scsi/isci/core/intel_sata.h
 create mode 100644 drivers/scsi/isci/core/intel_scsi.h
 create mode 100644 drivers/scsi/isci/core/sati_device.h
 create mode 100644 drivers/scsi/isci/core/sati_translator_sequence.h
 create mode 100644 drivers/scsi/isci/core/sati_types.h
 create mode 100644 drivers/scsi/isci/core/sci_pool.h
 create mode 100644 drivers/scsi/isci/core/sci_status.h
 create mode 100644 drivers/scsi/isci/core/sci_util.c
 create mode 100644 drivers/scsi/isci/core/sci_util.h
 create mode 100644 drivers/scsi/isci/core/scic_config_parameters.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_pci.h

diff --git a/drivers/scsi/isci/core/intel_ata.h b/drivers/scsi/isci/core/intel_ata.h
new file mode 100644
index 0000000..48b297e
--- /dev/null
+++ b/drivers/scsi/isci/core/intel_ata.h
@@ -0,0 +1,554 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+/**
+ * This file defines all of the ATA related constants, enumerations, and types.
+ *     Please note that this file does not necessarily contain an exhaustive
+ *    list of all constants, commands, sub-commands, etc.
+ *
+ *
+ */
+
+#ifndef _ATA_H_
+#define _ATA_H_
+
+#include <linux/types.h>
+
+/**
+ *
+ *
+ * ATA_COMMAND_CODES These constants depict the various ATA command codes
+ * defined in the ATA/ATAPI specification.
+ */
+#define ATA_IDENTIFY_DEVICE         0xEC
+#define ATA_CHECK_POWER_MODE        0xE5
+#define ATA_STANDBY                 0xE2
+#define ATA_STANDBY_IMMED           0xE0
+#define ATA_IDLE_IMMED              0xE1
+#define ATA_IDLE                    0xE3
+#define ATA_FLUSH_CACHE             0xE7
+#define ATA_FLUSH_CACHE_EXT         0xEA
+#define ATA_READ_DMA_EXT            0x25
+#define ATA_READ_DMA                0xC8
+#define ATA_READ_SECTORS_EXT        0x24
+#define ATA_READ_SECTORS            0x20
+#define ATA_WRITE_DMA_EXT           0x35
+#define ATA_WRITE_DMA               0xCA
+#define ATA_WRITE_SECTORS_EXT       0x34
+#define ATA_WRITE_SECTORS           0x30
+#define ATA_WRITE_UNCORRECTABLE     0x45
+#define ATA_READ_VERIFY_SECTORS     0x40
+#define ATA_READ_VERIFY_SECTORS_EXT 0x42
+#define ATA_READ_BUFFER             0xE4
+#define ATA_WRITE_BUFFER            0xE8
+#define ATA_EXECUTE_DEVICE_DIAG     0x90
+#define ATA_SET_FEATURES            0xEF
+#define ATA_SMART                   0xB0
+#define ATA_PACKET_IDENTIFY         0xA1
+#define ATA_PACKET                  0xA0
+#define ATA_READ_FPDMA              0x60
+#define ATA_WRITE_FPDMA             0x61
+#define ATA_READ_LOG_EXT            0x2F
+#define ATA_NOP                     0x00
+#define ATA_DEVICE_RESET            0x08
+#define ATA_MEDIA_EJECT             0xED
+
+/**
+ *
+ *
+ * ATA_SMART_SUB_COMMAND_CODES These constants define the ATA SMART command
+ * sub-codes that can be executed.
+ */
+#define ATA_SMART_SUB_CMD_ENABLE        0xD8
+#define ATA_SMART_SUB_CMD_DISABLE       0xD9
+#define ATA_SMART_SUB_CMD_RETURN_STATUS 0xDA
+#define ATA_SMART_SUB_CMD_READ_LOG      0xD5
+
+/**
+ *
+ *
+ * ATA_SET_FEATURES_SUB_COMMAND_CODES These constants define the ATA SET
+ * FEATURES command sub-codes that can be executed.
+ */
+#define ATA_SET_FEATURES_SUB_CMD_ENABLE_CACHE       0x02
+#define ATA_SET_FEATURES_SUB_CMD_DISABLE_CACHE      0x82
+#define ATA_SET_FEATURES_SUB_CMD_DISABLE_READ_AHEAD 0x55
+#define ATA_SET_FEATURES_SUB_CMD_ENABLE_READ_AHEAD  0xAA
+#define ATA_SET_FEATURES_SUB_CMD_SET_TRANSFER_MODE  0x3
+
+/**
+ *
+ *
+ * ATA_READ_LOG_EXT_PAGE_CODES This is a list of log page codes available for
+ * use.
+ */
+#define ATA_LOG_PAGE_NCQ_ERROR                  0x10
+#define ATA_LOG_PAGE_SMART_SELF_TEST            0x06
+#define ATA_LOG_PAGE_EXTENDED_SMART_SELF_TEST   0x07
+
+/**
+ *
+ *
+ * ATA_LOG_PAGE_NCQ_ERROR_CONSTANTS These constants define standard values for
+ * use when requesting the NCQ error log page.
+ */
+#define ATA_LOG_PAGE_NCQ_ERROR_SECTOR        0
+#define ATA_LOG_PAGE_NCQ_ERROR_SECTOR_COUNT  1
+
+/**
+ *
+ *
+ * ATA_STATUS_REGISTER_BITS The following are status register bit definitions
+ * per ATA/ATAPI-7.
+ */
+#define ATA_STATUS_REG_BSY_BIT          0x80
+#define ATA_STATUS_REG_DEVICE_FAULT_BIT 0x20
+#define ATA_STATUS_REG_ERROR_BIT        0x01
+
+/**
+ *
+ *
+ * ATA_ERROR_REGISTER_BITS The following are error register bit definitions per
+ * ATA/ATAPI-7.
+ */
+#define ATA_ERROR_REG_NO_MEDIA_BIT              0x02
+#define ATA_ERROR_REG_ABORT_BIT                 0x04
+#define ATA_ERROR_REG_MEDIA_CHANGE_REQUEST_BIT  0x08
+#define ATA_ERROR_REG_ID_NOT_FOUND_BIT          0x10
+#define ATA_ERROR_REG_MEDIA_CHANGE_BIT          0x20
+#define ATA_ERROR_REG_UNCORRECTABLE_BIT         0x40
+#define ATA_ERROR_REG_WRITE_PROTECTED_BIT       0x40
+#define ATA_ERROR_REG_ICRC_BIT                  0x80
+
+/**
+ *
+ *
+ * ATA_CONTROL_REGISTER_BITS The following are control register bit definitions
+ * per ATA/ATAPI-7
+ */
+#define ATA_CONTROL_REG_INTERRUPT_ENABLE_BIT 0x02
+#define ATA_CONTROL_REG_SOFT_RESET_BIT       0x04
+#define ATA_CONTROL_REG_HIGH_ORDER_BYTE_BIT  0x80
+
+/**
+ *
+ *
+ * ATA_DEVICE_HEAD_REGISTER_BITS The following are device/head register bit
+ * definitions per ATA/ATAPI-7.
+ */
+#define ATA_DEV_HEAD_REG_LBA_MODE_ENABLE  0x40
+#define ATA_DEV_HEAD_REG_FUA_ENABLE       0x80
+
+/**
+ *
+ *
+ * ATA_IDENTIFY_DEVICE_FIELD_LENGTHS The following constants define the number
+ * of bytes contained in various fields found in the IDENTIFY DEVICE data
+ * structure.
+ */
+#define ATA_IDENTIFY_SERIAL_NUMBER_LEN        20
+#define ATA_IDENTIFY_MODEL_NUMBER_LEN         40
+#define ATA_IDENTIFY_FW_REVISION_LEN          8
+#define ATA_IDENTIFY_48_LBA_LEN               8
+#define ATA_IDENTIFY_MEDIA_SERIAL_NUMBER_LEN  30
+#define ATA_IDENTIFY_WWN_LEN                  8
+
+/**
+ *
+ *
+ * ATA_IDENTIFY_DEVICE_FIELD_MASKS The following constants define bit masks
+ * utilized to determine if a feature is supported/enabled or if a bit is
+ * simply set inside of the IDENTIFY DEVICE data structre.
+ */
+#define ATA_IDENTIFY_REMOVABLE_MEDIA_ENABLE              0x0080
+#define ATA_IDENTIFY_CAPABILITIES1_NORMAL_DMA_ENABLE     0x0100
+#define ATA_IDENTIFY_CAPABILITIES1_STANDBY_ENABLE        0x2000
+#define ATA_IDENTIFY_COMMAND_SET_SUPPORTED0_SMART_ENABLE 0x0001
+#define ATA_IDENTIFY_COMMAND_SET_SUPPORTED1_48BIT_ENABLE 0x0400
+#define ATA_IDENTIFY_COMMAND_SET_WWN_SUPPORT_ENABLE      0x0100
+#define ATA_IDENTIFY_COMMAND_SET_ENABLED0_SMART_ENABLE   0x0001
+#define ATA_IDENTIFY_SATA_CAPABILITIES_NCQ_ENABLE        0x0100
+#define ATA_IDENTIFY_NCQ_QUEUE_DEPTH_ENABLE              0x001F
+#define ATA_IDENTIFY_SECTOR_LARGER_THEN_512_ENABLE       0x0100
+#define ATA_IDENTIFY_LOGICAL_SECTOR_PER_PHYSICAL_SECTOR_MASK   0x000F
+#define ATA_IDENTIFY_LOGICAL_SECTOR_PER_PHYSICAL_SECTOR_ENABLE 0x2000
+#define ATA_IDENTIFY_WRITE_UNCORRECTABLE_SUPPORT         0x0004
+#define ATA_IDENTIFY_COMMAND_SET_SMART_SELF_TEST_SUPPORTED     0x0002
+
+/**
+ *
+ *
+ * ATAPI_IDENTIFY_DEVICE_FIELD_MASKS These constants define the various bit
+ * definitions for the fields in the PACKET IDENTIFY DEVICE data structure.
+ */
+#define ATAPI_IDENTIFY_16BYTE_CMD_PCKT_ENABLE       0x01
+
+/**
+ *
+ *
+ * ATA_PACKET_FEATURE_BITS These constants define the various bit definitions
+ * for the ATA PACKET feature register.
+ */
+#define ATA_PACKET_FEATURE_DMA     0x01
+#define ATA_PACKET_FEATURE_OVL     0x02
+#define ATA_PACKET_FEATURE_DMADIR  0x04
+
+/**
+ *
+ *
+ * ATA_Device_Power_Mode_Values These constants define the power mode values
+ * returned by ATA_Check_Power_Mode
+ */
+#define ATA_STANDBY_POWER_MODE    0x00
+#define ATA_IDLE_POWER_MODE       0x80
+#define ATA_ACTIVE_POWER_MODE     0xFF
+
+/**
+ *
+ *
+ * ATA_WRITE_UNCORRECTIABLE feature field values These constants define the
+ * Write Uncorrectable feature values used with the SATI translation.
+ */
+#define ATA_WRITE_UNCORRECTABLE_PSUEDO    0x55
+#define ATA_WRITE_UNCORRECTABLE_FLAGGED   0xAA
+
+
+
+/**
+ * struct ATA_IDENTIFY_DEVICE - This structure depicts the ATA IDENTIFY DEVICE
+ *    data format.
+ *
+ *
+ */
+struct ata_identify_device_data {
+	u16 general_config_bits;                                                /* word  00 */
+	u16 obsolete0;                                                          /* word  01 (num cylinders) */
+	u16 vendor_specific_config_bits;                                        /* word  02 */
+	u16 obsolete1;                                                          /* word  03 (num heads) */
+	u16 retired1[2];                                                        /* words 04-05 */
+	u16 obsolete2;                                                          /* word  06 (sectors / track) */
+	u16 reserved_for_compact_flash1[2];                                     /* words 07-08 */
+	u16 retired0;                                                           /* word  09 */
+	u8 serial_number[ATA_IDENTIFY_SERIAL_NUMBER_LEN];                       /* word 10-19 */
+	u16 retired2[2];                                                        /* words 20-21 */
+	u16 obsolete4;                                                          /* word  22 */
+	u8 firmware_revision[ATA_IDENTIFY_FW_REVISION_LEN];                     /* words 23-26 */
+	u8 model_number[ATA_IDENTIFY_MODEL_NUMBER_LEN];                         /* words 27-46 */
+	u16 max_sectors_per_multiple;                                           /* word  47 */
+	u16 reserved0;                                                          /* word  48 */
+	u16 capabilities1;                                                      /* word  49 */
+	u16 capabilities2;                                                      /* word  50 */
+	u16 obsolete5[2];                                                       /* words 51-52 */
+	u16 validity_bits;                                                      /* word  53 */
+	u16 obsolete6[5];                                                       /*
+										 * words 54-58 Used to be:
+										 * current cylinders,
+										 * current heads,
+										 * current sectors/Track,
+										 * current capacity */
+	u16 current_max_sectors_per_multiple;                                   /* word  59 */
+	u8 total_num_sectors[4];                                                /* words 60-61 */
+	u16 obsolete7;                                                          /* word  62 */
+	u16 multi_word_dma_mode;                                                /* word  63 */
+	u16 pio_modes_supported;                                                /* word  64 */
+	u16 min_multiword_dma_transfer_cycle;                                   /* word  65 */
+	u16 rec_min_multiword_dma_transfer_cycle;                               /* word  66 */
+	u16 min_pio_transfer_no_flow_ctrl;                                      /* word  67 */
+	u16 min_pio_transfer_with_flow_ctrl;                                    /* word  68 */
+	u16 reserved1[2];                                                       /* words 69-70 */
+	u16 reserved2[4];                                                       /* words 71-74 */
+	u16 queue_depth;                                                        /* word  75 */
+	u16 serial_ata_capabilities;                                            /* word  76 */
+	u16 serial_ata_reserved;                                                /* word  77 */
+	u16 serial_ata_features_supported;                                      /* word  78 */
+	u16 serial_ata_features_enabled;                                        /* word  79 */
+	u16 major_version_number;                                               /* word  80 */
+	u16 minor_version_number;                                               /* word  81 */
+	u16 command_set_supported0;                                             /* word  82 */
+	u16 command_set_supported1;                                             /* word  83 */
+	u16 command_set_supported_extention;                                    /* word  84 */
+	u16 command_set_enabled0;                                               /* word  85 */
+	u16 command_set_enabled1;                                               /* word  86 */
+	u16 command_set_default;                                                /* word  87 */
+	u16 ultra_dma_mode;                                                     /* word  88 */
+	u16 security_erase_completion_time;                                     /* word  89 */
+	u16 enhanced_security_erase_time;                                       /* word  90 */
+	u16 current_power_mgmt_value;                                           /* word  91 */
+	u16 master_password_revision;                                           /* word  92 */
+	u16 hardware_reset_result;                                              /* word  93 */
+	u16 current_acoustic_management_value;                                  /* word  94 */
+	u16 stream_min_request_size;                                            /* word  95 */
+	u16 stream_transfer_time;                                               /* word  96 */
+	u16 stream_access_latency;                                              /* word  97 */
+	u16 stream_performance_granularity[2];                                  /* words 98-99 */
+	u8 max_48bit_lba[ATA_IDENTIFY_48_LBA_LEN];                              /* words 100-103 */
+	u16 streaming_transfer_time;                                            /* word  104 */
+	u16 reserved3;                                                          /* word  105 */
+	u16 physical_logical_sector_info;                                       /* word  106 */
+	u16 acoustic_test_interseek_delay;                                      /* word  107 */
+	u8 world_wide_name[ATA_IDENTIFY_WWN_LEN];                               /* words 108-111 */
+	u8 reserved_for_wwn_extention[ATA_IDENTIFY_WWN_LEN];                    /* words 112-115 */
+	u16 reserved4;                                                          /* word  116 */
+	u8 words_per_logical_sector[4];                                         /* words 117-118 */
+	u16 command_set_supported2;                                             /* word  119 */
+	u16 reserved5[7];                                                       /* words 120-126 */
+	u16 removable_media_status;                                             /* word  127 */
+	u16 security_status;                                                    /* word  128 */
+	u16 vendor_specific1[31];                                               /* words 129-159 */
+	u16 cfa_power_mode1;                                                    /* word  160 */
+	u16 reserved_for_compact_flash2[7];                                     /* words 161-167 */
+	u16 device_nominal_form_factor;                                         /* word 168 */
+	u16 reserved_for_compact_flash3[7];                                     /* words 169-175 */
+	u16 current_media_serial_number[ATA_IDENTIFY_MEDIA_SERIAL_NUMBER_LEN];  /* words 176-205 */
+	u16 reserved6[3];                                                       /* words 206-208 */
+	u16 logical_sector_alignment;                                           /* words 209 */
+	u16 reserved7[7];                                                       /* words 210-216 */
+	u16 nominal_media_rotation_rate;                                        /* word 217 */
+	u16 reserved8[37];                                                      /* words 218-254 */
+	u16 integrity_word;                                                     /* word  255 */
+
+};
+
+#define ATA_IDENTIFY_DEVICE_GET_OFFSET(field_name) \
+	((unsigned long)&(((struct ata_identify_device_data *)0)->field_name))
+#define ATA_IDENTIFY_DEVICE_WCE_ENABLE  0x20
+#define ATA_IDENTIFY_DEVICE_RA_ENABLE   0x40
+
+/**
+ * struct ATAPI_IDENTIFY_PACKET_DATA - The following structure depicts the
+ *    ATA-ATAPI 7 version of the IDENTIFY PACKET DEVICE data structure.
+ *
+ *
+ */
+struct atapi_identify_packet_device {
+	u16 generalConfigBits;                                  /* word  00 */
+	u16 reserved0;                                          /* word  01 (num cylinders) */
+	u16 uniqueConfigBits;                                   /* word  02 */
+	u16 reserved1[7];                                       /* words 03 - 09 */
+	u8 serialNumber[ATA_IDENTIFY_SERIAL_NUMBER_LEN];        /* word 10-19 */
+	u16 reserved2[3];                                       /* words 20-22 */
+	u8 firmwareRevision[ATA_IDENTIFY_FW_REVISION_LEN];      /* words 23-26 */
+	u8 modelNumber[ATA_IDENTIFY_MODEL_NUMBER_LEN];          /* words 27-46 */
+	u16 reserved4[2];                                       /* words 47-48 */
+	u16 capabilities1;                                      /* word  49 */
+	u16 capabilities2;                                      /* word  50 */
+	u16 obsolete0[2];                                       /* words 51-52 */
+	u16 validityBits;                                       /* word  53 */
+	u16 reserved[8];                                        /* words 54-61 */
+
+	u16 DMADIRBitRequired;                                  /* word  62, page2 */
+	u16 multiWordDmaMode;                                   /* word  63 */
+	u16 pioModesSupported;                                  /* word  64 */
+	u16 minMultiwordDmaTransferCycle;                       /* word  65 */
+	u16 recMinMultiwordDmaTransferCycle;                    /* word  66 */
+	u16 minPioTransferNoFlowCtrl;                           /* word  67 */
+	u16 minPioTransferWithFlowCtrl;                         /* word  68 */
+	u16 reserved6[2];                                       /* words 69-70 */
+	u16 nsFromPACKETReceiptToBusRelease;                    /* word  71 */
+	u16 nsFromSERVICEReceiptToBSYreset;                     /* wore  72 */
+	u16 reserved7[2];                                       /* words 73-74 */
+	u16 queueDepth;                                         /* word  75 */
+	u16 serialAtaCapabilities;                              /* word  76 */
+	u16 serialAtaReserved;                                  /* word  77 */
+	u16 serialAtaFeaturesSupported;                         /* word  78 */
+	u16 serialAtaFeaturesEnabled;                           /* word  79 */
+
+	u16 majorVersionNumber;                                 /* word  80, page3 */
+	u16 minorVersionNumber;                                 /* word  81 */
+	u16 commandSetSupported0;                               /* word  82 */
+	u16 commandSetSupported1;                               /* word  83 */
+
+	u16 commandSetSupportedExtention;                       /* word  84, page4 */
+	u16 commandSetEnabled0;                                 /* word  85 */
+	u16 commandSetEnabled1;                                 /* word  86 */
+	u16 commandSetDefault;                                  /* word  87 */
+
+	u16 ultraDmaMode;                                       /* word  88, page5 */
+	u16 reserved8[4];                                       /* words 89 - 92 */
+
+	u16 hardwareResetResult;                                /* word  93, page6 */
+	u16 currentAcousticManagementValue;                     /* word  94 */
+	u16 reserved9[30];                                      /* words 95-124 */
+	u16 ATAPIByteCount0Behavior;                            /* word  125 */
+	u16 obsolete1;                                          /* word  126 */
+	u16 removableMediaStatus;                               /* word  127, */
+
+	u16 securityStatus;                                     /* word  128, page7 */
+	u16 vendorSpecific1[31];                                /* words 129-159 */
+	u16 reservedForCompactFlash[16];                        /* words 160-175 */
+	u16 reserved10[79];                                     /* words 176-254 */
+	u16 integrityWord;                                      /* word  255 */
+};
+
+/**
+ * struct ata_extended_smart_self_test_log - The following structure depicts
+ *    the ATA-8 version of the Extended SMART self test log page descriptor
+ *    entry.
+ *
+ *
+ */
+union ata_descriptor_entry {
+	struct DESCRIPTOR_ENTRY {
+		u8 lba_field;
+		u8 status_byte;
+		u8 time_stamp_low;
+		u8 time_stamp_high;
+		u8 checkpoint_byte;
+		u8 failing_lba_low;
+		u8 failing_lba_mid;
+		u8 failing_lba_high;
+		u8 failing_lba_low_ext;
+		u8 failing_lba_mid_ext;
+		u8 failing_lba_high_ext;
+
+		u8 vendor_specific1;
+		u8 vendor_specific2;
+		u8 vendor_specific3;
+		u8 vendor_specific4;
+		u8 vendor_specific5;
+		u8 vendor_specific6;
+		u8 vendor_specific7;
+		u8 vendor_specific8;
+		u8 vendor_specific9;
+		u8 vendor_specific10;
+		u8 vendor_specific11;
+		u8 vendor_specific12;
+		u8 vendor_specific13;
+		u8 vendor_specific14;
+		u8 vendor_specific15;
+	} DESCRIPTOR_ENTRY;
+
+	u8 descriptor_entry[26];
+
+};
+
+/**
+ * struct ata_extended_smart_self_test_log - The following structure depicts
+ *    the ATA-8 version of the SMART self test log page descriptor entry.
+ *
+ *
+ */
+union ata_smart_descriptor_entry {
+	struct SMART_DESCRIPTOR_ENTRY {
+		u8 lba_field;
+		u8 status_byte;
+		u8 time_stamp_low;
+		u8 time_stamp_high;
+		u8 checkpoint_byte;
+		u8 failing_lba_low;
+		u8 failing_lba_mid;
+		u8 failing_lba_high;
+		u8 failing_lba_low_ext;
+
+		u8 vendor_specific1;
+		u8 vendor_specific2;
+		u8 vendor_specific3;
+		u8 vendor_specific4;
+		u8 vendor_specific5;
+		u8 vendor_specific6;
+		u8 vendor_specific7;
+		u8 vendor_specific8;
+		u8 vendor_specific9;
+		u8 vendor_specific10;
+		u8 vendor_specific11;
+		u8 vendor_specific12;
+		u8 vendor_specific13;
+		u8 vendor_specific14;
+		u8 vendor_specific15;
+	} SMART_DESCRIPTOR_ENTRY;
+
+	u8 smart_descriptor_entry[24];
+
+};
+
+/**
+ * struct ata_extended_smart_self_test_log - The following structure depicts
+ *    the ATA-8 version of the Extended SMART self test log page.
+ *
+ *
+ */
+struct ata_extended_smart_self_test_log {
+	u8 self_test_log_data_structure_revision_number;        /* byte 0 */
+	u8 reserved0;                                           /* byte 1 */
+	u8 self_test_descriptor_index[2];                       /* byte 2-3 */
+
+	union ata_descriptor_entry descriptor_entrys[19];           /* bytes 4-497 */
+
+	u8 vendor_specific[2];                                  /* byte 498-499 */
+	u8 reserved1[11];                                       /* byte 500-510 */
+	u8 data_structure_checksum;                             /* byte 511 */
+
+};
+
+/**
+ * struct ata_extended_smart_self_test_log - The following structure depicts
+ *    the ATA-8 version of the SMART self test log page.
+ *
+ *
+ */
+struct ata_smart_self_test_log {
+	u8 self_test_log_data_structure_revision_number[2];     /* bytes 0-1 */
+
+	union ata_smart_descriptor_entry descriptor_entrys[21];     /* bytes 2-505 */
+
+	u8 vendor_specific[2];                                  /* byte 506-507 */
+	u8 self_test_index;                                     /* byte 508 */
+	u8 reserved1[2];                                        /* byte 509-510 */
+	u8 data_structure_checksum;                             /* byte 511 */
+
+};
+
+#endif /* _ATA_H_ */
+
diff --git a/drivers/scsi/isci/core/intel_sas.h b/drivers/scsi/isci/core/intel_sas.h
new file mode 100644
index 0000000..eb9686e
--- /dev/null
+++ b/drivers/scsi/isci/core/intel_sas.h
@@ -0,0 +1,948 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _INTEL_SAS_H_
+#define _INTEL_SAS_H_
+
+/**
+ * This file contains all of the definitions relating to structures, constants,
+ *    etc. defined by the SAS specification.
+ *
+ *
+ */
+
+#include "intel_sata.h"
+#include "intel_scsi.h"
+
+/**
+ * struct sci_sas_address - This structure depicts how a SAS address is
+ *    represented by SCI.
+ *
+ *
+ */
+struct sci_sas_address {
+	/**
+	 * This member contains the higher 32-bits of the SAS address.
+	 */
+	u32 high;
+
+	/**
+	 * This member contains the lower 32-bits of the SAS address.
+	 */
+	u32 low;
+
+};
+
+/**
+ * struct sci_sas_identify_address_frame_protocols - This structure depicts the
+ *    contents of bytes 2 and 3 in the SAS IDENTIFY ADDRESS FRAME (IAF).
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification Link layer section on address frames.
+ */
+struct sci_sas_identify_address_frame_protocols {
+	union {
+		struct {
+			u16 restricted1:1;
+			u16 smp_initiator:1;
+			u16 stp_initiator:1;
+			u16 ssp_initiator:1;
+			u16 reserved3:4;
+			u16 restricted2:1;
+			u16 smp_target:1;
+			u16 stp_target:1;
+			u16 ssp_target:1;
+			u16 reserved4:4;
+		} bits;
+
+		u16 all;
+	} u;
+
+};
+
+/**
+ * struct sci_sas_identify_address_frame - This structure depicts the contents
+ *    of the SAS IDENTIFY ADDRESS FRAME (IAF).
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification Link layer section on address frames.
+ */
+struct sci_sas_identify_address_frame {
+	u16 address_frame_type:4;
+	u16 device_type:3;
+	u16 reserved1:1;
+	u16 reason:4;
+	u16 reserved2:4;
+
+	struct sci_sas_identify_address_frame_protocols protocols;
+
+	struct sci_sas_address device_name;
+	struct sci_sas_address sas_address;
+
+	u32 phy_identifier:8;
+	u32 break_reply_capable:1;
+	u32 requested_in_zpsds:1;
+	u32 in_zpsds_persistent:1;
+	u32 reserved5:21;
+
+	u32 reserved6[4];
+
+};
+
+/**
+ * struct sas_capabilities - This structure depicts the various SAS
+ *    capabilities supported by the directly attached target device.  For
+ *    specific information on each of these individual fields please reference
+ *    the SAS specification Phy layer section on speed negotiation windows.
+ *
+ *
+ */
+struct sas_capabilities {
+	union {
+#if defined (SCIC_SDS_4_ENABLED)
+		struct {
+			/**
+			 * The SAS specification indicates the start bit shall always be set to
+			 * 1.  This implementation will have the start bit set to 0 if the
+			 * PHY CAPABILITIES were either not received or speed negotiation failed.
+			 */
+			u32 start:1;
+			u32 tx_ssc_type:1;
+			u32 reserved1:2;
+			u32 requested_logical_link_rate:4;
+
+			u32 gen1_without_ssc_supported:1;
+			u32 gen1_with_ssc_supported:1;
+			u32 gen2_without_ssc_supported:1;
+			u32 gen2_with_ssc_supported:1;
+			u32 gen3_without_ssc_supported:1;
+			u32 gen3_with_ssc_supported:1;
+			u32 reserved2:17;
+			u32 parity:1;
+		} bits;
+#endif          /* (SCIC_SDS_4_ENABLED) */
+
+		u32 all;
+	} u;
+
+};
+
+/**
+ * enum _SCI_SAS_LINK_RATE - This enumeration depicts the SAS specification
+ *    defined link speeds.
+ *
+ *
+ */
+enum sci_sas_link_rate {
+	SCI_SAS_NO_LINK_RATE = 0,
+	SCI_SATA_SPINUP_HOLD = 0x3,
+	SCI_SAS_150_GB = 0x8,
+	SCI_SAS_300_GB = 0x9,
+	SCI_SAS_600_GB = 0xA
+};
+
+/**
+ * enum _SCI_SAS_TASK_ATTRIBUTE - This enumeration depicts the SAM/SAS
+ *    specification defined task attribute values for a command information
+ *    unit.
+ *
+ *
+ */
+enum sci_sas_task_attribute {
+	SCI_SAS_SIMPLE_ATTRIBUTE = 0,
+	SCI_SAS_HEAD_OF_QUEUE_ATTRIBUTE = 1,
+	SCI_SAS_ORDERED_ATTRIBUTE = 2,
+	SCI_SAS_ACA_ATTRIBUTE = 4,
+};
+
+/**
+ * enum _SCI_SAS_TASK_MGMT_FUNCTION - This enumeration depicts the SAM/SAS
+ *    specification defined task management functions.
+ *
+ * This HARD_RESET function listed here is not actually defined as a task
+ * management function in the industry standard.
+ */
+enum sci_sas_task_mgmt_function {
+	SCI_SAS_ABORT_TASK = SCSI_TASK_REQUEST_ABORT_TASK,
+	SCI_SAS_ABORT_TASK_SET = SCSI_TASK_REQUEST_ABORT_TASK_SET,
+	SCI_SAS_CLEAR_TASK_SET = SCSI_TASK_REQUEST_CLEAR_TASK_SET,
+	SCI_SAS_LOGICAL_UNIT_RESET = SCSI_TASK_REQUEST_LOGICAL_UNIT_RESET,
+	SCI_SAS_I_T_NEXUS_RESET = SCSI_TASK_REQUEST_I_T_NEXUS_RESET,
+	SCI_SAS_CLEAR_ACA = SCSI_TASK_REQUEST_CLEAR_ACA,
+	SCI_SAS_QUERY_TASK = SCSI_TASK_REQUEST_QUERY_TASK,
+	SCI_SAS_QUERY_TASK_SET = SCSI_TASK_REQUEST_QUERY_TASK_SET,
+	SCI_SAS_QUERY_ASYNCHRONOUS_EVENT = SCSI_TASK_REQUEST_QUERY_UNIT_ATTENTION,
+	SCI_SAS_HARD_RESET = 0xFF
+};
+
+
+/**
+ * enum _SCI_SAS_FRAME_TYPE - This enumeration depicts the SAS specification
+ *    defined SSP frame types.
+ *
+ *
+ */
+enum sci_sas_frame_type {
+	SCI_SAS_DATA_FRAME = 0x01,
+	SCI_SAS_XFER_RDY_FRAME = 0x05,
+	SCI_SAS_COMMAND_FRAME = 0x06,
+	SCI_SAS_RESPONSE_FRAME = 0x07,
+	SCI_SAS_TASK_FRAME = 0x16
+};
+
+/**
+ * struct sci_ssp_command_iu - This structure depicts the contents of the SSP
+ *    COMMAND INFORMATION UNIT. For specific information on each of these
+ *    individual fields please reference the SAS specification SSP transport
+ *    layer section.
+ *
+ *
+ */
+struct sci_ssp_command_iu {
+	u32 lun_upper;
+	u32 lun_lower;
+
+	u32 additional_cdb_length:6;
+	u32 reserved0:2;
+	u32 reserved1:8;
+	u32 enable_first_burst:1;
+	u32 task_priority:4;
+	u32 task_attribute:3;
+	u32 reserved2:8;
+
+	u32 cdb[4];
+
+};
+
+/**
+ * struct sci_ssp_task_iu - This structure depicts the contents of the SSP TASK
+ *    INFORMATION UNIT. For specific information on each of these individual
+ *    fields please reference the SAS specification SSP transport layer section.
+ *
+ *
+ */
+struct sci_ssp_task_iu {
+	u32 lun_upper;
+	u32 lun_lower;
+
+	u32 reserved0:8;
+	u32 task_function:8;
+	u32 reserved1:8;
+	u32 reserved2:8;
+
+	u32 reserved3:16;
+	u32 task_tag:16;
+
+	u32 reserved4[3];
+
+};
+
+#define SSP_RESPONSE_IU_MAX_DATA 64
+
+#define SCI_SSP_RESPONSE_IU_DATA_PRESENT_MASK   (0x03)
+
+
+#define sci_ssp_get_sense_data_length(sense_data_length_buffer)	\
+	SCIC_BUILD_DWORD(sense_data_length_buffer)
+
+#define sci_ssp_get_response_data_length(response_data_length_buffer) \
+	SCIC_BUILD_DWORD(response_data_length_buffer)
+
+/**
+ * struct sci_ssp_response_iu - This structure depicts the contents of the SSP
+ *    RESPONSE INFORMATION UNIT. For specific information on each of these
+ *    individual fields please reference the SAS specification SSP transport
+ *    layer section.
+ *
+ *
+ */
+struct sci_ssp_response_iu {
+	u8 reserved0[8];
+
+	u8 retry_delay_timer[2];
+	u8 data_present;
+	u8 status;
+
+	u8 reserved1[4];
+	u8 sense_data_length[4];
+	u8 response_data_length[4];
+
+	u32 data[SSP_RESPONSE_IU_MAX_DATA];
+
+};
+
+/**
+ * enum _SCI_SAS_DATA_PRESENT_TYPE - This enumeration depicts the SAS
+ *    specification defined SSP data present types in struct sci_ssp_response_iu.
+ *
+ *
+ */
+enum sci_ssp_response_iu_data_present_type {
+	SCI_SSP_RESPONSE_IU_NO_DATA = 0x00,
+	SCI_SSP_RESPONSE_IU_RESPONSE_DATA = 0x01,
+	SCI_SSP_RESPONSE_IU_SENSE_DATA = 0x02
+};
+
+/**
+ * struct sci_ssp_frame_header - This structure depicts the contents of an SSP
+ *    frame header.  For specific information on the individual fields please
+ *    reference the SAS specification transport layer SSP frame format.
+ *
+ *
+ */
+struct sci_ssp_frame_header {
+	/* Word 0 */
+	u32 hashed_destination_address:24;
+	u32 frame_type:8;
+
+	/* Word 1 */
+	u32 hashed_source_address:24;
+	u32 reserved1_0:8;
+
+	/* Word 2 */
+	u32 reserved2_2:6;
+	u32 fill_bytes:2;
+	u32 reserved2_1:3;
+	u32 tlr_control:2;
+	u32 retry_data_frames:1;
+	u32 retransmit:1;
+	u32 changing_data_pointer:1;
+	u32 reserved2_0:16;
+
+	/* Word 3 */
+	u32 uiResv4;
+
+	/* Word 4 */
+	u16 target_port_transfer_tag;
+	u16 tag;
+
+	/* Word 5 */
+	u32 data_offset;
+
+};
+
+/**
+ * struct smp_request_header - This structure defines the contents of an SMP
+ *    Request header.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification.
+ */
+struct smp_request_header {
+	u8 smp_frame_type;              /* byte 0 */
+	u8 function;                    /* byte 1 */
+	u8 allocated_response_length;   /* byte 2 */
+	u8 request_length;              /* byte 3 */
+};
+
+/**
+ * struct smp_response_header - This structure depicts the contents of the SAS
+ *    SMP DISCOVER RESPONSE frame.  For specific information on each of these
+ *    individual fields please reference the SAS specification Link layer
+ *    section on address frames.
+ *
+ *
+ */
+struct smp_response_header {
+	u8 smp_frame_type;      /* byte 0 */
+	u8 function;            /* byte 1 */
+	u8 function_result;     /* byte 2 */
+	u8 response_length;     /* byte 3 */
+};
+
+/**
+ * struct smp_request_general - This structure defines the contents of an SMP
+ *    Request that is comprised of the struct smp_request_header and a CRC.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification.
+ */
+struct smp_request_general {
+	u32 crc;      /* bytes 4-7 */
+
+};
+
+/**
+ * struct smp_request_phy_identifier - This structure defines the contents of
+ *    an SMP Request that is comprised of the struct smp_request_header and a phy
+ *    identifier. Examples: SMP_REQUEST_DISCOVER, SMP_REQUEST_REPORT_PHY_SATA.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification.
+ */
+struct smp_request_phy_identifier {
+	u32 reserved_byte4_7;           /* bytes 4-7 */
+
+	u32 ignore_zone_group:1;      /* byte 8 */
+	u32 reserved_byte8:7;
+
+	u32 phy_identifier:8;         /* byte 9 */
+	u32 reserved_byte10:8;        /* byte 10 */
+	u32 reserved_byte11:8;        /* byte 11 */
+
+};
+
+/**
+ * struct smp_request_configure_route_information - This structure defines the
+ *    contents of an SMP Configure Route Information request.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification.
+ */
+struct smp_request_configure_route_information {
+	u32 expected_expander_change_count:16;        /* bytes 4-5 */
+	u32 expander_route_index_high:8;
+	u32 expander_route_index:8;                   /* bytes 6-7 */
+
+	u32 reserved_byte8:8;                         /* bytes 8 */
+	u32 phy_identifier:8;                         /* bytes 9 */
+	u32 reserved_byte_10_11:16;                   /* bytes 10-11 */
+
+	u32 reserved_byte_12_bit_0_6:7;
+	u32 disable_route_entry:1;    /* byte 12 */
+	u32 reserved_byte_13_15:24;   /* bytes 13-15 */
+
+	u32 routed_sas_address[2];      /* bytes 16-23 */
+	u8 reserved_byte_24_39[16];     /* bytes 24-39 */
+
+};
+
+/**
+ * struct smp_request_phy_control - This structure defines the contents of an
+ *    SMP Phy Controler request.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification.
+ */
+struct smp_request_phy_control {
+	u16 expected_expander_change_count;     /* byte 4-5 */
+
+	u16 reserved_byte_6_7;                  /* byte 6-7 */
+	u8 reserved_byte_8;                     /* byte 8 */
+
+	u8 phy_identifier;                      /* byte 9 */
+	u8 phy_operation;                       /* byte 10 */
+
+	u8 update_partial_pathway_timeout_value:1;
+	u8 reserved_byte_11_bit_1_7:7;        /* byte 11 */
+
+	u8 reserved_byte_12_23[12];             /* byte 12-23 */
+
+	u8 attached_device_name[8];             /* byte 24-31 */
+
+	u8 reserved_byte_32_bit_3_0:4;        /* byte 32 */
+	u8 programmed_minimum_physical_link_rate:4;
+
+	u8 reserved_byte_33_bit_3_0:4; /* byte 33 */
+	u8 programmed_maximum_physical_link_rate:4;
+
+	u16 reserved_byte_34_35; /* byte 34-35 */
+
+	u8 partial_pathway_timeout_value:4;
+	u8 reserved_byte_36_bit_4_7:4;        /* byte 36 */
+
+	u16 reserved_byte_37_38;                /* byte 37-38 */
+	u8 reserved_byte_39;                    /* byte 39 */
+
+};
+
+/**
+ * struct smp_request_vendor_specific - This structure depicts the vendor
+ *    specific space for SMP request.
+ *
+ *
+ */
+ #define SMP_REQUEST_VENDOR_SPECIFIC_MAX_LENGTH 1016
+struct smp_request_vendor_specific {
+	u8 request_bytes[SMP_REQUEST_VENDOR_SPECIFIC_MAX_LENGTH];
+};
+
+/**
+ * struct smp_request - This structure simply unionizes the existing request
+ *    structures into a common request type.
+ *
+ *
+ */
+struct smp_request {
+	struct smp_request_header header;
+
+	union { /* bytes 4-N */
+		struct smp_request_general report_general;
+		struct smp_request_phy_identifier discover;
+		struct smp_request_general report_manufacturer_information;
+		struct smp_request_phy_identifier report_phy_sata;
+		struct smp_request_phy_control phy_control;
+		struct smp_request_phy_identifier report_phy_error_log;
+		struct smp_request_phy_identifier report_route_information;
+		struct smp_request_configure_route_information configure_route_information;
+		struct smp_request_vendor_specific vendor_specific_request;
+	} request;
+
+};
+
+
+/**
+ * struct smp_response_report_general - This structure depicts the SMP Report
+ *    General for expander devices.  It adheres to the SAS-2.1 specification.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification Application layer section on SMP.
+ */
+struct smp_response_report_general {
+	u16 expander_change_count;              /* byte 4-5 */
+	u16 expander_route_indexes;             /* byte 6-7 */
+
+	u32 reserved_byte8:7;                 /* byte 8 bit 0-6 */
+	u32 long_response:1;                  /* byte 8 bit 7 */
+
+	u32 number_of_phys:8;                 /* byte 9 */
+
+	u32 configurable_route_table:1;       /* byte 10 */
+	u32 configuring:1;
+	u32 configures_others:1;
+	u32 open_reject_retry_supported:1;
+	u32 stp_continue_awt:1;
+	u32 self_configuring:1;
+	u32 zone_configuring:1;
+	u32 table_to_table_supported:1;
+
+	u32 reserved_byte11:8;                /* byte 11 */
+
+	u32 enclosure_logical_identifier_high;  /* byte 12-15 */
+	u32 enclosure_logical_identifier_low;   /* byte 16-19 */
+
+	u32 reserved_byte20_23;
+	u32 reserved_byte24_27;
+
+};
+
+struct smp_response_report_general_long {
+	struct smp_response_report_general sas1_1;
+
+	struct {
+		u16 reserved1;
+		u16 stp_bus_inactivity_time_limit;
+		u16 stp_max_connect_time_limit;
+		u16 stp_smp_i_t_nexus_loss_time;
+
+		u32 zoning_enabled:1;
+		u32 zoning_supported:1;
+		u32 physicaL_presence_asserted:1;
+		u32 zone_locked:1;
+		u32 reserved2:1;
+		u32 num_zone_groups:3;
+		u32 saving_zoning_enabled_supported:3;
+		u32 saving_zone_perms_table_supported:1;
+		u32 saving_zone_phy_info_supported:1;
+		u32 saving_zone_manager_password_supported:1;
+		u32 saving:1;
+		u32 reserved3:1;
+		u32 max_number_routed_sas_addresses:16;
+
+		struct sci_sas_address active_zone_manager_sas_address;
+
+		u16 zone_lock_inactivity_time_limit;
+		u16 reserved4;
+
+		u8 reserved5;
+		u8 first_enclosure_connector_element_index;
+		u8 number_of_enclosure_connector_element_indices;
+		u8 reserved6;
+
+		u32 reserved7:7;
+		u32 reduced_functionality:1;
+		u32 time_to_reduce_functionality:8;
+		u32 initial_time_to_reduce_functionality:8;
+		u8 max_reduced_functionality_time;
+
+		u16 last_self_config_status_descriptor_index;
+		u16 max_number_of_stored_self_config_status_descriptors;
+
+		u16 last_phy_event_list_descriptor_index;
+		u16 max_number_of_stored_phy_event_list_descriptors;
+	} sas2;
+
+};
+
+/**
+ * struct smp_response_report_manufacturer_information - This structure depicts
+ *    the SMP report manufacturer information for expander devices.  It adheres
+ *    to the SAS-2.1 specification.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification Application layer section on SMP.
+ */
+struct smp_response_report_manufacturer_information {
+	u32 expander_change_count:16; /* bytes 4-5 */
+	u32 reserved1:16;
+
+	u32 sas1_1_format:1;
+	u32 reserved2:31;
+
+	u8 vendor_id[8];
+	u8 product_id[16];
+	u8 product_revision_level[4];
+	u8 component_vendor_id[8];
+	u8 component_id[2];
+	u8 component_revision_level;
+	u8 reserved3;
+	u8 vendor_specific[8];
+
+};
+
+#define SMP_RESPONSE_DISCOVER_FORMAT_1_1_SIZE 52
+#define SMP_RESPONSE_DISCOVER_FORMAT_2_SIZE   116
+
+/**
+ * struct smp_discover_response_protocols - This structure depicts the discover
+ *    response where the supported protocols by the remote phy are specified.
+ *
+ * For specific information on each of these individual fields please reference
+ * the SAS specification Link layer section on address frames.
+ */
+struct smp_discover_response_protocols {
+	union {
+		struct {
+			u16 attached_sata_host:1;
+			u16 attached_smp_initiator:1;
+			u16 attached_stp_initiator:1;
+			u16 attached_ssp_initiator:1;
+			u16 reserved3:4;
+			u16 attached_sata_device:1;
+			u16 attached_smp_target:1;
+			u16 attached_stp_target:1;
+			u16 attached_ssp_target:1;
+			u16 reserved4:3;
+			u16 attached_sata_port_selector:1;
+		} bits;
+
+		u16 all;
+	} u;
+
+};
+
+/**
+ * struct SMP_RESPONSE_DISCOVER_FORMAT - This structure defines the SMP phy
+ *    discover response format. It handles both SAS1.1 and SAS 2 definitions.
+ *    The unions indicate locations where the SAS specification versions differ
+ *    from one another.
+ *
+ *
+ */
+struct smp_response_discover {
+
+	union {
+		struct {
+			u8 reserved[2];
+		} sas1_1;
+
+		struct {
+			u16 expander_change_count;
+		} sas2;
+
+	} u1;
+
+	u8 reserved1[3];
+	u8 phy_identifier;
+	u8 reserved2[2];
+
+	union {
+		struct {
+			u16 reserved1:4;
+			u16 attached_device_type:3;
+			u16 reserved2:1;
+			u16 negotiated_physical_link_rate:4;
+			u16 reserved3:4;
+		} sas1_1;
+
+		struct {
+			u16 attached_reason:4;
+			u16 attached_device_type:3;
+			u16 reserved2:1;
+			u16 negotiated_logical_link_rate:4;
+			u16 reserved3:4;
+		} sas2;
+
+	} u2;
+
+	struct smp_discover_response_protocols protocols;
+	struct sci_sas_address sas_address;
+	struct sci_sas_address attached_sas_address;
+
+	u8 attached_phy_identifier;
+
+	union {
+		struct {
+			u8 reserved;
+		} sas1_1;
+
+		struct {
+			u8 attached_break_reply_capable:1;
+			u8 attached_requested_inside_zpsds:1;
+			u8 attached_inside_zpsds_persistent:1;
+			u8 reserved1:5;
+		} sas2;
+
+	} u3;
+
+	u8 reserved_for_identify[6];
+
+	u32 hardware_min_physical_link_rate:4;
+	u32 programmed_min_physical_link_rate:4;
+	u32 hardware_max_physical_link_rate:4;
+	u32 programmed_max_physical_link_rate:4;
+	u32 phy_change_count:8;
+	u32 partial_pathway_timeout_value:4;
+	u32 reserved5:3;
+	u32 virtual_phy:1;
+
+	u32 routing_attribute:4;
+	u32 reserved6:4;
+	u32 connector_type:7;
+	u32 reserved7:1;
+	u32 connector_element_index:8;
+	u32 connector_physical_link:8;
+
+	u16 reserved8;
+	u16 vendor_specific;
+
+	union {
+		struct {
+			/**
+			 * In the SAS 1.1 specification this structure ends after 52 bytes.
+			 * As a result, the contents of this field should never have a
+			 * real value.  It is undefined.
+			 */
+			u8 undefined[SMP_RESPONSE_DISCOVER_FORMAT_2_SIZE
+				     - SMP_RESPONSE_DISCOVER_FORMAT_1_1_SIZE];
+		} sas1_1;
+
+		struct {
+			struct sci_sas_address attached_device_name;
+
+			u32 zoning_enabled:1;
+			u32 inside_zpsds:1;
+			u32 zone_group_persistent:1;
+			u32 reserved1:1;
+			u32 requested_inside_zpsds:1;
+			u32 inside_zpsds_persistent:1;
+			u32 requested_inside_zpsds_changed_by_expander:1;
+			u32 reserved2:1;
+			u32 reserved_for_zoning_fields:16;
+			u32 zone_group:8;
+
+			u8 self_configuration_status;
+			u8 self_configuration_levels_completed;
+			u16 reserved_for_self_config_fields;
+
+			struct sci_sas_address self_configuration_sas_address;
+
+			u32 programmed_phy_capabilities;
+			u32 current_phy_capabilities;
+			u32 attached_phy_capabilities;
+
+			u32 reserved3;
+
+			u32 reserved4:16;
+			u32 negotiated_physical_link_rate:4;
+			u32 reason:4;
+			u32 hardware_muxing_supported:1;
+			u32 negotiated_ssc:1;
+			u32 reserved5:6;
+
+			u32 default_zoning_enabled:1;
+			u32 reserved6:1;
+			u32 default_zone_group_persistent:1;
+			u32 reserved7:1;
+			u32 default_requested_inside_zpsds:1;
+			u32 default_inside_zpsds_persistent:1;
+			u32 reserved8:2;
+			u32 reserved9:16;
+			u32 default_zone_group:8;
+
+			u32 saved_zoning_enabled:1;
+			u32 reserved10:1;
+			u32 saved_zone_group_persistent:1;
+			u32 reserved11:1;
+			u32 saved_requested_inside_zpsds:1;
+			u32 saved_inside_zpsds_persistent:1;
+			u32 reserved12:18;
+			u32 saved_zone_group:8;
+
+			u32 reserved14:2;
+			u32 shadow_zone_group_persistent:1;
+			u32 reserved15:1;
+			u32 shadow_requested_inside_zpsds:1;
+			u32 shadow_inside_zpsds_persistent:1;
+			u32 reserved16:18;
+			u32 shadow_zone_group:8;
+
+			u8 device_slot_number;
+			u8 device_slot_group_number;
+			u8 device_slot_group_output_connector[6];
+		} sas2;
+
+	} u4;
+
+};
+
+/**
+ * struct smp_response_report_phy_sata - This structure depicts the contents of
+ *    the SAS SMP REPORT PHY SATA frame.  For specific information on each of
+ *    these individual fields please reference the SAS specification Link layer
+ *    section on address frames.
+ *
+ *
+ */
+struct smp_response_report_phy_sata {
+	u32 ignored_byte_4_7; /* bytes 4-7 */
+
+	u32 affiliations_valid:1;
+	u32 affiliations_supported:1;
+	u32 reserved_byte11:6;        /* byte 11 */
+	u32 ignored_byte10:8;         /* byte 10 */
+	u32 phy_identifier:8;         /* byte  9 */
+	u32 reserved_byte_8:8;        /* byte  8 */
+
+	u32 reserved_12_15;
+	u32 stp_sas_address[2];
+	u8 device_to_host_fis[20];
+	u32 reserved_44_47;
+	u32 affiliated_stp_initiator_sas_address[2];
+
+};
+
+struct smp_response_vendor_specific {
+	u8 response_bytes[SMP_REQUEST_VENDOR_SPECIFIC_MAX_LENGTH];
+};
+
+union smp_response_body {
+	struct smp_response_report_general report_general;
+	struct smp_response_report_manufacturer_information report_manufacturer_information;
+	struct smp_response_discover discover;
+	struct smp_response_report_phy_sata report_phy_sata;
+	struct smp_response_vendor_specific vendor_specific_response;
+};
+
+/**
+ * struct smp_response - This structure simply unionizes the existing response
+ *    structures into a common response type.
+ *
+ *
+ */
+struct smp_response {
+	struct smp_response_header header;
+
+	union smp_response_body response;
+
+};
+
+/* SMP Request Functions */
+#define SMP_FUNCTION_REPORT_GENERAL                   0x00
+#define SMP_FUNCTION_REPORT_MANUFACTURER_INFORMATION  0x01
+#define SMP_FUNCTION_DISCOVER                         0x10
+#define SMP_FUNCTION_REPORT_PHY_ERROR_LOG             0x11
+#define SMP_FUNCTION_REPORT_PHY_SATA                  0x12
+#define SMP_FUNCTION_REPORT_ROUTE_INFORMATION         0X13
+#define SMP_FUNCTION_CONFIGURE_ROUTE_INFORMATION      0X90
+#define SMP_FUNCTION_PHY_CONTROL                      0x91
+#define SMP_FUNCTION_PHY_TEST                         0x92
+
+#define SMP_FRAME_TYPE_REQUEST          0x40
+#define SMP_FRAME_TYPE_RESPONSE         0x41
+
+#define PHY_OPERATION_NOP               0x00
+#define PHY_OPERATION_LINK_RESET        0x01
+#define PHY_OPERATION_HARD_RESET        0x02
+#define PHY_OPERATION_DISABLE           0x03
+#define PHY_OPERATION_CLEAR_ERROR_LOG   0x05
+#define PHY_OPERATION_CLEAR_AFFILIATION 0x06
+
+#define NPLR_PHY_ENABLED_UNK_LINK_RATE 0x00
+#define NPLR_PHY_DISABLED     0x01
+#define NPLR_PHY_ENABLED_SPD_NEG_FAILED   0x02
+#define NPLR_PHY_ENABLED_SATA_HOLD  0x03
+#define NPLR_PHY_ENABLED_1_5G    0x08
+#define NPLR_PHY_ENABLED_3_0G    0x09
+
+/* SMP Function Result values. */
+#define SMP_RESULT_FUNCTION_ACCEPTED              0x00
+#define SMP_RESULT_UNKNOWN_FUNCTION               0x01
+#define SMP_RESULT_FUNCTION_FAILED                0x02
+#define SMP_RESULT_INVALID_REQUEST_FRAME_LEN      0x03
+#define SMP_RESULT_INAVALID_EXPANDER_CHANGE_COUNT 0x04
+#define SMP_RESULT_BUSY                           0x05
+#define SMP_RESULT_INCOMPLETE_DESCRIPTOR_LIST     0x06
+#define SMP_RESULT_PHY_DOES_NOT_EXIST             0x10
+#define SMP_RESULT_INDEX_DOES_NOT_EXIST           0x11
+#define SMP_RESULT_PHY_DOES_NOT_SUPPORT_SATA      0x12
+#define SMP_RESULT_UNKNOWN_PHY_OPERATION          0x13
+#define SMP_RESULT_UNKNOWN_PHY_TEST_FUNCTION      0x14
+#define SMP_RESULT_PHY_TEST_IN_PROGRESS           0x15
+#define SMP_RESULT_PHY_VACANT                     0x16
+
+/* Attached Device Types */
+#define SMP_NO_DEVICE_ATTACHED      0
+#define SMP_END_DEVICE_ONLY         1
+#define SMP_EDGE_EXPANDER_DEVICE    2
+#define SMP_FANOUT_EXPANDER_DEVICE  3
+
+/* Expander phy routine attribute */
+#define DIRECT_ROUTING_ATTRIBUTE        0
+#define SUBTRACTIVE_ROUTING_ATTRIBUTE   1
+#define TABLE_ROUTING_ATTRIBUTE         2
+
+#endif /* _INTEL_SAS_H_ */
+
diff --git a/drivers/scsi/isci/core/intel_sat.h b/drivers/scsi/isci/core/intel_sat.h
new file mode 100644
index 0000000..c4d78ed
--- /dev/null
+++ b/drivers/scsi/isci/core/intel_sat.h
@@ -0,0 +1,95 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SAT_H_
+#define _SAT_H_
+
+/**
+ * This file contains constants and constructs defined in the SCSI to ATA
+ *    Translation (SAT) T10 standard.  For more information please refer to
+ *    www.t10.org.
+ *
+ *
+ */
+
+/**
+ *
+ *
+ * SAT_PROTOCOLS These constants indicate the various protocol values that can
+ * be supported in a SAT translator.
+ */
+#define SAT_PROTOCOL_ATA_HARD_RESET       0
+#define SAT_PROTOCOL_SOFT_RESET           1
+#define SAT_PROTOCOL_NON_DATA             3
+#define SAT_PROTOCOL_PIO_DATA_IN          4
+#define SAT_PROTOCOL_PIO_DATA_OUT         5
+#define SAT_PROTOCOL_DMA                  6
+#define SAT_PROTOCOL_DMA_QUEUED           7
+#define SAT_PROTOCOL_DEVICE_DIAGNOSTIC    8
+#define SAT_PROTOCOL_DEVICE_RESET         9
+#define SAT_PROTOCOL_UDMA_DATA_IN         10
+#define SAT_PROTOCOL_UDMA_DATA_OUT        11
+#define SAT_PROTOCOL_FPDMA                12
+#define SAT_PROTOCOL_RETURN_RESPONSE_INFO 15
+
+#define SAT_PROTOCOL_PACKET               0x10
+#define SAT_PROTOCOL_PACKET_NON_DATA      (SAT_PROTOCOL_PACKET | 0x0)
+#define SAT_PROTOCOL_PACKET_DMA_DATA_IN   (SAT_PROTOCOL_PACKET | 0x1)
+#define SAT_PROTOCOL_PACKET_DMA_DATA_OUT  (SAT_PROTOCOL_PACKET | 0x2)
+#define SAT_PROTOCOL_PACKET_PIO_DATA_IN   (SAT_PROTOCOL_PACKET | 0x3)
+#define SAT_PROTOCOL_PACKET_PIO_DATA_OUT  (SAT_PROTOCOL_PACKET | 0x4)
+
+#endif /* _SAT_H_ */
+
diff --git a/drivers/scsi/isci/core/intel_sata.h b/drivers/scsi/isci/core/intel_sata.h
new file mode 100644
index 0000000..47390d5
--- /dev/null
+++ b/drivers/scsi/isci/core/intel_sata.h
@@ -0,0 +1,280 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SATA_H_
+#define _SATA_H_
+
+#include <linux/types.h>
+
+/**
+ * This file defines all of the SATA releated constants, enumerations, and
+ *    types. Please note that this file does not necessarily contain an
+ *    exhaustive list of all contants and commands.
+ *
+ *
+ */
+
+/**
+ *
+ *
+ * SATA FIS Types These constants depict the various SATA FIS types devined in
+ * the serial ATA specification.
+ */
+#define SATA_FIS_TYPE_REGH2D          0x27
+#define SATA_FIS_TYPE_REGD2H          0x34
+#define SATA_FIS_TYPE_SETDEVBITS      0xA1
+#define SATA_FIS_TYPE_DMA_ACTIVATE    0x39
+#define SATA_FIS_TYPE_DMA_SETUP       0x41
+#define SATA_FIS_TYPE_BIST_ACTIVATE   0x58
+#define SATA_FIS_TYPE_PIO_SETUP       0x5F
+#define SATA_FIS_TYPE_DATA            0x46
+
+#define SATA_REGISTER_FIS_SIZE 0x20
+
+/**
+ * struct sata_fis_header - This is the common definition for a SATA FIS Header
+ *    word.  A different header word is defined for any FIS type that does not
+ *    use the standard header.
+ *
+ *
+ */
+struct sata_fis_header {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved:1;
+	u32 direction_flag:1;       /* direction */
+	u32 interrupt_flag:1;
+	u32 command_flag:1;       /* command, auto_activate, or notification */
+	u32 status:8;
+	u32 error:8;
+};
+
+
+/**
+ * struct sata_fis_reg_h2d - This is the definition for a SATA Host to Device
+ *    Register FIS.
+ *
+ *
+ */
+struct sata_fis_reg_h2d {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved0:3;
+	u32 command_flag:1;
+	u32 command:8;
+	u32 features:8;
+	u32 lba_low:8; /* word 1 */
+	u32 lba_mid:8;
+	u32 lba_high:8;
+	u32 device:8;
+	u32 lba_low_exp:8; /* word 2 */
+	u32 lba_mid_exp:8;
+	u32 lba_high_exp:8;
+	u32 features_exp:8;
+	u32 sector_count:8; /* word 3 */
+	u32 sector_count_exp:8;
+	u32 reserved1:8;
+	u32 control:8;
+	u32 reserved2;          /* word 4 */
+};
+
+/**
+ * struct sata_fis_reg_d2h - SATA Device To Host FIS
+ *
+ *
+ */
+struct sata_fis_reg_d2h {
+	u32 fis_type:8;   /* word 0 */
+	u32 pm_port:4;
+	u32 reserved0:2;
+	u32 irq:1;
+	u32 reserved1:1;
+	u32 status:8;
+	u32 error:8;
+	u8 lba_low;          /* word 1 */
+	u8 lba_mid;
+	u8 lba_high;
+	u8 device;
+	u8 lba_low_exp;      /* word 2 */
+	u8 lba_mid_exp;
+	u8 lba_high_exp;
+	u8 reserved;
+	u8 sector_count;     /* word 3 */
+	u8 sector_count_exp;
+	u16 reserved2;
+	u32 reserved3;
+};
+
+/**
+ *
+ *
+ * Status field bit definitions
+ */
+#define SATA_FIS_STATUS_DEVBITS_MASK  (0x77)
+
+/**
+ * struct sata_fis_set_dev_bits - SATA Set Device Bits FIS
+ *
+ *
+ */
+struct sata_fis_set_dev_bits {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved0:2;
+	u32 irq:1;
+	u32 notification:1;
+	u32 status_low:4;
+	u32 status_high:4;
+	u32 error:8;
+	u32 s_active;      /* word 1 */
+};
+
+/**
+ * struct sata_fis_dma_activate - SATA DMA Activate FIS
+ *
+ *
+ */
+struct sata_fis_dma_activate {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved0:24;
+};
+
+/**
+ *
+ *
+ * The lower 5 bits in the DMA Buffer ID Low field of the DMA Setup are used to
+ * communicate the command tag.
+ */
+#define SATA_DMA_SETUP_TAG_ENABLE      0x1F
+
+#define SATA_DMA_SETUP_AUTO_ACT_ENABLE 0x80
+
+/**
+ * struct sata_fis_dma_setup - SATA DMA Setup FIS
+ *
+ *
+ */
+struct sata_fis_dma_setup {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved_00:1;
+	u32 direction:1;
+	u32 irq:1;
+	u32 auto_activate:1;
+	u32 reserved_01:16;
+	u32 dma_buffer_id_low;          /* word 1 */
+	u32 dma_buffer_id_high;         /* word 2 */
+	u32 reserved0;                  /* word 3 */
+	u32 dma_buffer_offset;          /* word 4 */
+	u32 dma_transfer_count;         /* word 5 */
+	u32 reserved1;                  /* word 6 */
+};
+
+/**
+ * struct sata_fis_bist_activate - SATA BIST Activate FIS
+ *
+ *
+ */
+struct sata_fis_bist_activate {
+	u32 fis_type:8; /* word 0 */
+	u32 reserved0:8;
+	u32 pattern_definition:8;
+	u32 reserved1:8;
+	u32 data1;                      /* word 1 */
+	u32 data2;                      /* word 1 */
+};
+
+/*
+ *  SATA PIO Setup FIS
+ */
+struct sata_fis_pio_setup {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved_00:1;
+	u32 direction:1;
+	u32 irq:1;
+	u32 reserved_01:1;
+	u32 status:8;
+	u32 error:8;
+	u32 lba_low:8; /* word 1 */
+	u32 lba_mid:8;
+	u32 lba_high:8;
+	u32 device:8;
+	u32 lba_low_exp:8; /* word 2 */
+	u32 lba_mid_exp:8;
+	u32 lba_high_exp:8;
+	u32 reserved:8;
+	u32 sector_count:8; /* word 3 */
+	u32 sector_count_exp:8;
+	u32 reserved1:8;
+	u32 ending_status:8;
+	u32 transfter_count:16; /* word 4 */
+	u32 reserved3:16;
+};
+
+/**
+ * struct sata_fis_data - SATA Data FIS
+ *
+ *
+ */
+struct sata_fis_data {
+	u32 fis_type:8; /* word 0 */
+	u32 pm_port:4;
+	u32 reserved0:24;
+	u8 data[4];        /* word 1 */
+};
+
+#endif /* _SATA_H_ */
diff --git a/drivers/scsi/isci/core/intel_scsi.h b/drivers/scsi/isci/core/intel_scsi.h
new file mode 100644
index 0000000..1e45d3c
--- /dev/null
+++ b/drivers/scsi/isci/core/intel_scsi.h
@@ -0,0 +1,474 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+/**
+ * This file defines all of the SCSI related constants, enumerations, and
+ *    types.  Please note that this file does not necessarily contain an
+ *    exhaustive list of all constants, commands, sub-commands, etc.
+ *
+ *
+ */
+
+#ifndef _SCSI_H__
+#define _SCSI_H__
+
+
+/*
+ * ******************************************************************************
+ * * C O N S T A N T S   A N D   M A C R O S
+ * ****************************************************************************** */
+
+/**
+ * enum _SCSI_TASK_MGMT_REQUEST_CODES - This enumberation contains the
+ *    constants to be used for SCSI task management request codes.  SAM does
+ *    not specify any particular values for these codes so constants used here
+ *    are the same as those specified in SAS.
+ *
+ *
+ */
+enum scsi_task_mgmt_request_codes {
+	SCSI_TASK_REQUEST_ABORT_TASK           = 0x01,
+	SCSI_TASK_REQUEST_ABORT_TASK_SET       = 0x02,
+	SCSI_TASK_REQUEST_CLEAR_TASK_SET       = 0x04,
+	SCSI_TASK_REQUEST_LOGICAL_UNIT_RESET   = 0x08,
+	SCSI_TASK_REQUEST_I_T_NEXUS_RESET      = 0x10,
+	SCSI_TASK_REQUEST_CLEAR_ACA            = 0x40,
+	SCSI_TASK_REQUEST_QUERY_TASK           = 0x80,
+	SCSI_TASK_REQUEST_QUERY_TASK_SET       = 0x81,
+	SCSI_TASK_REQUEST_QUERY_UNIT_ATTENTION = 0x82,
+
+};
+
+/**
+ * enum _SCSI_TASK_MGMT_RESPONSE_CODES - This enumeration contains all of the
+ *    SCSI task management response codes.
+ *
+ *
+ */
+enum scsi_task_mgmt_response_codes {
+	SCSI_TASK_MGMT_FUNC_COMPLETE      = 0,
+	SCSI_INVALID_FRAME                = 2,
+	SCSI_TASK_MGMT_FUNC_NOT_SUPPORTED = 4,
+	SCSI_TASK_MGMT_FUNC_FAILED        = 5,
+	SCSI_TASK_MGMT_FUNC_SUCCEEDED     = 8,
+	SCSI_INVALID_LUN                  = 9
+};
+
+/**
+ * enum _SCSI_SENSE_RESPONSE_CODE - this enumeration depicts the types of sense
+ *    data responses as per SPC-3.
+ *
+ *
+ */
+enum scsi_sense_response_code {
+	SCSI_FIXED_CURRENT_RESPONSE_CODE       = 0x70,
+	SCSI_FIXED_DEFERRED_RESPONSE_CODE      = 0x71,
+	SCSI_DESCRIPTOR_CURRENT_RESPONSE_CODE  = 0x72,
+	SCSI_DESCRIPTOR_DEFERRED_RESPONSE_CODE = 0x73
+
+};
+
+/*
+ * This constant represents the valid bit located in byte 0 of a FIXED
+ * format sense data. */
+#define SCSI_FIXED_SENSE_DATA_VALID_BIT   0x80
+
+#define SCSI_FIXED_SENSE_DATA_BASE_LENGTH 18
+
+/* This value is used in the DATAPRES field of the SCSI Response IU. */
+#define SCSI_RESPONSE_DATA_PRES_SENSE_DATA 0x02
+
+/**
+ *
+ *
+ * SCSI_SENSE_KEYS These constants delineate all of the SCSI protocol sense key
+ * constants
+ */
+#define SCSI_SENSE_NO_SENSE        0x00
+#define SCSI_SENSE_RECOVERED_ERROR 0x01
+#define SCSI_SENSE_NOT_READY       0x02
+#define SCSI_SENSE_MEDIUM_ERROR    0x03
+#define SCSI_SENSE_HARDWARE_ERROR  0x04
+#define SCSI_SENSE_ILLEGAL_REQUEST 0x05
+#define SCSI_SENSE_UNIT_ATTENTION  0x06
+#define SCSI_SENSE_DATA_PROTECT    0x07
+#define SCSI_SENSE_BLANK_CHECK     0x08
+#define SCSI_SENSE_VENDOR_SPECIFIC 0x09
+#define SCSI_SENSE_COPY_ABORTED    0x0A
+#define SCSI_SENSE_ABORTED_COMMAND 0x0B
+#define SCSI_SENSE_VOLUME_OVERFLOW 0x0D
+#define SCSI_SENSE_MISCOMPARE      0x0E
+
+/**
+ *
+ *
+ * SCSI_ADDITIONAL_SENSE_CODES These constants delineate all of the SCSI
+ * protocol additional sense code constants.
+ */
+#define SCSI_ASC_NO_ADDITIONAL_SENSE             0x00
+#define SCSI_ASC_INITIALIZING_COMMAND_REQUIRED   0x04
+#define SCSI_ASC_LUN_SELF_TEST_IN_PROGRESS       0x04
+#define SCSI_ASC_LUN_FORMAT_IN_PROGRESS          0x04
+#define SCSI_ASC_LUN_NOT_RESPOND_TO_SELECTION    0x05
+#define SCSI_ASC_UNRECOVERED_READ_ERROR          0x11
+#define SCSI_ASC_INVALID_COMMAND_OPERATION_CODE  0x20
+#define SCSI_ASC_LBA_OUT_OF_RANGE                0x21
+#define SCSI_ASC_INVALID_FIELD_IN_CDB            0x24
+#define SCSI_ASC_INVALID_FIELD_IN_PARM_LIST      0x26
+#define SCSI_ASC_WRITE_PROTECTED                 0x27
+#define SCSI_ASC_NOT_READY_TO_READY_CHANGE       0x28
+#define SCSI_ASC_SAVING_PARMS_NOT_SUPPORTED      0x39
+#define SCSI_ASC_MEDIUM_NOT_PRESENT              0x3A
+#define SCSI_ASC_INTERNAL_TARGET_FAILURE         0x44
+#define SCSI_ASC_IU_CRC_ERROR_DETECTED           0x47
+#define SCSI_ASC_MEDIUM_REMOVAL_REQUEST          0x5A
+#define SCSI_ASC_COMMAND_SEQUENCE_ERROR          0x2C
+#define SCSI_ASC_MEDIA_LOAD_OR_EJECT_FAILED      0x53
+#define SCSI_ASC_HARDWARE_IMPENDING_FAILURE      0x5D
+#define SCSI_ASC_POWER_STATE_CHANGE              0x5E
+#define SCSI_DIAGNOSTIC_FAILURE_ON_COMPONENT     0x40
+#define SCSI_ASC_ATA_DEVICE_FEATURE_NOT_ENABLED  0x67
+
+/**
+ *
+ *
+ * SCSI_ADDITIONAL_SENSE_CODE_QUALIFIERS This enumeration contains all of the
+ * used SCSI protocol additional sense code qualifier constants.
+ */
+#define SCSI_ASCQ_NO_ADDITIONAL_SENSE                    0x00
+#define SCSI_ASCQ_INVALID_FIELD_IN_CDB                   0x00
+#define SCSI_ASCQ_INVALID_FIELD_IN_PARM_LIST             0x00
+#define SCSI_ASCQ_LUN_NOT_RESPOND_TO_SELECTION           0x00
+#define SCSI_ASCQ_INTERNAL_TARGET_FAILURE                0x00
+#define SCSI_ASCQ_LBA_OUT_OF_RANGE                       0x00
+#define SCSI_ASCQ_MEDIUM_NOT_PRESENT                     0x00
+#define SCSI_ASCQ_NOT_READY_TO_READY_CHANGE              0x00
+#define SCSI_ASCQ_WRITE_PROTECTED                        0x00
+#define SCSI_ASCQ_UNRECOVERED_READ_ERROR                 0x00
+#define SCSI_ASCQ_SAVING_PARMS_NOT_SUPPORTED             0x00
+#define SCSI_ASCQ_INVALID_COMMAND_OPERATION_CODE         0x00
+#define SCSI_ASCQ_MEDIUM_REMOVAL_REQUEST                 0x01
+#define SCSI_ASCQ_INITIALIZING_COMMAND_REQUIRED          0x02
+#define SCSI_ASCQ_IU_CRC_ERROR_DETECTED                  0x03
+#define SCSI_ASCQ_LUN_FORMAT_IN_PROGRESS                 0x04
+#define SCSI_ASCQ_LUN_SELF_TEST_IN_PROGRESS              0x09
+#define SCSI_ASCQ_GENERAL_HARD_DRIVE_FAILURE             0x10
+#define SCSI_ASCQ_IDLE_CONDITION_ACTIVATE_BY_COMMAND     0x03
+#define SCSI_ASCQ_STANDBY_CONDITION_ACTIVATE_BY_COMMAND  0x04
+#define SCSI_ASCQ_POWER_STATE_CHANGE_TO_IDLE             0x42
+#define SCSI_ASCQ_POWER_STATE_CHANGE_TO_STANDBY          0x43
+#define SCSI_ASCQ_ATA_DEVICE_FEATURE_NOT_ENABLED         0x0B
+#define SCSI_ASCQ_UNRECOVERED_READ_ERROR_AUTO_REALLOCATE_FAIL    0x04
+
+
+
+/**
+ *
+ *
+ * SCSI_STATUS_CODES These constants define all of the used SCSI status values.
+ */
+#define SCSI_STATUS_GOOD            0x00
+#define SCSI_STATUS_CHECK_CONDITION 0x02
+#define SCSI_STATUS_CONDITION_MET   0x04
+#define SCSI_STATUS_BUSY            0x08
+#define SCSI_STATUS_TASKFULL        0x28
+#define SCSI_STATUS_ACA             0x30
+#define SCSI_STATUS_ABORT           0x40
+
+/**
+ *
+ *
+ * SCSI_OPERATION_CODES These constants delineate all of the SCSI
+ * command/operation codes.
+ */
+#define SCSI_INQUIRY                0x12
+#define SCSI_READ_CAPACITY_10       0x25
+#define SCSI_SERVICE_ACTION_IN_16   0x9E
+#define SCSI_TEST_UNIT_READY        0x00
+#define SCSI_START_STOP_UNIT        0x1B
+#define SCSI_SYNCHRONIZE_CACHE_10   0x35
+#define SCSI_SYNCHRONIZE_CACHE_16   0x91
+#define SCSI_REQUEST_SENSE          0x03
+#define SCSI_REPORT_LUNS            0xA0
+#define SCSI_REASSIGN_BLOCKS        0x07
+#define SCSI_READ_6                 0x08
+#define SCSI_READ_10                0x28
+#define SCSI_READ_12                0xA8
+#define SCSI_READ_16                0x88
+#define SCSI_WRITE_6                0x0A
+#define SCSI_WRITE_10               0x2A
+#define SCSI_WRITE_12               0xAA
+#define SCSI_WRITE_16               0x8A
+#define SCSI_VERIFY_10              0x2F
+#define SCSI_VERIFY_12              0xAF
+#define SCSI_VERIFY_16              0x8F
+#define SCSI_SEEK_6                 0x01
+#define SCSI_SEEK_10                0x02
+#define SCSI_WRITE_VERIFY           0x2E
+#define SCSI_FORMAT_UNIT            0x04
+#define SCSI_READ_BUFFER            0x3C
+#define SCSI_WRITE_BUFFER           0x3B
+#define SCSI_SEND_DIAGNOSTIC        0x1D
+#define SCSI_RECEIVE_DIAGNOSTIC     0x1C
+#define SCSI_MODE_SENSE_6           0x1A
+#define SCSI_MODE_SENSE_10          0x5A
+#define SCSI_MODE_SELECT_6          0x15
+#define SCSI_MODE_SELECT_10         0x55
+#define SCSI_MAINTENANCE_IN         0xA3
+#define SCSI_LOG_SENSE              0x4D
+#define SCSI_LOG_SELECT             0x4C
+#define SCSI_RESERVE_6              0x16
+#define SCSI_RESERVE_10             0x56
+#define SCSI_RELEASE_6              0x17
+#define SCSI_RELEASE_10             0x57
+#define SCSI_ATA_PASSTHRU_12        0xA1
+#define SCSI_ATA_PASSTHRU_16        0x85
+#define SCSI_WRITE_LONG_10          0x3F
+#define SCSI_WRITE_LONG_16          0x9F
+#define SCSI_PERSISTENT_RESERVE_IN  0x5E
+#define SCSI_PERSISTENT_RESERVE_OUT 0x5F
+
+/**
+ *
+ *
+ * SCSI_SERVICE_ACTION_IN_CODES Service action in operations.
+ */
+#define SCSI_SERVICE_ACTION_IN_CODES_READ_CAPACITY_16     0x10
+
+#define SCSI_SERVICE_ACTION_MASK 0x1f
+
+/**
+ *
+ *
+ * SCSI_MAINTENANCE_IN_SERVICE_ACTION_CODES MAINTENANCE IN service action codes.
+ */
+#define SCSI_REPORT_TASK_MGMT  0x0D
+#define SCSI_REPORT_OP_CODES   0x0C
+
+/**
+ *
+ *
+ * SCSI_MODE_PAGE_CONTROLS These constants delineate all of the used SCSI Mode
+ * Page control values.
+ */
+#define SCSI_MODE_SENSE_PC_CURRENT     0x0
+#define SCSI_MODE_SENSE_PC_CHANGEABLE  0x1
+#define SCSI_MODE_SENSE_PC_DEFAULT     0x2
+#define SCSI_MODE_SENSE_PC_SAVED       0x3
+
+#define SCSI_MODE_SENSE_PC_SHIFT           0x06
+#define SCSI_MODE_SENSE_PAGE_CODE_ENABLE   0x3F
+#define SCSI_MODE_SENSE_DBD_ENABLE         0x08
+#define SCSI_MODE_SENSE_LLBAA_ENABLE       0x10
+
+/**
+ *
+ *
+ * SCSI_MODE_PAGE_CODES These constants delineate all of the used SCSI Mode
+ * Page codes.
+ */
+#define SCSI_MODE_PAGE_READ_WRITE_ERROR           0x01
+#define SCSI_MODE_PAGE_DISCONNECT_RECONNECT       0x02
+#define SCSI_MODE_PAGE_CACHING                    0x08
+#define SCSI_MODE_PAGE_CONTROL                    0x0A
+#define SCSI_MODE_PAGE_PROTOCOL_SPECIFIC_PORT     0x19
+#define SCSI_MODE_PAGE_POWER_CONDITION            0x1A
+#define SCSI_MODE_PAGE_INFORMATIONAL_EXCP_CONTROL 0x1C
+#define SCSI_MODE_PAGE_ALL_PAGES                  0x3F
+
+#define SCSI_MODE_SENSE_ALL_SUB_PAGES_CODE         0xFF
+#define SCSI_MODE_SENSE_NO_SUB_PAGES_CODE          0x0
+#define SCSI_MODE_SENSE_PROTOCOL_PORT_NUM_SUBPAGES 0x1
+#define SCSI_MODE_PAGE_CACHE_PAGE_WCE_BIT          0x04
+#define SCSI_MODE_PAGE_CACHE_PAGE_DRA_BIT          0x20
+#define SCSI_MODE_PAGE_DEXCPT_ENABLE               0x08
+#define SCSI_MODE_SENSE_HEADER_FUA_ENABLE          0x10
+#define SCSI_MODE_PAGE_POWER_CONDITION_STANDBY     0x1
+#define SCSI_MODE_PAGE_POWER_CONDITION_IDLE        0x2
+
+#define SCSI_MODE_SENSE_6_HEADER_LENGTH              4
+#define SCSI_MODE_SENSE_10_HEADER_LENGTH             8
+#define SCSI_MODE_SENSE_STD_BLOCK_DESCRIPTOR_LENGTH  8
+#define SCSI_MODE_SENSE_LLBA_BLOCK_DESCRIPTOR_LENGTH 16
+
+#define SCSI_MODE_PAGE_INFORMATIONAL_EXCP_DXCPT_ENABLE 0x08
+#define SCSI_MODE_PAGE_19_SAS_ID         0x6
+#define SCSI_MODE_PAGE_19_SUB1_PAGE_NUM  0x1
+#define SCSI_MODE_PAGE_19_SUB1_PC        0x59
+
+#define SCSI_MODE_HEADER_MEDIUM_TYPE_SBC 0x00
+
+/* Mode Select constrains related masks value */
+#define SCSI_MODE_SELECT_PF_BIT                       0x1
+#define SCSI_MODE_SELECT_PF_MASK                      0x10
+#define SCSI_MODE_SELECT_MODE_PAGE_MRIE_BYTE          0x6
+#define SCSI_MODE_SELECT_MODE_PAGE_MRIE_MASK          0x0F
+#define SCSI_MODE_SELECT_MODE_PAGE_SPF_MASK           0x40
+#define SCSI_MODE_SELECT_MODE_PAGE_01_AWRE_MASK       0x80
+#define SCSI_MODE_SELECT_MODE_PAGE_01_ARRE_MASK       0x40
+#define SCSI_MODE_SELECT_MODE_PAGE_01_RC_ERBITS_MASK  0x1F
+#define SCSI_MODE_SELECT_MODE_PAGE_08_FSW_LBCSS_NVDIS 0xC1
+#define SCSI_MODE_SELECT_MODE_PAGE_1C_PERF_TEST       0x84
+#define SCSI_MODE_SELECT_MODE_PAGE_0A_TST_TMF_RLEC    0xF1
+#define SCSI_MODE_SELECT_MODE_PAGE_0A_MODIFIER        0xF0
+#define SCSI_MODE_SELECT_MODE_PAGE_0A_UA_SWP          0x38
+#define SCSI_MODE_SELECT_MODE_PAGE_0A_TAS_AUTO        0x47
+
+
+#define SCSI_CONTROL_BYTE_NACA_BIT_ENABLE  0x04
+#define SCSI_MOVE_FUA_BIT_ENABLE           0x08
+#define SCSI_READ_CAPACITY_PMI_BIT_ENABLE  0x01
+#define SCSI_READ_CAPACITY_10_DATA_LENGTH  8
+#define SCSI_READ_CAPACITY_16_DATA_LENGTH  32
+
+/* Inquiry constants */
+#define SCSI_INQUIRY_EVPD_ENABLE          0x01
+#define SCSI_INQUIRY_PAGE_CODE_OFFSET     0x02
+#define SCSI_INQUIRY_SUPPORTED_PAGES_PAGE 0x00
+#define SCSI_INQUIRY_UNIT_SERIAL_NUM_PAGE 0x80
+#define SCSI_INQUIRY_DEVICE_ID_PAGE       0x83
+#define SCSI_INQUIRY_ATA_INFORMATION_PAGE 0x89
+#define SCSI_INQUIRY_BLOCK_DEVICE_PAGE    0xB1
+#define SCSI_INQUIRY_BLOCK_DEVICE_LENGTH  0x3C
+#define SCSI_INQUIRY_STANDARD_ALLOCATION_LENGTH 0x24    /* 36 */
+
+#define SCSI_REQUEST_SENSE_ALLOCATION_LENGTH   0xFC     /* 252 */
+
+/** Defines the log page codes that are use in gathing Smart data
+ */
+#define SCSI_LOG_PAGE_SUPPORTED_PAGES       0x00
+#define SCSI_LOG_PAGE_INFORMATION_EXCEPTION 0x2F
+#define SCSI_LOG_PAGE_SELF_TEST             0x10
+
+/**
+ *
+ *
+ * SCSI_INQUIRY_VPD The following are constants used with vital product data
+ * inquiry pages. Values are already shifted into the proper nibble location.
+ */
+#define SCSI_PIV_ENABLE                 0x80
+#define SCSI_LUN_ASSOCIATION            0x00
+#define SCSI_TARGET_PORT_ASSOCIATION    0x10
+
+#define SCSI_VEN_UNIQUE_IDENTIFIER_TYPE 0x00
+#define SCSI_NAA_IDENTIFIER_TYPE        0x03
+
+#define SCSI_T10_IDENTIFIER_TYPE        0x01
+#define SCSI_BINARY_CODE_SET            0x01
+#define SCSI_ASCII_CODE_SET             0x02
+#define SCSI_FC_PROTOCOL_IDENTIFIER     0x00
+#define SCSI_SAS_PROTOCOL_IDENTIFIER    0x60
+
+#define SCSI_VERIFY_BYTCHK_ENABLED      0x02
+
+#define SCSI_SYNCHRONIZE_CACHE_IMMED_ENABLED 0x02
+/**
+ *
+ *
+ * SCSI_START_STOP_UNIT_POWER_CONDITION_CODES The following are SCSI Start Stop
+ * Unit command Power Condition codes.
+ */
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_START_VALID       0x0
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_ACTIVE            0x1
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_IDLE              0x2
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_STANDBY           0x3
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_LU_CONTROL        0x7
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_FORCE_S_CONTROL   0xB
+
+#define SCSI_START_STOP_UNIT_IMMED_MASK            0x1
+#define SCSI_START_STOP_UNIT_IMMED_SHIFT           0
+
+#define SCSI_START_STOP_UNIT_START_BIT_MASK        0x1
+#define SCSI_START_STOP_UNIT_START_BIT_SHIFT       0
+
+#define SCSI_START_STOP_UNIT_LOEJ_BIT_MASK         0x2
+#define SCSI_START_STOP_UNIT_LOEJ_BIT_SHIFT        1
+
+#define SCSI_START_STOP_UNIT_NO_FLUSH_MASK         0x4
+#define SCSI_START_STOP_UNIT_NO_FLUSH_SHIFT        2
+
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_MODIFIER_MASK   0xF
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_MODIFIER_SHIFT  0
+
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_MASK  0xF0
+#define SCSI_START_STOP_UNIT_POWER_CONDITION_SHIFT 4
+
+#define SCSI_LOG_SENSE_PC_FIELD_MASK      0xC0
+#define SCSI_LOG_SENSE_PC_FIELD_SHIFT     6
+
+#define SCSI_LOG_SENSE_PAGE_CODE_FIELD_MASK      0x3F
+#define SCSI_LOG_SENSE_PAGE_CODE_FIELD_SHIFT     0
+
+/**
+ *
+ *
+ * MRIE - Method of reporting informational exceptions codes
+ */
+#define NO_REPORTING_INFO_EXCEPTION_CONDITION      0x0
+#define ASYNCHRONOUS_EVENT_REPORTING               0x1
+#define ESTABLISH_UNIT_ATTENTION_CONDITION         0x2
+#define CONDITIONALLY_GENERATE_RECOVERED_ERROR     0x3
+#define UNCONDITIONALLY_GENERATE_RECOVERED_ERROR   0x4
+#define GENERATE_NO_SENSE                          0x5
+#define REPORT_INFO_EXCEPTION_CONDITION_ON_REQUEST 0x6
+
+#define SCSI_INFORMATION_EXCEPTION_DEXCPT_BIT      0x08
+
+/* Reassign Blocks masks */
+#define SCSI_REASSIGN_BLOCKS_LONGLBA_BIT           0x02
+#define SCSI_REASSIGN_BLOCKS_LONGLIST_BIT          0x01
+
+#endif /* _SCSI_H_ */
+
diff --git a/drivers/scsi/isci/core/sati_device.h b/drivers/scsi/isci/core/sati_device.h
new file mode 100644
index 0000000..4d1cfde
--- /dev/null
+++ b/drivers/scsi/isci/core/sati_device.h
@@ -0,0 +1,156 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SATI_DEVICE_H_
+#define _SATI_DEVICE_H_
+
+/**
+ * This file contains all of the defintions for the SATI remote device object.
+ *    Some translations require information to be remembered on a per device
+ *    basis.  This information is stored in the object defined in this file.
+ *
+ *
+ */
+
+#include "sati_types.h"
+#include "intel_ata.h"
+
+/**
+ * enum _SATI_DEVICE_STATE - This enumeration depicts the various states
+ *    possible for the a translation remote device object.
+ *
+ *
+ */
+enum sati_device_state {
+	SATI_DEVICE_STATE_OPERATIONAL,
+	SATI_DEVICE_STATE_STOPPED,
+	SATI_DEVICE_STATE_STANDBY,
+	SATI_DEVICE_STATE_IDLE,
+	SATI_DEVICE_STATE_DEVICE_FAULT_OCCURRED,
+	SATI_DEVICE_STATE_FORMAT_UNIT_IN_PROGRESS,
+	SATI_DEVICE_STATE_SELF_TEST_IN_PROGRESS,
+	SATI_DEVICE_STATE_SEQUENCE_INCOMPLETE,
+	SATI_DEVICE_STATE_UNIT_ATTENTION_CONDITION
+
+};
+
+/**
+ *
+ *
+ * SATI_DEVICE_CAPABILITIES These constants define the various capabilities
+ * that a remote device may support for which there is an impact on translation.
+ */
+#define SATI_DEVICE_CAP_UDMA_ENABLE          0x00000001
+#define SATI_DEVICE_CAP_NCQ_REQUESTED_ENABLE 0x00000002
+#define SATI_DEVICE_CAP_NCQ_SUPPORTED_ENABLE 0x00000004
+#define SATI_DEVICE_CAP_48BIT_ENABLE         0x00000008
+#define SATI_DEVICE_CAP_DMA_FUA_ENABLE       0x00000010
+#define SATI_DEVICE_CAP_SMART_SUPPORT        0x00000020
+#define SATI_DEVICE_CAP_REMOVABLE_MEDIA      0x00000040
+#define SATI_DEVICE_CAP_SMART_ENABLE         0x00000080
+#define SATI_DEVICE_CAP_WRITE_UNCORRECTABLE_ENABLE           0x00000100
+#define SATI_DEVICE_CAP_MULTIPLE_SECTORS_PER_PHYSCIAL_SECTOR 0x00000200
+#define SATI_DEVICE_CAP_SMART_SELF_TEST_SUPPORT              0x00000400
+
+
+/**
+ * struct sati_device - The SATI_DEVICE structure define the state of the
+ *    remote device with respect to translation.
+ *
+ *
+ */
+struct sati_device {
+	/**
+	 * This field simply dictates the state of the SATI device.
+	 */
+	enum sati_device_state state;
+
+	/**
+	 * This field indicates features supported by the remote device that
+	 * impact translation execution.
+	 */
+	u16 capabilities;
+
+	/**
+	 * This field indicates the depth of the native command queue supported
+	 * by the device.
+	 */
+	u8 ncq_depth;
+
+	/**
+	 * This field stores the additional sense code for a unit attention
+	 * condition.
+	 */
+	u8 unit_attention_asc;
+
+	/**
+	 * This field indicates the additional sense code qualifier for a unit
+	 * attention condition.
+	 */
+	u8 unit_attention_ascq;
+
+};
+
+void sati_device_construct(
+	struct sati_device *device,
+	bool is_ncq_enabled,
+	u8 max_ncq_depth);
+
+void sati_device_update_capabilities(
+	struct sati_device *device,
+	struct ata_identify_device_data *identify);
+
+#endif /* _SATI_TRANSLATOR_SEQUENCE_H_ */
+
diff --git a/drivers/scsi/isci/core/sati_translator_sequence.h b/drivers/scsi/isci/core/sati_translator_sequence.h
new file mode 100644
index 0000000..592570d
--- /dev/null
+++ b/drivers/scsi/isci/core/sati_translator_sequence.h
@@ -0,0 +1,304 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SATI_TRANSLATOR_SEQUENCE_H_
+#define _SATI_TRANSLATOR_SEQUENCE_H_
+
+/**
+ * This file contains all of the defintions for the SATI translator sequence.
+ *    A translator sequence is simply a defintion for the various sequences of
+ *    commands that occur in this translator.
+ *
+ *
+ */
+
+#include "sati_device.h"
+
+/**
+ * enum _SATI_TRANSLATOR_SEQUENCE_TYPE - This enumeration defines the possible
+ *    sequence types for the translator.
+ *
+ *
+ */
+enum sati_translator_sequence_type {
+	/* SCSI Primary Command (SPC) sequences. */
+	SATI_SEQUENCE_REPORT_LUNS,
+	SATI_SEQUENCE_TEST_UNIT_READY,
+	SATI_SEQUENCE_INQUIRY_STANDARD,
+	SATI_SEQUENCE_INQUIRY_SUPPORTED_PAGES,
+	SATI_SEQUENCE_INQUIRY_SERIAL_NUMBER,
+	SATI_SEQUENCE_INQUIRY_DEVICE_ID,
+	SATI_SEQUENCE_INQUIRY_BLOCK_DEVICE,
+	SATI_SEQUENCE_MODE_SENSE_6_CACHING,
+	SATI_SEQUENCE_MODE_SENSE_6_INFORMATIONAL_EXCP_CONTROL,
+	SATI_SEQUENCE_MODE_SENSE_6_READ_WRITE_ERROR,
+	SATI_SEQUENCE_MODE_SENSE_6_DISCONNECT_RECONNECT,
+	SATI_SEQUENCE_MODE_SENSE_6_CONTROL,
+	SATI_SEQUENCE_MODE_SENSE_6_ALL_PAGES,
+	SATI_SEQUENCE_MODE_SENSE_10_CACHING,
+	SATI_SEQUENCE_MODE_SENSE_10_INFORMATIONAL_EXCP_CONTROL,
+	SATI_SEQUENCE_MODE_SENSE_10_READ_WRITE_ERROR,
+	SATI_SEQUENCE_MODE_SENSE_10_DISCONNECT_RECONNECT,
+	SATI_SEQUENCE_MODE_SENSE_10_CONTROL,
+	SATI_SEQUENCE_MODE_SENSE_10_ALL_PAGES,
+	SATI_SEQUENCE_MODE_SELECT_MODE_PAGE_CACHING,
+	SATI_SEQUENCE_MODE_SELECT_MODE_POWER_CONDITION,
+	SATI_SEQUENCE_MODE_SELECT_MODE_INFORMATION_EXCEPT_CONTROL,
+
+	/* Log Sense Sequences */
+	SATI_SEQUENCE_LOG_SENSE_SELF_TEST_LOG_PAGE,
+	SATI_SEQUENCE_LOG_SENSE_EXTENDED_SELF_TEST_LOG_PAGE,
+	SATI_SEQUENCE_LOG_SENSE_SUPPORTED_LOG_PAGE,
+	SATI_SEQUENCE_LOG_SENSE_INFO_EXCEPTION_LOG_PAGE,
+
+	/* SCSI Block Command (SBC) sequences. */
+
+	SATI_SEQUENCE_READ_6,
+	SATI_SEQUENCE_READ_10,
+	SATI_SEQUENCE_READ_12,
+	SATI_SEQUENCE_READ_16,
+
+	SATI_SEQUENCE_READ_CAPACITY_10,
+	SATI_SEQUENCE_READ_CAPACITY_16,
+
+	SATI_SEQUENCE_SYNCHRONIZE_CACHE,
+
+	SATI_SEQUENCE_VERIFY_10,
+	SATI_SEQUENCE_VERIFY_12,
+	SATI_SEQUENCE_VERIFY_16,
+
+	SATI_SEQUENCE_WRITE_6,
+	SATI_SEQUENCE_WRITE_10,
+	SATI_SEQUENCE_WRITE_12,
+	SATI_SEQUENCE_WRITE_16,
+
+	SATI_SEQUENCE_START_STOP_UNIT,
+
+	SATI_SEQUENCE_REASSIGN_BLOCKS,
+
+	/* SCSI Task Requests sequences */
+
+	SATI_SEQUENCE_LUN_RESET,
+
+	SATI_SEQUENCE_REQUEST_SENSE_SMART_RETURN_STATUS,
+	SATI_SEQUENCE_REQUEST_SENSE_CHECK_POWER_MODE,
+
+	SATI_SEQUENCE_WRITE_LONG
+
+};
+
+#define SATI_SEQUENCE_TYPE_READ_MIN SATI_SEQUENCE_READ_6
+#define SATI_SEQUENCE_TYPE_READ_MAX SATI_SEQUENCE_READ_16
+
+/**
+ *
+ *
+ * SATI_SEQUENCE_STATES These constants depict the various state values
+ * associated with a translation sequence.
+ */
+#define SATI_SEQUENCE_STATE_INITIAL        0
+#define SATI_SEQUENCE_STATE_TRANSLATE_DATA 1
+#define SATI_SEQUENCE_STATE_AWAIT_RESPONSE 2
+#define SATI_SEQUENCE_STATE_FINAL          3
+#define SATI_SEQUENCE_STATE_INCOMPLETE     4
+
+/**
+ *
+ *
+ * SATI_DATA_DIRECTIONS These constants depict the various types of data
+ * directions for a translation sequence.  Data can flow in/out (read/write) or
+ * no data at all.
+ */
+#define SATI_DATA_DIRECTION_NONE 0
+#define SATI_DATA_DIRECTION_IN   1
+#define SATI_DATA_DIRECTION_OUT  2
+
+/**
+ * struct SATI_MODE_SELECT_PROCESSING_STATE - This structure contains all of
+ *    the current processing states for processing mode select 6 and 10
+ *    commands' parameter fields.
+ *
+ *
+ */
+typedef  struct SATI_MODE_SELECT_PROCESSING_STATE {
+	u8 *mode_pages;
+	u32 mode_page_offset;
+	u32 mode_pages_size;
+	u32 size_of_data_processed;
+	u32 total_ata_command_sent;
+	u32 ata_command_sent_for_cmp; /* cmp: current mode page */
+	bool current_mode_page_processed;
+
+} SATI_MODE_SELECT_PROCESSING_STATE_T;
+
+
+enum SATI_REASSIGN_BLOCKS_ATA_COMMAND_STATUS {
+	SATI_REASSIGN_BLOCKS_READY_TO_SEND,
+	SATI_REASSIGN_BLOCKS_COMMAND_FAIL,
+	SATI_REASSIGN_BLOCKS_COMMAND_SUCCESS,
+};
+
+/**
+ * struct sati_reassign_blocks_processing_state - This structure contains all
+ *    of the current processing states for processing reassign block command's
+ *    parameter fields.
+ *
+ *
+ */
+struct sati_reassign_blocks_processing_state {
+	u32 lba_offset;
+	u32 block_lists_size;
+	u8 lba_size;
+	u32 size_of_data_processed;
+	u32 ata_command_sent_for_current_lba;
+	bool current_lba_processed;
+	enum     SATI_REASSIGN_BLOCKS_ATA_COMMAND_STATUS ata_command_status;
+
+};
+
+#define SATI_ATAPI_REQUEST_SENSE_CDB_LENGTH 12
+
+/**
+ * struct sati_atapi_data - The SATI_ATAPI_DATA structure is for sati atapi IO
+ *    specific data.
+ *
+ *
+ */
+struct sati_atapi_data {
+	u8 request_sense_cdb[SATI_ATAPI_REQUEST_SENSE_CDB_LENGTH];
+};
+
+/**
+ * struct sati_translator_sequence - This structure contains all of the
+ *    translation information associated with a particular request.
+ *
+ *
+ */
+struct sati_translator_sequence {
+	/**
+	 * This field contains the sequence type determined by the SATI.
+	 */
+	u8 type;
+
+	/**
+	 * This field indicates the current state for the sequence.
+	 */
+	u8 state;
+
+	/**
+	 * This field indicates the data direction (none, read, or write) for
+	 * the translated request.
+	 */
+	u8 data_direction;
+
+	/**
+	 * This field contains the SATA/ATA protocol to be utilized during
+	 * the IO transfer.
+	 */
+	u8 protocol;
+
+	/**
+	 * This field is utilized for sequences requiring data translation.
+	 * It specifies the amount of data requested by the caller from the
+	 * operation.  It's necessary, because at times the user requests less
+	 * data than is available.  Thus, we need to avoid overrunning the
+	 * buffer.
+	 */
+	u32 allocation_length;
+
+	/**
+	 * This field specifies the amount of data that will actually be
+	 * transfered across the wire for this ATA request.
+	 */
+	u32 ata_transfer_length;
+
+	/**
+	 * This field specifies the amount of data bytes that have been
+	 * set in a translation sequence. It will be incremented every time
+	 * a data byte has been set by a sati translation.
+	 */
+	u16 number_data_bytes_set;
+
+	/**
+	 * This field indicates whether or not the sense response has been set
+	 * by the translation sequence.
+	 */
+	bool is_sense_response_set;
+
+	/**
+	 * This field specifies the remote device context for which this
+	 * translator sequence is destined.
+	 */
+	struct sati_device *device;
+
+	/**
+	 * This field is utilized to provide the translator with memory space
+	 * required for translations that utilize multiple requests.
+	 */
+	union {
+		u32 translated_command;
+		u32 move_sector_count;
+		u32 scratch;
+		struct sati_reassign_blocks_processing_state reassign_blocks_process_state;
+		SATI_MODE_SELECT_PROCESSING_STATE_T process_state;
+		struct sati_atapi_data sati_atapi_data;
+	} command_specific_data;
+
+};
+
+
+
+#endif /* _SATI_TRANSLATOR_SEQUENCE_H_ */
+
diff --git a/drivers/scsi/isci/core/sati_types.h b/drivers/scsi/isci/core/sati_types.h
new file mode 100644
index 0000000..b6159e0
--- /dev/null
+++ b/drivers/scsi/isci/core/sati_types.h
@@ -0,0 +1,145 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SATI_TYPES_H_
+#define _SATI_TYPES_H_
+
+/**
+ * This file contains various type definitions to be utilized with SCSI to ATA
+ *    Translation Implementation.
+ *
+ *
+ */
+
+/**
+ * enum _SATI_STATUS - This enumeration defines the possible return values from
+ *    the SATI translation methods.
+ *
+ *
+ */
+enum sati_status {
+	/**
+	 * This indicates that the translation was supported and occurred
+	 * without error.
+	 */
+	SATI_SUCCESS,
+
+	/**
+	 * This indicates that the translation was supported, occurred without
+	 * error, and no additional translation is necessary.  This is done in
+	 * conditions where the SCSI command doesn't require any interaction with
+	 * the remote device.
+	 */
+	SATI_COMPLETE,
+
+	/**
+	 * This indicated everything SATI_COMPLETE does in addition to the response data
+	 * not using all the memory allocated by the OS.
+	 */
+	SATI_COMPLETE_IO_DONE_EARLY,
+
+	/**
+	 * This indicates that translator sequence has finished some specific
+	 * command in the sequence, but additional commands are necessary.
+	 */
+	SATI_SEQUENCE_INCOMPLETE,
+
+	/**
+	 * This indicates a general failure has occurred for which no further
+	 * specification information is available.
+	 */
+	SATI_FAILURE,
+
+	/**
+	 * This indicates that the result of the IO request indicates a
+	 * failure.  The caller should reference the corresponding response
+	 * data for further details.
+	 */
+	SATI_FAILURE_CHECK_RESPONSE_DATA,
+
+	/**
+	 * This status indicates that the supplied sequence type doesn't map
+	 * to an existing definition.
+	 */
+	SATI_FAILURE_INVALID_SEQUENCE_TYPE,
+
+	/**
+	 * This status indicates that the supplied sequence state doesn't match
+	 * the operation being requested by the user.
+	 */
+	SATI_FAILURE_INVALID_STATE
+
+};
+
+#if (!defined(DISABLE_SATI_MODE_SENSE)	    \
+	|| !defined(DISABLE_SATI_MODE_SELECT)	  \
+	|| !defined(DISABLE_SATI_REQUEST_SENSE)) \
+
+#if !defined(ENABLE_SATI_MODE_PAGES)
+/**
+ *
+ *
+ * This macro enables the common mode page data structures and code. Currently,
+ * MODE SENSE, MODE SELECT, and REQUEST SENSE all make reference to this common
+ * code.  As a result, enable the common mode page code if any of these 3 are
+ * being translated.
+ */
+#define ENABLE_SATI_MODE_PAGES
+#endif  /* !defined(ENABLE_SATI_MODE_PAGES) */
+
+#endif  /* MODE_SENSE/SELECT/REQUEST_SENSE */
+
+#endif  /* _SATI_TYPES_H_ */
+
diff --git a/drivers/scsi/isci/core/sci_pool.h b/drivers/scsi/isci/core/sci_pool.h
new file mode 100644
index 0000000..c0d2ea3
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_pool.h
@@ -0,0 +1,199 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+/**
+ * This file contains the interface to the pool class. This class allows two
+ *    different two different priority tasks to insert and remove items from
+ *    the free pool. The user of the pool is expected to evaluate the pool
+ *    condition empty before a get operation and pool condition full before a
+ *    put operation. Methods Provided: - sci_pool_create() -
+ *    sci_pool_initialize() - sci_pool_empty() - sci_pool_full() -
+ *    sci_pool_get() - sci_pool_put()
+ *
+ *
+ */
+
+#ifndef _SCI_POOL_H_
+#define _SCI_POOL_H_
+
+/**
+ * SCI_POOL_INCREMENT() -
+ *
+ * Private operation for the pool
+ */
+#define SCI_POOL_INCREMENT(this_pool, index) \
+	(((index) + 1) == (this_pool).size ? 0 : (index) + 1)
+
+/**
+ * SCI_POOL_CREATE() -
+ *
+ * This creates a pool structure of pool_name. The members in the pool are of
+ * type with number of elements equal to size.
+ */
+#define SCI_POOL_CREATE(pool_name, type, pool_size) \
+	struct \
+	{ \
+		u32 size; \
+		u32 get; \
+		u32 put; \
+		type array[(pool_size) + 1]; \
+	} pool_name
+
+
+/**
+ * sci_pool_empty() -
+ *
+ * This macro evaluates the pool and returns true if the pool is empty. If the
+ * pool is empty the user should not perform any get operation on the pool.
+ */
+#define sci_pool_empty(this_pool) \
+	((this_pool).get == (this_pool).put)
+
+/**
+ * sci_pool_full() -
+ *
+ * This macro evaluates the pool and returns true if the pool is full.  If the
+ * pool is full the user should not perform any put operation.
+ */
+#define sci_pool_full(this_pool) \
+	(SCI_POOL_INCREMENT(this_pool, (this_pool).put) == (this_pool).get)
+
+/**
+ * sci_pool_size() -
+ *
+ * This macro returns the size of the pool created.  The internal size of the
+ * pool is actually 1 larger then necessary in order to ensure get and put
+ * pointers can be written simultaneously by different users.  As a result,
+ * this macro subtracts 1 from the internal size
+ */
+#define sci_pool_size(this_pool) \
+	((this_pool).size - 1)
+
+/**
+ * sci_pool_count() -
+ *
+ * This macro indicates the number of elements currently contained in the pool.
+ */
+#define sci_pool_count(this_pool) \
+	(\
+		sci_pool_empty((this_pool)) \
+		? 0 \
+		: (\
+			sci_pool_full((this_pool)) \
+			? sci_pool_size((this_pool)) \
+			: (\
+				(this_pool).get > (this_pool).put \
+				? ((this_pool).size - (this_pool).get + (this_pool).put) \
+				: ((this_pool).put - (this_pool).get) \
+				) \
+			) \
+	)
+
+/**
+ * sci_pool_initialize() -
+ *
+ * This macro initializes the pool to an empty condition.
+ */
+#define sci_pool_initialize(this_pool) \
+	{ \
+		(this_pool).size = (sizeof((this_pool).array) / sizeof((this_pool).array[0])); \
+		(this_pool).get = 0; \
+		(this_pool).put = 0; \
+	}
+
+/**
+ * sci_pool_get() -
+ *
+ * This macro will get the next free element from the pool. This should only be
+ * called if the pool is not empty.
+ */
+#define sci_pool_get(this_pool, my_value) \
+	{ \
+		(my_value) = (this_pool).array[(this_pool).get]; \
+		(this_pool).get = SCI_POOL_INCREMENT((this_pool), (this_pool).get); \
+	}
+
+/**
+ * sci_pool_put() -
+ *
+ * This macro will put the value into the pool. This should only be called if
+ * the pool is not full.
+ */
+#define sci_pool_put(this_pool, the_value) \
+	{ \
+		(this_pool).array[(this_pool).put] = (the_value); \
+		(this_pool).put = SCI_POOL_INCREMENT((this_pool), (this_pool).put); \
+	}
+
+/**
+ * sci_pool_erase() -
+ *
+ * This macro will search the pool and remove any elements in the pool matching
+ * the supplied value. This method can only be utilized on pools
+ */
+#define sci_pool_erase(this_pool, type, the_value) \
+	{ \
+		type tmp_value;	\
+		u32 index; \
+		u32 element_count = sci_pool_count((this_pool)); \
+ \
+		for (index = 0; index < element_count; index++) {	\
+			sci_pool_get((this_pool), tmp_value); \
+			if (tmp_value != (the_value)) \
+				sci_pool_put((this_pool), tmp_value); \
+		} \
+	}
+
+#endif /* _SCI_POOL_H_ */
diff --git a/drivers/scsi/isci/core/sci_status.h b/drivers/scsi/isci/core/sci_status.h
new file mode 100644
index 0000000..72b6108
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_status.h
@@ -0,0 +1,409 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SCI_STATUS_H_
+#define _SCI_STATUS_H_
+
+/**
+ * This file contains all of the return status codes utilized across the
+ *    various sub-components in SCI.
+ *
+ *
+ */
+
+
+/**
+ * enum _SCI_STATUS - This is the general return status enumeration for non-IO,
+ *    non-task management related SCI interface methods.
+ *
+ *
+ */
+enum sci_status {
+	/**
+	 * This member indicates successful completion.
+	 */
+	SCI_SUCCESS = 0,
+
+	/**
+	 * This value indicates that the calling method completed successfully,
+	 * but that the IO may have completed before having it's start method
+	 * invoked.  This occurs during SAT translation for requests that do
+	 * not require an IO to the target or for any other requests that may
+	 * be completed without having to submit IO.
+	 */
+	SCI_SUCCESS_IO_COMPLETE_BEFORE_START,
+
+	/**
+	 *  This Value indicates that the SCU hardware returned an early response
+	 *  because the io request specified more data than is returned by the
+	 *  target device (mode pages, inquiry data, etc.). The completion routine
+	 *  will handle this case to get the actual number of bytes transferred.
+	 */
+	SCI_SUCCESS_IO_DONE_EARLY,
+
+	/**
+	 * This member indicates that the object for which a state change is
+	 * being requested is already in said state.
+	 */
+	SCI_WARNING_ALREADY_IN_STATE,
+
+	/**
+	 * This member indicates interrupt coalescence timer may cause SAS
+	 * specification compliance issues (i.e. SMP target mode response
+	 * frames must be returned within 1.9 milliseconds).
+	 */
+	SCI_WARNING_TIMER_CONFLICT,
+
+	/**
+	 * This field indicates a sequence of action is not completed yet. Mostly,
+	 * this status is used when multiple ATA commands are needed in a SATI translation.
+	 */
+	SCI_WARNING_SEQUENCE_INCOMPLETE,
+
+	/**
+	 * This member indicates that there was a general failure.
+	 */
+	SCI_FAILURE,
+
+	/**
+	 * This member indicates that the SCI implementation is unable to complete
+	 * an operation due to a critical flaw the prevents any further operation
+	 * (i.e. an invalid pointer).
+	 */
+	SCI_FATAL_ERROR,
+
+	/**
+	 * This member indicates the calling function failed, because the state
+	 * of the controller is in a state that prevents successful completion.
+	 */
+	SCI_FAILURE_INVALID_STATE,
+
+	/**
+	 * This member indicates the calling function failed, because there is
+	 * insufficient resources/memory to complete the request.
+	 */
+	SCI_FAILURE_INSUFFICIENT_RESOURCES,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * controller object required for the operation can't be located.
+	 */
+	SCI_FAILURE_CONTROLLER_NOT_FOUND,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * discovered controller type is not supported by the library.
+	 */
+	SCI_FAILURE_UNSUPPORTED_CONTROLLER_TYPE,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * requested initialization data version isn't supported.
+	 */
+	SCI_FAILURE_UNSUPPORTED_INIT_DATA_VERSION,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * requested configuration of SAS Phys into SAS Ports is not supported.
+	 */
+	SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * requested protocol is not supported by the remote device, port,
+	 * or controller.
+	 */
+	SCI_FAILURE_UNSUPPORTED_PROTOCOL,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * requested information type is not supported by the SCI implementation.
+	 */
+	SCI_FAILURE_UNSUPPORTED_INFORMATION_TYPE,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * device already exists.
+	 */
+	SCI_FAILURE_DEVICE_EXISTS,
+
+	/**
+	 * This member indicates the calling function failed, because adding
+	 * a phy to the object is not possible.
+	 */
+	SCI_FAILURE_ADDING_PHY_UNSUPPORTED,
+
+	/**
+	 * This member indicates the calling function failed, because the
+	 * requested information type is not supported by the SCI implementation.
+	 */
+	SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD,
+
+	/**
+	 * This member indicates the calling function failed, because the SCI
+	 * implementation does not support the supplied time limit.
+	 */
+	SCI_FAILURE_UNSUPPORTED_TIME_LIMIT,
+
+	/**
+	 * This member indicates the calling method failed, because the SCI
+	 * implementation does not contain the specified Phy.
+	 */
+	SCI_FAILURE_INVALID_PHY,
+
+	/**
+	 * This member indicates the calling method failed, because the SCI
+	 * implementation does not contain the specified Port.
+	 */
+	SCI_FAILURE_INVALID_PORT,
+
+	/**
+	 * This member indicates the calling method was partly successful
+	 * The port was reset but not all phys in port are operational
+	 */
+	SCI_FAILURE_RESET_PORT_PARTIAL_SUCCESS,
+
+	/**
+	 * This member indicates that calling method failed
+	 * The port reset did not complete because none of the phys are operational
+	 */
+	SCI_FAILURE_RESET_PORT_FAILURE,
+
+	/**
+	 * This member indicates the calling method failed, because the SCI
+	 * implementation does not contain the specified remote device.
+	 */
+	SCI_FAILURE_INVALID_REMOTE_DEVICE,
+
+	/**
+	 * This member indicates the calling method failed, because the remote
+	 * device is in a bad state and requires a reset.
+	 */
+	SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED,
+
+	/**
+	 * This member indicates the calling method failed, because the SCI
+	 * implementation does not contain or support the specified IO tag.
+	 */
+	SCI_FAILURE_INVALID_IO_TAG,
+
+	/**
+	 * This member indicates that the operation failed and the user should
+	 * check the response data associated with the IO.
+	 */
+	SCI_FAILURE_IO_RESPONSE_VALID,
+
+	/**
+	 * This member indicates that the operation failed, the failure is
+	 * controller implementation specific, and the response data associated
+	 * with the request is not valid.  You can query for the controller
+	 * specific error information via scic_controller_get_request_status()
+	 */
+	SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR,
+
+	/**
+	 * This member indicated that the operation failed because the
+	 * user requested this IO to be terminated.
+	 */
+	SCI_FAILURE_IO_TERMINATED,
+
+	/**
+	 * This member indicates that the operation failed and the associated
+	 * request requires a SCSI abort task to be sent to the target.
+	 */
+	SCI_FAILURE_IO_REQUIRES_SCSI_ABORT,
+
+	/**
+	 * This member indicates that the operation failed because the supplied
+	 * device could not be located.
+	 */
+	SCI_FAILURE_DEVICE_NOT_FOUND,
+
+	/**
+	 * This member indicates that the operation failed because the
+	 * objects association is required and is not correctly set.
+	 */
+	SCI_FAILURE_INVALID_ASSOCIATION,
+
+	/**
+	 * This member indicates that the operation failed, because a timeout
+	 * occurred.
+	 */
+	SCI_FAILURE_TIMEOUT,
+
+	/**
+	 * This member indicates that the operation failed, because the user
+	 * specified a value that is either invalid or not supported.
+	 */
+	SCI_FAILURE_INVALID_PARAMETER_VALUE,
+
+	/**
+	 * This value indicates that the operation failed, because the number
+	 * of messages (MSI-X) is not supported.
+	 */
+	SCI_FAILURE_UNSUPPORTED_MESSAGE_COUNT,
+
+	/**
+	 * This value indicates that the method failed due to a lack of
+	 * available NCQ tags.
+	 */
+	SCI_FAILURE_NO_NCQ_TAG_AVAILABLE,
+
+	/**
+	 * This value indicates that a protocol violation has occurred on the
+	 * link.
+	 */
+	SCI_FAILURE_PROTOCOL_VIOLATION,
+
+	/**
+	 * This value indicates a failure condition that retry may help to clear.
+	 */
+	SCI_FAILURE_RETRY_REQUIRED,
+
+	/**
+	 * This field indicates the retry limit was reached when a retry is attempted
+	 */
+	SCI_FAILURE_RETRY_LIMIT_REACHED,
+
+	/**
+	 * This member indicates the calling method was partly successful.
+	 * Mostly, this status is used when a LUN_RESET issued to an expander attached
+	 * STP device in READY NCQ substate needs to have RNC suspended/resumed
+	 * before posting TC.
+	 */
+	SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS,
+
+	/**
+	 * This field indicates an illegal phy connection based on the routing attribute
+	 * of both expander phy attached to each other.
+	 */
+	SCI_FAILURE_ILLEGAL_ROUTING_ATTRIBUTE_CONFIGURATION,
+
+	/**
+	 * This field indicates a CONFIG ROUTE INFO command has a response with function result
+	 * INDEX DOES NOT EXIST, usually means exceeding max route index.
+	 */
+	SCI_FAILURE_EXCEED_MAX_ROUTE_INDEX,
+
+	/**
+	 * This value indicates that an unsupported PCI device ID has been
+	 * specified.  This indicates that attempts to invoke
+	 * scic_library_allocate_controller() will fail.
+	 */
+	SCI_FAILURE_UNSUPPORTED_PCI_DEVICE_ID
+
+};
+
+/**
+ * enum _SCI_IO_STATUS - This enumeration depicts all of the possible IO
+ *    completion status values.  Each value in this enumeration maps directly
+ *    to a value in the enum sci_status enumeration.  Please refer to that
+ *    enumeration for detailed comments concerning what the status represents.
+ *
+ * Add the API to retrieve the SCU status from the core. Check to see that the
+ * following status are properly handled: - SCI_IO_FAILURE_UNSUPPORTED_PROTOCOL
+ * - SCI_IO_FAILURE_INVALID_IO_TAG
+ */
+enum sci_io_status {
+	SCI_IO_SUCCESS                         = SCI_SUCCESS,
+	SCI_IO_FAILURE                         = SCI_FAILURE,
+	SCI_IO_SUCCESS_COMPLETE_BEFORE_START   = SCI_SUCCESS_IO_COMPLETE_BEFORE_START,
+	SCI_IO_SUCCESS_IO_DONE_EARLY           = SCI_SUCCESS_IO_DONE_EARLY,
+	SCI_IO_FAILURE_INVALID_STATE           = SCI_FAILURE_INVALID_STATE,
+	SCI_IO_FAILURE_INSUFFICIENT_RESOURCES  = SCI_FAILURE_INSUFFICIENT_RESOURCES,
+	SCI_IO_FAILURE_UNSUPPORTED_PROTOCOL    = SCI_FAILURE_UNSUPPORTED_PROTOCOL,
+	SCI_IO_FAILURE_RESPONSE_VALID          = SCI_FAILURE_IO_RESPONSE_VALID,
+	SCI_IO_FAILURE_CONTROLLER_SPECIFIC_ERR = SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR,
+	SCI_IO_FAILURE_TERMINATED              = SCI_FAILURE_IO_TERMINATED,
+	SCI_IO_FAILURE_REQUIRES_SCSI_ABORT     = SCI_FAILURE_IO_REQUIRES_SCSI_ABORT,
+	SCI_IO_FAILURE_INVALID_PARAMETER_VALUE = SCI_FAILURE_INVALID_PARAMETER_VALUE,
+	SCI_IO_FAILURE_NO_NCQ_TAG_AVAILABLE    = SCI_FAILURE_NO_NCQ_TAG_AVAILABLE,
+	SCI_IO_FAILURE_PROTOCOL_VIOLATION      = SCI_FAILURE_PROTOCOL_VIOLATION,
+
+	SCI_IO_FAILURE_REMOTE_DEVICE_RESET_REQUIRED = SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED,
+
+	SCI_IO_FAILURE_RETRY_REQUIRED      = SCI_FAILURE_RETRY_REQUIRED,
+	SCI_IO_FAILURE_RETRY_LIMIT_REACHED = SCI_FAILURE_RETRY_LIMIT_REACHED,
+	SCI_IO_FAILURE_INVALID_REMOTE_DEVICE = SCI_FAILURE_INVALID_REMOTE_DEVICE
+};
+
+/**
+ * enum _SCI_TASK_STATUS - This enumeration depicts all of the possible task
+ *    completion status values.  Each value in this enumeration maps directly
+ *    to a value in the enum sci_status enumeration.  Please refer to that
+ *    enumeration for detailed comments concerning what the status represents.
+ *
+ * Check to see that the following status are properly handled:
+ */
+enum sci_task_status {
+	SCI_TASK_SUCCESS                         = SCI_SUCCESS,
+	SCI_TASK_FAILURE                         = SCI_FAILURE,
+	SCI_TASK_FAILURE_INVALID_STATE           = SCI_FAILURE_INVALID_STATE,
+	SCI_TASK_FAILURE_INSUFFICIENT_RESOURCES  = SCI_FAILURE_INSUFFICIENT_RESOURCES,
+	SCI_TASK_FAILURE_UNSUPPORTED_PROTOCOL    = SCI_FAILURE_UNSUPPORTED_PROTOCOL,
+	SCI_TASK_FAILURE_INVALID_TAG             = SCI_FAILURE_INVALID_IO_TAG,
+	SCI_TASK_FAILURE_RESPONSE_VALID          = SCI_FAILURE_IO_RESPONSE_VALID,
+	SCI_TASK_FAILURE_CONTROLLER_SPECIFIC_ERR = SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR,
+	SCI_TASK_FAILURE_TERMINATED              = SCI_FAILURE_IO_TERMINATED,
+	SCI_TASK_FAILURE_INVALID_PARAMETER_VALUE = SCI_FAILURE_INVALID_PARAMETER_VALUE,
+
+	SCI_TASK_FAILURE_REMOTE_DEVICE_RESET_REQUIRED = SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED,
+	SCI_TASK_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS = SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS
+
+};
+
+
+#endif  /* _SCI_STATUS_H_ */
+
diff --git a/drivers/scsi/isci/core/sci_util.c b/drivers/scsi/isci/core/sci_util.c
new file mode 100644
index 0000000..cb3e9f7
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_util.c
@@ -0,0 +1,101 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#include <linux/kernel.h>
+#include "sci_util.h"
+#include "sci_environment.h"
+
+void scic_word_copy_with_swap(
+	u32 *destination,
+	u32 *source,
+	u32 word_count)
+{
+	while (word_count--) {
+		*destination = SCIC_SWAP_DWORD(*source);
+
+		source++;
+		destination++;
+	}
+}
+
+void *scic_request_get_virt_addr(struct scic_sds_request *sci_req, dma_addr_t phys_addr)
+{
+	struct isci_request *ireq = sci_object_get_association(sci_req);
+	dma_addr_t offset;
+
+	BUG_ON(phys_addr < ireq->request_daddr);
+
+	offset = phys_addr - ireq->request_daddr;
+
+	BUG_ON(offset >= ireq->request_alloc_size);
+
+	return (char *)ireq + offset;
+}
+
+dma_addr_t scic_io_request_get_dma_addr(struct scic_sds_request *sds_request,
+					void *virt_addr)
+{
+	struct isci_request *isci_request =
+		(struct isci_request *)sci_object_get_association(sds_request);
+
+	char *requested_addr = (char *)virt_addr;
+	char *base_addr = (char *)isci_request;
+
+	BUG_ON(requested_addr < base_addr);
+	BUG_ON((requested_addr - base_addr) >=
+			isci_request->request_alloc_size);
+
+	return isci_request->request_daddr + (requested_addr - base_addr);
+}
diff --git a/drivers/scsi/isci/core/sci_util.h b/drivers/scsi/isci/core/sci_util.h
new file mode 100644
index 0000000..b6f43e2
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_util.h
@@ -0,0 +1,108 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SCI_UTIL_H_
+#define _SCI_UTIL_H_
+
+#include <linux/string.h>
+#include "scic_sds_request.h"
+
+/**
+ * SCIC_SWAP_DWORD() -
+ *
+ * Normal byte swap macro
+ */
+#define SCIC_SWAP_DWORD(x) \
+	(\
+		(((x) >> 24) & 0x000000FF) \
+		| (((x) >>  8) & 0x0000FF00) \
+		| (((x) <<  8) & 0x00FF0000) \
+		| (((x) << 24) & 0xFF000000) \
+	)
+
+#define SCIC_BUILD_DWORD(char_buffer) \
+	(\
+		((char_buffer)[0] << 24) \
+		| ((char_buffer)[1] << 16) \
+		| ((char_buffer)[2] <<  8) \
+		| ((char_buffer)[3]) \
+	)
+
+#define SCI_FIELD_OFFSET(type, field)   ((unsigned long)&(((type *)0)->field))
+
+
+#define sci_cb_make_physical_address(physical_addr, addr_upper, addr_lower) \
+	((physical_addr) = (addr_lower) | ((u64)addr_upper) << 32)
+
+/**
+ * scic_word_copy_with_swap() - Copy the data from source to destination and
+ *    swap the bytes during the copy.
+ * @destination: This parameter specifies the destination address to which the
+ *    data is to be copied.
+ * @source: This parameter specifies the source address from which data is to
+ *    be copied.
+ * @word_count: This parameter specifies the number of 32-bit words to copy and
+ *    byte swap.
+ *
+ */
+void scic_word_copy_with_swap(u32 *destination, u32 *source, u32 word_count);
+
+void *scic_request_get_virt_addr(struct scic_sds_request *sds_request,
+				 dma_addr_t phys_addr);
+
+dma_addr_t scic_io_request_get_dma_addr(struct scic_sds_request *sds_request,
+					void *virt_addr);
+
+#endif /* _SCI_UTIL_H_ */
diff --git a/drivers/scsi/isci/core/scic_config_parameters.h b/drivers/scsi/isci/core/scic_config_parameters.h
new file mode 100644
index 0000000..485fefc
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_config_parameters.h
@@ -0,0 +1,346 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SCIC_SDS_USER_PARAMETERS_H_
+#define _SCIC_SDS_USER_PARAMETERS_H_
+
+/**
+ * This file contains all of the structure definitions and interface methods
+ *    that can be called by a SCIC user on the SCU Driver Standard
+ *    (struct scic_sds_user_parameters) user parameter block.
+ *
+ *
+ */
+
+
+#include "sci_status.h"
+#include "intel_sas.h"
+#include "sci_controller_constants.h"
+
+struct scic_sds_controller;
+
+/**
+ *
+ *
+ * SCIC_SDS_PARM_PHY_SPEED These constants define the speeds utilized for a
+ * phy/port.
+ */
+#define SCIC_SDS_PARM_NO_SPEED   0
+
+/**
+ *
+ *
+ * This value of 1 indicates generation 1 (i.e. 1.5 Gb/s).
+ */
+#define SCIC_SDS_PARM_GEN1_SPEED 1
+
+/**
+ *
+ *
+ * This value of 2 indicates generation 2 (i.e. 3.0 Gb/s).
+ */
+#define SCIC_SDS_PARM_GEN2_SPEED 2
+
+/**
+ *
+ *
+ * This value of 3 indicates generation 3 (i.e. 6.0 Gb/s).
+ */
+#define SCIC_SDS_PARM_GEN3_SPEED 3
+
+/**
+ *
+ *
+ * For range checks, the max speed generation
+ */
+#define SCIC_SDS_PARM_MAX_SPEED SCIC_SDS_PARM_GEN3_SPEED
+
+/**
+ * struct scic_sds_user_parameters - This structure delineates the various user
+ *    parameters that can be changed by the core user.
+ *
+ *
+ */
+struct scic_sds_user_parameters {
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
+	u8 max_number_concurrent_device_spin_up;
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
+	 * These timer values specifies how long a link will remain open in increments
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
+/**
+ * This structure/union specifies the various different user parameter sets
+ *    available.  Each type is specific to a hardware controller version.
+ *
+ * union scic_user_parameters
+ */
+union scic_user_parameters {
+	/**
+	 * This field specifies the user parameters specific to the
+	 * Storage Controller Unit (SCU) Driver Standard (SDS) version
+	 * 1.
+	 */
+	struct scic_sds_user_parameters sds1;
+
+};
+
+
+/**
+ *
+ *
+ * SCIC_SDS_OEM_PHY_MASK These constants define the valid values for phy_mask
+ */
+
+/**
+ *
+ *
+ * This is the min value assignable to a port's phy mask
+ */
+#define SCIC_SDS_PARM_PHY_MASK_MIN 0x0
+
+/**
+ *
+ *
+ * This is the max value assignable to a port's phy mask
+ */
+#define SCIC_SDS_PARM_PHY_MASK_MAX 0xF
+
+/**
+ * struct scic_sds_oem_parameters - This structure delineates the various OEM
+ *    parameters that must be set the core user.
+ *
+ *
+ */
+struct scic_sds_oem_parameters {
+	struct {
+		/**
+		 * This field indicates whether Spread Spectrum Clocking (SSC)
+		 * should be enabled or disabled.
+		 */
+		bool do_enable_ssc;
+
+	} controller;
+
+	struct {
+		/**
+		 * This field specifies the phys to be contained inside a port.
+		 * The bit position in the mask specifies the index of the phy
+		 * to be contained in the port.  Multiple bits (i.e. phys)
+		 * can be contained in a single port.
+		 */
+		u8 phy_mask;
+
+	} ports[SCI_MAX_PORTS];
+
+	struct sci_phy_oem_params {
+		/**
+		 * This field specifies the SAS address to be transmitted on
+		 * for this phy index.
+		 */
+		struct sci_sas_address sas_address;
+
+	} phys[SCI_MAX_PHYS];
+
+};
+
+/**
+ * This structure/union specifies the various different OEM parameter sets
+ *    available.  Each type is specific to a hardware controller version.
+ *
+ * union scic_oem_parameters
+ */
+union scic_oem_parameters {
+	/**
+	 * This field specifies the OEM parameters specific to the
+	 * Storage Controller Unit (SCU) Driver Standard (SDS) version
+	 * 1.
+	 */
+	struct scic_sds_oem_parameters sds1;
+
+};
+
+/**
+ * scic_user_parameters_set() - This method allows the user to attempt to
+ *    change the user parameters utilized by the controller.
+ * @controller: This parameter specifies the controller on which to set the
+ *    user parameters.
+ * @user_parameters: This parameter specifies the USER_PARAMETERS object
+ *    containing the potential new values.
+ *
+ * Indicate if the update of the user parameters was successful. SCI_SUCCESS
+ * This value is returned if the operation succeeded. SCI_FAILURE_INVALID_STATE
+ * This value is returned if the attempt to change the user parameter failed,
+ * because changing one of the parameters is not currently allowed.
+ * SCI_FAILURE_INVALID_PARAMETER_VALUE This value is returned if the user
+ * supplied an invalid interrupt coalescence time, spin up delay interval, etc.
+ */
+enum sci_status scic_user_parameters_set(
+	struct scic_sds_controller *controller,
+	union scic_user_parameters *user_parameters);
+
+/**
+ * scic_user_parameters_get() - This method allows the user to retrieve the
+ *    user parameters utilized by the controller.
+ * @controller: This parameter specifies the controller on which to set the
+ *    user parameters.
+ * @user_parameters: This parameter specifies the USER_PARAMETERS object into
+ *    which the framework shall save it's parameters.
+ *
+ */
+void scic_user_parameters_get(
+	struct scic_sds_controller *controller,
+	union scic_user_parameters *user_parameters);
+
+/**
+ * scic_oem_parameters_set() - This method allows the user to attempt to change
+ *    the OEM parameters utilized by the controller.
+ * @controller: This parameter specifies the controller on which to set the
+ *    user parameters.
+ * @oem_parameters: This parameter specifies the OEM parameters object
+ *    containing the potential new values.
+ *
+ * Indicate if the update of the user parameters was successful. SCI_SUCCESS
+ * This value is returned if the operation succeeded. SCI_FAILURE_INVALID_STATE
+ * This value is returned if the attempt to change the user parameter failed,
+ * because changing one of the parameters is not currently allowed.
+ * SCI_FAILURE_INVALID_PARAMETER_VALUE This value is returned if the user
+ * supplied an unsupported value for one of the OEM parameters.
+ */
+enum sci_status scic_oem_parameters_set(
+	struct scic_sds_controller *controller,
+	union scic_oem_parameters *oem_parameters);
+
+/**
+ * scic_oem_parameters_get() - This method allows the user to retreive the OEM
+ *    parameters utilized by the controller.
+ * @controller: This parameter specifies the controller on which to set the
+ *    user parameters.
+ * @oem_parameters: This parameter specifies the OEM parameters object in which
+ *    to write the core's OEM parameters.
+ *
+ */
+void scic_oem_parameters_get(
+	struct scic_sds_controller *controller,
+	union scic_oem_parameters *oem_parameters);
+
+
+#endif  /* _SCIC_SDS_USER_PARAMETERS_H_ */
+
diff --git a/drivers/scsi/isci/core/scic_sds_pci.h b/drivers/scsi/isci/core/scic_sds_pci.h
new file mode 100644
index 0000000..bf0cbca
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_pci.h
@@ -0,0 +1,94 @@
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
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#ifndef _SCIC_SDS_PCI_H_
+#define _SCIC_SDS_PCI_H_
+
+/**
+ * This file contains the prototypes/macros utilized in writing out PCI data
+ *    for the SCI core.
+ *
+ *
+ */
+
+#include <asm/io.h>
+
+struct scic_sds_controller;
+
+void scic_sds_pci_bar_initialization(struct scic_sds_controller *scic);
+
+/* for debug we separate scu and smu accesses and require a controller */
+static inline u32 scic_sds_pci_read_smu_dword(struct scic_sds_controller *scic, void __iomem *addr)
+{
+	return readl(addr);
+}
+
+static inline void scic_sds_pci_write_smu_dword(struct scic_sds_controller *scic, void __iomem *addr, u32 value)
+{
+	writel(value, addr);
+}
+
+static inline u32 scic_sds_pci_read_scu_dword(struct scic_sds_controller *scic, void __iomem *addr)
+{
+	return readl(addr);
+}
+
+static inline void scic_sds_pci_write_scu_dword(struct scic_sds_controller *scic, void __iomem *addr, u32 value)
+{
+	writel(value, addr);
+}
+
+
+#endif /* _SCIC_SDS_PCI_H_ */

