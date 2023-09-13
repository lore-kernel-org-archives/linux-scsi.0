Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4B0EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbjIMBsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:48:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ED310FE;
        Tue, 12 Sep 2023 18:48:28 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fbbea0dfeso2450089b3a.0;
        Tue, 12 Sep 2023 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569708; x=1695174508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7l7Ooi75LNlR51lsin0vDW3Nn/mJ6yO9QYMhDBt2yU=;
        b=AZh7oYs3ZJ1QIaH3TQCi/4QV2TS1GOmeNdSrH0d1c7neCtn16AngcVRhf7myf4OsEU
         LpeUyQuTkNAP1f5ME9kARGruEanBy0K+nn1NT4pGB+XOUnnxGAnagwbMuRKnCbe6sc3+
         WkkIKOxmbV9N8K8vCmync3YRS78W7KJinZmdHKrk98A5W+cbs+pIMaVMPrjgQ84FKi9R
         b1mOS1RaED709xRZjXQ//Lr1vxBgbX7X6OY3tyuuOLCWAprXaxxAqKDxcRphAQaaw+Ko
         zM6u0J8iOazkHQbmvW2PY/ulrG6Y/pKsMLosR/+fKdSdaJzG9rGnGgtm5E39LazCMo3c
         3WxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569708; x=1695174508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7l7Ooi75LNlR51lsin0vDW3Nn/mJ6yO9QYMhDBt2yU=;
        b=uRlBBT4rKDuqGW7ZDwvgaBOPIWvnCoZWoC0ZOmB0emAYczPtuaYm5TmFLp/ghRzs7l
         1GJj+5/PC+Sd8B4kxNYrUSCp1oH5Z6la2T8E1IFbSzdOAPEydvWPS7MGRaqn/gxuVgRx
         O0zhATisnKPVvMU0Ui15YBQRYIBiFiEyc9AuEe3fwW0KlkrOga35+NbAS+W1DZZ67MC/
         a4cojhYjJ6IYxVEBYutgXCK1QPxXHTyPgWKORdzzNnvJ3Rs9PpiaOzcyb3qQ+Vpuk5TW
         oRsY9dZl5saagnxfgQB2McVReBl9d3jGZ7vXzXW228fKf63jcbXxka7ctmVSgnk3EhiR
         tCQQ==
X-Gm-Message-State: AOJu0YwCYK9IX9bHauDgO0B0UhDS23luWRMyz7O3dJoHu6h/2ODru+Mt
        WdyPf9ZZIBU1nyJS3a8by2w=
X-Google-Smtp-Source: AGHT+IE92maXvWvJmdgu0rm3uZHsUeXafd7Pv6+IYlsWnBEU11HPz+au2Ij7jLp+0fDB/qbV3BDjHw==
X-Received: by 2002:a05:6a00:238c:b0:68e:3f0b:5e6f with SMTP id f12-20020a056a00238c00b0068e3f0b5e6fmr1519587pfc.24.1694569708438;
        Tue, 12 Sep 2023 18:48:28 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id w20-20020a056a0014d400b006862b2a6b0dsm6033931pfu.15.2023.09.12.18.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:48:28 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:48:23 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 15/19] ata: libata-core: Do not resume ports that have
 been runtime suspended
Message-ID: <ZQEU5/7bkZoiZ6uI@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-16-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-16-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:13PM +0900, Damien Le Moal wrote:
> The scsi disk driver does not resume disks that have been runtime
> suspended by the user. To be consistent with this behavior, do the same
> for ata ports and skip the PM request in ata_port_pm_resume() if the
> port was already runtime suspended. With this change, it is no longer
> necessary to for the PM state of the port to ACTIVE as the PM core code
> will take care of that when handling runtime resume.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
