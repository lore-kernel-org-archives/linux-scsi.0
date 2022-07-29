Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A30C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 23:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiG2Xiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 19:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiG2Xip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 19:38:45 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08B760C7
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 16:38:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o3so5853427ple.5
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 16:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mSEMBhFuO4z8gBUZbmc9EV9QPignDStL622s1c9Q2Lk=;
        b=LrkSX8bOsg8Fa8YSspvVVOoQquhpOGqKNufd1xb4UzvM1cp7Cr9usm5gMQHzS/RDzn
         YgI7L1pVVL7qbEEo/NW+1NT8GovFaZy1K5EVorFthABzmGoespIxAjcoy6XNedQbrVxE
         PLfCmL6A58ypnMOXv0rjZoqxKK8TxllqL6EbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mSEMBhFuO4z8gBUZbmc9EV9QPignDStL622s1c9Q2Lk=;
        b=UqSNmW+xB4uConRWcCnoIAmO/EVper59HhJcFnkeLwXLCdGWA7dVUhZsbz5ptKIHGA
         h6/gzshhhmmhq46WNclHAgCWph4ckAeHHwmNrd1UUKE4nAm6YeTumR+T8kXJBXcxOu11
         nBFsYm9dKJDSmeZWvLUQ8a8s0pgiUoYFby93bYSktm64h8eDkuqjV/xwOEdXToF3Q5ZS
         ll8XacsJjgJ9O5LcG5do08fYobCR/kUjALTlQqhi+5LS6iYSvh873/ud2ehSZE/ECozJ
         K+1KirBFetTWlrqd4wJjw3dVlv3bNIjYvMtIP86eKfS4rADg6C/jdOz8ZG9Ekn1kR2s+
         o9GA==
X-Gm-Message-State: ACgBeo0g4ApxQtBN3orEXn/ONBDQdp+eieIenIa1+xGyaXfP7Ytovq7p
        D5Gut/TMIXPouVBMqxAt4U+LUg==
X-Google-Smtp-Source: AA6agR6zSsTkmbOt/xP5Lo0qobWDl0gtmrGZfqwYxEwBcSL8mrl8Co0FA8d1t+LpmhQEsrkMF0zf/g==
X-Received: by 2002:a17:902:f101:b0:16d:c0ae:acd5 with SMTP id e1-20020a170902f10100b0016dc0aeacd5mr6068760plb.70.1659137923191;
        Fri, 29 Jul 2022 16:38:43 -0700 (PDT)
Received: from dev-ushankar.dev.purestorage.com ([2620:125:9007:640:7:70:36:0])
        by smtp.gmail.com with ESMTPSA id n13-20020a170902f60d00b0016bdea07b9esm4147005plg.190.2022.07.29.16.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 16:38:42 -0700 (PDT)
Date:   Fri, 29 Jul 2022 17:38:39 -0600
From:   Uday Shankar <ushankar@purestorage.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org,
        Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN
 list
Message-ID: <20220729233839.GA578093@dev-ushankar.dev.purestorage.com>
References: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
 <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes, I understand that Brian reached out to you for feedback on this
patch. I still have doubts I'd like to clarify; I quote portions of
your response below.

> Biggest problem is that we currently cannot 'reload' an existing SCSI
> device, as the inquiry data is fixed.

I agree; scsi_probe_and_add_lun called with rescan == SCSI_SCAN_MANUAL
on a LUN for which we already have a struct scsi_device seems to be
essentially no-op. scsi_rescan_device will update VPD, but not other
inquiry data.

> So if we come across things like EMC Clariion which changes the
> inquiry data for LUN0 when mapping devices to the host we don't have
> any other choice but to physically remove the device and rescan it
> again. Which is okay if you run under multipath, but for directly
> accessed devices it'll kill your machine :-(

I don't understand how a "reload" will help in this scenario. I don't
know the specifics of the EMC Clariion behavior, but based on your
description and what I've read in the driver code I assume the device
changes the PDT/PQ fields in the LUN 0 inquiry depending on whether or
not there is storage attached to it. There are two "transitions:"

Attaching storage to LUN 0: We don't save a struct scsi_device for
devices whose PDT/PQ indicates "no storage attached," so when storage
gets attached and PDT/PQ changes, scsi_probe_and_add_lun will act as if
its seeing a new device for the first time. Everything should work.

Detaching storage from LUN 0: The current implementation of target scan
won't pick up the updated inquiry data, sure, but a "reload" can't save
your machine from dying if programs were accessing the LUN 0 volume
directly, can it? Regardless of what the host does, the fact remains
that it can no longer do I/O on the LUN 0 volume. The only thing the
host can control is the particular flavor of errors delivered to these
programs, and the one associated to "device is gone" seems to be most
accurate, and the one that Brian's patch (if it applied to all devices,
not just those with vendor PURE) would deliver.

Overall: we'd like to eliminate the need for manual rescans wherever
possible, and we're willing to revise the patch and/or submit patches
elsewhere as needed to achieve that goal. Please advise.

Thanks,
Uday
