Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0042C2D0D6
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE91206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLXElY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:24 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4210 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfLXElY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:24 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: A7gzaEgfzI+wbf1hQ09NnHnac/BwnX2w6n8xLxVMM61yE9w3m9ee3iILSPlMjyGDmDpMadnL7E
 3n/pIuV6pM56m4GCWK2aDcVQRZDTyZUjmuvwsrLwjFRUF8J/TipUzn/Wq3dSMe5AQ1NL5/eBAt
 deMSZq7P2a9+WNR42Mma63qVEt6xZ1PsOC/yzbzg1janOrvxu+6rDC+lS/UKJMGuREKY4/A2hD
 ZXoSfGqxUJ63JykqmvNFuqWIk80W6TDGI4It9o/4k96PqvvTEa8RVxBPRO5nsI+t2NZkLdFyuI
 IjA=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="61418513"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:41:13 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:41:12 -0800
Received: from localhost (10.41.130.49) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:41:12 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 08/12] pm80xx : IOCTL functionality for GPIO.
Date:   Tue, 24 Dec 2019 10:11:39 +0530
Message-ID: <20191224044143.8178-9-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191224044143.8178-1-deepak.ukey@microchip.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

Added IOCTL functionality for GPIO.
The SPCv controller provides 24 GPIO signals. The first 12 signals
[11:0] and the last 4 signals [23:20] are for customer use. Eight
signals [19:12] are reserved for the SPCv controller firmware.
Whenever the host performs GPIO setup or a read/write operation
using the GPIO command the host needs to make sure that it does
not disturb the GPIO configuration for the bits [19:12].
Each signal can be configured either as an input or as an output.
When configured as an output, the host can use the GPIO Command to
set the desired level. GPIO inputs can also be configured so that
the SPCv controller sends the GPIO Event notification when specific
GPIO events occur.
Different GPIO features implemented:
1) GPIO Pin Setup
2) GPIO Event Setup
3) GPIO Read
4) GPIO Write

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Yu Zheng <yuuzheng@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |  95 ++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  24 +++++++++
 drivers/scsi/pm8001/pm8001_init.c |   6 +++
 drivers/scsi/pm8001/pm8001_sas.h  |  17 ++++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 106 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  |  49 ++++++++++++++++++
 6 files changed, 297 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 6daae852d5ac..8292074c1e6f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -39,6 +39,7 @@
  */
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/poll.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
 #include "pm80xx_hwi.h"
