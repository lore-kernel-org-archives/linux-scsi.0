From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 1/5] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Thu, 02 May 2013 22:37:23 +0900
Message-ID: <003a01ce473a$2d3c12b0$87b43810$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <CALMYJDteQFvFcW3E8pXKLTigqj42fd=dwfdknE3SiG6zH9zMJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:8482 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3EBNhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 09:37:25 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM6003P2B6BTGT0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 02 May 2013 22:37:23 +0900 (KST)
In-reply-to: <CALMYJDteQFvFcW3E8pXKLTigqj42fd=dwfdknE3SiG6zH9zMJQ@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Santosh Y' <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Thursday, May 02, 2013, Santosh Y wrote:
> On Wed, Apr 24, 2013 at 9:36 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Move the ufshcd_hba_stop from header file.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
> >  drivers/scsi/ufs/ufshcd.h |    9 ---------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 60fd40c..41b9639 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -285,6 +285,15 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
> >  }
> >
> >  /**
> > + * ufshcd_hba_stop - Send controller to reset state
> > + * @hba: per adapter instance
> > + */
> > +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> > +{
> > +       writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > +}
> > +
> > +/**
> >   * ufshcd_is_hba_active - Get controller state
> >   * @hba: per adapter instance
> >   *
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 6b99a42..1680394 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -190,13 +190,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
> >                         unsigned int);
> >  void ufshcd_remove(struct ufs_hba *);
> >
> > -/**
> > - * ufshcd_hba_stop - Send controller to reset state
> > - * @hba: per adapter instance
> > - */
> > -static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> > -{
> > -       writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > -}
> > -
> >  #endif /* End of Header */
> > --
> > 1.7.0.4
> >
> >
> 
> The patch doesn't apply due to the character set.
> 
> "fatal: cannot convert from ks_c_5601-1987 to UTF-8"
Oh, I didn't see the problem.
I'll check more for resend.

Thanks,
Seungwon Jeon
> 
> 
> --
> ~Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

