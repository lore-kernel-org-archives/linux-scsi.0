From: Douglas Gilbert <dougg@torque.net>
Subject: lk 2.5.49 module frustration
Date: Sat, 23 Nov 2002 14:14:42 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DDEF2A2.8050701@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-78.triode.net.au [202.147.125.78])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gAN3EWA04484
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2002 14:14:33 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hopefully others are having more success with the new
module loader than I am. My system is basically RH8.0
with the new module-init-tools (version 0.7) loaded
and the recent 2.5.49 kernel.

During system load there is noise (failure?) on calls
to modprobe since the new command doesn't support the same
switches as the old. [harmless?]

My lsmod looks like this:
# lsmod
Module                  Size  Used by
scsi_debug             29423  0 [unsafe]
ohci1394               21561  0
ieee1394               41773  1 ohci1394 [unsafe]
parport_pc             18883  0 [unsafe]
parport                30228  1 parport_pc [unsafe]
ehci_hcd               32801  0
usbcore                90237  3 ehci_hcd

Those "unsafe" dependencies wedge in a module, making
it hard to remove them. In the case of scsi_debug about
30 seconds after it is loaded I get this on my console:
# Module scsi_debug cannot be unloaded due to unsafe
# usage in fs/proc/inode.c:204
That is procfs calling __MOD_INC_USE_COUNT. Is that our
problem (i.e. shouldn't RR fix that before he lets this
stuff loose on us)?

Are all the MODULE_* macros now dead? I can no longer
get any load time options/parameters through to the
scsi_debug. Nothing useful comes out of modinfo.

Where is the ..... documentation?
$ ls -l modules.txt
-rw-r--r--    1 1046     101          9441 Feb 17  2001 modules.txt

Doug Gilbert



