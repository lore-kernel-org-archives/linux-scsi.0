From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 07/36] scsi: lpfc: fix remoteport access
Date: Thu, 22 Nov 2018 14:52:11 -0500
Message-ID: <20181122195240.13123-7-sashal@kernel.org>
References: <20181122195240.13123-1-sashal@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122195240.13123-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f8d294324598ec85bea2779512e48c94cbe4d7c6 ]

The addition of a spinlock in lpfc_debugfs_nodelist_data() introduced
a bug that lets us not skip NULL pointers correctly, as noticed by
gcc-8:

drivers/scsi/lpfc/lpfc_debugfs.c: In function 'lpfc_debugfs_nodelist_data.constprop':
drivers/scsi/lpfc/lpfc_debugfs.c:728:13: error: 'nrport' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)

This changes the logic back to what it was, while keeping the added
spinlock.

Fixes: 9e210178267b ("scsi: lpfc: Synchronize access to remoteport via rport")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index aec5b10a8c85..ca6c3982548d 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -700,6 +700,8 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
+		else
+			nrport = NULL;
 		spin_unlock(&phba->hbalock);
 		if (!nrport)
 			continue;
-- 
2.17.1
