From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/15] lpfc 8.2.8 : Add kernel-doc function headers - part 1
Date: Sun, 24 Aug 2008 21:49:00 -0400
Message-ID: <1219628941.7890.21.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52408 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYHYBs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:48:59 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1mwSN019898
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:48:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add kernel-doc function headers - part 1


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |  919 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 914 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 18:48:41.000000000 -0400
@@ -49,6 +49,21 @@
 #define LPFC_LINK_SPEED_BITMAP 0x00000117
 #define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8"
 
+/**
+ * lpfc_jedec_to_ascii: Hex to ascii convertor according to JEDEC rules.
+ * @incr: integer to convert.
+ * @hdw: ascii string holding converted integer plus a string terminator.
+ *
+ * Description:
+ * JEDEC Joint Electron Device Engineering Council.
+ * Convert a 32 bit integer composed of 8 nibbles into an 8 byte ascii
+ * character string. The string is then terminated with a NULL in byte 9.
+ * Hex 0-9 becomes ascii '0' to '9'.
+ * Hex a-f becomes ascii '=' to 'B' capital B.
+ *
+ * Notes:
+ * Coded for 32 bit integers only.
+ **/
 static void
 lpfc_jedec_to_ascii(int incr, char hdw[])
 {
@@ -65,6 +80,14 @@ lpfc_jedec_to_ascii(int incr, char hdw[]
 	return;
 }
 
+/**
+ * lpfc_drvr_version_show: Return the Emulex driver string with version number.
+ * @dev: class unused variable.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the module description text.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_drvr_version_show(struct device *dev, struct device_attribute *attr,
 		       char *buf)
@@ -72,6 +95,14 @@ lpfc_drvr_version_show(struct device *de
 	return snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
 }
 
+/**
+ * lpfc_info_show: Return some pci info about the host in ascii.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the formatted text from lpfc_info().
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_info_show(struct device *dev, struct device_attribute *attr,
 	       char *buf)
@@ -81,6 +112,14 @@ lpfc_info_show(struct device *dev, struc
 	return snprintf(buf, PAGE_SIZE, "%s\n",lpfc_info(host));
 }
 
+/**
+ * lpfc_serialnum_show: Return the hba serial number in ascii.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the formatted text serial number.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_serialnum_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -92,6 +131,18 @@ lpfc_serialnum_show(struct device *dev, 
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->SerialNumber);
 }
 
+/**
+ * lpfc_temp_sensor_show: Return the temperature sensor level.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the formatted support level.
+ *
+ * Description:
+ * Returns a number indicating the temperature sensor level currently
+ * supported, zero or one in ascii.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_temp_sensor_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
@@ -102,6 +153,14 @@ lpfc_temp_sensor_show(struct device *dev
 	return snprintf(buf, PAGE_SIZE, "%d\n",phba->temp_sensor_support);
 }
 
+/**
+ * lpfc_modeldesc_show: Return the model description of the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the scsi vpd model description.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_modeldesc_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -113,6 +172,14 @@ lpfc_modeldesc_show(struct device *dev, 
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelDesc);
 }
 
+/**
+ * lpfc_modelname_show: Return the model name of the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the scsi vpd model name.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_modelname_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -124,6 +191,14 @@ lpfc_modelname_show(struct device *dev, 
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelName);
 }
 
+/**
+ * lpfc_programtype_show: Return the program type of the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the scsi vpd program type.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_programtype_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
@@ -135,6 +210,14 @@ lpfc_programtype_show(struct device *dev
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ProgramType);
 }
 
+/**
+ * lpfc_vportnum_show: Return the port number in ascii of the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains scsi vpd program type.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_vportnum_show(struct device *dev, struct device_attribute *attr,
 		   char *buf)
@@ -146,6 +229,14 @@ lpfc_vportnum_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->Port);
 }
 
+/**
+ * lpfc_fwrev_show: Return the firmware rev running in the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the scsi vpd program type.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_fwrev_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -159,6 +250,14 @@ lpfc_fwrev_show(struct device *dev, stru
 	return snprintf(buf, PAGE_SIZE, "%s, sli-%d\n", fwrev, phba->sli_rev);
 }
 
+/**
+ * lpfc_hdw_show: Return the jedec information about the hba.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the scsi vpd program type.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_hdw_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -171,6 +270,15 @@ lpfc_hdw_show(struct device *dev, struct
 	lpfc_jedec_to_ascii(vp->rev.biuRev, hdw);
 	return snprintf(buf, PAGE_SIZE, "%s\n", hdw);
 }
+
+/**
+ * lpfc_option_rom_version_show: Return the adapter ROM FCode version.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the ROM and FCode ascii strings.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_option_rom_version_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
@@ -181,6 +289,18 @@ lpfc_option_rom_version_show(struct devi
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
 }
+
+/**
+ * lpfc_state_show: Return the link state of the port.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains text describing the state of the link.
+ *
+ * Notes:
+ * The switch statement has no default so zero will be returned.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_link_state_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
@@ -253,6 +373,18 @@ lpfc_link_state_show(struct device *dev,
 	return len;
 }
 
+/**
+ * lpfc_num_discovered_ports_show: Return sum of mapped and unmapped vports.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the sum of fc mapped and unmapped.
+ *
+ * Description:
+ * Returns the ascii text number of the sum of the fc mapped and unmapped
+ * vport counts.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_num_discovered_ports_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -264,7 +396,20 @@ lpfc_num_discovered_ports_show(struct de
 			vport->fc_map_cnt + vport->fc_unmap_cnt);
 }
 
-
+/**
+ * lpfc_issue_lip: Misnomer, name carried over from long ago.
+ * @shost: Scsi_Host pointer.
+ *
+ * Description:
+ * Bring the link down gracefully then re-init the link. The firmware will
+ * re-init the fiber channel interface as required. Does not issue a LIP.
+ *
+ * Returns:
+ * -EPERM port offline or management commands are being blocked
+ * -ENOMEM cannot allocate memory for the mailbox command
+ * -EIO error sending the mailbox command
+ * zero for success
+ **/
 static int
 lpfc_issue_lip(struct Scsi_Host *shost)
 {
@@ -306,6 +451,21 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	return 0;
 }
 
+/**
+ * lpfc_do_offline: Issues a mailbox command to bring the link down.
+ * @phba: lpfc_hba pointer.
+ * @type: LPFC_EVT_OFFLINE, LPFC_EVT_WARM_START, LPFC_EVT_KILL.
+ *
+ * Notes:
+ * Assumes any error from lpfc_do_offline() will be negative.
+ * Can wait up to 5 seconds for the port ring buffers count
+ * to reach zero, prints a warning if it is not zero and continues.
+ * lpfc_workq_post_event() returns a non-zero return coce if call fails.
+ *
+ * Returns:
+ * -EIO error posting the event
+ * zero for success
+ **/
 static int
 lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 {
@@ -353,6 +513,22 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 	return 0;
 }
 
+/**
+ * lpfc_selective_reset: Offline then onlines the port.
+ * @phba: lpfc_hba pointer.
+ *
+ * Description:
+ * If the port is configured to allow a reset then the hba is brought
+ * offline then online.
+ *
+ * Notes:
+ * Assumes any error from lpfc_do_offline() will be negative.
+ *
+ * Returns:
+ * lpfc_do_offline() return code if not zero
+ * -EIO reset not configured or error posting the event
+ * zero for success
+ **/
 static int
 lpfc_selective_reset(struct lpfc_hba *phba)
 {
@@ -378,6 +554,27 @@ lpfc_selective_reset(struct lpfc_hba *ph
 	return 0;
 }
 
+/**
+ * lpfc_issue_reset: Selectively resets an adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string "selective".
+ * @count: unused variable.
+ *
+ * Description:
+ * If the buf contains the string "selective" then lpfc_selective_reset()
+ * is called to perform the reset.
+ *
+ * Notes:
+ * Assumes any error from lpfc_selective_reset() will be negative.
+ * If lpfc_selective_reset() returns zero then the length of the buffer
+ * is returned which indicates succcess
+ *
+ * Returns:
+ * -EINVAL if the buffer does not contain the string "selective"
+ * length of buf if lpfc-selective_reset() if the call succeeds
+ * return value of lpfc_selective_reset() if the call fails
+**/
 static ssize_t
 lpfc_issue_reset(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
@@ -397,6 +594,14 @@ lpfc_issue_reset(struct device *dev, str
 		return status;
 }
 
+/**
+ * lpfc_nport_evt_cnt_show: Return the number of nport events.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the ascii number of nport events.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_nport_evt_cnt_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -408,6 +613,14 @@ lpfc_nport_evt_cnt_show(struct device *d
 	return snprintf(buf, PAGE_SIZE, "%d\n", phba->nport_event_cnt);
 }
 
+/**
+ * lpfc_board_mode_show: Return the state of the board.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the state of the adapter.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_board_mode_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
@@ -429,6 +642,19 @@ lpfc_board_mode_show(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%s\n", state);
 }
 
+/**
+ * lpfc_board_mode_store: Puts the hba in online, offline, warm or error state.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing one of the strings "online", "offline", "warm" or "error".
+ * @count: unused variable.
+ *
+ * Returns:
+ * -EACCES if enable hba reset not enabled
+ * -EINVAL if the buffer does not contain a valid string (see above)
+ * -EIO if lpfc_workq_post_event() or lpfc_do_offline() fails
+ * buf length greater than zero indicates success
+ **/
 static ssize_t
 lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
 		      const char *buf, size_t count)
@@ -462,6 +688,24 @@ lpfc_board_mode_store(struct device *dev
 		return -EIO;
 }
 
+/**
+ * lpfc_get_hba_info: Return various bits of informaton about the adapter.
+ * @phba: pointer to the adapter structure.
+ * @mxri max xri count.
+ * @axri available xri count.
+ * @mrpi max rpi count.
+ * @arpi available rpi count.
+ * @mvpi max vpi count.
+ * @avpi available vpi count.
+ *
+ * Description:
+ * If an integer pointer for an count is not null then the value for the
+ * count is returned.
+ *
+ * Returns:
+ * zero on error
+ * one for success
+ **/
 static int
 lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mxri, uint32_t *axri,
@@ -524,6 +768,20 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	return 1;
 }
 
+/**
+ * lpfc_max_rpi_show: Return maximum rpi.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the maximum rpi count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mrpi count.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_max_rpi_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
@@ -538,6 +796,20 @@ lpfc_max_rpi_show(struct device *dev, st
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_used_rpi_show: Return maximum rpi minus available rpi.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the used rpi count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mrpi and arpi counts.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_used_rpi_show(struct device *dev, struct device_attribute *attr,
 		   char *buf)
@@ -552,6 +824,20 @@ lpfc_used_rpi_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_max_xri_show: Return maximum xri.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the maximum xri count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mrpi count.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_max_xri_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
@@ -566,6 +852,20 @@ lpfc_max_xri_show(struct device *dev, st
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_used_xri_show: Return maximum xpi minus the available xpi.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the used xri count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mxri and axri counts.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_used_xri_show(struct device *dev, struct device_attribute *attr,
 		   char *buf)
@@ -580,6 +880,20 @@ lpfc_used_xri_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_max_vpi_show: Return maximum vpi.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the maximum vpi count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mvpi count.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_max_vpi_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
@@ -594,6 +908,20 @@ lpfc_max_vpi_show(struct device *dev, st
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_used_vpi_show: Return maximum vpi minus the available vpi.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the used vpi count in decimal or "Unknown".
+ *
+ * Description:
+ * Calls lpfc_get_hba_info() asking for just the mvpi and avpi counts.
+ * If lpfc_get_hba_info() returns zero (failure) the buffer text is set
+ * to "Unknown" and the buffer length is returned, therefore the caller
+ * must check for "Unknown" in the buffer to detect a failure.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_used_vpi_show(struct device *dev, struct device_attribute *attr,
 		   char *buf)
@@ -608,6 +936,19 @@ lpfc_used_vpi_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
+/**
+ * lpfc_npiv_info_show: Return text about NPIV support for the adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: text that must be interpreted to determine if npiv is supported.
+ *
+ * Description:
+ * Buffer will contain text indicating npiv is not suppoerted on the port,
+ * the port is an NPIV physical port, or it is an npiv virtual port with
+ * the id of the vport.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_npiv_info_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -623,6 +964,17 @@ lpfc_npiv_info_show(struct device *dev, 
 	return snprintf(buf, PAGE_SIZE, "NPIV Virtual (VPI %d)\n", vport->vpi);
 }
 
+/**
+ * lpfc_poll_show: Return text about poll support for the adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the cfg_poll in hex.
+ *
+ * Notes:
+ * cfg_poll should be a lpfc_polling_flags type.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_poll_show(struct device *dev, struct device_attribute *attr,
 	       char *buf)
@@ -634,6 +986,20 @@ lpfc_poll_show(struct device *dev, struc
 	return snprintf(buf, PAGE_SIZE, "%#x\n", phba->cfg_poll);
 }
 
+/**
+ * lpfc_poll_store: Set the value of cfg_poll for the adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: one or more lpfc_polling_flags values.
+ * @count: not used.
+ *
+ * Notes:
+ * buf contents converted to integer and checked for a valid value.
+ *
+ * Returns:
+ * -EINVAL if the buffer connot be converted or is out of range
+ * length of the buf on success
+ **/
 static ssize_t
 lpfc_poll_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
@@ -692,6 +1058,20 @@ lpfc_poll_store(struct device *dev, stru
 	return strlen(buf);
 }
 
+/**
+ * lpfc_param_show: Return a cfg attribute value in decimal.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_show.
+ *
+ * lpfc_##attr##_show: Return the decimal value of an adapters cfg_xxx field.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the attribute value in decimal.
+ *
+ * Returns: size of formatted string.
+ **/
 #define lpfc_param_show(attr)	\
 static ssize_t \
 lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
@@ -706,6 +1086,20 @@ lpfc_##attr##_show(struct device *dev, s
 			phba->cfg_##attr);\
 }
 
