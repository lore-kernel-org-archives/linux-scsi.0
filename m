From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Transport Attributes -- attempt#4
Date: 23 Feb 2004 18:17:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077581832.1833.21.camel@mulgrave>
References: <20040120215645.GG15871@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3SAaQYj0WiGEbTPqpFca"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54662 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261626AbUBXARP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 19:17:15 -0500
In-Reply-To: <20040120215645.GG15871@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-3SAaQYj0WiGEbTPqpFca
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2004-01-20 at 15:56, Martin Hicks wrote:
> Updated patches against Linus' bk tree from earlier today.  The patch
> that fixes up the scsi_sysfs.c error path, that was sent out by me on
> Jan 16, is required for the core patch to apply cleanly.
> 
> I think I've addressed all the comments from the last round with the
> exception of doing Lazy registration of the transport classes.  I'm
> still not totally convinced that this is really required.

OK, I finally found time to look at all this and try it out.

My big objection is still that the scsi mid-layer needs to know about
the transports.  In testing, I recoded this so that no mid-layer
transport knowledge is necessary (patch attached).  I didn't opt for a
transport registration API in the mid-layer, but I could see that such a
thing might have been a better solution.

I also see no necessity to allow hosts to add arbitrary transport
attributes: they can simply add extra device attributes to the same
effect.  This means that the attribute list is fixed, and we develop a
private API between the transport and the device driver to update
attributes (I didn't code this, but you can see where I'm going with
it).

There were a few other initialisation touches (Like making the
attributes part of the host structure directly), and initialising the
default transportt correctly in the host_alloc.

I did my implementation for the 53c700 which is the driver I can readily
use.  As you can see, the other half of this is shifting the driver
internally to use the transport attribute values (so that whatever we
find there can be directly exported to the user).

James


--=-3SAaQYj0WiGEbTPqpFca
Content-Disposition: attachment; filename=xprt.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=xprt.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/Kconfig 1.57 vs edited =3D=3D=3D=3D=3D
--- 1.57/drivers/scsi/Kconfig	Mon Feb 23 14:41:38 2004
+++ edited/drivers/scsi/Kconfig	Mon Feb 23 15:51:15 2004
@@ -200,14 +200,14 @@
 	depends on SCSI
=20
 config SCSI_SPI_ATTRS
-	bool "Parallel SCSI (SPI) Transport Attributes"
+	tristate "Parallel SCSI (SPI) Transport Attributes"
 	depends on SCSI
 	help
 	  If you wish to export transport-specific information about
 	  each attached SCSI device to sysfs, say Y.  Otherwise, say N.
=20
 config SCSI_FC_ATTRS
-	bool "FiberChannel Transport Attributes"
+	tristate "FiberChannel Transport Attributes"
 	depends on SCSI
 	help
 	  If you wish to export transport-specific information about
=3D=3D=3D=3D=3D drivers/scsi/Makefile 1.56 vs edited =3D=3D=3D=3D=3D
--- 1.56/drivers/scsi/Makefile	Mon Feb 23 14:59:02 2004
+++ edited/drivers/scsi/Makefile	Mon Feb 23 15:53:07 2004
@@ -22,6 +22,14 @@
=20
 obj-$(CONFIG_SCSI)		+=3D scsi_mod.o
=20
+# --- NOTE ORDERING HERE ---
+# For kernel non-modular link, transport attributes need to
+# be initialised before drivers
+# --------------------------
+obj-$(CONFIG_SCSI_SPI_ATTRS)	+=3D scsi_transport_spi.o
+obj-$(CONFIG_SCSI_FC_ATTRS) 	+=3D scsi_transport_fc.o
+
+
 obj-$(CONFIG_SCSI_AMIGA7XX)	+=3D amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+=3D a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+=3D a2091.o	wd33c93.o
@@ -130,8 +138,6 @@
 scsi_mod-$(CONFIG_SYSCTL)	+=3D scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+=3D scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+=3D scsi_pc98.o
-scsi_mod-$(CONFIG_SCSI_SPI_ATTRS) +=3D scsi_transport_spi.o
-scsi_mod-$(CONFIG_SCSI_FC_ATTRS)  +=3D scsi_transport_fc.o
=20
 sd_mod-objs	:=3D sd.o
 sr_mod-objs	:=3D sr.o sr_ioctl.o sr_vendor.o
=3D=3D=3D=3D=3D drivers/scsi/hosts.c 1.96 vs edited =3D=3D=3D=3D=3D
--- 1.96/drivers/scsi/hosts.c	Mon Dec 29 15:38:10 2003
+++ edited/drivers/scsi/hosts.c	Mon Feb 23 17:22:26 2004
@@ -32,6 +32,7 @@
 #include <linux/unistd.h>
=20
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
=20
 #include "scsi_priv.h"
