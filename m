Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6CBEE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbjIMBti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIMBth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:49:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0BABE;
        Tue, 12 Sep 2023 18:49:33 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68fbd5cd0ceso2499321b3a.1;
        Tue, 12 Sep 2023 18:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569773; x=1695174573; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+75F0J9tRLXf19xaP5XcU1nx/xjl2HCMzyH/CekR/Ik=;
        b=WL+/RDntUm1Inr+9/dI6xzEWu37L8kKFo4p26dNg6eN8tgv80YfQXX8RnB90JtUUhK
         hAPVfdDbDBVy4mq22JtWoPFGPlXe+o3KoL0mvzGrD0dWdOzhwoD9Xill+FXkxxCrnX++
         7Yc+rSLgLHT5SDpScqVjOFTKFyg5kKs54NJb3hFOBYO4sqEd/MKlgEI0KwcQZxKX6Vga
         3cuur/aZM8TVkBGKLZ1T3Bd7BYTNWxyb8Tm6iBaNYQFZHk0dZRBkewKn/pwFRTg45OD3
         otTKAmXzMiLChZ4YoKdWana1n9aXz5BouLQ1SB3JQeE3a1MYTAvh5q7QwMbTYWN2AVjA
         mXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569773; x=1695174573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+75F0J9tRLXf19xaP5XcU1nx/xjl2HCMzyH/CekR/Ik=;
        b=h/VliPbxPPMaELHAGyhgtGYUcGhX0Ii5usfi13/IsdjBvNmbCeHC6Rq3b60Hmam586
         TeJWWbsngw5h4kw8KDIey+Rnt6ntfH1I3yxPIXqKOoCHidzzv3+Tmla9miV3170ctY2C
         OSMkiKniSIPKCjic8JTcvDNReZwlrrTbEoFfgGCKWh+Xpe0j8eoJtZSg5ToeJL+XDMbz
         4KYs0WJyGkT99qY57JJjnXP8Ltg5p9ZhWPsIFeJj4BDsZ2Ezfo1FkhUocBUmgU8H8iPJ
         lh9aQj5uhQ2me7UAaUzrUKzq4Uj+2q4g80oNIFwtOUVEHsq5jydxswPrXGi8wjDGrMyW
         9Afg==
X-Gm-Message-State: AOJu0Yw+aT31ogwii+VIi+dcPWuZtvNrk/aUMRDWPdh7B48NAf1RVD7E
        Py3FMFPdrkAbS+w7rJ1pz8U=
X-Google-Smtp-Source: AGHT+IFg/mNt23AeHrY3OT07r+Of7E8bnOGrfOtmAqItHG+79aTeF295QIxWDXCkO0dtWM1uLMJ41A==
X-Received: by 2002:a05:6a00:15ce:b0:68e:23c9:b306 with SMTP id o14-20020a056a0015ce00b0068e23c9b306mr1631158pfu.30.1694569773124;
        Tue, 12 Sep 2023 18:49:33 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id y19-20020aa78553000000b0068e4c5a4f3esm1795216pfn.71.2023.09.12.18.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:49:32 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:49:27 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 18/19] ata: libata-eh: Reduce "disable device" message
 verbosity
Message-ID: <ZQEVJ63+wWVGCrVx@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-19-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-19-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:16PM +0900, Damien Le Moal wrote:
> There is no point in warning about a device being diabled when we expect
> it to be, that is, on suspend, shutdown or when detaching a device.
> Suppress this message for these cases by introducing the EH static
> function ata_eh_dev_disable() and by using it in ata_eh_unload() and
> ata_eh_detach_dev(). ata_dev_disable() code is modified to call this new
> function after printing the "disable device" message.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
