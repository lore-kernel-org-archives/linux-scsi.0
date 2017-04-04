From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when !CONFIG_LBDAF
Date: Tue, 04 Apr 2017 19:35:05 -0400
Message-ID: <yq1pogrvj9y.fsf@oracle.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
        <1488211985.2656.1.camel@sandisk.com>
        <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
        <1488221849.2656.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488221849.2656.8.camel@sandisk.com> (Bart Van Assche's message
        of "Mon, 27 Feb 2017 18:57:44 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "steve.magnani@digidescorp.com" <steve.magnani@digidescorp.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

Hi Bart,

> Sorry but I still don't understand why the two checks are
> different. How about the (untested) patch below? The approach below
> avoids that the check is duplicated and - at least in my opinion -
> results in code that is easier to read.

Just tripped over this issue in connection with something else. However,
I had to make a few passes to convince myself that your proposed fix was
correct. How about something like the following?

Martin

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9b4d29af0b..6084c415c070 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2102,6 +2102,16 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
+static bool sd_addressable_capacity(u64 lba, unsigned int sector_size)
+{
+	u64 last_sector = lba + 1ULL << ilog2(sector_size) - 9;
+
+	if (sizeof(sector_t) == 4 && last_sector > 0xffffffffULL)
+		return false;
+
+	return true;
+}
+
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
@@ -2167,7 +2177,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -ENODEV;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2256,7 +2266,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return sector_size;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
