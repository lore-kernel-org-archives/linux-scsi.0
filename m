From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 09/11] mptfusion: make adapter prod_name[] a pointer
Date: Wed, 25 Jun 2014 17:06:28 -0400
Message-ID: <1403730388-20285-1-git-send-email-joe.lawrence@stratus.com>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:53874 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaFYVGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 17:06:55 -0400
In-Reply-To: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>

The struct _MPT_ADAPTER doesn't need a full copy of the product string,
so prod_name can point to the string literal storage that the driver
already provides.

Avoids the following smatch warning:

  drivers/message/fusion/mptbase.c:2858 MptDisplayIocCapabilities()
    warn: this array is probably non-NULL. 'ioc->prod_name'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptbase.c |   11 +++++------
 drivers/message/fusion/mptbase.h |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ea30033..9d4c782 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1408,8 +1408,8 @@ mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp)
  *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
  *
  **/
-static void
-mpt_get_product_name(u16 vendor, u16 device, u8 revision, char *prod_name)
+static const char*
+mpt_get_product_name(u16 vendor, u16 device, u8 revision)
 {
 	char *product_str = NULL;
 
@@ -1635,8 +1635,7 @@ mpt_get_product_name(u16 vendor, u16 device, u8 revision, char *prod_name)
 	}
 
  out:
-	if (product_str)
-		sprintf(prod_name, "%s", product_str);
+	return product_str;
 }
 
 /**
@@ -1887,8 +1886,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
 	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
-	mpt_get_product_name(pdev->vendor, pdev->device, pdev->revision,
-			     ioc->prod_name);
+	ioc->prod_name = mpt_get_product_name(pdev->vendor, pdev->device,
+					      pdev->revision);
 
 	switch (pdev->device)
 	{
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 76c05bc..78c8104 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -605,7 +605,7 @@ typedef struct _MPT_ADAPTER
 	int			 id;		/* Unique adapter id N {0,1,2,...} */
 	int			 pci_irq;	/* This irq           */
 	char			 name[MPT_NAME_LENGTH];	/* "iocN"             */
-	char			 prod_name[MPT_NAME_LENGTH];	/* "LSIFC9x9"         */
+	const char		 *prod_name;	/* "LSIFC9x9"         */
 #ifdef CONFIG_FUSION_LOGGING
 	/* used in mpt_display_event_info */
 	char			 evStr[EVENT_DESCR_STR_SZ];
-- 
1.7.10.4

