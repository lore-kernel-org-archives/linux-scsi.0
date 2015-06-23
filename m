From: Timothy Pearson <tpearson@raptorengineeringinc.com>
Subject: [PATCH] mpt3sas: Abort initialization if no memory I/O resources
 detected
Date: Tue, 23 Jun 2015 14:32:38 -0500 (CDT)
Message-ID: <1741634911.3158.1435087958045.JavaMail.zimbra@raptorengineeringinc.com>
References: <557B578D.50706@raptorengineeringinc.com> <1435066507.2251.10.camel@HansenPartnership.com> <55899867.3010400@raptorengineeringinc.com> <1435081516.2251.118.camel@HansenPartnership.com> <55899BBA.5030509@raptorengineeringinc.com> <1435082169.2251.120.camel@HansenPartnership.com> <55899E79.1010208@raptorengineeringinc.com> <1435083585.2251.125.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearsoncomputing.net ([192.119.205.242]:23905 "EHLO
	mail.pearsoncomputing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbbFWTcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 15:32:39 -0400
In-Reply-To: <216113403.3157.1435087917094.JavaMail.zimbra@raptorengineeringinc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Support (LSI)" <support@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

The mpt3sas driver crashes if the BIOS does not set up at least one
memory I/O resource.  This failure can happen if the device is too
slow to respond during POST and is missed by the BIOS, but Linux
then detects the device later in the boot process.

Signed-off-by: Timothy Pearson <tpearson@raptorengineeringinc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 14a781b..4460d48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1865,6 +1865,13 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		}
 	}
 
+	if (ioc->chip == NULL) {
+		printk(MPT3SAS_FMT "unable to map "
+			"adapter memory (resource not found)!\n", ioc->name);
+		r = -EINVAL;
+		goto out_fail;
+	}
+
 	_base_mask_interrupts(ioc);
 
 	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
-- 
1.7.9.5

-- 
Timothy Pearson
Raptor Engineering
+1 (415) 727-8645
http://www.raptorengineeringinc.com 
