From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: various CDB processing fixes for -rc2
Date: Thu, 11 Aug 2011 01:52:46 +0000
Message-ID: <1313027569-27640-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41700 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HKCRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2011 22:17:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Folks,

The following is a bugfix series for lio-core-2.6.git/master to address
various CDB processing breakage that has been introduced with -rc1.

This includes the removal of some duplicate control CDB emulation completion
callbacks in transport_emulate_control_cdb, a fix to allow SYNCHRONIZE_CACHE
to work again for default IBLOCK/FILEIO cases with zero LBA + range, and the
addition of a missing check for DATA_SG_IO traffic to ensure that a receieved
LBA + range does not exceed the maximum via ->get_blocks()

This series will also need to goto mainline as well for -rc2, so please
have a look and comment.

Thanks!

--nab

Nicholas Bellinger (3):
  target: Remove duplicate task completions in
    transport_emulate_control_cdb
  target: Fix SYNCHRONIZE_CACHE zero LBA + range breakage
  target: Add missing DATA_SG_IO transport_cmd_get_valid_sectors check

 drivers/target/target_core_cdb.c       |   14 ++++++++------
 drivers/target/target_core_transport.c |   29 +++++++++++++++--------------
 2 files changed, 23 insertions(+), 20 deletions(-)

-- 
1.7.2.5

