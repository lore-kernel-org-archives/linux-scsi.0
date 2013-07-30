From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Tue, 30 Jul 2013 22:02:54 +0900
Message-ID: <002a01ce8d25$1b0e4730$512ad590$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-2-git-send-email-mita@fixstars.com>
 <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com>
 <51F608F4.9020107@codeaurora.org> <51F6493C.3020105@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3G3NC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 09:02:56 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQR001FW2WVO430@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 30 Jul 2013 22:02:55 +0900 (KST)
In-reply-to: <51F6493C.3020105@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Mon, July 29, 2013, Sujit Reddy Thumma wrote:
> On 7/29/2013 11:47 AM, Subhash Jadavani wrote:
> > On 7/26/2013 7:15 PM, Seungwon Jeon wrote:
> >> Fatal error in OCS(overall command status) field indicates
> >> error conditions which is not covered by UFSHCI.
> >> It means that host cannot define the result of command status
> >> and therefore host may need to check transfer response UPIU's
> >> response and status field.
> >> It was actually found that 'CHECK CONDITION' is stored in status
> >> field of UPIU where OCS is 'FATAL ERROR'.
> 
> It looks like you are assuming that there will be some kind of response
> from the device. But the spec. mentions - "OCS_FATAL ERROR: within host
> controller that is not covered by the error conditions described above
> in this table."
Yes, error interrupt doesn't happen actually.

> 
> So spec. left everything to implementers on how to trigger this error.
> Also, it says "within host controller" so ufshcd_is_valid_req_rsp()
> might fail as well.
> 
> I couldn't understand why there is a need for a host controller to
> interpret the SCSI command status and raise an OCS_FATAL_ERROR?
I feel like OCS values are related to syntax problem except OCS_FATAL_ERROR.
Basically, host controller may need to refer the Response field[Target Success/Target Failure] of response UPIU.
It's a overall result from response UPIU. 
When Response field is 'Target Failure', if host controller updates the OCS field with 'SUCCESS', it's not proper behavior.
In this case host may refer the Status field of response UPIU to decide the OCS result.
Of course, it's not clear thing and could depends on host's implementation,
because there is no obvious description for that.
But if we consider the way to report UTP error from UFSHCI 8.2.4,
we can check the Response UPIU for more detailed error condition regardless OCS value.
Could you check your host side?

Thanks,
Seungwon Jeon

> 
> If it is clarified by the spec. then we can have generic implementation
> otherwise I would prefer to make this specific to those host controllers
> that raise OCS_FATAL_ERROR for CHECK_CONDITION.
> 
> >>
> >> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >> ---
> >>   drivers/scsi/ufs/ufshcd.c |    3 +--
> >>   1 files changed, 1 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >> index b743bd6..4cf3a2d 100644
> >> --- a/drivers/scsi/ufs/ufshcd.c
> >> +++ b/drivers/scsi/ufs/ufshcd.c
> >> @@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> >> struct ufshcd_lrb *lrbp)
> >>       switch (ocs) {
> >>       case OCS_SUCCESS:
> >> -
> >> +    case OCS_FATAL_ERROR:
> >>           /* check if the returned transfer response is valid */
> >>           result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> >
> > I don't see the response UPIU data of the last command response is
> > cleared anywhere in the driver. This means its quite possible that if
> > the current command failed (and if it is using the same tag as the last
> > succeeded command) with the OCS_FATAL_ERROR then response UPIU (pointed
> > by lrbp->ucd_rsp_ptr) content may be still the same as the last one. If
> > we ensure to clear the response UPIU data after every command completion
> > then only we can rely on the response  UPIU content in case of fatal
> > errors.
> >
> > Regards,
> > Subhash
> >>           if (result) {
> >> @@ -1229,7 +1229,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> >> struct ufshcd_lrb *lrbp)
> >>       case OCS_MISMATCH_DATA_BUF_SIZE:
> >>       case OCS_MISMATCH_RESP_UPIU_SIZE:
> >>       case OCS_PEER_COMM_FAILURE:
> >> -    case OCS_FATAL_ERROR:
> >>       default:
> >>           result |= DID_ERROR << 16;
> >>           dev_err(hba->dev,
> >
> 
> 
> --
> Regards,
> Sujit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

