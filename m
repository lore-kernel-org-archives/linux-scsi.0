Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD2FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E849561929
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbhKPQLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:11:19 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:33711 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbhKPQKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 11:10:38 -0500
Received: by mail-pl1-f175.google.com with SMTP id y7so17939382plp.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 08:07:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LmCfG1d5ffvYYVCRRzwWXy4AhDnnAAkZeUNA8BespFs=;
        b=LUhvxzloa9hWFjQu27303LLbCb5lOiyx14ngte7H+hk4wHeciJAaCuYPO8ypv7epMD
         Ld0F/OrpCVNnkUUbZqfkRmrfbAJhD0y3uJZnnIhD/4ZjZU3UvewNOHgS2LsV84qGh4Mh
         nrSkphIjKoSR3OozaXMYg9orut2ftFFC49DkcbWIpPY5B22hEsl2aLSoXWMXp0jS0r5R
         6aOEgzcgjmWQ+0TVkZ0X3FCtp6PHJw2F6EH6tOQQ2lAOguuNUEAil7rqQSt5YeYtqGNr
         YN8rl9ojW8SO88Do3atmNQVlRrLe+uPFb8yzNbq6Dk7ASgRcNge61Y223mIgm9k3OYpH
         9u6w==
X-Gm-Message-State: AOAM531kxSmHQECYJ3nP3SuXnaBPch1JBHh5MNBQi8oZnLLcNReESVl3
        kwmJWIc/AgikAoGTIpCeC7U=
X-Google-Smtp-Source: ABdhPJyAKERT7sd4IwB0yyG1txYIIJzmyP7HUM4NjlaEuT5v/qO2+BkKgo8678pkpK5tEfK9Xi4D4Q==
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr147713pjb.220.1637078861284;
        Tue, 16 Nov 2021 08:07:41 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p1sm21472348pfo.143.2021.11.16.08.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 08:07:40 -0800 (PST)
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
 <aac7b8c8-7474-4317-c342-1714cc61a331@acm.org>
 <985b86c5-e45f-8d07-31e3-7eed1c7c894c@intel.com>
 <9ebeec91-ff62-3dcd-a377-1d6f98bd7c32@acm.org>
 <4829b1ab-9f33-7189-3b72-a65250552e54@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b5da3b85-e86c-0025-f566-9e807701a217@acm.org>
Date:   Tue, 16 Nov 2021 08:07:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4829b1ab-9f33-7189-3b72-a65250552e54@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 1:03 AM, Adrian Hunter wrote:
> One perhaps unrelated issue in scsi_times_out():
> 
> 		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
> 			return BLK_EH_RESET_TIMER;
> 
> Shouldn't that return BLK_EH_DONE not BLK_EH_RESET_TIMER, since the request has been through blk_mq_complete_request() ?

I think so. I will submit a patch.

Bart.
