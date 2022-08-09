Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27B3C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 20:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiHIUOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbiHIUOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 16:14:17 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823C1A041
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 13:14:17 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 202so5588813pgc.8
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 13:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=jqeJJGBjWSxiBcryzKaak91jOHvj6p3PE/wgcWZN3cY=;
        b=THWgCzeyj0lhD3Ea7tXN3GxDmNAJyNYRJSTcmX14cOhPaekr+VcgVud4GheQHkc5Nx
         JOsEGNXM4SNRvUrmm1GM9WO6yUSf4FM+CoF0JrNnamnziEFtuxceJL5APAuWXIFrLpeu
         zTUl9vh53RCElta6eUcAriGe6DAZb8kPUrR9+314uPzc7/hPVYyy6JkjfFJU5kvtC7+3
         9WqgFxIdKA3Wvn33hRQ0a8cikavepkXdXtxCktKOl5/dDQSJ73Vy/5vhvC4MR/m5NBvQ
         a6OPQJS7ozyAFu7aMCzXTCtdzi23MLM1jSQHeYYy0HcwSDk7hZ9AHDmCEEKzVFFn0zKQ
         dhlg==
X-Gm-Message-State: ACgBeo0hq5KKD94i1v6FWqEPTlJGsm5SmPXSgaE5EW6oPHyXBIoyjkVk
        4CtSgIi0sO8AxBIA4wtGbUUcQLaw244=
X-Google-Smtp-Source: AA6agR55nrBGVU4SXJIUFhTMLyl77CsPfwQLBpi1mFmisRW/l/9jNJ4e9TCX094EZBvFqT6eP47Sog==
X-Received: by 2002:a63:6e82:0:b0:41a:1817:15d9 with SMTP id j124-20020a636e82000000b0041a181715d9mr20507928pgc.577.1660076056348;
        Tue, 09 Aug 2022 13:14:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a12c800b001f506009036sm12928599pjg.49.2022.08.09.13.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:14:15 -0700 (PDT)
Message-ID: <cc65663d-a2b2-f9f6-cecd-1cb3f24b25a5@acm.org>
Date:   Tue, 9 Aug 2022 13:14:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/10] scsi: Convert scsi_decide_disposition to use
 SCSIML_STAT
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-10-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220804034100.121125-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 20:40, Mike Christie wrote:
> Don't use:
> 
> DID_TARGET_FAILURE
> DID_NEXUS_FAILURE
> DID_ALLOC_FAILURE
> DID_MEDIUM_ERROR
> 
> Instead use the scsi-ml internal values.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
