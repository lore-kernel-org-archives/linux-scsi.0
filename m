From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Fri, 10 Oct 2014 08:49:01 +0100
Message-ID: <20141010074901.GA32028@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance
even though they implement post SPC-2 features (such as thin
provisioning) which means the Linux kernel does not go on to test for
those features even though they are advertised.

A previous patch attempted to add a quirk to workaround this but the
quirk was only enabled after the features had been scanned for, wouldn't
work for "small" disks and would quirk on  all Hyper-V SCSI devices
(e.g. passthrough disks).

The new patches partially revert the previous effort, add the quirk in a
more traditional manner to only Hyper-V virtual disks and work on small
virtual disks.

Sitsofe Wheeler (3):
  Revert "Drivers: add blist flags"
  scsi: add try_rc16 blacklist flag
  scsi: Use try_rc16 and try_vpd_pages quirks on Hyper-V virtual disks

 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/scsi_scan.c    |  3 +++
 drivers/scsi/sd.c           |  3 +++
 drivers/scsi/storvsc_drv.c  | 10 ----------
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  1 +
 6 files changed, 9 insertions(+), 10 deletions(-)

-- 
1.9.3
