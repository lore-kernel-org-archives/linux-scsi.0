From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 0/5] st: increase maximum number of tapes beyond 128
Date: Mon, 21 May 2012 16:13:40 -0700
Message-ID: <4FBACC24.9080603@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

This patch set increases the maximum number of tape drives.  The device
limit of 128 tape drives was established in 2003 as a significant increase
from the 8 tape drives allowed previously.

We have seen many Linux sites that, between a large number of tape drives
and multipathing, are discovering more than 128 devices and are running
into problems.

This patch set cleans up some st code that made increasing the number
of drives costly, then actually increases the maximum number from 128
to 2^17 devices (based on the current code).

This patch set is based off of the scsi git tree.

Jeff Mahoney (5):
  st: Use static class attributes
  st: clean up dev cleanup in st_probe
  st: get rid of scsi_tapes array
  st: clean up device file creation and removal
  st: raise device limit

 drivers/scsi/st.c |  404 ++++++++++++++++++++++-------------------------------
 drivers/scsi/st.h |    4 +-
 2 files changed, 169 insertions(+), 239 deletions(-)

-- 
1.7.9.2
