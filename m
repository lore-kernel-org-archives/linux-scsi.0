Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DC1C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DCF63509
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbhKOScq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:32:46 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:40942 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241788AbhKOSah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 13:30:37 -0500
Received: by mail-pf1-f182.google.com with SMTP id z6so15799229pfe.7
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 10:27:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gyiJwSeUrIoCepym1YAOUtLeanoLUac2GiYqRIZZa88=;
        b=OYfoAvwBDiBDX/egUlBp+49wQwV/XOsRvksE3H1iivFWVwgyPkRTAPIMXdfSTSFKth
         TB6m+M95m+Wba/LqDieipXtkVPqgLxLaY8IbEO4Km1Xa7iBHWmEi8JnunVTHPr7yFryx
         bdrLaxLUHU/kTWeBaHZZ+Qb4Wb2z472gctNrwEv/SNek5u9b4KLp6g8oEDq0zrb2bIPb
         /ln4u77j8w5lMl/Qf4WkX5DckoNmnpROPILyrPCmmbvV9EX5c4Ys/IRYI+z3H+ELv+g5
         jVyoyBQE2C7lg2G+MrpniRzXbdHko25q2i4Ck1EwvBNIReq4yqL5AC5TGet54pTXKaTu
         Kohg==
X-Gm-Message-State: AOAM531PlgnbBcxAwDieteBEIw7TTMjcMibbc5RQlxsNIiGf3+Z9P1VA
        rGuv4Z1CNW/fmcZE+rVh58dolJbZzQNHcw==
X-Google-Smtp-Source: ABdhPJxoxHXZLEf8BG0yROHSa10OYjeUMIUi19RwZdLi4Wr0Qw3VB1PzG/iEyoPhLbx20DxwWON6mg==
X-Received: by 2002:a62:ae0f:0:b0:481:7fe:c719 with SMTP id q15-20020a62ae0f000000b0048107fec719mr35497560pff.14.1637000861892;
        Mon, 15 Nov 2021 10:27:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id ls14sm48871pjb.49.2021.11.15.10.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:27:40 -0800 (PST)
Subject: Re: [PATCH 06/11] scsi: ufs: Rework ufshcd_change_queue_depth()
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-7-bvanassche@acm.org>
 <DM6PR04MB6575DE9B188092CBE7A893DEFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3e62af92-529f-d2b3-2332-b8003b6f8864@acm.org>
Date:   Mon, 15 Nov 2021 10:27:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575DE9B188092CBE7A893DEFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 11:22 PM, Avri Altman wrote:
>>
>> Prepare for making sdev->host->can_queue less than hba->nutrs. This patch
>> does not change any functionality.
 >
> ufshcd_set_queue_depth() may also needs similar adjustments?

That's a great question. I will modify scsi_change_queue_depth() such 
that it limits the queue depth to host->can_queue.

Thanks,

Bart.
