Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1798242D7D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 08:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770885518; cv=none; b=rAG8Md9wxw4OP+hsk+6TdTwgw3LBDmLcJFjDbo9JG4PQOG1imyN0x1JWyRSJqVxcBZv/TAG5SIwuRjn/9UIO0gh3qz2QthE2J5in+B8yZdXMnLIiUKdxZoAaYyDeNbdUGluWG+s9NWmweSgRuiXDaKfjYKHyrNxUn9G5hBw8afY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770885518; c=relaxed/simple;
	bh=ef3LzpCrcs4QdW7jFhPSXJPb9kTcCbi08cRJaE50Ur4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RnKy9A8YdD6mCp3BBiUfHC7MQFgaaFZ4uMbOKAbpEMNKGZtcJHnqDtaSgwfyV+uegfWjKZB+OPPPU+siG79FV71PVYjLESV5YAabGqP5k20XOOKemn1a8zDe4emLICMzNO0v+qbsGVdJdgfaGETqVrMZc0PtB8sETRNxc1Pmj/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gn6GWT0t; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gn6GWT0t; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gn6GWT0t";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gn6GWT0t"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B1C33E6E8;
	Thu, 12 Feb 2026 08:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770885515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ASzH9qE0mBRibU9uWHl4KojtE+mVdpgEGiVGmw5TkI=;
	b=Gn6GWT0tpFD4Wj0aIBXIADPNbMyqxnarB7G6+MOUb7r55zoH19ifoS/6oYN98O3iKcRraw
	9/gjSCt246xTx4r9GkhCsE063MzrrvxyeGrIY20vFRLxt6LIR4BvoDSJ0VCcO4dLRLaU/Z
	kwxe3FAh1YLhI3NjeVZLnZSoQpjmJsc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770885515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ASzH9qE0mBRibU9uWHl4KojtE+mVdpgEGiVGmw5TkI=;
	b=Gn6GWT0tpFD4Wj0aIBXIADPNbMyqxnarB7G6+MOUb7r55zoH19ifoS/6oYN98O3iKcRraw
	9/gjSCt246xTx4r9GkhCsE063MzrrvxyeGrIY20vFRLxt6LIR4BvoDSJ0VCcO4dLRLaU/Z
	kwxe3FAh1YLhI3NjeVZLnZSoQpjmJsc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A551A3EA62;
	Thu, 12 Feb 2026 08:38:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +qE3J4qRjWmJMwAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 12 Feb 2026 08:38:34 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
