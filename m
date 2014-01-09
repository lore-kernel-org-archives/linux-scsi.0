From: Kees Cook <keescook@google.com>
Subject: Re: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
Date: Thu, 9 Jan 2014 10:34:36 -0800
Message-ID: <CAGXu5j+WvAckRNyiSU8WYzWriWU2Y4+KMwxe17xxn8Y_w=kSPA@mail.gmail.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131030171351.GB4130@longonot.mountain>
	<bd7f5bb0d19c45e2af9702c1cb6068ea@DM2PR07MB400.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35290 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAISeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 13:34:37 -0500
Received: by mail-oa0-f43.google.com with SMTP id m1so3857401oag.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jan 2014 10:34:37 -0800 (PST)
In-Reply-To: <bd7f5bb0d19c45e2af9702c1cb6068ea@DM2PR07MB400.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>, Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>

On Wed, Jan 8, 2014 at 4:27 AM, Saxena, Sumit <Sumit.Saxena@lsi.com> wrote:
>
>
>>-----Original Message-----
>>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>>Sent: Wednesday, October 30, 2013 10:44 PM
>>To: DL-MegaRAID Linux
>>Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; security@kernel.org;
>>Nico Golde; Fabian Yamaguchi
>>Subject: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
>>
>>pthru32->dataxferlen comes from the user so we need to check that it's
>>not too large so we don't overflow the buffer.
>>
>>Reported-by: Nico Golde <nico@ngolde.de>
>>Reported-by: Fabian Yamaguchi <fabs@goesec.de>
>>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>---
>>Please review this carefully because I have not tested it.
>>
>>diff --git a/drivers/scsi/megaraid/megaraid_mm.c
>>b/drivers/scsi/megaraid/megaraid_mm.c
>>index dfffd0f..a706927 100644
>>--- a/drivers/scsi/megaraid/megaraid_mm.c
>>+++ b/drivers/scsi/megaraid/megaraid_mm.c
>>@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd,
>>mraid_mmadp_t *adp, uioc_t *kioc)
>>
>>       pthru32->dataxferaddr   = kioc->buf_paddr;
>>       if (kioc->data_dir & UIOC_WR) {
>>+              if (pthru32->dataxferlen > kioc->xferlen)
>>+                      return -EINVAL;
>>               if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
>>                                               pthru32->dataxferlen)) {
>>                       return (-EFAULT);
>
> Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
>
> Sumit
>

Thanks for the Ack. Who normally picks patches for this area?

-Kees

-- 
Kees Cook
Chrome OS Security
