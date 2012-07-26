From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/3] hpsa: Use LUN reset instead of target reset
Date: Thu, 26 Jul 2012 11:34:10 -0500
Message-ID: <20120726163410.25864.55403.stgit@beardog.cce.hp.com>
References: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It turns out Smart Array logical drives do not support target
reset and when the target reset fails, the logical drive will
be taken off line.  Symptoms look like this:

hpsa 0000:03:00.0: Abort request on C1:B0:T0:L0
hpsa 0000:03:00.0: resetting device 1:0:0:0
hpsa 0000:03:00.0: cp ffff880037c56000 is reported invalid (probably means target device no longer present)
hpsa 0000:03:00.0: resetting device failed.
sd 1:0:0:0: Device offlined - not ready after error recovery
sd 1:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sdb1): read_block_bitmap:

LUN reset is supported though, and is what we should be using.
Target reset is also disruptive in shared SAS situations,
for example, an external MSA1210m which does support target
reset attached to Smart Arrays in multiple hosts -- a target
reset from one host is disruptive to other hosts as all LUNs
on the target will be reset and will abort all outstanding i/os
back to all the attached hosts.  So we should use LUN reset,
not target reset.

Tested this with Smart Array logical drives and with tape drives.
Not sure how this bug survived since 2009, except it must be very
rare for a Smart Array to require more than 30s to complete a request.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..015a6c8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3265,7 +3265,7 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.Timeout = 0; /* Don't time out */
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] =  cmd;
-			c->Request.CDB[1] = 0x03;  /* Reset target above */
+			c->Request.CDB[1] = HPSA_RESET_TYPE_LUN;
 			/* If bytes 4-7 are zero, it means reset the */
 			/* LunID device */
 			c->Request.CDB[4] = 0x00;
