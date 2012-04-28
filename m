From: "Jack Wang" <jack_wang@usish.com>
Subject: Re [PATCH] pm8001: support HDA (flashless) mode
Date: Sat, 28 Apr 2012 12:44:39 +0800
Message-ID: <031C71F94EE847BE812F50366014A8DE@usish.com.cn>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49673 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2D1Eo1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Apr 2012 00:44:27 -0400
In-Reply-To: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+
+	/* HDA SEEPROM Force HDA Mode */
+	if (PM8001_CHIP_DISP->chip_in_hda_mode(pm8001_ha)) {
+		rc = PM8001_CHIP_DISP->chip_hda_mode(pm8001_ha);
+		if (!rc) {
+			rc = -EBUSY;
+			goto err_out_ha_free;
+		}
+		pm8001_ha->rst_signature = SPC_HDASOFT_RESET_SIGNATURE;
+	} else {
+		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha,
+			SPC_SOFT_RESET_SIGNATURE);
+		pm8001_ha->rst_signature = SPC_SOFT_RESET_SIGNATURE;
+	}

Here I think we'd better try normal mode first, then fail to HAD mode.

Jack

> 
> The pm8001 can be delivered as a standalone product with flash-programmed
> firmware images, or without the flash present requiring the driver to
upload
> the images into the chip's RAM and then run. This is called HDA mode.
> 
> We add support for this firmware upload in the enclosed patch. We try some
> basic initialization checks of the Firmware, and if it appears dead, we
make
> the assumption the adapter must in-fact be halted in this HDA mode. The
> Firmware images themselves have not been cleared for open-release by PMC,
but
> they are available in OpenSolaris <hint hint>. PMC's rationalization for
not
> wanting an open-release of the Firmware Images is that they do not want to
> take support calls except from paying OEMs (such as Xyratex) that are
embedding
> PMC product into the motherboards and thus may have a tested combination
of
> Firmware and Hardware. Please respect this sentiment. Images are expected
in:
> 
> /lib/firmware/aap1img.bin
> /lib/firmware/ilaimg.bin
> /lib/firmware/iopimg.bin
> /lib/firmware/istrimg.bin
> 
> using the exact same naming convention as PMC and in OpenSolaris (and its
> followon children) for these image files.
> 
> Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
> 
>  drivers/scsi/pm8001/pm8001_hwi.c  |  584
> +++++++++++++++++++++++++++++++++++---
>  drivers/scsi/pm8001/pm8001_hwi.h  |   37 ++
>  drivers/scsi/pm8001/pm8001_init.c |   30 +
>  drivers/scsi/pm8001/pm8001_sas.h  |    3
>  4 files changed, 613 insertions(+), 41 deletions(-)
> 
> Please see enclosed attachment


