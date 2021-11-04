Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B1FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE7161215
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 23:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhKDXpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 19:45:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43289 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKDXpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 19:45:42 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211104234302epoutp047db9c6024340d32f66173abcfd37253a~0fG9iR0291609416094epoutp04k
        for <linux-scsi@vger.kernel.org>; Thu,  4 Nov 2021 23:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211104234302epoutp047db9c6024340d32f66173abcfd37253a~0fG9iR0291609416094epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636069382;
        bh=vvQIrJapyoEEb8GmlEVCvm7KhaLWg25YRoUT6KjbZK0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=qVfaFYrPciJZpvL/Y112S3nIP8wYoyeX0uFO0ZOymBvCATNbUmpMTvcTSE5SdGRyS
         TnjmmQpDLUHkeksgKcDovWQiJC+HvY7eZZfDv4jud/xLoIi3QTpy7Z/J4Tw7leA1E1
         fPwJfZd+NJ79m5qsjoO7UBpbwrMMw60+5R2Rs8rM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20211104234301epcas3p1678e7456e23e7e1693939e081638a3ef~0fG87AG6X0756707567epcas3p15;
        Thu,  4 Nov 2021 23:43:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4HlgDj5T0Dz4x9QM; Thu,  4 Nov 2021 23:43:01 +0000
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
In-Reply-To: <087fe1fe-173d-50dd-a52e-d794c97648da@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01636069381755.JavaMail.epsvc@epcpadp4>
Date:   Fri, 05 Nov 2021 08:39:57 +0900
X-CMS-MailID: 20211104233957epcms2p1b9022bc74b087eda53d7618493eab805
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211104181111epcas2p2965ba25c905be783c39f098210cc4c61
References: <087fe1fe-173d-50dd-a52e-d794c97648da@acm.org>
        <20211104181059.4129537-1-bvanassche@acm.org>
        <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
        <CGME20211104181111epcas2p2965ba25c905be783c39f098210cc4c61@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 11/4/21 3:39 PM, Daejun Park wrote:
>> I found similar code in the ufshcd_err_handler(). I think the following
>> patch will required to fix another warning.
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index f5ba8f953b87..cce9abc6b879 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6190,6 +6190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>>                  }
>>                  dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
>>                          hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
>> +               hba->lrb[tag].cmd = NULL;
>>          }
>> 
>>          /* Clear pending task management requests */
> 
>Hmm ... since the error handler calls ufshcd_complete_requests(), 
>shouldn't the completion function clear the 'cmd' member? I'm concerned 
>that the above change would break the completion handler.

I missed that the error handler calls ufshcd_complete_requests(). Please
ignore my suggestion.

By the way, I give my reviewed-by tag.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
