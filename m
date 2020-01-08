Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5880C282DD
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 22:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1862073A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 22:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgAHWxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:53:17 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36168 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgAHWxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 17:53:17 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so2356973pfb.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 14:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k7N5jmHVyr4AqAdSJabxN8M3MyPNBBSzg3NQjy5FzsU=;
        b=gVzDgAgZpZ4n0TLxoCWGtv9QZ/fjgsQbxvvFrs9fwBrM+yBl18IroAigMHZSwDJ98w
         ptt3odBhtXT2mMesfoYothD3rAIyjOCCeAO5AX0nurPPl9soflPSOEl59PZKwu94WQFr
         d7oj+XyJeHL9e+ZcAFwuS6la2O1QtkRsvc0lv4m+ebnFJAryYvuZlSeaQL/YCujtxOvc
         SrUPHEIlXZ+4juyXHo4VV9PgUHvLEjGO1RjQDop9Xf4mLTNaFhU+MX5fKEkQLx0lQ/8d
         69cvzrp9aypKu1nQPrpiKZOT/IL+bB9FSgje/gSuzNR0e03snX3e/y3zKd9H0AkOkD6Q
         6q5A==
X-Gm-Message-State: APjAAAVkzsk83ehKgcEUqbnXKBeEcOun6EvqU2PgyTzXXqZmHpySDe1C
        Ho0Du1BNRYhxuGdU5wAfVHc=
X-Google-Smtp-Source: APXvYqzTGqFeKqKXLRS1M2TCDwgGKyM19JkeZfvAwpYNoGe98IkYfTkXXkJ0TCUHZL3e5/WmH3+smA==
X-Received: by 2002:a62:b508:: with SMTP id y8mr7671598pfe.251.1578523996531;
        Wed, 08 Jan 2020 14:53:16 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id i11sm339180pjg.0.2020.01.08.14.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 14:53:15 -0800 (PST)
Subject: Re: [PATCH 0/4] ufs: Let the SCSI core allocate per-command UFS data
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <MN2PR04MB699136BA44E4A11A606460E4FC3E0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d894ef4f-e506-74c1-4afd-5deb3437b6df@acm.org>
Date:   Wed, 8 Jan 2020 14:53:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB699136BA44E4A11A606460E4FC3E0@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/20 5:14 AM, Avri Altman wrote:
> Aside of a mere simplification - is this change has other objectives?
> I am asking because at the end of the day not sure if using scsi privet data for the lrb is obtaining that goal.

Hi Avri,

Thanks for having taken a look. An important goal of this patch series 
is to optimize the UFS driver. This patch series should make the UFS 
driver slightly faster because it removes several pointer dereferences 
from the hot path and because it organizes all request-related data in a 
single contiguous address range.

Bart.

