From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] qla1820 iomem annotations
Date: Thu, 21 Oct 2004 00:58:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235837.GC23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45737 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270454AbUJTX6k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:58:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-aacraid/drivers/scsi/qla1280.c RC9-bk4-qla1820/drivers/scsi/qla1280.c
--- RC9-bk4-aacraid/drivers/scsi/qla1280.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-qla1820/drivers/scsi/qla1280.c	Wed Oct 20 13:46:21 2004
@@ -540,7 +540,7 @@
 				struct list_head *);
 static uint16_t qla1280_get_nvram_word(struct scsi_qla_host *, uint32_t);
 static uint16_t qla1280_nvram_request(struct scsi_qla_host *, uint32_t);
-static uint16_t qla1280_debounce_register(volatile uint16_t *);
+static uint16_t qla1280_debounce_register(volatile uint16_t __iomem *);
 static request_t *qla1280_req_pkt(struct scsi_qla_host *);
 static int qla1280_check_for_dead_scsi_bus(struct scsi_qla_host *,
 					   unsigned int);
@@ -949,7 +949,7 @@
 static void qla1280_mailbox_timeout(unsigned long __data)
 {
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)__data;
-	struct device_reg *reg;
+	struct device_reg __iomem *reg;
 	reg = ha->iobase;
 
 	ha->mailbox_out[0] = RD_REG_WORD(&reg->mailbox0);
@@ -1360,7 +1360,7 @@
 qla1280_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct scsi_qla_host *ha;
-	struct device_reg *reg;
+	struct device_reg __iomem *reg;
 	u16 data;
 	int handled = 0;
 
@@ -1716,7 +1716,7 @@
 static inline void
 qla1280_enable_intrs(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg;
+	struct device_reg __iomem *reg;
 
 	reg = ha->iobase;
 	/* enable risc and host interrupts */
@@ -1728,7 +1728,7 @@
 static inline void
 qla1280_disable_intrs(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg;
+	struct device_reg __iomem *reg;
 
 	reg = ha->iobase;
 	/* disable risc and host interrupts */
@@ -1750,7 +1750,7 @@
 static int __devinit
 qla1280_initialize_adapter(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg;
+	struct device_reg __iomem *reg;
 	int status;
 	int bus;
 #if LINUX_VERSION_CODE > 0x020500
@@ -1921,7 +1921,7 @@
 qla1280_chip_diag(struct scsi_qla_host *ha)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	int status = 0;
 	int cnt;
 	uint16_t data;
@@ -2513,7 +2513,7 @@
 static int
 qla1280_nvram_config(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	struct nvram *nv = &ha->nvram;
 	int bus, target, status = 0;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
@@ -2699,7 +2699,7 @@
 static uint16_t
 qla1280_nvram_request(struct scsi_qla_host *ha, uint32_t nv_cmd)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	int cnt;
 	uint16_t data = 0;
 	uint16_t reg_data;
@@ -2742,7 +2742,7 @@
 static void
 qla1280_nv_write(struct scsi_qla_host *ha, uint16_t data)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 
 	WRT_REG_WORD(&reg->nvram, data | NV_SELECT);
 	RD_REG_WORD(&reg->id_l);	/* Flush PCI write */
@@ -2773,13 +2773,14 @@
 static int
 qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 #if 0
 	LIST_HEAD(done_q);
 #endif
 	int status = 0;
 	int cnt;
 	uint16_t *optr, *iptr;
+	uint16_t __iomem *mptr;
 	uint16_t data;
 	DECLARE_COMPLETION(wait);
 	struct timer_list timer;
@@ -2796,15 +2797,15 @@
 	 * available before starting sending the command data
 	 */
 	/* Load mailbox registers. */
-	optr = (uint16_t *) &reg->mailbox0;
+	mptr = (uint16_t __iomem *) &reg->mailbox0;
 	iptr = mb;
 	for (cnt = 0; cnt < MAILBOX_REGISTER_COUNT; cnt++) {
 		if (mr & BIT_0) {
-			WRT_REG_WORD(optr, (*iptr));
+			WRT_REG_WORD(mptr, (*iptr));
 		}
 
 		mr >>= 1;
-		optr++;
+		mptr++;
 		iptr++;
 	}
 
@@ -2880,7 +2881,7 @@
 static void
 qla1280_poll(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	uint16_t data;
 	LIST_HEAD(done_q);
 
@@ -3083,7 +3084,7 @@
 static void
 qla1280_reset_adapter(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 
 	ENTER("qla1280_reset_adapter");
 
@@ -3147,7 +3148,7 @@
 static int
 qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
 	struct scatterlist *sg = NULL;
@@ -3433,7 +3434,7 @@
 static int
 qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
 	struct scatterlist *sg = NULL;
@@ -3693,7 +3694,7 @@
 static request_t *
 qla1280_req_pkt(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	request_t *pkt = NULL;
 	int cnt;
 	uint32_t timer;
@@ -3761,7 +3762,7 @@
 static void
 qla1280_isp_cmd(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 
 	ENTER("qla1280_isp_cmd");
 
@@ -3799,7 +3800,7 @@
 static void
 qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	struct response *pkt;
 	struct srb *sp = NULL;
 	uint16_t mailbox[MAILBOX_REGISTER_COUNT];
@@ -4258,7 +4259,7 @@
 static int
 qla1280_abort_isp(struct scsi_qla_host *ha)
 {
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 	struct srb *sp;
 	int status = 0;
 	int cnt;
@@ -4336,7 +4337,7 @@
  *      register value.
  */
 static u16
-qla1280_debounce_register(volatile u16 * addr)
+qla1280_debounce_register(volatile u16 __iomem * addr)
 {
 	volatile u16 ret;
 	volatile u16 ret2;
@@ -4368,7 +4369,7 @@
 qla1280_check_for_dead_scsi_bus(struct scsi_qla_host *ha, unsigned int bus)
 {
 	uint16_t config_reg, scsi_control;
-	struct device_reg *reg = ha->iobase;
+	struct device_reg __iomem *reg = ha->iobase;
 
 	if (ha->bus_settings[bus].scsi_bus_dead) {
 		WRT_REG_WORD(&reg->host_cmd, HC_PAUSE_RISC);
@@ -4787,7 +4788,7 @@
 	}
 
 	host->base = (unsigned long)ha->mmpbase;
-	ha->iobase = (struct device_reg *)ha->mmpbase;
+	ha->iobase = (struct device_reg __iomem *)ha->mmpbase;
 #else
 	host->io_port = pci_resource_start(ha->pdev, 0);
 	if (!request_region(host->io_port, 0xff, "qla1280")) {
diff -urN RC9-bk4-aacraid/drivers/scsi/qla1280.h RC9-bk4-qla1820/drivers/scsi/qla1280.h
--- RC9-bk4-aacraid/drivers/scsi/qla1280.h	Mon Oct 18 22:04:50 2004
+++ RC9-bk4-qla1820/drivers/scsi/qla1280.h	Wed Oct 20 13:46:24 2004
@@ -1038,9 +1038,9 @@
 	/* Linux adapter configuration data */
 	struct Scsi_Host *host;	/* pointer to host data */
 	struct scsi_qla_host *next;
-	struct device_reg *iobase;	/* Base Memory-mapped I/O address */
+	struct device_reg __iomem *iobase;	/* Base Memory-mapped I/O address */
 
-	unsigned char *mmpbase;	/* memory mapped address */
+	unsigned char __iomem *mmpbase;	/* memory mapped address */
 	unsigned long host_no;
 	struct pci_dev *pdev;
 	uint8_t devnum;
