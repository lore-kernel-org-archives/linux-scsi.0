From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Tue, 26 Jul 2011 20:09:00 -0700 (PDT)
Message-ID: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.45]:35543 "HELO
	nm20-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752347Ab1G0DOV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 23:14:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

If expander discovery fails (sas_discover_expander()),
remove the expander from the port device list
(sas_ex_discover_expander()), before freeing it. Else
the list is corrupted and, e.g., when we attempt to send
SMP commands to other devices, the kernel oopses.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
=A0drivers/scsi/libsas/sas_expander.c |=A0=A0=A0 3 +++
=A01 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/s=
as_expander.c
index 874e29d..f84084b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expand=
er(
=A0
=A0=A0=A0=A0 res =3D sas_discover_expander(child);
=A0=A0=A0=A0 if (res) {
+=A0=A0=A0 =A0=A0=A0 spin_lock_irq(&parent->port->dev_list_lock);
+=A0=A0=A0 =A0=A0=A0 list_del(&child->dev_list_node);
+=A0=A0=A0 =A0=A0=A0 spin_unlock_irq(&parent->port->dev_list_lock);
=A0=A0=A0=A0 =A0=A0=A0 kfree(child);
=A0=A0=A0=A0 =A0=A0=A0 return NULL;
=A0=A0=A0=A0 }
--=20
1.7.2.2.165.gbc382
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
