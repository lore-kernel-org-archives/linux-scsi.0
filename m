From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/1] scsi: fix check of PQ and PDT bits for WLUNs
Date: Thu, 21 Aug 2008 15:14:14 -0500
Message-ID: <1219349654.3265.38.camel@localhost.localdomain>
References: <20080812114037.963047000@linux.vnet.ibm.com>
	 <20080812114123.133900000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42070 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbYHUUOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 16:14:18 -0400
In-Reply-To: <20080812114123.133900000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Petermann <martin@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-08-12 at 13:40 +0200, Martin Petermann wrote:
> plain text document attachment (scsi_scan.diff)
> From: Martin Petermann <martin@linux.vnet.ibm.com>
> 
> With kernel version 2.6.19 a check was introduced not to create a generic
> SCSI device for devices that return PQ=1 and PDT=0x1f. For WLUNs (see 
> SAM-3, p. 41ff) generic SCSI devices should be created unconditionally
> without looking at the PQ bit. I'm referring here to the thread "With kernel
> 2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f" of the 
> linux-scsi forum. This is my proposed fix.
> 
> Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
> 
> ---
>  drivers/scsi/scsi_scan.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/drivers/scsi/scsi_scan.c	2008-08-12 12:51:32.000000000 +0200
> +++ b/drivers/scsi/scsi_scan.c	2008-08-12 12:58:16.000000000 +0200
> @@ -75,6 +75,11 @@
>  #define SCSI_SCAN_TARGET_PRESENT	1
>  #define SCSI_SCAN_LUN_PRESENT		2
>  
> +#define SCSI_W_LUN_BASE 0xc100
> +#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
> +#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
> +#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)

These need to be in a header file, I think, probably scsi.h

>  static const char *scsi_null_device_strs = "nullnullnullnull";
>  
>  #define MAX_SCSI_LUNS	512
> @@ -1080,7 +1085,7 @@ static int scsi_probe_and_add_lun(struct
>  	 * PDT=1Fh none (no FDD connected to the requested logical unit)
>  	 */
>  	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
> -	     (result[0] & 0x1f) == 0x1f) {
> +	    (result[0] & 0x1f) == 0x1f && (lun & 0xff00) != SCSI_W_LUN_BASE) {

And this should probably be wrapped nicely too.

>  		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
>  					"scsi scan: peripheral device type"
>  					" of 31, no device added\n"));

Does this look OK?

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 84b4879..34d0de6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1080,7 +1080,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
-	     (result[0] & 0x1f) == 0x1f) {
+	    (result[0] & 0x1f) == 0x1f &&
+	    !scsi_is_wlun(lun)) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral device type"
 					" of 31, no device added\n"));
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c40cc5..192f871 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -309,6 +309,20 @@ struct scsi_lun {
 };
 
 /*
+ * The Well Known LUNS (SAM-3) in our int representation of a LUN
+ */
+#define SCSI_W_LUN_BASE 0xc100
+#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
+#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
+#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
+
+static inline int scsi_is_wlun(unsigned int lun)
+{
+	return (lun & 0xff00) == SCSI_W_LUN_BASE;
+}
+
+
+/*
  *  MESSAGE CODES
  */
 


