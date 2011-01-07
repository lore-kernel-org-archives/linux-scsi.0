From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/3] hpsa: fix use of uninitialized variable in
	hpsa_add_msa2xxx_enclosure_device()
Date: Fri, 07 Jan 2011 10:55:43 -0600
Message-ID: <20110107165543.14259.80663.stgit@beardog.cce.hp.com>
References: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclosure_device()

Thanks to Scott Teel for noticing this.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c255f46..c6c13b0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1617,6 +1617,8 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (lun == 0) /* if lun is 0, then obviously we have a lun 0. */
 		return 0;
 
+	memset(scsi3addr, 0, 8);
+	scsi3addr[3] = target;
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
@@ -1631,8 +1633,6 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 		return 0;
 	}
 
-	memset(scsi3addr, 0, 8);
-	scsi3addr[3] = target;
 	if (hpsa_update_device_info(h, scsi3addr, this_device))
 		return 0;
 	(*nmsa2xxx_enclosures)++;
