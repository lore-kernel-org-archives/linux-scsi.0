Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B96AEE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbjIMBrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbjIMBrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:47:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F022610DF;
        Tue, 12 Sep 2023 18:47:44 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1c364fb8a4cso57456185ad.1;
        Tue, 12 Sep 2023 18:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569664; x=1695174464; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yb/7M88EYCwJf1t6Gg+ZiqyACQNnw+eX2EFwxbmR27A=;
        b=GAUsR6kadPYtzci7Fk6WOCLS2C8J759dTTJYyO35x5DJ+8wvu6GJDnrqVngNnn8X16
         sxPNGvQzpQWrdsgIT/tFoV/L7tW0qEpzZcjIrG8s+T1hRD1BY3j1sZTAC7xL2YoDvwwg
         uw1NuQmabDVrpn3QCSsjMUjCbnr4f3f1huxJmGghPn04xafPcBMgS5W3g0g1cX4I5GtI
         tRJ1x/lD+nDgxrCDgXsU+S4q6t7w64X0lH9vWK6gpJbs5L8PBoI7B2pCrqrQ1FoIJck4
         F0eON4hWmWXHTWTp70i2sDwERqMbCEcF10PU03iXdPVe0ZjbCbjH5vEcWfJ21qi7dd+L
         2QMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569664; x=1695174464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yb/7M88EYCwJf1t6Gg+ZiqyACQNnw+eX2EFwxbmR27A=;
        b=l5cpUobTC0/uILxe1mtBG65bDqw2Rq4m654o99GvHtJEizH6w4w5vcfOrXddb6LDJu
         F9/kS0jSOXJTj0eEO9LSFVbos24YisSonRO4yuFmuYNa7hurlxPE7K4NW1dmoi8QXk5a
         x2o0nxhRedhe9XFT1aB7v7nMYWemJISTQgEZRyas618TwwRIXmtPZgRhKftMv4t2iRWy
         Jgv4akfn9OCBM34Y3lRz9teA0oylB5+Z/WwVDIcYOIZbjlmfFUpUTRDdFqdmm0BD4mlh
         0GPgICHeTfV2xp9I6p0kFDKk2rDRq+3WR852Ct6Cm47vPO6sOHbYnvfwFxiwh8sB5nTI
         ImXQ==
X-Gm-Message-State: AOJu0YywW5wUYGlxt7iXkK9+o7nQ9JHInMvwPowVU1XMj0CKOgi3Lttm
        Z2bTlDLwvZHft2hdvlUBO+8=
X-Google-Smtp-Source: AGHT+IFm4SuC79joazWz5T00/Crv5PM7P/Rh6rEEDbIWEseJLVMzYjzcImxRoTr0MSvpXuARiIu6nQ==
X-Received: by 2002:a17:902:b289:b0:1c2:584:51c8 with SMTP id u9-20020a170902b28900b001c2058451c8mr1338077plr.12.1694569664340;
        Tue, 12 Sep 2023 18:47:44 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id i11-20020a1709026acb00b001b9de39905asm9130543plt.59.2023.09.12.18.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:47:44 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:47:39 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 13/19] ata: libata-core: Remove ata_port_resume_async()
Message-ID: <ZQEUu9I19toy5wxZ@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-14-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-14-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:11PM +0900, Damien Le Moal wrote:
> Remove ata_port_resume_async() and replace it with a modified
> ata_port_resume() taking an additional bool argument indicating if
> ata EH resume operation should be executed synchronously or
> asynchronously. With this change, the variable ata_port_resume_ehi is
> not longer necessary and its value (ATA_EHI_XXX flags) passed directly
> to ata_port_request_pm().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
