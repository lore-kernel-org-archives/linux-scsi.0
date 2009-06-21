From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] New: SMART responses for SATA disks on SAS get
 interpreted as errors
Date: Sun, 21 Jun 2009 17:26:29 GMT
Message-ID: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36341 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZFUR00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 13:26:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5LHQThU028527
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2009 17:26:29 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13594

           Summary: SMART responses for SATA disks on SAS get interpret=
ed
                    as errors
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.30-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: sgunderson@bigfoot.com
        Regression: No


Hi,

I just bought a LSI SAS3081E-R which I use against a Supermicro backpla=
ne to
drive ten Seagate SATA disks (7200.11, 750GB and 1.5GB). I'm using the
standard Linux Fusion MPT device driver (CONFIG_FUSION_SAS) under Linux
2.6.30-rc6. Everything seems to work pretty well, with one exception: W=
hen I
use SMART against the drives (say, smartctl -a /dev/sda) the kernel com=
plains
with:

  [  811.091916] sd 0:0:0:0: [sda] Sense Key : Recovered Error [current=
]
[descriptor]
  [  811.099807] Descriptor sense data with sense descriptors (in hex):
  [  811.106175]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 0=
0
  [  811.113262]         00 4f 00 c2 00 50
  [  811.117379] sd 0:0:0:0: [sda] Add. Sense: ATA pass through informa=
tion
available

I've tried upgrading to the newest firmware (1.28.02.00, 05-MAY-2009), =
but
all that changed is that the hex dump was added to the error message.

Whenever this happens, it appears like all the disks =E2=80=9Chiccup=E2=
=80=9D and the kernel
loses contact with the controller for a small while. If too many of the=
se
happen at once, eventually disks start falling off RAIDs, and the entir=
e
machine goes down. It looks to me as if these messages should simply no=
t be
treated as errors by the kernel -- smartctl explicitly asks for a respo=
nse even
if the command doesn't fail (by setting CK_COND), so the response proba=
bly
shouldn't be taken as an error.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
