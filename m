Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FA437DE92
	for <linux-scsi@vger.kernel.org>; Sun,  3 May 2026 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777823060; cv=none; b=e9yJVeMKdfM0/kR+ZGSqrbZbe8wYb+E4BBzzeK8aoTGOAzttbEVcXOvKPBGT4iOyOoNpNYEpMZSYTFfF1U9w3eNf+J4V7Tglgn0WWFySh0uSXJ7Av+9//7Ya8bOiRtXSwXKikWJWaGiZ6/mkxFjOyPo6CWzlKfBVPkaW3d/AGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777823060; c=relaxed/simple;
	bh=T8F42POAToFNBe/c6Lvjrezo0y1L+8vgzufG+w2J95k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SPAVWd09P/chapupK6TNM03Bb4nGhTbcPIGJ5OkdxNlQ/k608YI6a4rjlYQgnkBAHixP48x/3JmimjNRPhjrHnB2hOm9DcePdbn4x9bMp2FIcnIgi9F+pd34GsZUJyawtUu67UTRAIxwdWewXLhIL+N8+KMc8zkBEdIbSHelOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kzt2Ensa; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kzt2Ensa"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g7pwx6Xpgzlfl5V;
	Sun,  3 May 2026 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777823052; x=1780415053; bh=W2WBKBFcgRQtZYEa8mP2I/LA
	u5YF3Z3S7dU+0WBCs+s=; b=Kzt2EnsaZoOvrtjb1nPbqmcXt0efOCZN+Inq8UoB
	TOEGOTrB9i0NxQqfdRJnWisI7yH7sxcZgEfyu4sq5wrBhb6VHOsLMIsMazNBMt6T
	OzUlMgB9HboTs6sJkobDRpsJHOCJNzPRnanpWvWw2ePYgRRuQbEv2Cp/WLfKu5Sw
	ygeOGaFsfOPELjXTtlVtd7xZvSx0YoQzOSs7K9O4rtaXbAwXhD+SumA80d1+E/Nw
	8vJhYod9Bw3O00oo5/74jtHKE6Fj8V1ZHgFhS6rERyCwN+vkKtbR8ayDcSttl5JV
	9UkLnDJIzk9G0e8gSkESLudJRrsFKOVdGSJ1HgeFhf19eg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2N4tJGxxzxOd; Sun,  3 May 2026 15:44:12 +0000 (UTC)
