Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDCCC47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 13:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B8560200
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 13:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhE0NZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 09:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236268AbhE0NZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 09:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622121810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHsIQJhjaJ9zmhpKCmH9eFnUstaH3DkdMMtmjVXKIOU=;
        b=b1QK0pPQZCzjRtSxiJcCjqoJOA15TnG/DYw2q9xp/UyTPf2GnFXzh3fLSSiLMvU6MV0Wrg
        gNGfZBhnwABQgHXuBLoaIAq27oBklRHodquTi+gzi/P575xf4zfZW5krH+qsstFsGWQZKO
        XIgDNiY2MepuSWqbNoQkyLUaZGsxaXo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-Lf6-5djKOwyhD7ZzMJHN7Q-1; Thu, 27 May 2021 09:23:27 -0400
X-MC-Unique: Lf6-5djKOwyhD7ZzMJHN7Q-1
Received: by mail-ej1-f69.google.com with SMTP id h18-20020a1709063992b02903d59b32b039so3062eje.12
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 06:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NHsIQJhjaJ9zmhpKCmH9eFnUstaH3DkdMMtmjVXKIOU=;
        b=C+5Th8kV+OI7ZJZhe9lfb3Il+I7CLWMqOfuQZ19nFihNxjaBC4MIfLBGaoCaA7AQ0g
         S6/reFvKzUwGWJ3UovpZ+yi+IN3j+Q3s8XCCITXtHfrCbbrhKSK3Gf+9HHqd5bOowVK0
         yzsrTt68FFDbIvTiYyMxHlUlKcQ8P5/6dTY4f+tcH9aahckeuJlh0O3GE6lsGUmAHqh1
         KnmtLNaVE7etjGI5OGJlym/zdwsovbZdeQ3Oawd00LLgklWr02E3i7kiVsxGGBx4SCpu
         krN1e7GBUJMNn03/irg19lnI+LktcHzMtx7ynZ2YvjWMdvFlmoa2pyxEI1/U1GwUJVvD
         4L+g==
X-Gm-Message-State: AOAM533gdRaVwimfW2Tf5GqZblaJw9hAtrSKLEPlPHud/I8dopiNt2Ot
        VxI7z0nmXgaBCL5jsSpnbR2IMQ56im+Sjc9b3O6I/evkIM/kivMWyQVis//Xo7zrDEgN5rKQnGN
        pSQyKZybVyoIeRnsYb71DBA==
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr4017009edc.360.1622121805908;
        Thu, 27 May 2021 06:23:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8BH+Z7WjU6R8Sc+c920kMoMoVBQUuMl3i00V6kvPgTbHrdJ2zmcxtpY0Zrl6LJD3FdcBcdg==
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr4016987edc.360.1622121805757;
        Thu, 27 May 2021 06:23:25 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id p15sm1118635edr.50.2021.05.27.06.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 06:23:25 -0700 (PDT)
Date:   Thu, 27 May 2021 15:23:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] vhost: fix up vhost_work coding style
Message-ID: <20210527132323.n3efsd6kfgohnaty@steredhat>
References: <20210525174733.6212-1-michael.christie@oracle.com>
 <20210525174733.6212-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210525174733.6212-6-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 25, 2021 at 12:47:33PM -0500, Mike Christie wrote:
>Switch from a mix of tabs and spaces to just tabs.
>
>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>---
> drivers/vhost/vhost.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>index 575c8180caad..7d5306d1229d 100644
>--- a/drivers/vhost/vhost.h
>+++ b/drivers/vhost/vhost.h
>@@ -20,9 +20,9 @@ typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>
> #define VHOST_WORK_QUEUED 1
> struct vhost_work {
>-	struct llist_node	  node;
>-	vhost_work_fn_t		  fn;
>-	unsigned long		  flags;
>+	struct llist_node	node;
>+	vhost_work_fn_t		fn;
>+	unsigned long		flags;
> };
>
> /* Poll a file (eventfd or socket) */
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

