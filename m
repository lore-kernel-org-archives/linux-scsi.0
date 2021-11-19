Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184DDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4CAA61AEC
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhKSTEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:04:41 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:34617 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhKSTEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 14:04:41 -0500
Received: by mail-pf1-f179.google.com with SMTP id r130so10135484pfc.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:01:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hxVGPHyBkUoUmibpdQR5YG6223FvP5Q7v1GwOax71Ko=;
        b=aQJEREMwKZhg2t6KWtObZzeDtnw4kUo1qHHtUwBAAfBahBPB3W7IlSOJBJGpfGPnPJ
         1+J/5unJFZ/3jGh8dePHjPHozZgtGHcY+CSm5H8+P+8yuqKuVTQ/c5m5fT8DycE6ejX8
         MtLUF804rNumCRXjYTXwa9FNwa5McQexocd+Lb9kecsckPvKZJ0UJIZGQ9fYOxPNSdCW
         P4C2GcdLn8g+wsJTJ1XDi6ATPvE8aSX0k546r2Tbj0CwNoLr6KgsVEXSl5CW2BO7D8g2
         5Z/p4jPmBDykL5pmwTD5LA14p7rdkeIExU5lahUWsxv/abxnfScbCDKe731XozdR9aaQ
         plwQ==
X-Gm-Message-State: AOAM53299+uAzRKus7HnNhYpnHdYiB4gzSpoH30lDsR7MMYsFpyQXpmY
        34HGxvGTHpZv9bmY2Hg8ZxM=
X-Google-Smtp-Source: ABdhPJxridcEL2HvPiSZ7nKkw9BOMaKSq49+17Rfv31wWhBWsy2OaT8p82Y6i+Apr3ac4/DYCXJiEg==
X-Received: by 2002:a05:6a00:2186:b0:473:5a61:a7f6 with SMTP id h6-20020a056a00218600b004735a61a7f6mr24799345pfi.15.1637348498618;
        Fri, 19 Nov 2021 11:01:38 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g7sm389014pfv.159.2021.11.19.11.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:01:38 -0800 (PST)
Message-ID: <fe970625-67e4-c94b-04df-707e5be1bddb@acm.org>
Date:   Fri, 19 Nov 2021 11:01:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 11/11] scsi: ufs: Implement polling support
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-12-bvanassche@acm.org>
 <DM6PR04MB6575F4155E19B2D08A4EFB94FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F4155E19B2D08A4EFB94FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 00:11, Avri Altman wrote:
> Also I think this should be a separate patch as well.

I see an 8x IOPS improvement on my test setup (2736 IOPS with interrupt based
completions; 22000 IOPS when using polling).

>> +       .mq_poll                = ufshcd_poll,
> Did you consider to use some form blk_mq_tagset_busy_iter,
> And return nutrs - busy?

Hmm ... wouldn't it be racy to use blk_mq_tagset_busy_iter() inside ufshcd_poll()
since multiple threads may be polling at the same time?

Thanks,

Bart.