+/**
+ * lpfc_param_hex_show: Return a cfg attribute value in hex.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_show
+ *
+ * lpfc_##attr##_show: Return the hex value of an adapters cfg_xxx field.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the attribute value in hexidecimal.
+ *
+ * Returns: size of formatted string.
+ **/
 #define lpfc_param_hex_show(attr)	\
 static ssize_t \
 lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
@@ -720,6 +1114,25 @@ lpfc_##attr##_show(struct device *dev, s
 			phba->cfg_##attr);\
 }
 
+/**
+ * lpfc_param_init: Intializes a cfg attribute.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_init. The macro also
+ * takes a default argument, a minimum and maximum argument.
+ *
+ * lpfc_##attr##_init: Initializes an attribute.
+ * @phba: pointer the the adapter structure.
+ * @val: integer attribute value.
+ *
+ * Validates the min and max values then sets the adapter config field
+ * accordingly, or uses the default if out of range and prints an error message.
+ *
+ * Returns:
+ * zero on success
+ * -EINVAL if default used
+ **/
 #define lpfc_param_init(attr, default, minval, maxval)	\
 static int \
 lpfc_##attr##_init(struct lpfc_hba *phba, int val) \
@@ -735,6 +1148,26 @@ lpfc_##attr##_init(struct lpfc_hba *phba
 	return -EINVAL;\
 }
 
