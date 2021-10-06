Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5188BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 12:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31FD56115A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 12:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhJFMCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 08:02:15 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43625 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhJFMCP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 08:02:15 -0400
Received: by mail-wr1-f52.google.com with SMTP id r7so8021745wrc.10
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 05:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=20aPkRckhHOA2aAVK/kSiWeKKvRSMK2cHLgirPldQ5E=;
        b=Lbd9g8v559i05920r4RRoh6XSnuJGfQNFpCGgvblYKKO1EHpgnOuffnTAxJPgC0YTI
         fLSYfoPRVUOSk1qEiDTXvI5QQ1uMc1u37OS0Uuyfenk3jxqd/o5T7ZY84Qnd2cJa4Z8U
         qjQP73jHv10R4ZBUkRxOJlioYfq2CGLrdnSL7nRm4dwLdCPhdZiQqJX3uUeO3cM4dQU/
         gKrbaSlATd7hLisgQSiqAtLm32I07qmkMCEaCwyT0mjYgxbBxmcndWBESlebi7v92R1J
         wFwbmtSchafQcmuhVXJDepCbTVzNk9d2jN1e9bvTg5n61udDHwYnQ/QxS+l39Ke04OX5
         fNug==
X-Gm-Message-State: AOAM531CLUcUtriBkFrrA7GiXHDV/Uqt5axYJUsJ73J/ftuJj9QtWH9Y
        cqP6RdmHgljNam0KVMLIdXOUhnWPPtE=
X-Google-Smtp-Source: ABdhPJydrJgs61nY1FD8Mmch+rGqrkbTDlbYA16LgpFdizeuADFH43zcQ2YvZxCLeFgMuNH8UFCajg==
X-Received: by 2002:adf:d1b3:: with SMTP id w19mr28384641wrc.152.1633521622314;
        Wed, 06 Oct 2021 05:00:22 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id c25sm2028293wml.37.2021.10.06.05.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 05:00:21 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:00:20 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
Message-ID: <20211006120020.dhop72wlqjanymoz@liuwe-devbox-debian-v2>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-73-bvanassche@acm.org>
 <BN8PR21MB12841C43D1775DACB542A1A8CAAA9@BN8PR21MB1284.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR21MB12841C43D1775DACB542A1A8CAAA9@BN8PR21MB1284.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 05:57:51PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Bart Van Assche <bvanassche@acm.org>
[...]
> Thanks.
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 

Bart, Martin and Haiyang,

Seeing this patch is part of a large patch series, I am expecting
whoever funnels the whole series applies this patch together with other
patches. Let me know if I should do anything else.

Wei.
