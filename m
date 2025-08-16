Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3526561D;
	Sat, 16 Aug 2025 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341592; cv=none; b=meg4Uv9OwmHjmVxUBhfjypyN60VW6FQHMzyVchflcjdhe9ZNRPXkQCZ+01D6bCkGbFWO5B5P6gbECyAZMeKI6Byhybzb10+edDEm+oNgHpwsroXfKpDt88rtkO031NnWgV/O2b9JFtowxrV/BHfSOuxt4dCrZkIHC+EcJYVqJJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341592; c=relaxed/simple;
	bh=edgDcX3RquBMgifGjTFNXYiKMCFfgIQcZgmluEDIf60=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kiMdds1zOGaqV3YIGhg+Hw32m+2tcpRguOPNrag1xZvyCG6p71swkSwCYQ0PZUZZVqNgrqd4d5u5FjgdRrIZvZovIq9Txhi8xdK9qjasd/Qk9YpSLzwnDkq1eVsnpUV3pDOlvDr4yKuSaoYhm6q13Ml/RVQ24mzqRiiXvwikAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wmw4KK2zvX6C;
	Sat, 16 Aug 2025 18:53:04 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 962FE180087;
	Sat, 16 Aug 2025 18:53:06 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:05 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 00/14] scsi: scsi_error: Introduce new error handle mechanism
Date: Sat, 16 Aug 2025 19:24:03 +0800
Message-ID: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

It's unbearable for systems with large scale scsi devices share HBAs to
block all devices' IOs when handle error commands, we need a new error
handle mechanism to address this issue.

I consulted about this issue a year ago, the discuss link can be found in
refenence. Hannes replied about why we have to block the SCSI host
then perform error recovery kindly. I think it's unnecessary to block
SCSI host for all drivers and can try a small level recovery(LUN based for
example) first to avoid block the SCSI host.

The new error handle mechanism introduced in this patchset has been
developed and tested with out self developed hardware since one year
ago, now we want this mechanism can be used by more drivers.

Drivers can decide if using the new error handle mechanism and how to
handle error commands when scsi_device are scanned,the new mechanism
makes SCSI error handle more flexible.

SCSI error recovery strategy after blocking host's IO is mainly
following steps:

- LUN reset
- Target reset
- Bus reset
- Host reset

Some drivers did not implement callbacks for host reset, it's unnecessary
to block host's IO for these drivers. For example, virtio_scsi only
registered device reset, if device reset failed, it's meaningless to
fallback to target reset, bus reset or host reset any more, because these
steps would also failed.

Here are some drivers we concerned:(there are too many kinds of drivers
to figure out, so here I just list some drivers I am familiar with)

+-------------+--------------+--------------+-----------+------------+
|  drivers    | device_reset | target_reset | bus_reset | host_reset |
+-------------+--------------+--------------+-----------+------------+
| mpt3sas     |     Y        |     Y        |    N      |    Y       |
+-------------+--------------+--------------+-----------+------------+
| smartpqi    |     Y        |     N        |    N      |    N       |
+-------------+--------------+--------------+-----------+------------+
| megaraidsas |     N        |     Y        |    N      |    Y       |
+-------------+--------------+--------------+-----------+------------+
| virtioscsi  |     Y        |     N        |    N      |    N       |
+-------------+--------------+--------------+-----------+------------+
| iscsi_tcp   |     Y        |     Y        |    N      |    N       |
+-------------+--------------+--------------+-----------+------------+
| hisisas     |     Y        |     Y        |    N      |    N       |
+-------------+--------------+--------------+-----------+------------+

For LUN based error handle, when scsi command is classified as error,
we would block the scsi device's IO and try to recover this scsi
device, if still can not recover all error commands, it might
fallback to target or host level recovery.

It's same for target based error handle, but target based error handle
would block the scsi target's IO then try to recover the error commands
of this target.

The first patch defines basic framework to support LUN/target based error
handle mechanism, three key operations are abstracted which are:
 - add error command
 - wake up error handle
 - block IOs when error command is added and recoverying.

The driver can implement these three function callbacks and set them in
the SCSI midlayer. I have added callbacks for setup/clear implementations:
 - setup/clear LUN based error handler
 - setup/clear target based error handler
As well as a generic implementation that the driver can directly reference. 

The changes of SCSI middle level's error handle are tested with scsi_debug
which support single LUN error injection, the scsi_debug patches can be
found in reference, following scenarios are tested.

Scenario1: LUN based error handle is enabled:
+-----------+---------+-------------------------------------------------------+
| lun reset | TUR     | Desired result                                        |
+ --------- + ------- + ------------------------------------------------------+
| success   | success | retry or finish with  EIO(may offline disk)           |
+ --------- + ------- + ------------------------------------------------------+
| success   | fail    | fallback to host  recovery, retry or finish with      |
|           |         | EIO(may offline disk)                                 |
+ --------- + ------- + ------------------------------------------------------+
| fail      | NA      | fallback to host  recovery, retry or finish with      |
|           |         | EIO(may offline disk)                                 |
+ --------- + ------- + ------------------------------------------------------+

