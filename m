Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5B9C33C9E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A002067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c8fdERrT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAIBFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:05:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46847 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgAIBFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:05:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so5446269wrl.13
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 17:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fb5H5gwJSDD3CTCXaikaG+SZK4yp6FZFPV85mtJUNW8=;
        b=c8fdERrTm0V3smao2VFAT0wAmQcaCX22ckpS1iVEV0BHgKaFLCK9ZrFthogpGfLGSl
         7Tk5aMhkgRAQYqim3BaEjLQJt9f4a3GR7qcoMm493Oq4BA4KFuzLFyGy+SFlGU2DUHrd
         uqHItu/Uff9DT0L6y0eJF39/aV7O986n1DfjkIx0SmivwKogC1RWyBQYFZKcf5z4cScI
         0t2NvxAgSTHfaDW7nYzul+A7R1SeOvLwgPHiwF/buKp1kZsadsOFGwCM8G4u0wJr9xKn
         /yVH/7E+xA1sq39ZksvUgwkx4M1lMlp81HEB7/3q/sbJziVrZHD/wF7vkzak8rKFHuQx
         wNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fb5H5gwJSDD3CTCXaikaG+SZK4yp6FZFPV85mtJUNW8=;
        b=JypNWKPTh3LkL8eaC1QRRqYz+qHTDqmMNJGJfNXSD29UdS3IopyMTFtqC4xzn1BbPh
         I/88RQ/p66FeZYiXF6gWO7obKZPq3iL+PeDvI0HzOnFM6+l2B5g0KSlWSXPhIFq/jgkK
         rsBUzPunOILxKuZCm7O6H5wRlxcSzM+f22qcVXUKF+lL9bV6GjDl/tbmTyIaTE8Y4z7J
         HFS9IYxav2Id9Nc2gYakl5Vv5XxKMswETtDC/igrALoGivCtBePvy9A3Ee6qf+DyHYP4
         fTXK9ORrYvaVhRPNLFMV0+PLvrux2v5rMz5sv4nHGjsGop2daIGetUApzZtmmbhuYDDw
         DM7g==
X-Gm-Message-State: APjAAAWGxelWNkDeHxiiwKLdAIRlhzIooXZSoBf3W+FM8nby9F9iXlt3
        x1bC4osqkRwHBBJAFPwYlMU=
X-Google-Smtp-Source: APXvYqz2m+MNbLxx9O1jK2vjEcgjk3TFIS9TAnSBql9nsWSTmNl18GyMCR2Mk8T/NT9VIG1ezyJAcg==
X-Received: by 2002:adf:f80b:: with SMTP id s11mr7231406wrp.12.1578531901877;
        Wed, 08 Jan 2020 17:05:01 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x14sm924737wmj.42.2020.01.08.17.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 17:05:01 -0800 (PST)
Subject: Re: [PATCH v2 05/32] elx: libefc_sli: Populate and post different
 WQEs
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-6-jsmart2021@gmail.com>
 <e643b215-133b-5740-9e41-9f59129d6ac4@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <e6aa2ea7-53d2-935b-2c95-43b1ba231565@gmail.com>
Date:   Wed, 8 Jan 2020 17:04:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <e643b215-133b-5740-9e41-9f59129d6ac4@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/2020 11:54 PM, Hannes Reinecke wrote:
> You seem to have given up using EFC_SUCCESS / EFC_FAIL for the next few
> functions.
> Please be consistent here.
> 
> Cheers,
> 
> Hannes
> 

We will covert over to EFC_xxx status's

Thanks

-- james
