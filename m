Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AD2CA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 15:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C953208E3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 15:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389906AbfJ2PPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 11:15:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37528 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389841AbfJ2PPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 11:15:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so9812056pgi.4;
        Tue, 29 Oct 2019 08:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BpdmLBrAF6vIWkMIKjmn2Nztml/ALZp4Q1mNNsAX6zA=;
        b=FBsBZ4/PgKstuD1cHzrx6zoEP5CihEbcCLMklC6ghK9nhCqT3mvifXe6kDyT4U4dAa
         /QHluUsOMOCxQJqj/hgPPHvOPSLQE3VAraEJ97ArqqO+fRitOt1ahmLoTJ4ucEoLJujm
         HJSJzRGIXOQ4EQVevIiH8r75DGjdjT+jkEWa+wGui3Ht0ynnrooj2DSpvndmv96fUPOH
         T+UEL5GclguyhzK4faFjhnP5YzJIEcogvNn6T55G3LIa3PflLJwMy1vTRMpUrvBZX0SY
         5f82WL+VD4sqd2DIKNO26aY1eIEoy6724VeuCE2V4p6MXn5ehInwSY3FLpKa+dQlbsHw
         8COw==
X-Gm-Message-State: APjAAAUHKSCduG9EfkVTlsKC0T7vxRB/wWcYJePkueZiE/WAeE4i2iYz
        g9jgNCK1h6Fk9G29fMhAzHc=
X-Google-Smtp-Source: APXvYqyQhKFHzk7jdh70TLLVp4Cwd9bRfe/8VfkXsoeqpWNgAlOI0jsF0Xy+1MCAqUR+aa0JrHEGHg==
X-Received: by 2002:a63:cf45:: with SMTP id b5mr27606615pgj.36.1572362098980;
        Tue, 29 Oct 2019 08:14:58 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s23sm13708158pgh.21.2019.10.29.08.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 08:14:58 -0700 (PDT)
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
 <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
 <BYAPR04MB5816FF25422E60C168F78308E7610@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7b3cad63-3c0d-0bff-b400-acf85344bfee@acm.org>
Date:   Tue, 29 Oct 2019 08:14:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816FF25422E60C168F78308E7610@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/19 1:17 AM, Damien Le Moal wrote:
> So I think changing the interface to unsigned int makes sense in that
> context. Also, unless I am reading this wrong, the above definition you
> quote always lead to resid >= 0, so I do not see what problem you are
> worried about. Could you elaborate your concerns please ?

Hi Damien,

SCSI LLDs handle residual overflow in at least two different ways. I 
think the iSCSI initiator handles this by reporting the DID_BAD_TARGET 
error code. In the tcm_loop driver I found the following, which I think 
is incorrect:

	set_host_byte(sc, DID_OK);
	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
		scsi_set_resid(sc, se_cmd->residual_count);

Seeing this made me wonder what the best approach is for a SCSI LLD to 
report a residual overflow?

Thanks,

Bart.
