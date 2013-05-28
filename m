From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH 0/2] Minor scsi_dh_emc error path fixes
Date: Tue, 28 May 2013 17:18:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:58835 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3E1VWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 17:22:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

These two patches spun out of the blk_get_request return type changes
I've been working on [1].

  [1] http://thread.gmane.org/gmane.linux.scsi/80934

Should that patch go in, there are a few other device handler changes
possible for 3.11 [2], but the following bugfixes are unrelated, so I
thought I'd post them in case they could apply for 3.10.

  [2] http://thread.gmane.org/gmane.linux.scsi/81130

The first bug was spotted by Mike in thread [2], the second when I
traced the call path of clariion_send_inquiry back out through
clariion_set_params and its caller parse_path. The latter fix could have
been made in parse_path, but it didn't seem appropriate for that file to
sort through SCSI_DH enums.

Comments welcome, unfortunately I don't have the HW to verify, so these
are only compile tested.

Thanks,

Joe Lawrence (2):
  scsi_dh_emc: handle zero-senselen send_inquiry_cmd errors
  scsi_dh_emc: set_params callback should consistently return errno

 drivers/scsi/device_handler/scsi_dh_emc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

-- 
1.7.10.4

