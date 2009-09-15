From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCHv4] qla2xxx: Add firmware-dump kobject uevent notification.
Date: Tue, 15 Sep 2009 09:44:15 -0700
Message-ID: <20090915164415.GD46353@plap4-2.local>
References: <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
 <20090912001752.GC12098@plap4-2.local>
 <20090912003808.GD12098@plap4-2.local>
 <20090912005446.GA11691@kroah.com>
 <20090912025623.GA14824@plap4-2.local>
 <20090912043333.GA12349@kroah.com>
 <1252765807.4238.74.camel@mulgrave.site>
 <20090915153312.GB22774@kroah.com>
 <1253029631.29947.156.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1253029631.29947.156.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

On Tue, 15 Sep 2009, James Bottomley wrote:
> On Tue, 2009-09-15 at 08:33 -0700, Greg KH wrote:
> > On Sat, Sep 12, 2009 at 09:30:07AM -0500, James Bottomley wrote:
> > > On Fri, 2009-09-11 at 21:33 -0700, Greg KH wrote:
> > > > On Fri, Sep 11, 2009 at 07:56:23PM -0700, Andrew Vasquez wrote:
> > > > > On Fri, 11 Sep 2009, Greg KH wrote:
> > > > > 
> > > > > > On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez wrote:
> > > > > > > Randy Dunlap noted:
> > > > > > > 
> > > > > > >   when CONFIG_MODULES=n:
> > > > > > > 
> > > > > > > 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > > > > > > 
> > > > > > >   in
> > > > > > > 
> > > > > > > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > > > > > > 		KOBJ_CHANGE, envp);
> > > > > > > 
> > > > > > > Trigger kobject event on the 'struct device' hanging off the pci_dev.
> > > > > > 
> > > > > > Um, why?  What are you trying to do here?  kobject change should not be
> > > > > > for a device, or a "normal" kobject.
> > > > > > 
> > > > > > What do you expect userspace to do with this?  Where have you documented
> > > > > > it?
> > > > > 
> > > > > The purpose was described here:
> > > > > 
> > > > > 	http://article.gmane.org/gmane.linux.scsi/54155
> > > > > 
> > > > > Basically we'd like to instruct user-space to retrieve a blob of data
> > > > > automatically.
> > > > 
> > > > Hm, like a firmware object perhaps?
> > > > 
> > > > > Original implementation used the kboject hanging off
> > > > > the module which does not exist when CONFIG_MODULES=n.  It was
> > > > > suggested that perhaps an alternative would be to use 'struct device'
> > > > > kobj.  Any tips on how to trigger such a driver-specific event,
> > > > > perhaps a dedicated kobject exported by the driver itself???
> > > > 
> > > > Why not use the firmware interface for it, that is what it is designed
> > > > for, and you will not have to craft any new udev rules.
> > > 
> > > The data is going the wrong way to use the current firmware interface,
> > > which is designed to load data from userspace into the kernel.  For this
> > > interface, we want the data to go the other way (i.e. the kernel has a
> > > blob of dump data it would like userspace to save if it can).
> > 
> > Ick.
> 
> It's a natural debugging event ... the user can simply program the
> system to discard the dump.
> 
> > > I'd be amenable to updating the firmware interface to do this, but it
> > > looks like adding a completely new codepath, which it's not clear even
> > > belongs there.
> > 
> > Well, I don't think it deserves a kobject change event, as that means
> > something a bit different to userspace today, right?
> 
> Well, the documentation (in include/linux/kobject.h) does say that
> KOBJ_CHANGED is the dumping ground for events that don't match anything
> else, which this one seems to qualify as.  What else do you suggest?
> 
> > Either way, I see no documentation being added to the Documentation/ABI/
> > directory describing what is happening here, that needs to be added at
> > the least.
> 
> OK, we can add that in the next go around.
> 
> Andrew, I actually dropped the patch (just this one, not the rest of the
> qla2xxx patches) from the tree, so we can work on updating this as a
> whole.

Ok, how about this squashed commit as a first stab at documenting the
ABI???

