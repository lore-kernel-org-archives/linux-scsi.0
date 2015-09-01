From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] scsi_scan: move 'INQUIRY result too short' message to debug level
Date: Tue, 01 Sep 2015 17:43:50 +0200
Message-ID: <87io7udu15.fsf@vitty.brq.redhat.com>
References: <1441025401-30044-1-git-send-email-vkuznets@redhat.com>
	<1441115361.2682.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441115361.2682.2.camel@HansenPartnership.com> (James
	Bottomley's message of "Tue, 01 Sep 2015 07:49:21 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Mon, 2015-08-31 at 14:50 +0200, Vitaly Kuznetsov wrote:
>> Some Hyper-V hosts are known for ignoring SPC-2/3/4 requirement
>> for 'INQUIRY data (see table ...) shall contain at least 36 bytes'. As a
>> result we get tons on 'scsi 0:7:1:1: scsi scan: INQUIRY result too short
>> (5), using 36' messages on console. As Hyper-V is also known for its
>> serial port being extremely slow multi-VCPU guests we get CPU blocked
>> putting these (useless) messages on console (e.g. happens when we add
>> multiple disks). Move them to debug level.
>
> This isn't an ignorable debug message.  It means the inquiry information
> the system relies on will be false, so it's fairly essential for bug
> reports.  It could be made a once per device print, but I don't think we
> can eliminate it.

I see. What if we introduce a special flag to mark such known-as-broken
hosts? E.g.:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..c6ffb5c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -701,9 +701,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		sdev_printk(KERN_INFO, sdev,
-			    "scsi scan: INQUIRY result too short (%d),"
-			    " using 36\n", sdev->inquiry_len);
+		if (!sdev->host->hostt->short_inquiry)
+			sdev_printk(KERN_INFO, sdev,
+				    "scsi scan: INQUIRY result too short (%d),"
+				    " using 36\n", sdev->inquiry_len);
 		sdev->inquiry_len = 36;
 	}
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..f3b4d0f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1711,6 +1711,7 @@ static struct scsi_host_template scsi_driver = {
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
 	.no_write_same =	1,
+	.short_inquiry =	1,
 };
 
 enum {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..04aefad 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -454,6 +454,12 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
 
 	/*
+	 * True if this host adapter returns short (<36 bytes) resposes to
+	 * INQUIRY requests.
+	 */
+	unsigned short_inquiry:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;

-- 
  Vitaly
