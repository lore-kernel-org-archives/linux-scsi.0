Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4380CC4D2E3
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802F92477D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfLMUGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:06:41 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45583 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbfLMUGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 15:06:40 -0500
Received: by mail-pj1-f65.google.com with SMTP id r11so162484pjp.12;
        Fri, 13 Dec 2019 12:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QRdsTw/j1Ix9fJZywlz3234qa71GZtf8UOa6MhdtsVI=;
        b=VSJH4T/G1CYgONwS5osDAMFabguC2EUHjqiimBhvYJKPn4SutK8s6igxUKeAs51ckq
         3zC+J7dtRHTb9gftUXaFzkBzn+x6DOXEKYPGf2c0ftMO6mopH0vep6rNwouJo5qu1j7H
         94kXtkaVKgHDHvEurJ5xAIu4SrLQUO++TozPUrnRHaE6qI7/avQ7TRPxqhZnChzQbMj2
         61UmTeeWWnE8TILJ4Ut8hjj4ZMT4Q8TUc7RIer8h4rQ+zCoP+247AA5UFXIrkCQysp5K
         cnnAsX7/eXQjkTQNff6AHo3RtyXg29wEbvoRh4xnHRp2xYyRncBptSiNPA01Ct/x4/km
         ZZeA==
X-Gm-Message-State: APjAAAXG19cO6Uq6eyP2jynAhrFcJcBPfg2OaTdUTI4DhAISs6/YFbVS
        OGQwi+d3OpMPBpZLsm9vC20PG11D
X-Google-Smtp-Source: APXvYqzU+bscPdgRugDu234KsrieabOKgMlgnsf3IJe1OZEd+Q15IAEkZsEleJXRAe0gQkonXvP7CQ==
X-Received: by 2002:a17:90a:86c9:: with SMTP id y9mr1338700pjv.88.1576267599659;
        Fri, 13 Dec 2019 12:06:39 -0800 (PST)
Received: from [172.19.248.113] ([38.98.37.141])
        by smtp.gmail.com with ESMTPSA id q7sm12487540pfb.44.2019.12.13.12.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 12:06:38 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: ufs: Simplify a condition
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>
Cc:     Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191213104935.wgpq2epaz6zh5zus@kili.mountain>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b08b7848-c0da-4438-258c-19ce18fa798c@acm.org>
Date:   Fri, 13 Dec 2019 13:05:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213104935.wgpq2epaz6zh5zus@kili.mountain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/19 5:49 AM, Dan Carpenter wrote:
> We know that "check_for_bkops" is non-zero on this side of the ||
> because it was checked on the other side.

How about also removing the superfluous parentheses? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