Thanks, AV

 Documentation/ABI/stable/sysfs-driver-qla2xxx |    8 +++
 drivers/scsi/qla2xxx/qla_dbg.c                |   78 +++++++-----------------
 drivers/scsi/qla2xxx/qla_def.h                |    5 ++
 drivers/scsi/qla2xxx/qla_gbl.h                |    1 +
 drivers/scsi/qla2xxx/qla_os.c                 |   35 +++++++++++
 5 files changed, 72 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-qla2xxx

diff --git a/Documentation/ABI/stable/sysfs-driver-qla2xxx b/Documentation/ABI/stable/sysfs-driver-qla2xxx
new file mode 100644
index 0000000..9a59d84
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-qla2xxx
@@ -0,0 +1,8 @@
+What:		/sys/bus/pci/drivers/qla2xxx/.../devices/*
+Date:		September 2009
+Contact:	QLogic Linux Driver <linux-driver@qlogic.com>
+Description:	qla2xxx-udev.sh currently looks for uevent CHANGE events to
+		signal a firmware-dump has been generated by the driver and is
+		ready for retrieval.
+Users:		qla2xxx-udev.sh.  Proposed changes should be mailed to
+		linux-driver@qlogic.com
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cca8e4a..cb2eca4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -377,6 +377,24 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	return ptr + sizeof(struct qla2xxx_mq_chain);
 }
 
+static void
+qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
+	} else {
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump saved to temp buffer (%ld/%p).\n",
+		    vha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
+		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
+	}
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -530,17 +548,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval == QLA_SUCCESS)
 		qla2xxx_copy_queues(ha, nxt);
 
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2300_fw_dump_failed:
 	if (!hardware_locked)
@@ -737,17 +745,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval == QLA_SUCCESS)
 		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
 
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2100_fw_dump_failed:
 	if (!hardware_locked)
@@ -984,17 +982,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla24xx_copy_eft(ha, nxt);
 
 qla24xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla24xx_fw_dump_failed:
 	if (!hardware_locked)
@@ -1305,17 +1293,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 qla25xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla25xx_fw_dump_failed:
 	if (!hardware_locked)
@@ -1628,17 +1606,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 qla81xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla81xx_fw_dump_failed:
 	if (!hardware_locked)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2150618..d8ce310 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2123,6 +2123,7 @@ enum qla_work_type {
 	QLA_EVT_ASYNC_LOGIN_DONE,
 	QLA_EVT_ASYNC_LOGOUT,
 	QLA_EVT_ASYNC_LOGOUT_DONE,
+	QLA_EVT_UEVENT,
 };
 
 
@@ -2146,6 +2147,10 @@ struct qla_work_evt {
 #define QLA_LOGIO_LOGIN_RETRIED	BIT_0
 			u16 data[2];
 		} logio;
+		struct {
+			u32 code;
+#define QLA_UEVENT_CODE_FW_DUMP	0
+		} uevent;
 	} u;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f3d1d1a..14e0562 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -92,6 +92,7 @@ extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
     fc_port_t *, uint16_t *);
+extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b79fca7..ecf2a40 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
+#include <linux/kobject.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2653,6 +2654,37 @@ qla2x00_post_async_work(login_done, QLA_EVT_ASYNC_LOGIN_DONE);
 qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
 qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
 
+int
+qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_UEVENT);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.uevent.code = code;
+	return qla2x00_post_work(vha, e);
+}
+
+static void
+qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
+{
+	char event_string[40];
+	char *envp[] = { event_string, NULL };
+
+	switch (code) {
+	case QLA_UEVENT_CODE_FW_DUMP:
+		snprintf(event_string, sizeof(event_string), "FW_DUMP=%ld",
+		    vha->host_no);
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+	kobject_uevent_env(&vha->hw->pdev->dev.kobj, KOBJ_CHANGE, envp);
+}
+
 void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -2690,6 +2722,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			qla2x00_async_logout_done(vha, e->u.logio.fcport,
 			    e->u.logio.data);
 			break;
+		case QLA_EVT_UEVENT:
+			qla2x00_uevent_emit(vha, e->u.uevent.code);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-- 
1.6.5.rc0
