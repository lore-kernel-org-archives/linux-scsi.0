Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF7A47B41C
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522070; cv=none; b=t57ca4zSzExKgQFU+ejDzs6xwkU7p+ns2PA8gzQdognzSaDAodGLvkpTfWh62sY5X4lOFKx33Wq7HAAzCsuhM//3MgrkJ3/a7rhxumTNezapAH0h2ln430zuTNx+N6DyAThXfGskuu5grdmUWQjBeKcWXKgqzf17Vs9nO0ON32M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522070; c=relaxed/simple;
	bh=HlERhSB75i8bX4QVmrQpc5gZGoxkBqzXyApECTG138s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAatniYLoGGnvACVnEKg006zTwbkxSBG05kgSEudApGjiIk3OA4zESVcfmOYaGClumvJrJ15GgvpuR262QbHWVkKip8ySEWk9xu68kiud8VxPqGXAfyKx2No/p2iDVThQD9C7LLSebPPc8dIj0SpM5vzlvjOhxxO9JJA42YLoiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6KKry1p; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6KKry1p"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b1b9c3af5cso722072eaf.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 04:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522066; x=1789126866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2E5WMWcIyJZoE2GE8k1ComnlqCfp2hy8iFWq+cBj4jU=;
        b=p6KKry1p4t3uE+1n0M1JF3KPoQk9E5W+ShbzYUaUdix6FQaChy9tOfieJKB/gP9Be2
         q9p7GF3b58XuiFUn407yw4i1igOWyZbC7ipQnyIN/5jQ3ppSMBtYHzaT2Wg3vyIWyl10
         8vcYsqh8A7kfCV988wtIGNmqK2lUJt+Fim8rnw2nWAdoMvtMmq+tFG95+rgy6ryyBgXX
         xL0iEuu/m8xfx7aHbnbW0pIOj23+tbZ/KAa5Cw7jDtC9c4z7E61WBo6svstgcUsfqME/
         yJQl33wUblKu5azBEXzYrv85RNREFBOzt3LLJViOLhjficzk9mPkKj/DNgfaow7RO0Zs
         176A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522066; x=1789126866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2E5WMWcIyJZoE2GE8k1ComnlqCfp2hy8iFWq+cBj4jU=;
        b=b/+Q46f8r7+tOv49fqA8YF5h12dn/wrZmSBVvcuWNYO2HG8uIhNQosJJJo4TOb7+NA
         cWoq7bJy12fjqCpxn3dSAfQS7lXOz6n+DdehaDd1pln9rPp6pFq1kgF53mtwU2PAruOf
         FNsUwDAWyLJdfY4/wavIcejuiqsigW+7K9WfJ4eY0Z0g3RqpVUO3Quw7FAo9NQ2bz0ZY
         o7nX3srogHbGmfqCZxkOu46K/xl73gvIQumt9F1DuvMpN/f0AWf6I73tGhULdgUWqSXZ
         ygLzAr1l8rpARytwcJvqPrLOcyOS8q7QvaeDpwcbThws4x598f975kPLfnlnpr1FeKjz
         MM5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwhGT04GTkFPaX0XPUv3IzL+MZXrrszyqTI29vn6e74Qhqn+qMt2OB9T0KKVi/tLYU43dAcoD0Zw9jU@vger.kernel.org
X-Gm-Message-State: AFuF++mHBNN9plAVMTca4rslFKS7wYjsLQD2RkZNWEHFr4paF7zZ/Rt8
	UqzdHf1LRsvsZ8B9GFoXVoL4RXGPLDz6U545SfKAiTUsyecA709qnWji
