Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9697C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 01:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiBJB0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 20:26:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiBJB00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 20:26:26 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C14E220D6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 17:26:20 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id v4so3796045pjh.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 17:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNiY/uRaasYGA+3zb+5HYwUD83p+N3/Wgr1xZkcY2cY=;
        b=IXrx9xLbAgVyij9saBkQPvW0bwt1CRf/O0kGXD803XvETKw4gUzyM87Dzle387MwCh
         WIGuJkRDcPMe+lXLTS1ioygRYdwrhkPcN8BGa0aDRnsqaZ8zOwM1SNjVZcjfQqsO+CVw
         sPlctPRTdGxl3ddlQ1ZH5xzRZvtp4CBdUWGgmD6Ax4+syvU2flAA3CZ+8ITgz9I7m5mz
         mNLcRNSG2XcRJYSbWRoax8ySLfOEUFUZ1yC9I6Jtvkl+mZGKeuSFWMi/o/R3Qa69AgzR
         2XJ2zGQAHvvw7OhPM1ZvluQtFdq02q7EBR3CdFQVHhg4VLZpkj4GCyx/g5v9tMSeJ6so
         JfYA==
X-Gm-Message-State: AOAM531Rrw2Y+2y0tj774SCIsdHd9lhVwfnxCruYT4Sl+Ju9/bbYR2pG
        CqCfBTkxGmKBZLsh3sgdkXI=
X-Google-Smtp-Source: ABdhPJxz5FK0Vxx7aQxo29kYZpGPCK1rAVOgaEc1KsVmVWK8YR13R58Z7HncE9K/4eg+ju1EW4LBJw==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr160937pjb.216.1644456379329;
        Wed, 09 Feb 2022 17:26:19 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm20904467pfj.211.2022.02.09.17.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 17:26:18 -0800 (PST)
Message-ID: <8767869c-8fda-b748-1209-6382418d9bdb@acm.org>
Date:   Wed, 9 Feb 2022 17:26:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
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
 <e1b73af8-914c-8289-756a-94c316e5a2f7@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e1b73af8-914c-8289-756a-94c316e5a2f7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 15:37, Chris Leech wrote:
> On 2/8/22 9:24 AM, Bart Van Assche wrote:
>> --- a/drivers/scsi/qedi/qedi_fw.c
>> +++ b/drivers/scsi/qedi/qedi_fw.c
>> @@ -603,7 +603,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
>>   		goto error;
>>   	}
>>   
>> -	if (!sc_cmd->SCp.ptr) {
>> +	if (!iscsi_cmd(sc_cmd)->task) {
>>   		QEDI_WARN(&qedi->dbg_ctx,
>>   			  "SCp.ptr is NULL, returned in another context.\n");
>>   		goto error;
>> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
>> index 282ecb4e39bb..8196f89f404e 100644
> 
> Minor nit, but this warning should probably be changed as well.

Thanks, I will fix the reference to SCp.ptr.

Bart.
