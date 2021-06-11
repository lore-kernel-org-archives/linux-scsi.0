Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F048C48BE0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131F2611CA
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFKVFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:05:51 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:55864 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKVFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 17:05:51 -0400
Received: by mail-pj1-f46.google.com with SMTP id k7so6359247pjf.5;
        Fri, 11 Jun 2021 14:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z6du9WszW7mZy9BU41+sV0nx4cAh5uv8eWtj4chy0tk=;
        b=IWiNkdn/1gNnYZQMgJ17zSAVwpVI8KAG/Hk11slrio5KAzO6QzvHFmUSOwo2VJrjJT
         MJJRP8dv35CyjBBNgf0IeX0Qhk8xDM2+DpNoJB2wHbHyxd3P0b9w8cRCYsxoVtYqo0N6
         2b2wG3S/CVgjo7Cm1X4jz6lGwqQ2rVcdE32SFr96Y8bsdmN1Z3JQZbmGMM5hmD9uDXUa
         nZebjaiAZs8OBZiWQxbMitugOlWO7ddSvwrJdKCrrXwqryW2Cb5OVAme0kI2kxFe+9Qq
         Olfe+kuzq3LOnSB255pWzURJATLlONcB8w1kNwjUcvSp699ECcL11MqhobPan/L5jbcT
         3zog==
X-Gm-Message-State: AOAM533ZjydBSmUSa5wi5Kc5zOzT+G5olhEtEet8f8ToFu0zFBsiGAy5
        uh+FRHl4TOA6bGCr+myQxhLuGQIIiJg=
X-Google-Smtp-Source: ABdhPJx51NBa9lpt58dxuwxqEyfMqyJacz3UNBI3qnr5bUvyluWUFEBq395WWNhmAcHkIkbClyJy8w==
X-Received: by 2002:a17:902:da84:b029:10e:fafc:b29b with SMTP id j4-20020a170902da84b029010efafcb29bmr5594979plx.35.1623445416135;
        Fri, 11 Jun 2021 14:03:36 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x3sm6579375pgx.8.2021.06.11.14.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 14:03:35 -0700 (PDT)
Subject: Re: [PATCH v3 9/9] scsi: ufs: Apply more limitations to user access
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-10-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b1e555c2-a59a-2a63-79e0-7c22d5b7b698@acm.org>
Date:   Fri, 11 Jun 2021 14:03:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-10-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> Do not let user access HW if hba resume fails or hba is not in good state,
> otherwise it may lead to various stability issues.

Just like for the previous patch, I'm wondering whether or not such a
failure perhaps indicates a hardware bug?

Thanks,

Bart.
