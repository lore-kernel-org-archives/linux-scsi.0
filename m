Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96492EE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbjIMBqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIMBqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:46:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F2010DF;
        Tue, 12 Sep 2023 18:46:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-68fc081cd46so2639298b3a.0;
        Tue, 12 Sep 2023 18:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569598; x=1695174398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3LvAhigReOYdKAmJcav+TsJ1jv8Zwt8C13GXBVxJWRU=;
        b=WNKkt8mTzVyrp/71XhySvkbWuJpcX0X/T1Y+wuQ9vPl/RvTv55pU3aqYK+IaPzoqpK
         /b/wgjY06P5bpyNwNiARqrUdvPjh9rPX3kBxqqA9FobF7078vv6MWzTCgv8Qzc+nntj2
         oWUbqPuZdoqJ7JUKa+NxvJ+MbNRgxtCcJvC5OY6QKbRupAc5A11cTs2uOKN+oi89Nkie
         pFTK8BZuEe1lqNpZBXT8m5gwJo0v3K0J9JRxWGJ9chZs69x3p/HxhdpXR6KAAKc/fVD1
         UslwvdteM+IboDwfqAYV/FWgXxuozAkWZkw7WE0p4zE+/4e2Bj0xNlIOK42T+sZVV9kx
         fETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569598; x=1695174398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3LvAhigReOYdKAmJcav+TsJ1jv8Zwt8C13GXBVxJWRU=;
        b=CCtt1FgT21lObP2exyAjToQCK4ISqv6a9/T/ZvaDL0++5BV2hG1MRoZ8uK92Ob4leu
         pfxPhkDnndy+TI85bx/mRSKzQirvu4Z2tMyQStWSJXVYH7YCgAtqhBLwk56AbVKsDgEt
         xjamio8PdGILFdbq0tzNjwk6kfQm5X0Qc8d+ZZIQTBabrMAFomUUaa02H4Mjmw9+Enaq
         KPtg+H88uG1TEFK+LajwUw65ZbJJv6kfUSmn+E5ptFZJPAh6EZqbsbfZLaW2nDvnJeiL
         14HZSoZ54jnA9CtIiBMdxu5bP0g6AtTUwLGV8kEtI1pjeBby4EzTQzokoSR/xZxDOtz2
         WsYA==
X-Gm-Message-State: AOJu0YxJastfGSz4htW8GlHg5UAOynFtaecpv/TywVmVPX+nRswHPxxF
        xu+23AH7iCFFy5R1OGzTOvc=
X-Google-Smtp-Source: AGHT+IFQ8EBcQzp7RnwKDrbvFr7H7LFNrVcvzk5Ztb5939RTHV3d9LURTkVlwce2OvLX5XbcGj4zpQ==
X-Received: by 2002:a05:6a00:2d1e:b0:68f:ba5d:c7c8 with SMTP id fa30-20020a056a002d1e00b0068fba5dc7c8mr1592724pfb.10.1694569598024;
        Tue, 12 Sep 2023 18:46:38 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id h2-20020aa786c2000000b0068c68231dc1sm1917992pfo.104.2023.09.12.18.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:46:37 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:46:33 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 10/19] ata: libata-core: Synchronize ata_port_detach()
 with hotplug
Message-ID: <ZQEUeejWrg6cVBD+@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-11-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-11-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:08PM +0900, Damien Le Moal wrote:
> The call to async_synchronize_cookie() to synchronize a port removal
> and hotplug probe is done in ata_host_detach() right before calling
> ata_port_detach(). Move this call at the beginning of ata_port_detach()
> to ensure that this operation is always synchronized with probe.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