@@ -221,6 +222,11 @@
 	shost->max_channel =3D 0;
 	shost->max_id =3D 8;
 	shost->max_lun =3D 8;
+
+	/* Give each shost a default transportt if the driver
+	 * doesn't yet support Transport Attributes */
+	if (!shost->transportt)=20
+		shost->transportt =3D &blank_transport_template;
=20
 	/*
 	 * All drivers right now should be able to handle 12 byte
=3D=3D=3D=3D=3D drivers/scsi/scsi_scan.c 1.116 vs edited =3D=3D=3D=3D=3D
--- 1.116/drivers/scsi/scsi_scan.c	Mon Feb 23 14:41:38 2004
+++ edited/drivers/scsi/scsi_scan.c	Mon Feb 23 17:22:08 2004
@@ -193,7 +193,7 @@
 	struct scsi_device *sdev, *device;
 	unsigned long flags;
=20
-	sdev =3D kmalloc(sizeof(*sdev), GFP_ATOMIC);
+	sdev =3D kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);
 	if (!sdev)
 		goto out;
=20
@@ -237,11 +237,6 @@
 		if (shost->hostt->slave_alloc(sdev))
 			goto out_free_queue;
 	}
-
-	/* Give each shost a default transportt if the driver
-	 * doesn't yet support Transport Attributes */
-	if (!shost->transportt)=20
-		shost->transportt =3D &blank_transport_template;
=20
 	if (shost->transportt->setup) {
 		if (shost->transportt->setup(sdev))
=3D=3D=3D=3D=3D drivers/scsi/scsi_sysfs.c 1.40 vs edited =3D=3D=3D=3D=3D
--- 1.40/drivers/scsi/scsi_sysfs.c	Mon Feb 23 14:41:38 2004
+++ edited/drivers/scsi/scsi_sysfs.c	Mon Feb 23 15:34:41 2004
@@ -14,8 +14,6 @@
=20
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_spi.h>
-#include <scsi/scsi_transport_fc.h>
 #include "scsi.h"
=20
 #include "scsi_priv.h"
@@ -165,31 +163,13 @@
 	int error;
=20
 	error =3D bus_register(&scsi_bus_type);
-	if (error)
-		return error;
-
-	error =3D class_register(&sdev_class);
-	if (error)
-		goto undo_bus;
-
-	error =3D scsi_spi_transport_init();
-	if (error)
-		goto undo_sdev;
-
-	error =3D scsi_fc_transport_init();
-	if (error)
-		goto undo_all;
+	if (!error) {
+		error =3D class_register(&sdev_class);
+		if (error)
+			bus_unregister(&scsi_bus_type);
+	}
=20
- out:
 	return error;
-
- undo_all:
-	scsi_spi_transport_exit();
- undo_sdev:
-	class_unregister(&sdev_class);
- undo_bus:
-	bus_unregister(&scsi_bus_type);
-	goto out;
 }
=20
 void scsi_sysfs_unregister(void)
@@ -546,4 +526,4 @@
=20
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
-struct scsi_transport_template blank_transport_template;
+struct scsi_transport_template blank_transport_template =3D { 0, };
=3D=3D=3D=3D=3D drivers/scsi/scsi_transport_spi.c 1.1 vs edited =3D=3D=3D=
=3D=3D
--- 1.1/drivers/scsi/scsi_transport_spi.c	Mon Feb 23 14:41:41 2004
+++ edited/drivers/scsi/scsi_transport_spi.c	Mon Feb 23 16:27:08 2004
@@ -17,7 +17,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  =
USA
  */
-
+#include <linux/module.h>
+#include <linux/init.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -30,34 +31,25 @@
 	.release =3D transport_class_release,
 };
=20
-int scsi_spi_transport_init(void)
+static __init int scsi_spi_transport_init(void)
 {
 	return class_register(&spi_transport_class);
 }
=20
-void scsi_spi_transport_exit(void)
+static void __exit scsi_spi_transport_exit(void)
 {
 	class_unregister(&spi_transport_class);
 }
=20
-static int spi_alloc_transport_attrs(struct scsi_device *sdev)
+static int spi_setup_transport_attrs(struct scsi_device *sdev)
 {
-	sdev->transport_attr_values =3D kmalloc(sizeof(struct spi_transport_attrs=
),
-					      GFP_ATOMIC);
-	if (!sdev->transport_attr_values)
-		return -ENOMEM;
-
-	memcpy(sdev->transport_attr_values, sdev->host->transportt->default_attr_=
values,
-	       sizeof(struct spi_transport_attrs));
+	/* FIXME: should callback into the driver to get these values */
+	spi_period(sdev) =3D -1;
+	spi_offset(sdev) =3D -1;
=20
 	return 0;
 }