+/**
+ * lpfc_param_set: Set a cfg attribute value.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_set
+ *
+ * lpfc_##attr##_set: Sets an attribute value.
+ * @phba: pointer the the adapter structure.
+ * @val: integer attribute value.
+ *
+ * Description:
+ * Validates the min and max values then sets the
+ * adapter config field if in the valid range. prints error message
+ * and does not set the parameter if invalid.
+ *
+ * Returns:
+ * zero on success
+ * -EINVAL if val is invalid
+ **/
 #define lpfc_param_set(attr, default, minval, maxval)	\
 static int \
 lpfc_##attr##_set(struct lpfc_hba *phba, int val) \
@@ -749,6 +1182,27 @@ lpfc_##attr##_set(struct lpfc_hba *phba,
 	return -EINVAL;\
 }
 
+/**
+ * lpfc_param_store: Set a vport attribute value.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_store.
+ *
+ * lpfc_##attr##_store: Set an sttribute value.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: contains the attribute value in ascii.
+ * @count: not used.
+ *
+ * Description:
+ * Convert the ascii text number to an integer, then
+ * use the lpfc_##attr##_set function to set the value.
+ *
+ * Returns:
+ * -EINVAL if val is invalid or lpfc_##attr##_set() fails
+ * length of buffer upon success.
+ **/
 #define lpfc_param_store(attr)	\
 static ssize_t \
 lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
