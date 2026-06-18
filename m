Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C7013A86C;
	Thu, 18 Jun 2026 13:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788537; cv=none; b=lo1HQbA1ew/l3nS8lub0xiYq/HCZQibUsXlqUyUuSMtmctAaDO9HiloCUHH6BogmWBOvgUW2nbb/wUojsVYnTy1NXsUvTE7I4qmfRkV61ubNuPlQB6/TUmt12Kz4j2QNmESVO7AmvXrFUJIFQiGfQ6TSjM7tI+OiX44sy8NzfZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788537; c=relaxed/simple;
	bh=ABsoaaUcgliw9FcMTDp8g13+A40h1x1f1QrD2a6oXIQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BcdAnbn6LgDccBsQHgXYUWeWHgvrvcMVlGzvYwVVXSZC8AEHSvKCQNbqQ160jDT4q+KCHxJFascM8kFeB1JCot85BRdPse9m4HXn5TLzFT0uh5KnlVek/cuA94s6z5WhQtWAOUXGo0w1kI3em7TKn6TpfF/2swUoedEH/Xb7wKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=UFAsXuGM; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="UFAsXuGM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781788518; x=1782393318; i=markus.elfring@web.de;
	bh=uR3UfO9LJUS8dd9Wje1UrjJ+0Q9ZQzYWZxCZuKRvFMc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UFAsXuGMKY/LzKjXTSRt3Qwc3GEeYAZlBaFjblpjCifarCfdQ6FRwpFY5+J+eIwg
	 URThH67IY7l0pfBgcA7myvQ8NS7xUtX9NOMO4VH6CmP3HEjRv3tmXGiQIiKXYiUwB
	 VXnx15TNdtiGsLlunq+sm5+1ID95XBd+I3rKkS+1Sbw308ndwpSRXDl7cycHNl0oF
	 GIk7nPBLks2nIgcfiJj3BUtEZ7TqB1OHRqR0lLPNtC1qoINtMJ4iqlIdUSh1+08GF
	 K5sUoTZGBDbgUP/MzT5RF1KaTGirE8JQf0Jww8gGR5bjsIZn+AZb+zZQ/sp8C2rOw
	 6ss/XG+kvu7pZzBY2g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MoNZC-1wyEnd3qKe-00pj2f; Thu, 18
 Jun 2026 15:15:17 +0200
Message-ID: <366c376e-ef8a-490d-a580-570f2f51ec81@web.de>
Date: Thu, 18 Jun 2026 15:15:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
 Brian Bunker <brian@purestorage.com>, Hannes Reinecke <hare@suse.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Kees Cook <kees@kernel.org>, Krishna Kant <krishna.kant@purestorage.com>,
 Marco Crivellari <marco.crivellari@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Tang Junhui <tang.junhui@zte.com.cn>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] scsi: scsi_dh_alua: Use common code in alua_rtpg()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Dq5On5Zo6Zu1+TkrokHdfKbyMP7QpRZJomrJ1xA6L4mjc8gZaYG
 bbxzS8mf5Q0eV8NZsW8kV2Eul8ZBSKftCGebhRT6Yqxj/9k6T0nrRerF/1YeRx6RL1zGzN1
 LGmHYWKTLGvAdxhMdIfD0JZe6ew/UFDuYysfVCDpmhugRtKc68gIfUSsQj0LnnUcJgKHAq9
 r2Hfu5uwNsfWwKtn2EmbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GcmuM6wjwsg=;v9scbXDFOOwHgIlFHU0TeHG70uI
 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
 mfvDaa0Yi1fhWvWhzXy6D8Y/WZo=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 18 Jun 2026 14:54:13 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/dev=
ice_handler/scsi_dh_alua.c
index 80ab0ff921d4..016150701064 100644
=2D-- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -582,8 +582,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct =
alua_port_group *pg)
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: ignoring rtpg result %d\n",
 				    ALUA_DH_NAME, retval);
-			kfree(buff);
-			return SCSI_DH_OK;
+			err =3D SCSI_DH_OK;
+			goto free_buff;
 		}
 		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
@@ -632,15 +632,14 @@ static int alua_rtpg(struct scsi_device *sdev, struc=
t alua_port_group *pg)
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-			kfree(buff);
-			return err;
+			goto free_buff;
 		}
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-		kfree(buff);
 		pg->expiry =3D 0;
-		return SCSI_DH_IO;
+		err =3D SCSI_DH_IO;
+		goto free_buff;
 	}
=20
 	len =3D get_unaligned_be32(&buff[0]) + 4;
@@ -770,6 +769,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct =
alua_port_group *pg)
 		break;
 	}
 	spin_unlock_irqrestore(&pg->lock, flags);
+free_buff:
 	kfree(buff);
 	return err;
 }
=2D-=20
2.54.0

