From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: support HDA (flashless) mode
Date: Mon, 30 Apr 2012 10:00:44 -0400
Message-ID: <B52541CD-797A-4BD7-9730-5F240C40C34C@xyratex.com>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com> <5ADF3694BDC14FC2BF986C45DFBDD819@usish.com.cn>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:60327 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752432Ab2D3OAt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 10:00:49 -0400
In-Reply-To: <5ADF3694BDC14FC2BF986C45DFBDD819@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org, 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?utf-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

PMC still does not like the images or firmware header files getting out willy-nilly, have not got free redistribution rights or approvals (in effect, as their agent). And they won't take the action to submit them to the Linux archives. As an OEM customer we are bound to follow their NDA requirements and approvals. Someone not bound by the NDA, on the other hand, can do so <hint hint>.

Conversion from their header format to binary is as follows:

	for i in aap1img.h ilaimg.h iopimg.h istrimg.h ; do
		gcc -x c -c -o ${i%.h}.bin ${i}
		objcopy -O binary ${i%h}.bin
	done

Sincerely -- Mark Salyzyn

On Apr 27, 2012, at 9:06 PM, Jack Wang wrote:

> Thanks Mark,
> 
> So how we get the bin images? PMCS only offer the converted c Header file
> for this, we need users who want to use this function convert the header
> file to bin file.
> 
> Patch need a little more time to look into, will comment back soon.
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
>> 
>> 
>> ______________________________________________________________________
>> This email may contain privileged or confidential information, which
> should
>> only be used for the purpose for which it was sent by Xyratex. No further
> rights
>> or licenses are granted to use such information. If you are not the
> intended
>> recipient of this message, please notify the sender by return and delete
> it.
>> You may not use, copy, disclose or rely on the information contained in
> it.
>> 
>> Internet email is susceptible to data corruption, interception and
>> unauthorised amendment for which Xyratex does not accept liability. While
> we
>> have taken reasonable precautions to ensure that this email is free of
> viruses,
>> Xyratex does not accept liability for the presence of any computer viruses
> in
>> this email, nor for any losses caused as a result of viruses.
>> 
>> Xyratex Technology Limited (03134912), Registered in England & Wales,
>> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>> 
>> The Xyratex group of companies also includes, Xyratex Ltd, registered in
>> Bermuda, Xyratex International Inc, registered in California, Xyratex
>> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
> Ltd
>> registered in The People's Republic of China and Xyratex Japan Limited
>> registered in Japan.
>> ______________________________________________________________________
>> 
>> 
> 
> 

