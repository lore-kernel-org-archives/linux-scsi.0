From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Transport Attributes -- attempt#4
Date: 25 Feb 2004 10:42:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077727369.1804.208.camel@mulgrave>
References: <20040120215645.GG15871@localhost>
	<1077581832.1833.21.camel@mulgrave> <20040224055828.GA503530@sgi.com>
	<1077634979.1827.7.camel@mulgrave>  <20040225070847.GA504005@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7xyG3NCrhlu8WOGUXf2S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:43935 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261378AbUBYQm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 11:42:58 -0500
In-Reply-To: <20040225070847.GA504005@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Martin Hicks <mort@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-7xyG3NCrhlu8WOGUXf2S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2004-02-25 at 01:08, Jeremy Higdon wrote:
> What I meant to say is that I get a compile error at the following
> line in scsi_scan.c:
> 
> 	sdev = kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);

Er, oops, I forgot to do a bk diff in include/scsi.  It should be
attached, sorry.

James


--=-7xyG3NCrhlu8WOGUXf2S
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D include/scsi/scsi_device.h 1.12 vs edited =3D=3D=3D=3D=3D
--- 1.12/include/scsi/scsi_device.h	Mon Feb 23 14:41:39 2004
+++ edited/include/scsi/scsi_device.h	Mon Feb 23 15:39:55 2004
@@ -103,11 +103,11 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
=20
-	void			*transport_attr_values;
 	struct class_device	transport_classdev;
=20
 	enum scsi_device_state sdev_state;
-};
+	unsigned long		transport_data[0];
+} __attribute__((aligned(sizeof(unsigned long))));
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
=3D=3D=3D=3D=3D include/scsi/scsi_transport.h 1.1 vs edited =3D=3D=3D=3D=3D
--- 1.1/include/scsi/scsi_transport.h	Mon Feb 23 14:41:44 2004
+++ edited/include/scsi/scsi_transport.h	Mon Feb 23 15:32:33 2004
@@ -32,9 +32,10 @@
 	/* Constructor/Destructor functions */
 	int (* setup)(struct scsi_device *);
 	void (* cleanup)(struct scsi_device *);
-
-	/* Default values for the transport attributes */
-	void *default_attr_values;
+	/* The size of the specific transport attribute structure (a
+	 * space of this size will be left at the end of the
+	 * scsi_device structure */
+	int	size;
 };
=20
 #endif /* SCSI_TRANSPORT_H */
=3D=3D=3D=3D=3D include/scsi/scsi_transport_spi.h 1.1 vs edited =3D=3D=3D=
=3D=3D
--- 1.1/include/scsi/scsi_transport_spi.h	Mon Feb 23 14:41:48 2004
+++ edited/include/scsi/scsi_transport_spi.h	Mon Feb 23 15:56:50 2004
@@ -29,14 +29,10 @@
 	int offset;
 };
=20
-extern struct scsi_transport_template spi_transport_template;
+/* accessor functions */
+#define spi_period(x)	(((struct spi_transport_attrs *)&(x)->transport_data=
)->period)
+#define spi_offset(x)	(((struct spi_transport_attrs *)&(x)->transport_data=
)->offset)
=20
-#ifdef CONFIG_SCSI_SPI_ATTRS
-extern int scsi_spi_transport_init(void);
-extern void scsi_spi_transport_exit(void);
-#else
-# define scsi_spi_transport_init() 0
-# define scsi_spi_transport_exit()
-#endif
+extern struct scsi_transport_template spi_transport_template;
=20
 #endif /* SCSI_TRANSPORT_SPI_H */

--=-7xyG3NCrhlu8WOGUXf2S--

