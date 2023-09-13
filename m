Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B18AEE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbjIMBlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:41:43 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D9C115;
        Tue, 12 Sep 2023 18:41:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fb898ab3bso2476405b3a.3;
        Tue, 12 Sep 2023 18:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569299; x=1695174099; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J3TiZZxRrL5FeayA5WgvfzkXcjWq/B5bue3/NTZ/Lqw=;
        b=OwoqWVhAIw0kEceV5WavZ/cR3Y24JKYdA9fKLfCeeB9U+HJ8raLqtoJ5HtbOITFkW2
         sdPsA6C9lHnFcb1MhJXoxYzZLza+BX7Gb/5F21W+/QLpojxf/ZVrxsebz998LOD1xGa1
         mlvafead3h7jYAi0Tj9ljaD37PAMw165cwYyj+njudlFCqXQ5QOoZPUvrbyQmHNCQb9P
         gE1jp1xE2oQxdd3ZRIFtceXvLTBkNpTJw2oFfNBjp+TPHD4YjfeRVWEHwW6OlFAzFW4x
         kLZ2+9lg1mxgUuNBprIfWax1z53zNefyh6CFYeDy1OdH3LDmoHQwcLoF2RGCbA/ZIvOh
         rwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569299; x=1695174099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3TiZZxRrL5FeayA5WgvfzkXcjWq/B5bue3/NTZ/Lqw=;
        b=LJh1HuNesh3luI4JMqAOtmjcwlmaMqC0cNddKltaZE9AQPkMPu9NQw4J50XEKpV9N4
         Kur1HMb+DEp+Gk2z1cxdX9EvLoe4waPJzrLz1ABUg3GK/Cc4yTrqdfOc0wo3gnOPcHBk
         hpXU0RuAOxhWWGo0+4Vva7rqCss7FR0zftoyGkbI1xFbT2fvg/8p+RGG8b3wILayEsNt
         spw04ZaH/NFuZn0dTbShhYiMM7fzdcjv9zDYXgr0FrGYp6OqdVM6EYgzAPN8MVxez4z0
         zE4g2LE+G1X+ahzhKgl5F2gw+GvxFIlnEQW9WU/1RIsXgDDqnXgLS+S2cKHOeW5BPuXo
         2tQQ==
X-Gm-Message-State: AOJu0YxCqu6t/z7UjYH7vUFEE+gYulczZqh0D3ODdliiuWbNab+lbpcz
        S+qsNVHQ2qGSvuA2GMscM50=
X-Google-Smtp-Source: AGHT+IFkvkZw2CJqgCgx4HW9BQxOSdaw8KY66Nh2rbBvbLzcYF+InDUwCXvrWJTr4apIx62bbXlcGQ==
X-Received: by 2002:a05:6a00:1505:b0:68b:fb93:5b48 with SMTP id q5-20020a056a00150500b0068bfb935b48mr1992300pfu.18.1694569298922;
        Tue, 12 Sep 2023 18:41:38 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id j17-20020aa783d1000000b0068c5bd3c3b4sm7935870pfn.206.2023.09.12.18.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:41:38 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:41:33 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 01/19] ata: libata-core: Fix ata_port_request_pm() locking
Message-ID: <ZQETTbJiY70pQjCw@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-2-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-2-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:01:59PM +0900, Damien Le Moal wrote:
> The function ata_port_request_pm() checks the port flag
> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
> ensure that power management operations for a port are not secheduled
> simultaneously. However, this flag check is done without holding the
> port lock.
> 
> Fix this by taking the port lock on entry to the function and checking
> the flag under this lock. The lock is released and re-taken if
> ata_port_wait_eh() needs to be called.
> 
> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
