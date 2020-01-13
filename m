Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB45C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 16:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AEEC206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 16:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAMQLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:11:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38645 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgAMQLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 11:11:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so5089180pfc.5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2020 08:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zs5FgMN9YqIoBAnFzPyJhCqHBxjYfEXqp6MnxsUCmYo=;
        b=i3nDlnxYBMQB07p6Vp+qqdJY0mQPslqD83smkm/DguPh9dw83MTgFbNJiChH5z7/Wo
         +uMrzIBdhj6p46K5J860WgZIlgcA+1iFhopVNzqUWoy3z46Eur1EgAuLm42FqJnL8Fw4
         i9y6qihZwEGwj7GQIa/lAQseAi2OQ2GPYCOSwO9V8BheR1X5Ut/z04KlehDZfMMoK7zE
         GfyzTtD5+oP/1ECfxvtlEjGyrFC5VHtWVr+jadxY5fRblh7gcBQSdioZbMC2U+b22FqB
         eVbt8/CMog10azmNnogSFGb6LL39fvko+EnoYVeyWycxd+w0bq+8/WRg5zTZwCACOU2t
         jHTg==
X-Gm-Message-State: APjAAAVpA2PQNV/+OpdTu7GWKH4boKZ36G3LCCRYLAHLCrdS/HUQ9QQx
        fBOxQ1IjEqIl96Zz0ytkexg=
X-Google-Smtp-Source: APXvYqyvRg+L3OgqEZG60HQh114CQXz+4KgJMw37ai2oM5URCLOovzS5R18vn7wyX4g54qhdMpXVgw==
X-Received: by 2002:a63:1a1c:: with SMTP id a28mr22397316pga.374.1578931871087;
        Mon, 13 Jan 2020 08:11:11 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id t30sm13889568pgl.75.2020.01.13.08.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 08:11:10 -0800 (PST)
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
To:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200112210846.13421-1-bvanassche@acm.org>
 <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <086f02b8-b8d8-5336-bf2c-031293d95890@acm.org>
Date:   Mon, 13 Jan 2020 08:11:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/20 7:29 AM, Ewan D. Milne wrote:
> On Sun, 2020-01-12 at 13:08 -0800, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
>> index c4e087217484..6560908ed50e 100644
>> --- a/drivers/scsi/qla2xxx/qla_init.c
>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>> @@ -4895,6 +4895,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
>>   void
>>   qla2x00_free_fcport(fc_port_t *fcport)
>>   {
>> +	if (!fcport)
>> +		return;
>>   	if (fcport->ct_desc.ct_sns) {
>>   		dma_free_coherent(&fcport->vha->hw->pdev->dev,
>>   			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,
>>
> 
> I would have fixed this by moving the label to be after the qla2x00_free_fcport()
> call in qla2x00_configure_local_loop(), which Coverity complained about.  And
> called it something different.  (The code could probably be simplified by only
> making a call to qla2x00_alloc_fcport() in one place, something to think about...)

Hi Ewan,

I have considered the solution that you proposed. The solution shown 
above was chosen because I did not want to introduce any memory leaks in 
qla2x00_configure_local_loop(). There is a "goto cleanup_allocation" 
statement in that function that occurs after the "new_fcport = 
qla2x00_alloc_fcport(vha, GFP_KERNEL)" assignment. That is hard to 
notice because the qla2x00_configure_local_loop() function is so long.

Thanks,

Bart.
