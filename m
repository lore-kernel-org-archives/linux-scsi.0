From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] pm8001: support HDA (flashless) mode
Date: Sat, 28 Apr 2012 14:07:11 +0800
Message-ID: <A60D2B04CB1E487D9D0371139484E1C2@usish.com.cn>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:46551 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2D1GG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Apr 2012 02:06:59 -0400
In-Reply-To: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>


+	data = pm8001_mr32(
+		pm8001_ha->main_cfg_tbl_addr,
+		pm8001_ha->main_cfg_tbl.hda_mode_flag);
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("*MAIN_HDA_FLAGS = 0x%x\n", data));
+	return data & 0x4;

Here seems wrong, you may want to check the force hda bit? So you need to
read offset #define MAIN_HDA_FLAGS_OFFSET		0x84/* DWORD 0x21 */

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


