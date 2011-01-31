From: Chuck Tuffli <ctuffli@gmail.com>
Subject: [libsas] lldd_port_formed question
Date: Mon, 31 Jan 2011 15:04:14 -0800
Message-ID: <AANLkTimKLX4DfQ_XtEdgwPm35Gnr8h8tqUz6e-TFdkWa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1AaXEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2011 18:04:16 -0500
Received: by wwa36 with SMTP id 36so6395776wwa.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2011 15:04:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to understand the intention of the lldd_port_formed
callback from libsas. My assumption was libsas would only call this
function (if defined, of course) once per port, but it appears to be
called for each PHY added to the port. Is that by design or should the
function have an additional check on the number of PHYs in the port?
Something like

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 5257fdf..8d61938 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -140,7 +140,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 		port->port_dev->pathways = port->num_phys;

 	/* Tell the LLDD about this port formation. */
-	if (si->dft->lldd_port_formed)
+	if (si->dft->lldd_port_formed && (port->num_phys == 1))
 		si->dft->lldd_port_formed(phy);

 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);


---chuck
