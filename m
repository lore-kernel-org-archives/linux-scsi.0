From: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Subject: [PATCH] 2.4.21-pre3 scsi_scan.c memory leak.
Date: Fri, 17 Jan 2003 11:58:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1216290000.1042829927@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h0HIwsj03171
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2003 10:58:54 -0800 (PST)
Received: from btc.btc.adaptec.com (btc.btc.adaptec.com [10.100.0.52])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA07780
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2003 10:58:49 -0800 (PST)
Received: from [10.100.253.70] (aslan [10.100.253.70])
	by btc.btc.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id LAA19110
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2003 11:58:46 -0700 (MST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

I found this while doing a longevity load/unload test of the aic79xx
driver.  I can't say if this is the only memory leak in the unload
process, but its at least one of them.  This only cleans up properly
in the common cases of failure in scan_scsis_single().  The whole
routines a bit of a mess....

--
Justin


--- scsi_scan.c	2003-01-17 11:53:07.000000000 -0700
+++ scsi_scan.c.mine	2003-01-17 11:53:03.000000000 -0700
@@ -596,6 +596,7 @@
 		} else {
 			/* assume no peripheral if any other sort of error */
 			scsi_release_request(SRpnt);
+			scsi_release_commandblocks(SDpnt);
 			return 0;
 		}
 	}
@@ -619,6 +620,7 @@
 	 */
 	if ((scsi_result[0] >> 5) == 3) {
 		scsi_release_request(SRpnt);
+		scsi_release_commandblocks(SDpnt);
 		return 0;	/* assume no peripheral if any sort of error */
 	}
 	 /*   The Toshiba ROM was "gender-changed" here as an inline hack.

