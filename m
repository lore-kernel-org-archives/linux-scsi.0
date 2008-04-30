From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Fix jbod operations scan issues
Date: Wed, 30 Apr 2008 15:47:35 -0400
Message-ID: <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com> <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com> <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-44--650578320
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:48599 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbYD3Trh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 15:47:37 -0400
Received: from Macintosh.adaptec.com (unknown [10.5.3.1])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 45D36240840
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2008 12:47:36 -0700 (PDT)
In-Reply-To: <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>


--Apple-Mail-44--650578320
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

As JBOD devices (really just Simple Single Drive Volumes exported to  
the SCSI channel) are managed, they fail to update correctly when the  
driver triggers a SCSI scan. In addition, the ability to change  
multiple arrays or JBODs at the same time was resulting in dropped  
scans, set up a mechanism to issue a list of single target scans on a  
single configuration change notification from the Firmware.

Performed some additional sundry cosmetic code style cleanups.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/commsup.c |   32 +++++++++++++++++++++++++-------
  drivers/scsi/aacraid/linit.c   |   16 +++++++++-------
  2 files changed, 34 insertions(+), 14 deletions(-)

Sincerely - Mark Salyzyn

--Apple-Mail-44--650578320
Content-Disposition: attachment;
	filename=aacraid_jbod_scan.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_jbod_scan.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	2008-04-30 15:29:36.074346998 -0400
+++ b/drivers/scsi/aacraid/commsup.c	2008-04-30 15:38:40.331089743 -0400
@@ -906,15 +906,22 @@
 		case AifEnAddJBOD:
 		case AifEnDeleteJBOD:
 			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
-			if ((container >> 28))
+			if ((container >> 28)) {
+				container = (u32)-1;
 				break;
+			}
 			channel = (container >> 24) & 0xF;
-			if (channel >= dev->maximum_num_channels)
+			if (channel >= dev->maximum_num_channels) {
+				container = (u32)-1;
 				break;
+			}
 			id = container & 0xFFFF;
-			if (id >= dev->maximum_num_physicals)
+			if (id >= dev->maximum_num_physicals) {
+				container = (u32)-1;
 				break;
+			}
 			lun = (container >> 16) & 0xFF;
+			container = (u32)-1;
 			channel = aac_phys_to_logical(channel);
 			device_config_needed =
 			  (((__le32 *)aifcmd->data)[0] ==
@@ -933,13 +940,18 @@
 			case EM_DRIVE_REMOVAL:
 				container = le32_to_cpu(
 					((__le32 *)aifcmd->data)[2]);
-				if ((container >> 28))
+				if ((container >> 28)) {
+					container = (u32)-1;
 					break;
+				}
 				channel = (container >> 24) & 0xF;
-				if (channel >= dev->maximum_num_channels)
+				if (channel >= dev->maximum_num_channels) {
+					container = (u32)-1;
 					break;
+				}
 				id = container & 0xFFFF;
 				lun = (container >> 16) & 0xFF;
+				container = (u32)-1;
 				if (id >= dev->maximum_num_physicals) {
 					/* legacy dev_t ? */
 					if ((0x2000 <= id) || lun || channel ||
@@ -1025,9 +1037,10 @@
 		break;
 	}
 
+	container = 0;
+retry_next:
 	if (device_config_needed == NOTHING)
-	for (container = 0; container < dev->maximum_num_containers;
-	    ++container) {
+	for (; container < dev->maximum_num_containers; ++container) {
 		if ((dev->fsa_dev[container].config_waiting_on == 0) &&
 			(dev->fsa_dev[container].config_needed != NOTHING) &&
 			time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT)) {
@@ -1110,6 +1123,11 @@
 	}
 	if (device_config_needed == ADD)
 		scsi_add_device(dev->scsi_host_ptr, channel, id, lun);
+	if (channel == CONTAINER_CHANNEL) {
+		container++;
+		device_config_needed = NOTHING;
+		goto retry_next;
+	}
 }
 
 static int _aac_reset_adapter(struct aac_dev *aac, int forced)
diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2008-04-30 15:29:36.075346870 -0400
+++ b/drivers/scsi/aacraid/linit.c	2008-04-30 15:38:40.332089616 -0400
@@ -401,6 +401,8 @@
 static int aac_slave_configure(struct scsi_device *sdev)
 {
 	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
+	if (aac->jbod && (sdev->type == TYPE_DISK))
+		sdev->removable = 1;
 	if ((sdev->type == TYPE_DISK) &&
 			(sdev_channel(sdev) != CONTAINER_CHANNEL) &&
 			(!aac->jbod || sdev->inq_periph_qual) &&
@@ -1106,7 +1108,7 @@
 	aac->pdev = pdev;
 	aac->name = aac_driver_template.name;
 	aac->id = shost->unique_id;
-	aac->cardtype =  index;
+	aac->cardtype = index;
 	INIT_LIST_HEAD(&aac->entry);
 
 	aac->fibs = kmalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
@@ -1146,19 +1148,19 @@
 		goto out_deinit;
 
 	/*
- 	 * Lets override negotiations and drop the maximum SG limit to 34
- 	 */
+	 * Lets override negotiations and drop the maximum SG limit to 34
+	 */
 	if ((aac_drivers[index].quirks & AAC_QUIRK_34SG) &&
 			(shost->sg_tablesize > 34)) {
 		shost->sg_tablesize = 34;
 		shost->max_sectors = (shost->sg_tablesize * 8) + 112;
- 	}
+	}
 
- 	if ((aac_drivers[index].quirks & AAC_QUIRK_17SG) &&
+	if ((aac_drivers[index].quirks & AAC_QUIRK_17SG) &&
 			(shost->sg_tablesize > 17)) {
 		shost->sg_tablesize = 17;
 		shost->max_sectors = (shost->sg_tablesize * 8) + 112;
- 	}
+	}
 
 	error = pci_set_dma_max_seg_size(pdev,
 		(aac->adapter_info.options & AAC_OPT_NEW_COMM) ?
@@ -1174,7 +1176,7 @@
 	else
 		aac->printf_enabled = 0;
 
- 	/*
+	/*
 	 * max channel will be the physical channels plus 1 virtual channel
 	 * all containers are on the virtual channel 0 (CONTAINER_CHANNEL)
 	 * physical channels are address by their actual physical number+1

--Apple-Mail-44--650578320
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-44--650578320--
