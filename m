From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] scsi: storvsc: be more picky about scmnd->sc_data_direction
Date: Thu, 25 Jun 2015 18:12:11 +0200
Message-ID: <1435248731-29085-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbbFYQMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 12:12:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>

Under the 'default' case in scmnd->sc_data_direction we have 3 options:
- DMA_NONE which we handle correctly.
- DMA_BIDIRECTIONAL which is never supposed to be set by SCSI stack.
- Garbage value.

Do WARN() and return -EINVAL in the last two cases. virtio_scsi does
BUG_ON() here but it looks like an overkill.

Reported-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..61f4855 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1598,10 +1598,18 @@ static int storvsc_queuecommand(struct Scsi_Hos=
t *host, struct scsi_cmnd *scmnd)
 		vm_srb->data_in =3D READ_TYPE;
 		vm_srb->win8_extension.srb_flags |=3D SRB_FLAGS_DATA_IN;
 		break;
-	default:
+	case DMA_NONE:
 		vm_srb->data_in =3D UNKNOWN_TYPE;
 		vm_srb->win8_extension.srb_flags |=3D SRB_FLAGS_NO_DATA_TRANSFER;
 		break;
+	default:
+		/*
+		 * This is DMA_BIDIRECTIONAL or something else we are never
+		 * supposed to see here.
+		 */
+		WARN(1, "Unexpected data direction: %d\n",
+		     scmnd->sc_data_direction);
+		return -EINVAL;
 	}
=20
=20
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
