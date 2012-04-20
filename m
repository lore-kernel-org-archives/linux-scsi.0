From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/17] hpsa updates for April, 2012
Date: Fri, 20 Apr 2012 10:06:11 -0500
Message-ID: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

The two big changes here are adding an abort handler, and using multiple
reply queues for command completions.  

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
      hpsa: remove unused parameter from finish_cmd
      hpsa: add abort error handler function
      hpsa: do aborts two ways
      hpsa: factor out tail calls to next_command() in process_(non)indexed_cmd()
      hpsa: factor out hpsa_free_irqs_and_disable_msix
      hpsa: use new IS_ENABLED macro
      hpsa: removed unused member maxQsinceinit
      hpsa: dial down lockup detection during firmware flash


 drivers/block/cciss.c   |    2 
 drivers/scsi/hpsa.c     |  689 +++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa.h     |   85 ++++--
 drivers/scsi/hpsa_cmd.h |   37 ++-
 4 files changed, 643 insertions(+), 170 deletions(-)

-- 
-- steve
