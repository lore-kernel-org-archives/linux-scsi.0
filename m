Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6491EC18E5B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C03521D56
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 14:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgCKOC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:02:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35434 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729646AbgCKOC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 10:02:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id 7so1274673pgr.2;
        Wed, 11 Mar 2020 07:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KLtJmXhCIzrNkvAdjsvCjhryZc8RxSTUaj1Utezcg4w=;
        b=Ul/Qi53HauxzhwgPCTYwXJ5mV+gpqp+w7OlTlqBFJLkGfD4XnD0PRqpyAZxsCFimZI
         H6I3+d3M3K5i6dxVBQfMMPzAKrZWUW2MM+TNS0e9jHUU/h9NHfuDAxOO/u7grHRFQ85K
         Hw4v37vXOntYmAiwAJx2ixbZQjKiHHDC9cltftZC7t8AV2EymBhIWC/DBfAqRJEkO58B
         EDNdnChnZgmLgS4xzjbJ8kyEf1c3DZILjz0BbVr29S+c7X4xKsj0u1SIYyMGEHqGtPI4
         zuL7S4/iIxDssk7xrNY5aiLnPvCfyuWeX4LUY9qJBb5WmLx8Ra3cVVihEDJWTOxbFq76
         qLZA==
X-Gm-Message-State: ANhLgQ2Pd0007nsL8qlkIrbOlKwtT4fxKQ0Ey223IdPk6G2XDGx7lbjj
        HgyBZwCxL1t0sPrKFfM2cvu5d7M1
X-Google-Smtp-Source: ADFU+vsM1mSTO9fsERSzVPJY4Zav1t/67hGUP2jF0REJxK+KfcAyl4/qSyv2hDMWOAKT7jFhIhr87Q==
X-Received: by 2002:a63:af58:: with SMTP id s24mr3006593pgo.15.1583935377149;
        Wed, 11 Mar 2020 07:02:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:af99:b4cf:6b17:1075? ([2601:647:4000:d7:af99:b4cf:6b17:1075])
        by smtp.gmail.com with ESMTPSA id 63sm11193597pfx.132.2020.03.11.07.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 07:02:55 -0700 (PDT)
Subject: Re: [EXT] RE: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core
 allocate per-command UFS data"
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200311112921.29031-1-beanhuo@micron.com>
 <SN6PR04MB46404175998962B4FA575824FCFC0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <BN7PR08MB5684DBAD57C95A40CB62B24ADBFC0@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cfa5b0c8-1ca6-5d1c-591b-67e783d979fd@acm.org>
Date:   Wed, 11 Mar 2020 07:02:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684DBAD57C95A40CB62B24ADBFC0@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/20 5:53 AM, Bean Huo (beanhuo) wrote:
> Hi, Avri
> Do you want to revert all or two (scsi: ufs: Let the SCSI core allocate per-command UFS data,   scsi: core: Introduce {init,exit}_cmd_priv() )?
> Because the patches "scsi: ufs: Simplify two tests" and  "scsi: ufs: Introduce ufshcd_init_lrb()" are ok to me.
> No problem keeping them. Just this one "scsi: core: Introduce {init,exit}_cmd_priv()" is not necessary, since no drivers it now.

I agree with Bean. The other patches from the same series are small and 
easy to review. The SCSI core patch has been tested with other SCSI LLDs.

Bart.
