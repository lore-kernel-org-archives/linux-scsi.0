From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 00/12] bnx2fc: Version 1.0.4
Date: Mon, 27 Jun 2011 23:30:52 -0700
Message-ID: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

The following patch set contains
        - the support for FCP-2 sequence level error recovery (patch 3-8)
        - the support to handle vlan id changes in the switch (patch 2)
        - enhancements/bug fixes (patch 1,9,10,11)

James,

Please note that this patchset has dependency on the latest bnx2x network
driver currently in linux-next tree. These patches were compiled and tested on
linux-next tree and will have to be applied after the one I submitted on
05/27: http://marc.info/?l=linux-scsi&m=130652206419164&w=2, followed by sync
up with linux-next tree.

Thanks.

Bhanu Prakash Gollapudi (12):
  bnx2fc: Replace printks with KERN_ALERT to KERN_ERR/KERN_INFO
  bnx2fc: Introduce interface structure for each vlan interface
  bnx2fc: Enable REC & CONF support for the session
  bnx2fc: Support 'sequence cleanup' task
  bnx2fc: REC/SRR link service request and response handling
  bnx2fc: Handle REC_TOV error code from firmware
  bnx2fc: HSI changes for tape
  bnx2fc: Enable support for sequence level error recovery
  bnx2fc: hold tgt lock when calling cmd_release
  bnx2fc: Do not arm CQ when there are no CQEs
  bnx2fc: Tx BDs cache in write tasks
  bnx2fc: Update copyright and bump version to 1.0.4

 drivers/scsi/bnx2fc/bnx2fc.h       |  107 +++---
 drivers/scsi/bnx2fc/bnx2fc_debug.h |   16 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c   |  435 +++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |  734 +++++++++++++++++-------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |  433 +++++++++++++++++-----
 drivers/scsi/bnx2fc/bnx2fc_io.c    |  194 ++++++++--
 drivers/scsi/bnx2fc/bnx2fc_tgt.c   |   51 ++-
 7 files changed, 1363 insertions(+), 607 deletions(-)
