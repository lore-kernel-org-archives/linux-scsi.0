Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18A8C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65F7B222BD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLQvV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:51:21 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39783 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfKLQvV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 11:51:21 -0500
Received: by mail-pl1-f196.google.com with SMTP id o9so9638042plk.6
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 08:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zZeDPhEBKkSutEVnYbBuj2XR2BoFk/Xvk7+F5VsGE8s=;
        b=S2g/IOp1bvRGw00T1yPCc6YT8Y0J4vABq2zhk81aVxWgECeFbQLbNoK6OJcrQMaHoL
         w36KIVJEH00r2hlQa67Xyf06D60hxBa3UXtSQGU2Yv8okecjYbgHfVG89rkkaIm9BsQw
         KoyXTxWwmFqu24ZG/k6D8d7umhYCbUSM3yqH99l07bvg76xckofFonuEBDcWH2eH2FP0
         dDtKk0nX/RBy9mVM8sfG8bTOq7jDUpdGcBcpVdUNealA+DZ+kHuRDlhJUnYGdrR1rAS/
         oSF+5d20g4UEzrxtNCol0fWZlz72HLonYiGFBuZFA/qA98r0+uWX4+wMZt3twSGx8m99
         9jpQ==
X-Gm-Message-State: APjAAAUxL2QS6lXscEoNByjg37A4nG/LQdGW4AvyGQ/lsbiFb7SL4SIq
        S6+12UWAKOeYvmJS4cxdGd4=
X-Google-Smtp-Source: APXvYqyAEWoiz2F/2Tn+AXW5E18jx9OGpJx1abrhA9fxknmtXMJiNxrjVDF3kVyj8z0t1FNyNxIJWw==
X-Received: by 2002:a17:902:a512:: with SMTP id s18mr30394396plq.99.1573577478711;
        Tue, 12 Nov 2019 08:51:18 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w8sm17489473pfi.60.2019.11.12.08.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:51:18 -0800 (PST)
Subject: Re: [EXT] [PATCH v4 1/3] ufs: Avoid busy-waiting by eliminating tag
 conflicts
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191111174841.185278-1-bvanassche@acm.org>
 <20191111174841.185278-2-bvanassche@acm.org>
 <BN7PR08MB5684739C6BEC8C5D7E4A0223DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b7765122-32fb-aec0-702c-f66119dc9069@acm.org>
Date:   Tue, 12 Nov 2019 08:51:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684739C6BEC8C5D7E4A0223DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/19 4:25 AM, Bean Huo (beanhuo) wrote:
>> +	err = -ENOMEM;
>> +	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
>> +	if (!hba->cmd_queue)
> 
> It is possible  to return ERR_PTR(-ENOMEM)  in  blk_mq_init_queue(),,
> Here just checkup if not NULL is not safe enough.

Agreed, this should be changed into an IS_ERR() check.

Bart.
