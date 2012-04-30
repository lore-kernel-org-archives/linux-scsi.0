From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: support HDA (flashless) mode
Date: Mon, 30 Apr 2012 09:49:58 -0400
Message-ID: <73464C75-47D9-4409-87C2-8DDD0CBD5C67@xyratex.com>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com> <A60D2B04CB1E487D9D0371139484E1C2@usish.com.cn>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:32261 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752432Ab2D3NuE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 09:50:04 -0400
In-Reply-To: <A60D2B04CB1E487D9D0371139484E1C2@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org, 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?utf-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

You are right ... however this code is 'never reached' since mpi_uninit_check() generally fails before this in the chip_in_hda_mode set of tests.

I instrumented up, on our HDA mode chip, we are seeing a value of ZERO in MAIN_HDA_FLAGS_OFFSET ... Ahh, the world of initializing hardware that is in an indeterminate (code not running) state ...

-- Mark

On Apr 28, 2012, at 2:07 AM, Jack Wang wrote:

> 
> +	data = pm8001_mr32(
> +		pm8001_ha->main_cfg_tbl_addr,
> +		pm8001_ha->main_cfg_tbl.hda_mode_flag);
> +	PM8001_INIT_DBG(pm8001_ha,
> +		pm8001_printk("*MAIN_HDA_FLAGS = 0x%x\n", data));
> +	return data & 0x4;
> 
> Here seems wrong, you may want to check the force hda bit? So you need to
> read offset #define MAIN_HDA_FLAGS_OFFSET		0x84/* DWORD 0x21 */
> 
> Jack
> 
> 
>> 
>> The pm8001 can be delivered as a standalone product with flash-programmed
>> firmware images, or without the flash present requiring the driver to
> upload
>> the images into the chip's RAM and then run. This is called HDA mode.
>> 
>> We add support for this firmware upload in the enclosed patch. We try some
>> basic initialization checks of the Firmware, and if it appears dead, we
> make
>> the assumption the adapter must in-fact be halted in this HDA mode. The
>> Firmware images themselves have not been cleared for open-release by PMC,
> but
>> they are available in OpenSolaris <hint hint>. PMC's rationalization for
> not
>> wanting an open-release of the Firmware Images is that they do not want to
>> take support calls except from paying OEMs (such as Xyratex) that are
> embedding
>> PMC product into the motherboards and thus may have a tested combination
> of
>> Firmware and Hardware. Please respect this sentiment. Images are expected
> in:
>> 
>> /lib/firmware/aap1img.bin
>> /lib/firmware/ilaimg.bin
>> /lib/firmware/iopimg.bin
>> /lib/firmware/istrimg.bin
>> 
>> using the exact same naming convention as PMC and in OpenSolaris (and its
>> followon children) for these image files.
>> 
>> Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
>> 
>> drivers/scsi/pm8001/pm8001_hwi.c  |  584
>> +++++++++++++++++++++++++++++++++++---
>> drivers/scsi/pm8001/pm8001_hwi.h  |   37 ++
>> drivers/scsi/pm8001/pm8001_init.c |   30 +
>> drivers/scsi/pm8001/pm8001_sas.h  |    3
>> 4 files changed, 613 insertions(+), 41 deletions(-)
>> 
>> Please see enclosed attachment
> 
> 

