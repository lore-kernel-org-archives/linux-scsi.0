Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705A5C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 22:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5293860EE2
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 22:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhG1Wsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 18:48:30 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:40460 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhG1Wsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 18:48:30 -0400
Received: by mail-pj1-f52.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so12451575pja.5
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 15:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rOcwvENymP/RkqPz0jceWgeHxUHhE20PBMXmz68EqUQ=;
        b=Zsr0wnFrc375Q9fqBxpW6Ofa0pVe5VHSIrr+QOnbnrLJaGt45evE/97E00RYU1lKBP
         tFyVJueB+qyTYP/U2y/1jQFDtjgGTg1iT7mgDYGSiHCbMdEDjqfIkB+vPrDB1PfZrqdG
         9aA1JChMA4IhwxTuiiNQKbq/qf94rif7/KWSW6bUmjZJTOj8CaOK+plQNHXPxAw1LsYZ
         nM76pV4xNsi7GJxaa7qCJUH6XbinfEQRWCkCqG1sv5UojKvzq0quujJiVjxlKYo9Bvri
         rPzY3Y8b/N2jt/eO49snCE30NLH3hmCm8D+2TPmSUcKpsHEnoDODC14ZahhWoOwufV06
         mpaQ==
X-Gm-Message-State: AOAM533b+9pez4+JFqqByeZiO3WZItoQ9Q3mA2sHKnjhIlFy5k9IP8CN
        ibab8BJK7CTECVSw0IWgUaw=
X-Google-Smtp-Source: ABdhPJywk2/TvxUNxzX02uTidlnsJMndHVeNruP1x+zbQlGIWwFl/m1FQ1nJVS7XgcXPCAt5ieWMiA==
X-Received: by 2002:a17:90a:348f:: with SMTP id p15mr2030672pjb.170.1627512507890;
        Wed, 28 Jul 2021 15:48:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:3328:5f8d:f6e2:85ea])
        by smtp.gmail.com with ESMTPSA id s36sm1050997pfw.131.2021.07.28.15.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 15:48:27 -0700 (PDT)
Subject: Re: [PATCH v3 06/18] scsi: ufs: Remove ufshcd_valid_tag()
To:     daejun7.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210722033439.26550-7-bvanassche@acm.org>
 <20210722033439.26550-1-bvanassche@acm.org>
 <CGME20210722033524epcas2p31e41c1db6883aaa644edf23bbe8a1ca2@epcms2p4>
 <2038148563.21627455482667.JavaMail.epsvc@epcpadp4>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2f95ca58-8f9d-c756-cb08-44c0bbc297aa@acm.org>
Date:   Wed, 28 Jul 2021 15:48:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2038148563.21627455482667.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/21 11:48 PM, Daejun Park wrote:
>> @@ -6979,24 +6966,15 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>>    */
>>   static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   {
>> -        struct Scsi_Host *host;
>> -        struct ufs_hba *hba;
>> +        struct Scsi_Host *host = cmd->device->host;
>> +        struct ufs_hba *hba = shost_priv(host);
>> +        unsigned int tag = cmd->request->tag;
>> +        struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> 
> If tag < 0, lrbp will be assigned incorrect pointer.

That shouldn't hurt since lrbp is only used after it has been verified 
that tag >= 0.

Thanks,

Bart.
