From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/17] hpsa: suppress excessively chatty error messages
Date: Fri, 20 Apr 2012 10:06:34 -0500
Message-ID: <20120420150634.10596.30524.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
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
index 906672b..fcb9fb2 100644
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
