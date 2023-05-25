Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA93C7EE2E
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 08:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbjEYIAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjEYIAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 04:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949B5183
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 00:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685001587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NwwIZJaZmyN29dYpZnR8aKcXxLup1p21dC4SUQQJNdM=;
        b=WX+QPlhBiVNtP+1XDv4NZ+Db2Trke857lOY7dsrvFBEkIKXXuop70dEeVwA7twb0OrBcbR
        e+g98jM37pXF7U6JOo8K5B3OaEZ5J8TVN1TaFoAQ+AdJ0j/TLUzab+PXF6pkiqqU6sVp8A
        +JjJTTzIHOxieLho9dhnbUXi8QflyvI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-4URaVvIzPZyV6A8dEjHcZQ-1; Thu, 25 May 2023 03:59:46 -0400
X-MC-Unique: 4URaVvIzPZyV6A8dEjHcZQ-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f6b0c739adso8182861cf.3
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 00:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685001586; x=1687593586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwwIZJaZmyN29dYpZnR8aKcXxLup1p21dC4SUQQJNdM=;
        b=SfMrnFOu21Cctg4TlMuIZ/tvI81Y4x0RpBlXXG85h94ix/OlTmWnY0D/TE8Oa01sLs
         ayHqL/UXU0GagE9wswRcQ4dbD17x8s5UMWuZVq2VbHhFqdRV3rhPKvh9RZuZJb8F16u0
         lOWB5LdIWQIWH1iAdBY4zgup/TXY929IMBeUx8dG8cuQI3VORfaTtVHekIZeatbsy4Yc
         tYh+VkSSUuCjL288rftt8gr4x8TeCdtBm5i/OmqPiv7mZXJ5b9RMYK3EV5kgX0Ds0jXq
         /1OjrwB3z/Oy5YGY63JfN5AFj9eT69ex29AtfImVcnBb+KwcvGhO+ZxoMcxCqaeWoiZ8
         AxSQ==
X-Gm-Message-State: AC+VfDxEtKUhPqBuVjMb0yQ7fQ02+7Aa8ygl+9Pk535tt1DQI2GLWnOs
        zYYQR1DHPEA++Bxpt6t6MFYI/kFjqWAsp9fwIkt9PAPWUEBCx4bBg8F5g+l1Te/uye6i+qTlwHZ
        tmvd0r/CoipGdQ+n+/diTqo5V8xR+Fa1d
X-Received: by 2002:a05:622a:34a:b0:3f2:f35:8e6f with SMTP id r10-20020a05622a034a00b003f20f358e6fmr29397748qtw.25.1685001585834;
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6zl0dYCxYxkI+YVsbHmeWTGNczau5rHDnkpRLez3qsWsVlCM5yo3Zal8EdbIG0yQ8bNC7y6Q==
X-Received: by 2002:a05:622a:34a:b0:3f2:f35:8e6f with SMTP id r10-20020a05622a034a00b003f20f358e6fmr29397737qtw.25.1685001585600;
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
Received: from redhat.com ([191.101.160.247])
        by smtp.gmail.com with ESMTPSA id d3-20020a0cf6c3000000b00625b2f59d3fsm223966qvo.96.2023.05.25.00.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
Date:   Thu, 25 May 2023 03:59:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230525035847-mutt-send-email-mst@kernel.org>
References: <20230524233407.41432-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524233407.41432-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 24, 2023 at 06:34:04PM -0500, Mike Christie wrote:
> The following patches were made over Linus's tree and fix an issue
> where windows guests will send iovecs with offset/lengths that result
> in IOs that are not aligned to 512. The LIO layer will then send them
> to Linux's block layer but it requires 512 byte alignment, so depending
> on the block driver being used we will get IO errors or hung IO.
> 
> The following patches have vhost-scsi detect when windows sends these
> IOs and copy them to a bounce buffer. It then does some cleanup in
> the related code.

Normally with virtio we'd have a feature bit that allows skipping alignment
checks. Teach linux to set it. Stefan, WDYT?

-- 
MST

