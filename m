From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/5] aacraid: fix inquiry page
Date: Mon, 24 Oct 2005 10:51:53 -0700
Message-ID: <1130176314.4628.22.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:30942 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751200AbVJXRv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:51:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch uses the adapter supplemental information AdapterTypeText as
the default for the array name.

Applies to the scsi-rc-fixes-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/aachba.c	2005-10-19 13:03:53.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c	2005-10-19 13:04:02.000000000 -0700
@@ -608,17 +608,43 @@
  * files instead of in OS dependant driver source.
  */
 
-static void setinqstr(int devtype, void *data, int tindex)
+static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 {
 	struct scsi_inq *str;
-	struct aac_driver_ident *mp;
 
-	mp = aac_get_driver_ident(devtype);
-   
 	str = (struct scsi_inq *)(data); /* cast data to scsi inq block */
+	memset(str, ' ', sizeof(*str));
 
-	inqstrcpy (mp->vname, str->vid); 
-	inqstrcpy (mp->model, str->pid); /* last six chars reserved for vol type */
+	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
+		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+		int c = sizeof(str->vid);
+		while (*cp && *cp != ' ' && --c)
+			++cp;
+		c = *cp;
+		*cp = '\0';
+		inqstrcpy (dev->supplement_adapter_info.AdapterTypeText,
+		  str->vid); 
+		*cp = c;
+		while (*cp && *cp != ' ')
+			++cp;
+		while (*cp == ' ')
+			++cp;
+		/* last six chars reserved for vol type */
+		c = 0;
+		if (strlen(cp) > sizeof(str->pid)) {
+			c = cp[sizeof(str->pid)];
+			cp[sizeof(str->pid)] = '\0';
+		}
+		inqstrcpy (cp, str->pid);
+		if (c)
+			cp[sizeof(str->pid)] = c;
+	} else {
+		struct aac_driver_ident *mp = aac_get_driver_ident(dev->cardtype);
+   
+		inqstrcpy (mp->vname, str->vid); 
+		/* last six chars reserved for vol type */
+		inqstrcpy (mp->model, str->pid);
+	}
 
 	if (tindex < (sizeof(container_types)/sizeof(char *))){
 		char *findit = str->pid;
@@ -627,7 +653,9 @@
 		/* RAID is superfluous in the context of a RAID device */
 		if (memcmp(findit-4, "RAID", 4) == 0)
 			*(findit -= 4) = ' ';
-		inqstrcpy (container_types[tindex], findit + 1);
+		if (((findit - str->pid) + strlen(container_types[tindex]))
+		 < (sizeof(str->pid) + sizeof(str->prl)))
+			inqstrcpy (container_types[tindex], findit + 1);
 	}
 	inqstrcpy ("V1.0", str->prl);
 }
@@ -1438,7 +1466,6 @@
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
-	int cardtype = dev->cardtype;
 	int ret;
 	
 	/*
@@ -1542,14 +1569,14 @@
 		 *	see: <vendor>.c i.e. aac.c
 		 */
 		if (scsicmd->device->id == host->this_id) {
-			setinqstr(cardtype, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
+			setinqstr(dev, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 			scsicmd->scsi_done(scsicmd);
 			return 0;
 		}
-		setinqstr(cardtype, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
+		setinqstr(dev, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
 		inq_data.inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
 		aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
 		return aac_get_container_name(scsicmd, cid);

-- 
Mark Haverkamp <markh@osdl.org>

