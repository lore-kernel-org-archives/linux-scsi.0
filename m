From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv4 0/1] Update SCSI hosts to use ida for host number mgmt
Date: Wed,  7 Oct 2015 16:51:33 -0700
Message-ID: <cover.1444241058.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

This patch updates the SCSI hosts module to use the ida
index-management routines to manage its host_no index instead
of using an ATOMIC integer. This means that host numbers
can now be reclaimed and re-used.

NOTE: it was not feasible to use idr_*() functions instead of
ida_*() functions, since using idr_find() without additional
locking to find our Scsi_Host structure left a window between
idr lookup and host structure deletion that would have
required additional locking to close.

Changes from v3:
 - Switched from idr to ida since managing our instance
   pointer required extra locking
Changes from v2 and v1:
 - First two version used idr instead of ida

Lee Duncan (1):
  SCSI: hosts: update to use ida_simple for host_no management

 drivers/scsi/hosts.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
2.1.4
