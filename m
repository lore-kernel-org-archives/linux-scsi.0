Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631D6C4743C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4886161107
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhFURdf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:33:35 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:37600 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhFURda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 13:33:30 -0400
Received: by mail-pl1-f180.google.com with SMTP id y21so3106463plb.4
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 10:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b02Xzj/uN5iyWI7dXW/EOPm2KeItv36+1pgBaZ9RfnA=;
        b=ks2OZbjCFDnGYbRKy1JggyG51DH2bI4S+e20BeQx+U8WFzDVJAjjyI4vl3Wa1XAca8
         41EEIv+UqtdZB3eEP7oHjPU/cyblbtChVQqqlq/JayhKuKTmGFLLSM0Ll9ypUJORRhgo
         BsgWUSeMeHm10QlUCzJOeXaTGNS3uC8Q8zkZgkpK50BA6jijuq7M+Rnb2BSedEZ40Ore
         jFLF0V51zaFcpFwhHI0a+/D3aEpTfSle+n70BgjkiYNAMcjJ0luSoXyB7WHshG4fFq8h
         8GW+y2MO8rSuryhf9fDRL8nVaP0c+hc3danZVmlV1GyOUCa65OQueb7Zd2GuoZvgQvvl
         LsFg==
X-Gm-Message-State: AOAM532Rj5uEjHIhYcvQQoD30t3oFqy3ko3/4RbbqZNNvew4f2Cdr8gn
        R1bhoxsvEuxQm0hCupu2FHs=
X-Google-Smtp-Source: ABdhPJw/YP5C2jmjzjaNPmboPi6KZMTb930M5+QqXednchPwd/ishmQjkWN/nREq2oCKFrcAvzRVsQ==
X-Received: by 2002:a17:90b:78e:: with SMTP id l14mr28892062pjz.110.1624296673780;
        Mon, 21 Jun 2021 10:31:13 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s4sm15871191pju.17.2021.06.21.10.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 10:31:12 -0700 (PDT)
Subject: Re: [PATCH RFC 2/4] ufs: Remove a check from ufshcd_queuecommand()
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-3-bvanassche@acm.org>
 <DM6PR04MB6575D553EA3E6938FEAC0F9DFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <49e38c5d-e333-5e19-e89c-5b9fca087fac@acm.org>
Date:   Mon, 21 Jun 2021 10:31:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575D553EA3E6938FEAC0F9DFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/21/21 1:22 AM, Avri Altman wrote:
> While at it, maybe remove ufshcd_valid_tag altogether?

I Will do that.

Thanks,

Bart.
