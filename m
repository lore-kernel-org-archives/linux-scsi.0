From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Display SPI transfer agreement in common code
Date: Wed, 23 Feb 2005 18:20:02 +0000
Message-ID: <20050223182002.GQ28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21434 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261518AbVBWSUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 13:20:08 -0500
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.33)
	id 1D417D-0002Az-2l
	for linux-scsi@vger.kernel.org; Wed, 23 Feb 2005 18:20:03 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Introduce a generic SPI function to print the negotiated transfer
agreement.  It's based on the implementation in sym53c8xx_2/sym_misc.c.
>From a quick look, 53c700, ncr53c8xx and sym2 can use it easily.
Other drivers need to be converted to use the SPI transport layer first.

In order to calculate the speed I needed to be able to convert from
period factor to period in picoseconds.  That required changing
(show|store)_spi_transport_period to work in picoseconds rather than
a string.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/lib/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.10
diff -u -p -r1.10 scsi_transport_spi.c
--- ./drivers/scsi/scsi_transport_spi.c	14 Feb 2005 02:55:24 -0000	1.10
+++ ./drivers/scsi/scsi_transport_spi.c	23 Feb 2005 17:39:36 -0000
@@ -18,15 +18,11 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/workqueue.h>
-#include <asm/scatterlist.h>
-#include <asm/io.h>
+#include <asm/semaphore.h>
 #include <scsi/scsi.h>
 #include "scsi_priv.h"
 #include <scsi/scsi_device.h>
