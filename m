Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5A0CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E91A208E3
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfKAPep (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:34:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41917 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfKAPep (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 11:34:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id p26so7312288pfq.8
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 08:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vLcSnKYtUhn8UQ7TOxaQkVNPZ/CUBgLJ7sFnXY3rcI0=;
        b=pSmu79MBUjHkm7S7UqgyVsCIW9VIf4vA2BkYnu2xepNIO24nzpohNTsWn+2B/p8PmR
         w4UuRX2HusfbM9+5knl/rpDin+usYMIaRWMWzryR3gvzMUp6qS7hdj9WqzFQQdLWEn0m
         tb3qOsrKUMmQl+SG+pHm8UR290SZMWhOPQv+gQZiAshjlYGlEws7boBwYfTsJQvCoMSw
         rL2KnA6erfS7pCLfRASL2xorv/5EYnEDqetZrlwv4dqxiPxLqQfZC57VWRxEGIzAy/Br
         Zv5GKzkbWSW826cYjicUyHPtmoCBgASa7DoHnAkil6UKt7SqW88rkRGCvgS5fIYiEa8N
         c8sg==
X-Gm-Message-State: APjAAAUDKA2BPDE7O8AYFV81guVyjUbxXlNwoXEGCPk5sGzTrTIAr1K2
        Wx7ASYp+eYzm9eBbl+7AUF+/3f+i
X-Google-Smtp-Source: APXvYqzfdX6Nr0UQaN1zBOiZOewHimaxR1Qiwg/YBN515XAFnaGsWFHpaGnvxDxpDgStPoXRKAaUrg==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr3391968pff.256.1572622483833;
        Fri, 01 Nov 2019 08:34:43 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a29sm10531303pfr.49.2019.11.01.08.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 08:34:42 -0700 (PDT)
Subject: Re: [PATCH 3/4] aacraid: use blk_mq_rq_busy_iter() for traversing
 outstanding commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191101111838.140027-1-hare@suse.de>
 <20191101111838.140027-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6c70be12-cc58-1c69-beed-f9cd8ef65269@acm.org>
Date:   Fri, 1 Nov 2019 08:34:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101111838.140027-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 4:18 AM, Hannes Reinecke wrote:
> +static bool synchronize_busy_iter(struct request *req, void *data, bool reserved)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	struct synchronize_busy_data *busy_data = data;
> +
> +	if (busy_data->sdev == cmd->device &&
> +	    cmd->SCp.phase == AAC_OWNER_FIRMWARE) {
> +		u64 cmnd_lba;
> +		u32 cmnd_count;
> +
> +		if (cmd->cmnd[0] == WRITE_6) {
> +			cmnd_lba = ((cmd->cmnd[1] & 0x1F) << 16) |
> +				(cmd->cmnd[2] << 8) |
> +				cmd->cmnd[3];
> +			cmnd_count = cmd->cmnd[4];
> +			if (cmnd_count == 0)
> +				cmnd_count = 256;
> +		} else if (cmd->cmnd[0] == WRITE_16) {
> +			cmnd_lba = ((u64)cmd->cmnd[2] << 56) |
> +				((u64)cmd->cmnd[3] << 48) |
> +				((u64)cmd->cmnd[4] << 40) |
> +				((u64)cmd->cmnd[5] << 32) |
> +				((u64)cmd->cmnd[6] << 24) |
> +				(cmd->cmnd[7] << 16) |
> +				(cmd->cmnd[8] << 8) |
> +				cmd->cmnd[9];
> +			cmnd_count = (cmd->cmnd[10] << 24) |
> +				(cmd->cmnd[11] << 16) |
> +				(cmd->cmnd[12] << 8) |
> +				cmd->cmnd[13];
> +		} else if (cmd->cmnd[0] == WRITE_12) {
> +			cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
> +				(cmd->cmnd[3] << 16) |
> +				(cmd->cmnd[4] << 8) |
> +				cmd->cmnd[5];
> +			cmnd_count = (cmd->cmnd[6] << 24) |
> +				(cmd->cmnd[7] << 16) |
> +				(cmd->cmnd[8] << 8) |
> +				cmd->cmnd[9];
> +		} else if (cmd->cmnd[0] == WRITE_10) {
> +			cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
> +				(cmd->cmnd[3] << 16) |
> +				(cmd->cmnd[4] << 8) |
> +				cmd->cmnd[5];
> +			cmnd_count = (cmd->cmnd[7] << 8) |
> +				cmd->cmnd[8];
> +		} else
> +			return true;

The above code looks very similar to the code in scsi_trace.c. Although 
SCSI LLDs shouldn't parse CDBs, there are a few SCSI LLDs that do this. 
Would it be worth it to introduce a function in the SCSI core that 
extracts the most important fields from a CDB (LBA, data buffer size, ...)?

Bart.
