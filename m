From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_level constants in scsi.h
Date: Wed, 25 Aug 2004 11:33:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412BEC84.50809@torque.net>
References: <412B28F8.8000107@torque.net> <20040824125239.A28215@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070709050001050201000000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:61844 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S266262AbUHYBeq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 21:34:46 -0400
In-Reply-To: <20040824125239.A28215@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------070709050001050201000000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> On Tue, Aug 24, 2004 at 09:39:36PM +1000, Douglas Gilbert wrote:
> 
>>The scsi_level value in struct scsi_device is a bit
>>mysterious. Hopefully this patch makes it a bit clearer
>>since it is visible via sysfs.
>>
>>Changes:
>>   - add scsi_level constants for SPC-2 and SPC-3
>>   - comment on relationship between scsi_level and INQUIRY response
> 
> 
> Looks cool.  What about turning it into an enum while you're at it?

Christoph,
Changes:
     - convert scsi_level defines to enumerations
     - add scsi_level enumerations for SPC-2, SPC-3 and proposed SPC-4
     - comment on relationship between scsi_level and INQUIRY response

Patch against lk 2.6.9-rc1 attached.

Doug Gilbert


--------------070709050001050201000000
Content-Type: text/x-patch;
 name="scsi_h_269rc1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_h_269rc1.diff"

--- linux/include/scsi/scsi.h	2004-08-25 10:06:42.597842752 +1000
+++ linux/include/scsi/scsi.h269rc1sl2	2004-08-25 10:20:24.314922768 +1000
@@ -354,14 +354,22 @@
 		     ((lun) & 0x07))
 
 /*
- *  SCSI command sets
+ *  struct scsi_device::scsi_level values. For SCSI devices other than those
+ *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + 1)
+ *  where "resp" is a byte array of the response to an INQUIRY. The scsi_level
+ *  variable is visible to the user via sysfs.
  */
 
-#define SCSI_UNKNOWN    0
-#define SCSI_1          1
-#define SCSI_1_CCS      2
-#define SCSI_2          3
-#define SCSI_3          4
+enum scsi_level_state {
+	SCSI_UNKNOWN =	0,
+	SCSI_1 =	1,
+	SCSI_1_CCS =	2,
+	SCSI_2 =	3,
+	SCSI_3 =	4,	/* SPC */
+	SCSI_SPC_2 =	5,
+	SCSI_SPC_3 =	6,
+	SCSI_SPC_4 =	7
+};
 
 /*
  * INQ PERIPHERAL QUALIFIERS

--------------070709050001050201000000--