@@ -941,6 +942,73 @@ static long pm8001_info_ioctl(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
+static long pm8001_gpio_ioctl(struct pm8001_hba_info *pm8001_ha,
+		unsigned long arg)
+{
+	struct gpio_buffer buffer;
+	struct pm8001_gpio *payload;
+	struct gpio_ioctl_resp *gpio_resp;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	unsigned long timeout;
+	u32 ret = 0, operation;
+
+	if (pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2)
+		return ADPT_IOCTL_CALL_INVALID_DEVICE;
+
+	if (copy_from_user(&buffer, (struct gpio_buffer *)arg,
+		sizeof(struct gpio_buffer))) {
+		ret = ADPT_IOCTL_CALL_FAILED;
+	}
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+	pm8001_ha->ioctl_completion = &completion;
+	payload = &buffer.gpio_payload;
+	operation = payload->operation;
+	ret = PM8001_CHIP_DISP->gpio_req(pm8001_ha, payload);
+	if (ret != 0) {
+		ret = ADPT_IOCTL_CALL_FAILED;
+		goto exit;
+	}
+
+	timeout = (unsigned long)buffer.header.timeout * 1000;
+	if (timeout < 2000)
+		timeout = 2000;
+
+	timeout = wait_for_completion_timeout(&completion,
+			msecs_to_jiffies(timeout));
+	if (timeout == 0) {
+		ret = ADPT_IOCTL_CALL_TIMEOUT;
+		goto exit;
+	}
+	gpio_resp = &pm8001_ha->gpio_resp;
+	buffer.header.return_code = ADPT_IOCTL_CALL_SUCCESS;
+
+	if (operation == GPIO_READ) {
+		payload->rd_wr_val		= gpio_resp->gpio_rd_val;
+		payload->input_enable		= gpio_resp->gpio_in_enabled;
+		payload->pinsetup1		= gpio_resp->gpio_pinsetup1;
+		payload->pinsetup2		= gpio_resp->gpio_pinsetup2;
+		payload->event_level		= gpio_resp->gpio_evt_change;
+		payload->event_rising_edge	= gpio_resp->gpio_evt_rise;
+		payload->event_falling_edge	= gpio_resp->gpio_evt_fall;
+
+		if (copy_to_user((void *)arg, (void *)&buffer,
+					sizeof(struct gpio_buffer))) {
+			ret = ADPT_IOCTL_CALL_FAILED;
+		}
+	} else {
+		if (copy_to_user((void *)arg, (void *)&buffer.header,
+					sizeof(struct ioctl_header))) {
+			ret = ADPT_IOCTL_CALL_FAILED;
+		}
+	}
+exit:
+	spin_lock_irq(&pm8001_ha->ioctl_lock);
+	pm8001_ha->ioctl_completion = NULL;
+	spin_unlock_irq(&pm8001_ha->ioctl_lock);
+	mutex_unlock(&pm8001_ha->ioctl_mutex);
+	return ret;
+}
+
 static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
 		unsigned long arg)
 {
@@ -1101,6 +1169,9 @@ static long pm8001_ioctl(struct file *file,
 	case ADPT_IOCTL_INFO:
 		ret = pm8001_info_ioctl(pm8001_ha, arg);
 		break;
+	case ADPT_IOCTL_GPIO:
+		ret = pm8001_gpio_ioctl(pm8001_ha, arg);
+		break;
 	case ADPT_IOCTL_GET_PHY_PROFILE:
 		ret = pm8001_ioctl_get_phy_profile(pm8001_ha, arg);
 		return ret;
@@ -1123,11 +1194,35 @@ static long pm8001_ioctl(struct file *file,
 	return ret;
 }
 
+/**
+ *pm8001_poll - pm8001 poll request function
+ *@file: file handle
+ *@wait: poll table to wait
+ *Handles a poll request.
+ */
+__poll_t pm8001_poll(struct file *file, poll_table *wait)
+{
+	struct pm8001_hba_info *pm8001_ha;
+	__poll_t mask = 0;
+
+	pm8001_ha = file->private_data;
+
+	poll_wait(file, &pm8001_ha->pollq,  wait);
+
+	if (pm8001_ha->gpio_event_occurred == 1) {
+		pm8001_ha->gpio_event_occurred = 0;
+		mask |= POLLIN | POLLRDNORM;
+	}
+
+	return mask;
+}
+
 static const struct file_operations pm8001_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pm8001_open,
 	.release	= pm8001_close,
 	.unlocked_ioctl	= pm8001_ioctl,
+	.poll		= pm8001_poll,
 };
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index 686ad69f0e0c..5be43b2672d4 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -64,6 +64,7 @@
 #define ADPT_IOCTL_CALL_FAILED		0x01
 #define ADPT_IOCTL_CALL_INVALID_CODE	0x03
 #define ADPT_IOCTL_CALL_INVALID_DEVICE	0x04
+#define ADPT_IOCTL_CALL_TIMEOUT		0x08
 
 #define MAX_NUM_PHYS			16
 
@@ -86,11 +87,33 @@ struct ioctl_drv_info {
 	u32	reserved[16];
 };
 
+#define	GPIO_READ	0
+#define	GPIO_WRITE	1
+#define	GPIO_PINSETUP	2
+#define	GPIO_EVENTSETUP	3
+
+struct pm8001_gpio {
+	u32	operation;
+	u32	mask;
+	u32	rd_wr_val;
+	u32	input_enable;
+	u32	pinsetup1;
+	u32	pinsetup2;
+	u32	event_level;
+	u32	event_rising_edge;
+	u32	event_falling_edge;
+};
+
 struct ioctl_info_buffer {
 	struct ioctl_header	header;
 	struct ioctl_drv_info	information;
 };
 
+struct gpio_buffer {
+	struct ioctl_header	header;
+	struct pm8001_gpio	gpio_payload;
+};
+
 struct phy_profile {
 	char		phy_id;
 	unsigned int	phys:4;
@@ -119,6 +142,7 @@ struct phy_prof_resp {
 };
 
 #define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
+#define ADPT_IOCTL_GPIO	_IOWR(ADPT_MAGIC_NUMBER, 1, struct  gpio_buffer *)
 #define ADPT_IOCTL_GET_PHY_PROFILE _IOWR(ADPT_MAGIC_NUMBER, 8, \
 		struct phy_profile*)
 #define ADPT_IOCTL_GET_PHY_ERR_CNT _IOWR(ADPT_MAGIC_NUMBER, 9, \
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 25e74f1dbd0c..6e2512aa5f6e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -498,6 +498,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	else
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
+	mutex_init(&pm8001_ha->ioctl_mutex);
+	pm8001_ha->ioctl_completion = NULL;
+	init_waitqueue_head(&pm8001_ha->pollq);
+	pm8001_ha->gpio_event_occurred = 0;
+	spin_lock_init(&pm8001_ha->ioctl_lock);
+
 #ifdef PM8001_USE_TASKLET
 	/* Tasklet for non msi-x interrupt handler */
 	if ((!pdev->msix_cap || !pci_msi_enabled())
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 99920d53ac09..8e442214c954 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -132,6 +132,18 @@ extern const struct pm8001_dispatch pm8001_80xx_dispatch;
 struct pm8001_hba_info;
 struct pm8001_ccb_info;
 struct pm8001_device;
+
+struct gpio_ioctl_resp {
+	u32	tag;
+	u32	gpio_rd_val;
+	u32	gpio_in_enabled;
+	u32	gpio_pinsetup1;
+	u32	gpio_pinsetup2;
+	u32	gpio_evt_change;
+	u32	gpio_evt_rise;
+	u32	gpio_evt_fall;
+};
+
 /* define task management IU */
 struct pm8001_tmf_task {
 	u8	tmf;
@@ -247,6 +259,8 @@ struct pm8001_dispatch {
 	int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
 		u32 state);
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
+	int (*gpio_req)(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_gpio *gpio_payload);
 	int (*get_phy_profile_req)(struct pm8001_hba_info *pm8001_ha,
 		int phy, int page);
 };
@@ -562,6 +576,9 @@ struct pm8001_hba_info {
 	u32			smp_exp_mode;
 	bool			controller_fatal_error;
 	const struct firmware 	*fw_image;
+	struct			gpio_ioctl_resp  gpio_resp;
+	u32			gpio_event_occurred;
+	wait_queue_head_t	pollq;
 	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
 	spinlock_t		ioctl_lock;
 	struct mutex		ioctl_mutex;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7f2b7b1d4110..10a922e5a478 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3845,6 +3845,50 @@ static int ssp_coalesced_comp_resp(struct pm8001_hba_info *pm8001_ha,
 	return 0;
 }
 
+static int mpi_gpio_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+{
+	u32 tag;
+	struct gpio_ioctl_resp *pgpio_resp;
+	struct gpio_resp *ppayload = (struct gpio_resp *)(piomb + 4);
+
+	tag = le32_to_cpu(ppayload->tag);
+	spin_lock(&pm8001_ha->ioctl_lock);
+	if (pm8001_ha->ioctl_completion != NULL) {
+		pgpio_resp = &pm8001_ha->gpio_resp;
+		pgpio_resp->gpio_rd_val = le32_to_cpu(ppayload->gpio_rd_val);
+		pgpio_resp->gpio_in_enabled =
+			le32_to_cpu(ppayload->gpio_in_enabled);
+		pgpio_resp->gpio_pinsetup1 =
+			le32_to_cpu(ppayload->gpio_pinsetup1);
+		pgpio_resp->gpio_pinsetup2 =
+			le32_to_cpu(ppayload->gpio_pinsetup2);
+		pgpio_resp->gpio_evt_change =
+			le32_to_cpu(ppayload->gpio_evt_change);
+		pgpio_resp->gpio_evt_rise =
+			le32_to_cpu(ppayload->gpio_evt_rise);
+		pgpio_resp->gpio_evt_fall =
+			le32_to_cpu(ppayload->gpio_evt_fall);
+
+		complete(pm8001_ha->ioctl_completion);
+	}
+	spin_unlock(&pm8001_ha->ioctl_lock);
+	pm8001_tag_free(pm8001_ha, tag);
+	return 0;
+}
+
+static int mpi_gpio_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
+{
+	u32 gpio_event = 0;
+	struct gpio_event *ppayload = (struct gpio_event *)(piomb + 4);
+
+	gpio_event = le32_to_cpu(ppayload->gpio_event);
+	PM8001_MSG_DBG(pm8001_ha,
+			pm8001_printk("GPIO event: 0x%X\n", gpio_event));
+	pm8001_ha->gpio_event_occurred = 1;
+	wake_up_interruptible(&pm8001_ha->pollq);
+	return 0;
+}
+
 /**
  * process_one_iomb - process one outbound Queue memory block
  * @pm8001_ha: our hba card information
@@ -3931,10 +3975,12 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case OPC_OUB_GPIO_RESPONSE:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_GPIO_RESPONSE\n"));
+		mpi_gpio_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GPIO_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_GPIO_EVENT\n"));
+		mpi_gpio_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GENERAL_EVENT:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -5038,6 +5084,65 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("PHY %d settings applied", phy));
 }
+
+/**
+ * pm80xx_chip_gpio_req - support for GPIO operation
+ * @pm8001_ha: our hba card information.
+ * @ioctl_payload: the payload for the GPIO operation
+ */
+int pm80xx_chip_gpio_req(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_gpio *gpio_payload)
+{
+	struct gpio_req payload;
+	struct inbound_queue_table *circularQ;
+	int ret;
+	u32 tag;
+	u32 opc = OPC_INB_GPIO;
+
+	if (pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2)
+		return -1;
+
+	ret = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (ret)
+		return -1;
+
+	memset(&payload, 0, sizeof(payload));
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+	payload.tag = cpu_to_le32(tag);
+
+	switch (gpio_payload->operation) {
+	case GPIO_READ:
+		payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GR_BIT);
+		break;
+	case GPIO_WRITE:
+		payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GW_BIT);
+		payload.gpio_wr_msk = cpu_to_le32(gpio_payload->mask);
+		payload.gpio_wr_val = cpu_to_le32(gpio_payload->rd_wr_val);
+		break;
+	case GPIO_PINSETUP:
+		payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GS_BIT);
+		payload.gpio_in_enabled =
+			cpu_to_le32(gpio_payload->input_enable);
+		payload.gpio_pinsetup1 = cpu_to_le32(gpio_payload->pinsetup1);
+		payload.gpio_pinsetup2 = cpu_to_le32(gpio_payload->pinsetup2);
+		break;
+	case GPIO_EVENTSETUP:
+		payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GE_BIT);
+		payload.gpio_evt_change =
+			cpu_to_le32(gpio_payload->event_level);
+		payload.gpio_evt_rise =
+			cpu_to_le32(gpio_payload->event_rising_edge);
+		payload.gpio_evt_fall =
+			cpu_to_le32(gpio_payload->event_falling_edge);
+		break;
+	}
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
+	if (ret != 0)
+		pm8001_tag_free(pm8001_ha, tag);
+	return ret;
+}
+
 const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.name			= "pmc80xx",
 	.chip_init		= pm80xx_chip_init,
