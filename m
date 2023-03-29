Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDE0C761A6
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjC2Uwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjC2Uw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:52:28 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3A17AB4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:52:04 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id y19so10094075pgk.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680123124;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJ6lrhUIJniZASXaQdpxUtDYV9CTVjlePFFqheIDoaA=;
        b=J6z9MCOoCWXVUwiVYAn00BX7AtF1DtDw5X3JIdO5h3CthM34IWa7luZ5pGjlrtNm2v
         I7xnW5Nt0M2v0BaO5JDBrXtY7xWuYh+n/rA4ED9c7pvG6X5V0dEWuqwyW0ljZ9fk6oSZ
         p278FtG7mGiNVtzk6INPju63efgP8SXONmmqQszO0fXYvAN/bzwR/syu6axIBVtLY4+X
         xKqp1I09DIUwnKjIykrQ5nxIDWdsjZn58LcN8TVjNZC5YON/HskWIV1/HUPn0c6pAs5I
         kD6MUMAcGDP+hKBjRPN7qzjiAAH4NwsTtTzGKwqJLilbQFf0MkIbVGzRVu8RSPK6epPz
         fmWg==
X-Gm-Message-State: AAQBX9co6tMaA9cfkcmhQJwiZXxBVyWDdIfBqOUX5PhjGrZwpSMfb8XD
        d5slV+1XfoxlKvM+CTSVAgU=
X-Google-Smtp-Source: AKy350ZC8FdrvuQRAfqUF6zK1rGco5FHTBdb4E+SwKFU+4B1wXOo1uF7WuYb3d+mCP/WSyLNK8Wd8w==
X-Received: by 2002:a62:2545:0:b0:628:f0:51d4 with SMTP id l66-20020a622545000000b0062800f051d4mr18887094pfl.11.1680123123792;
        Wed, 29 Mar 2023 13:52:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c058:cec1:e4c9:184e? ([2620:15c:211:201:c058:cec1:e4c9:184e])
        by smtp.gmail.com with ESMTPSA id a25-20020a62e219000000b00590ede84b1csm24212174pfi.147.2023.03.29.13.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 13:52:03 -0700 (PDT)
Message-ID: <577ea430-32eb-5bf8-8ff9-35b54626bf6d@acm.org>
Date:   Wed, 29 Mar 2023 13:51:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <cover.1680083571.git.quic_nguyenb@quicinc.com>
 <16c79431-0a04-6d07-9965-b3af400b8329@acm.org>
 <8dae9795-3d81-ce0c-bc6f-2751d8309ff5@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8dae9795-3d81-ce0c-bc6f-2751d8309ff5@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/23 13:50, Bao D. Nguyen wrote:
> Hi Bart, I am not sure if I did it correctly or not. The last time I 
> posted, it was with RFC tag in the subject. I have made some minor 
> changes to address the comments and some bug fixes. I am posting the 
> patches again without "RFC" tag now.

The change history is missing. This could have been made clear in the 
change history. Anyway, I will take a closer look at these patches.

Bart.

