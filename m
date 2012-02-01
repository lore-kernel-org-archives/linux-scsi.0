From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi 0.26 beta 2, add --wwn
Date: Wed, 01 Feb 2012 11:32:57 -0500
Message-ID: <4F296939.9040806@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41237 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2BAQdH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2012 11:33:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id A4D192041B6
	for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2012 17:33:00 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sLQPL9yYINLQ for <linux-scsi@vger.kernel.org>;
	Wed,  1 Feb 2012 17:32:59 +0100 (CET)
Received: from [192.168.48.66] (unknown [216.99.49.31])
	by smtp.infotech.no (Postfix) with ESMTPA id CBA0D2041B5
	for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2012 17:32:58 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

lsscsi currently can provide some transport related
WWN information when the --transport (-t) option
is used. This will probably be a target port name rather
than a LU name.
Fetching the LU name has proven elusive. The most direct
way would be to issue an INQUIRY to get the device
identification VPD page but that would require root
permissions. A feature of lsscsi is that it doesn't need
root permissions (or related tricks).

This beta adds a --wwn (-w) option which searches the udev
provided /dev/disk/by-id/wwn-* symlinks. This will find
WWNs (LU names) for disks if udev can find them.

If there is no averse feedback version 0.26 will be released
in a few weeks.


There are two SATA disks in the example below: /dev/sda and
/dev/sdd . /dev/sda has no WWN and is directly connected to
a SATA controller on the motherboard. /dev/sdd has a WNN and
is connected via a SAS expander.

# lsscsi
[1:0:0:0]    disk    ATA      ST3320620AS      3.AA  /dev/sda
[6:0:0:0]    enclosu Intel    RES2SV240        0600  -
[6:0:1:0]    disk    SEAGATE  ST33000650SS     0002  /dev/sdb
[6:0:2:0]    disk    SEAGATE  ST32000444SS     0006  /dev/sdc
[6:0:3:0]    disk    ATA      ST3500418AS      CC34  /dev/sdd

# lsscsi -w
[1:0:0:0]    disk                                    /dev/sda
[6:0:0:0]    enclosu                                 -
[6:0:1:0]    disk    0x5000c50033fe58db              /dev/sdb
[6:0:2:0]    disk    0x5000c500215725bf              /dev/sdc
[6:0:3:0]    disk    0x5000c500120bfe84              /dev/sdd

# lsscsi -t
[1:0:0:0]    disk    sata:                           /dev/sda
[6:0:0:0]    enclosu sas:0x5001517e85c3effd          -
[6:0:1:0]    disk    sas:0x5000c50033fe58d9          /dev/sdb
[6:0:2:0]    disk    sas:0x5000c500215725bd          /dev/sdc
[6:0:3:0]    disk    sas:0x5001517e85c3efe2          /dev/sdd


Version 0.26 beta 2 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for the tarball:
   http://sg.danny.cz/scsi/lsscsi-0.26b2.tgz
There are no debian or redhat packages built for this beta.

Version 0.26 2012/01/31 [svn: r97]
   - add 'fcoe' transport indicator
   - add '--wwn' option, datamine /dev/disk/by-id/wwn*
   - move lsscsi.c into src directory

Version 0.25 2011/05/09 [svn: r92]
...

Doug Gilbert
