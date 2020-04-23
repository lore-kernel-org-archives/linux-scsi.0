Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F076C55191
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 17:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A7420781
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 17:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgDWR5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 13:57:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38270 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbgDWR5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 13:57:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id y25so3336085pfn.5;
        Thu, 23 Apr 2020 10:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=daGbqtibwc35BdsMcdFSyIPRGTwwJ3IBA05IlTqZ6d8=;
        b=I43wCRcz1amw60Iwve4JvxqA0ScjeazRbVV66+rZ9KoEKP6dec+I/ctur/ENwEayQd
         ndcOGMM5kAKgqghrlaS7J9HvQVJYjAy6nidPGH5+8Dr9GqpLdGOWWNOWRG5S1K62wF39
         efmwdmjlWalGp5CC0Y3eZARAOGixD6hQFYzX9CD+fhMRAlz7FYpb9xXhkltcEW5cbiAJ
         LnXnYTzvYGCXOkIn1bWLcztwpbhL8esRb3nFngfUt9O5vsZFtptGjOOadslo9gRc1jhE
         qmD8qLMnsdn0j+1dKjipqtS4MNfhQF5xefV+z4pymKvXML8QU6OlrbLmo898Gs+WwKmn
         dj4Q==
X-Gm-Message-State: AGi0PuaVsQ1z841mO2Aeug2Xdv2fvlfqXjJ2oyJA5aErp+r4wu0b8zYr
        BWnKiu3Iiy8bnNp5Y4Z++Ez18SGX1ZI=
X-Google-Smtp-Source: APiQypJ55IrIhgkLR0B2lVLW2yZ5mX8SXZEg7Y6hVIE2B8F13QM14Fh+Px7JmoDMASkcC5LEUuMrEw==
X-Received: by 2002:a63:1e0f:: with SMTP id e15mr4904610pge.240.1587664642229;
        Thu, 23 Apr 2020 10:57:22 -0700 (PDT)
Received: from [100.124.9.89] ([104.129.198.56])
        by smtp.gmail.com with ESMTPSA id w185sm2622217pgb.12.2020.04.23.10.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:57:20 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 1/5] scsi; ufs: add device descriptor for
 Host Performance Booster
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-2-beanhuo@micron.com>
 <6e092ac1-7e7d-3f12-8c81-b88369f1f621@acm.org>
 <BN7PR08MB568449A01D10F89B5C7F0E8BDBD30@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2625027d-8d98-3f30-93d4-dc1c39a434f1@acm.org>
Date:   Thu, 23 Apr 2020 10:57:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB568449A01D10F89B5C7F0E8BDBD30@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/20 4:01 AM, Bean Huo (beanhuo) wrote:
> Thanks your review, I will take your suggestions in next version development.

Hi Bean,

Please make sure that the issues raised by Christoph are addressed 
before reposting this series.

Additionally, I think the following two call chains are deadlock-prone 
and should be addressed:

ufshcd_queuecommand()
-> ufshcd_comp_scsi_upiu()
   -> ufshpb_prep_fn()
     -> schedule_work(&hpb->ufshpb_req_work)
       -> ufshpb_req_workq_fn()
         -> ufshpb_subregion_activate()
           -> ufshpb_subregion_l2p_load()
             -> ufshpb_l2p_load_req()
               -> blk_execute_rq_nowait()

ufshcd_queuecommand()
-> ufshcd_comp_scsi_upiu()
   -> ufshpb_prep_fn()
     -> schedule_work(&hpb->ufshpb_req_work)
       -> ufshpb_req_workq_fn()
         -> ufshpb_subregion_activate()
         -> ufshpb_region_deactivate()
           -> ufshpb_execute_cmd()
             -> scsi_execute()

I don't know any other block or SCSI driver that calls blk_execute_rq*() 
or scsi_execute() from inside its .queue_rq() callback to queue requests 
onto the same request queue (the device mapper requeues requests onto a 
lower level request queue).

Thanks,

Bart.
