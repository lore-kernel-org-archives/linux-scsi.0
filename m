From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Add VPD support to aacraid
Date: Thu, 25 Jan 2007 10:47:35 +0100
Message-ID: <45B87CB7.80102@suse.de>
References: <45B87336.5070707@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050002030207010207080708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965726AbXAYJrh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jan 2007 04:47:37 -0500
In-Reply-To: <45B87336.5070707@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050002030207010207080708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hannes Reinecke wrote:
> Hi Mark,
> 
> I found to my surprise that the aacraid driver does not support VPD
> pages at all. I'm somewhat used to modern SCSI HBAs export SCSI-2 disks,
> but not supporting VPD pages at all is really a bit .. hmm .. SCSI-1-ish.
> And it makes it really impossible to assign a persistent device ID to
> those drives.
> 
[ .. ]
> 
> Anyway, I don't think that it should be too hard to add proper VPD page
> support (ie page 0x83), but for that one would have some documentation
> how to ask the controller for it. I'll leave that to you :-)
> You can use the page 0x80 support as a template.
> 
And here is even the patch, based on scsi-misc.
Might help on reviewing.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------050002030207010207080708
Content-Type: text/plain;
 name="aacraid-vpd-support"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aacraid-vpd-support"

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 426cd6f..410a127 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -666,6 +666,27 @@ static void setinqstr(struct aac_dev *de
 	inqstrcpy ("V1.0", str->prl);
 }
 
+/* Function: setinqserial
+ *
+ * Arguments: [1] pointer to void [1] int
+ *
+ * Purpose: Sets SCSI Unit Serial number.
+ *          This is a fake. We should read a proper
+ *          serial number from the container. But
+ *          without docs it's quite hard to do it :-)
+ *          So this will have to do in the meantime.
+ */
+
+static int setinqserial(struct aac_dev *dev, void *data, int cid)
+{
+	char *ep;
+
+	ep = (char *)(data);
+
+	return snprintf(ep, sizeof(struct scsi_inq) - 4, "%08X%02X",
+			le32_to_cpu(dev->adapter_info.serial[0]), cid);
+}
+
 static void set_sense(u8 *sense_buf, u8 sense_key, u8 sense_code,
 		      u8 a_sense_code, u8 incorrect_length,
 		      u8 bit_pointer, u16 field_pointer,
@@ -1580,6 +1601,46 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", scmd_id(scsicmd)));
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
+		if (scsicmd->cmnd[1] & 0x1 ) {
+			char *arr = (char *)&inq_data;
+
+			/* EVPD bit set */
+			if (scmd_id(scsicmd) == host->this_id) {
+				arr[0] = INQD_PDT_PROC;
+			} else {
+				arr[0] = INQD_PDT_DA;
+			}
+			if (scsicmd->cmnd[2] == 0) {
+				int n;
+				/* supported vital product data pages */
+				arr[1] = scsicmd->cmnd[2];
+				n = 4;
+				arr[n++] = 0x0;;
+				arr[n++] = 0x80;
+				arr[3] = n - 4;
+				aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			} else if (scsicmd->cmnd[2] == 0x80) {
+				/* unit serial number page */
+				arr[1] = scsicmd->cmnd[2];
+				arr[3] = setinqserial(dev, &arr[4], scmd_id(scsicmd));
+				aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			} else {
+				/* vpd page not implemented */
+				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+				set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
+					  ILLEGAL_REQUEST,
+					  SENCODE_INVALID_CDB_FIELD,
+					  ASENCODE_NO_SENSE, 0, 7, 2, 0);
+				memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+				       (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+				       ? sizeof(scsicmd->sense_buffer)
+				       : sizeof(dev->fsa_dev[cid].sense_data));
+			}
+			scsicmd->scsi_done(scsicmd);
+			return 0;
+		}
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
 		inq_data.inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
 		inq_data.inqd_len = 31;

--------------050002030207010207080708--
