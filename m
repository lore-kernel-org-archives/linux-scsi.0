From: Ewan Milne <emilne@redhat.com>
Subject: Re: qla2xxx: automatically rescan removed luns.
Date: Mon, 25 Nov 2013 12:17:03 -0500
Message-ID: <1385399823.3839.116.camel@localhost.localdomain>
References: <52936EB4.4090508@mpstor.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3KYRRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Nov 2013 12:17:09 -0500
In-Reply-To: <52936EB4.4090508@mpstor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-11-25 at 15:37 +0000, Benjamin ESTRABAUD wrote:
> Hi,
> 
> Using the qla2xxx driver from Linux 3.10.1 (release), if a LUN from the 
> target side (multiple drives exported over a LIO IBlock qla2xxx export) 
> is removed at the LIO level, the initiator side will not automatically 
> detect that this LUN was removed.
> 
> All commands to this LUN will fail (sg_inq, read, writes) but the 
> qla2xxx will never kick the drive out.
> 
> If another drive was to be exported on the target side using the same 
> lun as the previously removed drive, commands sent to the same block id 
> would now work again but be sent to the new LUN.
> 
> I tried to echo "- - -" in the scsi_host sysfs "scan" file corresponding 
> to the FC port. This worked to detect new LUNs but not to "clear" 
> removed ones.
> 
> I tried issuing a lip_reset on both sides, but no change.
> 
> Looking through Google, I realized that, on RedHat, a /proc/scsi/qla2xxx 
> virtual FS exists which allows to send a "scsi-qlascan" command to the 
> driver that apparently can detect removed LUNs. Unfortunately I don't 
> have this FS visible on my Linux kernel, and I made sure /proc/scsi was 
> enabled.
> 
> The only way I found was to "echo 1 > /sys/block/sdX/device/delete" to 
> the stale device (that corresponds to the removed LUN from the target 
> side), then replace the removed LUN on the target side before finally 
> issuing a "scan" command on the initiator side.
> 
> Am I missing something here? Is there a way to rescan a Qlogic FC port 
> using the "qla2xxx" driver from the official, stock kernel?

The kernel does not contain support for removing devices automatically
during a subsequent rescan.  You have to delete them individually.
You can, however, update the properties detected when scanning a device
(e.g. disk capacity) by scanning the individual device in sysfs.  For
SCSI devices, there is a "rescan" capability, e.g.

echo 1> /sys/devices/<pci device path>/host0/target0:0:0/0:0:0:0/rescan

*Very* recent kernels contain a udev notification mechanism when a SCSI
device reports a Unit Attention, so you can have udev rules like:

ACTION=="change", SUBSYSTEM=="scsi", \
ENV{SDEV_UA}=="INQUIRY_DATA_HAS_CHANGED", TEST=="rescan", \
ATTR{rescan}="x"

ACTION=="change", SUBSYSTEM=="scsi", \
ENV{SDEV_UA}=="CAPACITY_DATA_HAS_CHANGED", TEST=="rescan", \
ATTR{rescan}="x"

ACTION=="change", SUBSYSTEM=="scsi", \
ENV{SDEV_UA}=="THIN_PROVISIONING_SOFT_THRESHOLD_REACHED", \
TEST=="rescan", ATTR{rescan}="x"

ACTION=="change", SUBSYSTEM=="scsi", \
ENV{SDEV_UA}=="MODE_PARAMETERS_CHANGED", TEST=="rescan", \
ATTR{rescan}="x"

ACTION=="change", SUBSYSTEM=="scsi", \
ENV{SDEV_UA}=="REPORTED_LUNS_DATA_HAS_CHANGED", \
RUN+="<script to scan devices> $env{DEVPATH}"

...

A script to scan devices can use the devpath of the SCSI device
reporting the Unit Attention to perform the desired action.  If you
just want to scan the target port, something like this might work,
although it is a little clumsy...

#!/bin/sh -e

HOST_PATH1=`echo $1 | awk '{print substr($1,0,index($1,"/target")-1)}'`
HOST_PATH2="scsi_host/host"`echo $1 | awk
'{split(substr($1,index($1,"target")),a,"/"); split(a[2],b,":"); print
b[1]}'`"/scan"

SCAN_STRING=`echo $1 | awk '{split(substr($1,index($1,"target")),a,"/");
split(a[2],b,":"); print b[2],b[3],"-"}'`

echo $SCAN_STRING > "/sys/"$HOST_PATH1"/"$HOST_PATH2

Or, "rescan-scsi-bus.sh" from (I think) sg3_utils might do what you
want.  Beware of running shell scripts from udev rules, however, as
that doesn't scale well in large configurations.

-Ewan


> 
> Thank you very much in advance for your help!
> 
> Regards,
> 
> Ben - MPSTOR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


