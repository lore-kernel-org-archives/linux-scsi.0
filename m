From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - why mid-layer does not scan LUNs?
Date: Fri, 18 Jun 2004 16:10:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF039@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:8215 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264500AbUFRVKY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 17:10:24 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Can some one please tell me why mid-layer doesn't scan LUNs but just Buses and Targets in lk 2.4?  

The default max_channel, max_id and max_lun defined in mid-layer are 0, 8 and 8 respectively.  I use scsi_debug low-level driver to check which B:T:L mid-layer scans, but find it only scans 0:0:0, 0:1:0, 0:2:0...  Why it doesn't scan 0:0:1, 0:0:2...?

I have taken out:

	if ((target > driver_template.this_id) || (SCpnt->lun != 0))
		return schedule_resp(SCpnt, NULL, done, DID_NO_CONNECT << 16, 0);

from scsi_debug_queuecommand(...) of scsi_debug driver, but mid-layer still does not scan LUNs.

I would appreciate it if some one could tell me what I missed.

Thanks,


Lee

