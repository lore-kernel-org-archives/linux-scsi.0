Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A407C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 20:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D47461163
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 20:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbhHFUYi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 16:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhHFUYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 16:24:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00771C0613CF
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 13:24:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so21192371pji.5
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 13:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=e0lVUt/4NFFIZHEfoHt+E24OPdgRm/YTKU30hnkZZJc=;
        b=nLFMG4+6ENRBYgCyQjNisdc8bQWWT33EHZdckernMco0LzNaLdMIBv/oKVAr0Mum8A
         UKo4fg9vXKvB/niO2HxTurZu22NoM3O5HXyHQLlxQ9nQTJf7MLpES94OAGjl6S0vxsZO
         NpL4779AaWZJ/+rlYD3fcs8pISo+hWkhMpxiDravfsIyVlEExbuHH/4gDqlxVOf646WU
         T7HwWZyeUGg5sNvfJwvGA3SZlO+EgUzhJTb0amEwCl75hallmfmFEswPZ62ihBGfgMZh
         wBdUrNowDMTPpkllpzrpTTSWG3UyvYqKV0Y9Nz2bHIKQjv/2QskI6p46CVu/RjkUKdUC
         OUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=e0lVUt/4NFFIZHEfoHt+E24OPdgRm/YTKU30hnkZZJc=;
        b=dR1xqdM9ufaY7eQ5QbdEZb1ynPp5DopMdXQKCgfVyfCw4+iTlbh7WWhNDc2gf2dgRQ
         j6R8CNOV+98dYYEOYat/uQSsr6pnEAH7qEU+4nmdzhYJ9Gyop+OXEB6YmGDM/xtPiQst
         fWG3w0Jvk56goBGK2+6eIllLBy5Sbk5BJn0nYbQNAjJ4YKUdWhJ8HungAddMdfLzzZBV
         FK0gGlsgOkq5oyLMcIk/ngM/mC8w58LstdBA37/fCbVuii56Yx1ie8ft0MDS3B/YgGf/
         q6ME4/bKBuaSrxSi0Ax45R6eQyTWXpx5xWOI3QQ6+2GDnCmoxfbb/Zu9zQbYG4wptcTs
         oU2g==
X-Gm-Message-State: AOAM533fSugHQPDUPwAp0jLcBHcljovW0Vpn5wMhTaFeLsMlToQgMmiZ
        MHrAOtv9BlpBQGqCGB3wyDc=
X-Google-Smtp-Source: ABdhPJxq2wmz5RcEHxTbal+OPboi8fS7tj2oTil9Cx9akKPekCCGFadwAfuhpFINMwnFcrFnR9tqsA==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr22562324pjj.165.1628281461485;
        Fri, 06 Aug 2021 13:24:21 -0700 (PDT)
Received: from [10.1.1.25] (222-152-189-37-fibre.sparkbb.co.nz. [222.152.189.37])
        by smtp.gmail.com with ESMTPSA id t9sm14466960pgc.81.2021.08.06.13.24.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Aug 2021 13:24:20 -0700 (PDT)
Subject: Re: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-13-bvanassche@acm.org>
 <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org>
 <041a2d03-c37e-288c-c042-95b825bf2fbc@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <5ec19a0b-d49c-8f6d-9452-f8b1a43f2a22@gmail.com>
Date:   Sat, 7 Aug 2021 08:24:15 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <041a2d03-c37e-288c-c042-95b825bf2fbc@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Am 07.08.2021 um 03:56 schrieb Bart Van Assche:
> On 8/6/21 2:24 AM, Finn Thain wrote:
>> On Thu, 5 Aug 2021, Bart Van Assche wrote:
>>
>>> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
>>> instead. This patch does not change any functionality.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> Acked-by: Finn Thain <fthain@linux-m68k.org>
>>
>> Did you consider replacing rq_data_dir(cmd->request) with
>> cmd->sc_data_direction for this driver?
>
> That's an interesting suggestion but I prefer to minimize the number of
> changes I make in NCR5380 drivers since I do not have access to a setup
> on which I can test any of these drivers.

The NCR5380 driver gets frequent testing on my Atari, so unless it's 
something integration specific, we ought to see any regressions there.

Cheers,

	Michael