@@ -768,6 +1222,20 @@ lpfc_##attr##_store(struct device *dev, 
 		return -EINVAL;\
 }
 
+/**
+ * lpfc_vport_param_show: Return decimal formatted cfg attribute value.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_show
+ *
+ * lpfc_##attr##_show: prints the attribute value in decimal.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the attribute value in decimal.
+ *
+ * Returns: length of formatted string.
+ **/
 #define lpfc_vport_param_show(attr)	\
 static ssize_t \
 lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
@@ -780,6 +1248,21 @@ lpfc_##attr##_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
 }
 
+/**
+ * lpfc_vport_param_hex_show: Return hex formatted attribute value.
+ *
+ * Description:
+ * Macro that given an attr e.g.
+ * hba_queue_depth expands into a function with the name
+ * lpfc_hba_queue_depth_show
+ *
+ * lpfc_##attr##_show: prints the attribute value in hexidecimal.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the attribute value in hexidecimal.
+ *
+ * Returns: length of formatted string.
+ **/
 #define lpfc_vport_param_hex_show(attr)	\
 static ssize_t \
 lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
@@ -792,6 +1275,24 @@ lpfc_##attr##_show(struct device *dev, s
 	return snprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
 }
 
+/**
+ * lpfc_vport_param_init: Initialize a vport cfg attribute.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_init. The macro also
+ * takes a default argument, a minimum and maximum argument.
+ *
+ * lpfc_##attr##_init: validates the min and max values then sets the
+ * adapter config field accordingly, or uses the default if out of range
+ * and prints an error message.
+ * @phba: pointer the the adapter structure.
+ * @val: integer attribute value.
+ *
+ * Returns:
+ * zero on success
+ * -EINVAL if default used
+ **/
 #define lpfc_vport_param_init(attr, default, minval, maxval)	\
 static int \
 lpfc_##attr##_init(struct lpfc_vport *vport, int val) \
@@ -807,6 +1308,23 @@ lpfc_##attr##_init(struct lpfc_vport *vp
 	return -EINVAL;\
 }
 
+/**
+ * lpfc_vport_param_set: Set a vport cfg attribute.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth expands
+ * into a function with the name lpfc_hba_queue_depth_set
+ *
+ * lpfc_##attr##_set: validates the min and max values then sets the
+ * adapter config field if in the valid range. prints error message
+ * and does not set the parameter if invalid.
+ * @phba: pointer the the adapter structure.
+ * @val:	integer attribute value.
+ *
+ * Returns:
+ * zero on success
+ * -EINVAL if val is invalid
+ **/
 #define lpfc_vport_param_set(attr, default, minval, maxval)	\
 static int \
 lpfc_##attr##_set(struct lpfc_vport *vport, int val) \
@@ -821,6 +1339,23 @@ lpfc_##attr##_set(struct lpfc_vport *vpo
 	return -EINVAL;\
 }
 
+/**
+ * lpfc_vport_param_store: Set a vport attribute.
+ *
+ * Description:
+ * Macro that given an attr e.g. hba_queue_depth
+ * expands into a function with the name lpfc_hba_queue_depth_store
+ *
+ * lpfc_##attr##_store: convert the ascii text number to an integer, then
+ * use the lpfc_##attr##_set function to set the value.
+ * @cdev: class device that is converted into a Scsi_host.
+ * @buf:	contains the attribute value in decimal.
+ * @count: not used.
+ *
+ * Returns:
+ * -EINVAL if val is invalid or lpfc_##attr##_set() fails
+ * length of buffer upon success.
+ **/
 #define lpfc_vport_param_store(attr)	\
 static ssize_t \
 lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
