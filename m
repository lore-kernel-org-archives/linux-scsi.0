From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 0/2] fix race conditions in SCSI/Block leading to oops
Date: Fri, 22 Apr 2011 10:37:18 -0500
Message-ID: <1303486638.2590.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35966 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1DVPhY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 11:37:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>

There's a lkml thread on this:

http://marc.info/?t=130253369300004

But the synopsis is that some combination of delaying factors in the
boot of this machine exposed a race in SCSI and block between teardown
and reuse of SCSI devices.  This two set series fixes the race.

James

---

James Bottomley (2):
  block: add proper state guards to __elv_next_request
  put stricter guards on queue dead checks

 block/blk.h               |    3 ++-
 drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

-- 
1.7.4.1



