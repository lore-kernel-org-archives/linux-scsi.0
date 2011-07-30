From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/9] isci updates for 3.1
Date: Fri, 29 Jul 2011 17:16:34 -0700
Message-ID: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3AQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:16:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

James, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

...to receive primarily a collection of fixes.  The first two are tagged
for -stable.

We still have ATAPI and SGPIO support in the works.

The SGPIO support is awaiting your response on the interface from libsas
to the driver for locally attached sgpio operation [1].  I think we can
solve the sysfs representation of these initiators at a later date.  For
now this just allows the driver to capture the smp sgpio request.

ATAPI support is not ready for prime time, but the initial
implementation is available on the 'testing' branch [2], and we are
aiming to get it finalized for 3.1.

[1]: http://marc.info/?l=linux-scsi&m=130876728404136&w=2
[2]: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git testing

Dan Williams (5):
      isci: fix sata response handling
      isci: fix 32-bit operation when CONFIG_HIGHMEM64G=n
      isci: dynamic interrupt coalescing
      isci: fix event-get pointer increment
      isci: add version number

Dave Jiang (2):
      isci: Update MAINTAINERS entry for the isci driver
      isci: Adding documentation to API change and fixup sysfs registration

Jeff Skirvin (1):
      isci: Leave requests alone if already terminating.

Marcin Tomczak (1):
      isci: change sas phy timeouts from 54us to 59us

 Documentation/ABI/testing/sysfs-class-scsi_host |   13 ++++++
 MAINTAINERS                                     |   11 +++++
 drivers/scsi/isci/host.c                        |   13 ++++++-
 drivers/scsi/isci/host.h                        |    3 +
 drivers/scsi/isci/init.c                        |   47 +++++++++++++---------
 drivers/scsi/isci/phy.c                         |   13 ++++++
 drivers/scsi/isci/registers.h                   |   12 ++++++
 drivers/scsi/isci/request.c                     |   30 ++++++++-------
 drivers/scsi/isci/unsolicited_frame_control.c   |    2 +-
 drivers/scsi/isci/unsolicited_frame_control.h   |    2 +-
 10 files changed, 110 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_host
