Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DA0C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 04:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiBZEx3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 23:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBZEx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 23:53:28 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8A4A1BD7
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 20:52:55 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so5741498pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 20:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oXonBgwDU2ySMn/NyEvYsbjr/oR2n5SBkKJFlank37c=;
        b=uBFUQxBTR0qI9eu/jEUmBIo9lgmmoYl1UHhEQO2h57BI0OIigTQ5T1mUl5GjH68Vid
         Hm3iwF48AJNtfSQR6jt3UT3nXYXXRMWVIFFfXx/NWkXvmYZ9fCcbqpRuYW5QqJ61+gfB
         mO0VrB/Xn4JZmhv8XcqKdKnRkoZ6sBXrdGH89uskctt7JA4Dz4TMWqf9vkvKfTF/dCDD
         RnDyCDT+6b+FE20RUKatAVVqPXPW4c7DbjlW4ZtPY+kVC1pGE76GEcnDIFkpogmOPe2V
         D4RovBMv/OOsHmMrfW84jtgD8C6vj37LeWWJvAYYmGtFyjuAeQma92ohnwjx63CxZ4nv
         4dCQ==
X-Gm-Message-State: AOAM531JsTy0EbDjE1rXuCf6hR6D92eEiPd3AlCExGcIMsr5qCk2YfUo
        DfjOkoBq6G2kYJe+Y8+CBF4=
X-Google-Smtp-Source: ABdhPJxwTT7YAcFaT7ImtmBpjyzb3rEKQ5qkorofZBDtvFZR1tNDoLc0K2n/P6LRqgr5S/H/3xKATg==
X-Received: by 2002:a17:90a:e286:b0:1bc:2e7d:93f4 with SMTP id d6-20020a17090ae28600b001bc2e7d93f4mr6387041pjz.217.1645851174485;
        Fri, 25 Feb 2022 20:52:54 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z14-20020aa7888e000000b004e5c2c0b9dcsm5171836pfe.30.2022.02.25.20.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 20:52:53 -0800 (PST)
Message-ID: <f5f6be34-56c8-7792-8c54-d3b9ec62b204@acm.org>
Date:   Fri, 25 Feb 2022 20:52:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] scsi: aacraid: add missing manage_lock on
 management_fib_count
Content-Language: en-US
To:     Niels Dossche <dossche.niels@gmail.com>, linux-scsi@vger.kernel.org
Cc:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Niels Dossche <niels.dossche@ugent.be>
References: <20220225213308.89883-1-niels.dossche@ugent.be>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220225213308.89883-1-niels.dossche@ugent.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/22 13:33, Niels Dossche wrote:
> All other places modify the management_fib_count under the manage_lock.
> Avoid a possible race condition by also applying that lock in
> aac_src_intr_message.
> 
> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

One Signed-off-by line per author please. If you want to make sure that
multiple email addresses are recognized as a single author, please add
an entry to the .mailmap file.

Thanks,

Bart.
