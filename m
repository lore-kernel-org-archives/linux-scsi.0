From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/4] scsi: storvsc: Fix a bug in the layout of the
 hv_fc_wwn_packet
Date: Thu, 10 Dec 2015 16:14:17 -0800
Message-ID: <1449792860-15447-1-git-send-email-kys@microsoft.com>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449792829-15406-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

The hv_fc_wwn_packet is exchanged over vmbus. Make the definition in Linux match
the Window's definition.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index c41f674..00bb4bd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -92,9 +92,8 @@ enum vstor_packet_operation {
  */
 
 struct hv_fc_wwn_packet {
-	bool	primary_active;
-	u8	reserved1;
-	u8	reserved2;
+	u8	primary_active;
+	u8	reserved1[3];
 	u8	primary_port_wwn[8];
 	u8	primary_node_wwn[8];
 	u8	secondary_port_wwn[8];
-- 
1.7.4.1
