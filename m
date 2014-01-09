From: Kees Cook <keescook@google.com>
Subject: Re: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
Date: Thu, 9 Jan 2014 12:03:10 -0800
Message-ID: <CAGXu5jLniOyrRrJFXdxQL1ojb=0RW1w8XLAL+UXWp7h2J49Xbw@mail.gmail.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131030171351.GB4130@longonot.mountain>
	<bd7f5bb0d19c45e2af9702c1cb6068ea@DM2PR07MB400.namprd07.prod.outlook.com>
	<CAGXu5j+WvAckRNyiSU8WYzWriWU2Y4+KMwxe17xxn8Y_w=kSPA@mail.gmail.com>
	<341c8929f76f46d19027677af9d6f532@DM2PR07MB400.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57560 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAIUDL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 15:03:11 -0500
Received: by mail-oa0-f41.google.com with SMTP id i4so2997094oah.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jan 2014 12:03:11 -0800 (PST)
In-Reply-To: <341c8929f76f46d19027677af9d6f532@DM2PR07MB400.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "Saxena, Sumit" <Sumit.Saxena@lsi.com>, Dan Carpenter <dan.carpenter@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>, Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>

On Thu, Jan 9, 2014 at 11:53 AM, Saxena, Sumit <Sumit.Saxena@lsi.com> wrote:
>
>
>>-----Original Message-----
>>From: Kees Cook [mailto:keescook@google.com]
>>Sent: Friday, January 10, 2014 12:05 AM
>>To: Saxena, Sumit
>>Cc: Dan Carpenter; DL-MegaRAID Linux; James E.J. Bottomley; linux-
>>scsi@vger.kernel.org; security@kernel.org; Nico Golde; Fabian Yamaguchi
>>Subject: Re: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
>>
>>On Wed, Jan 8, 2014 at 4:27 AM, Saxena, Sumit <Sumit.Saxena@lsi.com>
>>wrote:
>>>
>>>
>>>>-----Original Message-----
>>>>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>>>>Sent: Wednesday, October 30, 2013 10:44 PM
>>>>To: DL-MegaRAID Linux
>>>>Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org;
>>>>security@kernel.org; Nico Golde; Fabian Yamaguchi
>>>>Subject: [patch] [SCSI] megaraid: missing bounds check in
>>>>mimd_to_kioc()
>>>>
>>>>pthru32->dataxferlen comes from the user so we need to check that it's
>>>>not too large so we don't overflow the buffer.
>>>>
>>>>Reported-by: Nico Golde <nico@ngolde.de>
>>>>Reported-by: Fabian Yamaguchi <fabs@goesec.de>
>>>>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>---
>>>>Please review this carefully because I have not tested it.
>>>>
>>>>diff --git a/drivers/scsi/megaraid/megaraid_mm.c
>>>>b/drivers/scsi/megaraid/megaraid_mm.c
>>>>index dfffd0f..a706927 100644
>>>>--- a/drivers/scsi/megaraid/megaraid_mm.c
>>>>+++ b/drivers/scsi/megaraid/megaraid_mm.c
>>>>@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd,
>>mraid_mmadp_t
>>>>*adp, uioc_t *kioc)
>>>>
>>>>       pthru32->dataxferaddr   = kioc->buf_paddr;
>>>>       if (kioc->data_dir & UIOC_WR) {
>>>>+              if (pthru32->dataxferlen > kioc->xferlen)
>>>>+                      return -EINVAL;
>>>>               if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
>>>>                                               pthru32->dataxferlen)) {
>>>>                       return (-EFAULT);
>>>
>>> Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
>>>
>>> Sumit
>>>
>>
>>Thanks for the Ack. Who normally picks patches for this area?
>>
>>-Kees
>>
> James Bottomley(Linux SCSI subsystem maintainer) should pick this patch.

Okay, thanks. James, can you pick up this patch as well?
https://lkml.org/lkml/2013/12/18/477

Thanks,

-Kees

>
> Sumit
>>--
>>Kees Cook
>>Chrome OS Security
>



-- 
Kees Cook
Chrome OS Security
