From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH 0/2] Introduce the parameter to limit scsi timeout count (take
 3)
Date: Thu, 16 Jul 2009 16:45:08 -0400
Message-ID: <4A5F9154.9010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbZGPUpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 16:45:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Hi,

This is the updated patch to limit the scsi timeout count for
the scsi-rc-fixes-2.6.


BACKGROUND
==========

A storage could break down in the way that a Logical Unit (LU) does
not respond to scsi commands such as read/write, while the LU respond
to scsi commands such as test unit ready (TUR).

I think that it is an ideal behavior that a storage returns an error
for both TUR and R/W to the LU related to a failed disk unit so that
OS can notice the failure of the LU. However, TUR and R/W are processed
by different components in the storage. TUR is processed by a storage
controller, and R/W is processed by a disk unit. When a disk unit takes
time to process R/W, this type of error could happen in reality.

When this problem happens, the scsi-mid layer detects timeout for the
LU. Then, scsi-mid layer tries to recover the error, and scsi-mid layer
misunderstands that the LU has been recovered by the result of TUR.
Therefore, the state of the device related to the LU is not changed to
offline and user application can continue to issue I/Os to the LU.
This may cause timeout errors repeatedly on the same LU, and application
can not do proper actions quickly.

In addition, this issue seriously affects system boot time. During
LU scanning in scsi-mid layer, read I/Os are issued to recognized LUs
to get their partition table in check_partition(). Usually, many types
of filesystems are registered to the kernel, and partition check is
executed for each filesystem. This is a very long process because every
read I/O ends up scsi timeout.

Moreover, scsi device scan is sequentially done, and other devices wait
to be scanned. In some Linux distributions, boot processes go forward
before valid devices are recognized, and system can not start correctly
even if devices are fully redundant using mirroring.


SOLUTIONS
=========

Introduce the parameter to limit the maximum number of timeout count
in scsi-mid layer. When the number of timeout count of a device reaches
the maximum timeout count, the device is offlined. This parameter is
configurable through sysfs.

In addition, to address the issue at kernel boot, a scsi module
parameter, initparm, is added to set default values, timeout value
and maximum timeout count. These values can be defined for devices
identified by vender/model as scsi devinfo does.


PATCH SET
=========

  1/2: Limit scsi timeout count per device
  2/2: Interface to set default timeout related values


EXAMPLE
=======

 * Limit a scsi timout count to 1
    # echo 1 > /sys/block/<sdX>/device/max_timeout_cnt
    # cat  /sys/block/<sdX>/device/max_timeout_cnt
    1

 * Display a current timeout count
    # cat /sys/block/<sdX>/device/iotimeout_cnt
    0

 * Load scsi module with a default scsi timeout(10s) and
   maximum timeout count (1) for HITACHI/DF600.
    # insmod scsi_mod.ko initparm="HITACHI:DF600:10:1"

 * Show current default configurations.
    # cat /proc/scsi/initparm
    'HITACHI' 'DF600' timeout=10 max_timeout_cnt=1


PREVIOUS POSTS
==============

  Introduce the parameter to limit scsi timeout count
  http://www.spinics.net/lists/linux-scsi/msg36406.html 

  Introduce the parameter to limit scsi timeout count (take2)
  http://www.spinics.net/lists/linux-scsi/msg36954.html 


I appreciate your comments and suggestions.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.





