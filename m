Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B806DC67871
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 00:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiJYAt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiJYAt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 20:49:28 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EC4B7ED0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 16:27:24 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id b5so9959839pgb.6
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 16:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/qsi9yQvxD/GIFFG7OMgToxRDmJ2I49u6gNJaJWlZXI=;
        b=wfFqWOcvHRVtfC4j1s3/VtAWuthl8SHJb6HEAoozFW40iXLw7DaQVS2XZ5TYNXGu3z
         GG8geJF2wdNm14qVKpYPiUireUhV1EQc01RD8ZWv+TyOs+uiMXUrGJT0N5EYCRSVWRl8
         LJn3D0+EHHN1UEgjF+uTLXRMpNAn9+6DAFks/pHi/CFqRZAYaS7gLtHk+kVsGyquvA4h
         wxyiW9FUmKYoSeaXbkrcbc/+XtWD0EjaJPy9UH3JmM3fIu7+bUUAuyHrH2s+JTRNmR1s
         80YMFSAD3R1wOcWuYopkedVfASw2wu3SsDAT49Z2RkOWKxIpnf9l89Hhr+Rp5b8iy2jB
         M39g==
X-Gm-Message-State: ACrzQf1Npsa2XssYOebRdBY0XRGy+v6QNVLn2Rayv4FaxlZMnYTmdFT/
        RK27IA9cbBR7wfMpeBlngVI=
X-Google-Smtp-Source: AMsMyM6pkAHhHHGgvGOfP04KNCu3aBvJlIxqNWWvfoRe3kcpqrMAb3uhTyvQ8rvtSg1YzVPX7m5dSg==
X-Received: by 2002:a05:6a00:2391:b0:56c:511:f649 with SMTP id f17-20020a056a00239100b0056c0511f649mr3486069pfc.84.1666654043770;
        Mon, 24 Oct 2022 16:27:23 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y13-20020aa79e0d000000b0056bd4ec964csm296017pfq.194.2022.10.24.16.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 16:27:23 -0700 (PDT)
Message-ID: <56d27d76-a6bd-41ad-c729-3e147696ee06@acm.org>
Date:   Mon, 24 Oct 2022 16:27:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 00/10] Fix a deadlock in the UFS driver
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <yq15ygcwnb6.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB6575AC3D9239CFA6F8598EB2FC2F9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575AC3D9239CFA6F8598EB2FC2F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/22 23:16, Avri Altman wrote:
> Patch #6: dcd5b7637c6d (scsi: ufs: Reduce the START STOP UNIT
> timeout) wasn't acked by any device manufacturer. This timeout is now
> reduced from 10 seconds to 3 seconds, after it was reduced from 3x60
> on August. Please allow few more days to verify it internally.

Thanks Avri for the additional testing. If the timeout value would have 
to be modified I think that can be done easily with a follow-up patch.

Bart.
