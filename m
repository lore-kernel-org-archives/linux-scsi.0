From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [BK PATCH] Critical SCSI fixes for 2.6.11-rc2
Date: Tue, 01 Feb 2005 12:14:21 -0600
Message-ID: <1107281661.4800.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:5858 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262093AbVBASOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 13:14:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Following regression tests on BK latest, two critical problems have
turned up in the SCSI subsystem:

1) Hang using REQ_BLOCK_PC on CD/DVD
2) oops in transport classes with multiple HBAs

Could we do a quick include of this tree:

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

to pick up fixes for them?  Everything else in this tree is also a
regression bugfix (except the addition of the qla maintainer, which is a
documentation bugfix)

The tree contains:

Andrew Vasquez:
  o MAINTAINERS: add entry for qla2xxx driver

Douglas Gilbert:
  o fix scsi cdrom problem

James Bottomley:
  o Fix missed class_remove_file in attribute_container
  o SCSI: fix multiple HBA problem with transport classes
  o SCSI Fix oops with faulty DVD

Randy Dunlap:
  o gdth: fix module_param() type for 'irq'

and the diffstat is:

 MAINTAINERS                         |    6 ++
 drivers/base/attribute_container.c  |  108 +++++++++++++++++++++++++++++++++++-
 drivers/base/transport_class.c      |   25 +-------
 drivers/scsi/gdth.c                 |    2 
 drivers/scsi/scsi_lib.c             |   10 +--
 drivers/scsi/scsi_transport_fc.c    |   12 +++-
 drivers/scsi/scsi_transport_iscsi.c |   12 +++-
 drivers/scsi/scsi_transport_spi.c   |   15 ++++-
 drivers/scsi/sr.c                   |    1 
 include/linux/attribute_container.h |   12 ++++
 10 files changed, 166 insertions(+), 37 deletions(-)

James


