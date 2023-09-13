Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231D0EE3F3F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbjIMBr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbjIMBr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:47:27 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347A810FE;
        Tue, 12 Sep 2023 18:47:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-57756115f08so2493042a12.3;
        Tue, 12 Sep 2023 18:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569643; x=1695174443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=69G7PEjFwdWD8Q6GENETh1J5Ic0tIjeADOdt+e679yY=;
        b=V5QTk+KePWiT4LnHPl7JlrEJFNcRz3l0tQWKjjc4IqeWDssJWzaE5IpuXZlukFKlNK
         6s7CHF0fn61t26FwoZxBbAq4D+FE0oUd6RgNpaRG+bUaILlTJjHlFTzbcTEZA2n1Jt/W
         Ni23QB4jHMQeSpZRc2+9XQuiPEOE8xKEX/LGPkF7OKBVkOEUPPuHAkCFAERNSgUCp8Wc
         eAWKVILQLlrDBJQjV7jxvG5Im5P6uGFjn86MV3wM9/OaIBYYG0Ls03Yx26UlRsiI/fLw
         gUjDOVfy0a99bQCgZLFkRzhDovQTmhaS9FJHhSnrQE39JjrzuEqlWaHXeGrBOGyyQyWq
         Q76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569643; x=1695174443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69G7PEjFwdWD8Q6GENETh1J5Ic0tIjeADOdt+e679yY=;
        b=xT5PSZ0ImsB3bxu7zh9ZcIh5i6fUnI3XgcfEnBLJTWL92btRnBppwJUkVOODJWxySz
         Tp03VYtjz7iGnjt+e5/8Y+4ebML+wK2H82R6T9nYDWKHmG+2OFCEGorLUwFPV2INtKO+
         X+08wpYqfvXd9Extr7CgTo7rYnhxJJN4Y0+26h0TU5rRgdaNenBvBFLLANY8ChFl+xSD
         t79I4p3VMsu8nxJU6Ej5mIax/9+u9/SiuA3FKOOjluUXFuhC9HkLMG0915yJp9UXnkoR
         BPdbhHjHrXVTbHcp2tY0seVF+SDDjNNi5JI51oTpu1gIhjMVYYIlqhu2btJdUEhwL6wG
         0lDQ==
X-Gm-Message-State: AOJu0YyuXwx79KgQXmhGhBV7h/Gr70Ir5x+btpcBQQ+Z68x/b7mPjhEc
        AfITTzdWjaMlOr5YCGX6/nc=
X-Google-Smtp-Source: AGHT+IFIZG2bsiGa/32bTwpGacklpCIox8DomAR311YzMRrGthyQHxBSR24AtRspvhGALtF48oHmgg==
X-Received: by 2002:a17:90a:d98d:b0:26b:c3f:1503 with SMTP id d13-20020a17090ad98d00b0026b0c3f1503mr991014pjv.17.1694569643623;
        Tue, 12 Sep 2023 18:47:23 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id h15-20020a17090a604f00b0026b3773043dsm241932pjm.22.2023.09.12.18.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:47:23 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:47:18 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 12/19] ata: libata-core: Remove ata_port_suspend_async()
Message-ID: <ZQEUpgCIss7msLlZ@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-13-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-13-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:10PM +0900, Damien Le Moal wrote:
> ata_port_suspend_async() is only called by ata_sas_port_suspend().
> Modify ata_port_suspend() with an additional bool argument indicating an
> asynchronous or synchronous suspend to allow removing that helper
> function. With this change, the variable ata_port_resume_ehi can also be
> removed and its value (ATA_EHI_XXX flags passed directly to
> ata_port_request_pm().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
