From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/9] isci: fix 32-bit operation when CONFIG_HIGHMEM64G=n
Date: Fri, 29 Jul 2011 17:16:45 -0700
Message-ID: <20110730001645.28430.89776.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3AQp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:16:45 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: stable@kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

The unsolicited frame control infrastructure requires a table of dma
addresses for the hardware to lookup the frame buffer location by an
index.  The hardware expects the elements of this table to be 64-bit
quantities, so we cannot reference these elements as dma_addr_t.  All
unsolicited frame protocols are affected, particularly SATA-PIO and SMP
which prevented direct-attached SATA drives and expander-attached drives
to not be discovered.

Cc: <stable@kernel.org>
Reported-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/unsolicited_frame_control.c |    2 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/unsolicited_frame_control.c b/drivers/scsi/isci/unsolicited_frame_control.c
index e9e1e2a..16f88ab 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.c
+++ b/drivers/scsi/isci/unsolicited_frame_control.c
@@ -72,7 +72,7 @@ int sci_unsolicited_frame_control_construct(struct isci_host *ihost)
 	 */
 	buf_len = SCU_MAX_UNSOLICITED_FRAMES * SCU_UNSOLICITED_FRAME_BUFFER_SIZE;
 	header_len = SCU_MAX_UNSOLICITED_FRAMES * sizeof(struct scu_unsolicited_frame_header);
-	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(dma_addr_t);
+	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(uf_control->address_table.array[0]);
 
 	/*
 	 * The Unsolicited Frame buffers are set at the start of the UF
diff --git a/drivers/scsi/isci/unsolicited_frame_control.h b/drivers/scsi/isci/unsolicited_frame_control.h
index 31cb950..75d8966 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.h
+++ b/drivers/scsi/isci/unsolicited_frame_control.h
@@ -214,7 +214,7 @@ struct sci_uf_address_table_array {
 	 * starting address of the UF address table.
 	 * 64-bit pointers are required by the hardware.
 	 */
-	dma_addr_t *array;
+	u64 *array;
 
 	/**
 	 * This field specifies the physical address location for the UF

