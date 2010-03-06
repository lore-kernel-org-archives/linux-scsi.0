From: <kgudipat@brocade.com>
Subject: [PATCH 21/23] bfa: Support vport create/delete from sysfs.
Date: Fri, 5 Mar 2010 19:38:36 -0800
Message-ID: <1267846716-23559-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:18095 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0CFDip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:38:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Made changes to handle vport creation/deletion from sysfs.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c |  104 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d97f691..d20d223 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -584,6 +584,106 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
 }
 
+static int
+bfad_im_parse_wwn(const char *buf, u8 *wwn)
+{
+	unsigned int i, j;
+	memset(wwn, 0, 8);
+
+	/* Validate and store the new name */
+	for (i = 0, j = 0; i < 16; i++) {
+		if ((*buf >= '0') && (*buf <= '9'))
+			j = ((j << 4) | (*buf++ - '0'));
+		else if ((*buf >= 'a') && (*buf <= 'f'))
+			j = ((j << 4) | ((*buf++ - 'a') + 10));
+		else if ((*buf >= 'A') && (*buf <= 'F'))
+			j = ((j << 4) | ((*buf++ - 'A') + 10));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t
+bfad_im_vport_create(struct device *cdev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfa_port_cfg_s port_cfg;
+	u8 wwn[8];
+	int status;
+
+	memset(&port_cfg, 0, sizeof(port_cfg));
+	status = bfad_im_parse_wwn(&buf[0], wwn);
+	if (status)
+		return status;
+	memcpy(&port_cfg.pwwn, wwn, sizeof(wwn));
+
+	status = bfad_im_parse_wwn(&buf[17], wwn);
+	if (status)
+		return status;
+	memcpy(&port_cfg.nwwn, wwn, sizeof(wwn));
+
+	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
+	status = bfad_vport_create(bfad, 0, &port_cfg);
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t
+bfad_im_vport_delete(struct device *cdev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(cdev);
+	struct bfad_im_port_s *im_port =
+		(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	u8 wwn[8];
+	int status;
+	unsigned long flags;
+	struct bfa_fcs_vport_s *fcs_vport;
+	struct bfad_vport_s *bfad_vport;
+	struct completion fcomp;
+
+	status = bfad_im_parse_wwn(&buf[0], wwn);
+	if (status)
+		return status;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, *(wwn_t *)wwn);
+	if (fcs_vport == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return -EINVAL;
+	}
+
+	bfad_vport = fcs_vport->vport_drv;
+	bfad_vport->drv_port.flags |= BFAD_PORT_DELETE;
+	bfad_vport->comp_del = &fcomp;
+	init_completion(bfad_vport->comp_del);
+
+	status = bfa_fcs_vport_delete(fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	wait_for_completion(bfad_vport->comp_del);
+
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	bfad_os_scsi_host_free(bfad, bfad_vport->drv_port.im_port);
+	kfree(bfad_vport);
+	return count;
+}
+
 static          DEVICE_ATTR(serial_number, S_IRUGO,
 				bfad_im_serial_num_show, NULL);
 static          DEVICE_ATTR(model, S_IRUGO, bfad_im_model_show, NULL);
@@ -605,6 +705,8 @@ static          DEVICE_ATTR(number_of_ports, S_IRUGO,
 static          DEVICE_ATTR(driver_name, S_IRUGO, bfad_im_drv_name_show, NULL);
 static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
 				bfad_im_num_of_discovered_ports_show, NULL);
+static		DEVICE_ATTR(vport_create, S_IWUSR, NULL, bfad_im_vport_create);
+static		DEVICE_ATTR(vport_delete, S_IWUSR, NULL, bfad_im_vport_delete);
 
 struct device_attribute *bfad_im_host_attrs[] = {
 	&dev_attr_serial_number,
@@ -619,6 +721,8 @@ struct device_attribute *bfad_im_host_attrs[] = {
 	&dev_attr_number_of_ports,
 	&dev_attr_driver_name,
 	&dev_attr_number_of_discovered_ports,
+	&dev_attr_vport_create,
+	&dev_attr_vport_delete,
 	NULL,
 };
 
-- 
1.6.5.3

