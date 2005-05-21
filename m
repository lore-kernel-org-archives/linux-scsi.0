From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Sat, 21 May 2005 14:39:48 -0700
Message-ID: <1116711588.6289.32.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30696 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261632AbVEUVjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 17:39:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi <open-iscsi@googlegroups.com>, linux-scsi@vger.kernel.org

Implement transport specific scanning function for open-iscsi.
This fixes the sysfs layout so it looks like this:

[root@mina host1]# tree
.
`-- session1
    |-- connection1:0
    `-- target1:0:0
        |-- 1:0:0:0

representing the relationship between a session and a target.
open-iscsi/linux-iscsi-5 uses struct devices and driver mode transport
classes like in past sumbitted patches here
http://marc.theaimsgroup.com/?l=linux-scsi&m=111618626124050&w=2

This patches against the subversion source found at
open-iscsi.org or the currect release
http://www.open-iscsi.org/bits/open-iscsi-0.3rc4-325.tar.gz
open-iscsi is not in mainline, but we are trying :). I only
post this to show an example of the callout usage since I do not
have access to a box (or really the serial line to reboot it) with
FC to fix the fc transport class today, and to make sure open-iscsi
is even doing the correct sysfs layout wrt to struct devices and
transport_classes and what should link to what.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff -aurp open-iscsi/kernel/scsi_transport_iscsi.c open-iscsi.work/kernel/scsi_transport_iscsi.c
--- open-iscsi/kernel/scsi_transport_iscsi.c	2005-05-21 14:03:04.000000000 -0700
+++ open-iscsi.work/kernel/scsi_transport_iscsi.c	2005-05-21 14:21:00.000000000 -0700
@@ -887,6 +887,15 @@ iscsi_if_rx(struct sock *sk, int len)
 	up(&rx_queue_sema);
 }
 
+static int
+iscsi_scan(struct Scsi_Host *shost, unsigned int channel, unsigned int id,
+	   unsigned int lun, int rescan)
+{
+	struct iscsi_if_session *session = hostdata_session(shost->hostdata);
+	scsi_scan_target(&session->dev, channel, id, lun, rescan);
+	return 0;
+}
+
 /*
  * iSCSI connection attrs
  */
@@ -1039,6 +1048,7 @@ int iscsi_register_transport(struct iscs
 	INIT_LIST_HEAD(&priv->sessions);
 	spin_lock_init(&priv->session_lock);
 	priv->iscsi_transport = tt;
+	priv->t.scan = iscsi_scan;
 
 	/* setup parameters mask */
 	priv->param_mask = 0xFFFFFFFF;
diff -aurp open-iscsi/usr/initiator.c open-iscsi.work/usr/initiator.c
--- open-iscsi/usr/initiator.c	2005-05-21 14:03:05.000000000 -0700
+++ open-iscsi.work/usr/initiator.c	2005-05-21 14:03:50.000000000 -0700
@@ -181,7 +181,7 @@ __session_scan_host(iscsi_session_t *ses
 		/* child */
 		log_debug(4, "scanning host%d using %s",session->id,
 			  sysfs_file);
-		write(fd, "- - -", 5);
+		write(fd, "0 0 -", 5);
 		close(fd);
 		exit(0);
 	}


