Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA45C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5607F60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhHNDMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 23:12:25 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:33677 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhHNDLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 23:11:35 -0400
Received: by mail-pj1-f47.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so12667844pje.0;
        Fri, 13 Aug 2021 20:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kfw00GVSdXBrainH+8NLVWPIBE8UHBhusGRtecxsNW8=;
        b=NOpX+F2TSnAQm01Um3rEsledzVFOSlooPSpBAsuf1S9QGbKjNFGU/H5LbiffqseD5y
         k2OzkmDdlbQWYRTonCOWLHLY7FGpZ1Jhhpy/fkwnOa8t/hrBSx12IzlePxXPCVsLnHKO
         Gnn7Ym0VgcpF3xfqBaEudfWOvvNf1f36rgqbdyIC1K5dIxqdqGlbvEpS/j/SW/PugU1/
         VC10fk2U2GvsL/AvFWL9D3/gJnu96eXLWTfMEpt6HugX/Xl4ZC3BobR+IpTl1GYKmzAt
         LaP1wF5zfZwi+C9KMh4ydUPWYjB6bPEBWKxlcvj5ws+SgPL5IQBe1cVjJwP6MhFD9W9l
         o/Aw==
X-Gm-Message-State: AOAM531x0TbXg++RJdKbJtz8u3J2nI9M0s+5lhhDeCPtcqUKAFUGAL37
        YaAo6qjmaJWHA7dNKYM9lUU=
X-Google-Smtp-Source: ABdhPJzBnGMsNfkmATpcS03dWromZISUWQLcHJzsoceBKegeUMtNRMAqPView/sRR6b65xHN6vDZPg==
X-Received: by 2002:a65:40c4:: with SMTP id u4mr5122562pgp.186.1628910667212;
        Fri, 13 Aug 2021 20:11:07 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:55d6:7aa0:a6ad:d964? ([2601:647:4000:d7:55d6:7aa0:a6ad:d964])
        by smtp.gmail.com with ESMTPSA id w2sm3023744pjq.5.2021.08.13.20.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 20:11:06 -0700 (PDT)
Subject: Re: [PATCH 1/3] scsi: wd719: Stop using scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de, hch@lst.de
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-2-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2fdb9ef3-fb2d-e8bc-4489-cb0c332398ae@acm.org>
Date:   Fri, 13 Aug 2021 20:11:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628862553-179450-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/21 6:49 AM, John Garry wrote:
> -	action = /*cmd->tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;
> +	action = /*tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;

If this patch series would be reposted, please remove the commented-out
code instead of modifying it. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
