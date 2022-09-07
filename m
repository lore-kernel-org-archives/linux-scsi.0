Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99892C38145
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 07:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIGHwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 03:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIGHvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 03:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763DE86057
        for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2022 00:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662537105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8KMdampSVOfSjQJ+eYUB/+euJ05288b13jRxouoL8v4=;
        b=f9qW33gZuL22wnajU0IOAp3kQ19FGqpnVE3BxzM1cm/KZSZWdUOp2otyB0LTPstvg2UaC5
        B5dkFFA5IT2rmuOgHvWF4GaklQ/mOne4jUzWt1RDFWPZPts4SPkvmXT9c9zp+iqypEgUpU
        hQ2zzUts3Rzs56YLGc9ZginO0pLuFKY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-CgEltQk2NnKWooRKW4QZtA-1; Wed, 07 Sep 2022 03:51:44 -0400
X-MC-Unique: CgEltQk2NnKWooRKW4QZtA-1
Received: by mail-wr1-f69.google.com with SMTP id i29-20020adfa51d000000b00228fa8325c0so308068wrb.15
        for <linux-scsi@vger.kernel.org>; Wed, 07 Sep 2022 00:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8KMdampSVOfSjQJ+eYUB/+euJ05288b13jRxouoL8v4=;
        b=0D0RL0SzxOu27/7NFUR8w/cnz5/KCnXdjhhdVI9uP7CwHaZ6lK8bvgS74QxrzpTceG
         wlNd1fSPzf+E1OPNrSZx90RDxwG9jt0AOv4TyC7gFhVO9Qs2sNh+Fsq2A6UhihCR1Son
         TXwGJhA9hfC9/EVx4VCEOUC7sEdz6rtQPqEWsQ9fY6Q1yta0AJmUWW8zwSyKhLn5zMG9
         j+6ryp6ZWTU8/KkncgAQw7WSRyLM1DIkPFQYvfQ5fI1rt4mNwWl5wNqSWZlXRg7wOYiQ
         3OCLYCCdyDm+meW4QvkfoXxBPzfKazO1ptsw+55KvdLbu8hta9HEuRmBSxgLB/FwJ+Ea
         O4Mw==
X-Gm-Message-State: ACgBeo3LEG4N2Cc/UZlwKvInvUoCKdLnHj77dGaUiBcc1tCpiYScTcxe
        jKWyDapPbWEb/Oppic5j381u/Bm2kxM63bld8mSASk06deDCXFS+39GyBM7c+dFrLwUsRsb8Ton
        OE5BBA4XSQO5Dvady5u0I2g==
X-Received: by 2002:a5d:6f19:0:b0:228:d8e8:3ac8 with SMTP id ay25-20020a5d6f19000000b00228d8e83ac8mr1149255wrb.101.1662537103863;
        Wed, 07 Sep 2022 00:51:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ThqBf88YF8iut0HC9FOIofHwvY/fghW1g6YgYSZwxQVisX9JDtm6hidIgh47utu42naZpeA==
X-Received: by 2002:a5d:6f19:0:b0:228:d8e8:3ac8 with SMTP id ay25-20020a5d6f19000000b00228d8e83ac8mr1149243wrb.101.1662537103667;
        Wed, 07 Sep 2022 00:51:43 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id d14-20020adff2ce000000b00228d6edade0sm6597943wrp.46.2022.09.07.00.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:51:43 -0700 (PDT)
Date:   Wed, 7 Sep 2022 09:51:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     vdasa@vmware.com
Cc:     vbhakta@vmware.com, namit@vmware.com, bryantan@vmware.com,
        zackr@vmware.com, linux-graphics-maintainer@vmware.com,
        doshir@vmware.com, gregkh@linuxfoundation.org, davem@davemloft.net,
        pv-drivers@vmware.com, joe@perches.com, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Message-ID: <20220907075138.ph3bbitnev72rei3@sgarzare-redhat>
References: <20220906172722.19862-1-vdasa@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220906172722.19862-1-vdasa@vmware.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 06, 2022 at 10:27:19AM -0700, vdasa@vmware.com wrote:
>From: Vishnu Dasa <vdasa@vmware.com>
>
>This series updates a few existing maintainer entries for VMware
>supported drivers and adds a new entry for vsock vmci transport
>driver.
>

Since you are updating MAINTAINERS, what about adding 
"include/linux/vmw_vmci*" under "VMWARE VMCI DRIVER"?

Thanks,
Stefano

