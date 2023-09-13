Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA5CEE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbjIMBsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbjIMBsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:48:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C997110DF;
        Tue, 12 Sep 2023 18:48:08 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-27398378997so4552315a91.3;
        Tue, 12 Sep 2023 18:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569688; x=1695174488; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rwbHYl56BU5fxYA8BmdxW+pep6OKZfwFtCgAO7WyD4c=;
        b=b9hDTLcG035lcqLeq2Z0Kbu4GM19e2tw6qGYDunh+a5uP0guXnntoEV3BaxHeNV6hq
         8sOd3EDzGtLe+/4KiG0Pl33npnyq4XTPoAd13rCfoFLr5AYWoJOvnaTasfauOg2KDhHy
         pzyCdmQtR81V3sEQ1PhihrmTY1Dnzp4CalH4IfnaLFyIexe+4sF7fEkv6KB8qbntLnj8
         2BBMhIFNAMp49quRJIAlTljYYJ0xXnOUCix/HkCj6HBDplUxFWPs90G5JWIsbZCdl2jq
         MqFYnJ6jN11HVqsV9B+giaA4OHwzFka1bGm4L9M69WUT+4Vsryn60wa9cIbmTjx5o49H
         ExGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569688; x=1695174488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwbHYl56BU5fxYA8BmdxW+pep6OKZfwFtCgAO7WyD4c=;
        b=ZoCj2dxG2lZJlMZV6myO0PtQy5klRB3mUChiZcWsS/03yWFNwgs3QhYCTWk2Iy919r
         a4H5JUnJNRpeaNQT6HuZ0BpaX3Q3mguzK3+D4DDLtv3PIbH6IIQvkmASlJillTwzcw/U
         mMV4qCHcxCfr3N1pPZgHzOA2PhuAsyyK5PlKWhqgROfir8MZVPU8bTscqkC0yANtXJRT
         YKNdyVeXkB2Dx4rOMhhRYPmb3fxpM+4mRr8YJmrJCIDNxQyzd/d/9SgJT9pX4U8IkI0c
         E49P8rb8lqNXKHSV474GEAGpn6HGc/LTtcVRptNTrUymJjdkbMzkjI1x06ZN+cL7/GK/
         z+Mw==
X-Gm-Message-State: AOJu0YwTdN24ofvTVBpXDj98r15ZY/PIiRy5IUZj+PBTWLjKlzfcUIGR
        WR77oQKokcFnUD9YXO/t8Ls=
X-Google-Smtp-Source: AGHT+IFmIn9Ppym6QPZwuru6tgIG48QV+sRRUEO9HZV0fD3h3A/xN2dQeOm5ezwdJGzRmnKkECEymg==
X-Received: by 2002:a17:90b:38cb:b0:26d:4100:e129 with SMTP id nn11-20020a17090b38cb00b0026d4100e129mr806124pjb.48.1694569688098;
        Tue, 12 Sep 2023 18:48:08 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a019a00b0026fb228fafasm283309pjc.18.2023.09.12.18.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:48:07 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:48:03 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 14/19] ata: libata-core: skip poweroff for devices that
 are runtime suspended
Message-ID: <ZQEU03dyXx9JqCjn@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-15-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-15-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:12PM +0900, Damien Le Moal wrote:
> When powering off, there is no need to suspend a port that has already
> been runtime suspended. Skip the EH PM request in ata_port_pm_poweroff()
> in this case.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
