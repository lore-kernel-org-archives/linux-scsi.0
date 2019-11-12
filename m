Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96802C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78C8421D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLQlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:41:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36214 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 11:41:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id k13so12229701pgh.3;
        Tue, 12 Nov 2019 08:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ybxmXWMezvLhgdDEhiwpfLwWzxv34/V1MC53izwQbWU=;
        b=kMH4bgkXmZnA5DQTf72y0GbZHoGhyvh0vb1Fu2OzovigtU3OTUmGRT1NL0aWsgnL0w
         jucpp/2/IE0hKcmzyXJaTRiUuw6mwRl/n1XxSPVutHNRnf1nxaClQzKrP80ujJJYIBRT
         vdLGhjruaeQvv4cj68q5i0Dn739w3N9BxWpigTXyocgm2El+CS16Z/Kvs6XMsOcFDXR8
         M9vsudkzLXUoyg3AFUCui4FBAZrdO1piPdOHt2DxM4tOcUGH2SHUpaYPX8teYmXucxM8
         ezehPJZuND/W7TBU+q22lvyy4OfB8NBOtPLgTyQWtCtFijePG1Oa6tLEh/+O09v9nEMR
         6Nvw==
X-Gm-Message-State: APjAAAXfmVMN8pQnVu6sykUzy4To6c8Ws55S2bODNNT9VDgcfcB4BLmr
        nBNVpWlnGqe8YQmOr9QTLukUbS+0
X-Google-Smtp-Source: APXvYqzalYzInV0tZcPnsk9ArJqWVcuBbhdGasY1B/CzkF+OlKDBmRejK8+nzwzbB2qmlxd3qzOpYg==
X-Received: by 2002:a63:d901:: with SMTP id r1mr36175093pgg.328.1573576882474;
        Tue, 12 Nov 2019 08:41:22 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p9sm24051231pfq.40.2019.11.12.08.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:41:21 -0800 (PST)
Subject: Re: [RESEND PATCH v1 2/2] scsi: ufs: fix potential bug which ends in
 system hang-up
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <BN7PR08MB5684BD2FEE5153F7AF96F146DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f923772d-2105-e2b2-8503-4e87fd1bc180@acm.org>
Date:   Tue, 12 Nov 2019 08:41:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684BD2FEE5153F7AF96F146DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/19 4:22 PM, Bean Huo (beanhuo) wrote:
> 
> Bean Huo <beanhuo@micron.com>
> 
> In function __ufshcd_query_descriptor(), in the event of an error
> happening, we directly goto out_unlock, and forget to invaliate
> hba->dev_cmd.query.descriptor pointer. Thus results in this pointer
> still validity in ufshcd_copy_query_response() for other query requests
> which go through ufshcd_exec_raw_upiu_cmd(). This will cuases __memcpy()
> crash and system hangs up, log shows as below:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