@@ -958,6 +1493,17 @@ static DEVICE_ATTR(lpfc_temp_sensor, S_I
 
 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
+/**
+ * lpfc_soft_wwn_enable_store: Allows setting of the wwn if the key is valid.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string lpfc_soft_wwn_key.
+ * @count: must be size of lpfc_soft_wwn_key.
+ *
+ * Returns:
+ * -EINVAL if the buffer does not contain lpfc_soft_wwn_key
+ * length of buf indicates success
+ **/
 static ssize_t
 lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
@@ -994,6 +1540,14 @@ lpfc_soft_wwn_enable_store(struct device
 static DEVICE_ATTR(lpfc_soft_wwn_enable, S_IWUSR, NULL,
 		   lpfc_soft_wwn_enable_store);
 
+/**
+ * lpfc_soft_wwpn_show: Return the cfg soft ww port name of the adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the wwpn in hexidecimal.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_soft_wwpn_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -1006,7 +1560,19 @@ lpfc_soft_wwpn_show(struct device *dev, 
 			(unsigned long long)phba->cfg_soft_wwpn);
 }
 
-
+/**
+ * lpfc_soft_wwpn_store: Set the ww port name of the adapter.
+ * @dev class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: contains the wwpn in hexidecimal.
+ * @count: number of wwpn bytes in buf
+ *
+ * Returns:
+ * -EACCES hba reset not enabled, adapter over temp
+ * -EINVAL soft wwn not enabled, count is invalid, invalid wwpn byte invalid
+ * -EIO error taking adapter offline or online
+ * value of count on success
+ **/
 static ssize_t
 lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t count)
@@ -1080,6 +1646,14 @@ lpfc_soft_wwpn_store(struct device *dev,
 static DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,\
 		   lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
 
+/**
+ * lpfc_soft_wwnn_show: Return the cfg soft ww node name for the adapter.
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the wwnn in hexidecimal.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_soft_wwnn_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -1090,7 +1664,16 @@ lpfc_soft_wwnn_show(struct device *dev, 
 			(unsigned long long)phba->cfg_soft_wwnn);
 }
 
-
+/**
+ * lpfc_soft_wwnn_store: sets the ww node name of the adapter.
+ * @cdev: class device that is converted into a Scsi_host.
+ * @buf: contains the ww node name in hexidecimal.
+ * @count: number of wwnn bytes in buf.
+ *
+ * Returns:
+ * -EINVAL soft wwn not enabled, count is invalid, invalid wwnn byte invalid
+ * value of count on success
+ **/
 static ssize_t
 lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t count)
@@ -1178,6 +1761,15 @@ module_param(lpfc_nodev_tmo, int, 0);
 MODULE_PARM_DESC(lpfc_nodev_tmo,
 		 "Seconds driver will hold I/O waiting "
 		 "for a device to come back");
+
+/**
+ * lpfc_nodev_tmo_show: Return the hba dev loss timeout value.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the dev loss timeout in decimal.
+ *
+ * Returns: size of formatted string.
+ **/
 static ssize_t
 lpfc_nodev_tmo_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
@@ -1189,6 +1781,21 @@ lpfc_nodev_tmo_show(struct device *dev, 
 	return snprintf(buf, PAGE_SIZE, "%d\n",	vport->cfg_devloss_tmo);
 }
 
+/**
+ * lpfc_nodev_tmo_init: Set the hba nodev timeout value.
+ * @vport: lpfc vport structure pointer.
+ * @val: contains the nodev timeout value.
+ *
+ * Description:
+ * If the devloss tmo is already set then nodev tmo is set to devloss tmo,
+ * a kernel error message is printed and zero is returned.
+ * Else if val is in range then nodev tmo and devloss tmo are set to val.
+ * Otherwise nodev tmo is set to the default value.
+ *
+ * Returns:
+ * zero if already set or if val is in range
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
 {
@@ -1215,6 +1822,13 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
 	return -EINVAL;
 }
 
+/**
+ * lpfc_update_rport_devloss_tmo: Update dev loss tmo value.
+ * @vport: lpfc vport structure pointer.
+ *
+ * Description:
+ * Update all the ndlp's dev loss tmo with the vport devloss tmo value.
+ **/
 static void
 lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 {
@@ -1229,6 +1843,21 @@ lpfc_update_rport_devloss_tmo(struct lpf
 	spin_unlock_irq(shost->host_lock);
 }
 
+/**
+ * lpfc_nodev_tmo_set: Set the vport nodev tmo and devloss tmo values.
+ * @vport: lpfc vport structure pointer.
+ * @val: contains the tmo value.
+ *
+ * Description:
+ * If the devloss tmo is already set or the vport dev loss tmo has changed
+ * then a kernel error message is printed and zero is returned.
+ * Else if val is in range then nodev tmo and devloss tmo are set to val.
+ * Otherwise nodev tmo is set to the default value.
+ *
+ * Returns:
+ * zero if already set or if val is in range
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 {
@@ -1269,6 +1898,21 @@ MODULE_PARM_DESC(lpfc_devloss_tmo,
 lpfc_vport_param_init(devloss_tmo, LPFC_DEF_DEVLOSS_TMO,
 		      LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO)
 lpfc_vport_param_show(devloss_tmo)
+
+/**
+ * lpfc_devloss_tmo_set: Sets vport nodev tmo, devloss tmo values, changed bit.
+ * @vport: lpfc vport structure pointer.
+ * @val: contains the tmo value.
+ *
+ * Description:
+ * If val is in a valid range then set the vport nodev tmo,
+ * devloss tmo, also set the vport dev loss tmo changed flag.
+ * Else a kernel error message is printed.
+ *
+ * Returns:
+ * zero if val is in range
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_devloss_tmo_set(struct lpfc_vport *vport, int val)
 {
@@ -1366,6 +2010,21 @@ MODULE_PARM_DESC(lpfc_restrict_login,
 		 "Restrict virtual ports login to remote initiators.");
 lpfc_vport_param_show(restrict_login);
 
+/**
+ * lpfc_restrict_login_init: Set the vport restrict login flag.
+ * @vport: lpfc vport structure pointer.
+ * @val: contains the restrict login value.
+ *
+ * Description:
+ * If val is not in a valid range then log a kernel error message and set
+ * the vport restrict login to one.
+ * If the port type is physical clear the restrict login flag and return.
+ * Else set the restrict login flag to val.
+ *
+ * Returns:
+ * zero if val is in range
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_restrict_login_init(struct lpfc_vport *vport, int val)
 {
@@ -1385,6 +2044,22 @@ lpfc_restrict_login_init(struct lpfc_vpo
 	return 0;
 }
 
+/**
+ * lpfc_restrict_login_set: Set the vport restrict login flag.
+ * @vport: lpfc vport structure pointer.
+ * @val: contains the restrict login value.
+ *
+ * Description:
+ * If val is not in a valid range then log a kernel error message and set
+ * the vport restrict login to one.
+ * If the port type is physical and the val is not zero log a kernel
+ * error message, clear the restrict login flag and return zero.
+ * Else set the restrict login flag to val.
+ *
+ * Returns:
+ * zero if val is in range
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_restrict_login_set(struct lpfc_vport *vport, int val)
 {
@@ -1441,6 +2116,23 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
 # Set loop mode if you want to run as an NL_Port. Value range is [0,0x6].
 # Default value is 0.
 */
+
+/**
+ * lpfc_topology_set: Set the adapters topology field.
+ * @phba: lpfc_hba pointer.
+ * @val: topology value.
+ *
+ * Description:
+ * If val is in a valid range then set the adapter's topology field and
+ * issue a lip; if the lip fails reset the topology to the old value.
+ *
+ * If the value is not in range log a kernel error message and return an error.
+ *
+ * Returns:
+ * zero if val is in range and lip okay
+ * non-zero return value from lpfc_issue_lip()
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_topology_set(struct lpfc_hba *phba, int val)
 {
@@ -1479,6 +2171,24 @@ static DEVICE_ATTR(lpfc_topology, S_IRUG
 #       8  = 8 Gigabaud
 # Value range is [0,8]. Default value is 0.
 */
+
+/**
+ * lpfc_link_speed_set: Set the adapters link speed.
+ * @phba: lpfc_hba pointer.
+ * @val: link speed value.
+ *
+ * Description:
+ * If val is in a valid range then set the adapter's link speed field and
+ * issue a lip; if the lip fails reset the link speed to the old value.
+ *
+ * Notes:
+ * If the value is not in range log a kernel error message and return an error.
+ *
+ * Returns:
+ * zero if val is in range and lip okay.
+ * non-zero return value from lpfc_issue_lip()
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_link_speed_set(struct lpfc_hba *phba, int val)
 {
@@ -1513,6 +2223,23 @@ static int lpfc_link_speed = 0;
 module_param(lpfc_link_speed, int, 0);
 MODULE_PARM_DESC(lpfc_link_speed, "Select link speed");
 lpfc_param_show(link_speed)
+
+/**
+ * lpfc_link_speed_init: Set the adapters link speed.
+ * @phba: lpfc_hba pointer.
+ * @val: link speed value.
+ *
+ * Description:
+ * If val is in a valid range then set the adapter's link speed field.
+ *
+ * Notes:
+ * If the value is not in range log a kernel error message, clear the link
+ * speed and return an error.
+ *
+ * Returns:
+ * zero if val saved.
+ * -EINVAL val out of range
+ **/
 static int
 lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 {
@@ -1734,6 +2461,24 @@ struct device_attribute *lpfc_vport_attr
 	NULL,
 };
 
+/**
+ * sysfs_ctlreg_write: Write method for writing to ctlreg.
+ * @kobj: kernel kobject that contains the kernel class device.
+ * @bin_attr: kernel attributes passed to us.
+ * @buf: contains the data to be written to the adapter IOREG space.
+ * @off: offset into buffer to beginning of data.
+ * @count: bytes to transfer.
+ *
+ * Description:
+ * Accessed via /sys/class/scsi_host/hostxxx/ctlreg.
+ * Uses the adapter io control registers to send buf contents to the adapter.
+ *
+ * Returns:
+ * -ERANGE off and count combo out of range
+ * -EINVAL off, count or buff address invalid
+ * -EPERM adapter is offline
+ * value of count, buf contents written
+ **/
 static ssize_t
 sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 		   char *buf, loff_t off, size_t count)
@@ -1766,6 +2511,23 @@ sysfs_ctlreg_write(struct kobject *kobj,
 	return count;
 }
 
+/**
+ * sysfs_ctlreg_read: Read method for reading from ctlreg.
+ * @kobj: kernel kobject that contains the kernel class device.
+ * @bin_attr: kernel attributes passed to us.
+ * @buf: if succesful contains the data from the adapter IOREG space.
+ * @off: offset into buffer to beginning of data.
+ * @count: bytes to transfer.
+ *
+ * Description:
+ * Accessed via /sys/class/scsi_host/hostxxx/ctlreg.
+ * Uses the adapter io control registers to read data into buf.
+ *
+ * Returns:
+ * -ERANGE off and count combo out of range
+ * -EINVAL off, count or buff address invalid
+ * value of count, buf contents read
+ **/
 static ssize_t
 sysfs_ctlreg_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		  char *buf, loff_t off, size_t count)
