Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A36FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 07:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC862078E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 07:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="P1AWeZiE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgHKHDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHKHDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 03:03:42 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43FC06174A
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2020 00:03:42 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id u24so11306146oiv.7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2020 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=MlFkUroiC5cUzWMMBz6G7bs43pc0dCCdF/xysr3+kGI=;
        b=P1AWeZiELJeMHdkeyXxKCZDXtaKlflQPgnF8XISkjtKPd0rgCcQssdbNJEsufuM7jw
         r4X3V3f/D0hlUr3gjMjlcZcGM8LIyF10jVakP+E3lbp6EvkHrqlnBMAmSMlXOadmQkDv
         fZ7D5Nu3/X+praqU/f5ZuIiDor9HJ3yAr1+OE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=MlFkUroiC5cUzWMMBz6G7bs43pc0dCCdF/xysr3+kGI=;
        b=djVl+Jgowbqgvo3yDXh+0lzGr/WmIkx+fpJXwHs1E5QwpYG92vbGesWSY08vGK2h2n
         GXHencwmC1mPEA7GN88vg3MK5ZHxgLg8kz18SpPvAehdJJc7dmr2fEQuMT9ZzdN57Ne/
         UQVy8wEG0ztE+wXxFnghDk/PyXy9hIR2WA3JNYmf0/Rx3TR7ekcXCQVeuear66SWlAxk
         u53iVsbutsp1fsWmtPBuSbYKqZMSXF/JJUxWdOL35IZA+/AWa/mLGdnhM5o/lQME46ZQ
         DNbjxlEvDD0odzhnhQgT1ZxBLNM6e9Bee5cV6e0u1bHeMi08bwPCeHVJFtz7CFhKEJ4c
         T7jw==
X-Gm-Message-State: AOAM530h4JqQbjdbRe4QCzGrVyu5L4hzIW2H/U7MtnuYEKyQ2BUgSRDE
        fmPE3Jb3wYfSABJY01R1VPZoM+LESbv5V0aGAcF0VQ==
X-Google-Smtp-Source: ABdhPJzP6/z2Y4B/RMcgHNJSiFwMyyGjU10KSaMnAtQcTRxJV6ksZvT5b4tCLujJ7DZnZs3PkVCBa78PDbRwQv3p+Tg=
X-Received: by 2002:aca:1103:: with SMTP id 3mr2428658oir.104.1597129421052;
 Tue, 11 Aug 2020 00:03:41 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com>
 <b5469eef-08cf-267a-77e7-5e4a3640f4f3@suse.de> <2bab689170901076a118204cf05063d5@mail.gmail.com>
 <b18e3d59-1bf8-ff7d-db81-88f60ef283c1@suse.de>
In-Reply-To: <b18e3d59-1bf8-ff7d-db81-88f60ef283c1@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQJ7Mkz9vjBwWq9e6w+xaVY+lMObkwJ+Z0PfAmkI7CECA8cWxQIL+hSbp6E6rSA=
Date:   Tue, 11 Aug 2020 12:33:38 +0530
Message-ID: <579d6af65acdc2f3cf673d73d00d4694@mail.gmail.com>
Subject: RE: [PATCH 5/5] scsi_transport_fc: Added a new sysfs attribute noretries_abort
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Hi Hannes,
>>
>> Hmm. Wouldn't it make more sense to introduce a new port state 'marginal'
>> for this? We might >want/need to introduce additional error recovery
>> mechanisms here, so having a new state >might be easier in the long run
>> ...
>
>> Additionally, from my understanding the FPIN events will be generated
>> with a certain >frequency. So we could model the new 'marginal' state
>> similar to the dev_loss_tmo >mechanism; start a timer whenever the
>> 'marginal' state is being set, and clear the state back to >'running'
>> if the state hasn't been refreshed within that timeframe.
>> That would give us an automatic state reset back to running, and
>> quite easy to implement from >userland.
>
> Thanks for the review.
> I have a small doubt.
> When the port state moves from marginal to running state does it mean
> we expect a traffic from the path ?
>
>We don't expect traffic; rather we _allow_ traffic.
>But moving to from marginal to running means that we didn't receive FPIN
>events, and the path should be considered healthy again.
>So from that perspective it should be back to normal operations.


But this could  apply only to FPIN-Congestion. Only in this case FPIN-CN
FPIN events will be generated  with a certain  frequency.
But for FPIN-Li this is not the case.
FPIN-LI is used to inform about marginal paths, which needs manual
intervention to recover.
And for FPIN-LI the path should be re-enabled on any link bounce
(portdisable followed by portenable) which would correlated to a cable/sfp
change.
For now, however, we are addressing FPIN-LI primarily.

Regards,
Muneendra.