X-Gm-Gg: AYBFou213oaGJHtmaZDzrqRDv205rh3b+O5qju4/xn214VUg+HRVLynVwOA1/vT+GxC
	zOItWhowx+0i4nHAsN8BLX8Akn/6a8L/kchuP3fYg2Pb9667Fk+RfXGGMMqEKuw72UvDfCrhakF
	9F39a0DOvXSSyG6043H+kWeIkDJQzPFMtkvPItRW4D2PHpiALgcEKoeEgdPN/V3VJ3BOG/DRhhg
	cn3mEVFCqF1p80BfYymq9GYhMyvUx57mlReBtq6Sfo/XaMMS5IwzZHYHOEiKYBEbPX1RtccuouH
	IU6bMFuMKGMS4iBeAapxTBXTEsV+Fk7QGuj5TZp69x097XsR8IK/DnZe5pnKZzH/xl0zWSDYKYS
	nCnoGns1itgyfrEnq31lFjdyOaHQTVyy3d9Y6xtuJ/azqHI+t+ZmiCCp4Fr1XvbQ6h/qM/aDDN0
	mxgphtyVCOPMnF0JiSYYXL+OJWStzOJZXMic1WZYUSNkqh5VDf9FmcdLh87d/kMX1lQpA3ljCek
	rf7ntD3coSEhekVunqAfzJk/N8=
X-Received: by 2002:a05:6820:4b08:b0:6b7:46fc:1db with SMTP id 006d021491bc7-6b746fc0298mr2235475eaf.58.1788522065747;
        Fri, 04 Sep 2026 04:41:05 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm2695292eec.4.2026.09.04.04.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:41:05 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Matthieu CASTET <castet.matthieu@free.fr>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Chas Williams <3chas3@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Walleij <linusw@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Al Cooper <alcooperx@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathias Nyman <mathias.nyman@intel.com>,
	Thomas Winischhofer <thomas@winischhofer.net>,
	Bin Liu <b-liu@ti.com>,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 1/2] usb: fix typos in comments
Date: Fri,  4 Sep 2026 17:10:37 +0530
Message-ID: <20260904114046.24048-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904114046.24048-1-hemanth.selam@gmail.com>
References: <20260904114046.24048-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/usb/atm/ueagle-atm.c           | 2 +-
 drivers/usb/c67x00/c67x00-ll-hpi.c     | 8 ++++----
 drivers/usb/c67x00/c67x00-sched.c      | 2 +-
 drivers/usb/class/cdc-wdm.c            | 2 +-
 drivers/usb/core/hub.c                 | 2 +-
 drivers/usb/fotg210/fotg210-hcd.h      | 2 +-
 drivers/usb/gadget/configfs.c          | 2 +-
 drivers/usb/gadget/function/f_hid.c    | 2 +-
 drivers/usb/gadget/function/f_uac2.c   | 4 ++--
 drivers/usb/gadget/legacy/inode.c      | 2 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c  | 2 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c    | 2 +-
 drivers/usb/gadget/udc/core.c          | 4 ++--
 drivers/usb/gadget/udc/fsl_qe_udc.h    | 2 +-
 drivers/usb/gadget/udc/fsl_udc_core.c  | 4 ++--
 drivers/usb/gadget/udc/lpc32xx_udc.c   | 2 +-
 drivers/usb/gadget/udc/pch_udc.c       | 4 ++--
 drivers/usb/gadget/udc/r8a66597-udc.c  | 2 +-
 drivers/usb/gadget/udc/snps_udc_plat.c | 2 +-
 drivers/usb/gadget/udc/udc-xilinx.c    | 4 ++--
 drivers/usb/host/fhci-q.c              | 2 +-
 drivers/usb/host/fhci-tds.c            | 2 +-
 drivers/usb/host/oxu210hp-hcd.c        | 2 +-
 drivers/usb/host/xhci.c                | 8 ++++----
 drivers/usb/image/mdc800.c             | 2 +-
 drivers/usb/misc/sisusbvga/sisusbvga.c | 4 ++--
 drivers/usb/musb/tusb6010.c            | 2 +-
 drivers/usb/musb/ux500.c               | 2 +-
 drivers/usb/phy/phy-fsl-usb.c          | 2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c | 2 +-
 drivers/usb/renesas_usbhs/mod_host.c   | 2 +-
 drivers/usb/storage/uas.c              | 2 +-
 drivers/usb/typec/tcpm/fusb302.c       | 2 +-
 drivers/usb/typec/tcpm/tcpm.c          | 2 +-
 include/linux/usb/cdc.h                | 2 +-
 35 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 61723e7ab351..d569ee93b493 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2189,7 +2189,7 @@ static void uea_stop(struct uea_softc *sc)
 	release_firmware(sc->dsp_firm);
 }
 
