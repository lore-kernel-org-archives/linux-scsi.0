From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: add MMIO write to perform BIST for 64 bit adapters
Date: Thu, 17 Jun 2010 11:51:40 -0700
Message-ID: <4C1A6EBC.4030502@linux.vnet.ibm.com>
References: <20100617180257.008451213@linux.vnet.ibm.com> <4C1A6708.4040408@linux.vnet.ibm.com> <4C1A6B92.9000604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34372 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094Ab0FQSvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 14:51:53 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIYqcO017213
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 14:34:52 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HIpqvN145074
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 14:51:52 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIpfkP013356
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:51:42 -0600
In-Reply-To: <4C1A6B92.9000604@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>


On 06/17/2010 11:38 AM, Brian King wrote:
> On 06/17/2010 01:18 PM, Wayne Boyer wrote:
>> @@ -7448,20 +7448,25 @@ static int ipr_reset_bist_done(struct ip
>>  static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
>>  {
>>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
>> -	int rc;
>> +	int rc = PCIBIOS_SUCCESSFUL;
>>
>>  	ENTER;
>>  	pci_block_user_cfg_access(ioa_cfg->pdev);
>> -	rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
>>
>> -	if (rc != PCIBIOS_SUCCESSFUL) {
>> -		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
>> -		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
>> -		rc = IPR_RC_JOB_CONTINUE;
>> -	} else {
>> +	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
>> +		writel(IPR_UPROCI_SIS64_START_BIST,
>> +		       ioa_cfg->regs.sense_uproc_interrupt_reg32);
> 
> This should be writing to ioa_cfg->regs.set_uproc_interrupt_reg32 instead.
> 

Thanks for catching that.  Updated patch below.

---

The 64 bit chip used in new adapters does not properly support the BIST register
in PCI config space.  This patch implements an alternative MMIO write reset
method.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   37 +++++++++++++++++++++----------------
 drivers/scsi/ipr.h |    4 ++++
 2 files changed, 25 insertions(+), 16 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-06-17 08:19:35.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-06-17 11:40:26.000000000 -0700
@@ -174,15 +174,15 @@ static const struct ipr_chip_cfg_t ipr_c
 };

 static const struct ipr_chip_t ipr_chip[] = {
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, IPR_USE_MSI, IPR_SIS32, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, &ipr_chip_cfg[2] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2, IPR_USE_MSI, IPR_SIS64, &ipr_chip_cfg[2] }
+	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, IPR_USE_MSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
 };

 static int ipr_max_bus_speeds [] = {
@@ -7448,20 +7448,25 @@ static int ipr_reset_bist_done(struct ip
 static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	int rc;
+	int rc = PCIBIOS_SUCCESSFUL;

 	ENTER;
 	pci_block_user_cfg_access(ioa_cfg->pdev);
-	rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);

-	if (rc != PCIBIOS_SUCCESSFUL) {
-		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
-		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
-		rc = IPR_RC_JOB_CONTINUE;
-	} else {
+	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
+		writel(IPR_UPROCI_SIS64_START_BIST,
+		       ioa_cfg->regs.set_uproc_interrupt_reg32);
+	else
+		rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
+
+	if (rc == PCIBIOS_SUCCESSFUL) {
 		ipr_cmd->job_step = ipr_reset_bist_done;
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
+	} else {
+		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
+		rc = IPR_RC_JOB_CONTINUE;
 	}

 	LEAVE;
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-06-17 08:18:20.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-06-17 10:57:35.000000000 -0700
@@ -272,6 +272,7 @@ IPR_PCII_NO_HOST_RRQ | IPR_PCII_IOARRIN_

 #define IPR_UPROCI_RESET_ALERT			(0x80000000 >> 7)
 #define IPR_UPROCI_IO_DEBUG_ALERT			(0x80000000 >> 9)
+#define IPR_UPROCI_SIS64_START_BIST			(0x80000000 >> 23)

 #define IPR_LDUMP_MAX_LONG_ACK_DELAY_IN_USEC		200000	/* 200 ms */
 #define IPR_LDUMP_MAX_SHORT_ACK_DELAY_IN_USEC		200000	/* 200 ms */
@@ -1301,6 +1302,9 @@ struct ipr_chip_t {
 	u16 sis_type;
 #define IPR_SIS32			0x00
 #define IPR_SIS64			0x01
+	u16 bist_method;
+#define IPR_PCI_CFG			0x00
+#define IPR_MMIO			0x01
 	const struct ipr_chip_cfg_t *cfg;
 };

