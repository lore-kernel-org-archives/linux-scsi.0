From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Sun, 11 May 2003 23:38:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512063833.GA4133@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <1052711864.1768.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:50840 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261953AbTELGXa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 02:23:30 -0400
Content-Disposition: inline
In-Reply-To: <1052711864.1768.7.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Fri, 2003-05-09 at 01:33, Mike Anderson wrote:
> > This series of patches is an update to the scsi_host sysfs / ref
> > counting patches previously merged into the scsi-misc-2.5 tree. 
> 
> I'm still getting an oops in a scsi_register followed by a
> scsi_unregister (because of an error in the driver setup).  The problem
> occurs because the mid-layer is now dependent on the host_gendev.release
> method.  Unfortunately, this isn't set until scsi_host_add, which may be
> quite a while after scsi_register.
> 
> The quick "fix" is attached below, but I think we need all of this to be
> symmetric (i.e. scsi_unregister can be called any time after
> scsi_register) so probably the host_gendev.release method should be set
> elsewhere.

I agree on the symmetric interface. I attached a patch that adds a
scsi_sysfs_init_host function call which moves more initialization during
the scsi_register time frame.

I tested the attached patch on my current config of ips, qlogicisp,
aic7xxx, and scsi_debug.

Can you run this on your system and see if it addresses your issue? If
not I can hack scsi_debug to make back to back scsi_register /
scsi_unregister calls.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
Patch against scsi-misc-2.5

Fix scsi sysfs init so that a scsi_unregister can be called anytime after
a scsi_register.
- Create scsi_sysfs_init_host function and call from
scsi_register.
EDESC


 drivers/scsi/hosts.c      |    4 ++--
 drivers/scsi/scsi_priv.h  |    1 +
 drivers/scsi/scsi_sysfs.c |   25 ++++++++++++++++---------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsi_priv.h~scsi_unregister-syfs-fix drivers/scsi/scsi_priv.h
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_priv.h~scsi_unregister-syfs-fix	Sun May 11 22:05:01 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_priv.h	Sun May 11 22:12:54 2003
@@ -123,6 +123,7 @@ extern int scsi_device_register(struct s
 extern void scsi_device_unregister(struct scsi_device *);
 extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
 extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+extern void scsi_sysfs_init_host(struct Scsi_Host *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_sysfs_remove_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
diff -puN drivers/scsi/scsi_sysfs.c~scsi_unregister-syfs-fix drivers/scsi/scsi_sysfs.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~scsi_unregister-syfs-fix	Sun May 11 22:06:08 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Sun May 11 22:12:40 2003
@@ -321,6 +321,22 @@ static void scsi_host_release(struct dev
 	scsi_free_shost(shost);
 }
 
+void scsi_sysfs_init_host(struct Scsi_Host *shost)
+{
+	device_initialize(&shost->host_gendev);
+	snprintf(shost->host_gendev.bus_id, BUS_ID_SIZE, "host%d",
+		shost->host_no);
+	snprintf(shost->host_gendev.name, DEVICE_NAME_SIZE, "%s",
+		shost->hostt->proc_name);
+	shost->host_gendev.release = scsi_host_release;
+
+	class_device_initialize(&shost->class_dev);
+	shost->class_dev.dev = &shost->host_gendev;
+	shost->class_dev.class = &shost_class;
+	snprintf(shost->class_dev.class_id, BUS_ID_SIZE, "host%d",
+		  shost->host_no);
+}
+
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
@@ -330,22 +346,13 @@ int scsi_sysfs_add_host(struct Scsi_Host
 {
 	int i, error;
 
-	snprintf(shost->host_gendev.bus_id, BUS_ID_SIZE, "host%d",
-		shost->host_no);
-	snprintf(shost->host_gendev.name, DEVICE_NAME_SIZE, "%s",
-		shost->hostt->proc_name);
 	if (!shost->host_gendev.parent)
 		shost->host_gendev.parent = (dev) ? dev : &legacy_bus;
-	shost->host_gendev.release = scsi_host_release;
 
 	error = device_add(&shost->host_gendev);
 	if (error)
 		return error;
 
-	shost->class_dev.dev = &shost->host_gendev;
-	shost->class_dev.class = &shost_class;
-	snprintf(shost->class_dev.class_id, BUS_ID_SIZE, "host%d",
-		  shost->host_no);
 	error = class_device_add(&shost->class_dev);
 	if (error)
 		goto clean_device;
diff -puN drivers/scsi/hosts.c~scsi_unregister-syfs-fix drivers/scsi/hosts.c
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.c~scsi_unregister-syfs-fix	Sun May 11 22:06:19 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.c	Sun May 11 22:11:08 2003
@@ -405,8 +405,8 @@ found:
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
 		goto fail;
-	device_initialize(&shost->host_gendev);
-	class_device_initialize(&shost->class_dev);
+
+	scsi_sysfs_init_host(shost);
 
 	shost->eh_notify = &sem;
 	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);

_
