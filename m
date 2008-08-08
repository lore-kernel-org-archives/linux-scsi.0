From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_host_lookup: error returns and NULL pointers
Date: Thu, 07 Aug 2008 20:18:02 -0400
Message-ID: <1218154682.4689.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41532 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbYHHStv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 14:49:51 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m78Ini0S020879
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 11:49:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch cleans up the behavior of scsi_host_lookup().

The original implementation attempted to use the dual role of
either returning a pointer value, or a negative error code.
Consumer's needed to use IS_ERR() to check the result. This is
a bit obtuse. Additionally, the IS_ERR() macro uses unsigned
int math to check for negative error values vs a pointer
(e.g. all negative values between F's and -MAXERRNO are errors).
Meaning - IS_ERR() never sees a NULL pointer as an error.
NULL pointers can be returned via scsi_host_get(), which is
used by scsi_host_lookup().

Talk about a pothole for the uninitiated to step into....
And, none of the current consumers cared about the ERR_PTR
value returned.

This patch converts scsi_host_lookup() to return either NULL
or a valid pointer. The consumers were updated for the change.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 hosts.c                |    2 +-
 scsi_proc.c            |    8 ++++----
 scsi_tgt_lib.c         |    6 +++---
 scsi_transport_iscsi.c |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2008-07-30 13:05:11.000000000 -0400
+++ b/drivers/scsi/hosts.c	2008-08-07 19:27:46.000000000 -0400
@@ -464,7 +464,7 @@ static int __scsi_host_match(struct devi
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
 	struct device *cdev;
-	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
+	struct Scsi_Host *shost = NULL;
 
 	cdev = class_find_device(&shost_class, NULL, &hostnum,
 				 __scsi_host_match);
diff -upNr a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	2008-07-30 13:05:12.000000000 -0400
+++ b/drivers/scsi/scsi_proc.c	2008-08-07 19:31:46.000000000 -0400
@@ -259,8 +259,8 @@ static int scsi_add_single_device(uint h
 	int error = -ENXIO;
 
 	shost = scsi_host_lookup(host);
-	if (IS_ERR(shost))
-		return PTR_ERR(shost);
+	if (!shost)
+		return error;
 
 	if (shost->transportt->user_scan)
 		error = shost->transportt->user_scan(shost, channel, id, lun);
@@ -287,8 +287,8 @@ static int scsi_remove_single_device(uin
 	int error = -ENXIO;
 
 	shost = scsi_host_lookup(host);
-	if (IS_ERR(shost))
-		return PTR_ERR(shost);
+	if (!shost) 
+		return error;
 	sdev = scsi_device_lookup(shost, channel, id, lun);
 	if (sdev) {
 		scsi_remove_device(sdev);
diff -upNr a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c	2008-05-05 11:28:09.000000000 -0400
+++ b/drivers/scsi/scsi_tgt_lib.c	2008-08-07 19:32:34.000000000 -0400
@@ -460,7 +460,7 @@ int scsi_tgt_kspace_exec(int host_no, u6
 
 	/* TODO: replace with a O(1) alg */
 	shost = scsi_host_lookup(host_no);
-	if (IS_ERR(shost)) {
+	if (!shost) {
 		printk(KERN_ERR "Could not find host no %d\n", host_no);
 		return -EINVAL;
 	}
@@ -550,7 +550,7 @@ int scsi_tgt_kspace_tsk_mgmt(int host_no
 	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
 
 	shost = scsi_host_lookup(host_no);
-	if (IS_ERR(shost)) {
+	if (!shost) {
 		printk(KERN_ERR "Could not find host no %d\n", host_no);
 		return err;
 	}
@@ -603,7 +603,7 @@ int scsi_tgt_kspace_it_nexus_rsp(int hos
 	dprintk("%d %d%llx\n", host_no, result, (unsigned long long)itn_id);
 
 	shost = scsi_host_lookup(host_no);
-	if (IS_ERR(shost)) {
+	if (!shost) {
 		printk(KERN_ERR "Could not find host no %d\n", host_no);
 		return err;
 	}
diff -upNr a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	2008-07-30 13:05:12.000000000 -0400
+++ b/drivers/scsi/scsi_transport_iscsi.c	2008-08-07 19:29:14.000000000 -0400
@@ -1361,7 +1361,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *
 		return -EINVAL;
 
 	shost = scsi_host_lookup(ev->u.tgt_dscvr.host_no);
-	if (IS_ERR(shost)) {
+	if (!shost) {
 		printk(KERN_ERR "target discovery could not find host no %u\n",
 		       ev->u.tgt_dscvr.host_no);
 		return -ENODEV;
@@ -1387,7 +1387,7 @@ iscsi_set_host_param(struct iscsi_transp
 		return -ENOSYS;
 
 	shost = scsi_host_lookup(ev->u.set_host_param.host_no);
-	if (IS_ERR(shost)) {
+	if (!shost) {
 		printk(KERN_ERR "set_host_param could not find host no %u\n",
 		       ev->u.set_host_param.host_no);
 		return -ENODEV;


