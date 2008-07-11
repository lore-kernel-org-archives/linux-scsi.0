From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/6] : Fixing default enabling of MSI for SPI and FC
	controllers
Date: Thu, 10 Jul 2008 22:10:55 -0500
Message-ID: <1215745855.3353.118.camel@localhost.localdomain>
References: <20080520192741.GD11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40936 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYGKDK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 23:10:59 -0400
In-Reply-To: <20080520192741.GD11542@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Wed, 2008-05-21 at 00:57 +0530, Prakash, Sathya wrote:
> The patch submitted to enable the MSI by default for SAS controllers
> sets the MSI even for SPI and FC controllers due to a coding error
> This patch fixes that.

Actually, now I look at this patch, it's not complete.  There's a missed

	if (ioc->msi_enable)
		pci_disable_msi(ioc->pcidev);

in the suspend path which will trigger if ioc->msi_enable is -1.

Rather than trying to capture all the uses of ioc->msi_enable (and
missing some of them) to check for 1 instead of true, isn't it just
easier to fix the driver so that ioc->msi_enable is a logical truth
value like this?

James

---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index db3c892..d40d6d1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1686,9 +1686,14 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->bus_type = SAS;
 	}
 
-	if (ioc->bus_type == SAS && mpt_msi_enable == -1)
-		ioc->msi_enable = 1;
-	else
+	if (mpt_msi_enable == -1) {
+		/* Enable on SAS, disable on FC and SPI */
+		if (ioc->bus_type == SAS)
+			ioc->msi_enable = 1;
+		else
+			ioc->msi_enable = 0;
+	} else
+		/* follow flag: 0 - disable; 1 - enable */
 		ioc->msi_enable = mpt_msi_enable;
 
 	if (ioc->errata_flag_1064)


