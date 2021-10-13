Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE375C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 11:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FE9610C9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 11:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhJMLD1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhJMLDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 07:03:18 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A786EC0612ED
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 04:00:15 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e7so1968453pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 04:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nQQWQUgxuW6Tu+PRvCtkwuIVHgAhZ7y427FiGzCqW1I=;
        b=zuDceFqPkzhsXg/5Ra0cCOC1bU0nBHOgMC+yisKtXJINh/T8f5KQ5Xk3tN1hEQWy1f
         fF/5Ti7SlnxHTZ8CRdyv6Jl7qV6+yL697U37ZNkhKajiI+l/0MJiVPCdQ2f0nPB60e3l
         deL9dfPtSkXLUF1i0K5lBK/jrlNzSLsedO4pErBw8lcHrmTQsFpVw/Kq9PVvZIU+2X3S
         BjO3inmiQSb4KC3RcJr5s4SFs01LRfMOjiO3Y4IdS3Rj0CRwh+XHIqdFiSxlkBam0yxV
         rxKuYNPGd/pLOsHpTEsqWBSUGsQm4kgH2TClaSNsf9ya4bJIDlxKTpNOca2+BLM7jp/t
         D1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nQQWQUgxuW6Tu+PRvCtkwuIVHgAhZ7y427FiGzCqW1I=;
        b=CMlagocgf9kyTpYcWgb7TGXZO6FFsDZSC6As/0qz2yAvSlFDYHl6aDvqc6MgK9ndp3
         btx093KV43ao/6ejl7FWfS+UGe2RZKrcY+LQIJ1d5I4Jy+UtTQXOj8ApebmdcYUGTm/U
         Bu/sgLzH8JZvmzTidmd5J8O9UYzDdZz1zRx4F8/uGbfTrnWneMwd1do9wikh0p9sG7pa
         M+ag6nN2mm0jS6L2ncXM3MhOaTsd7jATnCqIzBQ6ULQf6CF8V9LLwnsE2kxCLLFkoFJH
         cf6URHhcsceFKzbSTuXC6yxUM0AxySpFD86gkuKMHEfV+X37HZBvDEMuL3Ti2YqqGjn6
         AkVA==
X-Gm-Message-State: AOAM532XxdTUsADhXHyoqygwkt6zq1sreElAQRsw7+uTDFvJkpGFsR2R
        w9KVn+ON/Nmk9b1xK1BMmcnOoA==
X-Google-Smtp-Source: ABdhPJxhzjNSoABq+dGG77CzsRDyX+40KYVEdGsQI8qW5B1JHU6i8UmOJoBqJRMmoCIvhAQ+em8rxg==
X-Received: by 2002:a63:2dc7:: with SMTP id t190mr27705777pgt.455.1634122814960;
        Wed, 13 Oct 2021 04:00:14 -0700 (PDT)
Received: from localhost ([106.201.113.61])
        by smtp.gmail.com with ESMTPSA id g189sm5284657pfb.75.2021.10.13.04.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 04:00:14 -0700 (PDT)
Date:   Wed, 13 Oct 2021 16:30:12 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gonglei <arei.gonglei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        David Airlie <airlied@linux.ie>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, Jie Deng <jie.deng@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Anton Yakovlev <anton.yakovlev@opensynergy.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, kvm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH RFC] virtio: wrap config->reset calls
Message-ID: <20211013110012.3exppbls2wggqfhb@vireshk-i7>
References: <20211013105226.20225-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013105226.20225-1-mst@redhat.com>
User-Agent: NeoMutt/20180716-391-311a52
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13-10-21, 06:55, Michael S. Tsirkin wrote:
> This will enable cleanups down the road.
> The idea is to disable cbs, then add "flush_queued_cbs" callback
> as a parameter, this way drivers can flush any work
> queued after callbacks have been disabled.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/gpio/gpio-virtio.c                 | 2 +-
>  drivers/i2c/busses/i2c-virtio.c            | 2 +-

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
