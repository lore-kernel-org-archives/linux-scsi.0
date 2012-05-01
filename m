From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/17] hpsa: resend updates for April, 2012
Date: Tue, 01 May 2012 11:42:03 -0500
Message-ID: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17672 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2EAQmG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 12:42:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

The two big changes here are adding an abort handler, and using multiple
reply queues for command completions.  Updated the patch set since last
time to address comments:

	* Use pci_set_master(h->pdev) to enable bus mastering instead of 
	  doing it manually.

	* Retry driver initiated commands on SAM_STAT_TASK_SET_FULL
	  as well as SAM_STAT_BUSY and retry more than just 3 times,
	  backing off the retry rate.

	* Dropped the changes that used the new IS_ENABLED macro.

Matt Bondurant (1):
      hpsa: retry driver initiated commands on busy status

Matt Gates (2):
      hpsa: use multiple reply queues
      hpsa: refine interrupt handler locking for greater concurrency

Mike Miller (1):
      hpsa: add new RAID level "1(ADM)"

Stephen M. Cameron (13):
      hpsa: call pci_disable_device on driver unload
      hpsa: do not skip disabled devices
      hpsa: enable bus master bit after pci_enable_device
      hpsa: suppress excessively chatty error messages
      hpsa: do not read from controller unnecessarily in completion code
      hpsa: do not give up retry of driver cmds after only 3 retries
      hpsa: remove unused parameter from finish_cmd
      hpsa: add abort error handler function
      hpsa: do aborts two ways
      hpsa: factor out tail calls to next_command() in process_(non)indexed_cmd()
      hpsa: factor out hpsa_free_irqs_and_disable_msix
      hpsa: removed unused member maxQsinceinit
      hpsa: dial down lockup detection during firmware flash


 drivers/block/cciss.c   |    2 
 drivers/scsi/hpsa.c     |  682 ++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/hpsa.h     |   85 ++++--
 drivers/scsi/hpsa_cmd.h |   37 ++-
 4 files changed, 642 insertions(+), 164 deletions(-)

-- 
-- steve

