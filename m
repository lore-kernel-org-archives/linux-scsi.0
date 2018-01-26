From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH resend 0/6] Fix cdrom autoclose
Date: Fri, 26 Jan 2018 17:58:34 +0100
Message-ID: <cover.1516985620.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <cover.1513263482.git.msuchanek@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

  there is cdrom autoclose feature that is supposed to close the tray, wait for
  the disc to become ready, and then open the device.

  This used to work in ancient times. Then in old times there was a hack in
  util-linux which worked around the breakage which probably resulted from
  switching to scsi emulation.

  Currently util-linux maintainer refuses to merge another hack on the basis that
  kernel still has the feature so it should be fixed there. Indeed, to implement
  this feature effectively from userspace one would need to know when the CD-ROM
  is in the "drive becoming ready" state which is knowledge that never leaves the
  hardware-specific driver and is passed neither to userspace nor the generic
  cdrom driver.

  So this patchset fixes the kernel autoclose implementation in cdrom.c and to
  do so reports the "drive becoming ready" state from the harware specific
  drivers.

First time I did not get any feedback for the patches. I found a defect in
tray_close - it used status function without checking it exists. So resending
with the defect corrected.

Michal Suchanek (6):
  delay: add poll_event_interruptible
  cdrom: factor out common open_for_* code
  cdrom: wait for tray to close
  cdrom: introduce CDS_DRIVE_ERROR
  Documentetion: cdrom: introduce CDS_DRIVE_ERROR
  cdrom: wait for drive to become ready

 Documentation/cdrom/cdrom-standard.tex |   8 ++-
 Documentation/cdrom/ide-cd             |   6 ++
 Documentation/ioctl/cdrom.txt          |   1 +
 drivers/block/paride/pcd.c             |   2 +-
 drivers/cdrom/cdrom.c                  | 124 ++++++++++++++++-----------------
 drivers/cdrom/gdrom.c                  |   2 +-
 drivers/ide/ide-cd_ioctl.c             |  12 ++--
 drivers/scsi/sr_ioctl.c                |   2 +-
 include/linux/delay.h                  |  12 ++++
 include/uapi/linux/cdrom.h             |   1 +
 10 files changed, 99 insertions(+), 71 deletions(-)

-- 
2.13.6

