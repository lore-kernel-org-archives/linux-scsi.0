From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 04:54:54 -0800
Message-ID: <m1iqn2ein5.fsf@fess.ebiederm.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<499FD623.1010105@kernel.org> <49A04F1E.7020006@gmail.com>
	<200902221308.55053.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:52491 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBVMyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 07:54:41 -0500
In-Reply-To: <200902221308.55053.prakash@punnoor.de> (Prakash Punnoor's message of "Sun\, 22 Feb 2009 13\:08\:54 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org


Prakesh could you try this patch instead?

I think the problem is simply that the MCP55 ht mapping capability
requires an address to be programed into it and it wasn't in your
case.

It should not hurt to enable one msi ht mapping capability too many.

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index baad093..f7a0370 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2017,10 +2017,19 @@ static void __devinit ht_enable_msi_mapping(struct pci_dev *dev)
 	while (pos && ttl--) {
 		u8 flags;
 
-		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
-					 &flags) == 0) {
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags))
+			return;
+
+		if (!(flags & HT_MSI_FLAGS_ENABLE)) {
 			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
 
+			if (!(flags & HT_MSI_FLAGS_FIXED)) {
+				pci_write_config_dword(dev, pos + HT_MSI_ADDR_LO,
+					(HT_MSI_FIXED_ADDR & HT_MSI_FIXED_ADDR));
+				pci_write_config_dword(dev, pos + HT_MSI_ADDR_HI,
+					(HT_MSI_FIXED_ADDR >> 32));
+			}
+
 			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 					      flags | HT_MSI_FLAGS_ENABLE);
 		}
