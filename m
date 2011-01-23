From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 0/3] libata bug fixes and updates as a precursor for
 converting libsas to the new eh
Date: Sun, 23 Jan 2011 08:26:46 -0600
Message-ID: <1295792806.3007.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

While I was playing around with converting libsas to the new error
handler, I ran into the two locking bugs and the fact that sas uses non
standard submission paths.  These patches fix all of that.  In theory,
the error handler locking bug is serious, since the eh_cmd_q list is
being processed on the wrong lock, but in practise, since libata has one
host per port, I don't think it will ever have any visible consequence
(until, of course, libsas comes along with multiple ports per host plus
non-libata ports).

James

---

James Bottomley (3):
  libata: plumb sas port scan into standard libata paths
  libata: fix locking for sas paths
  libata: fix eh locking

 drivers/ata/libata-core.c |   46 +++++++++++++++++++++-----------------------
 drivers/ata/libata-eh.c   |    9 ++++++-
 drivers/ata/libata-scsi.c |    4 +-
 drivers/ata/libata.h      |    1 +
 4 files changed, 32 insertions(+), 28 deletions(-)


