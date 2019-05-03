From: Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 1/3] ibmvscsi: Wire up host_reset() in the drivers
 scsi_host_template
Date: Thu,  2 May 2019 19:50:56 -0500
Message-ID: <20190503005058.8768-1-tyreld@linux.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: james.bottomley@hansenpartnership.com
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Wire up the host_reset function in our driver_template to allow a user
requested adpater reset via the host_reset sysfs attribute.

Example:

echo "adapter" > /sys/class/scsi_host/host0/host_reset

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
Changes in v2:
	removed interrupt disabe/enable around reset

 drivers/scsi/ibmvscsi/ibmvscsi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 8cec5230fe31..65fc8ca962c5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2050,6 +2050,16 @@ static struct device_attribute ibmvscsi_host_config = {
 	.show = show_host_config,
 };
 
+static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
+{
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
+
+	dev_info(hostdata->dev, "Initiating adapter reset!\n");
+	ibmvscsi_reset_host(hostdata);
+
+	return 0;
+}
+
 static struct device_attribute *ibmvscsi_attrs[] = {
 	&ibmvscsi_host_vhost_loc,
 	&ibmvscsi_host_vhost_name,
@@ -2076,6 +2086,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler = ibmvscsi_eh_host_reset_handler,
 	.slave_configure = ibmvscsi_slave_configure,
 	.change_queue_depth = ibmvscsi_change_queue_depth,
+	.host_reset = ibmvscsi_host_reset,
 	.cmd_per_lun = IBMVSCSI_CMDS_PER_LUN_DEFAULT,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
-- 
2.18.1
