From: Douglas Gilbert <dougg@torque.net>
Subject: Fwd: [PATCH] 2.5.54 fix ide-cd/ide-scsi oopses after module unload
Date: Sat, 04 Jan 2003 22:18:44 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E16C314.1060307@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010706080400060808030004"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mikpe@csd.uu.se, wrlk@riede.org

This is a multi-part message in MIME format.
--------------010706080400060808030004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mikael Pettersson posted the following to the linux-kernel
mailing list. His patch includes a fix that Willem Riede
spotted as well (no driver_unregister() in ide.c). Willem
also had other changes in ide-scsi.c which are still pending.
See attached file.


Doug Gilbert


Mikael Pettersson wrote on lkml:
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

In 2.5 (the bug's been there since 2.5.42), rmmod:ing a
modular IDE subdriver like ide-cd or ide-scsi and then
rebooting causes an oops in device_shutdown(). This is because
the IDE layer doesn't reset the drive->gendev.driver pointer
that it previously set up to point to data structures in the
subdriver module. device_shutdown() sees a non-NULL ->driver,
dereferences it, and oopses.

The patch below for 2.5.54 fixes two generic bugs related to
unloading of modular IDE subdrivers, and one specific to ide-scsi:

1. ata_attach() needs to set drive->gendev.driver = NULL
    when no specific driver claims the drive. This prevents a
    drive previously owned by a subdriver module from keeping
    its ->gendev.driver pointing into that module.

2. ide_unregister_driver() needs to unregister &driver->gen_driver;
    this is to balance the corresponding register call in
    ide_register_driver(). [This part of the patch is originally
    by Patrick Mochel.]

3. ide-scsi.c abuses ide_driver_t's busy field as a counter
    while the field in fact is a single-bit boolean. This causes
    the busyness of the driver to be incorrect while the driver
    is active. (From my recent patch for 2.4.20-ac2/2.4.21-pre2.)

With these three fixes modular ide-cd and ide-scsi work quite
reliably for me in 2.5.54.

/Mikael

diff -ruN linux-2.5.54/drivers/ide/ide.c 
linux-2.5.54.ide-fixes/drivers/ide/ide.c
--- linux-2.5.54/drivers/ide/ide.c	2003-01-02 14:27:55.000000000 +0100
+++ linux-2.5.54.ide-fixes/drivers/ide/ide.c	2003-01-04 
02:34:02.000000000 +0100
@@ -1346,6 +1346,7 @@
  	spin_unlock(&drivers_lock);
  	spin_lock(&drives_lock);
  	list_add_tail(&drive->list, &ata_unused);
+	drive->gendev.driver = NULL;
  	spin_unlock(&drives_lock);
  	return 1;
  }
@@ -2308,6 +2309,8 @@
  	list_del(&driver->drivers);
  	spin_unlock(&drivers_lock);

+	driver_unregister(&driver->gen_driver);
+
  	while(!list_empty(&driver->drives)) {
  		drive = list_entry(driver->drives.next, ide_drive_t, list);
  		if (driver->cleanup(drive)) {
diff -ruN linux-2.5.54/drivers/scsi/ide-scsi.c 
linux-2.5.54.ide-fixes/drivers/scsi/ide-scsi.c
--- linux-2.5.54/drivers/scsi/ide-scsi.c	2002-12-24 13:53:50.000000000 +0100
+++ linux-2.5.54.ide-fixes/drivers/scsi/ide-scsi.c	2003-01-04 
02:34:02.000000000 +0100
@@ -590,6 +590,7 @@
  	set_bit(IDESCSI_LOG_CMD, &scsi->log);
  #endif /* IDESCSI_DEBUG_LOG */
  	idescsi_add_settings(drive);
+	DRIVER(drive)->busy--;
  }

  static int idescsi_cleanup (ide_drive_t *drive)
@@ -995,7 +996,7 @@
  	for (id = 0; id < MAX_HWIFS * MAX_DRIVES; id++) {
  		drive = idescsi_drives[id];
  		if (drive)
-			DRIVER(drive)->busy--;
+			DRIVER(drive)->busy = 0;
  	}
  	scsi_unregister   (idescsi_host);
  	device_unregister(&idescsi_primary);
-
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

--------------010706080400060808030004
Content-Type: text/plain;
 name="ide-scsi_2553wr2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi_2553wr2.diff"

--- linux/drivers/scsi/ide-scsi.c	2002-12-24 18:12:54.000000000 +1100
+++ linux/drivers/scsi/ide-scsi.c2553wr2	2002-12-24 09:30:17.000000000 +1100
@@ -289,6 +289,7 @@
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_command->special;
+	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -876,7 +877,8 @@
 			/* is cmd active?
 			 *  need to lock so this stuff doesn't change under us */
 			spin_lock_irqsave(&ide_lock, flags);
-			if (scsi->pc && scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+			if (scsi->pc && scsi->pc->scsi_cmd && 
+					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
 				/* yep - let's give it some more time - 
 				 * we can do that, we're in _our_ error kernel thread */
 				spin_unlock_irqrestore(&ide_lock, flags);

--------------010706080400060808030004--

