Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8ADC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 20:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A549060FE4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFCUOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:14:25 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:46978 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhFCUOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 16:14:24 -0400
Received: by mail-pj1-f44.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso4536165pjb.5;
        Thu, 03 Jun 2021 13:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=szgPeL3ERm4PNP/mSl1tO41AkC982Wgrr8TI/ZTijv0=;
        b=KFCXliSGqXOiakGfRsRJqDe1SgrwjcJFCrutRxPsANzCPjkdnzEWgQH3gpwmYpeHGz
         JhakKdjdDnJ6zC1H9BPfVRNO7LOAVZi5Y/G1vh4e1w8U8QKBcOnaV1OmlZylFbhl1/Rv
         o/G3Rg/+4g3VmgjDexETBAoLa4/4r/GPApoDMN8WtiOPukSjr8TftqnhYDEKv7ogr8PV
         zhEulGoSjsArFAzsRBs0JyF99enLYP1v0xDDVqxZ6/N0Kgp4BYfRkb0OpfRYckDB2tqP
         Cz1jTLAo8oxEPMIo/HikTRW7GkYZVNfesDuvq3iOBKf7il99Y2eES8dtFAM0zqQhwgmJ
         ulOw==
X-Gm-Message-State: AOAM531I5vWvZNJxciRQOdmEsCHiT4zpoAhXsrM/gQQqV5AkfdWX77W/
        Rv3kjPdbAWUjCOCKXdbtw/Q=
X-Google-Smtp-Source: ABdhPJz4lAjognofa1ZFYD/DzdzE1hI2Zc3NKnASr2viuP4aYLg+Nq9cE05XC9QvUspJ/ZPyQLT0EA==
X-Received: by 2002:a17:902:8307:b029:103:c733:e5e0 with SMTP id bd7-20020a1709028307b0290103c733e5e0mr815054plb.8.1622751149192;
        Thu, 03 Jun 2021 13:12:29 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y27sm1204800pff.202.2021.06.03.13.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 13:12:28 -0700 (PDT)
Subject: Re: [PATCH v35 3/4] scsi: ufs: Prepare HPB read for cached sub-region
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
 <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p2>
 <20210524084546epcms2p2c91dc1df482fd593307892825532c6dd@epcms2p2>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <12392bef-e018-8260-5279-16b7b43f5a8f@acm.org>
Date:   Thu, 3 Jun 2021 13:12:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524084546epcms2p2c91dc1df482fd593307892825532c6dd@epcms2p2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:45 AM, Daejun Park wrote:
> +static void
> +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
> +			    u32 lpn, u64 ppn, u8 transfer_len)
> +{
> +	unsigned char *cdb = lrbp->cmd->cmnd;
> +
> +	cdb[0] = UFSHPB_READ;
> +
> +	/* ppn value is stored as big-endian in the host memory */

I think that that comment means that the type of the 'ppn' argument
should be changed from 'u64' into __be64.

> +	memcpy(&cdb[6], &ppn, sizeof(__be64));
> +	cdb[14] = transfer_len;
> +
> +	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
> +}
> +
> +/*
> + * This function will set up HPB read command using host-side L2P map data.
> + * In HPB v1.0, maximum size of HPB read command is 4KB.
> + */
> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
[ ... ]
> +
> +	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);

'transfer_len' has type int and is truncated to type 'u8' when passed as
an argument to ufshpb_set_hpb_read_to_upiu(). Please handle transfer_len
values >= 256 properly.

Thanks,

Bart.
