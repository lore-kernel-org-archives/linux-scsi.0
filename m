Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16172C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 20:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjAXUdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjAXUdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 15:33:36 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5DF46A5
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 12:33:34 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id i65so12077157pfc.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 12:33:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZvOXBxrpQ5rpLV7CbNutc5BZucUM9mBEQv+QV32/b4=;
        b=KXWO26kIrWpFAAQcQx100y0wz9WbOO4GFisXoxY5QoEwHf7UNNQW9I0oCh8q64jXRZ
         FN19lK+/kjoVDOZHFNvGJtdgia9WF9O3EYQLbzNu5Imsv54TQdlEG8areo7/PldLNeTu
         yhvlm6hJrOUMcZ0ZP/EQEF4Qel282wCAwoZvUc1MTuHXHjChVtWMJBExaiYO9/89+B3i
         oHu6f96a7vaof/yklH6kYeUqDYVJyFaeNvuqVzpeZbLGwQTTPTkCF8CWOZdpqtnaKrkI
         c4hDrSmxV+QAWu+NS1cCEujOvEZ3Jv1Lr4l8JJ1Q8fa5WulH/kHtjEt/UD6w9GMXb1aQ
         pkww==
X-Gm-Message-State: AFqh2krZdEcC+ZWWCAMR/wrTmGJSlunJlxrG35E6cWOKSbSCUpYjXjz7
        QfprGwt5ALfFMHBrdldZWZg=
X-Google-Smtp-Source: AMrXdXvmwvzoduPLRWAnPi0ALW53OEUqhU4pTMAo2vBjXfwyL7s7mcId9GjR3i5q3HcCSNOyuNGgJA==
X-Received: by 2002:a62:6492:0:b0:58d:90ae:495c with SMTP id y140-20020a626492000000b0058d90ae495cmr26618585pfb.11.1674592414311;
        Tue, 24 Jan 2023 12:33:34 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id dw6-20020a056a00368600b0058d9e915891sm2023998pfb.57.2023.01.24.12.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 12:33:33 -0800 (PST)
Message-ID: <53321793-fede-f84e-260a-9d6bc0bc2b6c@acm.org>
Date:   Tue, 24 Jan 2023 12:33:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20230124154953.17807-1-mwilck@suse.com>
 <aa6759a1-44db-cb2d-8f12-1ef44dd03791@acm.org>
 <c50ccfdc6fc8cb61f44713fd64697b20383a71fc.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c50ccfdc6fc8cb61f44713fd64697b20383a71fc.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:48, Martin Wilck wrote:
>> Something I should have asked earlier, has this alternative been
>> considered? This alternative has the advantage that no new functions
>> are
>> introduced.
> 
> Looks good to me, too. No, I didn't have this idea before.

Hi Martin,

Do you plan to post my suggestion as a patch or do you perhaps expect me 
to do that?

Thanks,

Bart.