@@ -63,22 +59,22 @@ struct spi_internal {
 
 #define to_spi_internal(tmpl)	container_of(tmpl, struct spi_internal, t)
 
-static const char *const ppr_to_ns[] = {
+static const int ppr_to_ps[] = {
 	/* The PPR values 0-6 are reserved, fill them in when
 	 * the committee defines them */
-	NULL,			/* 0x00 */
-	NULL,			/* 0x01 */
-	NULL,			/* 0x02 */
-	NULL,			/* 0x03 */
-	NULL,			/* 0x04 */
-	NULL,			/* 0x05 */
-	NULL,			/* 0x06 */
-	"3.125",		/* 0x07 */
-	"6.25",			/* 0x08 */
-	"12.5",			/* 0x09 */
-	"25",			/* 0x0a */
-	"30.3",			/* 0x0b */
-	"50",			/* 0x0c */
+	-1,			/* 0x00 */
+	-1,			/* 0x01 */
+	-1,			/* 0x02 */
+	-1,			/* 0x03 */
+	-1,			/* 0x04 */
+	-1,			/* 0x05 */
+	-1,			/* 0x06 */
+	 3125,			/* 0x07 */
+	 6250,			/* 0x08 */
+	12500,			/* 0x09 */
+	25000,			/* 0x0a */
+	30300,			/* 0x0b */
+	50000,			/* 0x0c */
 };
 /* The PPR values at which you calculate the period in ns by multiplying
  * by 4 */
@@ -261,7 +257,7 @@ static ssize_t show_spi_transport_period
 	struct scsi_target *starget = transport_class_to_starget(cdev);
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct spi_transport_attrs *tp;
-	const char *str;
+	int picosec;
 	struct spi_internal *i = to_spi_internal(shost->transportt);
 
 	tp = (struct spi_transport_attrs *)&starget->starget_data;
@@ -269,22 +265,19 @@ static ssize_t show_spi_transport_period
 	if (i->f->get_period)
 		i->f->get_period(starget);
 
-	switch(tp->period) {
-
-	case 0x07 ... SPI_STATIC_PPR:
-		str = ppr_to_ns[tp->period];
-		if(!str)
-			str = "reserved";
-		break;
-
-
-	case (SPI_STATIC_PPR+1) ... 0xff:
-		return sprintf(buf, "%d\n", tp->period * 4);
-
-	default:
-		str = "unknown";
+	if (tp->period < 0 || tp->period > 0xff) {
+		picosec = -1;
+	} else if (tp->period <= SPI_STATIC_PPR) {
+		picosec = ppr_to_ps[tp->period];
+	} else {
+		picosec = tp->period * 4000;
 	}
-	return sprintf(buf, "%s\n", str);
+
+	if (picosec == -1)
+		return sprintf(buf, "reserved");
+	if (picosec % 1000 == 0)
+		return sprintf(buf, "%d\n", picosec / 1000);
+	return sprintf(buf, "%d.%d\n", picosec / 1000, picosec % 1000);
 }
 
 static ssize_t
@@ -294,34 +287,30 @@ store_spi_transport_period(struct class_
 	struct scsi_target *starget = transport_class_to_starget(cdev);
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct spi_internal *i = to_spi_internal(shost->transportt);
-	int j, period = -1;
+	int j, picosec, period = -1;
+	char *endp;
 
-	for (j = 0; j < SPI_STATIC_PPR; j++) {
-		int len;
-
-		if(ppr_to_ns[j] == NULL)
-			continue;
-
-		len = strlen(ppr_to_ns[j]);
-
-		if(strncmp(ppr_to_ns[j], buf, len) != 0)
-			continue;
+	picosec = simple_strtoul(buf, &endp, 10) * 1000;
+	if (*endp == '.') {
+		int mult = 100;
+		do {
+			endp++;
+			if (!isdigit(*endp))
+				break;
+			picosec += (*endp - '0') * mult;
+			mult /= 10;
+		} while (mult > 0);
+	}
 
-		if(buf[len] != '\n')
+	for (j = 0; j <= SPI_STATIC_PPR; j++) {
+		if (ppr_to_ps[j] < picosec)
 			continue;
-		
 		period = j;
 		break;
 	}
 
-	if (period == -1) {
-		int val = simple_strtoul(buf, NULL, 0);
-
-
-		/* Should probably check limits here, but this
-		 * gets reasonably close to OK for most things */
-		period = val/4;
-	}
+	if (period == -1)
+		period = picosec / 4000;
 
 	if (period > 0xff)
 		period = 0xff;
@@ -794,6 +783,60 @@ spi_schedule_dv_device(struct scsi_devic
 	schedule_work(&wqw->work);
 }
 EXPORT_SYMBOL(spi_schedule_dv_device);
+
+/**
+ * spi_display_xfer_agreement - Print the current target transfer agreement
+ * @starget: The target for which to display the agreement
+ *
+ * Each SPI port is required to maintain a transfer agreement for each
+ * other port on the bus.  This function prints a one-line summary of
+ * the current agreement; more detailed information is available in sysfs.
+ */
+void spi_display_xfer_agreement(struct scsi_target *starget)
+{
+	struct spi_transport_attrs *tp;
+	tp = (struct spi_transport_attrs *)&starget->starget_data;
+
+	if (tp->offset > 0 && tp->period > 0) {
+		unsigned int picosec, kb100;
+		char *scsi = "FAST-?";
+
+		if (tp->period <= SPI_STATIC_PPR) {
+			picosec = ppr_to_ps[tp->period];
+			switch (tp->period) {
+				case  7: scsi = "FAST-320"; break;
+				case  8: scsi = "FAST-160"; break;
+				case  9: scsi = "FAST-80"; break;
+				case 10:
+				case 11: scsi = "FAST-40"; break;
+				case 12: scsi = "FAST-20"; break;
+			}
+		} else {
+			picosec = tp->period * 4000;
+			if (tp->period < 25)
+				scsi = "FAST-20";
+			else if (tp->period < 50)
+				scsi = "FAST-10";
+			else
+				scsi = "FAST-5";
+		}
+
+		kb100 = (10000000 + picosec / 2) / picosec;
+		if (tp->width)
+			kb100 *= 2;
+
+		dev_info(&starget->dev,
+			"%s %sSCSI %d.%d MB/s %s%s%s (%d.%d ns, offset %d)\n",
+			scsi, tp->width ? "WIDE " : "", kb100/10, kb100 % 10,
+			tp->dt ? "DT" : "ST", tp->iu ? " IU" : "",
+			tp->qas  ? " QAS" : "", picosec / 1000, picosec % 1000,
+			tp->offset);
+	} else {
+		dev_info(&starget->dev, "%sasynchronous.\n",
+				tp->width ? "wide " : "");
+	}
+}
+EXPORT_SYMBOL(spi_display_xfer_agreement);
 
 #define SETUP_ATTRIBUTE(field)						\
 	i->private_attrs[count] = class_device_attr_##field;		\
Index: ./include/scsi/scsi_transport_spi.h
===================================================================
RCS file: /var/lib/cvs/linux-2.6/include/scsi/scsi_transport_spi.h,v
retrieving revision 1.5
diff -u -p -r1.5 scsi_transport_spi.h
--- ./include/scsi/scsi_transport_spi.h	3 Feb 2005 11:45:13 -0000	1.5
+++ ./include/scsi/scsi_transport_spi.h	23 Feb 2005 17:40:05 -0000
@@ -130,5 +130,6 @@ struct scsi_transport_template *spi_atta
 void spi_release_transport(struct scsi_transport_template *);
 void spi_schedule_dv_device(struct scsi_device *);
 void spi_dv_device(struct scsi_device *);
+void spi_display_xfer_agreement(struct scsi_target *);
 
 #endif /* SCSI_TRANSPORT_SPI_H */

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
