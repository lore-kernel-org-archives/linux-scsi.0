From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH v2 1/7] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Mon, 06 May 2013 12:05:22 +0900
Message-ID: <000901ce4a06$8c8aaa00$a59ffe00$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <3081f2d4913dc74ded32bff2b8a68cd4.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38164 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3EFDFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 May 2013 23:05:25 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMC004TJWKZP6B0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 06 May 2013 12:05:23 +0900 (KST)
In-reply-to: <3081f2d4913dc74ded32bff2b8a68cd4.squirrel@www.codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: merez@codeaurora.org
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

On Sunday, May 05, 2013 8:23, Merze wrote:
> Hi,
> 
> ufshcd_pci_shutdown (in ufshcd_pci.c) is using ufshcd_hba_stop so it
> cannot be moved to ufshcd.c.
> Sorry for missing it last time I tested, I returned ufshcd_hba_stop to
> ufshcd.h by mistake when I resolved conflicts of the next patch so I
> didn't hit the compilation errors.

Oh, I also missed this. Thank you for informing.
I'll keep ufshcd_hba_stop function in place and
just touch for the patch of "scsi: ufs: wrap the i/o access operations".

Thanks,
Seungwon Jeon
> 
> Thanks,
> Maya
> > Move the ufshcd_hba_stop from header file.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> > Tested-by: Maya Erez <merez@codeaurora.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
> >  drivers/scsi/ufs/ufshcd.h |    9 ---------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index f244812..d932239 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -280,6 +280,15 @@ static inline void ufshcd_hba_start(struct ufs_hba
> > *hba)
> >  }
> >
> >  /**
> > + * ufshcd_hba_stop - Send controller to reset state
> > + * @hba: per adapter instance
> > + */
> > +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> > +{
> > +	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > +}
> > +
> > +/**
> >   * ufshcd_is_hba_active - Get controller state
> >   * @hba: per adapter instance
> >   *
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 336980b..3a1052d 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -208,13 +208,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** ,
> > void __iomem * ,
> >  			unsigned int);
> >  void ufshcd_remove(struct ufs_hba *);
> >
> > -/**
> > - * ufshcd_hba_stop - Send controller to reset state
> > - * @hba: per adapter instance
> > - */
> > -static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> > -{
> > -	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > -}
> > -
> >  #endif /* End of Header */
> > --
> > 1.7.0.4
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> Maya Erez
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

