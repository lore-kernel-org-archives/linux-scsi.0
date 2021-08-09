Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E90CC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 16:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4254160C41
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 16:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhHIQJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 12:09:21 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:39731 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHIQJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 12:09:20 -0400
Received: by mail-pl1-f180.google.com with SMTP id l11so5263635plk.6;
        Mon, 09 Aug 2021 09:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=36IFvq2hJqTtdBeE9dQ+kAyJuaNM0YGuzKVOtVidu4E=;
        b=bEQG9oDpcEtYU0SWatbsusYJStBlSjAwUbaiqRlBOFWp/j4SbT+rus4vomUblHiTlv
         kiI/N2oo6Ay3RkfX4J+VLlWNL2XuHsDDkSk1hTnFDbBzyfPIvxLGW+KinlcRCkT7IFIC
         b9ZzdIQtGhnl4KWa0mH1iBwkGbXU6ItjO5Di2c/c5uyJLQCEbN9RWRfT4JkqjrOulZ5f
         d2U1D7La+mc/WMmhts3b/mLiR4RBYu4N4N6hCXY3HpYHyTUqNbAODHa6jRIUsnf+XZGV
         /7h8t/QfLgmcsYjWTsJoHFNEkbw9bscpcHbl/Tfb02VzAUIeuce1dFbiuJFSDMVhmLld
         iIhA==
X-Gm-Message-State: AOAM531O0erdps8UaVM4jEBk2UU0vDH+P+sxSlhKaKuSDQt/vqGbWHz0
        0PYdVj8RpkUfvKCtYYy6d7s=
X-Google-Smtp-Source: ABdhPJw1iLnr943CFtyXg5yRvu7usWeVKxubZloldJl+nJaBk1xWVi9SQjZ9r8hmLHAa24ZrC5Lisg==
X-Received: by 2002:aa7:800e:0:b029:3a9:e527:c13 with SMTP id j14-20020aa7800e0000b02903a9e5270c13mr19021456pfi.42.1628525339678;
        Mon, 09 Aug 2021 09:08:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:7dd4:e46e:368b:7454? ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id l185sm13254376pfd.62.2021.08.09.09.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 09:08:58 -0700 (PDT)
Subject: Re: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
 <cover.1628231581.git.kwmad.kim@samsung.com>
 <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
 <000601d78cf2$a160f820$e422e860$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <32cc37cd-2f66-0f74-5242-cfcf86f58844@acm.org>
Date:   Mon, 9 Aug 2021 09:08:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000601d78cf2$a160f820$e422e860$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/21 12:46 AM, Kiwoong Kim wrote:
>> How about extending the UFS spec instead of adding a non-standard
>> mechanism in a driver that is otherwise based on a standard?
> 
> It seems to be a great approach but I wonder if extending for the events
> that all the SoC vendors require in the spec is recommendable.
> Because I think there is quite possible that many of those things are 
> originated for architectural reasons.

Has the interrupt mechanism supported by this patch series already been
implemented or is it still possible to change the ASIC design? In the
latter case, I propose the following:
* Drop the new interrupt.
* Instead of raising an interrupt if the UFS controller detects an
inconsistency, report this via a check condition code, e.g. LOGICAL UNIT
NOT READY, HARD RESET REQUIRED (there may be a better choice).

The above approach has the advantage that it does not slow down the UFS
interrupt handler.

Thanks,

Bart.