=20
-static void spi_destroy_transport_attrs(struct scsi_device *sdev)
-{
-	kfree(sdev->transport_attr_values);
-}
-
 static void transport_class_release(struct class_device *class_dev)
 {
 	struct scsi_device *sdev =3D transport_class_to_sdev(class_dev);
@@ -70,7 +62,7 @@
 {										\
 	struct scsi_device *sdev =3D transport_class_to_sdev(cdev);		\
 	struct spi_transport_attrs *tp;						\
-	tp =3D (struct spi_transport_attrs *)sdev->transport_attr_values;		\
+	tp =3D (struct spi_transport_attrs *)&sdev->transport_data;		\
 	return snprintf(buf, 20, format_string, tp->field);			\
 }
=20
@@ -89,16 +81,18 @@
 	NULL
 };
=20
-struct spi_transport_attrs spi_transport_attr_defaults =3D {
-	.period =3D -1,
-	.offset =3D -1,
-};
-
 struct scsi_transport_template spi_transport_template =3D {
 	.attrs =3D spi_transport_attrs,
 	.class =3D &spi_transport_class,
-	.setup =3D &spi_alloc_transport_attrs,
-	.cleanup =3D &spi_destroy_transport_attrs,
-	.default_attr_values =3D &spi_transport_attr_defaults,
+	.setup =3D &spi_setup_transport_attrs,
+	.cleanup =3D NULL,
+	.size =3D sizeof(struct spi_transport_attrs) - sizeof(unsigned long),
 };
 EXPORT_SYMBOL(spi_transport_template);
+
+MODULE_AUTHOR("Martin Hicks");
+MODULE_DESCRIPTION("SPI Transport Attributes");
+MODULE_LICENSE("GPL");
+
+module_init(scsi_spi_transport_init);
+module_exit(scsi_spi_transport_exit);

--=-3SAaQYj0WiGEbTPqpFca
Content-Disposition: attachment; filename=xprt-53c700.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=xprt-53c700.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/53c700.c 1.45 vs edited =3D=3D=3D=3D=3D
--- 1.45/drivers/scsi/53c700.c	Wed Nov 12 08:15:46 2003
+++ edited/drivers/scsi/53c700.c	Mon Feb 23 16:25:03 2004
@@ -137,6 +137,9 @@
 #include "scsi.h"
 #include "hosts.h"
=20
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
 #include "53c700.h"
