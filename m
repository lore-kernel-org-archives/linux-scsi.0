From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 11/16] pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (scsi)
Date: Sat, 24 Oct 2009 22:39:58 +0200
Message-ID: <20091024203958.GA1714@isilmar.linta.de>
References: <20091024194219.GA19546@comet.dominikbrodowski.net> <1256413386-20501-11-git-send-email-linux@dominikbrodowski.net> <200910242216.55136.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:52447 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751629AbZJXUjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2009 16:39:55 -0400
Content-Disposition: inline
In-Reply-To: <200910242216.55136.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-pcmcia@lists.infradead.org, linux-scsi@vger.kernel.org

On Sat, Oct 24, 2009 at 10:16:49PM +0200, Rolf Eike Beer wrote:
> Dominik Brodowski wrote:
> 
> > @@ -164,19 +152,21 @@ static int aha152x_config_cs(struct pcmcia_device
> >  *link) {
> >      scsi_info_t *info = link->priv;
> >      struct aha152x_setup s;
> > -    int last_ret, last_fn;
> > +    int ret
> >      struct Scsi_Host *host;
> 
> This looks not even compile tested, there is a semicolon missing.

Indeed, for this driver is !64BIT.... Updated patch (aha152x_stub.c only)
attached.

Thanks for noticing this issue.

	Dominik


diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 67cde01..4329e4e 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -54,15 +54,6 @@
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 
-#ifdef PCMCIA_DEBUG
-static int pc_debug = PCMCIA_DEBUG;
-module_param(pc_debug, int, 0644);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
-static char *version =
-"aha152x_cs.c 1.54 2000/06/12 21:27:25 (David Hinds)";
-#else
-#define DEBUG(n, args...)
-#endif
 
 /*====================================================================*/
 
@@ -103,7 +94,7 @@ static int aha152x_probe(struct pcmcia_device *link)
 {
     scsi_info_t *info;
 
-    DEBUG(0, "aha152x_attach()\n");
+    dev_dbg(&link->dev, "aha152x_attach()\n");
 
     /* Create new SCSI device */
     info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -127,7 +118,7 @@ static int aha152x_probe(struct pcmcia_device *link)
 
 static void aha152x_detach(struct pcmcia_device *link)
 {
-    DEBUG(0, "aha152x_detach(0x%p)\n", link);
+    dev_dbg(&link->dev, "aha152x_detach\n");
 
     aha152x_release_cs(link);
 
@@ -137,9 +128,6 @@ static void aha152x_detach(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
 static int aha152x_config_check(struct pcmcia_device *p_dev,
 				cistpl_cftable_entry_t *cfg,
 				cistpl_cftable_entry_t *dflt,
@@ -164,19 +152,22 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 {
     scsi_info_t *info = link->priv;
     struct aha152x_setup s;
-    int last_ret, last_fn;
+    int ret;
     struct Scsi_Host *host;
 
-    DEBUG(0, "aha152x_config(0x%p)\n", link);
+    dev_dbg(&link->dev, "aha152x_config\n");
 
-    last_ret = pcmcia_loop_config(link, aha152x_config_check, NULL);
-    if (last_ret) {
-	cs_error(link, RequestIO, last_ret);
-	goto failed;
-    }
+    ret = pcmcia_loop_config(link, aha152x_config_check, NULL);
+    if (ret)
+	    goto failed;
 
-    CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-    CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+    ret = pcmcia_request_irq(link, &link->irq);
+    if (ret)
+	    goto failed;
+
+    ret = pcmcia_request_configuration(link, &link->conf);
+    if (ret)
+	    goto failed;
     
     /* Set configuration options for the aha152x driver */
     memset(&s, 0, sizeof(s));
@@ -194,7 +185,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
     host = aha152x_probe_one(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
-	goto cs_failed;
+	goto failed;
     }
 
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
@@ -203,8 +194,6 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 
     return 0;
 
-cs_failed:
-    cs_error(link, last_fn, last_ret);
 failed:
     aha152x_release_cs(link);
     return -ENODEV;
