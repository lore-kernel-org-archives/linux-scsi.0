From: John McKell <mckellj@iomega.com>
Subject: [PATCH]:Amended:Allow random write for PDT 5 profile 2 Removable
	Disk
Date: 12 Feb 2004 12:00:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076612434.3386.3.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:12198 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266549AbUBLTAj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 14:00:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Jens,

The patch submitted recently: 
Subject:[PATCH]Allow random write for PDT 5 profile 2 Removable Disk
http://marc.theaimsgroup.com/?l=linux-scsi&m=107653753500466&w=2
was a composite patch.  This corrects that (as well as a few other 
small issues).  Thanks for the help.

---John McKell

diff -Nurp linux-2.6.2-fix/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.2-fix/include/linux/cdrom.h	2004-02-03 20:43:06.000000000 -0700
+++ linux/include/linux/cdrom.h	2004-02-12 09:18:19.000000000 -0700
@@ -721,7 +721,9 @@ struct request_sense {
 /*
  * feature profile
  */
-#define CDF_MRW		0x28
+#define CDF_RWRT	0x0020
+#define CDF_HWDM	0x0024
+#define CDF_MRW 	0x0028
 
 /*
  * media status bits
@@ -770,6 +772,34 @@ struct mrw_feature_desc {
 	__u8 reserved5;
 };
 
+/* cf. mmc4r02g.pdf 5.3.10 Random Writable Feature (0020h) pg 197 of 635 */
+struct rwrt_feature_desc {
+	__u16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1		: 2;
+	__u8 feature_version	: 4;
+	__u8 persistent		: 1;
+	__u8 curr		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr		: 1;
+	__u8 persistent		: 1;
+	__u8 feature_version	: 4;
+	__u8 reserved1		: 2;
+#endif
+	__u8 add_len;
+	__u32 last_lba;
+	__u32 block_size;
+	__u16 blocking;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved2		: 7;
+	__u8 page_present	: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 page_present	: 1;
+	__u8 reserved2		: 7;
+#endif
+	__u8 reserved3;
+};
+
 typedef struct {
 	__u16 disc_information_length;
 #if defined(__BIG_ENDIAN_BITFIELD)
@@ -1129,6 +1159,7 @@ struct media_event_desc {
 
 extern int cdrom_get_media_event(struct cdrom_device_info *cdi, struct media_event_desc *med);
 extern int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write);
+extern int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write);
 
 #endif  /* End of kernel only stuff */ 
 
diff -Nurp linux-2.6.2-fix/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.2-fix/drivers/ide/ide-cd.c	2004-02-03 20:43:44.000000000 -0700
+++ linux/drivers/ide/ide-cd.c	2004-02-12 09:29:04.000000000 -0700
@@ -2911,6 +2911,8 @@ static int ide_cdrom_register (ide_drive
 		devinfo->mask |= CDC_MRW;
 	if (!CDROM_CONFIG_FLAGS(drive)->mrw_w)
 		devinfo->mask |= CDC_MRW_W;
+	if (!CDROM_CONFIG_FLAGS(drive)->ram)
+		devinfo->mask |= CDC_RAM;
 
 	return register_cdrom(devinfo);
 }
@@ -2946,7 +2948,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
 	struct atapi_capabilities_page cap;
-	int nslots = 1, mrw_write = 0;
+	int nslots = 1, mrw_write = 0, ram_write = 0;
 
 	if (drive->media == ide_optical) {
 		CDROM_CONFIG_FLAGS(drive)->mo_drive = 1;
@@ -2982,6 +2984,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 			CDROM_CONFIG_FLAGS(drive)->ram = 1;
 		}
 	}
+	if (!cdrom_is_random_writable(cdi, &ram_write))
+		if (ram_write)
+			CDROM_CONFIG_FLAGS(drive)->ram = 1;
 
 	if (cap.lock == 0)
 		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
