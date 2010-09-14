From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/7] BKL mass-conversion to mutex
Date: Tue, 14 Sep 2010 21:53:35 +0200
Message-ID: <1284494022-7346-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: linux-kernel@vger.kernel.org
Cc: Corey Minyard <minyard@acm.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linuxppc-dev@ozlabs.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-mtd@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, openipmi-developer@lists.sourceforge.net, David Woodhouse <David.Woodhouse@intel.com>
List-Id: linux-scsi@vger.kernel.org

This is one out of five topic branches in my BKL removal
series that I would like to get into linux-next as
a preparation for merging into 2.6.37.

Based on a discussion with Ingo Molnar, this series converts
many drivers that only have a single file using the BKL
to use a private mutex instead.  All these patches except for
the last two have been reviewed before.

This is safe because they all use the BKL only to protect
their basic file operations and they take it as the
outermost lock. Consequently, we do not run into lock-order
problem or recursion.

Using a script that works for all these drivers gives
me reasonable confidence in the approach, since it avoids
typos and other common mistakes from sloppiness.

Stephen, please add
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git trivial

Arnd Bergmann (7):
  scsi: autoconvert trivial BKL users to private mutex
  mtd: autoconvert trivial BKL users to private mutex
  mac: autoconvert trivial BKL users to private mutex
  ipmi: autoconvert trivial BKL users to private mutex
  drivers: autoconvert trivial BKL users to private mutex
  sound: autoconvert trivial BKL users to private mutex
  block: autoconvert trivial BKL users to private mutex

 block/bsg.c                                |    3 --
 drivers/block/DAC960.c                     |   11 ++++---
 drivers/block/amiflop.c                    |   19 ++++++------
 drivers/block/aoe/aoeblk.c                 |    9 +++--
 drivers/block/aoe/aoechr.c                 |    9 +++--
 drivers/block/ataflop.c                    |   15 +++++----
 drivers/block/brd.c                        |    7 ++--
 drivers/block/cciss.c                      |   14 ++++----
 drivers/block/cpqarray.c                   |   15 +++++----
 drivers/block/drbd/drbd_main.c             |   11 ++++---
 drivers/block/floppy.c                     |   16 +++++-----
 drivers/block/loop.c                       |   11 ++++---
 drivers/block/nbd.c                        |    7 ++--
 drivers/block/paride/pcd.c                 |   15 +++++----
 drivers/block/paride/pd.c                  |   15 +++++----
 drivers/block/paride/pf.c                  |   17 ++++++-----
 drivers/block/paride/pg.c                  |    7 ++--
 drivers/block/paride/pt.c                  |   19 ++++++------
 drivers/block/pktcdvd.c                    |   16 +++++-----
 drivers/block/swim.c                       |   15 +++++----
 drivers/block/swim3.c                      |   15 +++++----
 drivers/block/ub.c                         |   15 +++++----
 drivers/block/viodasd.c                    |   11 ++++---
 drivers/block/virtio_blk.c                 |    7 ++--
 drivers/block/xd.c                         |    7 ++--
 drivers/block/xen-blkfront.c               |   11 ++++---
 drivers/block/xsysace.c                    |   11 ++++---
 drivers/block/z2ram.c                      |   15 +++++----
 drivers/cdrom/gdrom.c                      |   15 +++++----
 drivers/cdrom/viocd.c                      |   15 +++++----
 drivers/char/apm-emulation.c               |   11 ++++---
 drivers/char/applicom.c                    |    9 +++--
 drivers/char/ds1302.c                      |   15 +++++----
 drivers/char/ds1620.c                      |    8 ++--
 drivers/char/dsp56k.c                      |   27 +++++++++--------
 drivers/char/dtlk.c                        |    8 ++--
 drivers/char/generic_nvram.c               |    7 ++--
 drivers/char/genrtc.c                      |   13 ++++----
 drivers/char/i8k.c                         |    7 ++--
 drivers/char/ip2/ip2main.c                 |    8 ++--
 drivers/char/ipmi/ipmi_devintf.c           |   14 ++++----
 drivers/char/ipmi/ipmi_watchdog.c          |    8 ++--
 drivers/char/lp.c                          |   15 +++++----
 drivers/char/mbcs.c                        |    8 ++--
 drivers/char/mmtimer.c                     |    7 ++--
 drivers/char/mwave/mwavedd.c               |   44 ++++++++++++++--------------
 drivers/char/nvram.c                       |   11 ++++---
 drivers/char/nwflash.c                     |   12 ++++----
 drivers/char/pcmcia/cm4000_cs.c            |   11 ++++---
 drivers/char/pcmcia/cm4040_cs.c            |    7 ++--
 drivers/char/ppdev.c                       |    8 ++--
 drivers/char/rio/rio_linux.c               |    7 ++--
 drivers/char/snsc.c                        |    9 +++--
 drivers/char/toshiba.c                     |    9 +++--
 drivers/char/viotape.c                     |   11 ++++---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    6 ++--
 drivers/hwmon/fschmd.c                     |    6 ++--
 drivers/hwmon/w83793.c                     |    6 ++--
 drivers/ide/ide-cd.c                       |   14 ++++----
 drivers/ide/ide-disk_ioctl.c               |    7 ++--
 drivers/ide/ide-floppy_ioctl.c             |    7 ++--
 drivers/ide/ide-gd.c                       |   10 +++---
 drivers/ide/ide-tape.c                     |   19 ++++++------
 drivers/input/misc/hp_sdc_rtc.c            |    7 ++--
 drivers/macintosh/adb.c                    |   10 +++---
 drivers/macintosh/smu.c                    |    6 ++--
 drivers/macintosh/via-pmu.c                |   11 ++++---
 drivers/md/dm.c                            |   10 +++---
 drivers/md/md.c                            |   13 ++++----
 drivers/memstick/core/mspro_block.c        |   11 ++++---
 drivers/message/fusion/mptctl.c            |   15 +++++----
 drivers/message/i2o/i2o_block.c            |   15 +++++----
 drivers/message/i2o/i2o_config.c           |   23 +++++++-------
 drivers/misc/phantom.c                     |   11 ++++---
 drivers/mmc/card/block.c                   |   10 +++---
 drivers/mtd/mtd_blkdevs.c                  |   14 ++++----
 drivers/mtd/mtdchar.c                      |   15 +++++----
 drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
 drivers/rtc/rtc-m41t80.c                   |   13 ++++----
 drivers/s390/char/tape_block.c             |   13 ++++----
 drivers/sbus/char/jsflash.c                |   24 ++++++++-------
 drivers/scsi/3w-9xxx.c                     |    7 ++--
 drivers/scsi/3w-sas.c                      |    7 ++--
 drivers/scsi/3w-xxxx.c                     |    9 ++---
 drivers/scsi/aacraid/linit.c               |   15 +++++----
 drivers/scsi/ch.c                          |    8 ++--
 drivers/scsi/dpt_i2o.c                     |   18 ++++++------
 drivers/scsi/gdth.c                        |   11 ++++---
 drivers/scsi/megaraid.c                    |    8 ++--
 drivers/scsi/megaraid/megaraid_mm.c        |    8 ++--
 drivers/scsi/megaraid/megaraid_sas.c       |    2 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   11 ++++---
 drivers/scsi/osst.c                        |   15 +++++----
 drivers/scsi/scsi_tgt_if.c                 |    2 -
 drivers/scsi/sg.c                          |   11 ++++---
 drivers/scsi/sr.c                          |   14 ++++----
 drivers/scsi/st.c                          |   12 ++++----
 drivers/staging/hv/blkvsc_drv.c            |   11 ++++---
 drivers/staging/spectra/ffsport.c          |    7 ++--
 drivers/telephony/ixj.c                    |    7 ++--
 drivers/watchdog/cpwd.c                    |   15 +++++----
 fs/hfsplus/ioctl.c                         |   11 ++++---
 sound/oss/au1550_ac97.c                    |   30 +++++++++---------
 sound/oss/dmasound/dmasound_core.c         |   41 +++++++++++++------------
 sound/oss/msnd_pinnacle.c                  |   15 +++++----
 sound/oss/sh_dac_audio.c                   |   13 ++++----
 sound/oss/soundcard.c                      |   41 +++++++++++++------------
 sound/oss/swarm_cs4297a.c                  |   20 ++++++------
 sound/oss/vwsnd.c                          |   30 +++++++++---------
 109 files changed, 718 insertions(+), 657 deletions(-)

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-mtd@lists.infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
Cc: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
