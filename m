Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE53C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 17:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiG1Rkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 13:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiG1Rkl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 13:40:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734E074793
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 10:40:40 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 17so2562061pfy.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 10:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fbEi1xZlZBzTBnqpj74XqqavB5MT+yCRpPXrMycUsKw=;
        b=XxFa2Z4PpE2673KAGsJF1n9Y8j0dzAsiEsHmPEZx5CXW9SugrQtmtnXaXWDC3Olzcz
         OuEzR9pnDcZsd152PTZMxRWy3oL8cIY4+B8DfMlGnmoeCdoRXQ3urWaqsT+2z7IvEQ7H
         a8qS+RebPC5WtU135aTFB3BQzRXxohQUadHqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fbEi1xZlZBzTBnqpj74XqqavB5MT+yCRpPXrMycUsKw=;
        b=1u6XInxY01dMkWPROGt7n4m5pgrfJCl0EMB6pLnvj/87iZ3mnwVe7IplX6DsXzVFZS
         JQfBcxM2zKQnAf1/ydzsTZw2x2D+wkXV/l+X5kT3PCq+93oZNmoQ6uA+Jc1sg2I4RXTk
         gcoqtZgncPwAdBHmyYhuKIJpDAprCaM16I7N4FLkPG443ARTAc8gD7QwVmSH7gCtV1g2
         uqDldNGe/XpM0yht+kknzNTqDYcfEUGk54HSozomic30ZFJwI75d10sk+mluWQSAv+I8
         UDFUvYZFm4uaPWruLtj3Y60vf1OhAIVPXPPUgS2FDvrjEu3HlxDvlOvPXRiN/G4ILXpl
         Q3Ig==
X-Gm-Message-State: AJIora9p7vEDk5X0GHVr9fyib8Am0t3UH1Mggw5dFCDWVbWHdZRq5V7F
        GEhsIAdjegYqeb0D4N6LmPy2Xw==
X-Google-Smtp-Source: AGRyM1uk9v7wWFM19BOscuYM6AGaolBnZZhwWnBfT67esjypVLI4xgJYdL9nApIXkp8BkB09bZdf3g==
X-Received: by 2002:a65:6787:0:b0:412:e419:d654 with SMTP id e7-20020a656787000000b00412e419d654mr22867402pgr.427.1659030039908;
        Thu, 28 Jul 2022 10:40:39 -0700 (PDT)
Received: from dev-ushankar.dev.purestorage.com ([2620:125:9007:640:7:70:36:0])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902ea0300b0016d763967f8sm1611603plg.107.2022.07.28.10.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 10:40:39 -0700 (PDT)
Date:   Thu, 28 Jul 2022 11:40:36 -0600
From:   Uday Shankar <ushankar@purestorage.com>
To:     Ewan Milne <emilne@redhat.com>
Cc:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN
 list
Message-ID: <20220728174036.GA3910842@dev-ushankar.dev.purestorage.com>
References: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
 <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> but there are several cases where this is undesirable so I do not
> think the kernel should do it.
> Having userspace handle policy decisions allows for more flexibility.

Ewan, could you elaborate on this point? A volume ACL removal on the
target is not a transient disruption to access to the volume - it is
permanent and deliberate. Keeping the device data structures around on
the host paints a false picture for applications, as if those devices
are still accessible. Moreover, if a new volume is connected with the
same LUN, the old device nodes are re-used with no indication to the
application that the underlying volume has changed. As Brian showed
above, this behavior can cause corruption when devices are accessed via
multipath.

Sure, this can be avoided via a manual rescan-scsi-bus.sh -r after
removing volume ACLs. But we already have automatic scanning of the
target upon receiving the REPORTED_LUNS_DATA_HAS_CHANGED UA, and it
seems unnecessarily asymmetric for this scanning to have the ability to
create new devices but not delete old ones.

As far as policy decisions go, NVMe has in-kernel scanning which can
both add and remove devices. Is it a protocol difference that prevents
SCSI from doing the same?

Thanks,
Uday
