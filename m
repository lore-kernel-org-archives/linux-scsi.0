From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Mon, 29 Jul 2013 19:05:19 +0900
Message-ID: <001901ce8c43$2180a6e0$6481f4a0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-2-git-send-email-mita@fixstars.com>
 <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com>
 <51F608F4.9020107@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46993 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3G2KFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 06:05:21 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQP000FY00MHH30@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 29 Jul 2013 19:05:19 +0900 (KST)
In-reply-to: <51F608F4.9020107@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Mon, July 29, 2013, Subhash Jadavani wrote:
> On 7/26/2013 7:15 PM, Seungwon Jeon wrote:
> > Fatal error in OCS(overall command status) field indicates
> > error conditions which is not covered by UFSHCI.
> > It means that host cannot define the result of command status
> > and therefore host may need to check transfer response UPIU's
> > response and status field.
> > It was actually found that 'CHECK CONDITION' is stored in status
> > field of UPIU where OCS is 'FATAL ERROR'.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufshcd.c |    3 +--
> >   1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b743bd6..4cf3a2d 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >
> >   	switch (ocs) {
> >   	case OCS_SUCCESS:
> > -
> > +	case OCS_FATAL_ERROR:
> >   		/* check if the returned transfer response is valid */
> >   		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> 
> I don't see the response UPIU data of the last command response is
> cleared anywhere in the driver. This means its quite possible that if
> the current command failed (and if it is using the same tag as the last
> succeeded command) with the OCS_FATAL_ERROR then response UPIU (pointed
> by lrbp->ucd_rsp_ptr) content may be still the same as the last one. If
> we ensure to clear the response UPIU data after every command completion
> then only we can rely on the response  UPIU content in case of fatal errors.
Response data of 'ucd_rsp_ptr' will be updated by UFS device if response UPIU is completed.
There is nowhere driver clears 'ucd_rsp_ptr', though.
But if it's really needed, it can be another patch?

Thanks,
Seungwon Jeon

