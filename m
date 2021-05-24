Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9497C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC116100A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhEXBZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 21:25:47 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36462 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhEXBZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 21:25:47 -0400
Received: by mail-pf1-f180.google.com with SMTP id c12so7918147pfl.3;
        Sun, 23 May 2021 18:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=846OUuZQkLpeNUjXFbRAPUYHOWnoHhJDvnKplijG+Ac=;
        b=Wr8g4byQ2QA6oSoQz6VYrzO0bGqaOpAMuJDBxqsXoZOXLEoateurh9Y2EB4A4OFpGb
         3MYsbRp5cJn817iHHqw9aezkZuhpifWfQxXUVMh+7GGhzURfNakP8GVYqwUCYokryuAW
         v72Yb2/devoU3oNFMXZwUIx1p6b5hGOcPovBhcSxaDpfWdSBzhtEsQ2PbXiK3n0nUFgp
         OzpvcRSA0TcMtIN1M/W6jOI8ztcr5LBn/wipcXL39If+3ptRV1zTkLM9ZRP4utmQZbCb
         IUKRftfil1OCtHUtYRjYojOU695wCFpx4FPa/ErU5qrAbaIMeBGwLHoKvpQ5W2bi3PjR
         hLsQ==
X-Gm-Message-State: AOAM531VLWma+WMISMubyl+zgbaYwdCSj/WrcOR0ukRPcbbrdolzv8Sw
        TOWDBx1KjWU9JROY2pkGX/zkbJjLAiA=
X-Google-Smtp-Source: ABdhPJxIdlPArrEqTac8ea9DVMcycNf90KDw5YDPsrbuoHodNHLWwXuteKj4xfmZi2r7xi487D+moA==
X-Received: by 2002:a62:1b97:0:b029:24e:44e9:a8c1 with SMTP id b145-20020a621b970000b029024e44e9a8c1mr22020434pfb.19.1621819458407;
        Sun, 23 May 2021 18:24:18 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t1sm9900814pgq.47.2021.05.23.18.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 18:24:17 -0700 (PDT)
Subject: Re: [PATCH v1 1/3] scsi: ufs: Let UPIU completion trace print RSP
 UPIU
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210523211409.210304-1-huobean@gmail.com>
 <20210523211409.210304-2-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <628c0050-e3e2-033c-8a25-6fc04d4d5657@acm.org>
Date:   Sun, 23 May 2021 18:24:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210523211409.210304-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 2:14 PM, Bean Huo wrote:
> +		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;

So a pointer to a response (hba->lrb[tag].ucd_rsp_ptr) is cast to a
pointer to a request (struct utp_upiu_req *)? That seems really odd to
me. Please explain.

Bart.
