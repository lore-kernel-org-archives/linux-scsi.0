From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] storvsc_drv: make use of the lightweight FC transport
 class
Date: Fri, 18 Mar 2016 15:42:30 -0700
Message-ID: <1458340950.2892.9.camel@HansenPartnership.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
 <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
 <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq14mc6dpbu.fsf@sermon.lab.mkp.net>
 <1458169666.4793.62.camel@HansenPartnership.com>
 <SN2PR03MB2142B8D8C2B1831522F6EB1AA08A0@SN2PR03MB2142.namprd03.prod.outlook.com>
 <1458171653.4793.68.camel@HansenPartnership.com>
 <SN2PR03MB2142C30620CAC6F633AAFB52A08B0@SN2PR03MB2142.namprd03.prod.outlook.com>
 <1458340866.2892.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1458340866.2892.7.camel@HansenPartnership.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: James Bottomley <jejb@linux.vnet.ibm.com>
---
 drivers/scsi/storvsc_drv.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3ddcabb..dcb7393 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1769,21 +1769,16 @@ static int __init storvsc_drv_init(void)
 		sizeof(u64)));
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
-	fc_transport_template = fc_attach_transport(&fc_transport_functions);
+	fc_transport_template = fc_lw_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
-
-	/*
-	 * Install Hyper-V specific timeout handler.
-	 */
-	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 	if (ret)
-		fc_release_transport(fc_transport_template);
+		fc_lw_release_transport(fc_transport_template);
 #endif
 
 	return ret;
@@ -1793,7 +1788,7 @@ static void __exit storvsc_drv_exit(void)
 {
 	vmbus_driver_unregister(&storvsc_drv);
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
-	fc_release_transport(fc_transport_template);
+	fc_lw_release_transport(fc_transport_template);
 #endif
 }
 
-- 
2.6.2
