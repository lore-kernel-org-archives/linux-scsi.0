From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] [TCM/PR]: Add support for strict iSCSI TransportID ISID processing
Date: Mon, 12 Apr 2010 22:48:59 -0700
Message-ID: <1271137739-23307-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:29382 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882Ab0DMFHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 01:07:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings SCSI folks,

This is a set of patches to lio-core-2.6.git/master to add proper support for strict
iSCSI TransportID ISID processing within core TCM/PR fabric independent logic.

This allows TCM to properly handle the scenario for SPC-3 PR and legacy SPC-2 reservations 
where there is a single iSCSI InitiatorName with multiple ISIDs (TransportIDs with the same
InitiatorName) connecting to a single TCM/LIO target endpoint (TargetName+TargetPortalGroupTag)
Beyond this one case, this patch also does change the default operation of TCM/PR for all
scenarios to require the use of InitiatorName+ISID TransportIDs for PR opreation for fabrics
(like iSCSI) having 'multi-value' TransportIDs containing an ISID.

There is also a patch to add a device attribute 'enforce_pr_isids' to allow matching for
PR registration created via TransportID with SPEC_I_PT=1 or REGISTER_AND_MOVE not containing
a ISID, but for fabric destination employing them (iSCSI again).  Note that the changes have
been tested using iSCSI and Virtual SAS ports with REGISTER + SPEC_I_PT=1, APTPL=1 and
REGISTER_AND_MOVE between LIO-Target and TCM_Loop fabric modules.

It would be great if any folks fimilar discussion would mind to have a look at the code!

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  [TCM/PR]: Add proper support for ISIDs in TransportID processing
  [TCM/PR]: Replace usage of DEF_PR_REGISTERED with
    *core_scsi3_locate_pr_reg()
  [TCM/PR]: Update APTPL metadata logic for ISIDs in TransportID
    processing
  [TCM/ConfigFS]: Add per-device attribute 'enforce_pr_isids'

 drivers/target/target_core_configfs.c  |   44 +++-
 drivers/target/target_core_device.c    |   12 +
 drivers/target/target_core_pr.c        |  393 ++++++++++++++++++++++++--------
 include/target/target_core_base.h      |    4 +
 include/target/target_core_device.h    |    1 +
 include/target/target_core_pr.h        |    6 +-
 include/target/target_core_transport.h |    3 +
 7 files changed, 356 insertions(+), 107 deletions(-)

