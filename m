From: Dave Jones <davej@redhat.com>
Subject: fix swapped arguments in aic7xxx:ahc_find_pci_device
Date: Wed, 4 Sep 2013 22:33:09 -0400
Message-ID: <20130905023309.GA10315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab3IECdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Sep 2013 22:33:17 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r852XGmG014009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2013 22:33:16 -0400
Received: from gelk.kernelslacker.org (ovpn-113-166.phx2.redhat.com [10.3.113.166])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r852XAZP008240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2013 22:33:16 -0400
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id r852X9Ur010399
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2013 22:33:09 -0400
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id r852X96F010398
	for linux-scsi@vger.kernel.org; Wed, 4 Sep 2013 22:33:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The prototype for ahc_9005_subdevinfo_valid shows that the caller has the
arguments in the wrong order.

 637 ahc_9005_subdevinfo_valid(uint16_t device, uint16_t vendor,
 638                           uint16_t subdevice, uint16_t subvendor)

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 6917b4f..22d5a94 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -692,7 +692,7 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 	 * ID as valid.
 	 */
 	if (ahc_get_pci_function(pci) > 0
-	 && ahc_9005_subdevinfo_valid(vendor, device, subvendor, subdevice)
+	 && ahc_9005_subdevinfo_valid(device, vendor, subdevice, subvendor)
 	 && SUBID_9005_MFUNCENB(subdevice) == 0)
 		return (NULL);
 
