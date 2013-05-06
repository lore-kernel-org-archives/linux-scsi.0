From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] Cleanup struct Scsi_Host
Date: Mon,  6 May 2013 09:20:36 +0200
Message-ID: <1367824841-47767-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3EFHUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 03:20:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'Scsi_Host' structure has two fields 'resetting' and
'last_reset' which are basically unused. There are only
4 drivers referencing 'last_reset' (dpt_i2o, tmscsim, dc395, and advansys),
and only dpt_i2o makes usage of both fields.
However, dpt_i2o does _not_ require a delay after reset,
so even there the usage is questionable.

So move the 'last_reset' field into the internal host
structure where needed and remove both fields from
struct Scsi_Host.

Hannes Reinecke (5):
  scsi: remove 'resetting' field from struct Scsi_Host
  tmscsim: Move 'last_reset' into host structure
  dc395: Move 'last_reset' into internal host structure
  advansys: Remove references to 'last_reset'
  scsi: Remove 'last_reset' for struct Scsi_Host

 drivers/scsi/advansys.c  |  8 ++++----
 drivers/scsi/dc395x.c    | 24 +++++++++++++-----------
 drivers/scsi/dpt_i2o.c   | 22 +++-------------------
 drivers/scsi/scsi.c      | 25 +------------------------
 drivers/scsi/tmscsim.c   | 12 ++++++------
 drivers/scsi/tmscsim.h   |  1 +
 include/scsi/scsi_host.h |  4 +---
 7 files changed, 29 insertions(+), 67 deletions(-)

-- 
1.7.12.4

