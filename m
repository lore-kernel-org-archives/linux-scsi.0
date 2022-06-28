Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F299CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 13:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346631AbiF1NhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 09:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346625AbiF1NhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 09:37:00 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E0A2B183
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 06:36:54 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id p31so19941244qvp.5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 06:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gN4ZNyT9GRZ46Vwx3CUzNgwGxKE3ptwelsb3O/2waMc=;
        b=SRPS2zIET11DP06FAnMANUW30rX+F+KLnmvgpItTZuHDiHMYbx191l+udZ0BIKVo+p
         DUqKNFcRnPxEdciA9v/rjMoUuUABeinU5a59o91m7mO0ei+LjGwfeqP1sFK6bST4r2Sc
         +kwNrequilw+r3whlSvEqjUrw7uEou8aBEv26lUqmckZs7QEO1gxqNAIdKmR6ixdoBBW
         VwXL+VitONeiHER4+6czyOuvux/gSa01CsajOGl6xQeKgTZdOU9/PF5ai6yeP3/8Na6A
         VkyCaiWAoLiX3IML+rZ/qAH9obhof6Stg3VEpk4n7D6sOfmWV6A4zI2itZ9nI+NyrBEn
         GAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gN4ZNyT9GRZ46Vwx3CUzNgwGxKE3ptwelsb3O/2waMc=;
        b=15JKgKceNmCWIao4zGzXlFhR54/rnqSChdV6Jf+9WNEMiRxn/eOuaK2LuuR/hxn2b5
         aPfjJfDrlE5PZUmn3R8UIWjTS+wx2PxGNSBhONhDK1FQ8npcZ0TQfIAdscmBdsG56f6Z
         shKpDYMYjZve5RTByKchztQiOIzGwES3SGrr+9Cj5gm9ToYX2TfbWh5t5UJWRfEkDFoY
         Jq05nT4cenw6II5F5OvsUx5b9x+2WDCsiGu9dUMGkuu+mOEC57Hw8XJrbkesp+SGY9kn
         Xc/dlD1UfNAd7NhLNC2wOaLcCtAHs0s34mP4NwOosSPGg5lm/eKvweXsK52bukl5ldeR
         39Tg==
X-Gm-Message-State: AJIora/24ZgzbN8CR0exYdARn+nJajaO5wu6aN+KIXtcNMicGoW0TIqp
        Jba+yU9Hj6gaDXMXIirRv8QiZw==
X-Google-Smtp-Source: AGRyM1uooXTVlKXYemR9EvbrrQp4i2XA4BpQT09bjvN7I6xIwm3cKCnpXCNHNGqwd+HxVz52pv3Omw==
X-Received: by 2002:ac8:5b0d:0:b0:31b:f519:4107 with SMTP id m13-20020ac85b0d000000b0031bf5194107mr1237416qtw.331.1656423413317;
        Tue, 28 Jun 2022 06:36:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s10-20020a05620a29ca00b006a79479657fsm708363qkp.108.2022.06.28.06.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:36:52 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o6BOd-002vAA-VA; Tue, 28 Jun 2022 10:36:51 -0300
Date:   Tue, 28 Jun 2022 10:36:51 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-can@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-mmc@vger.kernel.org,
        nvdimm@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220628133651.GO23621@ziepe.ca>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
 <20220628005825.GA161566@embeddedor>
 <20220628022129.GA8452@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628022129.GA8452@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 28, 2022 at 04:21:29AM +0200, Gustavo A. R. Silva wrote:

> > > Though maybe we could just switch off -Wgnu-variable-sized-type-not-at-end  during configuration ?

> We need to think in a different strategy.

I think we will need to switch off the warning in userspace - this is
doable for rdma-core.

On the other hand, if the goal is to enable the array size check
compiler warning I would suggest focusing only on those structs that
actually hit that warning in the kernel. IIRC infiniband doesn't
trigger it because it just pointer casts the flex array to some other
struct.

It isn't actually an array it is a placeholder for a trailing
structure, so it is never indexed.

This is also why we hit the warning because the convient way for
userspace to compose the message is to squash the header and trailer
structs together in a super struct on the stack, then invoke the
ioctl.

Jason 
