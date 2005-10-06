From: Douglas Gilbert <dougg@torque.net>
Subject: scsi_debug: no_lun_0 and lun 49409
Date: Thu, 06 Oct 2005 18:22:04 +1000
Message-ID: <4344DEAC.4010908@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:49288 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750735AbVJFIVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 04:21:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, patmans@us.ibm.com

In the downloads section of:
http://www.torque.net/sg/sdebug26.html

is a beta version of scsi_debug version 1.77 .
It simulates a single port of a dual ported SAS disk
(with many of the VPD and mode page trimmings).

This beta adds an extra parameter: "no_lun_0" which
when set to one implements the code suggested by
Pat Mansfield in this post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112751597527556&w=2

It also goes into unchartered territory and implements
lun 49409 which is the REPORT LUNS well know logical unit.
Those folks out there that are paranoid about "specs"
will be glad (or perhaps disappointed) that it doesn't
break anything. Why do it? Well the spec says that a SCSI
target should either implement:
  - the phantom lun=0 technique, or
  - the REPORT LUNS well known lu
to facilitate lu discovery.

This with lk 2.6.14-rc3 :

# modprobe scsi_debug no_lun_0=1 max_luns=2
# modprobe sg
# cd /sys/class/scsi_host/host0
# echo "- - 49409" > scan
#
# lsscsi -g
[0:0:0:1]    disk    Linux    scsi_debug       0004  /dev/sda  /dev/sg0
[0:0:0:49409]wlun    Linux    scsi_debug       0004  -         /dev/sg1
#
# sg_luns --decode --select=2 /dev/sg1
Lun list length = 16 which imples 2 lun entries
Report luns [select_report=2]:
    0001000000000000
      Peripheral device addressing: lun=1
    c101000000000000
      REPORT LUNS well known logical unit

Notice that 0:0:0:0 is missing but a trace will show that
it did answer an INQUIRY and a REPORT LUNS.

The scsi_debug driver needs to set its Scsi_Host::max_luns
to 49409 so the "echo" above will work. Perhaps the scan
code could be a bit more open minded.

Doug Gilbert
