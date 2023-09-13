Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E939EE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbjIMBnr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:43:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E5C10FE;
        Tue, 12 Sep 2023 18:43:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bdf4752c3cso45431085ad.2;
        Tue, 12 Sep 2023 18:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569423; x=1695174223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ixcBjWybbozkvti+xSs6ChEuyizwDJvsKhmgMBPWy4=;
        b=qmmdsfZBC81EShApMeOgewEwjAY0y5LP4cvqlfQeBstorqMvKN0vdCcv6dElq+f+g9
         weXEcXrCfzrfP5A2ts4QskNlNNzWZ3G19gtsWJIkde0FHVBOGcPp1x64ua4WlToOSPiw
         RbnbvVL4eiUttp582lE0ExDuVR4LMu8XHpdR7+sSEhRZ6UDJjVQ7S4EAxajOyIlY/e0M
         p4sYMuW+EgTzOeJnCVTyAkOHtGY8cpHNI2s34SR66Awoi11LSXLyRPDly3My2JY4o2Fk
         tNQZ5uqpfdJOnTZO+n/jQOBN2ngga9scafI1a4GYa/LG1yrQ1VAQZyHlSGiIPsWP0JtZ
         YfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569423; x=1695174223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ixcBjWybbozkvti+xSs6ChEuyizwDJvsKhmgMBPWy4=;
        b=bFu0uw47Q3/wUQ1ljNIPJXU0+TBe4Bidt8DwGu5rCEtJhc/Xd+DWxWlM0vx7bhsrVM
         SRvHvpyDm2XDrE15EVfQKTcTYSo+uU9vt4jmQvCQJqPwtsyPZDqPdVuQYFqIRpggOB1N
         lRoEfHuWRBEEDdyQEn6/L8oIwKCp7d/unbWC4UzhhHbJijatPHZnQVerDYHRGvba7p8v
         xrqmHWAK5M+Nfqcbr7m1ccjU2BC2Prny6ZEbdmdHbKF2URUG/5AkXHWjbU5WCY6plCkv
         QHUDuEOPmXJM5TbaE/SuPCWP5iTjzIhbJnGca+VNsbFXINwjGsM1mAJ3VrwES5U5TWlk
         gycg==
X-Gm-Message-State: AOJu0YzYYlOSEbjS/2SScygXZRtyz/lzAg/2d8OYcvV8G9d/05MLX6No
        7LOWuaNfSlDYamYbToBSAYA=
X-Google-Smtp-Source: AGHT+IHozvJC4euUPKRlIhqYLBwXDny0FjsdDzazzTNn3C2f74wT/WEev3YWJ2d/sZzhLMfNwVyxoQ==
X-Received: by 2002:a17:902:7fcc:b0:1c1:e7b2:27ad with SMTP id t12-20020a1709027fcc00b001c1e7b227admr1286766plb.60.1694569422803;
        Tue, 12 Sep 2023 18:43:42 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902e98d00b001b8af7f632asm9182304plb.176.2023.09.12.18.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:43:42 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:43:37 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
Message-ID: <ZQETySHg2wWufWsO@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-4-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:01PM +0900, Damien Le Moal wrote:
> There is no direct device ancestry defined between an ata_device and
> its scsi device which prevents the power management code from correctly
> ordering suspend and resume operations. Create such ancestry with the
> ata device as the parent to ensure that the scsi device (child) is
> suspended before the ata device and that resume handles the ata device
> before the scsi device.
> 
> The parent-child (supplier-consumer) relationship is established between
> the ata_port (parent) and the scsi device (child) with the function
> device_add_link(). The parent used is not the ata_device as the PM
> operations are defined per port and the status of all devices connected
> through that port is controlled from the port operations.
> 
> The device link is established with the new function
> ata_scsi_dev_alloc(). This function is used to define the ->slave_alloc
> callback of the scsi host template of most drivers.
> 
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
