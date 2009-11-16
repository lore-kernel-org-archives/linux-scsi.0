From: Arnd Bergmann <arnd@arndb.de>
Subject: [uml-user] [PATCH 00/12] move compat_ioctl handling into drivers
Date: Mon, 16 Nov 2009 00:26:55 +0000
Message-ID: <1258331227-1694-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <user-mode-linux-user-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-user>,
	<mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=user-mode-linux-user>
List-Post: <mailto:user-mode-linux-user@lists.sourceforge.net>
List-Help: <mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-user>,
	<mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=subscribe>
Errors-To: user-mode-linux-user-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Paul Clements <Paul.Clements@steeleye.com>, Andre Noll <maan@systemlinux.org>, Pavel Machek <pavel@suse.cz>, linux-i2c@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jan Blunck <jblunck@suse.de>, Ian Kent <raven@themaw.net>, Nick Piggin <npiggin@suse.de>, user-mode-linux-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Alon Bar-Lev <alon.barlev@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Doug Gilbert <dgilbert@interlog.com>, David Vrabel <david.vrabel@csr.com>, Alexey Dobriyan <adobriyan@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Jeff Dike <jdike@addtoit.com>, Oliver Neukum <oliver@neukum.org>, linux-raid@vger.kernel.org, Tejun
List-Id: linux-scsi@vger.kernel.org

This is the second series of patches on compat_ioctl handling,
moving compat handlers into more drivers. Most of these
patches consist on a part that adds a compat_ioctl method
in one driver and another part removing the respective
section from fs/compat_ioctl.c. The fs/compat_ioctl.c
portion depends on other patches[1], but the driver code can
be applied independently.

If some of you feel responsible for the code I patched, please
look at my changes and if they are ok, either take them into
your tree or give me an Acked-by for them.

I have tested the patches for sg, usbdevfs and autofs, which
was easily done in qemu, but I'm lacking test cases for
most of the other ones.

	Arnd <><

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andre Noll <maan@systemlinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs@linux.kernel.org
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ian Kent <raven@themaw.net>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Jan Blunck <jblunck@suse.de>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
Cc: Wolfram Sang <w.sang@pengutronix.de>

Arnd Bergmann (12):
  arch/um: handle compat_ioctl in tty line driver
  scsi/sg: move compat_ioctl handling into sg driver
  autofs/autofs4: move compat_ioctl handling into fs
  raw: partly fix compat_ioctl handling on non-x86
  nbd: add compat_ioctl method
  smbfs: do compat_ioctl handling in place
  i2cdev: move compat_ioctl handling into driver
  md: move compat_ioctl handling into md.c
  lp: move compat_ioctl handling into lp.c
  usbdevfs: move compat_ioctl handling to devio.c
  hamradio/mkiss: fix typo in compat_ioctl
  compat_ioctl: remove unused handlers

 arch/um/drivers/line.c          |    6 +
 arch/um/drivers/ssl.c           |    1 +
 arch/um/drivers/stdio_console.c |    1 +
 arch/um/include/shared/line.h   |    2 +
 drivers/block/nbd.c             |    7 +-
 drivers/char/lp.c               |  115 +++++++--
 drivers/char/raw.c              |  157 ++++++++++---
 drivers/i2c/i2c-dev.c           |  117 +++++++++
 drivers/md/md.c                 |   23 ++
 drivers/net/hamradio/mkiss.c    |    2 +-
 drivers/scsi/sg.c               |  182 ++++++++++++++-
 drivers/usb/core/devio.c        |  110 ++++++++-
 fs/autofs/root.c                |   67 +++++-
 fs/autofs4/root.c               |   69 +++++-
 fs/compat_ioctl.c               |  504 +--------------------------------------
 fs/smbfs/dir.c                  |    5 +-
 fs/smbfs/file.c                 |    3 +-
 fs/smbfs/ioctl.c                |   48 ++++-
 fs/smbfs/proto.h                |    3 +-
 include/linux/auto_fs.h         |    1 +
 include/linux/usbdevice_fs.h    |   26 ++
 kernel/trace/blktrace.c         |    1 +
 22 files changed, 856 insertions(+), 594 deletions(-)

[1] http://patchwork.kernel.org/bundle/arnd/compat-ioctl-cleanup/?state=*

------------------------------------------------------------------------------
Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
trial. Simplify your report design, integration and deployment - and focus on 
what you do best, core application coding. Discover what's new with
Crystal Reports now.  http://p.sf.net/sfu/bobj-july
