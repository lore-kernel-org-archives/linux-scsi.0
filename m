From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sun, 22 May 2005 20:15:39 +1000
Message-ID: <42905BCB.4070809@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <1116689077.4999.9.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040306060501070705000901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:40865 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261340AbVEVKPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 06:15:35 -0400
In-Reply-To: <1116689077.4999.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------040306060501070705000901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> Here's a tiny update that means we print the correct ASCII type
> information
> 
> James
> 
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -111,6 +111,7 @@ const char *const scsi_device_types[MAX_
>  	"Unknown          ",
>  	"RAID             ",
>  	"Enclosure        ",
> +	"Direct-Access-RBC",
>  };
>  EXPORT_SYMBOL(scsi_device_types);
>  
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -28,7 +28,7 @@ extern const unsigned char scsi_command_
>   *	SCSI device types
>   */
>  
> -#define MAX_SCSI_DEVICE_CODE 14
> +#define MAX_SCSI_DEVICE_CODE 15
>  extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
>  
>  /*
> @@ -211,8 +211,8 @@ static inline int scsi_status_is_good(in
>  				     * - treated as TYPE_DISK */
>  #define TYPE_MEDIUM_CHANGER 0x08
>  #define TYPE_COMM           0x09    /* Communications device */
> -#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
>  #define TYPE_RAID           0x0c
> +#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
>  #define TYPE_RBC	    0x0e
>  #define TYPE_NO_LUN         0x7f
>  
> 
> 
> -

James,
Here is my take which goes a bit further.
One thing my patch does is change "CD-ROM"
to "CD/DVD" which might hurt any program
that parsers 'cat /proc/scsi/scsi". The
comments are taken from spc3r23 section 6.4.2
table 83.

Doug Gilbert

--------------040306060501070705000901
Content-Type: text/x-patch;
 name="scsi_2612rc4i1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_2612rc4i1.diff"

--- linux/include/scsi/scsi.h	2005-05-21 13:08:06.000000000 +1000
+++ linux/include/scsi/scsi.h2612rc4i1	2005-05-22 17:51:50.000000000 +1000
@@ -28,7 +28,7 @@
  *	SCSI device types
  */
 
-#define MAX_SCSI_DEVICE_CODE 14
+#define MAX_SCSI_DEVICE_CODE 32
 extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 
 /*
--- linux/drivers/scsi/scsi.c	2005-05-08 15:12:20.000000000 +1000
+++ linux/drivers/scsi/scsi.c2612rc4i1	2005-05-22 17:50:24.000000000 +1000
@@ -97,20 +97,38 @@
 #endif
 
 const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE] = {
-	"Direct-Access    ",
-	"Sequential-Access",
-	"Printer          ",
-	"Processor        ",
-	"WORM             ",
-	"CD-ROM           ",
-	"Scanner          ",
-	"Optical Device   ",
-	"Medium Changer   ",
-	"Communications   ",
-	"Unknown          ",
-	"Unknown          ",
-	"RAID             ",
-	"Enclosure        ",
+	"Direct-Access    ",	/* SBC-2 */
+	"Sequential-Access",	/* SSC-2 */
+	"Printer          ",	/* SSC */
+	"Processor        ",	/* SPC-2 */
+	"WORM             ",	/* SBC */
+	"CD/DVD           ",	/* MMC-4,5 */
+	"Scanner          ",	/* SCSI-2 */
+	"Optical Device   ",	/* SBC */
+	"Medium Changer   ",	/* SMC-2 */
+	"Communications   ",	/* SCSI-2 */
+	"Graphics(0xa)    ",
+	"Graphics(0xb)    ",
+	"RAID             ",	/* SCC-2 */
+	"Enclosure        ",	/* SES-2 */
+	"Simplified D-A   ",	/* RBC */
+	"Optical card rw  ",	/* OCRW */
+	"Bridge controller",	/* BCC */	/* 0x10 */
+	"Object storage   ",	/* OSD */
+	"Automation drv   ",	/* ADT */
+	"Unknown(0x13)    ",
+	"Unknown(0x14)    ",
+	"Unknown(0x15)    ",
+	"Unknown(0x16)    ",
+	"Unknown(0x17)    ",
+	"Unknown(0x18)    ",
+	"Unknown(0x19)    ",
+	"Unknown(0x1a)    ",
+	"Unknown(0x1b)    ",
+	"Unknown(0x1c)    ",
+	"Unknown(0x1e)    ",
+	"Well known lu    ",	/* SPC-3 */
+	"no dev on this lu",	/* SPC-3 */	/* 0x1f */
 };
 EXPORT_SYMBOL(scsi_device_types);
 

--------------040306060501070705000901--