Received: from [10.211.8.121] (unknown [213.147.98.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g7pwp2l1Gzlfl89;
	Sun,  3 May 2026 15:44:09 +0000 (UTC)
Message-ID: <b584f42f-534e-4204-9fa6-92ff93ab62ad@acm.org>
Date: Sun, 3 May 2026 17:44:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
From: Bart Van Assche <bvanassche@acm.org>
To: Brian Bunker <brian@purestorage.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org, krishna.kant@purestorage.com
References: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
 <20260501221153.90440-1-brian@purestorage.com>
 <5de0e746-1a90-4a41-a36b-e56a4fcfeee6@acm.org>
Content-Language: en-US
In-Reply-To: <5de0e746-1a90-4a41-a36b-e56a4fcfeee6@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/26 6:37 PM, Bart Van Assche wrote:
> Another possibility is to change sdev->vendor, sdev->model and
> sdev->rev from pointers to fixed size strings into '\0'-terminated char
> arrays.

(replying to my own email)

How about the untested patch below?

scsi: core: Convert inquiry information

Currently the vendor, model, and revision members of struct scsi_device
are pointers to fixed-length strings that are not NUL-terminated.
Fixed-precision format specifiers (e.g., "%.8s") are required whenever
they are printed and strncmp() must be used to compare these fields.
This is error-prone.

Convert these fields to fixed-size character arrays within struct
scsi_device and remove trailing white space at initialization time.

This patch fixes a bug in the qla2xxx driver. It makes the following
code safe:

                 if (state_flags & BIT_4)
                         scmd_printk(KERN_WARNING, cp,
                             "Unsupported device '%s' found.\n",
                             cp->device->vendor);

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 002e0660a0b8..e71b99f70076 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -306,7 +306,7 @@ static bool drivetemp_sct_avoid(struct 
drivetemp_data *st)
  	struct scsi_device *sdev = st->sdev;
  	unsigned int ctr;

-	if (!sdev->model)
+	if (!sdev->model[0])
  		return false;

  	/*
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fcf059bf41e8..f92ad396ac9c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7204,7 +7204,7 @@ static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, 
struct scsi_device *sdev)
  	if (asc_dvc->init_sdtr & tid_bits)
  		return;

-	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
+	if (type == TYPE_ROM && strcmp(sdev->vendor, "HP") == 0)
  		asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;

  	asc_dvc->pci_fix_asyn_xfer |= tid_bits;
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4010fdbf813c..fb59ca035843 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -408,7 +408,7 @@ ch_readconfig(scsi_changer *ch)
  				/* should not happen */
  				VPRINTK(KERN_CONT, "Huh? device not found!\n");
  			} else {
-				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
+				VPRINTK(KERN_CONT, "name: %8s %16s %4s\n",
  					ch->dt[elem]->vendor,
  					ch->dt[elem]->model,
  					ch->dt[elem]->rev);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd4723..bdec827b82a1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1262,7 +1262,7 @@ static void hpsa_show_dev_msg(const char *level, 
struct ctlr_info *h,
  	}

  	dev_printk(level, &h->pdev->dev,
-			"scsi %d:%d:%d:%d: %s %s %.8s %.16s %s SSDSmartPathCap%c En%c Exp=%d\n",
+			"scsi %d:%d:%d:%d: %s %s %s %s %s SSDSmartPathCap%c En%c Exp=%d\n",
  			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
  			description,
  			scsi_device_type(dev->devtype),
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b85..242bd46df3ba 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -292,9 +292,9 @@ static struct scsi_device *scsi_alloc_sdev(struct 
scsi_target *starget,
  	if (!sdev)
  		goto out;

-	sdev->vendor = scsi_null_device_strs;
-	sdev->model = scsi_null_device_strs;
-	sdev->rev = scsi_null_device_strs;
+	strscpy(sdev->vendor, scsi_null_device_strs);
+	strscpy(sdev->model, scsi_null_device_strs);
+	strscpy(sdev->rev, scsi_null_device_strs);
  	sdev->host = shost;
  	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
  	sdev->id = starget->id;
@@ -857,6 +857,21 @@ static int scsi_probe_lun(struct scsi_device *sdev, 
unsigned char *inq_result,
  	return 0;
  }

+static void strip_trailing_spaces(char *s)
+{
+	size_t size;
+	char *end;
+
+	size = strlen(s);
+	if (!size)
+		return;
+
+	end = s + size - 1;
+	while (end >= s && isspace(*end))
+		end--;
+	*(end + 1) = '\0';
+}
+
  /**
   * scsi_add_lun - allocate and fully initialze a scsi_device
   * @sdev:	holds information to be stored in the new scsi_device
@@ -905,11 +920,17 @@ static int scsi_add_lun(struct scsi_device *sdev, 
unsigned char *inq_result,
  	if (sdev->inquiry == NULL)
  		return SCSI_SCAN_NO_RESPONSE;

-	sdev->vendor = (char *) (sdev->inquiry + 8);
-	sdev->model = (char *) (sdev->inquiry + 16);
-	sdev->rev = (char *) (sdev->inquiry + 32);
-
-	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
+	memcpy(sdev->vendor, sdev->inquiry + 8, 8);
+	sdev->vendor[8] = 0;
+	strip_trailing_spaces(sdev->vendor);
+	memcpy(sdev->model, sdev->inquiry + 16, 16);
+	sdev->model[16] = 0;
+	strip_trailing_spaces(sdev->model);
+	memcpy(sdev->rev, sdev->inquiry + 32, 4);
+	sdev->rev[4] = 0;
+	strip_trailing_spaces(sdev->rev);
+
+	sdev->is_ata = strcmp(sdev->vendor, "ATA") == 0;
  	if (sdev->is_ata) {
  		/*
  		 * sata emulation layer device.  This is a hack to work around
@@ -978,7 +999,7 @@ static int scsi_add_lun(struct scsi_device *sdev, 
unsigned char *inq_result,
  	if (inq_result[7] & 0x10)
  		sdev->sdtr = 1;

-	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
+	sdev_printk(KERN_NOTICE, sdev, "%s %s %s %s PQ: %d "
  			"ANSI: %d%s\n", scsi_device_type(sdev->type),
  			sdev->vendor, sdev->model, sdev->rev,
  			sdev->inq_periph_qual, inq_result[2] & 0x07,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..3282ad956d1f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -648,9 +648,9 @@ static DEVICE_ATTR(field, S_IRUGO, 
sdev_show_##field, NULL);
   */
  sdev_rd_attr (type, "%d\n");
  sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr (vendor, "%s\n");
+sdev_rd_attr (model, "%s\n");
+sdev_rd_attr (rev, "%s\n");
  sdev_rd_attr (cdl_supported, "%d\n");

  static ssize_t
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2b4b2a1a8e44..b6c248e69b3a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2507,7 +2507,7 @@ static int sg_proc_seq_show_devstrs(struct 
seq_file *s, void *v)
  	sdp = it ? sg_lookup_dev(it->index) : NULL;
  	scsidp = sdp ? sdp->device : NULL;
  	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
-		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
+		seq_printf(s, "%8s\t%16s\t%4s\n",
  			   scsidp->vendor, scsidp->model, scsidp->rev);
  	else
  		seq_puts(s, "<no active device>\n");
diff --git a/drivers/target/target_core_pscsi.c 
b/drivers/target/target_core_pscsi.c
index 9ed2818c3028..1718d1620f24 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -169,14 +169,11 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, 
struct t10_wwn *wwn)
  	 * Use sdev->inquiry data from drivers/scsi/scsi_scan.c:scsi_add_lun()
  	 */
  	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
-	snprintf(wwn->vendor, sizeof(wwn->vendor),
-		 "%." __stringify(INQUIRY_VENDOR_LEN) "s", sdev->vendor);
+	strscpy(wwn->vendor, sdev->vendor);
  	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
-	snprintf(wwn->model, sizeof(wwn->model),
-		 "%." __stringify(INQUIRY_MODEL_LEN) "s", sdev->model);
+	strscpy(wwn->model, sdev->model);
  	BUILD_BUG_ON(sizeof(wwn->revision) != INQUIRY_REVISION_LEN + 1);
-	snprintf(wwn->revision, sizeof(wwn->revision),
-		 "%." __stringify(INQUIRY_REVISION_LEN) "s", sdev->rev);
+	strscpy(wwn->revision, sdev->rev);
  }

  static int
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..70315f7fdafe 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -702,7 +702,7 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
  	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
  		hba->dev_quirks);
  	if (sdev_ufs)
-		dev_err(hba->dev, "UFS dev info: %.8s %.16s rev %.4s\n",
+		dev_err(hba->dev, "UFS dev info: %s %s rev %s\n",
  			sdev_ufs->vendor, sdev_ufs->model, sdev_ufs->rev);

  	ufshcd_print_clk_freqs(hba);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891..cce4587b4b80 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -137,9 +137,9 @@ struct scsi_device {
  	struct mutex inquiry_mutex;
  	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
  	unsigned char * inquiry;	/* INQUIRY response data */
-	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
-	const char * model;		/* ... after scan; point to static string */
-	const char * rev;		/* ... "nullnullnullnull" before scan */
+	char vendor[9];
+	char model[17];
+	char rev[5];

  #define SCSI_DEFAULT_VPD_LEN	255	/* default SCSI VPD page size (max) */
  	struct scsi_vpd __rcu *vpd_pg0;

