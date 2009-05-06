From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 6/10] scsi: megaraid_sas - Report the Unconfigured PD
 (system PD) to OS
Date: Tue, 5 May 2009 19:35:42 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C5D@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C55@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:43816 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZEFBgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 21:36:37 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C55@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Report the Un-configured PD (system PD) to OS.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   57 +++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:24:19.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:30:02.000000000 -0400
@@ -1114,24 +1114,45 @@ megasas_queue_command(struct scsi_cmnd *
        return 0;
 }

+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+       int i;
+
+       for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+               if ((megasas_mgmt_info.instance[i]) &&
+                   (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+                       return megasas_mgmt_info.instance[i];
+       }
+
+       return NULL;
+}
+
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
-       /*
-        * Don't export physical disk devices to the disk driver.
-        *
-        * FIXME: Currently we don't export them to the midlayer at all.
-        *        That will be fixed once LSI engineers have audited the
-        *        firmware for possible issues.
-        */
-       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
+       u16                     pd_index = 0;
+       struct megasas_instance *instance;
+       instance = megasas_lookup_instance(sdev->host->host_no);
+
+        /* only export system physical disk devices to the midlayer */
+       if ((sdev->channel < MEGASAS_MAX_PD_CHANNELS) &&
+                       (sdev->type == TYPE_DISK)) {
+               pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+                               sdev->id;
+               if ((instance->pd_list[pd_index].driveState ==
+                       MR_PD_STATE_SYSTEM)) {
+                       blk_queue_rq_timeout(sdev->request_queue,
+                                       MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+                       return 0;
+               }
                return -ENXIO;
+       }

        /*
         * The RAID firmware may require extended timeouts.
         */
-       if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-               blk_queue_rq_timeout(sdev->request_queue,
-                                    MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+       blk_queue_rq_timeout(sdev->request_queue,
+                            MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
        return 0;
 }

@@ -3453,20 +3474,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
        return error;
 }

-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-       int i;
-
-       for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-               if ((megasas_mgmt_info.instance[i]) &&
-                   (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-                       return megasas_mgmt_info.instance[i];
-       }
-
-       return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
        struct megasas_iocpacket __user *user_ioc =
