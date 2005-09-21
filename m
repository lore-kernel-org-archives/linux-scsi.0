From: "goggin, edward" <egoggin@emc.com>
Subject: deadlock while cleaning up after transport timeout for target
Date: Wed, 21 Sep 2005 16:47:38 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ACC9@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:33499 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S964811AbVIUUrm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 16:47:42 -0400
Received: from mercury.eng.emc.com (mercury.eng.emc.com [168.159.100.12])
	by mailhub.lss.emc.com (Switch-3.1.6/Switch-3.1.6) with ESMTP id j8LKld2p003011
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 16:47:40 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Running with 2.6.13, an EMC Symmetrix target with lpfc and getting
into a deadlock when the target port times out WHILE starting to scan
the port via fc_scsi_scan_rport.

The lpfc_worker thread is stuck waiting for the scsi host's work_q to
empty in scsi_flush_work.  But this work queue wont empty since the
inquiry to LUN 0 initiated by the fc_scsi_scan_rport port scan is
getting retried onto the scsi mid-level request queue, seemingly ad
infinitum, since lpfc_queuecommand is returning
SCSI_MLQUEUE_HOST_BUSY whenever a target port infrastructure
is being dismantled.  This prevents the fc_scsi_scan_rport call from
finishing which prevents the target's NODEV timeout from being
completely serviced.  My boot up hangs as a result.

Not clear yet why the timeout is happening in the first place.  This
problem is occurring for about 70% of my reboots :((
