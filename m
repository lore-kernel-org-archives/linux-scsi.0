Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BBAC3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 20:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B30522CED
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 20:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Q+1hk21R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbfIDUWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 16:22:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39063 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbfIDUWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 16:22:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so38826pgi.6
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2019 13:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xVOtfa4FemHiS/Yp7atJtq7Zy87lPl7zBOB4z9A7MuY=;
        b=Q+1hk21RFb1tZ0ePhKaz0FBP+F7xrChbtOjP47j0INYk22MckIk8FAVmUdnlduNLiY
         vJUGbBajYhb8/8theSGrC63KxTjXhJjvmsEpUPvgpupBO36l5uZMwaw87S+8NHl54zZQ
         Wq0wbDhaLvHhiTG6g1xXdzZAwbvn8n9Iph63c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xVOtfa4FemHiS/Yp7atJtq7Zy87lPl7zBOB4z9A7MuY=;
        b=eelWrp3iAv9apGHWOYcL9QHZUzcCp8oiIp242s+NdKaZQ1cbj2dc6p1pQk/nD3mNP9
         WGCsNiFQyhD7yIJNmAekwgA+r5+if6+hp4UFT3fLlEs3iQcMBMFp3ObcY5eq6okBf5Ac
         RfbcfB5OQHSYHJRrv6q++f8Cq4jdhUnTaSczSWjsXg90gTqBSeUP1SuZw3eeYMbtpzgP
         Cl2agu0e/e0sfn+2kxFbnAQMSwrTwV6lDOxFqDlYkYrGOBfy1o1s1C/nsZqsMRdz1bp7
         xjArJbI9sswYmXoHkLXIoI/L4MTOlmEgemvyiRC0u8bbQVm0brioxXWQ7k2zK7iXDSEN
         /caQ==
X-Gm-Message-State: APjAAAW++H7w1d/lQa0na6lzSecFB1E+emNCbclIs2OmuKAtHQCjGL8K
        MXWazl4fxekJUfa2OXax4MZetg==
X-Google-Smtp-Source: APXvYqwBzTEtSdnbNv4cKtzyBFFJzW885bb0y8aCjJz1dx+RCqXH5zFiSZ/xW+rVes78ygzURGS+fA==
X-Received: by 2002:a63:3ec7:: with SMTP id l190mr4031pga.334.1567628549777;
        Wed, 04 Sep 2019 13:22:29 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d20sm30053798pfq.88.2019.09.04.13.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 13:22:29 -0700 (PDT)
Subject: Re: [PATCH 1/1] scsi: lpfc: Convert existing %pf users to %ps
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        rafael@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
References: <20190904160423.3865-1-sakari.ailus@linux.intel.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <2899e50b-2984-c546-2d3e-450908eada88@broadcom.com>
Date:   Wed, 4 Sep 2019 13:22:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904160423.3865-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/2019 9:04 AM, Sakari Ailus wrote:
> Convert the remaining %pf users to %ps to prepare for the removal of the
> old %pf conversion specifier support.
>
> Fixes: 323506644972 ("scsi: lpfc: Migrate to %px and %pf in kernel print calls")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
>   drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
>

Reviewed by: James Smart <james.smart@broadcom.com>

-- james


