Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48C7EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbjIMBpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:45:08 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0910DF;
        Tue, 12 Sep 2023 18:45:04 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3aa1254fb45so4210645b6e.2;
        Tue, 12 Sep 2023 18:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569503; x=1695174303; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u2TJ4g+Kt1RCCI3n/d4Ps8QJ4nc3lFvnEUXZevPoD5w=;
        b=cw1j/z/nK2Aa0fTfgnKAscdZeCmi/UiTU7PRKCNs0NSxhqclAiIuvosEX+WpOwm0yg
         /VuInAnWBoNXEueOVPuMRxILG9NJGzaxEjf/jxRYZBm9cPZ0kJOu6B7MoE/icjAAcwTo
         dfJ2Eo5hDzXBwhwnP46Tylqd/JwF3tno351sVWPm0rN5UzxYrJMWyv24YdMRCA0mqFiD
         jx3eFFyK+Ep2R9e5gHQ2q6BO09A8ob9+JmNLrlK/lbaWgqv0c+P1VqMNtK/87MUr8izt
         JlnLEn3YrC9FnynKU6XSxbFvqSCtBfEXTylANUWtLHLRxlJ3yQv/H6a70B0xcwv6tTxg
         zaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569503; x=1695174303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2TJ4g+Kt1RCCI3n/d4Ps8QJ4nc3lFvnEUXZevPoD5w=;
        b=V5LVeANJdrUunwxrkAWwB1I5g54FfSQPqywCbpVGu4mDOyxOuo0A65Bh10xQeFBlBR
         qxJliXl8NeT/0U7gIDT97ZL/oxJH6GSeiZNE0NX+MNCNzCDXr5WXau4KojwdCN9TJdzY
         3QQ2qQG/RorV2U+1wiIkyyzYG9QfK1v4w6UHzOa+BGJKNQ+e4Yj30gJiqBTlz2iJzNEv
         bKiPrxFQMjL2UZXt25ROYTd7EEKGwzJXQKaREnFcVpbQ3XShQQrgdV+sBq+whVcEtedt
         VOR/QXppz2EYott8oIyZRSWUTUzHqZrpIBi8/5I4cA54hf/v3JEC+wfGE+m6RBxSroMF
         Hvxw==
X-Gm-Message-State: AOJu0YzjXTZvOST7nn/ay7OJ9xD41xLqtzzp1t2efopsk55d1vZix6HC
        tilty0SQ6fIN+17pvn6ZDQE=
X-Google-Smtp-Source: AGHT+IGT8LMKIid2D+i7IR+6Z6T0wMs8J8oMEfM5JT7KZRC2MjmRj+FUcwz7EzQ2YnUTShlfiHE7tw==
X-Received: by 2002:a05:6808:eca:b0:3a8:74bf:1541 with SMTP id q10-20020a0568080eca00b003a874bf1541mr1436336oiv.50.1694569503651;
        Tue, 12 Sep 2023 18:45:03 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id o3-20020a637303000000b0056c24c2e23dsm7828975pgc.25.2023.09.12.18.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:45:03 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:44:59 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 06/19] ata: libata-core: Do not register PM operations
 for SAS ports
Message-ID: <ZQEUG8ozr9oxIgG0@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-7-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-7-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:04PM +0900, Damien Le Moal wrote:
> libsas does its own domain based power management of ports. For such
> ports, libata should not use a device type defining power management
> operations as executing these operations for suspend/resume in addition
> to libsas calls to ata_sas_port_suspend() and ata_sas_port_resume() is
> not necessary (and likely dangerous to do, even though problems are not
> seen currently).
> 
> Introduce the new ata_port_sas_type device_type for ports managed by
> libsas. This new device type is used in ata_tport_add() and is defined
> without power management operations.
> 
> Fixes: 2fcbdcb4c802 ("[SCSI] libata: export ata_port suspend/resume infrastructure for sas")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
