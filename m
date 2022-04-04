Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6A9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355121AbiDDVyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382316AbiDDV0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 17:26:44 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36181165A1
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 14:15:50 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so566147pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 14:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TICg4QJUmdzON1FBAoxNWvw+wrWSKnQSIZDDUQ592Ow=;
        b=qOl/1pqwiM2u5noT/Nz36BeFkj9BfYN6aBTYTLud/FByKTQXo8yN/EXnHCgFri6Tvn
         dAuLKBcOiPIujmqbhKyxdpPRHBLp3lBVfhU+8Kdgp5ujwFlUk60Yf1kLY9StEfD+vGYS
         WkhQpbeoyBQF2C6QeKcTbmWQEBqp9dTxMQe7AdHkbE9meDbQ6fHkUfdbKFzCV7c2Dt66
         ChrXxur7CP9rs6nZaL+9GXwIOcNPkn7SaE86cPNabDQXiiiw2gwLMJDaeP+Jf9OlZHOa
         b5Rp9bXfkkgMhTQnR5mKwxjw6jv3Kv0ce2b9oLD8OmzkgJDh5xspilpf8InsHzPvhGjO
         aKqg==
X-Gm-Message-State: AOAM5304qW+WxwSVTWywrZXMI/ZPrlKBvHSnQR7GtAby0wNQjzL6yIeU
        /xj7Pae8SKPPd8V3Ya0DtVM=
X-Google-Smtp-Source: ABdhPJzMXQyKtQIHO1H8nu+x3ycJ6XvZkletDUSlPKMLyaHv4R8RGdkla0y3c1071ApqXE3DTf/xIg==
X-Received: by 2002:a17:902:bf4a:b0:151:7d37:2943 with SMTP id u10-20020a170902bf4a00b001517d372943mr105202pls.131.1649106949636;
        Mon, 04 Apr 2022 14:15:49 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h189-20020a636cc6000000b0039841f669bcsm11455236pgc.78.2022.04.04.14.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 14:15:48 -0700 (PDT)
Message-ID: <240ef04b-e724-d2de-61f7-2aba8ab4dbc5@acm.org>
Date:   Mon, 4 Apr 2022 14:15:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 08/29] scsi: ufs: Rename struct ufs_dev_fix into
 ufs_dev_quirk
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
 <20220331223424.1054715-9-bvanassche@acm.org>
 <DM6PR04MB65754BB97F7C77FA41EEC8A8FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65754BB97F7C77FA41EEC8A8FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 12:47, Avri Altman wrote:
>   
>> Since struct ufs_dev_fix contains quirk information, rename it into struct
>> ufs_dev_quirk.
>
> Maybe squashed this one to 07/29?

Not sure what the best approach is in this case. I tried to make patches 
easy to review by splitting these if it makes sense.

Thanks,

Bart.
