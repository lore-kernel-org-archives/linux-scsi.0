From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix oops when removing scsi_host while IO is outstanding
 (and when using scsi_target patches)
Date: Sat, 09 Oct 2004 08:28:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416803A4.5000202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090808060003040909080007"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53701 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S266896AbUJIP2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 11:28:44 -0400
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id i99FSgbu031432
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 9 Oct 2004 10:28:43 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090808060003040909080007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

When trying to remove a host while IO is running I will get the folling warning,
and after these messages my log fills up with various oops.

Oct  9 04:54:44 mina kernel:  target0:0:0: Illegal state transition <NULL>->cancel
Oct  9 04:54:44 mina kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713
Oct  9 04:54:44 mina kernel:  [<c010585e>] dump_stack+0x1e/0x30
Oct  9 04:54:44 mina kernel:  [<f8831316>] scsi_device_set_state+0xc6/0x130 [scsi_mod]
Oct  9 04:54:44 mina kernel:  [<f88290fc>] scsi_device_cancel+0x3c/0x263 [scsi_mod]
Oct  9 04:54:44 mina kernel:  [<c02c280d>] device_for_each_child+0x4d/0x80
Oct  9 04:54:44 mina kernel:  [<f88293c2>] scsi_host_cancel+0x32/0xc0 [scsi_mod]
Oct  9 04:54:44 mina kernel:  [<f8829472>] scsi_remove_host+0x22/0x70 [scsi_mod]

Note the target dev name and NULL state.

Basically, scsi_host_cancel is doing a device_for_each_child thinking it's
children are scsi_devices, but in the scsi-target-2.6 tree they are now
targets. The attached patch fixes this by just adding the extra
device_for_each_child loop to get to the scsi device. It was built against
the current scsi-target-2.6 tree.

Mike

--------------090808060003040909080007
Content-Type: text/x-patch;
 name="cancel-scsi-targets.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cancel-scsi-targets.patch"

--- scsi-target-2.6/drivers/scsi/hosts.c	2004-10-09 07:56:54.363746835 -0700
+++ scsi-target-2.6.work/drivers/scsi/hosts.c	2004-10-09 07:49:21.287638490 -0700
@@ -55,6 +55,12 @@
 	return scsi_device_cancel(to_scsi_device(dev), *(int *)data);
 }
 
+static int scsi_target_cancel_cb(struct device *dev, void *data)
+{
+	device_for_each_child(dev, data, scsi_device_cancel_cb);
+	return 0;
+}
+
 /**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
@@ -64,7 +70,7 @@
 {
 	set_bit(SHOST_CANCEL, &shost->shost_state);
 	device_for_each_child(&shost->shost_gendev, &recovery,
-			      scsi_device_cancel_cb);
+			      scsi_target_cancel_cb);
 	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
 						&shost->shost_state)));
 }

--------------090808060003040909080007--
