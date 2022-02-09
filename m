Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C24C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 23:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiBIXfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 18:35:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiBIXfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 18:35:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFBEEE0536EE
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 15:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644449720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9y6D9RnShyIfXIArwGGS+kmHUFqMF4nsm1ogvvaNuw=;
        b=Cvk/n7DTRDAZ46wn9aRtXwHPe3ldiw29wU6ai0EYiyOYiAur2FLFVlZ/xMAmturNS7PoRF
        F0jW4lDzPzR15fg0Rs+nC6R1orptVwtq8L7K7cdCw5uy/IO35gNvJlOJL4W6/d0qlqfKaf
        zqfy+bWu4Emkd9xO/8P3rmFZwYbAmso=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-TPXzJ2gZPsS5m3dDrP-YSQ-1; Wed, 09 Feb 2022 18:35:18 -0500
X-MC-Unique: TPXzJ2gZPsS5m3dDrP-YSQ-1
Received: by mail-qv1-f71.google.com with SMTP id cs16-20020ad44c50000000b0042bfd7b5158so2753239qvb.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 15:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r9y6D9RnShyIfXIArwGGS+kmHUFqMF4nsm1ogvvaNuw=;
        b=79kHPlYTZ7ivSfKpMaRMzkyU8/Z0Snue/bDLVEmTCzeJRjY6JXZNVOpcHDa4nfdC6J
         fXPZAd6QNyAzJUCLqgY1s/fx5xx6ExAoHpqCBlJYLtPcB0LxZJrbyjBTNUHG3VgU/XsW
         WJ7icFJsIIsL1f4GEjdX7AasYFrWS9/eMB/aIp6mFZEI2QXcXhBAMQ+HnfWLfwbAg5lu
         1OPXvoV5iHrjrvZ0HZCQCeFY7CoBqK+/VkaOB4NhEqp5VD1jwOi+xT0mSlU2gni71+l3
         O/bSNzwyXa9/ZzO4MbfuqWHwuWHC2h2TjAKAArxAFWoW4HiaHxgkIDvzUjST2/udfLxv
         zB2g==
X-Gm-Message-State: AOAM5315rGEQ8csHMyXbMhfpo5XRzftY40ezihg+3oTsaqTfHog4JH1O
        uzMEJk+GzxS3CYD3bjwkK47P/hksg48trct2ASKzDxPSmO1XJjRYTJwJxsIfjmoBKDuM+nJcxbB
        Xg/McyJZSPUMtiTvjM1q9gA==
X-Received: by 2002:ac8:7dc3:: with SMTP id c3mr3101451qte.266.1644449718245;
        Wed, 09 Feb 2022 15:35:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv5ggKLJxE1k81UIhmZRk5Y/pHd73d5r6XeVNFC4Ue5v7gi/Y102HRLi8ly4GwpDuw6TKweg==
X-Received: by 2002:ac8:7dc3:: with SMTP id c3mr3101436qte.266.1644449718035;
        Wed, 09 Feb 2022 15:35:18 -0800 (PST)
Received: from [192.168.0.14] (97-120-56-15.ptld.qwest.net. [97.120.56.15])
        by smtp.gmail.com with ESMTPSA id y20sm9368211qta.9.2022.02.09.15.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 15:35:17 -0800 (PST)
Message-ID: <ad6657eb-c29c-ee79-4824-24a17b60e3ee@redhat.com>
Date:   Wed, 9 Feb 2022 15:35:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-23-bvanassche@acm.org>
 <51f46665-694e-27c4-3fdc-59339d51d54e@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <51f46665-694e-27c4-3fdc-59339d51d54e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 1:24 PM, Mike Christie wrote:
> On 2/8/22 11:24 AM, Bart Van Assche wrote:
>> Instead of storing the iSCSI task pointer and the session age in the SCSI
>> pointer, use command-private variables. This patch prepares for removal of
>> the SCSI pointer from struct scsi_cmnd.
>>
>> The list of iSCSI drivers has been obtained as follows:
>> $ git grep -lw iscsi_host_alloc
>> drivers/infiniband/ulp/iser/iscsi_iser.c
>> drivers/scsi/be2iscsi/be_main.c
>> drivers/scsi/bnx2i/bnx2i_iscsi.c
>> drivers/scsi/cxgbi/libcxgbi.c
>> drivers/scsi/iscsi_tcp.c
>> drivers/scsi/libiscsi.c
>> drivers/scsi/qedi/qedi_main.c
>> drivers/scsi/qla4xxx/ql4_os.c
>> include/scsi/libiscsi.h
>>
>> Note: it is not clear to me how the qla4xxx driver can work without this
>> patch since it uses the scsi_cmnd::SCp.ptr member for two different
>> purposes:
> 
> qla4xxx doesn't use libiscsi for scsi_cmd based IO. It has it's own
> queuecommand, completion path and error handlers, because it offloads
> the entire scsi cmd operation.
> 
> It only uses libiscsi for iscsi passthrough IO which doesn't use the
> scsi_cmnd.
> 
> 
>>  
>>  static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
>> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
>> index 69a590546bf9..a122909169ee 100644
>> --- a/drivers/scsi/qla4xxx/ql4_def.h
>> +++ b/drivers/scsi/qla4xxx/ql4_def.h
>> @@ -216,11 +216,18 @@
>>  #define IDC_COMP_TOV			5
>>  #define LINK_UP_COMP_TOV		30
>>  
>> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
>> +struct qla4xxx_cmd_priv {
>> +	struct iscsi_cmd iscsi_data; /* must be the first member */
>> +	struct srb *srb;
>> +};
> 
> 
> So you don't need the iscsi_cmd above.

Mike's of course right about qla4xxx, but it still calls iscsi_host_alloc
so only accounting for the srb pointer in cmd_size is going to trigger the 
WARN_ON_ONCE Bart added.

- Chris Leech