@@ -1810,7 +2572,10 @@ static struct bin_attribute sysfs_ctlreg
 	.write = sysfs_ctlreg_write,
 };
 
-
+/**
+ * sysfs_mbox_idle: frees the sysfs mailbox.
+ * @phba: lpfc_hba pointer
+ **/
 static void
 sysfs_mbox_idle(struct lpfc_hba *phba)
 {
@@ -1824,6 +2589,27 @@ sysfs_mbox_idle(struct lpfc_hba *phba)
 	}
 }
 
+/**
+ * sysfs_mbox_write: Write method for writing information via mbox.
+ * @kobj: kernel kobject that contains the kernel class device.
+ * @bin_attr: kernel attributes passed to us.
+ * @buf: contains the data to be written to sysfs mbox.
+ * @off: offset into buffer to beginning of data.
+ * @count: bytes to transfer.
+ *
+ * Description:
+ * Accessed via /sys/class/scsi_host/hostxxx/mbox.
+ * Uses the sysfs mbox to send buf contents to the adapter.
+ *
+ * Returns:
+ * -ERANGE off and count combo out of range
+ * -EINVAL off, count or buff address invalid
+ * zero if count is zero
+ * -EPERM adapter is offline
+ * -ENOMEM failed to allocate memory for the mail box
+ * -EAGAIN offset, state or mbox is NULL
+ * count number of bytes transferred
+ **/
 static ssize_t
 sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
