From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15623] New: doesn't allow SMART-passthrough on Adaptec Series 5
 controller
Date: Wed, 24 Mar 2010 16:38:36 GMT
Message-ID: <bug-15623-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53633 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0CXQii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2010 12:38:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2OGcb0L009055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:38:37 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15623

           Summary: doesn't allow SMART-passthrough on Adaptec Series 5
                    controller
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: lkolbe@techfak.uni-bielefeld.de
                CC: sfrey@techfak.uni-bielefeld.de
        Regression: No


On Linux 2.6.33, wich includes aacraid version 24702 (that's at least what
Adaptec's arcconf tells me), we're unable to query the smart information (SATA
disks attached to an Adaptec 52445):

wash:~# smartctl -a -d sat /dev/sg5
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST31000340NS
Serial Number:    9QJ2XFQP
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Wed Mar 24 16:33:07 2010 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

SMART Disabled. Use option -s with argument 'on' to enable it.

If I try with '-s on' I get:

wash:~# smartctl -a -d sat -s on /dev/sg5
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST31000340NS
Serial Number:    9QJ2XFQP
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Wed Mar 24 16:33:25 2010 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF ENABLE/DISABLE COMMANDS SECTION ===
SMART Enabled.
SMART Disabled. Use option -s with argument 'on' to enable it.

dmesg says:

[77323.301112] scsi 0:1:2:0: [sg5] Sense Key : Recovered Error [current]
[descriptor]
[77323.301120] Descriptor sense data with sense descriptors (in hex):
[77323.301122]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[77323.301130]         00 4f 00 c2 40 50 
[77323.301134] scsi 0:1:2:0: [sg5] Add. Sense: ATA pass through information
available
[77335.412005] scsi 0:1:2:0: [sg5] Sense Key : Recovered Error [current]
[descriptor]
[77335.412012] Descriptor sense data with sense descriptors (in hex):
[77335.412014]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[77335.412022]         00 4f 00 c2 40 50 
[77335.412026] scsi 0:1:2:0: [sg5] Add. Sense: ATA pass through information
available
[77353.712031] scsi 0:1:2:0: [sg5] Sense Key : Recovered Error [current]
[descriptor]
[77353.712044] Descriptor sense data with sense descriptors (in hex):
[77353.712046]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[77353.712052]         00 4f 00 c2 40 50 
[77353.712055] scsi 0:1:2:0: [sg5] Add. Sense: ATA pass through information
available

On 2.6.32, we can use the aacraid driver from adaptec (version 24900) and
smartmontools work as expected, but with 2.6.33 their version doesn't compile
anymore.

We really don't want to run their 'enterprise' storage manager software on our
servers to warn us about bad blocks, but as long as we're unable to use
smartctl for this we're quite out of luck :/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
