From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/2] Fix a couple hpsa bugs related to device discovery
Date: Thu, 16 Dec 2010 13:00:51 -0600
Message-ID: <20101216185823.545.99641.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32357 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0LPTCa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 14:02:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

This series fixes a couple of bugs related to discovering changes to
devices.  1) We should not consider a firmware change to mean the
device identity has changed.  Just because a logical drive's firmware
changes doesn't mean it's not the same drive with the same data, so
it should not be removed and re-added to the scsi mid layer.
2) Likewise if the RAID level is observed to change.  This can happen
for instance by doing a RAID level migration from with the Array
Configuration Utility. 

---

Stephen M. Cameron (2):
      hpsa: do not consider firmware revision when looking for device changes.
      hpsa: do not consider RAID level to be part of device identity


 drivers/scsi/hpsa.c |   11 -----------
 drivers/scsi/hpsa.h |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

-- 
-- steve
