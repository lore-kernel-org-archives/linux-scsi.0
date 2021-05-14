Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1DDC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E92361353
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhENC7y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:59:54 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:43781 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhENC7x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 22:59:53 -0400
Received: by mail-pg1-f176.google.com with SMTP id k15so10399010pgb.10
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 19:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABqkwdtF0v3ONT/LmbUhm9MoXe7AUZgmnfbxuz0BtNo=;
        b=AmDDGCcPeiuU+yWRV6BPntClZJjupKjjChBCRxt8ko3jXJLfWpZpVzvz/RMLLmEaZs
         daSAJYPJ+ZN01CbqbyMabD/IqICtf8iz/0HVvRmzX9VUKsVsznaIdKvk981/1W8KXOVf
         Ms4PVY4IHFvce+yD+llL+F2mzFFFh0QG5ojVNiqp//ppGn7iK241CvYktsueW123JEyI
         ElHCzs0RmAEOywGgBWLpcqEN7ycKyh/O0wesqsCrEpTAZbLFZxfPjwDRnd1KI142cltc
         rCLsipNK31nsxq6tIuCCNxmjkBH39eQBxOSJGPh3dY9U9PISJCYFO3FwGdWbKdBklrNj
         O2zA==
X-Gm-Message-State: AOAM532xNRy6hHgmIwx80RrkvgME3aiT4IqzoakeAu/dbTO7N7nYXBkP
        UaGqLb0+YQaTkq0/qStX/Ik=
X-Google-Smtp-Source: ABdhPJyBeOtOVz8+ZpuciCeFYcMX6khfwE7TlcY+O5lNRQhWcI4XLiQ7+wzNLEjVQzrY/t8ssHaaDA==
X-Received: by 2002:aa7:839a:0:b029:27a:8c0b:3f5e with SMTP id u26-20020aa7839a0000b029027a8c0b3f5emr43152747pfm.69.1620961122597;
        Thu, 13 May 2021 19:58:42 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:53a7:2faa:e07b:6134? ([2601:647:4000:d7:53a7:2faa:e07b:6134])
        by smtp.gmail.com with ESMTPSA id j7sm2910220pfc.164.2021.05.13.19.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 19:58:41 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] lpfc: Use scsi_get_sector() instead of
 scsi_get_lba()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        James Smart <james.smart@broadcom.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-6-bvanassche@acm.org>
 <DM6PR04MB7081541366E8AE3E7E833E43E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b31cc92-d29d-f1a1-a59f-4b16773f4039@acm.org>
Date:   Thu, 13 May 2021 19:58:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081541366E8AE3E7E833E43E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 7:00 PM, Damien Le Moal wrote:
> On 2021/05/14 7:38, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
>> index eefbb9b22798..8c6b25807f12 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -2963,7 +2963,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
>>  				"9059 BLKGRD: Guard Tag error in cmd"
>>  				" 0x%x lba 0x%llx blk cnt 0x%x "
>>  				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
>> -				(unsigned long long)scsi_get_lba(cmd),
>> +				(u64)scsi_get_sector(cmd),
> 
> Why the cast ? scsi_get_sector() returns a 64bits sector_t.

Right, the cast can be left out. Commit 72deb455b5ec ("block: remove
CONFIG_LBDAF") changed sector_t from sometimes 32-bit / sometimes 64-bit
into always 64-bit.

Bart.
