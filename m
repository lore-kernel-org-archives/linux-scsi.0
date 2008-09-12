From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 5/5] fusion disable scsi hard resets
Date: Fri, 12 Sep 2008 21:03:20 +0200
Message-ID: <200809122103.20995.bs@q-leap.de>
References: <200809122057.41565.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41685 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbYILTD0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 15:03:26 -0400
In-Reply-To: <200809122057.41565.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>

For 53C1030 based dual port HBAs the hard reset handler will still cause
trouble on the second channel with innocent devices. It is then better
to fail the device which activated the error handler than to fail
entirely innocent devices. Real solutions would be of course to figure out
why the hard reset handler cause trouble on the second channel. Probably
only LSI can do, though. Is it o.k. to do this for all mpt fusion based HBAs,
thus, are all of these 53C1030 based?

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptscsih.c |   45 ++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)


Index: linux-2.6.26/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.26/drivers/message/fusion/mptscsih.c
@@ -1890,6 +1890,33 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 		return FAILED;
 }
 
+/**
+  * Check if there are devices connected to the second (alt) ioc.
+  * Return 1 if there is at least on device and 0 if there are
+  * none or no alt_ioc.
+  */
+static int
+alt_ioc_with_dev(MPT_ADAPTER *ioc)
+{
+	struct Scsi_Host	*shost;
+	struct scsi_device	*sdev;
+	int 			have_devices = 0;
+
+	if (!ioc->alt_ioc)
+		return 0;
+
+	shost = ioc->alt_ioc->sh;
+
+	shost_for_each_device(sdev, shost) {
+		/* when we are here, we know there is is a device
+		 * attached to this host, which is all we need to know */
+		have_devices = 1;
+		break;
+	}
+
+	return have_devices ? 1 : 0;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
@@ -1922,8 +1949,22 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
 	retval = mpt_SoftResetHandler(ioc, CAN_SLEEP);
-	if (retval != 0)
-		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+	if (retval != 0) {
+		if (alt_ioc_with_dev(ioc) == 0) {
+			/* On dual port HBAs based on the 53C1030 chip the
+			* hard reset handler will cause DID_SOFT_ERROR on
+			* the second (in principle independent) port.
+			* Almost always this error cannot be recovered
+			* causing entire device failures. So it better not
+			* to call the hard reset handler at all in order to
+			* prevent failures of independent devices */
+			retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		} else {
+			printk(MYIOC_s_INFO_FMT "Skipping hard reset in "
+				"order to prevent failures on %s.\n",
+				ioc->name, ioc->alt_ioc->name);
+		}
+	}
 
 	if (retval < 0)
 		status = FAILED;
