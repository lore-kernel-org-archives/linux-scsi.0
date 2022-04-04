Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB475C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356137AbiDDVyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382654AbiDDVbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 17:31:43 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A2A140E4
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 14:14:57 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id ch16-20020a17090af41000b001ca867ef52bso765514pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 14:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lGe2KnRvytlZpz0En2B5bopl9Rbkj6BkPgPUca1GDLo=;
        b=N/iQrfgp2FJ3x4h1pL36MhET2Z45cXf76M+QETq0fi1H6TKpyf6cZfy0+xLLMhy0eA
         UR5wY44ugcH8mCSJ2Wej2rhh1kcoEm1Vw3cQK1wiNrYBa/5ru8FTuY4nqHJkbhz/Xscy
         tV1083w6jlo0UXH5uBgOyUWemb4SzmJ2R5vH868WeoPPR03n9RUfiDD4bYlFC8D9f2TE
         m1LM5pr1qh0f9wqDmC9f3NmF7kQlJKQ4aHcXu9NaZ8WuoIWl1DPFOdOv0bgaILYnx+R8
         8/Kpjk1QttF63UlkvB4F7XrrsghYvAsAvikUAZiePgkn+ZQJFT+YBt/5OKdA4a6AjsJy
         H4Dw==
X-Gm-Message-State: AOAM530WRRouSr67VCNCgTrb4qa6VCSE2sLHgbU0JX6OxEX5zZ0csA5d
        u5QxjW4U1Ptth435N34xzbs=
X-Google-Smtp-Source: ABdhPJx1V75qr6MvoV/4PRaOmeVYRqBcpb2R8WIc+iEuWBkdwrX6ADnrooqz1m4Qdf3L0Jjp6JWyxw==
X-Received: by 2002:a17:903:22cf:b0:154:837c:597 with SMTP id y15-20020a17090322cf00b00154837c0597mr1830174plg.135.1649106897081;
        Mon, 04 Apr 2022 14:14:57 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s11-20020a056a00178b00b004fb1997b775sm13935433pfg.10.2022.04.04.14.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 14:14:56 -0700 (PDT)
Message-ID: <f5213385-b57e-af9d-721c-0316dd4151cc@acm.org>
Date:   Mon, 4 Apr 2022 14:14:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-10-bvanassche@acm.org>
 <DM6PR04MB65757609D6D12BA09C6DEC4FFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65757609D6D12BA09C6DEC4FFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 12:56, Avri Altman wrote:
>> Declare the quirks array and also its 'model' member const to make it explicit
>> that these are not modified.
>
> Sometimes it's useful to be able to add a quirk as part of e.g. a debug session in the OEM premises.
> And not always we are able to recompile the kernel.
> Since we have a debugfs now, how about adding this capability, instead of blocking it?

Hmm ... does declaring data const prevent from modifying that data from 
inside a kernel debugger? Don't kernel debuggers allow to cast away 
constness?

Thanks,

Bart.
