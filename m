Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCDEC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 18:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352525AbhLASho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:37:44 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41957 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352551AbhLAShH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 13:37:07 -0500
Received: by mail-pf1-f175.google.com with SMTP id g19so25402472pfb.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2021 10:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BL8t6kyRm1ldtEOoFlj1IBjPz8mq+rXjVlBZEOSv6IQ=;
        b=HF0S6/5xLyV0Nre37ymQdtm85aglcBgO7TW3h1MknGJlZqB6S/qA9wRbyRhRi1DnZp
         OUgAyahOPVLgo4MrAn8LO1zPct+HVg65NCV0YjTTMNjB/gbhqL6ZoEohm8em9I1AKEEq
         qnZIIoqxKdWONAkyd/an5Pl1jROGnhG2Bd4CWA813B9wN+4f2qPKcRD1hdy8bwsQ4hNX
         fKMBLhWU83UtCcCrSi/pu/H61R9bjASRByYje1zpmqItDbbTaogUH+s7HdlUBz0dF0rf
         4GoWPE2QX4ZQb1x72+DmyfRfEPk+yy8viiQDU6kTsdc+gq+AtC0Tm97C2FI5B1PYksnN
         85cA==
X-Gm-Message-State: AOAM531Ho/j67kVMCAL4d9pzSxl3aDLyB39ln6VLj5NyH4S64yZcL2s8
        Ng+vd8akaPvJuOhFI8D9t5w=
X-Google-Smtp-Source: ABdhPJzdyD7VaAEOGONrZmw/EORmzLPABbpi8BZLtAx8jHrHxp30qiZeD9b+y4JycPNVV7GnUAdfEQ==
X-Received: by 2002:a63:6cc8:: with SMTP id h191mr5994488pgc.76.1638383625796;
        Wed, 01 Dec 2021 10:33:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7344:c0bd:a55f:88b8])
        by smtp.gmail.com with ESMTPSA id k18sm556550pfc.155.2021.12.01.10.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:33:45 -0800 (PST)
Subject: Re: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-19-bvanassche@acm.org>
 <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
 <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
 <2071f69b-885f-e0c5-3ded-9f0c39eb38ae@codeaurora.org>
 <6dea2d9c-c04a-20a5-4292-e48badf89ba2@acm.org>
 <b3d2764a-8dd3-1c4e-675d-c43039d28850@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <892fe890-6f8f-f9a6-0a0e-271b16c76da4@acm.org>
Date:   Wed, 1 Dec 2021 10:33:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b3d2764a-8dd3-1c4e-675d-c43039d28850@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 10:24 AM, Asutosh Das (asd) wrote:
> This looks good to me. Please push a change and I can test it out.

Thanks for having taken a look. v3 of this patch series is available at
https://github.com/bvanassche/linux/tree/ufs-for-next.

Bart.
