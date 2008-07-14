From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
Date: Mon, 14 Jul 2008 13:42:43 +0200 (CEST)
Message-ID: <tkrat.3a4a875d2359a2c0@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
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
To: linux-kernel@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

I now rebased all linux1394-2.6.git branches onto v2.6.26.  Here is how
it looks like now and what I plan to get merged into mainline:


branch for-linus (based on v2.6.26)
===================================

Contains cleanups including bits of Big Kernel Lock related work and
Philippe's patch to include IR/IT DMA buffers of raw1394, video1394,
dv1394 in core dumps.  All of these patches have been seen on lkml and
linux1394-devel and have been in many -next kernels without problem. I
will send a pull request to Linus soon, maybe still today.

Alan Cox (1):
      ieee1394: raw1394: Push the BKL down into the driver ioctls

Philippe De Muyter (1):
      ieee1394: dump mmapped iso buffers in core files

Stefan Richter (7):
      ieee1394: reduce log noise about config ROM CRC errors
      ieee1394: video1394: reorder module init, prepare BKL removal
      firewire: implement broadcast_channel CSR for 1394a compliance
      firewire: remove unused struct members
      firewire: clean up some includes
      firewire: clean up fw_card reference counting
      firewire: don't respond to broadcast write requests

 drivers/firewire/fw-card.c        |   32 +++++++++++++++++---------
 drivers/firewire/fw-device.c      |    5 +--
 drivers/firewire/fw-device.h      |    1 -
 drivers/firewire/fw-ohci.c        |    1 -
 drivers/firewire/fw-transaction.c |   32 +++++++++++++++++++-------
 drivers/firewire/fw-transaction.h |   34 ++++++++++++++++++++++------
 drivers/ieee1394/csr1212.c        |   32 ++++++++++++++++++--------
 drivers/ieee1394/dma.c            |    2 +-
 drivers/ieee1394/highlevel.c      |    4 +--
 drivers/ieee1394/highlevel.h      |   13 ++++++++++-
 drivers/ieee1394/raw1394.c        |   20 ++++++++++++----
 drivers/ieee1394/video1394.c      |    2 +
 12 files changed, 125 insertions(+), 53 deletions(-)


branch sbp2-spindown (based on v2.6.26)
=======================================

Contains a new device quirk handling in sd-mod and uses it for some
buggy SBP-2 disks.  Also changes the default setting of
manage_start_stop of all SBP-2 HDDs from off to on.  That is, disks will
now per default spun down if the system is suspended or shut down or if
sd-mod is unbound from a HDD.  This change is only done if the SBP-2
driver has exclusively logged in to a HDD (also the default mode), i.e.
the feature is not used in multiple initiator setups.

The patches have been seen on lkml, lsml, and linux1394-devel and have
been in many -next kernels without problem.  James has been polled for
ACK or NAK regarding the SCSI change a few times but I didn't get a
response.  I will nevertheless submit this for mainline merge ASAP but
in a pull request separate from the other for-linus patches.

Stefan Richter (5):
      scsi: sd: optionally set power condition in START STOP UNIT
      firewire: fw-sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      ieee1394: sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      firewire: fw-sbp2: spin disks down on suspend and shutdown
      ieee1394: sbp2: spin disks down on suspend and shutdown

 drivers/firewire/fw-sbp2.c |   25 +++++++++++++++++++++++--
 drivers/ieee1394/sbp2.c    |   22 ++++++++++++++++++++--
 drivers/ieee1394/sbp2.h    |    1 +
 drivers/scsi/sd.c          |    5 +++++
 include/scsi/scsi_device.h |    1 +
 5 files changed, 50 insertions(+), 4 deletions(-)


branch for-next (based on for-linus)
====================================

Contains new patches which have not yet been in -next.  However, they
look like they could be merged even before 2.6.27-rc1 gets out.

Stefan Richter (5):
      firewire: fix race of bus reset with request transmission
      firewire: fully initialize fw_transaction before marking it pending
      firewire: small fw_fill_request cleanup
      firewire: warn on unfinished transactions during card removal
      Merge branch 'sbp2-spindown' into for-next

 drivers/firewire/fw-card.c        |    2 +-
 drivers/firewire/fw-topology.c    |    2 --
 drivers/firewire/fw-transaction.c |   21 +++++++++------------
 3 files changed, 10 insertions(+), 15 deletions(-)


branch master (based on for-next)
=================================

Contains an already very old fix and a small optimization.  The fix
still needs follow-up work; it trades a fix for potential but rare
kernel panic with not too rare but avoidable temporary connection loss.
I need to implement something to let the connection survive the
respective situations.

Stefan Richter (2):
      firewire: insist on successive self ID complete events
      firewire: unnecessary BM delay after generation rollover

 drivers/firewire/fw-card.c        |    2 +-
 drivers/firewire/fw-topology.c    |   12 ++++++++++++
 drivers/firewire/fw-transaction.h |    9 +++++++++
 3 files changed, 22 insertions(+), 1 deletions(-)

-- 
Stefan Richter
-=====-==--- -=== -===-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
Studies have shown that voting for your favorite open source project,
along with a healthy diet, reduces your potential for chronic lameness
and boredom. Vote Now at http://www.sourceforge.net/community/cca08
