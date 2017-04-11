From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 0/4] scsi: scsi_dh_alua: handle target port unavailable state
Date: Mon, 10 Apr 2017 22:17:57 -0300
Message-ID: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58501 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752109AbdDKBSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:18:11 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1DnNQ001938
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:11 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29rcsy4qv8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:18:10 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:18:08 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1I6XB28835890
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:06 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1I5XF017530
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:18:06 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

This patch series resolves a problem in which all paths of a multipath device
became _permanently_ failed after a storage system had moved both controllers
into a _temporarily_ unavailable state (that is SCSI_ACCESS_STATE_UNAVAILABLE).

This happened because once scsi_dh_alua had set the 'pg->state' to that value,
any IO coming to that PG via alua_prep_fn() would be immediately failed there.

It was possible to confirm that IO coming to that PG by another function path
(e.g., SG_IO) would perform normally once that PG's respective storage system
controller had transitioned back to an active state.

- Patch 1 essentially resolves that problem by allowing IO requests coming in
  the SCSI_ACCESS_STATE_UNAVAILABLE to actually proceed in alua_prep_fn(). It
  also schedules a recheck in alua_check_sense() to update pg->state properly.
  The problem/debug test-case is included in its commit message for reference.

- Patch 2 and Patch 3 address uncertainty & potentially incorrect assumptions
  when trying to reconcile the alua: RTPG information in the kernel logs with
  the actual port groups state at a given point in time and to multipath/path
  checkers status/failed/reinstated messages, since scsi_dh_alua could update
  the PG state for the 'other' PG (i.e., not the PG by which the RTPG request
  was sent to) but only present an updated state message for the 'current' PG.

- Patch 4 silences the scsi_dh_alua messages about RTPG state/information for
  the unavailable state if it is no news (i.e., not a transition to/out-of it),
  only keeping the first and (potentially) last message (when it is some news).
  That's because during the period in which the unavailable state is in place,
  the path checkers will naturally have to go through alua_check_sense() path,
  which schedules a recheck and thus alua_rtpg() goes through the sdev_printk.

This patch series has been tested with the 4.11-rc4 kernel.

For documentation purposes, I'll reply to this cover letter with the analysis
of such cases of this problem, and the accompanying messages from kernel logs.

Mauricio Faria de Oliveira (4):
  scsi: scsi_dh_alua: allow I/O in the target port unavailable state
  scsi: scsi_dh_alua: create alua_rtpg_print() for alua_rtpg()
    sdev_printk
  scsi: scsi_dh_alua: print changes to RTPG state of other PGs too
  scsi: scsi_dh_alua: do not print target port group state if it remains
    unavailable

 drivers/scsi/device_handler/scsi_dh_alua.c | 99 ++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 11 deletions(-)

-- 
1.8.3.1
