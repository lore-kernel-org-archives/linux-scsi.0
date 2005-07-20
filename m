From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.15 released
Date: Wed, 20 Jul 2005 18:33:15 +1000
Message-ID: <42DE0C4B.9000403@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:457 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261443AbVGTIdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 04:33:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nate.Dailey@stratus.com

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about all SCSI devices and SCSI hosts. Both a
compact format (default) which is one line
per device and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported. Some examples:

$ lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
[1:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

$ lsscsi --classic
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02

Version 0.15 is available at
http://www.torque.net/scsi/lsscsi.html

This is an experimental version that attempts to find the device
name used in the /dev directory rather than the kernel generated
name. The kernel generated name of the first SCSI disk discovered
is /dev/sda . However in the lk 2.6 series kernels udev may be
used to give this device some other name in the /dev directory,
for example /dev/root_disk . By default this version will search
for the device node name in the /dev directory whose type (i.e.
block or char), major and minor numbers match the kernel device
information found in sysfs. This change makes a SCSI (or USB,
Firewire, etc) CD/DVD drive appear with a name like /dev/scd0
(as most distributions now use) rather than its kernel device
node name of sr0 used by sysfs. There are other ways this could be
done which would be more efficient in CPU usage, for example by
lsscsi using the udevinfo facilities internally. This version of
lsscsi can be given a '--kname' option to show the kernel
(i.e. sysfs) device node name instead. Note that sysfs and SCSI
errors and warning sent to the system log continue to use the
kernel device node name.

By default lsscsi lists all SCSI devices (or hosts). This version
allows select arguments to reduce the number of devices listed.
For example "lsscsi 1" will list all channels, targets and luns
within host1. A single SCSI device can be listed with
'lsscsi 1 0 0 0' (or 'lsscsi 1:0:0:0' or 'lsscsi [1:0:0:0]'). See
man page for more information. This version of lsscsi uses the
facilities of the scandir() library call to both select (filter)
and sort the SCSI devices (or hosts) it finds in sysfs. Since
libsysfs (version 1.2) doesn't have the ability to filter then
this version of lsscsi uses scandir() [and not libsysfs]. Evidently
a new version 2.0 API for libsysfs is under development (and I
have requested a scandir() like select+sort facility).

Extra SCSI device and host attributes (as found in lk 2.6.12) can
be seen by using the '--long' option twice (or more conveniently
using '-ll'). Attributes are listed as "<name>=<value>" pairs, one
per line (indented two spaces) when the '-lll' option is given.


ChangeLog:
Version 0.15 2005/6/29
   - option '-ll' gives more attributes and '-lll' gives attributes
     one per line
   - change reporting if device node:
     - use "match major+minor" with "/dev" directory (default)
     - use synthetic device node names when '--kname' given
       {this was the default in earlier versions}
   - add filtering, sync with lk 2.6.12
     {e.g. 'lsscsi 1' lists all SCSI devices on host1}
   - convert to autotools
   - builds on version 0.13 (does not use libsysfs)
     {because dlist_sort_custom() does not have filter() callback}

Thanks to Nate Dailey for the /dev scanning code.

Comments welcome.

Doug Gilbert
