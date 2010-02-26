From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/9] cciss driver SCSI updates
Date: Fri, 26 Feb 2010 16:01:06 -0600
Message-ID: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

The following series mainly fixes the scsi tape code in the cciss
driver to take advantage of more scatter gather elements, enabling
larger transfer sizes.  The first eight patches are mainly cleaning
things up and getting ready for the 9th patch, which enables the
SCSI half of the driver to use more than 31 scatter gather elements.

I've tested on 32-bit and 64-bit systems, and written out tapes
with block sizes up to 2Mb.

These patches are vs. Jens's linux-2.6-block tree.

Stephen M. Cameron (9):
      cciss: clarify command list padding calculation
      cciss: detect bad alignment of scsi commands at build time
      cciss: factor out scatter gather chain block allocation and freeing
      cciss: simplify scatter gather code
      cciss: fix scatter gather chain block dma direction kludge
      cciss: factor out scatter gather chain block mapping code
      cciss: do not use void pointer for scsi hba data
      cciss: eliminate unnecessary pointer use in cciss scsi code
      cciss: Fix problem with scatter gather elements in the scsi half of the driver


 drivers/block/cciss.c      |  174 ++++++++++++++++++++++----------------------
 drivers/block/cciss.h      |   12 +--
 drivers/block/cciss_cmd.h  |   14 +++-
 drivers/block/cciss_scsi.c |  145 +++++++++++++++++++++++--------------
 4 files changed, 188 insertions(+), 157 deletions(-)

-- 
-- steve
