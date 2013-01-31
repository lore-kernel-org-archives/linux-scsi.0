From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Fix bugs when dealing with unconfigured devices
Date: Thu, 31 Jan 2013 23:19:13 +0000
Message-ID: <1359674355-8590-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36636 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AaX2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2013 18:28:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

These two patches address two bugs that I've ran across when dealing with
backend devices that have failed to be successfully enabled, and remain
in an unconfigured state.

The first is a v3.8-rc1 specific regression due to fallout from the removal
of struct se_subsystem_dev, and the second is to avoid a possible divide by
zero when writing fabric_max_sectors when no block_size has been set by the
device.

The latter is being CC'ed to stable.

Thanks,

--nab

Nicholas Bellinger (2):
  target: Fix regression allowing unconfigured devices to fabric port
    link
  target: Fix divide by zero bug in fabric_max_sectors for unconfigured
    devices

 drivers/target/target_core_device.c          |    8 +++++++-
 drivers/target/target_core_fabric_configfs.c |    5 +++++
 2 files changed, 12 insertions(+), 1 deletions(-)

-- 
1.7.2.5