@@ -5064,5 +5169,6 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.set_nvmd_req		= pm8001_chip_set_nvmd_req,
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
+	.gpio_req		= pm80xx_chip_gpio_req,
 	.get_phy_profile_req	= pm8001_chip_get_phy_profile,
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index b5119c5479da..fed193df93d6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -529,6 +529,55 @@ struct hw_event_ack_req {
 	u32	reserved1[27];
 } __attribute__((packed, aligned(4)));
 
+/*
+ * brief the data structure of GPIO Commannd
+ * use to control MPI GPIOs (64 bytes)
+ */
+struct gpio_req {
+	__le32	tag;
+	__le32	eobid_ge_gs_gr_gw;
+	__le32	gpio_wr_msk;
+	__le32	gpio_wr_val;
+	__le32	gpio_in_enabled;
+	__le32	gpio_pinsetup1;
+	__le32	gpio_pinsetup2;
+	__le32	gpio_evt_change;
+	__le32	gpio_evt_rise;
+	__le32	gpio_evt_fall;
+	u32	reserved[5];
+} __packed __aligned(4);
+
+#define GPIO_GW_BIT 0x1
+#define GPIO_GR_BIT 0x2
+#define GPIO_GS_BIT 0x4
+#define GPIO_GE_BIT 0x8
+
+/*
+ * brief the data structure of GPIO Response
+ * indicates the completion of GPIO command (64 bytes)
+ */
+struct gpio_resp {
+	__le32	tag;
+	u32	reserved[2];
+	__le32	gpio_rd_val;
+	__le32	gpio_in_enabled;
+	__le32	gpio_pinsetup1;
+	__le32	gpio_pinsetup2;
+	__le32	gpio_evt_change;
+	__le32	gpio_evt_rise;
+	__le32	gpio_evt_fall;
+	u32	reserved1[5];
+} __packed __aligned(4);
+
+/*
+ * brief the data structure of GPIO Event
+ * indicates the generation of GPIO event (64 bytes)
+ */
+struct gpio_event {
+	__le32	gpio_event;
+	u32	reserved[14];
+} __packed __aligned(4);
+
 /*
  * brief the data structure of PHY_START Response Command
  * indicates the completion of PHY_START command (64 bytes)
-- 
2.16.3

