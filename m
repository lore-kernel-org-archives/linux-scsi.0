From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30062] New: Huge amounts of "HDIO_GET_IDENTITY failed for
 /dev/sr0" messages during boot
Date: Mon, 28 Feb 2011 10:52:28 GMT
Message-ID: <bug-30062-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:34163 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1B1Kw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 05:52:29 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1SAqSPj002145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2011 10:52:29 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=30062

           Summary: Huge amounts of "HDIO_GET_IDENTITY failed for
                    /dev/sr0" messages during boot
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.38-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: monoped@sudrala.de
        Regression: Yes


My system (Crux 2.7) contains an older SCSI disk, and a SCSI CD writer
(Plextor). When booting into 2.6.38, I get an endless sequence of errors like

    ata_id[xyz]: HDIO_GET_IDENTITY failed for '/dev/sr0'

The errors start when the command

    udevadm trigger --type=devices --action=add

is executed. There are also about 50 udevd processes in the process list. The
system gets extremely slow, and the only way to make it usable again is by
saying 'killall udevd'. Apparently udev has an issue with the CD writer (while
it handles the harddisk correctly).

The same system works well with kernel 2.6.37.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