@@ -1878,6 +2664,29 @@ sysfs_mbox_write(struct kobject *kobj, s
 	return count;
 }
 
+/**
+ * sysfs_mbox_read: Read method for reading information via mbox.
+ * @kobj: kernel kobject that contains the kernel class device.
+ * @bin_attr: kernel attributes passed to us.
+ * @buf: contains the data to be read from sysfs mbox.
+ * @off: offset into buffer to beginning of data.
+ * @count: bytes to transfer.
+ *
+ * Description:
+ * Accessed via /sys/class/scsi_host/hostxxx/mbox.
+ * Uses the sysfs mbox to receive data from to the adapter.
+ *
+ * Returns:
+ * -ERANGE off greater than mailbox command size
+ * -EINVAL off, count or buff address invalid
+ * zero if off and count are zero
+ * -EACCES adapter over temp
+ * -EPERM garbage can value to catch a multitude of errors
+ * -EAGAIN management IO not permitted, state or off error
+ * -ETIME mailbox timeout
+ * -ENODEV mailbox error
+ * count number of bytes transferred
+ **/
 static ssize_t
 sysfs_mbox_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
@@ -2059,6 +2868,14 @@ static struct bin_attribute sysfs_mbox_a
 	.write = sysfs_mbox_write,
 };
 
+/**
+ * lpfc_alloc_sysfs_attr: Creates the sysfs, ctlreg, menlo and mbox entries.
+ * @vport: address of lpfc vport structure.
+ *
+ * Return codes:
+ * zero on success
+ * error return code from sysfs_create_bin_file()
+ **/
 int
 lpfc_alloc_sysfs_attr(struct lpfc_vport *vport)
 {
@@ -2082,6 +2899,10 @@ out:
 	return error;
 }
 
