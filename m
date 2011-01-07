From: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 0/8] adding support to FCoE transport
Date: Fri, 07 Jan 2011 09:42:24 -0800
Message-ID: <20110107174027.14631.47077.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is the RFC v2 of adding fcoe transport to support vendor specific FCoE
transport into the existing Open-FCoE framework.

v1:
Initial post for adding fcoe transport:
https://lists.open-fcoe.org/pipermail/devel/2010-December/010865.html
Follow-up comments & discussions:
https://lists.open-fcoe.org/pipermail/devel/2011-January/010890.html

v2:
1. Per Joe's comment, renamed the libfcoe_fip.c to be fcoe_ctlr.c. I
also renamed the new ibfcoe_transport.c to be fcoe_transport.c.
2. Per Bhanu's comment, I have merged the three follow-up patches
from Bhanu with the following changes in fcoe_parse_buffer():
a) Though not a problem of the existing fcoe-util since the sysfs
entry is changing to libfcoe anyway, I still want to fill the buffer
of drv_name with default "fcoe" so default behavior is still the same
w/o changing cfg-ethx.
b) Fixed the '\n' ending in the input buffer in fcoe_parse_buffer, we still
need that proper formatting logic from the original fcoe_if_to_netdev(),
otherwise the ifname and drv_name will be messed up, causing the lookup for
netdev and transport to fail.

Testing Notes:
Did the checkpatch and tested w/ overnight stress FCoE traffic on 2 LUNs using
fcoe.ko as the default fcoe transport, that seems to be working ok. However,
loop create/destroy testing is needed before this gets committed eventually.

thanks,
yi

---

Yi Zou (8):
      fcoe: convert fcoe.ko to become an fcoe transport provider driver
      fcoe: prepare fcoe for using fcoe transport
      libfcoe: include fcoe_transport.c into kernel libfcoe module
      libfcoe: remove libfcoe.c, use the same fcoe_ctlr.c instead
      libfcoe: rename libfcoe.c to fcoe_cltr.c for the coming fcoe_transport.c
      libfcoe: add implementation to support fcoe transport
      libfcoe: add fcoe_transport structure defines to include/scsi/libfcoe.h
      libfcoe: move logging macros into the local libfcoe.h header file


 drivers/scsi/fcoe/Makefile         |    2 
 drivers/scsi/fcoe/fcoe.c           |  183 +-
 drivers/scsi/fcoe/fcoe_ctlr.c      | 2682 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c |  548 +++++++
 drivers/scsi/fcoe/libfcoe.c        | 2708 ------------------------------------
 drivers/scsi/fcoe/libfcoe.h        |   31 
 include/scsi/libfcoe.h             |   43 +
 7 files changed, 3367 insertions(+), 2830 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe_ctlr.c
 create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
 delete mode 100644 drivers/scsi/fcoe/libfcoe.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.h

-- 
Signature: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
