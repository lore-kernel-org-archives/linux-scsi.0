Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FFCC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jan 2022 21:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbiAWVDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jan 2022 16:03:00 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:34721 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240098AbiAWVDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2022 16:03:00 -0500
Received: by mail-pl1-f174.google.com with SMTP id l17so7476051plg.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2022 13:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=khD+AXGrp6/T8DJe1/NemytIh9G5AL7RmCdnHa1/TKg=;
        b=fdf9jS3iM1MF1TII+CeavsWstf4xV2bXbxy/piJq9MLha0+IJSr1pKnurAPJmo+nlD
         983JGp1cM7HngkFlGjbroRcoA+TSPx7rwWpB8laF4PF1E21hqi0A1b4muC6vOrs3+BHr
         eLaOKXVWb3ENBj1ADWr1VIKXVmaXhvo1xWY5/H/lqlbBYZBEuqw8Q1DtKdBKIK68ugfe
         HQWvOO47xlxSNp5exjYFdUxZXmt2QM2cZbry7c4VhKD9HZvDCNjUpUczsO7mEi8X/eRW
         AY6Cluw6JxclAnMORYpxHk5CaBP6Hh+ztfxxnj3/XQYJMwlb5S/LjpmXI6oNgF5C/k8r
         +SKQ==
X-Gm-Message-State: AOAM5306zpLnXKfjaCVRCQtAnt4heEP+XSfeeKOIJHmPrP3ySpPbRZBX
        9Hp+53fBzBrb6NoB7zAcV/w4/duxzLRqJg==
X-Google-Smtp-Source: ABdhPJwi2a6YZ/iS6fDTnV0DKeQ3NZfqYTDtQIm2YRsWWf8aUqtNGkRRk5cy7KP+U/68ZPODlHXhQQ==
X-Received: by 2002:a17:90a:5417:: with SMTP id z23mr10224337pjh.158.1642971779359;
        Sun, 23 Jan 2022 13:02:59 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id kx11sm10368729pjb.1.2022.01.23.13.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 13:02:58 -0800 (PST)
Message-ID: <5c075996-4d08-5296-510d-310b952e5eac@acm.org>
Date:   Sun, 23 Jan 2022 13:02:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: print actual pointer addresses if using scsi debug
 logging
Content-Language: en-US
To:     John Pittman <jpittman@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, dgilbert <dgilbert@interlog.com>,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        linux-scsi@vger.kernel.org
References: <20220121164938.18190-1-jpittman@redhat.com>
 <b4faa458-5f0c-cc19-05f4-22305b4942d1@linux.ibm.com>
 <CA+RJvhzVLXGLE0SDYO8mEYR4GEXwPJNkzbVJCJF2KcV3td+vAQ@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CA+RJvhzVLXGLE0SDYO8mEYR4GEXwPJNkzbVJCJF2KcV3td+vAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/21/22 11:17, John Pittman wrote:
> Thanks for looking Steffen.  I failed to notice the no_hash_pointers
> option.  I do think it would be a reasonable convenience for debug
> scsi logging to print the actual address without having to go through
> the trouble of rebooting enabling the no_hash_pointers parameter then
> rebooting again to disable afterward.  Perhaps the system is a
> production box that can't be rebooted. Maybe an additional sysctl to
> enable no_hash_pointers would be reasonable?  That way it could be
> changed online?  Thanks again.

Are SCSI command pointers really useful to anyone? How about modifying 
the debug statements such that the SCSI command tags are reported 
instead of the SCSI command pointers? There is a 1:1 correspondence 
between the values returned by blk_mq_unique_tag() and the SCSI command 
pointers.

Bart.
