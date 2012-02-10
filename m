From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 07/13] scsi_transport_sas: 'enable' phys on reset
Date: Fri, 10 Feb 2012 00:45:15 -0800
Message-ID: <20120210084515.25701.23144.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If userspace requests a phy reset, treat that as a request for the phy
to be enabled since that is the effect on hardware.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_transport_sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 7d69a25..f7565fc 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -615,6 +615,7 @@ do_sas_phy_reset(struct device *dev, size_t count, int hard_reset)
 	error = i->f->phy_reset(phy, hard_reset);
 	if (error)
 		return error;
+	phy->enabled = 1;
 	return count;
 };
 

