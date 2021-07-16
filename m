Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBCC636CA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F9C613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhGPQ5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 12:57:23 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:42889 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhGPQ5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 12:57:22 -0400
Received: by mail-pl1-f171.google.com with SMTP id v14so5586237plg.9
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 09:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43qrEvlqw0z1Pw1UQK6bmEFwhcVr9kwK2j76UKmnKpo=;
        b=Jxu6uftg4Y3hv4hDvBGJDinUhHuB7WgS7Ous6IHCNDSqN4rCCDca8Z7CDR/l8+1eCJ
         bKi5+VDvwwGzRdjoX0hu3fl6INWLqz7N2oVIpwCpf+mJ7DdqmSmEoDrLKOHAlbf4i078
         aG0zzaNrCn8tgdHXU+t5UaOOPBVWtUeRUoykqb9ui2uwotUWurirNtev9VPKHudH1j07
         GFSlkUDZqAl1sntCYNY9SKAMdMoGebARKNu/J0MwPqulmi6yek+lWLy9U9qoY7uVuiVD
         Q0DuFsWGDG70t+bznrmeZNNVwy8Khdp20fi5XhM2+8idtZhXP9X33ndwVbB3DYZTW9vK
         mk8Q==
X-Gm-Message-State: AOAM533K7SNHdry3QUkxEoUAmvxb5AdpPtIrGJyoHr3MUVdw6YKba5nq
        IWzzYXuaGrKKKWs303DFV50=
X-Google-Smtp-Source: ABdhPJwdITOE+u+YE6iyQmIW4QdL9/ft/aWZD68n1JlCS/Q2MHtjSXoHb5BbPti4pMIZW5fAT8euqw==
X-Received: by 2002:a17:902:da83:b029:129:9f09:bedb with SMTP id j3-20020a170902da83b02901299f09bedbmr8667850plx.56.1626454467195;
        Fri, 16 Jul 2021 09:54:27 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:ad12:9dbc:6e29:6c02? ([2620:0:1000:2004:ad12:9dbc:6e29:6c02])
        by smtp.gmail.com with ESMTPSA id h20sm10872194pfn.173.2021.07.16.09.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 09:54:26 -0700 (PDT)
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
 <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
 <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d43d94f4-8f9d-7391-a166-f839c03fb7b3@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b041051d-fc03-830a-f4b8-9ba2fe733954@acm.org>
Date:   Fri, 16 Jul 2021 09:54:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d43d94f4-8f9d-7391-a166-f839c03fb7b3@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/21 9:26 AM, Asutosh Das (asd) wrote:
> I agree. We saw substantial improvement with RR and RW too with the 
> 'Optimize host lock change'.

Recent UFS driver patches introduced three changes:
(1) Use the UTRLCNR register instead of the doorbell register in the 
completion path.
(2) Use atomic instructions instead of the host lock for updating the 
outstanding_reqs structure member.
(3) Reduce lock contention on the SCSI host lock.

My patch preserves (3) so it should preserve the performance 
improvements that are the result of eliminating lock contention for 
outstanding_reqs updates.

Thanks,

Bart.
