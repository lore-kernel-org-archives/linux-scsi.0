From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] scsi_error.c : reservation conflict after timeout causes
 device to be taken offline
Date: Mon, 10 Aug 2009 11:59:28 -0500
Message-ID: <4A8051F0.1010300@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:60504 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932288AbZHJQ76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 12:59:58 -0400
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23DB98F804C
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2009 09:59:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Kevan Rehm <kfr@sgi.com>

An IBM tape drive failed to complete a PERSISTENT RESERVE IN within the scsi cmd
timeout.  Error recovery was initiated and it sequenced from abort through taking
the tape drive offline.

The device was taken offline because it repeatedly responded to the TUR command
issued by error recovery with a RESERVATION CONFLICT status.  The tape drive
was reserved to another system.  This is perfectly legitimate response to TUR,
and is one that an escalation of recovery is unlikely to clear.  Further,
escalation of recovery can have undesirable side effects on the operation of
tape drives shared with other initiators.

Instead of escalating recovery, error recovery should treat the RESERVATION
CONFLICT response to the TUR as a good status, giving the issuer of the
command the opportunity to handle the timeout and reservation conflict.

Signed-off-by: Michael reed <mdr@sgi.com>

--


--- linux-2.6.30.4/drivers/scsi/scsi_error.c	2009-07-30 17:34:47.000000000 -0500
+++ linux-2.6.30.4-modified/drivers/scsi/scsi_error.c	2009-08-10 10:29:41.138433154 -0500
@@ -382,9 +382,13 @@ static int scsi_eh_completed_normally(st
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
+	case RESERVATION_CONFLICT:
+		/*
+		 * let issuer deal with this, it could be just fine
+		 */
+		return SUCCESS;
 	case BUSY:
 	case QUEUE_FULL:
-	case RESERVATION_CONFLICT:
 	default:
 		return FAILED;
 	}

