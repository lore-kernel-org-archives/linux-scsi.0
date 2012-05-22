From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] sbp-target merge for v3.5-rc1
Date: Tue, 22 May 2012 15:33:49 -0700
Message-ID: <1337726029.22481.116.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Chris Boot <bootc@bootc.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Clemens Ladisch <clemens@ladisch.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here is the next pull request for Chris Boot's new Serial Block Protocol
(sbp) target driver for IEEE-1394 (FireWire) hardware.  This code also
has been in linux-next for a number of weeks, and is ready for an
initial merge.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git sbp-target-merge

The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
as a SCSI transport. This module uses the SCSI Target framework to
expose LUNs to other machines attached to a FireWire bus, in effect
acting as a FireWire hard disk similar to FireWire Target Disk mode
on many Apple computers.

Also included are the two drivers/firewire/ patches required by
sbp-target to access fw_request fabric speed needed for mgt_agent
TCODE_WRITE_BLOCK_REQUEST ops, and exporting fw_card kref logic used
when creating/destroying active session references to individual
endpoints.

A credit goes to Chris in being able to get this code up and running so
quickly w/o any target core changes, and special thanks goes out to
Stefan Richter + Clemens Ladisch + Andy Grover for their help in getting
this driver ready for mainline.  Also, one of Chris's goals was to be
able to connect sbp-target to a PowerPC based MacOS-X based client, that
he accomplished along the way in this obligatory screenshot:

http://linux-iscsi.org/wiki/File:Linux-fireware-target-bootc-macosx.png

Great work Chris + linux-1394 team !!

--nab

Chris Boot (3):
  firewire: Add function to get speed from opaque struct fw_request
  firewire: Move fw_card kref functions into linux/firewire.h
  sbp-target: Initial merge of firewire/ieee-1394 target mode support

 MAINTAINERS                         |    9 +
 drivers/firewire/core-card.c        |    1 +
 drivers/firewire/core-transaction.c |    9 +
 drivers/firewire/core.h             |   15 -
 drivers/target/Kconfig              |    1 +
 drivers/target/Makefile             |    1 +
 drivers/target/sbp/Kconfig          |   11 +
 drivers/target/sbp/Makefile         |    1 +
 drivers/target/sbp/sbp_target.c     | 2621 +++++++++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_target.h     |  251 ++++
 include/linux/firewire.h            |   15 +
 11 files changed, 2920 insertions(+), 15 deletions(-)
 create mode 100644 drivers/target/sbp/Kconfig
 create mode 100644 drivers/target/sbp/Makefile
 create mode 100644 drivers/target/sbp/sbp_target.c
 create mode 100644 drivers/target/sbp/sbp_target.h
