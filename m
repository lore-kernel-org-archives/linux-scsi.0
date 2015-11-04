From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 3/3] mvsas: remove SCSI host before detaching from SAS transport
Date: Wed, 4 Nov 2015 17:52:37 +0100
Message-ID: <CAMGffE=iV5Q9L7fkqcsuzq1V8EWuP=1VcJfXFyb63c44qixwdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38479 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567AbbKDQw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 11:52:58 -0500
Received: by wmeg8 with SMTP id g8so46632502wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2015 08:52:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Cc: hch <hch@lst.de>, brood <brood@attotech.com>

=46rom 6c3cb7d4df1e164008338c922cd99149a6a8191b Mon Sep 17 00:00:00 200=
1
=46rom: Jack Wang <jinpu.wang@profitbricks.com>
Date: Wed, 4 Nov 2015 10:05:01 +0100
Subject: [PATCH 3/3] mvsas: remove SCSI host before detaching from SAS
 transport

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")

the reference count of scsi device was changed, which could lead to
when rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

=46ix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.=
c
index e2d555c..1960d95 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -641,9 +641,9 @@ static void mvs_pci_remove(struct pci_dev *pdev)
  tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif

+ scsi_remove_host(mvi->shost);
  sas_unregister_ha(sha);
  sas_remove_host(mvi->shost);
- scsi_remove_host(mvi->shost);

  MVS_CHIP_DISP->interrupt_disable(mvi);
  free_irq(mvi->pdev->irq, sha);
--=20
1.9.1


--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
