From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_get_sense_info_fld when valid=0
Date: Wed, 26 Oct 2005 11:12:51 +1000
Message-ID: <435ED813.8070007@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000905040206040609080804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:7816 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932514AbVJZBMC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 21:12:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------000905040206040609080804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alan,
This is in response to your post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112982432526039&w=2
in a thread titled:
  [PATCH] Improve code for detecting errors near the end of a CD

This patch should allow for the flexibility to handle
MMC devices that don't set the valid bit when putting
a lba in the information field.
The patch is against lk 2.6.14-rc5 .

Changelog:
  - make scsi_get_sense_info_fld() yield the sense
    data information field, or 0 if it is not available
  - the return value is the state of the valid bit in
    the sense data

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------000905040206040609080804
Content-Type: text/x-patch;
 name="scsi_err2614rc5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_err2614rc5.diff"

--- linux/drivers/scsi/scsi_error.c	2005-10-22 15:45:31.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2614rc5inf	2005-10-26 10:53:59.000000000 +1000
@@ -1929,11 +1929,17 @@
  *
  * @sense_buffer:	byte array of sense data
  * @sb_len:		number of valid bytes in sense_buffer
- * @info_out:		pointer to 64 integer where 8 or 4 byte information
- *			field will be placed if found.
+ * @info_out:		pointer to 64 bit integer where 8 or 4 byte
+ *			information field will be placed if found,
+ *			else 0 is written via pointer
+ *
+ * Notes:
+ *	Due to fuzziness in the MMC standard, a MMC device may (and some
+ *	do) set the information field without also setting the valid bit.
  *
  * Return value:
- *	1 if information field found, 0 if not found.
+ *	1 if valid bit is set, 0 if it is clear. Even when the return value
+ *	is 0, the information field may be fetched.
  **/
 int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 			    u64 * info_out)
@@ -1942,18 +1948,16 @@
 	const u8 * ucp;
 	u64 ull;
 
+	*info_out = 0;
 	if (sb_len < 7)
 		return 0;
 	switch (sense_buffer[0] & 0x7f) {
 	case 0x70:
 	case 0x71:
-		if (sense_buffer[0] & 0x80) {
-			*info_out = (sense_buffer[3] << 24) +
-				    (sense_buffer[4] << 16) +
-				    (sense_buffer[5] << 8) + sense_buffer[6];
-			return 1;
-		} else
-			return 0;
+		*info_out = (sense_buffer[3] << 24) +
+			    (sense_buffer[4] << 16) +
+			    (sense_buffer[5] << 8) + sense_buffer[6];
+		return (sense_buffer[0] & 0x80) ? 1 : 0;
 	case 0x72:
 	case 0x73:
 		ucp = scsi_sense_desc_find(sense_buffer, sb_len,
@@ -1966,7 +1970,7 @@
 				ull |= ucp[4 + j];
 			}
 			*info_out = ull;
-			return 1;
+			return 1;	/* valid bit defined to be 1 */
 		} else
 			return 0;
 	default:

--------------000905040206040609080804--
