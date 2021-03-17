Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8BBC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A9864EB3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhCQRC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:02:27 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:39304 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhCQRCR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:02:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id B0937A1291;
        Wed, 17 Mar 2021 17:02:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pxXI2zaqfTcq; Wed, 17 Mar 2021 17:02:16 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 18ACE9FEF3;
        Wed, 17 Mar 2021 17:02:10 +0000 (UTC)
Received: from [192.168.1.4] (rhapsody.internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 47E643EF3B;
        Wed, 17 Mar 2021 11:02:10 -0600 (MDT)
Subject: Re: [PATCH 4/8] scsi: FlashPoint: Remove unused variable 'TID' from
 'FlashPoint_AbortCCB()'
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210317091125.2910058-1-lee.jones@linaro.org>
 <20210317091125.2910058-5-lee.jones@linaro.org>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <e597f426-bcc0-35d5-220c-104d39c08706@gonehiking.org>
Date:   Wed, 17 Mar 2021 11:02:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210317091125.2910058-5-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 3:11 AM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/scsi/FlashPoint.c: In function ‘FlashPoint_AbortCCB’:
>  drivers/scsi/FlashPoint.c:1618:16: warning: variable ‘TID’ set but not used [-Wunused-but-set-variable]
> 
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/FlashPoint.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> index f479c542e787c..0464e37c806a4 100644
> --- a/drivers/scsi/FlashPoint.c
> +++ b/drivers/scsi/FlashPoint.c
> @@ -1615,7 +1615,6 @@ static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
>  
>  	unsigned char thisCard;
>  	CALL_BK_FN callback;
> -	unsigned char TID;
>  	struct sccb *pSaveSCCB;
>  	struct sccb_mgr_tar_info *currTar_Info;
>  
> @@ -1652,9 +1651,6 @@ static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
>  			}
>  
>  			else {
> -
> -				TID = p_Sccb->TargID;
> -
>  				if (p_Sccb->Sccb_tag) {
>  					MDISABLE_INT(ioport);
>  					if (((struct sccb_card *)pCurrCard)->
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>