-/* syfs interface */
+/* sysfs interface */
 static struct uea_softc *dev_to_uea(struct device *dev)
 {
 	struct usb_interface *intf;
diff --git a/drivers/usb/c67x00/c67x00-ll-hpi.c b/drivers/usb/c67x00/c67x00-ll-hpi.c
index 7a214a3a6cc7..f2225174f7df 100644
--- a/drivers/usb/c67x00/c67x00-ll-hpi.c
+++ b/drivers/usb/c67x00/c67x00-ll-hpi.c
@@ -113,7 +113,7 @@ static void hpi_write_word(struct c67x00_device *dev, u16 reg, u16 value)
 }
 
 /*
- * Only data is little endian, addr has cpu endianess
+ * Only data is little endian, addr has cpu endianness
  */
 static void hpi_write_words_le16(struct c67x00_device *dev, u16 addr,
 				 __le16 *data, u16 count)
@@ -131,7 +131,7 @@ static void hpi_write_words_le16(struct c67x00_device *dev, u16 addr,
 }
 
 /*
- * Only data is little endian, addr has cpu endianess
+ * Only data is little endian, addr has cpu endianness
  */
 static void hpi_read_words_le16(struct c67x00_device *dev, u16 addr,
 				__le16 *data, u16 count)
@@ -397,7 +397,7 @@ int c67x00_ll_reset(struct c67x00_device *dev)
 
 /*
  * c67x00_ll_write_mem_le16 - write into c67x00 memory
- * Only data is little endian, addr has cpu endianess.
+ * Only data is little endian, addr has cpu endianness.
  */
 void c67x00_ll_write_mem_le16(struct c67x00_device *dev, u16 addr,
 			      void *data, int len)
