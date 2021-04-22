Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BEBC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4406261409
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhDVQxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:53:33 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:35384 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbhDVQxd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:53:33 -0400
Received: by mail-pj1-f49.google.com with SMTP id j14-20020a17090a694eb0290152d92c205dso1313440pjm.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Apr 2021 09:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ikfBBwCsJMwk0NrZWR6BYuWS0vrc+qaG+lC8ZfVEnyY=;
        b=J797x/7Mt8h5Mm8Xke1M36BAMqDt8guz89+7N3gRKpeHUGGI5v5SMdG1UEiN6sEWx/
         CPDzSy9zKBjW9zj4dH6UjWM0Hx+Wkq7dXWr4KfTWknrDhITj8m/Nq7gllYmutgg51nJA
         rhOFJrn1I9UYSyYYWRyomQMiONFDmfRh9003HVAWdlsxpgSoVu5H8oBwxVD7CYVDT7lx
         oodwVEeFFQhYspAuGvjagAKHD5xPLcZLCq8YA0hWfJS1qb1nMOJeepbctk7++fAl0KZe
         QraZix7xW4c4F9oSkC3uyM21g7VS2OahwRaTDAE6+3E+kKPzR4uUZGotyVaw/hiojHq2
         MkWg==
X-Gm-Message-State: AOAM530j2F4tCZcnuw1TYfTuBikFX1glXLBYZ1djKXOYKB0uFuTHn9eX
        CELKRmSWSqLUtbOzyJT6mpkJnlX/kZU=
X-Google-Smtp-Source: ABdhPJxLNyAq3JdSJZvXsE1rItGjX73kkqEAF3MOHsi2t8fLTpYFIkEhDXsItbKPOoO/43uUX+Wjcw==
X-Received: by 2002:a17:90a:bb85:: with SMTP id v5mr5047511pjr.106.1619110377853;
        Thu, 22 Apr 2021 09:52:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ca3e:c761:2ef0:61cd? ([2601:647:4000:d7:ca3e:c761:2ef0:61cd])
        by smtp.gmail.com with ESMTPSA id h9sm2488947pfv.14.2021.04.22.09.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:52:57 -0700 (PDT)
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
To:     dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-15-hare@suse.de>
 <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org>
 <51b16b13-d4e3-f0e4-718e-357d04ed958f@interlog.com>
 <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
 <db827915-84e0-1aea-7b30-a01a22059817@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <62237423-f4f9-a426-43b5-3ff56a5dca1a@acm.org>
Date:   Thu, 22 Apr 2021 09:52:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <db827915-84e0-1aea-7b30-a01a22059817@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 8:56 AM, Douglas Gilbert wrote:
> In driver manuals Seagate often list the PRE-FETCH command as optional. As
> in: pay us some extra money and we will put it in. That suggests to me some
> big OEM likes PRE-FETCH. Where I found it supported in WDC manuals, they
> didn't support the IMMED bit which sort of defeats the purpose of it IMO.

Since the sd driver does not submit the PRE-FETCH command, how about
moving support for CONDITION MET into the sg code and treating CONDITION
MET as an error inside the sd, sr and st drivers? I think that would
allow to simplify scsi_status_is_good(). The current definition of that
function is as follows:

static inline int scsi_status_is_good(int status)
{
	/*
	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
	 * significant in SCSI-3.  For now, we follow the SCSI-2
	 * behaviour and ignore reserved bits.
	 */
	status &= 0xfe;
	return ((status == SAM_STAT_GOOD) ||
		(status == SAM_STAT_CONDITION_MET) ||
		/* Next two "intermediate" statuses are obsolete in*/
		/* SAM-4 */
		(status == SAM_STAT_INTERMEDIATE) ||
		(status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
		/* FIXME: this is obsolete in SAM-3 */
		(status == SAM_STAT_COMMAND_TERMINATED));
}

Thanks,

Bart.
