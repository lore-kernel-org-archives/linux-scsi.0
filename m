From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Mon, 18 Apr 2005 23:33:21 -0700
Message-ID: <20050419063319.GB5999@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:57509 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261348AbVDSGd3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 02:33:29 -0400
Content-Disposition: inline
In-Reply-To: <20050413214023.GA18161@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, 13 Apr 2005, Christoph Hellwig wrote:

> 
> > +struct scsi_transport_template *
> > +qla2x00_alloc_transport_tmpl(void)
> > +{
> > +	return (fc_attach_transport(&qla2xxx_transport_functions));
> > +}
> 
> I don't see much of a point in this function vs just making
> qla2xxx_transport_functions non-static.
> 
> > --- a/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:38:23.000000000 -0700
> > +++ b/drivers/scsi/qla2xxx/qla_gbl.h	2005-04-13 08:42:33.000000000 -0700
> > @@ -24,6 +24,7 @@
> >  #define	__QLA_GBL_H
> >  
> >  #include <linux/interrupt.h>
> > +#include <scsi/scsi_transport.h>
> 
> shouldn't be needed, a simple forward-declaration of
> struct scsi_transport_template should do it.
> 

Ok, makes sense.

James, please apply:


Make transport-functions structure non-static.  Replace #include of
scsi_transport.h with a forward declaration.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_attr.c |    8 +-------
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    3 ++-
 3 files changed, 5 insertions(+), 10 deletions(-)

drivers/scsi/qla2xxx/qla_attr.c: fb67d67bee97823d4d209cdbd9b356a5a2370683
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -300,7 +300,7 @@ qla2x00_set_rport_loss_tmo(struct fc_rpo
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 }
 
-static struct fc_function_template qla2xxx_transport_functions = {
+struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
@@ -322,12 +322,6 @@ static struct fc_function_template qla2x
 
 };
 
-struct scsi_transport_template *
-qla2x00_alloc_transport_tmpl(void)
-{
-	return (fc_attach_transport(&qla2xxx_transport_functions));
-}
-
 void
 qla2x00_init_host_attr(scsi_qla_host_t *ha)
 {
drivers/scsi/qla2xxx/qla_gbl.h: e49d05b0167879a042b09941c240274530784c65
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -24,7 +24,6 @@
 #define	__QLA_GBL_H
 
 #include <linux/interrupt.h>
-#include <scsi/scsi_transport.h>
 
 extern void qla2x00_remove_one(struct pci_dev *);
 extern int qla2x00_probe_one(struct pci_dev *, struct qla_board_info *);
@@ -248,9 +247,10 @@ extern void qla2x00_cancel_io_descriptor
 /*
  * Global Function Prototypes in qla_attr.c source file.
  */
+struct fc_function_template;
+extern struct fc_function_template qla2xxx_transport_functions;
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
-extern struct scsi_transport_template *qla2x00_alloc_transport_tmpl(void);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
drivers/scsi/qla2xxx/qla_os.c: f949c701ec022d6db1791df0e55ce3e534359a1c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2350,7 +2350,8 @@ qla2x00_module_init(void)
 #if DEBUG_QLA2100
 	strcat(qla2x00_version_str, "-debug");
 #endif
-	qla2xxx_transport_template = qla2x00_alloc_transport_tmpl();
+	qla2xxx_transport_template =
+	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template)
 		return -ENODEV;
 
