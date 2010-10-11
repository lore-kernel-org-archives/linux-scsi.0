From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20112] New: dmesg spam: "scsi host5: __pm_runtime_resume()
 returns 1" (DVD writer)
Date: Mon, 11 Oct 2010 21:21:02 GMT
Message-ID: <bug-20112-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50897 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab0JKVVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2010 17:21:03 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9BLL2iV013298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 21:21:02 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20112

           Summary: dmesg spam: "scsi host5: __pm_runtime_resume() returns
                    1" (DVD writer)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: Linux version 2.6.36-rc7-blueyed-00145-g50c6dc9
                    (root@base) (gcc version 4.4.5 (Ubuntu/Linaro
                    4.4.4-14ubuntu5) ) #2 SMP PREEMPT Mon Oct 11 21:53:45
                    CEST 2010
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: linux-bugs@thequod.de
        Regression: No


The system log gets spammed via dmesg with several of the following errors per
second:

Oct 11 22:53:39 base kernel: [ 2147.766956] scsi host5: __pm_runtime_resume()!
Oct 11 22:53:39 base kernel: [ 2147.766962] scsi host5: __pm_runtime_resume()
returns 1!

Apparently this refers to my DVD drive, according to the /proc files:

>From /proc/scsi/scsi:
Host: scsi5 Channel: 00 Id: 01 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-4163B Rev: A100
  Type:   CD-ROM                           ANSI  SCSI revision: 05

% cat /proc/scsi/sg/devices 
[...]
5       0       1       0       5       1       1       0       1

% cat /proc/scsi/sg/device_strs 
[...]
HL-DT-ST        DVDRAM GSA-4163B        A100

This might be caused by CONFIG_PM_DEBUG=y, and might actually be expected.
In this case, please excuse this report then - but consider making it less
verbose.

My /proc/config.gz unzipped: http://pastebin.com/knXt8nmw
lspci -vvv: http://pastebin.com/iMWbaUPC

Might this be related to the writer failing to detect rewritable media? (which
might be a regression I still would have to investigate deeper into)

(This might be related to https://bugzilla.kernel.org/show_bug.cgi?id=19712 -
where only a "__pm_runtime_resume()!" is posted repeatedly.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
