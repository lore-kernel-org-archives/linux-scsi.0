Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64195C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 01:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiBJBVg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 20:21:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiBJBVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 20:21:34 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EED765C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 17:21:35 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id n23so7519349pfo.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 17:21:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O90R81pbTbro5RQNp9EE0oXyhqoyHhftteShHIcnZCE=;
        b=SeE8Ek6ABiX0sh34S6JHkfwAJFxme+dVPADSaYW1SNsLAb0jCKAQnUlWeP0DrzJx5N
         GdQM4hm8XzPMqlf31LJz/x6TlYnX37zZz0GQvXsNGWZ95NIw/ueKeb3QoThE2M4dtAp6
         9KrCIfXREG7ESIRGP/eGNm0owV8/ek8oLuegSYqQ+poYYYM2dNjgw8noAKQVPEm5yrNR
         lovUfngoXSr1ebhywrYd/BNEqpvttdpNmHGt+gPYrXwbUChWoH4jHliRJa0k1VdyP3gq
         zLgZ6YFDhoXxrqY5OuYhSzzFlTUiLMRmdmFsKHeB6Ua5C6GZoUtpN/+DzYiTHJIAIxkD
         xKDw==
X-Gm-Message-State: AOAM533IOq2noeZTeqs8lhOkJ4enddSJa38DyBUPc+Y9MbuzGviqHXMn
        N50WrSg36Xow0/EuDJzavf4=
X-Google-Smtp-Source: ABdhPJxeShc9krPi+/AJQoaafQNLuVRz7+vZXdgqYjt4p2Uyql+uthbKnJmFJRXMk3fLGjfriRR+qQ==
X-Received: by 2002:a63:5545:: with SMTP id f5mr4143256pgm.157.1644456094252;
        Wed, 09 Feb 2022 17:21:34 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id v9sm21398559pfu.60.2022.02.09.17.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 17:21:33 -0800 (PST)
Message-ID: <f1c433ba-ace4-33ee-a2d5-ae17de658302@acm.org>
Date:   Wed, 9 Feb 2022 17:21:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <51f46665-694e-27c4-3fdc-59339d51d54e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 13:24, Mike Christie wrote:
> On 2/8/22 11:24 AM, Bart Van Assche wrote:
 >> [ ... ]
> qla4xxx doesn't use libiscsi for scsi_cmd based IO. It has it's own
> queuecommand, completion path and error handlers, because it offloads
> the entire scsi cmd operation.
> 
> It only uses libiscsi for iscsi passthrough IO which doesn't use the
> scsi_cmnd.
> 
>>   static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
>> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
>> index 69a590546bf9..a122909169ee 100644
>> --- a/drivers/scsi/qla4xxx/ql4_def.h
>> +++ b/drivers/scsi/qla4xxx/ql4_def.h
>> @@ -216,11 +216,18 @@
>>   #define IDC_COMP_TOV			5
>>   #define LINK_UP_COMP_TOV		30
>>   
>> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
>> +struct qla4xxx_cmd_priv {
>> +	struct iscsi_cmd iscsi_data; /* must be the first member */
>> +	struct srb *srb;
>> +};
> 
> So you don't need the iscsi_cmd above.

Thanks for the feedback Mike. However, leaving out struct iscsi_cmd from 
the above data structure is something I'm nervous about because if there 
would be any code in the qla4xxx driver that calls a libiscsi function 
that writes into struct iscsi_cmd then that would trigger data corruption.

Bart.
