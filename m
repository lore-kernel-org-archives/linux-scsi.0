From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 1/3] isci: isci: remove SCSI host before detaching from SAS transport
Date: Wed, 4 Nov 2015 17:48:08 +0100
Message-ID: <CAMGffE=F6PuKNV1vgesePQ29GJUCoZaScq01pT-gqROjV4DL9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38473 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030498AbbKDQs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 11:48:29 -0500
Received: by wmeg8 with SMTP id g8so46521342wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2015 08:48:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, intel-linux-scu@intel.com
Cc: hch@lst.de, brood@attotech.com

=46rom b1fb56b6d98610251253dc4b858df509df08e813 Mon Sep 17 00:00:00 200=
1
=46rom: Jack Wang <jinpu.wang@profitbricks.com>
Date: Wed, 4 Nov 2015 09:46:05 +0100
Subject: [PATCH 1/3] isci: remove SCSI host before detaching from SAS
 transport

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")
, the reference count of scsi device was changed, which could lead to w=
hen
rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

=46ix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/isci/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0dfcabe..9e0d069 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -272,11 +272,11 @@ static void isci_unregister(struct isci_host *isc=
i_host)
  if (!isci_host)
  return;

+ shost =3D to_shost(isci_host);
+ scsi_remove_host(shost);
  sas_unregister_ha(&isci_host->sas_ha);

- shost =3D to_shost(isci_host);
  sas_remove_host(shost);
- scsi_remove_host(shost);
  scsi_host_put(shost);
 }

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
