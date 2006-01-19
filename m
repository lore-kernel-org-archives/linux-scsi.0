From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5755] New: 16 byte CDBs not enabled in Adaptec
 SCSI HBA drivers
Date: Thu, 19 Jan 2006 03:46:01 -0800
Message-ID: <20060119034601.74725784.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55726 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161191AbWASLqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 06:46:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Fri, 16 Dec 2005 14:50:39 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5755] New: 16 byte CDBs not enabled in Adaptec SCSI HBA drivers


http://bugzilla.kernel.org/show_bug.cgi?id=5755

           Summary: 16 byte CDBs not enabled in Adaptec SCSI HBA drivers
    Kernel Version: 2.6.12
            Status: NEW
          Severity: low
             Owner: andmike@us.ibm.com
         Submitter: brianr01@yahoo.com


Problem Description:

The Adaptec aic7xxx / aic79xx HBA drivers use the default max_cmd_len of 12,
when in fact the hardware supports 16 byte CDBs. This can be corrected by adding
the line:

host->max_cmd_len = 16;

soon after the call to scsi_host_alloc() in aic7xxx_osm.c and aic79xx_osm.c. I
have confirmed that this change functions correctly. 

This feature is important because Quantum's latest drives (SDLT600, DLT-S4 and
DLT-V4) use the 16 byte commands 8C (Read Attributes) and 8D (Write Attributes)
to implement their WORM functionality. In order to support this feature on Linux
platforms 16 byte CDBs must be enabled in the individual HBA driver.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
