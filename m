From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/17] hpsa: suppress excessively chatty error messages
Date: Tue, 01 May 2012 11:42:25 -0500
Message-ID: <20120501164225.11705.57383.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Default behavior for any CHECK CONDITION excepting a few special cases is to
print out certain parts of the sense buffer and the CDB.  Default behavior
should be to print nothing and let the upper layers or applications decide what
to do about these.  The same information is already available by setting the
appropriate bits of the scsi_logging_level kernel parameter or via
/proc/sys/dev/scsi/logging_level.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ab16c16..9e09717 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1193,7 +1193,7 @@ static void complete_scsi_command(struct CommandList *cp)
 				break;
 			}
 			/* Must be some other type of check condition */
-			dev_warn(&h->pdev->dev, "cp %p has check condition: "
+			dev_dbg(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 					"Returning result: 0x%x, "
