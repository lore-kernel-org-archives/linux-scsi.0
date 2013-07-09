From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 8/8] fcoe: Reduce number of sparse warnings
Date: Tue, 09 Jul 2013 12:47:47 -0700
Message-ID: <20130709194747.10724.77557.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3GITsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:48:06 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

From: Bart Van Assche <bvanassche@acm.org>

Declare local variables and functions 'static'. This patch does not
change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 8c05ae01..c9382d6 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -507,7 +507,7 @@ static const struct attribute_group *fcoe_fcf_attr_groups[] = {
 	NULL,
 };
 
-struct bus_type fcoe_bus_type;
+static struct bus_type fcoe_bus_type;
 
 static int fcoe_bus_match(struct device *dev,
 			  struct device_driver *drv)
@@ -541,25 +541,25 @@ static void fcoe_fcf_device_release(struct device *dev)
 	kfree(fcf);
 }
 
-struct device_type fcoe_ctlr_device_type = {
+static struct device_type fcoe_ctlr_device_type = {
 	.name = "fcoe_ctlr",
 	.groups = fcoe_ctlr_attr_groups,
 	.release = fcoe_ctlr_device_release,
 };
 
-struct device_type fcoe_fcf_device_type = {
+static struct device_type fcoe_fcf_device_type = {
 	.name = "fcoe_fcf",
 	.groups = fcoe_fcf_attr_groups,
 	.release = fcoe_fcf_device_release,
 };
 
-struct bus_attribute fcoe_bus_attr_group[] = {
+static struct bus_attribute fcoe_bus_attr_group[] = {
 	__ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store),
 	__ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store),
 	__ATTR_NULL
 };
 
-struct bus_type fcoe_bus_type = {
+static struct bus_type fcoe_bus_type = {
 	.name = "fcoe",
 	.match = &fcoe_bus_match,
 	.bus_attrs = fcoe_bus_attr_group,
@@ -569,7 +569,7 @@ struct bus_type fcoe_bus_type = {
  * fcoe_ctlr_device_flush_work() - Flush a FIP ctlr's workqueue
  * @ctlr: Pointer to the FIP ctlr whose workqueue is to be flushed
  */
-void fcoe_ctlr_device_flush_work(struct fcoe_ctlr_device *ctlr)
+static void fcoe_ctlr_device_flush_work(struct fcoe_ctlr_device *ctlr)
 {
 	if (!fcoe_ctlr_work_q(ctlr)) {
 		printk(KERN_ERR
@@ -590,8 +590,8 @@ void fcoe_ctlr_device_flush_work(struct fcoe_ctlr_device *ctlr)
  * Return value:
  *	1 on success / 0 already queued / < 0 for error
  */
-int fcoe_ctlr_device_queue_work(struct fcoe_ctlr_device *ctlr,
-			       struct work_struct *work)
+static int fcoe_ctlr_device_queue_work(struct fcoe_ctlr_device *ctlr,
+				       struct work_struct *work)
 {
 	if (unlikely(!fcoe_ctlr_work_q(ctlr))) {
 		printk(KERN_ERR
@@ -609,7 +609,7 @@ int fcoe_ctlr_device_queue_work(struct fcoe_ctlr_device *ctlr,
  * fcoe_ctlr_device_flush_devloss() - Flush a FIP ctlr's devloss workqueue
  * @ctlr: Pointer to FIP ctlr whose workqueue is to be flushed
  */
-void fcoe_ctlr_device_flush_devloss(struct fcoe_ctlr_device *ctlr)
+static void fcoe_ctlr_device_flush_devloss(struct fcoe_ctlr_device *ctlr)
 {
 	if (!fcoe_ctlr_devloss_work_q(ctlr)) {
 		printk(KERN_ERR
@@ -631,9 +631,9 @@ void fcoe_ctlr_device_flush_devloss(struct fcoe_ctlr_device *ctlr)
  * Return value:
  *	1 on success / 0 already queued / < 0 for error
  */
-int fcoe_ctlr_device_queue_devloss_work(struct fcoe_ctlr_device *ctlr,
-				       struct delayed_work *work,
-				       unsigned long delay)
+static int fcoe_ctlr_device_queue_devloss_work(struct fcoe_ctlr_device *ctlr,
+					       struct delayed_work *work,
+					       unsigned long delay)
 {
 	if (unlikely(!fcoe_ctlr_devloss_work_q(ctlr))) {
 		printk(KERN_ERR

