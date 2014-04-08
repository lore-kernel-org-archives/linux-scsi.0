From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] hpsa: allow hpsa to claim Compaq SmartArray devices
Date: Tue, 08 Apr 2014 13:05:37 -0400
Message-ID: <53442C61.5000802@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaDHRGF (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2014 13:06:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Linux-scsi@vger.kernel.org

The hpsa driver has a wildcard entry to support older HP SmartArray devices
as unsupported. There are devices still in use that bear the Compaq vendor
ID and should be handled as well. These devices will be handled only when
hpsa_allow_any is set.

Tested with a device matching:
        {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSC, 0x0E11, 0x4091}

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -136,6 +136,8 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP, 0x333f, 0x103c, 0x333f},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
+	{PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 

-- 
Jeff Mahoney
SUSE Labs
