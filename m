Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC157C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 16:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A902C20672
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 16:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNQLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 11:11:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45745 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNQLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 11:11:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so4527902pfn.12
        for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2019 08:11:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gLqjUavFiU/wsHGoJl1yZ6xjF1j6RizKdWCOOufbTk=;
        b=Kqpllo8Bc1+fRKJKJqZ8eFvHJENoc/BNIhA3eo/zb4IzW6W6Ah7dAmNEJFufTN9Ev8
         UQ0MwaxROhq8/gA5pQV1NkDY+UTNc3lFJliPxSRRDkp9saQL846i7nFiOaUJPC5ob6yy
         7mWimVpDpoZPqTRh9AlkuNEEZfCN1oZ4csMxmYUOLbSa+cBxi48GQWm7JFJ0eUoyB2a1
         80CuzsfhxmYLkBZxlJCyu2XFrIMhXg0X3VynPE7aw4fMI65qs+ujPPWpSJDcRucZmVpj
         +BSz1ogQr/uyYwEBXpNlReqjtqxomSvWLPP25Vy91BNyeYg92JcU9AXhti3kyFR5wWBN
         mSLw==
X-Gm-Message-State: APjAAAXkIdSxro7nkec0na8j3DDiksWe6WoeUanhiZRyb2wxZCfW6OYU
        pPuTK40DeBmSV4RwX2x+AIyRAmCSBj8=
X-Google-Smtp-Source: APXvYqy0lzRpedDqg5uxhtT0XQNNal6w0qyBmiFH+dXC116Cj+OyHdx9FeZHXzZtObChF13bkRNaVg==
X-Received: by 2002:a63:b909:: with SMTP id z9mr10816259pge.136.1573747902139;
        Thu, 14 Nov 2019 08:11:42 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x186sm8507776pfx.105.2019.11.14.08.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 08:11:41 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
To:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
Date:   Thu, 14 Nov 2019 08:11:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/19 8:03 AM, Bean Huo (beanhuo) wrote:
> I think, you are asking for comment from Can.  As for me, attached patch is better.
> Removing ufshcd_wait_for_doorbell_clr(), instead of reading doorbell register, Now
> using block layer blk_mq_{un,}freeze_queue(), looks good. I tested your V5 patches,
> didn't find problem yet.
> 
> Since my available platform doesn't support dynamic clk scaling, I think, now seems only
> Qcom UFS controllers support this feature. So we need Can Guo to finally confirm it.

Hi Can,

Do you agree with this patch series if patch 4 is replaced by the patch 
attached to my previous e-mail? The entire (revised) series is available 
at https://github.com/bvanassche/linux/tree/ufs-for-next.

Thanks,

Bart.
