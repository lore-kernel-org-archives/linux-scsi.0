From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla_sup.c: compilation warning
Date: Thu, 24 Jan 2008 09:40:53 -0800
Message-ID: <20080124174053.GF10566@plap3.qlogic.org>
References: <4798C035.5010000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25483 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYAXRkz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 12:40:55 -0500
Content-Disposition: inline
In-Reply-To: <4798C035.5010000@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 24 Jan 2008, Boaz Harrosh wrote:

> With gcc 4.1.2 on fedora7 x86_64, cross compiling an i386 kernel i ge=
t
> the following compilation warning:
>=20
> CC [M] drivers/scsi/qla2xxx/qla_sup.o
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c: In function =E2=80=98qla2x00_beacon_blink=E2=80=99:
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c:906: warning: cast to pointer from integer of different size
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c: In function =E2=80=98qla2x00_beacon_on=E2=80=99:
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c:966: warning: cast to pointer from integer of different size
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c: In function =E2=80=98qla2x00_read_flash_byte=E2=80=99:
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c:1247: warning: cast to pointer from integer of different size
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c: In function =E2=80=98qla2x00_write_flash_byte=E2=80=99:
> /usr0/export/dev/bharrosh/git/pub/scsi-misc/drivers/scsi/qla2xxx/qla_=
sup.c:1307: warning: cast to pointer from integer of different size
>=20
> Perhaps the compiler is right this time ?
> configured with: "make ARCH=3Di386 allmodconfig"

Hmm, it looks like the conversion to resource_size_t usage
(3776541d8a46347a4924353a192c6ce4a3d04e2e) requires some additional
fixups to cleanup the structure-pointer castings used during IO mapped
accesses to the chip.

There's only a small number of locations, where the driver uses IO
mapped accesses to the hardware, the patch below should take care of
it without introducing to many structural changes to code flow.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_=
sup.c
index b68fb73..26822c8 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -893,6 +893,8 @@ qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *=
pflags)
 	}
 }
=20
+#define PIO_REG(h, r) ((h)->pio_address + offsetof(struct device_reg_2=
xxx, r))
+
 void
 qla2x00_beacon_blink(struct scsi_qla_host *ha)
 {
@@ -902,15 +904,12 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg =3D &ha->iobase->isp;
=20
-	if (ha->pio_address)
-		reg =3D (struct device_reg_2xxx __iomem *)ha->pio_address;
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
=20
 	/* Save the Original GPIOE. */
 	if (ha->pio_address) {
-		gpio_enable =3D RD_REG_WORD_PIO(&reg->gpioe);
-		gpio_data =3D RD_REG_WORD_PIO(&reg->gpiod);
+		gpio_enable =3D RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
+		gpio_data =3D RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
 	} else {
 		gpio_enable =3D RD_REG_WORD(&reg->gpioe);
 		gpio_data =3D RD_REG_WORD(&reg->gpiod);
@@ -920,7 +919,7 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 	gpio_enable |=3D GPIO_LED_MASK;
=20
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpioe, gpio_enable);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
 		WRT_REG_WORD(&reg->gpioe, gpio_enable);
 		RD_REG_WORD(&reg->gpioe);
@@ -936,7 +935,7 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
=20
 	/* Set the modified gpio_data values */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpiod, gpio_data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
 		WRT_REG_WORD(&reg->gpiod, gpio_data);
 		RD_REG_WORD(&reg->gpiod);
@@ -962,14 +961,11 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 		return QLA_FUNCTION_FAILED;
 	}
=20
-	if (ha->pio_address)
-		reg =3D (struct device_reg_2xxx __iomem *)ha->pio_address;
-
 	/* Turn off LEDs. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (ha->pio_address) {
-		gpio_enable =3D RD_REG_WORD_PIO(&reg->gpioe);
-		gpio_data =3D RD_REG_WORD_PIO(&reg->gpiod);
+		gpio_enable =3D RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
+		gpio_data =3D RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
 	} else {
 		gpio_enable =3D RD_REG_WORD(&reg->gpioe);
 		gpio_data =3D RD_REG_WORD(&reg->gpiod);
@@ -978,7 +974,7 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
=20
 	/* Set the modified gpio_enable values. */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpioe, gpio_enable);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
 		WRT_REG_WORD(&reg->gpioe, gpio_enable);
 		RD_REG_WORD(&reg->gpioe);
@@ -987,7 +983,7 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 	/* Clear out previously set LED colour. */
 	gpio_data &=3D ~GPIO_LED_MASK;
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpiod, gpio_data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
 		WRT_REG_WORD(&reg->gpiod, gpio_data);
 		RD_REG_WORD(&reg->gpiod);
@@ -1244,13 +1240,12 @@ qla2x00_read_flash_byte(scsi_qla_host_t *ha, ui=
nt32_t addr)
 	if (ha->pio_address) {
 		uint16_t data2;
=20
-		reg =3D (struct device_reg_2xxx __iomem *)ha->pio_address;
-		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
 		do {
-			data =3D RD_REG_WORD_PIO(&reg->flash_data);
+			data =3D RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
 			barrier();
 			cpu_relax();
-			data2 =3D RD_REG_WORD_PIO(&reg->flash_data);
+			data2 =3D RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
 		} while (data !=3D data2);
 	} else {
 		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
@@ -1304,9 +1299,8 @@ qla2x00_write_flash_byte(scsi_qla_host_t *ha, uin=
t32_t addr, uint8_t data)
=20
 	/* Always perform IO mapped accesses to the FLASH registers. */
 	if (ha->pio_address) {
-		reg =3D (struct device_reg_2xxx __iomem *)ha->pio_address;
-		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
-		WRT_REG_WORD_PIO(&reg->flash_data, (uint16_t)data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_data), (uint16_t)data);
 	} else {
 		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
 		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