diff -Nurp linux-2.6.2-fix/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.2-fix/drivers/scsi/sr.c	2004-02-09 13:59:10.000000000 -0700
+++ linux/drivers/scsi/sr.c	2004-02-12 09:25:57.000000000 -0700
@@ -693,7 +693,7 @@ Enomem:
 static void get_capabilities(struct scsi_cd *cd)
 {
 	unsigned char *buffer;
-	int rc, n, mrw_write = 0, mrw = 1;
+	int rc, n, mrw_write = 0, mrw = 1,ram_write=0;
 	struct scsi_mode_data data;
 	struct scsi_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
@@ -775,6 +775,11 @@ static void get_capabilities(struct scsi
 	if (!mrw_write)
 		cd->cdi.mask |= CDC_MRW_W;
 
+	if (cdrom_is_random_writable(&cd->cdi, &ram_write))
+		cd->cdi.mask |= CDC_RAM;
+	if (!ram_write)
+		cd->cdi.mask |= CDC_RAM;
+
 	n = data.header_length + data.block_descriptor_length;
 	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known = 1;
@@ -824,7 +829,8 @@ static void get_capabilities(struct scsi
 	/*
 	 * if DVD-RAM of MRW-W, we are randomly writeable
 	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W)) != (CDC_DVD_RAM | CDC_MRW_W))
+	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) !=
+	    (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM))
 		cd->device->writeable = 1;
 
 	scsi_release_request(SRpnt);
diff -Nurp linux-2.6.2-fix/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.2-fix/drivers/cdrom/cdrom.c	2004-02-09 13:58:21.000000000 -0700
+++ linux/drivers/cdrom/cdrom.c	2004-02-12 10:20:38.000000000 -0700
@@ -641,6 +641,80 @@ static int cdrom_mrw_set_lba_space(struc
 	return 0;
 }
 
+int cdrom_get_random_writable(struct cdrom_device_info *cdi,
+			      struct rwrt_feature_desc *rfd)
+{
+	struct cdrom_generic_command cgc;
+	char buffer[24];
+	struct feature_header *fh;
+	int ret;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;	/* often 0x46 */
+	cgc.cmd[3] = CDF_RWRT;			/* often 0x0020 */
+	cgc.cmd[8] = sizeof(buffer);		/* often 0x18 */
+	cgc.quiet = 1;
+
+	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+		return ret;
+
+	fh = (struct feature_header *)&buffer[0];
+	if (be32_to_cpu(fh->data_len) >= (sizeof(struct feature_header)+
+					  sizeof(struct rwrt_feature_desc)))
+		memcpy(rfd, &buffer[sizeof(struct feature_header)],
+		       sizeof (*rfd));
+	else
+		memset(rfd, 0, sizeof(*rfd));
+
+	return 0;
+}
+
+int cdrom_has_defect_mgt(struct cdrom_device_info *cdi)
+{
+	struct cdrom_generic_command cgc;
+	char buffer[16];
+	struct feature_header *fh;
+	__u16 *feature_code;
+	int ret;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;	/* often 0x46 */
+	cgc.cmd[3] = CDF_HWDM;			/* often 0x0024 */
+	cgc.cmd[8] = sizeof(buffer);		/* often 0x10 */
+	cgc.quiet = 1;
+
+	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+		return ret;
+
+	fh = (struct feature_header *)&buffer[0];
+	ret = 1;
+	if (be32_to_cpu(fh->data_len) >= (sizeof(struct feature_header)+8)) {
+		feature_code = (__u16 *)&buffer[sizeof(struct feature_header)];
+		if (CDF_HWDM == be16_to_cpu(*feature_code))
+			ret = 0;
+	}
+	return ret;
+}
+
+
+int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
+{
+	struct rwrt_feature_desc rfd;
+	int ret;
+
+	*write = 0;
+
+	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+		return ret;
+
+	if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
+		*write = 1;
+
+	return 0;
+}
+
 static int cdrom_media_erasable(struct cdrom_device_info *cdi)
 {
 	disc_information di;
@@ -695,6 +769,23 @@ static int cdrom_mrw_open_write(struct c
 	return ret;
 }
 
+static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
+{
+	struct rwrt_feature_desc rfd;
+	int ret;
+
+	if ((ret = cdrom_has_defect_mgt(cdi)))
+		return ret;
+	else
+		if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+			return ret;
+		else if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
+			ret = !rfd.curr;
+
+	cdinfo(CD_OPEN, "can open for random write\n");
+	return ret;
+}
+
 /*
  * returns 0 for ok to open write, non-0 to disallow
  */
@@ -706,6 +797,9 @@ static int cdrom_open_write(struct cdrom
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
 		ret = cdrom_dvdram_open_write(cdi);
+	else if (CDROM_CAN(CDC_RAM) &&
+		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW))
+		ret = cdrom_ram_open_write(cdi);
 	/*
 	 * needs to really check whether media is writeable
 	 */
@@ -2644,6 +2738,7 @@ EXPORT_SYMBOL(cdrom_mode_sense);
 EXPORT_SYMBOL(init_cdrom_command);
 EXPORT_SYMBOL(cdrom_get_media_event);
 EXPORT_SYMBOL(cdrom_is_mrw);
+EXPORT_SYMBOL(cdrom_is_random_writable);
 
 #ifdef CONFIG_SYSCTL
 
@@ -2748,6 +2843,10 @@ int cdrom_sysctl_info(ctl_table *ctl, in
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
 
+	pos += sprintf(info+pos, "\nCan write RAM:\t");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);