Subject: [PATCH 1/2] xenbus: add xenbus_device parameter to xenbus_read_driver_state()
Date: Thu, 12 Feb 2026 09:38:25 +0100
Message-ID: <20260212083826.136221-2-jgross@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212083826.136221-1-jgross@suse.com>
References: <20260212083826.136221-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[invisiblethingslab.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	R_RATELIMIT(0.00)[to_ip_from(RLsote1drt81dzioaq3931x19g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -5.80
X-Spam-Level: 

In order to prepare checking the xenbus device status in
xenbus_read_driver_state(), add the pointer to struct xenbus_device
as a parameter.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
 drivers/net/xen-netfront.c                 | 34 +++++++++++-----------
 drivers/pci/xen-pcifront.c                 |  8 ++---
 drivers/scsi/xen-scsifront.c               |  2 +-
 drivers/xen/xen-pciback/xenbus.c           | 10 +++----
 drivers/xen/xenbus/xenbus_client.c         |  3 +-
 drivers/xen/xenbus/xenbus_probe.c          |  6 ++--
 drivers/xen/xenbus/xenbus_probe_frontend.c |  2 +-
 include/xen/xenbus.h                       |  3 +-
 8 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 0969d5c9f6b7..2c414b77dd0f 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1646,7 +1646,7 @@ static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	/* avoid the race with XDP headroom adjustment */
 	wait_event(module_wq,
-		   xenbus_read_driver_state(np->xbdev->otherend) ==
+		   xenbus_read_driver_state(np->xbdev, np->xbdev->otherend) ==
 		   XenbusStateReconfigured);
 	np->netfront_xdp_enabled = true;
 
@@ -1764,9 +1764,9 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	do {
 		xenbus_switch_state(dev, XenbusStateInitialising);
 		err = wait_event_timeout(module_wq,
-				 xenbus_read_driver_state(dev->otherend) !=
+				 xenbus_read_driver_state(dev, dev->otherend) !=
 				 XenbusStateClosed &&
-				 xenbus_read_driver_state(dev->otherend) !=
+				 xenbus_read_driver_state(dev, dev->otherend) !=
 				 XenbusStateUnknown, XENNET_TIMEOUT);
 	} while (!err);
 
@@ -2627,31 +2627,31 @@ static void xennet_bus_close(struct xenbus_device *dev)
 {
 	int ret;
 
-	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+	if (xenbus_read_driver_state(dev, dev->otherend) == XenbusStateClosed)
 		return;
 	do {
 		xenbus_switch_state(dev, XenbusStateClosing);
 		ret = wait_event_timeout(module_wq,
-				   xenbus_read_driver_state(dev->otherend) ==
-				   XenbusStateClosing ||
-				   xenbus_read_driver_state(dev->otherend) ==
-				   XenbusStateClosed ||
-				   xenbus_read_driver_state(dev->otherend) ==
-				   XenbusStateUnknown,
-				   XENNET_TIMEOUT);
+				xenbus_read_driver_state(dev, dev->otherend) ==
+				XenbusStateClosing ||
+				xenbus_read_driver_state(dev, dev->otherend) ==
+				XenbusStateClosed ||
+				xenbus_read_driver_state(dev, dev->otherend) ==
+				XenbusStateUnknown,
+				XENNET_TIMEOUT);
 	} while (!ret);
 
-	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+	if (xenbus_read_driver_state(dev, dev->otherend) == XenbusStateClosed)
 		return;
 
 	do {
 		xenbus_switch_state(dev, XenbusStateClosed);
 		ret = wait_event_timeout(module_wq,
-				   xenbus_read_driver_state(dev->otherend) ==
-				   XenbusStateClosed ||
-				   xenbus_read_driver_state(dev->otherend) ==
-				   XenbusStateUnknown,
-				   XENNET_TIMEOUT);
+				xenbus_read_driver_state(dev, dev->otherend) ==
+				XenbusStateClosed ||
+				xenbus_read_driver_state(dev, dev->otherend) ==
+				XenbusStateUnknown,
+				XENNET_TIMEOUT);
 	} while (!ret);
 }
 
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 11636634ae51..cd22bf984024 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -856,7 +856,7 @@ static void pcifront_try_connect(struct pcifront_device *pdev)
 	int err;
 
 	/* Only connect once */
-	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename) !=
 	    XenbusStateInitialised)
 		return;
 
@@ -876,7 +876,7 @@ static int pcifront_try_disconnect(struct pcifront_device *pdev)
 	enum xenbus_state prev_state;
 
 
-	prev_state = xenbus_read_driver_state(pdev->xdev->nodename);
+	prev_state = xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename);
 
 	if (prev_state >= XenbusStateClosing)
 		goto out;
@@ -895,7 +895,7 @@ static int pcifront_try_disconnect(struct pcifront_device *pdev)
 
 static void pcifront_attach_devices(struct pcifront_device *pdev)
 {
-	if (xenbus_read_driver_state(pdev->xdev->nodename) ==
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename) ==
 	    XenbusStateReconfiguring)
 		pcifront_connect(pdev);
 }
@@ -909,7 +909,7 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
 	struct pci_dev *pci_dev;
 	char str[64];
 
-	state = xenbus_read_driver_state(pdev->xdev->nodename);
+	state = xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename);
 	if (state == XenbusStateInitialised) {
 		dev_dbg(&pdev->xdev->dev, "Handle skipped connect.\n");
 		/* We missed Connected and need to initialize. */
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 924025305753..ef74d4da5ab0 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -1175,7 +1175,7 @@ static void scsifront_backend_changed(struct xenbus_device *dev,
 			return;
 		}
 
-		if (xenbus_read_driver_state(dev->nodename) ==
+		if (xenbus_read_driver_state(dev, dev->nodename) ==
 		    XenbusStateInitialised)
 			scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_ADD_LUN);
 
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index b11e401f1b1e..4bd1c7a8957e 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -149,12 +149,12 @@ static int xen_pcibk_attach(struct xen_pcibk_device *pdev)
 
 	mutex_lock(&pdev->dev_lock);
 	/* Make sure we only do this setup once */
-	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename) !=
 	    XenbusStateInitialised)
 		goto out;
 
 	/* Wait for frontend to state that it has published the configuration */