+/**
+ * lpfc_free_sysfs_attr: Removes the sysfs, ctlreg, menlo and mbox entries.
+ * @vport: address of lpfc vport structure.
+ **/
 void
 lpfc_free_sysfs_attr(struct lpfc_vport *vport)
 {
@@ -2096,6 +2917,10 @@ lpfc_free_sysfs_attr(struct lpfc_vport *
  * Dynamic FC Host Attributes Support
  */
 
+/**
+ * lpfc_get_host_port_id: Copy the vport DID into the scsi host port id.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_get_host_port_id(struct Scsi_Host *shost)
 {
@@ -2105,6 +2930,10 @@ lpfc_get_host_port_id(struct Scsi_Host *
 	fc_host_port_id(shost) = vport->fc_myDID;
 }
 
+/**
+ * lpfc_get_host_port_type: Set the value of the scsi host port type.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_get_host_port_type(struct Scsi_Host *shost)
 {
@@ -2133,6 +2962,10 @@ lpfc_get_host_port_type(struct Scsi_Host
 	spin_unlock_irq(shost->host_lock);
 }
 
+/**
+ * lpfc_get_host_port_state: Set the value of the scsi host port state.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_get_host_port_state(struct Scsi_Host *shost)
 {
@@ -2167,6 +3000,10 @@ lpfc_get_host_port_state(struct Scsi_Hos
 	spin_unlock_irq(shost->host_lock);
 }
 
+/**
+ * lpfc_get_host_speed: Set the value of the scsi host speed.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_get_host_speed(struct Scsi_Host *shost)
 {
@@ -2199,6 +3036,10 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 	spin_unlock_irq(shost->host_lock);
 }
 
+/**
+ * lpfc_get_host_fabric_name: Set the value of the scsi host fabric name.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 {
@@ -2221,6 +3062,18 @@ lpfc_get_host_fabric_name (struct Scsi_H
 	fc_host_fabric_name(shost) = node_name;
 }
 
+/**
+ * lpfc_get_stats: Return statistical information about the adapter.
+ * @shost: kernel scsi host pointer.
+ *
+ * Notes:
+ * NULL on error for link down, no mbox pool, sli2 active,
+ * management not allowed, memory allocation error, or mbox error.
+ *
+ * Returns:
+ * NULL for error
+ * address of the adapter host statistics
+ **/
 static struct fc_host_statistics *
 lpfc_get_stats(struct Scsi_Host *shost)
 {
@@ -2334,6 +3187,10 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	return hs;
 }
 
+/**
+ * lpfc_reset_stats: Copy the adapter link stats information.
+ * @shost: kernel scsi host pointer.
+ **/
 static void
 lpfc_reset_stats(struct Scsi_Host *shost)
 {
@@ -2411,6 +3268,14 @@ lpfc_reset_stats(struct Scsi_Host *shost
  * are no sysfs handlers for link_down_tmo.
  */
 
+/**
+ * lpfc_get_node_by_target: Return the nodelist for a target.
+ * @starget: kernel scsi target pointer.
+ *
+ * Returns:
+ * address of the node list if found
+ * NULL target not found
+ **/
 static struct lpfc_nodelist *
 lpfc_get_node_by_target(struct scsi_target *starget)
 {
@@ -2432,6 +3297,10 @@ lpfc_get_node_by_target(struct scsi_targ
 	return NULL;
 }
 
+/**
+ * lpfc_get_starget_port_id: Set the target port id to the ndlp DID or -1.
+ * @starget: kernel scsi target pointer.
+ **/
 static void
 lpfc_get_starget_port_id(struct scsi_target *starget)
 {
@@ -2440,6 +3309,12 @@ lpfc_get_starget_port_id(struct scsi_tar
 	fc_starget_port_id(starget) = ndlp ? ndlp->nlp_DID : -1;
 }
 
+/**
+ * lpfc_get_starget_node_name: Set the target node name.
+ * @starget: kernel scsi target pointer.
+ *
+ * Description: Set the target node name to the ndlp node name wwn or zero.
+ **/
 static void
 lpfc_get_starget_node_name(struct scsi_target *starget)
 {
@@ -2449,6 +3324,12 @@ lpfc_get_starget_node_name(struct scsi_t
 		ndlp ? wwn_to_u64(ndlp->nlp_nodename.u.wwn) : 0;
 }
 
+/**
+ * lpfc_get_starget_port_name: Set the target port name.
+ * @starget: kernel scsi target pointer.
+ *
+ * Description:  set the target port name to the ndlp port name wwn or zero.
+ **/
 static void
 lpfc_get_starget_port_name(struct scsi_target *starget)
 {
@@ -2458,6 +3339,15 @@ lpfc_get_starget_port_name(struct scsi_t
 		ndlp ? wwn_to_u64(ndlp->nlp_portname.u.wwn) : 0;
 }
 
+/**
+ * lpfc_set_rport_loss_tmo: Set the rport dev loss tmo.
+ * @rport: fc rport address.
+ * @timeout: new value for dev loss tmo.
+ *
+ * Description:
+ * If timeout is non zero set the dev_loss_tmo to timeout, else set
+ * dev_loss_tmo to one.
+ **/
 static void
 lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
@@ -2467,7 +3357,18 @@ lpfc_set_rport_loss_tmo(struct fc_rport 
 		rport->dev_loss_tmo = 1;
 }
 
-
+/**
+ * lpfc_rport_show_function: Return rport target information.
+ *
+ * Description:
+ * Macro that uses field to generate a function with the name lpfc_show_rport_
+ *
+ * lpfc_show_rport_##field: returns the bytes formatted in buf
+ * @cdev: class converted to an fc_rport.
+ * @buf: on return contains the target_field or zero.
+ *
+ * Returns: size of formatted string.
+ **/
 #define lpfc_rport_show_function(field, format_string, sz, cast)	\
 static ssize_t								\
 lpfc_show_rport_##field (struct device *dev,				\
@@ -2602,6 +3503,10 @@ struct fc_function_template lpfc_vport_t
 	.vport_disable = lpfc_vport_disable,
 };
 
+/**
+ * lpfc_get_cfgparam: Used during probe_one to init the adapter structure.
+ * @phba: lpfc_hba pointer.
+ **/
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
@@ -2637,6 +3542,10 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	return;
 }
 
+/**
+ * lpfc_get_vport_cfgparam: Used during port create, init the vport structure.
+ * @vport: lpfc_vport pointer.
+ **/
 void
 lpfc_get_vport_cfgparam(struct lpfc_vport *vport)
 {


