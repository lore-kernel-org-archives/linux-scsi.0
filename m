From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 16:42:54 +0200
Message-ID: <42D133EE.9090204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43188 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261950AbVGJOnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 10:43:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: Ben Collins <bcollins@debian.org>

Hi all,

it seems the sbp2 driver module can never be unloaded because the
module "is in use" even though all SBP-2 devices were physically removed
(after umount etc.). I believe it is an old problem of the last few 2.6
kernels but am not sure when it was really introduced.

One thing can easily be spotted by "ps x": The scsi_error_handler of an
SBP-2 device does not exit. The /sys/bus/scsi/devices/$a:$b:$c:$d 
vanished, the /sys/bus/ieee1394/devices/$guid-$unit too, but the 
scsi_eh_# daemon is still there. It seems shost->shost_gendev.release 
was never called.

So I just added a few more scsi_host_put() to sbp2_remove_device(). 
scsi_eh_# now goes away when I disconnect the device. Still, modprobe -r 
sbp2 fails with "FATAL: Module sbp2 is in use.".
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/

