From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] libsas: SATA PHY connection rate matching during disovery
Date: Sat, 5 Jan 2019 00:01:25 +0800
Message-ID: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset looks to resolve an issue we see whereby a SATA end device
negotiated linkrate may exceed the min linkrate to the initiator, and
not be able to establish a connection.

According to the SAS spec, we should lower the SATA PHY linkrate when this
condition occurs.

It appears that some SAS HBAs (whose driver do not use libsas) already do
this automatically (via firmware, I assume).

This patchset solves this issue during device discovery phase when
detecting a new device, but not during revalidation after the user has
reprogrammed some PHY linkrates in the topology. Solving for the latter is
much more complicated, and will be done as follow-up to this series.

A minor tidy-up to libsas.h is also included.

John Garry (3):
  scsi: libsas: Fix some indentation in libsas.h
  scsi: libsas: Check SMP PHY control function result
  scsi: libsas: Support SATA PHY connection rate unmatch fixing during
    discovery

 drivers/scsi/libsas/sas_expander.c | 29 +++++++++++++++++++-
 include/scsi/libsas.h              | 56 ++++++++++++++++++--------------------
 2 files changed, 55 insertions(+), 30 deletions(-)

-- 
1.9.1
