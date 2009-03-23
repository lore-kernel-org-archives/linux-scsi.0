From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: ipr_remove() marked __devexit
Date: Mon, 23 Mar 2009 17:12:25 -0300
Message-ID: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:49443 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZCWUJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2009 16:09:31 -0400
Received: from mailhub3.br.ibm.com (mailhub3.br.ibm.com [9.18.232.110])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n2NK6C7Z027281
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 17:06:12 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2NK9kW91904846
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 17:09:47 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2NK9Rmn022551
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 17:09:27 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Marking the ipr clean up function ipr_remove() as __devexit and using
__devexit_p() macro in its address reference.


Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm.com>
Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0782900..bc39ac6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7674,7 +7674,7 @@ static void __ipr_remove(struct pci_dev *pdev)
  * Return value:
  *     none
  **/
-static void ipr_remove(struct pci_dev *pdev)
+static void __devexit ipr_remove(struct pci_dev *pdev)
 {
        struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);

@@ -7850,7 +7850,7 @@ static struct pci_driver ipr_driver = {
        .name = IPR_NAME,
        .id_table = ipr_pci_table,
        .probe = ipr_probe,
-       .remove = ipr_remove,
+       .remove = __devexit_p(ipr_remove),
        .shutdown = ipr_shutdown,
        .err_handler = &ipr_err_handler,
 };
--

-- 
Kleber Sacilotto de Souza
Software Engineer
IBM Linux Technology Center

