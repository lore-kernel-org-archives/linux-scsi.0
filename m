From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 16:18:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040827161800.A32040@infradead.org>
References: <412EF74A.1070106@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:58890 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266170AbUH0PSB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 11:18:01 -0400
Content-Disposition: inline
In-Reply-To: <412EF74A.1070106@torque.net>; from dougg@torque.net on Fri, Aug 27, 2004 at 06:56:42PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org


+struct scsi_sense_hd {     /* See SPC-3 section 4.5 */

maybe scsi_sense_desc insted?

+    uint8_t response_code; /* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+    uint8_t sense_key;
+    uint8_t asc;
+    uint8_t ascq;
+    uint8_t byte4;
+    uint8_t byte5;
+    uint8_t byte6;
+    uint8_t additional_length; /* always 0 for fixed sense format */

We use u8 elsewhere in the scsi code, please stay consistant.

+static inline int scsi_sense_is_deferred(struct scsi_sense_hd * sshd)
+{
+	return (sshd && (sshd->response_code >= 0x70) && 
+		(sshd->response_code & 1)) ? 1 : 0;
+}

I don't think we need the NULL check for sshd here, do we?

+/**
+ *	scsi_normalize_sense - normalize main elements from either fixed
+ *		or descriptor sense data format into a common format.
+ *	@sense_buffer:	byte array containing sense data returned by
+ *			device
+ *	@sb_len:	number of valid bytes in sense_buffer
+ *	@sshd:		pointer to instance of structure that common
+ *			elements are written to. Ignored if NULL.
+ *
+ *	The "main elements" from sense data are: response_code, sense_key,
+ *	asc, ascq and additional_length (only for descriptor format).
+ *	Typically this function can be called after a device has
+ *	responded to a SCSI command with the CHECK_CONDITION status.
+ *
+ *	Returns 1 if valid sense data information found, else 0;
+ **/
+int scsi_normalize_sense(const uint8_t * sense_buffer, int sb_len,
+                         struct scsi_sense_hd * sshd)
+{
+	if (sshd)
+		memset(sshd, 0, sizeof(struct scsi_sense_hd));

Again, checking for a NULL sshd here doesn't make much sense.

Also I think this function should get a __ prefix and we should
add two small helpers that take a scsi_cmnd/scsi_request and use
the sense_buffer and len from it.

+	if ((NULL == sense_buffer) || (0 == sb_len) ||
+	    (0x70 != (0x70 & sense_buffer[0])))
+		return 0;
+	if (NULL == sshd)
+		return 1;

Wrong way around vs normal scsi style.  Should be more like:

	if (!sense_buffer || !sb_len || (0x70 & sense_buffer[0]) != 0x70)
		return 0;

(and the sshd check gone again)
(same issues come up below again a few times)

