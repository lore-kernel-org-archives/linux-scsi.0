From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/4] scsi: megaraid_sas - Add the shutdown DCMD cmd to
 driver shutdown routine
Date: Fri, 1 Aug 2008 10:48:48 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B080962@cosmail02.lsi.com>
References: <1205741587.7479.17.camel@pcp021067pcs.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55150 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYHAQtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 12:49:36 -0400
In-Reply-To: <1205741587.7479.17.camel@pcp021067pcs.se.lsil.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "poswald@novell.com" <poswald@novell.com>, "Austria, Winston" <Winston.Austria@lsi.com>

Add the shutdown DCMD cmd to driver shutdown routine to make megaraid sas FW shutdown proper.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |    1 +
 1 files changed, 1 insertion(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2008-07-31 12:51:06.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2008-07-31 12:54:09.000000000 -0400
@@ -2863,6 +2863,7 @@ static void megasas_shutdown(struct pci_
 {
        struct megasas_instance *instance = pci_get_drvdata(pdev);
        megasas_flush_cache(instance);
+       megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 }

 /**
