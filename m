From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [SCSI] aacraid reset should disable MSI interrupt
Date: Fri, 2 Sep 2011 09:01:16 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A901854039@XYUS-EX22.xyus.xyratex.com>
References: <4E60F6E2.7090505@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:48063 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab1IBQCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2011 12:02:43 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4E60F6E2.7090505@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>, linux-scsi@vger.kernel.org, aacraid@adaptec.com
Cc: James Bottomley <jbottomley@parallels.com>

Good Stuff!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Vasily Averin [mailto:vvs@parallels.com] 
Sent: Friday, September 02, 2011 11:32 AM
To: linux-scsi@vger.kernel.org; aacraid@adaptec.com; Mark Salyzyn
Cc: James Bottomley
Subject: [SCSI] aacraid reset should disable MSI interrupt

scsi reset on hardware with enabled MSI interrupts generates WARNING
message

[11027.798722] aacraid: Host adapter abort request (0,0,0,0)
[11027.798814] aacraid: Host adapter reset request. SCSI hang ?
[11087.762237] aacraid: SCSI bus appears hung
[11135.082543] ------------[ cut here ]------------
[11135.082646] WARNING: at drivers/pci/msi.c:658
pci_enable_msi_block+0x251/0x290()

Signed-off-by:	Vasily Averin <vvs@sw.ru>
---
 drivers/scsi/aacraid/commsup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c
b/drivers/scsi/aacraid/commsup.c
index e7d0d47..e5f2d7d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1283,6 +1283,8 @@ static int _aac_reset_adapter(struct aac_dev *aac,
int forced)
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
-- 
1.7.4.1


______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


