From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: underflow field
Date: Thu, 30 Jan 2003 16:45:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <43220000.1043970348@aslan.btc.adaptec.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h0UNk0D17597
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2003 15:46:00 -0800 (PST)
Received: from btc.btc.adaptec.com (btc.btc.adaptec.com [10.100.0.52])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id PAA15630
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2003 15:45:49 -0800 (PST)
Received: from [10.100.253.70] (aslan [10.100.253.70])
	by btc.btc.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id QAA26500
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2003 16:45:47 -0700 (MST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I received a recent report of the aic7xxx driver reporting:

(scsi0:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi0:A:0:0): Saw underflow (80 of 96 bytes). Treated as error

This is because the aic7xxx driver (and the aic79xx driver) honors
the underflow field.  Has this field been deprecated and thus should
be ignored by HBA drivers?  If not, why is it that scsi_scan.c doesn't
set underflow to 0 (or maybe 1 in this case) for commands that can have
variable length responses?  The above is a fetch of the serial number
from VPD page 0x80.

--
Justin

