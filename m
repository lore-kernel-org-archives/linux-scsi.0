From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH]: Fix userspace warning in /usr/include/scsi/scsi.h
Date: Mon, 24 May 2010 15:20:11 -0400
Message-ID: <20100524191505.8082.33425.sendpatchset@prarit.bos.redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0EXTUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2010 15:20:12 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4OJKCjO028554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 24 May 2010 15:20:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, bharrosh@panasas.com
Cc: Prarit Bhargava <prarit@redhat.com>

Fixes warning:

/usr/include/scsi/scsi.h:168: userspace cannot call function or variable defined in the kernel

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9ae5c61..a2b013b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -165,6 +165,7 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
+#ifdef __KERNEL__
 extern const unsigned char scsi_command_size_tbl[8];
 #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
 
@@ -174,6 +175,7 @@ scsi_command_size(const unsigned char *cmnd)
 	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
+#endif /* __KERNEL__ */
 
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
@@ -290,8 +292,10 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#ifdef __KERNEL__
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
+#endif /* __KERNEL__ */
 
 /*
  * standard mode-select header prepended to all mode-select commands