=20
 /* NOTE: For 64 bit drivers there are points in the code where we use
@@ -236,6 +239,51 @@
 	NCR_700_MAX_OFFSET
 };
=20
+/* This translates the SDTR message offset and period to a value
+ * which can be loaded into the SXFER_REG.
+ *
+ * NOTE: According to SCSI-2, the true transfer period (in ns) is
+ *       actually four times this period value */
+static inline __u8
+NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
+			       __u8 offset, __u8 period)
+{
+	int XFERP;
+
+	__u8 min_xferp =3D (hostdata->chip710
+			  ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
+	__u8 max_offset =3D (hostdata->chip710
+			   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
+	/* NOTE: NCR_700_SDTR_msg[3] contains our offer of the minimum
+	 * period.  It is set in NCR_700_chip_setup() */
+	if(period < NCR_700_SDTR_msg[3]) {
+		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimu=
m, setting to %d\n", period*4, NCR_700_SDTR_msg[3]*4);
+		period =3D NCR_700_SDTR_msg[3];
+	}
+	XFERP =3D (period*4 * hostdata->sync_clock)/1000 - 4;
+	if(offset > max_offset) {
+		printk(KERN_WARNING "53c700: Offset %d exceeds chip maximum, setting to =
%d\n",
+		       offset, max_offset);
+		offset =3D max_offset;
+	}
+	if(XFERP < min_xferp) {
+		printk(KERN_WARNING "53c700: XFERP %d is less than minium, setting to %d=
\n",
+		       XFERP,  min_xferp);
+		XFERP =3D  min_xferp;
+	}
+	return (offset & 0x0f) | (XFERP & 0x07)<<4;
+}
+
+static inline __u8
+NCR_700_get_SXFER(Scsi_Device *SDp)
+{
+	struct NCR_700_Host_Parameters *hostdata =3D=20
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+
+	return NCR_700_offset_period_to_sxfer(hostdata, spi_offset(SDp),
+					      spi_period(SDp));
+}
+
 struct Scsi_Host *
 NCR_700_detect(Scsi_Host_Template *tpnt,
 	       struct NCR_700_Host_Parameters *hostdata)
@@ -326,6 +374,7 @@
 	hostdata->cmd =3D NULL;
 	host->max_id =3D 7;
 	host->max_lun =3D NCR_700_MAX_LUNS;
+	host->transportt =3D &spi_transport_template;
 	host->unique_id =3D hostdata->base;
 	host->base =3D hostdata->base;
 	hostdata->eh_complete =3D NULL;
@@ -520,40 +569,6 @@
 	hostdata->cmd =3D NULL;
 }
=20
-/* This translates the SDTR message offset and period to a value
- * which can be loaded into the SXFER_REG.
- *
- * NOTE: According to SCSI-2, the true transfer period (in ns) is
- *       actually four times this period value */
-STATIC inline __u8
-NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
-			       __u8 offset, __u8 period)
-{
-	int XFERP;
-	__u8 min_xferp =3D (hostdata->chip710
-			  ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
-	__u8 max_offset =3D (hostdata->chip710
-			   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
-	/* NOTE: NCR_700_SDTR_msg[3] contains our offer of the minimum
-	 * period.  It is set in NCR_700_chip_setup() */
-	if(period < NCR_700_SDTR_msg[3]) {
-		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimu=
m, setting to %d\n", period*4, NCR_700_SDTR_msg[3]*4);
-		period =3D NCR_700_SDTR_msg[3];
-	}
-	XFERP =3D (period*4 * hostdata->sync_clock)/1000 - 4;
-	if(offset > max_offset) {
-		printk(KERN_WARNING "53c700: Offset %d exceeds chip maximum, setting to =
%d\n",
-		       offset, max_offset);
-		offset =3D max_offset;
-	}
-	if(XFERP < min_xferp) {
-		printk(KERN_WARNING "53c700: XFERP %d is less than minium, setting to %d=
\n",
-		       XFERP,  min_xferp);
-		XFERP =3D  min_xferp;
-	}
-	return (offset & 0x0f) | (XFERP & 0x07)<<4;
-}
-
 STATIC inline void
 NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, Scsi_Cmnd *SCp,
 	      struct NCR_700_command_slot *slot)
@@ -777,19 +792,19 @@
 		if(SCp !=3D NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_S=
YNC_NEGOTIATION)) {
 			__u8 period =3D hostdata->msgin[3];
 			__u8 offset =3D hostdata->msgin[4];
-			__u8 sxfer;
=20
-			if(offset !=3D 0 && period !=3D 0)
-				sxfer =3D NCR_700_offset_period_to_sxfer(hostdata, offset, period);
-			else=20
-				sxfer =3D 0;
+			if(offset =3D=3D 0 || period =3D=3D 0) {
+				offset =3D 0;
+				period =3D 0;
+			}
 		=09
-			if(sxfer !=3D NCR_700_get_SXFER(SCp->device)) {
+			if(offset !=3D spi_offset(SCp->device) || period !=3D spi_period(SCp->d=
evice)) {
 				printk(KERN_INFO "scsi%d: (%d:%d) Synchronous at offset %d, period %dn=
s\n",
 				       host->host_no, pun, lun,
 				       offset, period*4);
 			=09
-				NCR_700_set_SXFER(SCp->device, sxfer);
+				spi_offset(SCp->device) =3D offset;
+				spi_period(SCp->device) =3D period;
 			}
 		=09
=20
@@ -870,7 +885,7 @@
 	case A_REJECT_MSG:
 		if(SCp !=3D NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_S=
YNC_NEGOTIATION)) {
 			/* Rejected our sync negotiation attempt */
-			NCR_700_set_SXFER(SCp->device, 0);
+			spi_period(SCp->device) =3D spi_offset(SCp->device) =3D 0;
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp !=3D NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_=
BEGIN_TAG_QUEUEING)) {
=3D=3D=3D=3D=3D drivers/scsi/53c700.h 1.15 vs edited =3D=3D=3D=3D=3D
--- 1.15/drivers/scsi/53c700.h	Sun Feb 22 12:05:18 2004
+++ edited/drivers/scsi/53c700.h	Mon Feb 23 16:20:23 2004
@@ -101,16 +101,6 @@
 #define NCR_700_DEV_TAG_STARVATION_WARNED (1<<19)
=20
 static inline void
-NCR_700_set_SXFER(Scsi_Device *SDp, __u8 sxfer)
-{
-	SDp->hostdata =3D (void *)(((long)SDp->hostdata & 0xffffff00) |
-				(sxfer & 0xff));
-}
-static inline __u8 NCR_700_get_SXFER(Scsi_Device *SDp)
-{
-	return (((unsigned long)SDp->hostdata) & 0xff);
-}
-static inline void
 NCR_700_set_depth(Scsi_Device *SDp, __u8 depth)
 {
 	long l =3D (long)SDp->hostdata;
@@ -437,6 +427,7 @@
 		       #symbol, A_##symbol##_used[i], val)); \
 	} \
 }
+
=20
 static inline __u8
 NCR_700_mem_readb(struct Scsi_Host *host, __u32 reg)

--=-3SAaQYj0WiGEbTPqpFca--

