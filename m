From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 0/9] zfcp: decouple scsi_eh callbacks from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:18 +0200
Message-ID: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54937 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752271AbdGYOOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEAFZq000636
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:40 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx3b2madx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:40 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

This is an early request for comments.
The patch set serves as a zfcp preparation step for Hannes' series
"[PATCH 00/47] SCSI EH argument reshuffle part II"
http://www.spinics.net/lists/linux-scsi/msg111165.html
or
http://marc.info/?l=linux-scsi&m=150091945302995&w=2

The series is based on 18 preceding zfcp patches,
including some stable regression bugfixes for zfcp tracing.
Hence it might not apply cleanly.
However, we plan to post the 18 preceding patches soon for integration
and I would like to get those in first.

Please do not apply to any tree that will merge into upstream yet,
as it's not ready for prime time.
It only builds (after each patch; sparse and checkpatch clean)
but it has not seen any function testing yet.

There are still some open questions:
* Search victim scsi_device in target_reset_handler just to get a LUN?
  (Even if we do, zfcp_fsf_fcp_handler_common() should not print that LUN!)
  http://www.spinics.net/lists/linux-scsi/msg111164.html
  http://www.spinics.net/lists/linux-scsi/msg111166.html
* Exact rport blocking logic in host_reset_handler.
  http://www.spinics.net/lists/linux-scsi/msg111165.html


Steffen Maier (9):
  zfcp: drop unsuitable scsi_cmnd usage from SCSI traces for scsi_eh /
    TMF
  zfcp: decouple TMF response handler from scsi_cmnd
  zfcp: split FCP_CMND IU setup between SCSI I/O and TMF again
  zfcp: decouple FSF request setup of TMF from scsi_cmnd
  zfcp: decouple SCSI setup of TMF from scsi_cmnd
  scsi: fc: start decoupling fc_block_scsi_eh from scsi_cmnd
  zfcp: use fc_block_rport for TMFs and host reset to decouple from
    scsi_cmnd
  zfcp: fix waiting for rport(s) unblock in eh_host_reset_handler
  zfcp: decouple our scsi_eh callbacks from scsi_cmnd

 drivers/s390/scsi/zfcp_dbf.c     |  51 ++++++++++++-------
 drivers/s390/scsi/zfcp_dbf.h     |  26 +++++++---
 drivers/s390/scsi/zfcp_ext.h     |  12 +++--
 drivers/s390/scsi/zfcp_fc.h      |  24 ++++++---
 drivers/s390/scsi/zfcp_fsf.c     | 106 +++++++++++++++++++++++++--------------
 drivers/s390/scsi/zfcp_scsi.c    | 105 +++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_transport_fc.c |  31 ++++++++++--
 include/scsi/scsi_transport_fc.h |   1 +
 8 files changed, 252 insertions(+), 104 deletions(-)

-- 
2.11.2
