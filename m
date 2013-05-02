From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 2/5] scsi: ufs: wrap the i/o access operations
Date: Thu, 02 May 2013 16:00:13 +0900
Message-ID: <002b01ce4702$b1a01c50$14e054f0$%jun@samsung.com>
References: <002001ce4105$afbcf000$0f36d000$%jun@samsung.com>
 <5178B5C9.90000@codeaurora.org>
 <000b01ce423b$d626e520$8274af60$%jun@samsung.com>
 <517FA9AA.1060101@codeaurora.org>
 <a3807486896956a4775acf473ddc7423.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:10723 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3EBHAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 03:00:15 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM500ACFSSADC70@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 02 May 2013 16:00:14 +0900 (KST)
In-reply-to: <a3807486896956a4775acf473ddc7423.squirrel@www.codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: merez@codeaurora.org, 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

On Wednesday, May 01, 2013, merez wrote:
> Tested-by: Maya Erez <merez@codeaurora.org>
> 
> I also tend to agree with Sujit on the order of the wrappers parameters.
Okay, I'll take the views of all(Sujit, Subhash and you)

Thanks,
Seungwon Jeon
> 
> Thanks,
> Maya
> 
> > On 4/26/2013 10:36 AM, Seungwon Jeon wrote:
> >> Hi,
> >>
> >> On Thursday, April 25, 2013, Sujit Reddy Thumma wrote:
> >>> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> >>>> Simplify operations with hiding mmio_base.
> >>>>
> >>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >>>> ---
> >>>>    drivers/scsi/ufs/ufshcd.c |  106
> >>>> +++++++++++++++++++--------------------------
> >>>>    drivers/scsi/ufs/ufshcd.h |    5 ++
> >>>>    2 files changed, 49 insertions(+), 62 deletions(-)
> >>>>
> >>>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> >>>> index 1680394..6728450 100644
> >>>> --- a/drivers/scsi/ufs/ufshcd.h
> >>>> +++ b/drivers/scsi/ufs/ufshcd.h
> >>>> @@ -190,4 +190,9 @@ int ufshcd_init(struct device *, struct ufs_hba **
> >>>> , void __iomem * ,
> >>>>    			unsigned int);
> >>>>    void ufshcd_remove(struct ufs_hba *);
> >>>>
> >>>> +#define ufshcd_writel(hba, reg, val)	\
> >>> Let this be consistent with writel() arguments - "val" as second arg
> >>> and
> >>> "reg" as third?
> >> You got a point there.
> >> When considering an array of arguments in two functions and value part
> >> can be some long expression,
> >> I think it seems more coherent.
> >> 	ufshcd_readl(hba, reg);
> >> 	ufshcd_writel(hba, reg, val);
> >> How about keeping these?
> >
> > I somehow tend to agree with what Sujit suggested. Its good to be
> > consitent with writel() for better code readability.
> >
> >>
> >> Thanks,
> >> Seungwon Jeon
> >>
> >>>> +	writel((val), (hba)->mmio_base + (reg))
> >>>> +#define ufshcd_readl(hba, reg)	\
> >>>> +	readl((hba)->mmio_base + (reg))
> >>>> +
> >>>>    #endif /* End of Header */
> >>>>
> >>> --
> >>> Regards,
> >>> Sujit
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> >>> in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

