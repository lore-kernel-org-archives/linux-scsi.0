From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 0/8] qla2xxx: Updates for Target Mode driver
Date: Tue, 14 Jul 2015 16:00:41 -0400
Message-ID: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:22789 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbbGNUp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 16:45:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi James,

This series is applied on top of patch series sent on June 10
   [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch
(http://marc.info/?l=linux-scsi&m=143395156920505&w=2)

These set of patches addresses issue with reuse of stale command found
in a customer enviorment. Here's sequence of events which could result
into this reuse of stale command which could potentially lead to data
corruption.
  - Backend driver goes out of sync with front end driver due to session
    management problem.
  - During this time a session receives a NEW login by the same initiator.
  - All the commands from previous session are not flushed before establishing
    a new session/connection.
  - These stale commands leaks into new session resulting into case
    where they could potentially share same Exchange ID.
In such case data can cross path between old and new session when the frontend
driver/fabric driver allows a new connection to be established without backend
knowledge. To fix this problem, old session is destroyed first before creating
new session. The session destroy process would wait for all existing commands
to finish.

The Changes from v1 of this series are:

- Rebased patch series on top of v4.2.0-rc1+.
- Dropped following patches and will be sent as seperate series.
  qla2xxx: Added interface to send ELS commands from driver.
  qla2xxx: delete session if initiator is gone from FW
  qla2xxx: wait for all conflicts before ack'ing PLOGI 

Please apply these patches to scsi tree at your earliest for inclusion in the
next mainline merge window.

Thanks,
Himanshu

Alexei Potashnik (6):
  qla2xxx: delay plogi/prli ack until existing sessions are deleted
  qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
  qla2xxx: added sess generations to detect RSCN update races
  qla2xxx: disable scsi_transport_fc registration in target mode
  qla2xxx: drop cmds/tmrs arrived while session is being deleted
  qla2xxx: terminate exchange when command is aborted by LIO

Roland Dreier (1):
  qla2xxx: kill sessions/log out initiator on RSCN and port down events

Swapnil Nagle (1):
  qla2xxx: cleanup cmd in qla workqueue before processing TMR

 drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
 drivers/scsi/qla2xxx/qla_def.h     |   12 +
 drivers/scsi/qla2xxx/qla_init.c    |  188 ++++++++--
 drivers/scsi/qla2xxx/qla_iocb.c    |    3 +
 drivers/scsi/qla2xxx/qla_os.c      |   11 +-
 drivers/scsi/qla2xxx/qla_target.c  |  714 +++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.h  |   69 +++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   23 +-
 8 files changed, 906 insertions(+), 120 deletions(-)

-- 
1.7.7

