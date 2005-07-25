From: Hannes Reinecke <hare@suse.de>
Subject: Fallback sequence in scsi_transport_spi
Date: Mon, 25 Jul 2005 10:30:31 +0200
Message-ID: <42E4A327.90005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46017 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261828AbVGYIao convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 04:30:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

it appears that the fallback sequence in
scsi_transport_spi.c:spi_dv_retrain()
is somewhat incorrect.

According to SPI-3 (spi3r14, actually), the flags DT, IU, and QAS can b=
e
set in the following order of precedence (Table 55, p 155):
- DT
- IU
- QAS

This implies that for QAS DT and IU _have_ to be set. Vice versa for a
retrain we first should unset QAS, then IU (as QAS without IU is
invalid) and then DT.

However, the fallback routine in spi_dv_retrain first unsets IU, _then_
QAS, and ignoring DT entirely. This smells a bit fishy.
Any reasons for this?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
