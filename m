Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CC9C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 18:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCD36197E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 18:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhGESLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 14:11:15 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:45832 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhGESLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 14:11:14 -0400
Received: by mail-pj1-f44.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so385462pjh.4
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jul 2021 11:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7S30w2iZqV5x1IfA5Bse+PIJ/B9norfYCeszokSAg2s=;
        b=E8oZzju6+xYnE/RaK4z9LMa+V4gisZzQ3B/KF4fFFmFswsg+pWRpZoeFnUC2cJoC2z
         PUVJkaDVHaJkFTKHYxzQQum4dYBnJ5JxEWt2FwDK8gjwoqtEI0boF+K4fBaOLpS9d2uT
         dfEvolv+5EG/8vGHRdeRk119ZQcYJw6G+8PU458tJkt9XvehyrMbEVLF5WK+ZrSf1vEo
         zNcmBLANsFxOUsf5NJOiyLwlNFHSQOrEAxZiHBmx9Bne6FpFbM3cLLTntxk/kEEiOveg
         fsTBWQ19JmLD1wFWYj3lPmlMIjiE7CzWP1DLLy29cQWj4Y2P3z+F26Dwhr8wOcSu6Luz
         wThA==
X-Gm-Message-State: AOAM531/Zkqdh6FFT3ICfQaHTjlFvdzOes33IyRBjT7MLbHzYEn/6O+T
        DRZ3kh4LRhpYZzHYRahtR8E=
X-Google-Smtp-Source: ABdhPJwHDWWxwszirdweU6ko4DuJwyEgkLrUG6NLMwK7hzv+atxoNo/8Mcp9qJ83fIPYGmfNSSGsRA==
X-Received: by 2002:a17:90a:800a:: with SMTP id b10mr320295pjn.138.1625508517175;
        Mon, 05 Jul 2021 11:08:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:7656:c56:bf79:33ca? ([2601:647:4000:d7:7656:c56:bf79:33ca])
        by smtp.gmail.com with ESMTPSA id a31sm15273417pgm.73.2021.07.05.11.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 11:08:36 -0700 (PDT)
Subject: Re: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-11-bvanassche@acm.org>
 <DM6PR04MB65756A3574F7857C2217BCAEFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <78c4342b-7758-a499-208f-393de8097a97@acm.org>
Date:   Mon, 5 Jul 2021 11:08:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65756A3574F7857C2217BCAEFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/21 11:46 PM, Avri Altman wrote:
>> scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
>> shost->can_queue to hba->nutrs. In other words, we know that tag values
>> will be in the range [0, hba->nutrs). Hence remove the checks that
>> verify that blk_get_request() returns a tag in this range. This check
>> was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
>> validity").
>>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
>>  static int ufshcd_abort(struct scsi_cmnd *cmd)
>>  {
>> -       struct Scsi_Host *host;
>> -       struct ufs_hba *hba;
>> +       struct Scsi_Host *host = cmd->device->host;
>> +       struct ufs_hba *hba = shost_priv(host);
>> +       unsigned int tag = cmd->request->tag;
>> +       struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>>         unsigned long flags;
>> -       unsigned int tag;
>>         int err = 0;
>> -       struct ufshcd_lrb *lrbp;
>>         u32 reg;
>>
>> -       host = cmd->device->host;
>> -       hba = shost_priv(host);
>> -       tag = cmd->request->tag;
>> -       lrbp = &hba->lrb[tag];
> lrbp is used below ?
> if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) ...

Hi Avri,

The lrbp assignment is preserved but it has been moved up to the
declaration block.

Bart.
