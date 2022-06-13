Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7DDC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 18:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbiFMSUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245086AbiFMSU3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 14:20:29 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2525300
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 07:24:50 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so8999786pjo.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 07:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bwmi7te5T3zW1KkBp1c5ZH5Wz6lTFwlup0r7H9j/PdA=;
        b=qqsQOLseqxtsAoHZq+Pya2truz+C+u8yp1i4IWOzKieOTgYyijvhD5exZUtD4dwRkf
         AkvrYhChWyzeL6PrIyLfeFhix3whDzOic+j8uZNJ5kEGSKW57/atvto2VzEVto5SfNF9
         OnzI0EPruBR0Q58FRTqXBRhusaVicl0+6+S1OtFEY5j3TEusbJ8Y+QHnCY6ab/aWFBrS
         2zrdcRnXjkKPyQTQGYBKum2T9FMhJdaJRqs00/HTKe2G+UDSANdDONRezh43TUJGN0cw
         ZyQTQlYmBOl9QNkx0BKfGPjgF5yy6p9NF/XGwlwKqat0NKoLANGbGR+6NsBoj7d+B6Rg
         RC/Q==
X-Gm-Message-State: AOAM533ODVk1Z6zU6It2F2AeIQXzoCHz/TnoXvQbir1zBX2QvFrAAOcd
        YQ457ru84ONWTS8hVxSleSrTP1WlTso=
X-Google-Smtp-Source: ABdhPJy0QSzPwK8atdAhTmRp/WpefhR25ZbxKbdwNeUoRgADs2OEEs7deHzumpjuHrMRrPDHUnx00A==
X-Received: by 2002:a17:902:e54b:b0:166:50b6:a0a0 with SMTP id n11-20020a170902e54b00b0016650b6a0a0mr54072869plf.30.1655130290057;
        Mon, 13 Jun 2022 07:24:50 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y26-20020a63b51a000000b003fdcd6425absm5615533pge.30.2022.06.13.07.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 07:24:49 -0700 (PDT)
Message-ID: <5fa152ed-265b-774f-ac72-e8acd9407ac4@acm.org>
Date:   Mon, 13 Jun 2022 07:24:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: ufs: Fix a race between the interrupt handler and
 the reset handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
References: <20220610232915.2916712-1-bvanassche@acm.org>
 <de4b45a6-1e67-0bc5-39c4-62d7982d55fa@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <de4b45a6-1e67-0bc5-39c4-62d7982d55fa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/22 23:28, Adrian Hunter wrote:
> Having cleared the bit in hba->outstanding_reqs, shouldn't we
> always complete the request? i.e. we should not 'break' here

Agreed. I will fix this, retest and repost.

Thanks,

Bart.
