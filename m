From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/4] Hyper-V TRIM support
Date: Fri, 13 Sep 2013 13:58:25 +0100
Message-ID: <1379077109-29606-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, devel@linuxdriverproject.org, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

tl;dr -- enable TRIM support for Hyper-V emulated disks.

The Hyper-V hypervisor can support TRIM for its devices, advertising this
via the appropriate VPD pages.  However the emulated disks only claim
to be SPC-2 devices.  According to the specs VPD pages (in general) did
exist at SPC-2 but the specific pages we interogate for the TRIM support
did not until SPC-3 therefore the kernel avoids reading the relevant pages
for SPC-2 devices and prevents TRIM from being offered for these devices.
Additionally at SPC-2 we prefer ReadCapacity10 over ReadCapacity16 and
unless we use RC16 we will not identify the device as TRIM capable also
preventing TRIM being offered.

As the VPD page zero does list which pages are valid for each device, it
could be argued that we could simply attempt to use these pages for all
devices which claim to be SPC-2 and above.  While this seems valid the
code documents a number of devices which take badly to having even VPD
page 0 interogated even when supposedly supported.  Therefore it seems
appropriate to add a scsi device flag to allow a device to request SPC-3
VPD pages be used when only at SPC-2.

Similarly for the ReadCapacity selection it seems dangerous to invert
the order for all SPC-2 devices.  So it seems appropriate to add a scsi
device flag to request we try RC16 before RC10 (mirroring the existing
flag for the opposite).

The following four patches add the two scsi device flags and select those
flags for the Hyper-V emulated disks.

Patches against v3.11.

Comments?

-apw

Andy Whitcroft (4):
  scsi: add scsi device flag to request VPD pages be used at SPC-2
  scsi: add scsi device flag to request READ CAPACITY (16) be preferred
  scsi: hyper-v storage -- mark as VPD capable at SPC-2
  scsi: hyper-v storage -- mark as preferring READ CAPACITY (16) at
    SPC-2

 drivers/scsi/sd.c          | 8 +++++++-
 drivers/scsi/storvsc_drv.c | 2 ++
 include/scsi/scsi_device.h | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
1.8.1.2
