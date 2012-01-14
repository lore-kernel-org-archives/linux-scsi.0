From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 0/7] libsas eh reworks: new + regression fixes
Date: Sat, 14 Jan 2012 10:09:51 -0800
Message-ID: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following are incremental to v4: http://marc.info/?l=linux-scsi&m=132618126007864&w=2

1/ patch 1, 2, 3, 4 new fixes to clean up eh vs device remove 
2/ patch 5 regression fix for the sas_drain_work implementation
3/ patch 6 regression fix for domain_device reference counting
4/ patch 7 RFC implementation for hardening sata device discovery.

Patch 7 is still undergoing test, but looking for feedback from other
libsas users, particularly Jack, about the approach and whether it
addresses the sata discovery problems that have been discussed on the
list.

[PATCH 1/7] libsas: mark all domain devices gone if root port disappears
[PATCH 2/7] libsas: close scsi_remove_target() vs libata-eh race
[PATCH 3/7] libsas: fix mixed topology recovery
[PATCH 4/7] libsas: route local link resets through ata-eh
[PATCH 5/7] libsas: fix sas_unregister_ports vs sas_drain_work
[PATCH 6/7] libsas: kill spurious sas_put_device
[RFC PATCH 7/7] libsas: let libata recover links that fail to transmit initial sig-fis

 drivers/scsi/libsas/sas_ata.c       |   84 ++++++++++++++++++++----
 drivers/scsi/libsas/sas_discover.c  |   16 +++-
 drivers/scsi/libsas/sas_expander.c  |  125 ++++++++++++++++-------------------
 drivers/scsi/libsas/sas_host_smp.c  |   11 +++
 drivers/scsi/libsas/sas_init.c      |   53 +++++++++------
 drivers/scsi/libsas/sas_internal.h  |    7 +-
 drivers/scsi/libsas/sas_port.c      |    4 -
 drivers/scsi/libsas/sas_scsi_host.c |   16 ++--
 include/scsi/libsas.h               |    2 -
 include/scsi/sas.h                  |    4 +
 include/scsi/sas_ata.h              |   17 +++--
 11 files changed, 210 insertions(+), 129 deletions(-)
