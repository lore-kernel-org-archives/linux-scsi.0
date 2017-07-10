From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2 0/4] scsi_dh_alua: fix stuck I/O after unavailable/standby states
Date: Mon, 10 Jul 2017 19:47:33 -0300
Message-ID: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, scsi_dh_alua fails I/O requests early on once ALUA state
unavailable/standby occur, which prevents path checkers to actually
check if I/O still fails or now works.

Then I/O requests are blocked indefinitely due to queue_if_no_path
but the underlying individual paths are fully operational, and can
be verified as such otherways (e.g., SG_IO).

This patchset addresses that problem, and adds a few improvements
to the logging of PG state changes.

Patch 1 fixes the problem.
Patch 2 makes sure that state changes for all PGs are logged.
Patch 3 makes sure that state no-changes for PGs in unavailable/standby
        are not logged - only changes are.
Patch 4 adds few sdev_dbg() calls to track the path to alua_rtpg_work()

Tested on v4.12+ (commit b4b8cbf679c4).

Mauricio Faria de Oliveira (4):
  scsi: scsi_dh_alua: allow I/O in target port unavailable and standby
    states
  scsi: scsi_dh_alua: print changes to RTPG state of all PGs
  scsi: scsi_dh_alua: do not print RTPG state if it remains
    unavailable/standby
  scsi: scsi_dh_alua: add sdev_dbg() to track alua_rtpg_work()

 drivers/scsi/device_handler/scsi_dh_alua.c | 129 +++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 16 deletions(-)

-- 
1.8.3.1
