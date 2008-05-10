From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for SBP-2 disks
Date: Sun, 11 May 2008 00:32:53 +0200 (CEST)
Message-ID: <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
	<tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series contains:

Patch 1/5...3/5:  Some SBP-2 disks don't work as expected if the power
condition field in the START STOP UNIT command is not set.  They either
don't spin down on start=0, or they become unresponsive after it.  These
patches selectively adds power condition values for known affected
devices.  We can't do so across the board because certain other SBP-2
devices have been found to not support power condition (even though it
is mandatory as per RBC).

These three patches should IMO go into mainline during the current -rc
phase.

Patch 4/5...5/5:  Enable scsi_device.manage_start_stop for all SBP-2
devices (except if logged in non-exclusively).  This lets FireWire disks
spin down on suspend, driver unbinding, or system shutdown.

These two patches are post 2.6.26 material.

James, how do we handle patch 1/5, assumed that this one is OK?  Do you
route it through scsi-rc-fixes (or scsi-misc if really necessary), or do
you make an exception and let it slip through linux1394-2.6.git?  The
patch applies to plain 2.6.25 as well as to current scsi-misc without
conflicts.

 drivers/firewire/fw-sbp2.c |   25 +++++++++++++++++++++++--
 drivers/ieee1394/sbp2.c    |   22 ++++++++++++++++++++--
 drivers/ieee1394/sbp2.h    |    1 +
 drivers/scsi/sd.c          |    5 +++++
 include/scsi/scsi_device.h |    1 +
 5 files changed, 50 insertions(+), 4 deletions(-)

Stefan Richter (5):
      scsi: sd: optionally set power condition in START STOP UNIT
      firewire: fw-sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      ieee1394: sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      firewire: fw-sbp2: spin disks down on suspend and shutdown
      ieee1394: sbp2: spin disks down on suspend and shutdown
-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
