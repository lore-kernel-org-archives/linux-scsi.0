From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 0/2] Introduce the parameter to limit scsi timeout count
 (take 2)
Date: Fri, 19 Jun 2009 18:38:46 -0400
Message-ID: <4A3C1376.4080305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760774AbZFSWgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 18:36:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Hi,

This is the updated patch to limit scsi timeout count.

  [RFC][PATCH] Introduce the parameter to limit scsi timeout count
  http://marc.info/?l=linux-scsi&m=124388354119073&w=2


BACKGROUND
==========

A storage can break down in the way that it does not respond to scsi
commands such as read/write, while a storage successfully respond to
scsi commands such as test unit ready.
(It may depend on implementation of storage.)

When this type of a device trouble happens, the scsi-mid layer detects
timeout for the device, and scsi-mid layer tries to recover the error.
Then, scsi-mid layer detects that the device has been recovered by
the result of Test Unit Ready.

Therefore, the state of the device is not changed to offline and user
application can continue to issue I/Os to the device. This may cause
timeout errors repeatedly on the same device, and application can not
do proper actions quickly.

In addition, this issue seriously affects system boot time. During
device scanning in scsi-mid layer, read I/Os are issued to recognized
devices to get their partition table in check_partition(). Usually,
many types of filesystems are registered, and partition check is
executed for every filesystems. This is a very long process because
every read I/O ends up by timeout.

Moreover, scsi device scan is sequentially done, and other devices
wait to be scanned. In some Linux distributions, boot processes go
forward before valid devices are recognised, and system can not start
correctly even if devices are fully redundant by mirroring.


SOLUTIONS
=========

Introduce the parameter to limit the maximum number of timeout count
in scsi-mid layer. When the number of timeout count of a device
reaches the maximum timeout count, the device is offlined.
This parameter is configurable by sysfs.

In addition, to address the issue at kernel boot, a scsi module
parameter, initparam, is added to set default values, timeout
value and maximum timeout count. These values can be defined for
devices identified by vender/model as scsi devinfo does.


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


I appreciate your comments and suggestions.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.




