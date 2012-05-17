From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Support MI_REPORT_TARGET_PGS extended header format
Date: Thu, 17 May 2012 05:49:03 +0000
Message-ID: <1337233745-8145-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53972 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2EQFuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 01:50:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Rob Evers <revers@redhat.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Hannes & Co,

This series adds support for MI_REPORT_TARGET_PGS extended header format
within ALUA target port group infrastructure, and adds 'implict_trans_secs'
tg_pt_gp attribute to set this value individually via configfs for each
/sys/kernel/config/target/core/$HBA/$DEV/alua/$ALUA_TG_PT_GP/ group.

This feature has been on my TODO list for a while, and now that Rob Evers
has posted the scsi_dh_alua.c changes to take advantage of this information
array side, it's now time to get this supported within target-core.

Note so far this has been tested with 'sg_raw a3 2a' on loopback LUNs, and
appears to be working as expected.  Please have a look and let me know if you
have any concerns.

Thanks!

Nicholas Bellinger (2):
  target: Fix MAINTENANCE_IN service action CDB checks to use lower 5
    bits
  target: Add MI_REPORT_TARGET_PGS ext. header + implict_trans_secs
    attribute

 drivers/target/target_core_alua.c      |   88 ++++++++++++++++++++++++++-----
 drivers/target/target_core_alua.h      |   10 ++++
 drivers/target/target_core_configfs.c  |   21 ++++++++
 drivers/target/target_core_transport.c |    3 +-
 include/target/target_core_base.h      |    1 +
 5 files changed, 107 insertions(+), 16 deletions(-)

-- 
1.7.2.5

