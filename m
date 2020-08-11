Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240C9C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 06:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB37206C3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 06:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="a3eYUi/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgHKGBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 02:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgHKGBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 02:01:43 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1077EC06174A
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 23:01:43 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id z18so9226658otk.6
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 23:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=yZqZMyJQawNkJZhzG8AMA4jYKVrIoiJmU5+5IGOJXCw=;
        b=a3eYUi/HecPDx8dZNG4AbraXu8UJAdBkZAoKkmONz9S6LbFeMUyLPXgE4KsIe7no4t
         Nxq9/ZqrSDdLNfrrB2gJVT3CO4AlyAfG4jZkVeX581Wxh93IdNXrdQj0L1qdjyZTdTGU
         xzJT0Hhd1nA/CTw1AbI2u5a4YVbhuSkzDwvog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=yZqZMyJQawNkJZhzG8AMA4jYKVrIoiJmU5+5IGOJXCw=;
        b=doPWwNt6v6DQ+7aMYZSrIE+SyBxxXL/FWAhBP7tFJfGi407MTDVOgU9NtxI/ZmtG5R
         d2zuK1X/fLRMZXM24EZYiyslP7a16pZW7J5kU/PdgvZ1p5D5J5KPmFpQj41h3BSfQXI+
         F397HVpK+7h6CDMTwhlzi74VzVUjWQGbmze1++Bho1fcKLi91JBm2FIZpw9XSC3RPoPz
         c+xPAUHE+s16N6Oq/BBdtZtunuNlMsWPrJd4oQ/G4UiX8LYZdQpljZBp9ECEcgTvcrtr
         DycQZRGu6vzOh3WV9ZXQmYzJOYMP0CnPv7GbCwTcGgB5c1KCK8eb144la64tkOcB8l6a
         TGNQ==
X-Gm-Message-State: AOAM530Nox+LyAj67j/dKG2Jn3mWZMe8oDKhMoJcJzyBQPylH5W22pl6
        PZDgaiuZ13uaMCTIf0DnowlXZQRzfD8SidnaS7pzDw==
X-Google-Smtp-Source: ABdhPJwntBqM7TA1yzR+H1a7vhFnOXZlGsPp5C1iAV9nfghKkXfBA3PcdZbEvBHb5iGd5BYtGlS5icrrBPIaGvpeMMw=
X-Received: by 2002:a9d:3c6:: with SMTP id f64mr3781327otf.364.1597125702170;
 Mon, 10 Aug 2020 23:01:42 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com> <b5469eef-08cf-267a-77e7-5e4a3640f4f3@suse.de>
In-Reply-To: <b5469eef-08cf-267a-77e7-5e4a3640f4f3@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQJ7Mkz9vjBwWq9e6w+xaVY+lMObkwJ+Z0PfAmkI7CGnwalNEA==
Date:   Tue, 11 Aug 2020 11:31:39 +0530
Message-ID: <2bab689170901076a118204cf05063d5@mail.gmail.com>
Subject: RE: [PATCH 5/5] scsi_transport_fc: Added a new sysfs attribute noretries_abort
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

>
>Hmm. Wouldn't it make more sense to introduce a new port state 'marginal'
>for this? We might >want/need to introduce additional error recovery
>mechanisms here, so having a new state >might be easier in the long run ...

>Additionally, from my understanding the FPIN events will be generated with
>a certain >frequency. So we could model the new 'marginal' state similar to
>the dev_loss_tmo >mechanism; start a timer whenever the 'marginal' state is
>being set, and clear the state back to >'running' if the state hasn't been
>refreshed within that timeframe.
>That would give us an automatic state reset back to running, and quite easy
>to implement from >userland.

Thanks for the review.
I have a small doubt.
When the port state moves from marginal to running state does it mean we
expect a traffic from the path ?

Regards,
Muneendra.
