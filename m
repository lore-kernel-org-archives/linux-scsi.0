Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E357C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB969613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhDVQL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:11:28 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:33319 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVQL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:11:27 -0400
Received: by mail-pj1-f50.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso2964149pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Apr 2021 09:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IB6bkA32vaHfGZjXyw6usl6S1f4ACEW5nGRJtJeYzr8=;
        b=oo+n1ke/YKjiVFUcUQKXTcgA1IpW07YPh4rb8VnplBfEhBETaDWW/uxiwbfwUxFkV4
         +Vsa+iTu+Gsv6MXktmcLRyM40omkVlmjZoevh0ggemoZhN2YWuzAiy2FQ7iNnYy4892T
         AB4IKLRd8425uO8ageyDphMX0rH/HFhhNqBbfhncCyUEv2wFxukTwM5dOuXPlnWVrdHW
         29y7OPpZeeJKBXdWimdod4xN5pPHAb/4rxvmg54E/RiQ3fT9BJRZwq9nTSz8A9sN/Iu8
         MOfC5R9RRi+BWlBov38VJ9cfBHofv6uUhPEH/osogATarG0A1JaoRK5Ycqssv0Kzz1yk
         hl7Q==
X-Gm-Message-State: AOAM5327M8wf39VVbJESvWJpKyaNXpjHvPouhXRSdgckSXgQdaG7kYC7
        5WCquI+T28voAxLRE4cYJ8/r7QCFTWM=
X-Google-Smtp-Source: ABdhPJw6KrKupxvEpvmuv7PScH8xr+kjfoF5K9k/c+ap1S1h7v4sGpA1Reelye2N84+CAW+dAggtDg==
X-Received: by 2002:a17:902:d4c6:b029:ec:881b:fdfb with SMTP id o6-20020a170902d4c6b02900ec881bfdfbmr4411802plg.83.1619107850732;
        Thu, 22 Apr 2021 09:10:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ca3e:c761:2ef0:61cd? ([2601:647:4000:d7:ca3e:c761:2ef0:61cd])
        by smtp.gmail.com with ESMTPSA id a74sm2629682pfa.16.2021.04.22.09.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:10:50 -0700 (PDT)
Subject: Re: [PATCH 15/42] NCR5380: use SCSI result accessors
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-16-hare@suse.de>
 <75df2cf5-ea29-ea54-f8d3-0f44a845409f@acm.org>
 <d0be206b-6666-d1cd-e0fd-bf2a1b491196@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <35e82f21-1480-fc88-3575-d21601678167@acm.org>
Date:   Thu, 22 Apr 2021 09:10:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <d0be206b-6666-d1cd-e0fd-bf2a1b491196@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 11:37 PM, Hannes Reinecke wrote:
> On 4/21/21 11:11 PM, Bart Van Assche wrote:
>> Do all SCSI devices from the nineties report SCSI status values with
>> the lower bit set to 0? If so, can the status_byte() macro be removed
>> entirely?
>>
> As indicated in the previous reply, yes, that is the plan (removing the
> status_byte() macro). And the drivers will have to report SCSI status
> values with the lower bit cleared, otherwise the linux SCSI status codes
> would never have worked in the first place.

Please elaborate the above further. My understanding is that SCSI-2
defines bits 0, 6 and 7 of the status byte as reserved while SAM-2
specifies that these bits must be zero for the status codes that also
have been defined in SCSI-2. Is it safe to assume that all SCSI-2
devices set the reserved bits to zero?

Thanks,

Bart.