Scenario2: target based error handle is enabled:
+-----------+---------+--------------+---------+------------------------------+
| lun reset | TUR     | target reset | TUR     | Desired result               |
+-----------+---------+--------------+---------+------------------------------+
| success   | success | NA           | NA      | retry or finish with         |
|           |         |              |         | EIO(may offline disk)        |
+-----------+---------+--------------+---------+------------------------------+
| success   | fail    | success      | success | retry or finish with         |
|           |         |              |         | EIO(may offline disk)        |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | success      | success | retry or finish with         |
|           |         |              |         | EIO(may offline disk)        |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | success      | fail    | fallback to host recovery,   |
|           |         |              |         | retry or finish with EIO(may |
|           |         |              |         | offline disk)                |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | fail         | NA      | fallback to host  recovery,  |
|           |         |              |         | retry or finish with EIO(may |
|           |         |              |         | offline disk)                |
+-----------+---------+--------------+---------+------------------------------+

Scenario3: both LUN and target based error handle are enabled:
+-----------+---------+--------------+---------+------------------------------+
| lun reset | TUR     | target reset | TUR     | Desired result               |
+-----------+---------+--------------+---------+------------------------------+
| success   | success | NA           | NA      | retry or finish with         |
|           |         |              |         | EIO(may offline disk)        |
+-----------+---------+--------------+---------+------------------------------+
| success   | fail    | success      | success | lun recovery fallback to     |
|           |         |              |         | target recovery, retry or    |
|           |         |              |         | finish with EIO(may offline  |
|           |         |              |         | disk                         |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | success      | success | lun recovery fallback to     |
|           |         |              |         | target recovery, retry or    |
|           |         |              |         | finish with EIO(may offline  |
|           |         |              |         | disk                         |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | success      | fail    | lun recovery fallback to     |
|           |         |              |         | target recovery, then fall   |
|           |         |              |         | back to host recovery, retry |
|           |         |              |         | or fhinsi with EIO(may       |
|           |         |              |         | offline disk)                |
+-----------+---------+--------------+---------+------------------------------+
| fail      | NA      | fail         | NA      | lun recovery fallback to     |
|           |         |              |         | target recovery, then fall   |
|           |         |              |         | back to host recovery, retry |
|           |         |              |         | or fhinsi with EIO(may       |
|           |         |              |         | offline disk)                |
+-----------+---------+--------------+---------+------------------------------+

References: https://lore.kernel.org/linux-scsi/20230815122316.4129333-1-haowenchao2@huawei.com/
References: https://lore.kernel.org/linux-scsi/71e09bb4-ff0a-23fe-38b4-fe6425670efa@huawei.com/

In this version of the push, I have made revisions based on the previous review comments. There
is previous version link:
References: https://lore.kernel.org/linux-scsi/20230901094127.2010873-1-haowenchao2@huawei.com/
References: https://lore.kernel.org/all/20250314012927.150860-1-jiangjianjun3@huawei.com/

JiangJianJun (4):
  scsi: core: increase/decrease target_busy if set error handler
  scsi: scsi_debug: Add params for configuring the error handler
  scsi: virtio_scsi: enable LUN based error handlers
  scsi: iscsi_tcp: enable LUN-based and target-based error handlers

Wenchao Hao (10):
  scsi: scsi_error: Define framework for LUN/target based error handle
  scsi: scsi_error: Move complete variable eh_action from shost to
    sdevice
  scsi: scsi_error: Check if to do reset in scsi_try_xxx_reset
  scsi: scsi_error: Add helper scsi_eh_sdev_stu to do START_UNIT
  scsi: scsi_error: Add helper scsi_eh_sdev_reset to do lun reset
  scsi: scsi_error: Add flags to mark error handle steps has done
  scsi: scsi_error: Add helper to handle scsi device's error command
    list
  scsi: scsi_error: Add a general LUN based error handler
  scsi: scsi_error: Add helper to handle scsi target's error command
    list
  scsi: scsi_error: Add a general target based error handler

 drivers/scsi/iscsi_tcp.c   |   4 +
 drivers/scsi/scsi_debug.c  |  26 +-
 drivers/scsi/scsi_error.c  | 800 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c    |  17 +-
 drivers/scsi/scsi_priv.h   |  15 +
 drivers/scsi/scsi_scan.c   |  19 +
 drivers/scsi/scsi_sysfs.c  |   2 +
 drivers/scsi/virtio_scsi.c |   3 +
 include/scsi/scsi_device.h |  87 ++++
 include/scsi/scsi_eh.h     |   8 +
 include/scsi/scsi_host.h   |  33 +-
 11 files changed, 952 insertions(+), 62 deletions(-)

-- 
2.33.0

