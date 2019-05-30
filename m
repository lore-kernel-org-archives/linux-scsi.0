From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] scsi: add support for request batching
Date: Thu, 30 May 2019 13:28:09 +0200
Message-ID: <20190530112811.3066-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

This allows a list of requests to be issued, with the LLD only writing
the hardware doorbell when necessary, after the last request was prepared.
This is more efficient if we have lists of requests to issue, particularly
on virtualized hardware, where writing the doorbell is more expensive than
on real hardware.

This applies to any HBA, either singlequeue or multiqueue; the second
patch implements it for virtio-scsi.

Paolo

Paolo Bonzini (2):
  scsi_host: add support for request batching
  virtio_scsi: implement request batching

 drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
 drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
 include/scsi/scsi_cmnd.h   |  1 +
 include/scsi/scsi_host.h   | 16 +++++++++--
 4 files changed, 89 insertions(+), 20 deletions(-)

-- 
2.21.0
