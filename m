From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] export print_sense_internal
Date: Wed, 05 Jan 2005 11:39:01 -0800
Message-ID: <41DC4255.7050109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040701090307030007030904"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:12999 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262140AbVAETjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 14:39:08 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j05Jd65E023916
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2005 13:39:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040701090307030007030904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Currently, we have scsi_print_sense and
scsi_print_req_sense, but the linux-iscsi
driver receives async messages from
a target that may contain SCSI sense data
and these messages are not tied to any
specific command. So that we can use the
scsi-ml sense printing capabilities the
attached patch exports exports
print_sense_internal and renames it to
__scsi_print_sense.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Oh yeah we are working to gettting the driver
in mainline so there will be a user of the
the interface soon (I hope soon).

--------------040701090307030007030904
Content-Type: text/x-patch;
 name="scsi-print.sense.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-print.sense.patch"

diff -aurp scsi-misc-2.6.orig/drivers/scsi/constants.c scsi-misc-2.6.sense/drivers/scsi/constants.c
--- scsi-misc-2.6.orig/drivers/scsi/constants.c	2005-01-05 03:14:48.000000000 -0800
+++ scsi-misc-2.6.sense/drivers/scsi/constants.c	2005-01-05 03:25:05.394602699 -0800
@@ -1156,17 +1156,14 @@ scsi_show_extd_sense(unsigned char asc, 
 }
 
 /* Print sense information */
-static void
-print_sense_internal(const char *devclass, 
-		     const unsigned char *sense_buffer,
-		     int sense_len,
-		     struct request *req)
+void
+__scsi_print_sense(const char *name, const unsigned char *sense_buffer,
+		   int sense_len)
 {
 	int k, num, res;
 	unsigned int info;
 	const char *error;
 	const char *sense_txt;
-	const char *name = req->rq_disk ? req->rq_disk->disk_name : devclass;
 	struct scsi_sense_hdr ssh;
     
 	res = scsi_normalize_sense(sense_buffer, sense_len, &ssh);
@@ -1254,18 +1251,25 @@ print_sense_internal(const char *devclas
 		printk("\n");
 	}
 }
+EXPORT_SYMBOL(__scsi_print_sense);
 
 void scsi_print_sense(const char *devclass, struct scsi_cmnd *cmd)
 {
-	print_sense_internal(devclass, cmd->sense_buffer,
-			     SCSI_SENSE_BUFFERSIZE, cmd->request);
+	const char *name = devclass;
+
+	if (cmd->request->rq_disk)
+		name = cmd->request->rq_disk->disk_name;
+	__scsi_print_sense(name, cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
 void scsi_print_req_sense(const char *devclass, struct scsi_request *sreq)
 {
-	print_sense_internal(devclass, sreq->sr_sense_buffer,
-			     SCSI_SENSE_BUFFERSIZE, sreq->sr_request);
+	const char *name = devclass;
+
+	if (sreq->sr_request->rq_disk)
+		name = sreq->sr_request->rq_disk->disk_name;
+	__scsi_print_sense(name, sreq->sr_sense_buffer, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_req_sense);

diff -aurp scsi-misc-2.6.orig/include/scsi/scsi_dbg.h scsi-misc-2.6.sense/include/scsi/scsi_dbg.h
--- scsi-misc-2.6.orig/include/scsi/scsi_dbg.h	2005-01-05 03:14:48.000000000 -0800
+++ scsi-misc-2.6.sense/include/scsi/scsi_dbg.h	2005-01-05 03:11:58.000000000 -0800
@@ -8,6 +8,9 @@ extern void scsi_print_command(struct sc
 extern void __scsi_print_command(unsigned char *);
 extern void scsi_print_sense(const char *, struct scsi_cmnd *);
 extern void scsi_print_req_sense(const char *, struct scsi_request *);
+extern void __scsi_print_sense(const char *name,
+			       const unsigned char *sense_buffer,
+			       int sense_len);
 extern void scsi_print_driverbyte(int);
 extern void scsi_print_hostbyte(int);
 extern void scsi_print_status(unsigned char);

--------------040701090307030007030904--
