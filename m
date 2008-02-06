From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sr: update to follow tray status correctly
Date: Wed, 06 Feb 2008 13:01:58 -0600
Message-ID: <1202324518.3112.104.camel@localhost.localdomain>
References: <20071027225830.585C8657DB@smtp.gentoo.org>
	 <1193801523.3321.138.camel@localhost.localdomain>
	 <1199551191.3399.29.camel@localhost.localdomain>
	 <47A9E9C6.4000802@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56780 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbYBFTCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 14:02:05 -0500
In-Reply-To: <47A9E9C6.4000802@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: Maarten Bressers <mbres@gentoo.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, tasio@hierro.tasio.net

On Wed, 2008-02-06 at 17:09 +0000, Daniel Drake wrote:
> Hi James,
> 
> James Bottomley wrote:
> > It's been a while with no status on this one, so I corrected the patch
> > based on my original input.  The attached is what I think is the best
> > way of doing this (I've replaced the home grown test_unit_ready routine
> > with the SCSI one and updated some of the sense check conditions).
> 
> Many thanks for following up on this. The user has not responded to my 
> request for him to test your patch, so I decided to try it myself. I'm 
> using Linus git as of today, I noticed the patch is merged.
> 
> It doesn't work for me. On unpatched 2.6.24, I get the behaviour 
> previously described - the ioctl always gives CDS_TRAY_OPEN regardless 
> of tray status. On 2.6.24-git which includes your patch, I instead 
> always get CDS_DISC_OK. I have confirmed that on 2 systems this is 
> because scsi_test_unit_ready() is returning 0.
> 
> Before I dig further, does this work for you? I have attached the test 
> program I am using.

Heh, you assume I have a CD easily to hand in my testing setup. But,
unfortunately it requires a bit of manual intervention to set up the
state ...

However, I think you're right, the vanilla TUR does eat NOT_READY for
removable media, which CDs are.  Does this fix it?

James

---
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 50ba492..1332a5c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -163,6 +163,29 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_unlock(&sr_ref_mutex);
 }
 
+/* identical to scsi_test_unit_ready except that it doesn't
+ * eat the NOT_READY returns for removable media */
+int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
+{
+	int retries = MAX_RETRIES;
+	int the_result; 
+	u8 cmd[] = {TEST_UNIT_READY, 0, 0, 0, 0, 0 };
+     
+	/* issue TEST_UNIT_READY until the initial startup UNIT_ATTENTION
+	 * conditions are gone, or a timeout happens
+	 */
+	do {
+		the_result = scsi_execute_req (sdev, cmd, DMA_NONE, NULL,
+					       0, sshdr, SR_TIMEOUT,
+					       retries--);
+
+	} while (retries > 0 && 
+		 (!scsi_status_is_good(the_result) ||
+		  (scsi_sense_valid(sshdr) &&
+		   sshdr->sense_key == UNIT_ATTENTION)));
+	return the_result;
+}
+
 /*
  * This function checks to see if the media has been changed in the
  * CDROM drive.  It is possible that we have already sensed a change,
@@ -185,8 +208,7 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 	}
 
 	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
-				      sshdr);
+	retval = sr_test_unit_ready(cd->device, sshdr);
 	if (retval || (scsi_sense_valid(sshdr) &&
 		       /* 0x3a is medium not present */
 		       sshdr->asc == 0x3a)) {
@@ -733,10 +755,8 @@ static void get_capabilities(struct scsi_cd *cd)
 {
 	unsigned char *buffer;
 	struct scsi_mode_data data;
-	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sshdr;
-	unsigned int the_result;
-	int retries, rc, n;
+	int rc, n;
 
 	static const char *loadmech[] =
 	{
@@ -758,23 +778,8 @@ static void get_capabilities(struct scsi_cd *cd)
 		return;
 	}
 
-	/* issue TEST_UNIT_READY until the initial startup UNIT_ATTENTION
-	 * conditions are gone, or a timeout happens
-	 */
-	retries = 0;
-	do {
-		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
-		cmd[0] = TEST_UNIT_READY;
-
-		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
-					       0, &sshdr, SR_TIMEOUT,
-					       MAX_RETRIES);
-
-		retries++;
-	} while (retries < 5 && 
-		 (!scsi_status_is_good(the_result) ||
-		  (scsi_sense_valid(&sshdr) &&
-		   sshdr.sense_key == UNIT_ATTENTION)));
+	/* eat unit attentions */
+	sr_test_unit_ready(cd->device, &sshdr);
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 81fbc0b..1e144df 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -61,6 +61,7 @@ int sr_select_speed(struct cdrom_device_info *cdi, int speed);
 int sr_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 
 int sr_is_xa(Scsi_CD *);
+int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr);
 
 /* sr_vendor.c */
 void sr_vendor_init(Scsi_CD *);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index d5cebff..ae87d08 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -306,8 +306,7 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (0 == scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
-				      &sshdr))
+	if (0 == sr_test_unit_ready(cd->device, &sshdr))
 		return CDS_DISC_OK;
 
 	if (!cdrom_get_media_event(cdi, &med)) {


