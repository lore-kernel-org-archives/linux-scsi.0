From: scameron@beardog.cce.hp.com
Subject: 16 commands per lun limitation bug?
Date: Wed, 10 Feb 2010 14:19:16 -0600
Message-ID: <20100210201916.GK11649@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:25128 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0BJUQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 15:16:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mike.miller@hp.com, james.bottomley@hansenpartnership.com, scameron@beardog.cce.hp.com


We have seen the amount of commands per lun that are sent to 
low level scsi driver limited to 16 commands per lun,
(seemingly artificially, well below our can_queue and
cmd_per_lun limits of 1020)

2.6.29 does not exhibit this bad behavior.
2.6.30, 2.6.31, 2.6.32 (2.6.32.1 through 2.6.32.8) do exhibit this bad behavior
2.6.31-rc1 does not exhibit this bad behavior

Testing was done with fio with this config file:

[global]
description=4096 byte random reads - ${CONFIG}
readwrite=randread
blocksize=4K
ioengine=libaio
softrandommap=1
direct=1
runtime=2000
time_based
#ramp_time=10
thread
filename=/dev/sdb

[iodepth=128]
stonewall
iodepth=128

When the problem is present, we only see 16 commands per lun, when
not present, we see 128 commands per lun.

Anybody else seen this problem?  Anybody know what caused the
brokeness between 2.6.29 and 2.6.30, or what fixed this between
2.6.32 and 2.6.33-rc1?

Hard for me to do a git bisect as the only hardware I have capable
of exercising the test case is Smart Array, and hpsa didn't go in
until 2.6.33-rc1.   Would like to know if other hardware/drivers
encounter this problem as well.

-- steve 


