From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 1/3] eeprom-93cx6: Add (read-only) support for 8-bit mode
Date: Mon, 24 Nov 2014 13:11:12 +0100
Message-ID: <1416831074-24282-2-git-send-email-linux@rainbow-software.org>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add read-only support for EEPROMs configured in 8-bit mode (ORG pin connected
to GND).
This will be used by wd719x driver.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/misc/eeprom/eeprom_93cx6.c |   62 +++++++++++++++++++++++++++++++++++-
 include/linux/eeprom_93cx6.h       |    4 +++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/eeprom_93cx6.c b/drivers/misc/eeprom/eeprom_93cx6.c
index 0ff4b02..0cf2c9d 100644
--- a/drivers/misc/eeprom/eeprom_93cx6.c
+++ b/drivers/misc/eeprom/eeprom_93cx6.c
@@ -170,7 +170,7 @@ static void eeprom_93cx6_read_bits(struct eeprom_93cx6 *eeprom,
 }
 
 /**
- * eeprom_93cx6_read - Read multiple words from eeprom
+ * eeprom_93cx6_read - Read a word from eeprom
  * @eeprom: Pointer to eeprom structure
  * @word: Word index from where we should start reading
  * @data: target pointer where the information will have to be stored
@@ -235,6 +235,66 @@ void eeprom_93cx6_multiread(struct eeprom_93cx6 *eeprom, const u8 word,
 EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
 
 /**
+ * eeprom_93cx6_readb - Read a byte from eeprom
+ * @eeprom: Pointer to eeprom structure
+ * @word: Byte index from where we should start reading
+ * @data: target pointer where the information will have to be stored
+ *
+ * This function will read a byte of the eeprom data
+ * into the given data pointer.
+ */
+void eeprom_93cx6_readb(struct eeprom_93cx6 *eeprom, const u8 byte,
+	u8 *data)
+{
+	u16 command;
+	u16 tmp;
+
+	/*
+	 * Initialize the eeprom register
+	 */
+	eeprom_93cx6_startup(eeprom);
+
+	/*
+	 * Select the read opcode and the byte to be read.
+	 */
+	command = (PCI_EEPROM_READ_OPCODE << (eeprom->width + 1)) | byte;
+	eeprom_93cx6_write_bits(eeprom, command,
+		PCI_EEPROM_WIDTH_OPCODE + eeprom->width + 1);
+
+	/*
+	 * Read the requested 8 bits.
+	 */
+	eeprom_93cx6_read_bits(eeprom, &tmp, 8);
+	*data = tmp & 0xff;
+
+	/*
+	 * Cleanup eeprom register.
+	 */
+	eeprom_93cx6_cleanup(eeprom);
+}
+EXPORT_SYMBOL_GPL(eeprom_93cx6_readb);
+
+/**
+ * eeprom_93cx6_multireadb - Read multiple bytes from eeprom
+ * @eeprom: Pointer to eeprom structure
+ * @byte: Index from where we should start reading
+ * @data: target pointer where the information will have to be stored
+ * @words: Number of bytes that should be read.
+ *
+ * This function will read all requested bytes from the eeprom,
+ * this is done by calling eeprom_93cx6_readb() multiple times.
+ */
+void eeprom_93cx6_multireadb(struct eeprom_93cx6 *eeprom, const u8 byte,
+	u8 *data, const u16 bytes)
+{
+	unsigned int i;
+
+	for (i = 0; i < bytes; i++)
+		eeprom_93cx6_readb(eeprom, byte + i, &data[i]);
+}
+EXPORT_SYMBOL_GPL(eeprom_93cx6_multireadb);
+
+/**
  * eeprom_93cx6_wren - set the write enable state
  * @eeprom: Pointer to eeprom structure
  * @enable: true to enable writes, otherwise disable writes
diff --git a/include/linux/eeprom_93cx6.h b/include/linux/eeprom_93cx6.h
index e50f98b..eb0b198 100644
--- a/include/linux/eeprom_93cx6.h
+++ b/include/linux/eeprom_93cx6.h
@@ -75,6 +75,10 @@ extern void eeprom_93cx6_read(struct eeprom_93cx6 *eeprom,
 	const u8 word, u16 *data);
 extern void eeprom_93cx6_multiread(struct eeprom_93cx6 *eeprom,
 	const u8 word, __le16 *data, const u16 words);
+extern void eeprom_93cx6_readb(struct eeprom_93cx6 *eeprom,
+	const u8 byte, u8 *data);
+extern void eeprom_93cx6_multireadb(struct eeprom_93cx6 *eeprom,
+	const u8 byte, u8 *data, const u16 bytes);
 
 extern void eeprom_93cx6_wren(struct eeprom_93cx6 *eeprom, bool enable);
 
-- 
Ondrej Zary
