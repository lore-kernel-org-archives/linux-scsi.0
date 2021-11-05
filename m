Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E00C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 02:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C573610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 02:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhKECUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 22:20:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39169 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhKECUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 22:20:44 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211105021802epoutp032d8d7c1066b84a634bd5ef589f33a4fb~0hOTLVRBu0159601596epoutp03Z
        for <linux-scsi@vger.kernel.org>; Fri,  5 Nov 2021 02:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211105021802epoutp032d8d7c1066b84a634bd5ef589f33a4fb~0hOTLVRBu0159601596epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636078682;
        bh=4oV3JWROumLz3q4h1HtB/aAw1mnfa8x/o5Ll1S2MT3U=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=hlj7fsSWQXKWmwkclxzp9iRvTyutJ8HH0waqq/uiCRMgfFSa2QKDvFgrSeJYMaGnl
         aviaETvGDcBMb1BmqehAYNnYksK58AwxU7jRl7VlpdjtRN3jCwo9jGfDOPMTh8VYVl
         weICiHYBK/MyeEfRDAYfC6tILul4SK/ZaoqrDVUg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20211105021802epcas3p3bd899585043aba94e768a47f232ee04a~0hOSvDg2n1957619576epcas3p3D;
        Fri,  5 Nov 2021 02:18:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4HlkgZ2DPCz4x9QF; Fri,  5 Nov 2021 02:18:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Improve SCSI abort handling
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        VISHAK G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        "huobean@gmail.com" <huobean@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <cb0982d2-1124-a8ee-d129-e2e4975ef1c4@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21636078682214.JavaMail.epsvc@epcpadp4>
Date:   Fri, 05 Nov 2021 10:53:15 +0900
X-CMS-MailID: 20211105015315epcms2p4cb25e9491e0b24a8852aee38408d174d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211104181111epcas2p2965ba25c905be783c39f098210cc4c61
References: <cb0982d2-1124-a8ee-d129-e2e4975ef1c4@acm.org>
        <087fe1fe-173d-50dd-a52e-d794c97648da@acm.org>
        <20211104181059.4129537-1-bvanassche@acm.org>
        <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
        <1891546521.01636069381755.JavaMail.epsvc@epcpadp4>
        <CGME20211104181111epcas2p2965ba25c905be783c39f098210cc4c61@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 11/4/21 4:39 PM, Daejun Park wrote:
>>> On 11/4/21 3:39 PM, Daejun Park wrote:
>>>> I found similar code in the ufshcd_err_handler(). I think the following
>>>> patch will required to fix another warning.
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index f5ba8f953b87..cce9abc6b879 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -6190,6 +6190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>>>>                   }
>>>>                   dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
>>>>                           hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
>>>> +               hba->lrb[tag].cmd = NULL;
>>>>           }
>>>>
>>>>           /* Clear pending task management requests */
>>>
>>> Hmm ... since the error handler calls ufshcd_complete_requests(),
>>> shouldn't the completion function clear the 'cmd' member? I'm concerned
>>> that the above change would break the completion handler.
>> 
>> I missed that the error handler calls ufshcd_complete_requests(). Please
>> ignore my suggestion.
>> 
>> By the way, I give my reviewed-by tag.
>> 
>> Reviewed-by: Daejun Park <daejun7.park@samsung.com>
> 
>Thanks Daejun! However, your question made me wonder whether ufshcd_abort()
>should clear the 'tag' bit from hba->outstanding_reqs. Although the SCSI
>standard requires that a command that is aborted is not completed, the UFSHCI
>specification requires that writing into the UTRLCLR register clears the
>corresponding bit(s) in the UTRLDBR register. I think bit 'tag' will have to
>be cleared from hba->outstanding_reqs to prevent that the aborted request is
>completed while the SCSI core is resubmitting it.

My understanding is the completion of aborted request can be duplicated
because SCSI core will resubmit the request. Therefore the clearing of the 
bit can avoid duplicated completion of the request.

Thanks,
Daejun

