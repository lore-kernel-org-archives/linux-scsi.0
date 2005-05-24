From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH RFC 1/2] add transport scan callout to fix sysfs layout when scanning from userspace
Date: Tue, 24 May 2005 16:01:43 -0700
Message-ID: <20050524230143.GA6407@us.ibm.com>
References: <1116711431.6285.28.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:57282 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262154AbVEXXDK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 19:03:10 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j4ON37mD726458
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 19:03:07 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4ON36GO116210
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 17:03:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j4ON35W0013649
	for <linux-scsi@vger.kernel.org>; Tue, 24 May 2005 17:03:06 -0600
Content-Disposition: inline
In-Reply-To: <1116711431.6285.28.camel@mina>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <James.Smart@Emulex.Com>

[dropped iscsi list ...]

On Sat, May 21, 2005 at 02:37:11PM -0700, Mike Christie wrote:
> When scanning hosts that implement FC rport support and
> open-iscsi/linux-iscsi-5 hosts from userspace the sysfs
> layout will end up placing the target's parent as the host
> instead of some transport specific object. For FC the
> target's parent should be the rport and for open-iscsi the
> parent should be a session (that is if for open-iscsi our
> using struct devices and our sysfs layout is correct).

I was trying FC to see if it caused problems, instead of a different
layout, no devices are found at all :-(

Getting more info from Mike C, and looking at the code, I expected the
scan to work OK, but for the targets to to show up directly under the
host, rather than under the rport.

modprobe qla2300 finds sd's as expected (sdg -> sdz), then I remove them
all via delete attribute, and then scan via /sys/class/scsi_host/host2/scan,
and nothing shows up.

With scsi command and scan logging on (0x2400 | 0x01c0), there were no
commands sent, just:

elm3b79:~# scsi_scan_host_selected: <2:4294967295:4294967295:4294967295>

Reloading the qla2300, the devices show up fine again.

I am running plain linux-2.6.12-rc4.

Others with FC storage might want to try this out ...

elm3b79:/sys/bus/scsi/devices# ls
0:0:0:0  0:0:4:0   2:0:12:0  2:0:16:0  2:0:1:0  2:0:5:0  2:0:9:0
0:0:1:0  0:0:5:0   2:0:13:0  2:0:17:0  2:0:2:0  2:0:6:0
0:0:2:0  2:0:10:0  2:0:14:0  2:0:18:0  2:0:3:0  2:0:7:0
0:0:3:0  2:0:11:0  2:0:15:0  2:0:19:0  2:0:4:0  2:0:8:0
elm3b79:/sys/bus/scsi/devices# for x in 2\:0\:*/delete
> do
> echo x > ${x}
> done

elm3b79:/sys/bus/scsi/devices# echo "- - -"  > /sys/class/scsi_host/host2/scan

elm3b79:~# modprobe -r qla2300
elm3b79:~# modprobe qla2300
elm3b79:~# ls /sys/bus/scsi/devices
0:0:0:0  0:0:4:0   3:0:11:0  3:0:15:0  3:0:19:0  3:0:4:0  3:0:8:0
0:0:1:0  0:0:5:0   3:0:12:0  3:0:16:0  3:0:1:0   3:0:5:0  3:0:9:0
0:0:2:0  3:0:0:0   3:0:13:0  3:0:17:0  3:0:2:0   3:0:6:0
0:0:3:0  3:0:10:0  3:0:14:0  3:0:18:0  3:0:3:0   3:0:7:0

-- Patrick Mansfield
