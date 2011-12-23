From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 21/28] libsas: Remove redundant phy state notification
 calls.
Date: Thu, 22 Dec 2011 19:00:18 -0800
Message-ID: <20111223030018.21827.61229.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-ide@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

In the case of an explicit sas_phy_enable call to disable a phy,
the LLDD provides the calls to sas_phy_disconnected and the
PHYE_LOSS_OF_SIGNAL event.

NOTE: This assumes that the lldd(s) generate the notification, which
appears to be the case, but only verfied on isci.

Cc: Jack Wang <jack_wang@usish.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index ca080a8..075927e 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -268,11 +268,8 @@ static int sas_phy_enable(struct sas_phy *phy, int enable)
 
 		if (enable)
 			ret = transport_sas_phy_reset(phy, 0);
-		else {
-			sas_phy_disconnected(asd_phy);
-			sas_ha->notify_phy_event(asd_phy, PHYE_LOSS_OF_SIGNAL);
+		else
 			ret = i->dft->lldd_control_phy(asd_phy, cmd, NULL);
-		}
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);

