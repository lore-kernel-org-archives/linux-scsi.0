From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH] scsi: storvsc: missing error code in storvsc_probe()
Date: Thu,  8 Feb 2018 16:50:40 -0700
Message-ID: <20180208235040.5803-1-longli@exchange.microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Long Li <longli@microsoft.com>, Dan Carpenter <dan.carpenter@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patch backports upstream commit ca8dc694045e9aa248e9916e0f614deb0494cb3d
for 4.14-stable.

commit ca8dc694045e9aa248e9916e0f614deb0494cb3d:

We should set the error code if fc_remote_port_add() fails.

Cc: <stable@vger.kernel.org> #v4.12+
Fixes: daf0cd445a21 ("scsi: storvsc: Add support for FC rport.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Cathy Avery <cavery@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5e7200f..c17ccb9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1826,8 +1826,10 @@ static int storvsc_probe(struct hv_device *device,
 		fc_host_node_name(host) = stor_device->node_name;
 		fc_host_port_name(host) = stor_device->port_name;
 		stor_device->rport = fc_remote_port_add(host, 0, &ids);
-		if (!stor_device->rport)
+		if (!stor_device->rport) {
+			ret = -ENOMEM;
 			goto err_out3;
+		}
 	}
 #endif
 	return 0;
-- 
2.7.4