@@ -436,7 +436,7 @@ void c67x00_ll_write_mem_le16(struct c67x00_device *dev, u16 addr,
 
 /*
  * c67x00_ll_read_mem_le16 - read from c67x00 memory
- * Only data is little endian, addr has cpu endianess.
+ * Only data is little endian, addr has cpu endianness.
  */
 void c67x00_ll_read_mem_le16(struct c67x00_device *dev, u16 addr,
 			     void *data, int len)
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index ae6c94f41cb3..3697a45b3cf1 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -37,7 +37,7 @@ struct c67x00_ep_data {
 /*
  * struct c67x00_td
  *
- * Hardware parts are little endiannes, SW in CPU endianess.
+ * Hardware parts are little endiannes, SW in CPU endianness.
  */
 struct c67x00_td {
 	/* HW specific part */
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7556c0dac908..1745d9f51a1c 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -1189,7 +1189,7 @@ static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
  *
  * The subdriver will manage the given interrupt endpoint exclusively
  * and will issue control requests referring to the given intf. It
- * will otherwise avoid interferring, and in particular not do
+ * will otherwise avoid interfering, and in particular not do
  * usb_set_intfdata/usb_get_intfdata on intf.
  *
  * The return value is a pointer to the subdriver's struct usb_driver.
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3345b3298daf..54e0d4f61f00 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6393,7 +6393,7 @@ int usb_reset_device(struct usb_device *udev)
 	 * is included in current configuration. The easist
 	 * approach is to do it for every device reset,
 	 * because the device 'memalloc_noio' flag may have
-	 * not been set before reseting the usb device.
+	 * not been set before resetting the usb device.
 	 */
 	noio_flag = memalloc_noio_save();
 
diff --git a/drivers/usb/fotg210/fotg210-hcd.h b/drivers/usb/fotg210/fotg210-hcd.h
index 13c9342982ee..b7353a89a71a 100644
--- a/drivers/usb/fotg210/fotg210-hcd.h
+++ b/drivers/usb/fotg210/fotg210-hcd.h
@@ -283,7 +283,7 @@ struct fotg210_regs {
 #define PORT_RWC_BITS   (PORT_CSC | PORT_PEC)
 	u32     reserved2[19];
 
-	/* OTGCSR: offet 0x70 */
+	/* OTGCSR: offset 0x70 */
 	u32     otgcsr;
 #define OTGCSR_HOST_SPD_TYP     (3 << 22)
 #define OTGCSR_A_BUS_DROP	(1 << 5)
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 51df6d1d1487..4e33239bb9e0 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -326,7 +326,7 @@ static ssize_t gadget_dev_desc_max_speed_store(struct config_item *item,
 
 	mutex_lock(&gi->lock);
 
-	/* Prevent changing of max_speed after the driver is binded */
+	/* Prevent changing of max_speed after the driver is bound */
 	if (gi->composite.gadget_driver.udc_name)
 		goto err;
 
diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 3c6b43d06a6d..a946f0030109 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -353,7 +353,7 @@ static ssize_t f_hidg_intout_read(struct file *file, char __user *buffer,
 	list->pos += count;
 
 	/*
-	 * if this request is completely handled and transfered to
+	 * if this request is completely handled and transferred to
 	 * userspace, remove its entry from the list and requeue it
 	 * again. Otherwise, we will revisit it again upon the next
 	 * call, taking into account its current read position.
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index d8cf710085a0..f9ca07dec17e 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -206,7 +206,7 @@ static struct uac2_input_terminal_descriptor io_in_it_desc = {
 	.bmControls = cpu_to_le16(CONTROL_RDWR << COPY_CTRL),
 };
 
-/* Ouput Terminal for USB_IN */
+/* Output Terminal for USB_IN */
 static struct uac2_output_terminal_descriptor usb_in_ot_desc = {
 	.bLength = sizeof usb_in_ot_desc,
 	.bDescriptorType = USB_DT_CS_INTERFACE,
@@ -220,7 +220,7 @@ static struct uac2_output_terminal_descriptor usb_in_ot_desc = {
 	.bmControls = cpu_to_le16(CONTROL_RDWR << COPY_CTRL),
 };
 
-/* Ouput Terminal for I/O-Out */
+/* Output Terminal for I/O-Out */
 static struct uac2_output_terminal_descriptor io_out_ot_desc = {
 	.bLength = sizeof io_out_ot_desc,
 	.bDescriptorType = USB_DT_CS_INTERFACE,
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index db961aaa3740..c8b71afb4e15 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1958,7 +1958,7 @@ static const struct file_operations ep0_operations = {
 
 
 /* FIXME PAM etc could set this security policy without mount options
- * if epfiles inherited ownership and permissons from ep0 ...
+ * if epfiles inherited ownership and permissions from ep0 ...
  */
 
 static unsigned default_uid;
diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index a8dbaef54aba..dfdb4c2948da 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -361,7 +361,7 @@ int bdc_reinit(struct bdc *bdc)
 	return ret;
 }
 
-/* Allocate all the dyanmic memory */
+/* Allocate all the dynamic memory */
 static int bdc_mem_alloc(struct bdc *bdc)
 {
 	u32 page_size;
diff --git a/drivers/usb/gadget/udc/bdc/bdc_ep.c b/drivers/usb/gadget/udc/bdc/bdc_ep.c
index a7a22e5ec47b..608edd4ae5dd 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@ -298,7 +298,7 @@ static int bd_available_ep(struct bdc_ep *ep)
 		return bd_list->max_bdi - bd_list->num_tabs;
 
 	/*
-	 * Depending upon where eqp and dqp pointers are, caculate number
+	 * Depending upon where eqp and dqp pointers are, calculate number
 	 * of avaialble bd's
 	 */
 	if (bd_list->hwd_bdi < bd_list->eqp_bdi) {
diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index f6da12b553a0..fa2022e9bc60 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1101,7 +1101,7 @@ int usb_gadget_ep_match_desc(struct usb_gadget *gadget,
 EXPORT_SYMBOL_GPL(usb_gadget_ep_match_desc);
 
 /**
- * usb_gadget_check_config - checks if the UDC can support the binded
+ * usb_gadget_check_config - checks if the UDC can support the bound
  *	configuration
  * @gadget: controller to check the USB configuration
  *
@@ -1524,7 +1524,7 @@ EXPORT_SYMBOL_GPL(usb_add_gadget_udc_release);
 /**
  * usb_get_gadget_udc_name - get the name of the first UDC controller
  * This functions returns the name of the first UDC controller in the system.
- * Please note that this interface is usefull only for legacy drivers which
+ * Please note that this interface is useful only for legacy drivers which
  * assume that there is only one UDC controller in the system and they need to
  * get its name before initialization. There is no guarantee that the UDC
  * of the returned name will be still available, when gadget driver registers
diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.h b/drivers/usb/gadget/udc/fsl_qe_udc.h
index 53ca0ff7c2cb..de3c9deb7409 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.h
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.h
@@ -329,7 +329,7 @@ struct qe_udc {
 
 	u32 max_pipes;          /* Device max pipes */
 	u32 max_use_endpts;     /* Max endpointes to be used */
-	u32 bus_reset;          /* Device is bus reseting */
+	u32 bus_reset;          /* Device is bus resetting */
 	u32 resume_state;       /* USB state to resume*/
 	u32 usb_state;          /* USB current state */
 	u32 usb_next_state;     /* USB next state */
diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 20392409afb1..9c82713abbc4 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -1398,7 +1398,7 @@ __acquires(udc->lock)
 
 	udc_reset_ep_queue(udc, 0);
 
-	/* We process some stardard setup requests here */
+	/* We process some standard setup requests here */
 	switch (setup->bRequest) {
 	case USB_REQ_GET_STATUS:
 		/* Data+Status phase from udc */
@@ -1831,7 +1831,7 @@ static void reset_irq(struct fsl_udc *udc)
 
 	if (fsl_readl(&dr_regs->portsc1) & PORTSCX_PORT_RESET) {
 		dev_vdbg(udc->dev, "Bus reset\n");
-		/* Bus is reseting */
+		/* Bus is resetting */
 		udc->bus_reset = 1;
 		/* Reset all the queues, include XD, dTD, EP queue
 		 * head and TR Queue */
diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index 044c31869cfb..7348704a9fc4 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -2743,7 +2743,7 @@ static irqreturn_t lpc32xx_usb_lp_irq(int irq, void *_udc)
 		/* All types of errors, from cable removal during transfer to
 		 * misc protocol and bit errors. These are mostly for just info,
 		 * as the USB hardware will work around these. If these errors
-		 * happen alot, something is wrong. */
+		 * happen a lot, something is wrong. */
 		udc_protocol_cmd_w(udc, CMD_RD_ERR_STAT);
 		tmp = udc_protocol_cmd_r(udc, DAT_RD_ERR_STAT);
 		dev_dbg(udc->dev, "Device error (0x%x)!\n", tmp);
diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index 99b3ce28210f..bf673e7faf37 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -319,7 +319,7 @@ struct pch_vbus_gpio_data {
  * @ep:			array of endpoints
  * @lock:		protects all state
  * @stall:		stall requested
- * @prot_stall:		protcol stall requested
+ * @prot_stall:		protocol stall requested
  * @suspended:		driver in suspended state
  * @connected:		gadget driver associated
  * @vbus_session:	required vbus_session state
@@ -846,7 +846,7 @@ static inline u32 pch_udc_read_ep_interrupts(struct pch_udc_dev *dev)
 }
 
 /**
- * pch_udc_write_ep_interrupts() - Clear endpoint interupts
+ * pch_udc_write_ep_interrupts() - Clear endpoint interrupts
  * @dev:	Reference to structure of type pch_udc_regs
  * @val:	The value to be written to interrupt register
  */
diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index d190e16d43fc..105638d47c79 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -652,7 +652,7 @@ static int sudmac_alloc_channel(struct r8a66597 *r8a66597,
 		change_bfre_mode(r8a66597, ep->pipenum, 1);
 	}
 
-	/* set r8a66597_ep paramters */
+	/* set r8a66597_ep parameters */
 	ep->use_dma = 1;
 	ep->dma = dma;
 	ep->fifoaddr = D0FIFO;
diff --git a/drivers/usb/gadget/udc/snps_udc_plat.c b/drivers/usb/gadget/udc/snps_udc_plat.c
index 0ee3ed185d9c..4b0c907b0f76 100644
--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -36,7 +36,7 @@ static void stop_udc(struct udc *udc)
 
 	spin_lock(&udc->lock);
 
-	/* Flush the receieve fifo */
+	/* Flush the receive fifo */
 	reg = readl(&udc->regs->ctl);
 	reg |= AMD_BIT(UDC_DEVCTL_SRX_FLUSH);
 	writel(reg, &udc->regs->ctl);
diff --git a/drivers/usb/gadget/udc/udc-xilinx.c b/drivers/usb/gadget/udc/udc-xilinx.c
index bef06fe7543b..e6b9233ccdf9 100644
--- a/drivers/usb/gadget/udc/udc-xilinx.c
+++ b/drivers/usb/gadget/udc/udc-xilinx.c
@@ -128,7 +128,7 @@ struct xusb_req {
  * @name: name of the endpoint
  * @epnumber: endpoint number
  * @maxpacket: maximum packet size the endpoint can store
- * @buffer0count: the size of the packet recieved in the first buffer
+ * @buffer0count: the size of the packet received in the first buffer
  * @buffer1count: the size of the packet received in the second buffer
  * @curbufnum: current buffer of endpoint that will be processed next
  * @buffer0ready: the busy state of first buffer
@@ -311,7 +311,7 @@ static void xudc_epconfig(struct xusb_ep *ep, struct xusb_udc *udc)
  * Return: 0 on success, error code on failure
  *
  * This function starts DMA transfer by writing to DMA source,
- * destination and lenth registers.
+ * destination and length registers.
  */
 static int xudc_start_dma(struct xusb_ep *ep, dma_addr_t src,
 			  dma_addr_t dst, u32 length)
diff --git a/drivers/usb/host/fhci-q.c b/drivers/usb/host/fhci-q.c
index 669c240523fe..b13ad02454e1 100644
--- a/drivers/usb/host/fhci-q.c
+++ b/drivers/usb/host/fhci-q.c
@@ -208,7 +208,7 @@ void fhci_urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
 }
 
 /*
- * caculate transfer length/stats and update the urb
+ * calculate transfer length/stats and update the urb
  * Precondition: irqsafe(only for urb-?status locking)
  */
 void fhci_done_td(struct urb *urb, struct td *td)
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index d7482dc0604e..a52bddb45bb7 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -367,7 +367,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
  * Arguments:
  * usb          A pointer to the USB structure
  * pkt          A pointer to the user frame structure
- * trans_type   Transaction tyep - IN,OUT or SETUP
+ * trans_type   Transaction type - IN,OUT or SETUP
  * dest_addr    Device address - 0~127
  * dest_ep      Endpoint number of the device - 0~16
  * trans_mode   Pipe type - ISO,Interrupt,bulk or control
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index ca96067e6d6d..25c857efaa08 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -882,7 +882,7 @@ static void ehci_hub_descriptor(struct oxu_hcd *oxu,
  */
 static int oxu_buf_alloc(struct oxu_hcd *oxu, struct ehci_qtd *qtd, int len)
 {
-	int n_blocks;	/* minium blocks needed to hold len */
+	int n_blocks;	/* minimum blocks needed to hold len */
 	int a_blocks;	/* blocks allocated */
 	int i, j;
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a9e47e178c28..4f1943fbd6ca 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -406,7 +406,7 @@ static void compliance_mode_recovery(struct timer_list *t)
  * The quirk creates a timer that polls every 2 seconds the link state of
  * each host controller's port and recovers it by issuing a Warm reset
  * if Compliance mode is detected, otherwise the port will become "dead" (no
- * device connections or disconnections will be detected anymore). Becasue no
+ * device connections or disconnections will be detected anymore). Because no
  * status event is generated when entering compliance mode (per xhci spec),
  * this quirk is needed on systems that have the failing hardware installed.
  */
@@ -1178,7 +1178,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool power_lost, bool is_auto_resume)
 		/* Delete all remaining commands */
 		xhci_cleanup_command_queue(xhci);
 
-		/* Clear data which is re-initilized during runtime */
+		/* Clear data which is re-initialized during runtime */
 		xhci_for_each_ring_seg(xhci->interrupters[0]->event_ring->first_seg, seg)
 			memset(seg->trbs, 0, sizeof(union xhci_trb) * TRBS_PER_SEGMENT);
 
@@ -4296,7 +4296,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		pm_runtime_get_noresume(hcd->self.controller);
 
 	/* Is this a LS or FS device under a HS hub? */
-	/* Hub or peripherial? */
+	/* Hub or peripheral? */
 	return 1;
 
 disable_slot:
@@ -4512,7 +4512,7 @@ static int xhci_enable_device(struct usb_hcd *hcd, struct usb_device *udev)
 
 /*
  * Transfer the port index into real index in the HW port status
- * registers. Caculate offset between the port's PORTSC register
+ * registers. Calculate offset between the port's PORTSC register
  * and port status base. Divide the number of per port register
  * to get the real index. The raw port number bases 1.
  */
diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index ca287b770e8c..5ff509a7e402 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -59,7 +59,7 @@
  * has been removed.
  *
  * version 0.6.0
- * Rewrite of this driver: The Emulation of the rs232 protocoll
+ * Rewrite of this driver: The Emulation of the rs232 protocol
  * has been removed from the driver. A special executeCommand function
  * for this driver is included to gphoto.
  * The driver supports two kind of communication to bulk endpoints.
diff --git a/drivers/usb/misc/sisusbvga/sisusbvga.c b/drivers/usb/misc/sisusbvga/sisusbvga.c
index 3e75a7c24828..5a86962d86c0 100644
--- a/drivers/usb/misc/sisusbvga/sisusbvga.c
+++ b/drivers/usb/misc/sisusbvga/sisusbvga.c
@@ -590,7 +590,7 @@ static int sisusb_send_bridge_packet(struct sisusb_usb_data *sisusb, int len,
  * This means that
  *   - the write routines expect "data" in machine endianness format.
  *     The data will be converted to leXX in sisusb_xxx_packet.
- *   - the read routines can expect read data in machine-endianess.
+ *   - the read routines can expect read data in machine-endianness.
  */
 
 static int sisusb_write_memio_byte(struct sisusb_usb_data *sisusb, int type,
@@ -946,7 +946,7 @@ static int sisusb_write_mem_bulk(struct sisusb_usb_data *sisusb, u32 addr,
 	return ret ? -EIO : 0;
 }
 
-/* Remember: Read data in packet is in machine-endianess! So for
+/* Remember: Read data in packet is in machine-endianness! So for
  * byte, word, 24bit, long no endian correction is necessary.
  */
 
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 1d9571f24a56..6a86bebc24ca 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -941,7 +941,7 @@ static void tusb_musb_enable(struct musb *musb)
 	musb_writel(tbase, TUSB_DMA_INT_MASK, 0x7fffffff);
 	musb_writel(tbase, TUSB_GPIO_INT_MASK, 0x1ff);
 
-	/* Clear all subsystem interrups */
+	/* Clear all subsystem interrupts */
 	musb_writel(tbase, TUSB_USBIP_INT_CLEAR, 0x7fffffff);
 	musb_writel(tbase, TUSB_DMA_INT_CLEAR, 0x7fffffff);
 	musb_writel(tbase, TUSB_GPIO_INT_CLEAR, 0x1ff);
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 8c2a43d992f5..6858beed1ac4 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -80,7 +80,7 @@ static void ux500_musb_set_vbus(struct musb *musb, int is_on)
 	/*
 	 * Devctl values will be updated after vbus goes below
 	 * session_valid. The time taken depends on the capacitance
-	 * on VBUS line. The max discharge time can be upto 1 sec
+	 * on VBUS line. The max discharge time can be up to 1 sec
 	 * as per the spec. Typically on our platform, it is 200ms
 	 */
 	if (!is_on)
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index 1986f7e9d9be..96f206351c3f 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -166,7 +166,7 @@ static void fsl_otg_drv_vbus(struct otg_fsm *fsm, int on)
 }
 
 /*
- * Pull-up D+, signalling connect by periperal. Also used in
+ * Pull-up D+, signalling connect by peripheral. Also used in
  * data-line pulsing in SRP
  */
 static void fsl_otg_loc_conn(struct otg_fsm *fsm, int on)
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 0c7fe109d5c7..92f4f35f8bb1 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -852,7 +852,7 @@ static int usbhsg_try_start(struct usbhs_priv *priv, u32 status)
 	usbhs_pipe_config_update(dcp->pipe, 0, 0, 64);
 
 	/*
-	 * system config enble
+	 * system config enable
 	 * - HI speed
 	 * - function
 	 * - usb module
diff --git a/drivers/usb/renesas_usbhs/mod_host.c b/drivers/usb/renesas_usbhs/mod_host.c
index f7ef3a9f82a4..c6a9d916135f 100644
--- a/drivers/usb/renesas_usbhs/mod_host.c
+++ b/drivers/usb/renesas_usbhs/mod_host.c
@@ -1468,7 +1468,7 @@ static int usbhsh_start(struct usbhs_priv *priv)
 	usbhsh_pipe_init_for_host(priv);
 
 	/*
-	 * system config enble
+	 * system config enable
 	 * - HI speed
 	 * - host
 	 * - usb module
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 265162981269..0a3ffe15d26d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -426,7 +426,7 @@ static void uas_data_cmplt(struct urb *urb)
 	if (status) {
 		if (status != -ENOENT && status != -ECONNRESET && status != -ESHUTDOWN)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
-		/* error: no data transfered */
+		/* error: no data transferred */
 		scsi_set_resid(cmnd, sdb->length);
 		set_host_byte(cmnd, DID_ERROR);
 	} else {
diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 3319f6a2b0c9..d3258675fdbc 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -448,7 +448,7 @@ static int tcpm_get_current_limit(struct tcpc_dev *dev)
 
 	/*
 	 * USB2 Charger detection may still be in progress when we get here,
-	 * this can take upto 600ms, wait 800ms max.
+	 * this can take up to 600ms, wait 800ms max.
 	 */
 	timeout = jiffies + msecs_to_jiffies(800);
 	do {
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a8cd1959c426..15a3cae27b6c 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2504,7 +2504,7 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 			/*
 			 * PD2.0 Spec 6.10.3: respond with NAK as DFP (data host)
 			 * PD3.1 Spec 6.4.4.2.5.1: respond with NAK if "invalid field" or
-			 * "wrong configuation" or "Unrecognized"
+			 * "wrong configuration" or "Unrecognized"
 			 */
 			if ((port->data_role == TYPEC_DEVICE || svdm_version >= SVDM_VER_2_0) &&
 			    port->nr_snk_vdo) {
diff --git a/include/linux/usb/cdc.h b/include/linux/usb/cdc.h
index 0af0db51bc89..861fdfa984dc 100644
--- a/include/linux/usb/cdc.h
+++ b/include/linux/usb/cdc.h
@@ -10,7 +10,7 @@
 #include <uapi/linux/usb/cdc.h>
 
 /*
- * inofficial magic numbers
+ * unofficial magic numbers
  */
 
 #define CDC_PHONET_MAGIC_NUMBER		0xAB
-- 
2.48.1