-	if (xenbus_read_driver_state(pdev->xdev->otherend) !=
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->otherend) !=
 	    XenbusStateInitialised)
 		goto out;
 
@@ -374,7 +374,7 @@ static int xen_pcibk_reconfigure(struct xen_pcibk_device *pdev,
 	dev_dbg(&pdev->xdev->dev, "Reconfiguring device ...\n");
 
 	mutex_lock(&pdev->dev_lock);
-	if (xenbus_read_driver_state(pdev->xdev->nodename) != state)
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename) != state)
 		goto out;
 
 	err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, "num_devs", "%d",
@@ -572,7 +572,7 @@ static int xen_pcibk_setup_backend(struct xen_pcibk_device *pdev)
 	/* It's possible we could get the call to setup twice, so make sure
 	 * we're not already connected.
 	 */
-	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	if (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename) !=
 	    XenbusStateInitWait)
 		goto out;
 
@@ -662,7 +662,7 @@ static void xen_pcibk_be_watch(struct xenbus_watch *watch,
 	struct xen_pcibk_device *pdev =
 	    container_of(watch, struct xen_pcibk_device, be_watch);
 
-	switch (xenbus_read_driver_state(pdev->xdev->nodename)) {
+	switch (xenbus_read_driver_state(pdev->xdev, pdev->xdev->nodename)) {
 	case XenbusStateInitWait:
 		xen_pcibk_setup_backend(pdev);
 		break;
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 2dc874fb5506..6ed0cd8e9676 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -936,7 +936,8 @@ static int xenbus_unmap_ring_hvm(struct xenbus_device *dev, void *vaddr)
  * Returns: the state of the driver rooted at the given store path, or
  * XenbusStateUnknown if no state can be read.
  */
-enum xenbus_state xenbus_read_driver_state(const char *path)
+enum xenbus_state xenbus_read_driver_state(const struct xenbus_device *dev,
+					   const char *path)
 {
 	enum xenbus_state result;
 	int err = xenbus_gather(XBT_NIL, path, "state", "%d", &result, NULL);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 9f9011cd7447..2eed06ba5d38 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -191,7 +191,7 @@ void xenbus_otherend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	state = xenbus_read_driver_state(dev->otherend);
+	state = xenbus_read_driver_state(dev, dev->otherend);
 
 	dev_dbg(&dev->dev, "state is %d, (%s), %s, %s\n",
 		state, xenbus_strstate(state), dev->otherend_watch.node, path);
@@ -364,7 +364,7 @@ void xenbus_dev_remove(struct device *_dev)
 	 * closed.
 	 */
 	if (!drv->allow_rebind ||
-	    xenbus_read_driver_state(dev->nodename) == XenbusStateClosing)
+	    xenbus_read_driver_state(dev, dev->nodename) == XenbusStateClosing)
 		xenbus_switch_state(dev, XenbusStateClosed);
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_remove);
@@ -514,7 +514,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	size_t stringlen;
 	char *tmpstring;
 
-	enum xenbus_state state = xenbus_read_driver_state(nodename);
+	enum xenbus_state state = xenbus_read_driver_state(NULL, nodename);
 
 	if (state != XenbusStateInitialising) {
 		/* Device is not new, so ignore it.  This can happen if a
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index f04707d1f667..ca04609730df 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -253,7 +253,7 @@ static int print_device_status(struct device *dev, void *data)
 	} else if (xendev->state < XenbusStateConnected) {
 		enum xenbus_state rstate = XenbusStateUnknown;
 		if (xendev->otherend)
-			rstate = xenbus_read_driver_state(xendev->otherend);
+			rstate = xenbus_read_driver_state(xendev, xendev->otherend);
 		pr_warn("Timeout connecting to device: %s (local state %d, remote state %d)\n",
 			xendev->nodename, xendev->state, rstate);
 	}
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index c94caf852aea..15319da65b7f 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -228,7 +228,8 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr);
 int xenbus_alloc_evtchn(struct xenbus_device *dev, evtchn_port_t *port);
 int xenbus_free_evtchn(struct xenbus_device *dev, evtchn_port_t port);
 
-enum xenbus_state xenbus_read_driver_state(const char *path);
+enum xenbus_state xenbus_read_driver_state(const struct xenbus_device *dev,
+					   const char *path);
 
 __printf(3, 4)
 void xenbus_dev_error(struct xenbus_device *dev, int err, const char *fmt, ...);
-- 
2.53.0

