Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A66C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 04:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3564160E78
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 04:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhHLEED (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 00:04:03 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:39442 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHLEEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 00:04:00 -0400
Received: by mail-pj1-f54.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so13117175pjn.4
        for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2021 21:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ttkui8PAAVSrnEmc6lEjSrPmVnacRqrogoezl/Fmu0c=;
        b=KpprPRsbY8vUTXT0haKLr+Lt4H21HX8FbpNZWIlt4948Xs38BWdLo9Gh+s8Mm/cGpx
         X8N0WgD8xyJJdysX0DXxhwAt75H44hNRLDODypT4a+JD+KxGO9x308Mz4RBDltwpzKaw
         1TSkuWc3eFhpmqiVbJ4njnnwIOrzLjahJ4PzFyu6XnL8oXJWXHLS9MnyNz3U6/FRuDGH
         I30fyd0Vxf//6UmtOqSNqvZ3kE8NgOEZ/qzHyk2IZXy1vFFj6xn5DJyABcLq8IllBngx
         D2ecQprdHEDPw0AUlUo9S4AP9VWFh1i6Zuus0DY8TQbbayAOuAZGBnObFpAKHiTwYpyR
         1kHg==
X-Gm-Message-State: AOAM531jTCutcR5gK3FfJdqCx3Qamf6xx7A1C/l2rBbIZ4Xy9BQwijau
        F2Oq3vIYUQIEGhP/C+K5Ka0=
X-Google-Smtp-Source: ABdhPJxb5WHEqZcP6R2btoSDGniELTpA/YCEqxMpgKcdixH1LBO5o/VHloeDU+kjpZ+oLIXoL7QyRg==
X-Received: by 2002:a63:25c7:: with SMTP id l190mr1988792pgl.165.1628741015505;
        Wed, 11 Aug 2021 21:03:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ed0b:eb2c:f73d:99ca? ([2601:647:4000:d7:ed0b:eb2c:f73d:99ca])
        by smtp.gmail.com with ESMTPSA id g2sm1176809pfi.211.2021.08.11.21.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 21:03:34 -0700 (PDT)
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
 <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
 <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4c0d65f6-625d-f9fc-75f0-d63321f65001@acm.org>
Date:   Wed, 11 Aug 2021 21:03:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/21 7:58 PM, Martin K. Petersen wrote:
> Adding a dedicated wrapper would result in the diff below. However,
> after having gone through this exercise, I'm not sure it's worth the
> additional churn...

Hi Martin,

Thanks for having looked to this. I share your opinion: I'm not sure
either it's worth the additional churn.

Thanks,

Bart.
