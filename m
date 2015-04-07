From: Jens Axboe <axboe@fb.com>
Subject: [PATCH RFC v2] mpt2/mpt3sas lock reduction for scsi-mq
Date: Tue, 7 Apr 2015 11:18:34 -0600
Message-ID: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8909 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbbDGRSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 13:18:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de

Hi,

This is v2 of the series. Generally addressed Christoph's review comments,
but more specifically, changes since v1:

- Kill the MPI2_FUNCTION_SCSI_TASK_MGMT support, which in turn
  enabled me to drop the SCSI/blk iter patches and the smid work-around
  for scsi-mq in mpt2/3 for bumping to hpr for NULL command.
- Made init/exit_command() work (sort of) on non scsi-mq. Drivers
  will have to set request_index related information separately
  still for non scsi-mq, since we don't have a reliable one
- Use scsi_cmd_priv() instead of adding a new helper.
- Make scsi_find_tag() only return in-progress IO for scsi-mq. This is
  simiar to the ->special check for non-mq.
- Ensure that mpt3sas is in sync with the mpt2sas changes.

 drivers/scsi/mpt2sas/mpt2sas_base.c  |  187 ++++++++++++++++++++++++-----------
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    3 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |  126 +----------------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   87 ++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  173 +++++++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    2 
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  130 +-----------------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   69 ++++++++++--
 drivers/scsi/scsi.c                  |    9 +
 drivers/scsi/scsi_lib.c              |   16 ++
 include/scsi/scsi_host.h             |    6 -
 include/scsi/scsi_tcq.h              |   11 +-
 12 files changed, 448 insertions(+), 371 deletions(-)

