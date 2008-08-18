From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 11/39] pcmcia: use pcmcia_loop_config in scsi pcmcia drivers
Date: Mon, 18 Aug 2008 20:53:02 +0200
Message-ID: <1219085610-12289-11-git-send-email-linux@dominikbrodowski.net>
References: <20080818185025.GA11647@comet.dominikbrodowski.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:35887 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760837AbYHRSyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 14:54:02 -0400
In-Reply-To: <20080818185025.GA11647@comet.dominikbrodowski.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pcmcia@lists.infradead.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Use the config loop helper in scsi pcmcia drivers.

CC: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/scsi/pcmcia/aha152x_stub.c |   57 +++++------
 drivers/scsi/pcmcia/fdomain_stub.c |   36 +++----
 drivers/scsi/pcmcia/nsp_cs.c       |  196 ++++++++++++++++++------------------
 drivers/scsi/pcmcia/qlogic_stub.c  |   46 ++++-----
 drivers/scsi/pcmcia/sym53c500_cs.c |   45 ++++-----
 5 files changed, 183 insertions(+), 197 deletions(-)

diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 2dd0dc9..bbcc20f 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -140,44 +140,40 @@ static void aha152x_detach(struct pcmcia_device *link)
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
+static int aha152x_config_check(struct pcmcia_device *p_dev,
+			   cistpl_cftable_entry_t *cfg,
+			   void *priv_data)
+{
+	/* For New Media T&J, look for a SCSI window */
+	if (cfg->io.win[0].len >= 0x20)
+		p_dev->io.BasePort1 = cfg->io.win[0].base;
+	else if ((cfg->io.nwin > 1) &&
+		 (cfg->io.win[1].len >= 0x20))
+		p_dev->io.BasePort1 = cfg->io.win[1].base;
+	if ((cfg->io.nwin > 0) &&
+	    (p_dev->io.BasePort1 < 0xffff)) {
+		p_dev->conf.ConfigIndex = cfg->index;
+		if (!pcmcia_request_io(p_dev, &p_dev->io))
+			return 0;
+	}
+	return -EINVAL;
+}
+
 static int aha152x_config_cs(struct pcmcia_device *link)
 {
     scsi_info_t *info = link->priv;
     struct aha152x_setup s;
-    tuple_t tuple;
-    cisparse_t parse;
-    int i, last_ret, last_fn;
-    u_char tuple_data[64];
+    int last_ret, last_fn;
     struct Scsi_Host *host;
-    
+
     DEBUG(0, "aha152x_config(0x%p)\n", link);
 
-    tuple.TupleData = tuple_data;
-    tuple.TupleDataMax = 64;
-    tuple.TupleOffset = 0;
-    tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-    tuple.Attributes = 0;
-    CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-    while (1) {
-	if (pcmcia_get_tuple_data(link, &tuple) != 0 ||
-		pcmcia_parse_tuple(link, &tuple, &parse) != 0)
-	    goto next_entry;
-	/* For New Media T&J, look for a SCSI window */
-	if (parse.cftable_entry.io.win[0].len >= 0x20)
-	    link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
-	else if ((parse.cftable_entry.io.nwin > 1) &&
-		 (parse.cftable_entry.io.win[1].len >= 0x20))
-	    link->io.BasePort1 = parse.cftable_entry.io.win[1].base;
-	if ((parse.cftable_entry.io.nwin > 0) &&
-	    (link->io.BasePort1 < 0xffff)) {
-	    link->conf.ConfigIndex = parse.cftable_entry.index;
-	    i = pcmcia_request_io(link, &link->io);
-	    if (i == CS_SUCCESS) break;
-	}
-    next_entry:
-	CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(link, &tuple));
+    last_ret = pcmcia_loop_config(link, aha152x_config_check, NULL);
+    if (last_ret) {
+	cs_error(link, RequestIO, last_ret);
+	goto failed;
     }
-    
+
     CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
     CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
     
@@ -208,6 +204,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 
 cs_failed:
     cs_error(link, last_fn, last_ret);
+failed:
     aha152x_release_cs(link);
     return -ENODEV;
 }
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index d8b9935..fefef7d 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -123,34 +123,29 @@ static void fdomain_detach(struct pcmcia_device *link)
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
+static int fdomain_config_check(struct pcmcia_device *p_dev,
+				  cistpl_cftable_entry_t *cfg,
+				  void *priv_data)
+{
+	p_dev->conf.ConfigIndex = cfg->index;
+	p_dev->io.BasePort1 = cfg->io.win[0].base;
+	return pcmcia_request_io(p_dev, &p_dev->io);
+}
+
+
 static int fdomain_config(struct pcmcia_device *link)
 {
     scsi_info_t *info = link->priv;
-    tuple_t tuple;
-    cisparse_t parse;
-    int i, last_ret, last_fn;
-    u_char tuple_data[64];
+    int last_ret, last_fn;
     char str[22];
     struct Scsi_Host *host;
 
     DEBUG(0, "fdomain_config(0x%p)\n", link);
 
-    tuple.TupleData = tuple_data;
-    tuple.TupleDataMax = 64;
-    tuple.TupleOffset = 0;
-
-    tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-    CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-    while (1) {
-	if (pcmcia_get_tuple_data(link, &tuple) != 0 ||
-		pcmcia_parse_tuple(link, &tuple, &parse) != 0)
-	    goto next_entry;
-	link->conf.ConfigIndex = parse.cftable_entry.index;
-	link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
-	i = pcmcia_request_io(link, &link->io);
-	if (i == CS_SUCCESS) break;
-    next_entry:
-	CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(link, &tuple));
+    last_ret = pcmcia_loop_config(link, fdomain_config_check, NULL);
+    if (last_ret) {
+	    cs_error(link, RequestIO, last_ret);
+	    goto failed;
     }
 
     CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
@@ -181,6 +176,7 @@ static int fdomain_config(struct pcmcia_device *link)
 
 cs_failed:
     cs_error(link, last_fn, last_ret);
+failed:
     fdomain_release(link);
     return -ENODEV;
 } /* fdomain_config */
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a221b6e..fc395a8 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1607,133 +1607,137 @@ static void nsp_cs_detach(struct pcmcia_device *link)
     is received, to configure the PCMCIA socket, and to make the
     ethernet device available to the system.
 ======================================================================*/
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-/*====================================================================*/
-static int nsp_cs_config(struct pcmcia_device *link)
-{
-	int		  ret;
-	scsi_info_t	 *info	 = link->priv;
-	tuple_t		  tuple;
-	cisparse_t	  parse;
-	int		  last_ret, last_fn;
-	unsigned char	  tuple_data[64];
-	config_info_t	  conf;
-	win_req_t         req;
-	memreq_t          map;
-	cistpl_cftable_entry_t dflt = { 0 };
-	struct Scsi_Host *host;
-	nsp_hw_data      *data = &nsp_data_base;
-
-	nsp_dbg(NSP_DEBUG_INIT, "in");
 
-	tuple.Attributes      = 0;
-	tuple.TupleData	      = tuple_data;
-	tuple.TupleDataMax    = sizeof(tuple_data);
-	tuple.TupleOffset     = 0;
-
-	/* Look up the current Vcc */
-	CS_CHECK(GetConfigurationInfo, pcmcia_get_configuration_info(link, &conf));
+struct nsp_cs_configdata {
+	nsp_hw_data		*data;
+	win_req_t		req;
+	config_info_t		conf;
+	cistpl_cftable_entry_t	dflt;
+};
 
-	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-	while (1) {
-		cistpl_cftable_entry_t *cfg = &(parse.cftable_entry);
+static int nsp_cs_config_check(struct pcmcia_device *p_dev,
+			       cistpl_cftable_entry_t *cfg,
+			       void *priv_data)
+{
+	struct nsp_cs_configdata *cfg_mem = priv_data;
 
-		if (pcmcia_get_tuple_data(link, &tuple) != 0 ||
-				pcmcia_parse_tuple(link, &tuple, &parse) != 0)
-			goto next_entry;
+	if (cfg->flags & CISTPL_CFTABLE_DEFAULT)
+		memcpy(&cfg_mem->dflt, cfg, sizeof(cistpl_cftable_entry_t));
+	if (cfg->index == 0)
+		return -ENODEV;
 
-		if (cfg->flags & CISTPL_CFTABLE_DEFAULT) { dflt = *cfg; }
-		if (cfg->index == 0) { goto next_entry; }
-		link->conf.ConfigIndex = cfg->index;
+	p_dev->conf.ConfigIndex = cfg->index;
 
-		/* Does this card need audio output? */
-		if (cfg->flags & CISTPL_CFTABLE_AUDIO) {
-			link->conf.Attributes |= CONF_ENABLE_SPKR;
-			link->conf.Status = CCSR_AUDIO_ENA;
-		}
+	/* Does this card need audio output? */
+	if (cfg->flags & CISTPL_CFTABLE_AUDIO) {
+		p_dev->conf.Attributes |= CONF_ENABLE_SPKR;
+		p_dev->conf.Status = CCSR_AUDIO_ENA;
+	}
 
-		/* Use power settings for Vcc and Vpp if present */
-		/*  Note that the CIS values need to be rescaled */
-		if (cfg->vcc.present & (1<<CISTPL_POWER_VNOM)) {
-			if (conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM]/10000) {
-				goto next_entry;
-			}
-		} else if (dflt.vcc.present & (1<<CISTPL_POWER_VNOM)) {
-			if (conf.Vcc != dflt.vcc.param[CISTPL_POWER_VNOM]/10000) {
-				goto next_entry;
-			}
+	/* Use power settings for Vcc and Vpp if present */
+	/*  Note that the CIS values need to be rescaled */
+	if (cfg->vcc.present & (1<<CISTPL_POWER_VNOM)) {
+		if (cfg_mem->conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM]/10000)
+			return -ENODEV;
+		else if (cfg_mem->dflt.vcc.present & (1<<CISTPL_POWER_VNOM)) {
+			if (cfg_mem->conf.Vcc != cfg_mem->dflt.vcc.param[CISTPL_POWER_VNOM]/10000)
+				return -ENODEV;
 		}
 
 		if (cfg->vpp1.present & (1 << CISTPL_POWER_VNOM)) {
-			link->conf.Vpp =
+			p_dev->conf.Vpp =
 				cfg->vpp1.param[CISTPL_POWER_VNOM] / 10000;
-		} else if (dflt.vpp1.present & (1 << CISTPL_POWER_VNOM)) {
-			link->conf.Vpp =
-				dflt.vpp1.param[CISTPL_POWER_VNOM] / 10000;
+		} else if (cfg_mem->dflt.vpp1.present & (1 << CISTPL_POWER_VNOM)) {
+			p_dev->conf.Vpp =
+				cfg_mem->dflt.vpp1.param[CISTPL_POWER_VNOM] / 10000;
 		}
 
 		/* Do we need to allocate an interrupt? */
-		if (cfg->irq.IRQInfo1 || dflt.irq.IRQInfo1) {
-			link->conf.Attributes |= CONF_ENABLE_IRQ;
+		if (cfg->irq.IRQInfo1 || cfg_mem->dflt.irq.IRQInfo1) {
+			p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
 		}
 
 		/* IO window settings */
-		link->io.NumPorts1 = link->io.NumPorts2 = 0;
-		if ((cfg->io.nwin > 0) || (dflt.io.nwin > 0)) {
-			cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt.io;
-			link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
+		p_dev->io.NumPorts1 = p_dev->io.NumPorts2 = 0;
+		if ((cfg->io.nwin > 0) || (cfg_mem->dflt.io.nwin > 0)) {
+			cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &cfg_mem->dflt.io;
+			p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
 			if (!(io->flags & CISTPL_IO_8BIT))
-				link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
+				p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
 			if (!(io->flags & CISTPL_IO_16BIT))
-				link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
-			link->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
-			link->io.BasePort1 = io->win[0].base;
-			link->io.NumPorts1 = io->win[0].len;
+				p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
+			p_dev->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
+			p_dev->io.BasePort1 = io->win[0].base;
+			p_dev->io.NumPorts1 = io->win[0].len;
 			if (io->nwin > 1) {
-				link->io.Attributes2 = link->io.Attributes1;
-				link->io.BasePort2 = io->win[1].base;
-				link->io.NumPorts2 = io->win[1].len;
+				p_dev->io.Attributes2 = p_dev->io.Attributes1;
+				p_dev->io.BasePort2 = io->win[1].base;
+				p_dev->io.NumPorts2 = io->win[1].len;
 			}
 			/* This reserves IO space but doesn't actually enable it */
-			if (pcmcia_request_io(link, &link->io) != 0)
+			if (pcmcia_request_io(p_dev, &p_dev->io) != 0)
 				goto next_entry;
 		}
 
-		if ((cfg->mem.nwin > 0) || (dflt.mem.nwin > 0)) {
-			cistpl_mem_t *mem =
-				(cfg->mem.nwin) ? &cfg->mem : &dflt.mem;
-			req.Attributes = WIN_DATA_WIDTH_16|WIN_MEMORY_TYPE_CM;
-			req.Attributes |= WIN_ENABLE;
-			req.Base = mem->win[0].host_addr;
-			req.Size = mem->win[0].len;
-			if (req.Size < 0x1000) {
-				req.Size = 0x1000;
+		if ((cfg->mem.nwin > 0) || (cfg_mem->dflt.mem.nwin > 0)) {
+			memreq_t	map;
+			cistpl_mem_t	*mem =
+				(cfg->mem.nwin) ? &cfg->mem : &cfg_mem->dflt.mem;
+			cfg_mem->req.Attributes = WIN_DATA_WIDTH_16|WIN_MEMORY_TYPE_CM;
+			cfg_mem->req.Attributes |= WIN_ENABLE;
+			cfg_mem->req.Base = mem->win[0].host_addr;
+			cfg_mem->req.Size = mem->win[0].len;
+			if (cfg_mem->req.Size < 0x1000) {
+				cfg_mem->req.Size = 0x1000;
 			}
-			req.AccessSpeed = 0;
-			if (pcmcia_request_window(&link, &req, &link->win) != 0)
+			cfg_mem->req.AccessSpeed = 0;
+			if (pcmcia_request_window(&p_dev, &cfg_mem->req, &p_dev->win) != 0)
 				goto next_entry;
 			map.Page = 0; map.CardOffset = mem->win[0].card_addr;
-			if (pcmcia_map_mem_page(link->win, &map) != 0)
+			if (pcmcia_map_mem_page(p_dev->win, &map) != 0)
 				goto next_entry;
 
-			data->MmioAddress = (unsigned long)ioremap_nocache(req.Base, req.Size);
-			data->MmioLength  = req.Size;
+			cfg_mem->data->MmioAddress = (unsigned long)ioremap_nocache(cfg_mem->req.Base, cfg_mem->req.Size);
+			cfg_mem->data->MmioLength  = cfg_mem->req.Size;
 		}
 		/* If we got this far, we're cool! */
-		break;
-
-	next_entry:
-		nsp_dbg(NSP_DEBUG_INIT, "next");
-		pcmcia_disable_device(link);
-		CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(link, &tuple));
+		return 0;
 	}
 
+next_entry:
+	nsp_dbg(NSP_DEBUG_INIT, "next");
+	pcmcia_disable_device(p_dev);
+	return -ENODEV;
+}
+
+static int nsp_cs_config(struct pcmcia_device *link)
+{
+	int		  ret;
+	scsi_info_t	 *info	 = link->priv;
+	struct nsp_cs_configdata *cfg_mem;
+	struct Scsi_Host *host;
+	nsp_hw_data      *data = &nsp_data_base;
+
+	nsp_dbg(NSP_DEBUG_INIT, "in");
+
+	cfg_mem = kzalloc(sizeof(cfg_mem), GFP_KERNEL);
+	if (!cfg_mem)
+		return -ENOMEM;
+	cfg_mem->data = data;
+
+	/* Look up the current Vcc */
+	CS_CHECK(GetConfigurationInfo, pcmcia_get_configuration_info(link, &cfg_mem->conf));
+	ret = pcmcia_loop_config(link, nsp_cs_config_check, cfg_mem);
+		goto cs_failed;
+
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
-		CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
+		if (pcmcia_request_irq(link, &link->irq))
+			goto cs_failed;
 	}
-	CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+
+	ret = pcmcia_request_configuration(link, &link->conf);
+	if (ret)
+		goto cs_failed;
 
 	if (free_ports) {
 		if (link->io.BasePort1) {
@@ -1791,20 +1795,20 @@ static int nsp_cs_config(struct pcmcia_device *link)
 		printk(" & 0x%04x-0x%04x", link->io.BasePort2,
 		       link->io.BasePort2+link->io.NumPorts2-1);
 	if (link->win)
-		printk(", mem 0x%06lx-0x%06lx", req.Base,
-		       req.Base+req.Size-1);
+		printk(", mem 0x%06lx-0x%06lx", cfg_mem->req.Base,
+		       cfg_mem->req.Base+cfg_mem->req.Size-1);
 	printk("\n");
 
+	kfree(cfg_mem);
 	return 0;
 
  cs_failed:
 	nsp_dbg(NSP_DEBUG_INIT, "config fail");
-	cs_error(link, last_fn, last_ret);
 	nsp_cs_release(link);
+	kfree(cfg_mem);
 
 	return -ENODEV;
 } /* nsp_cs_config */
-#undef CS_CHECK
 
 
 /*======================================================================
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 67c5a58..aa9b9e0 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -195,39 +195,32 @@ static void qlogic_detach(struct pcmcia_device *link)
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
+static int qlogic_config_check(struct pcmcia_device *p_dev,
+				  cistpl_cftable_entry_t *cfg,
+				  void *priv_data)
+{
+	p_dev->conf.ConfigIndex = cfg->index;
+	p_dev->io.BasePort1 = cfg->io.win[0].base;
+	p_dev->io.NumPorts1 = cfg->io.win[0].len;
+
+	if (p_dev->io.BasePort1 == 0)
+		return -ENODEV;
+
+	return pcmcia_request_io(p_dev, &p_dev->io);
+}
+
 static int qlogic_config(struct pcmcia_device * link)
 {
 	scsi_info_t *info = link->priv;
-	tuple_t tuple;
-	cisparse_t parse;
-	int i, last_ret, last_fn;
-	unsigned short tuple_data[32];
+	int last_ret, last_fn;
 	struct Scsi_Host *host;
 
 	DEBUG(0, "qlogic_config(0x%p)\n", link);
 
-	info->manf_id = link->manf_id;
-
-	tuple.TupleData = (cisdata_t *) tuple_data;
-	tuple.TupleDataMax = 64;
-	tuple.TupleOffset = 0;
-
-	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-	while (1) {
-		if (pcmcia_get_tuple_data(link, &tuple) != 0 ||
-				pcmcia_parse_tuple(link, &tuple, &parse) != 0)
-			goto next_entry;
-		link->conf.ConfigIndex = parse.cftable_entry.index;
-		link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
-		link->io.NumPorts1 = parse.cftable_entry.io.win[0].len;
-		if (link->io.BasePort1 != 0) {
-			i = pcmcia_request_io(link, &link->io);
-			if (i == CS_SUCCESS)
-				break;
-		}
-	      next_entry:
-		CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(link, &tuple));
+	last_ret = pcmcia_loop_config(link, qlogic_config_check, NULL);
+	if (last_ret) {
+		cs_error(link, RequestIO, last_ret);
+		goto failed;
 	}
 
 	CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
@@ -262,6 +255,7 @@ static int qlogic_config(struct pcmcia_device * link)
 cs_failed:
 	cs_error(link, last_fn, last_ret);
 	pcmcia_disable_device(link);
+failed:
 	return -ENODEV;
 
 }				/* qlogic_config */
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 0be232b..15369d9 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -700,15 +700,26 @@ static struct scsi_host_template sym53c500_driver_template = {
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
+static int SYM53C500_config_check(struct pcmcia_device *p_dev,
+				  cistpl_cftable_entry_t *cfg,
+				  void *priv_data)
+{
+	p_dev->conf.ConfigIndex = cfg->index;
+	p_dev->io.BasePort1 = cfg->io.win[0].base;
+	p_dev->io.NumPorts1 = cfg->io.win[0].len;
+
+	if (p_dev->io.BasePort1 == 0)
+		return -ENODEV;
+
+	return pcmcia_request_io(p_dev, &p_dev->io);
+}
+
 static int
 SYM53C500_config(struct pcmcia_device *link)
 {
 	struct scsi_info_t *info = link->priv;
-	tuple_t tuple;
-	cisparse_t parse;
-	int i, last_ret, last_fn;
+	int last_ret, last_fn;
 	int irq_level, port_base;
-	unsigned short tuple_data[32];
 	struct Scsi_Host *host;
 	struct scsi_host_template *tpnt = &sym53c500_driver_template;
 	struct sym53c500_data *data;
@@ -717,27 +728,10 @@ SYM53C500_config(struct pcmcia_device *link)
 
 	info->manf_id = link->manf_id;
 
-	tuple.TupleData = (cisdata_t *)tuple_data;
-	tuple.TupleDataMax = 64;
-	tuple.TupleOffset = 0;
-
-	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-	while (1) {
-		if (pcmcia_get_tuple_data(link, &tuple) != 0 ||
-		    pcmcia_parse_tuple(link, &tuple, &parse) != 0)
-			goto next_entry;
-		link->conf.ConfigIndex = parse.cftable_entry.index;
-		link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
-		link->io.NumPorts1 = parse.cftable_entry.io.win[0].len;
-
-		if (link->io.BasePort1 != 0) {
-			i = pcmcia_request_io(link, &link->io);
-			if (i == CS_SUCCESS)
-				break;
-		}
-next_entry:
-		CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(link, &tuple));
+	last_ret = pcmcia_loop_config(link, SYM53C500_config_check, NULL);
+	if (last_ret) {
+		cs_error(link, RequestIO, last_ret);
+		goto failed;
 	}
 
 	CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
@@ -831,6 +825,7 @@ err_release:
 
 cs_failed:
 	cs_error(link, last_fn, last_ret);
+failed:
 	SYM53C500_release(link);
 	return -ENODEV;
 } /* SYM53C500_config */
-- 
1.5.4.3

