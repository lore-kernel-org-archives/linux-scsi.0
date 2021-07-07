Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2F7C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 17:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D2D61CC2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 17:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhGGRpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 13:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhGGRpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 13:45:08 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F560C061760
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 10:42:27 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id a16so4400902ybt.8
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 10:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67r38bE7gQFQq3QdwWGtHId+Jukj2mvNHeTDPSYrtoQ=;
        b=PiICEgwc7suyXxN0mAopoGLe6qStu8w216bkY7ntbFJES64gkKAVvNRXyVO1GFHbgC
         l9k1jMUt3w3jw3TBaa55TTLeqvXmKjFlQV19yvAV97K/xigbpxsUIsifvWN7LxvoXoAs
         fFHHN17hY2dGumqaplrWaYI2uedjSijA70my9t9Nx0mZIuhWwHQ6UMsv+PVFsWQtI/1S
         Qkoj6ZtER+1olb/t7PvFV/X5wVqfllmBXnWc5GERs6mAjs+ZkAW8grwinee3GZDlHqGz
         +ZPUO2slLAckkd7WtWORZHyQREJLk+EpS1RLHxfCtC3g2Tc5JRSDNaGyWOfzs3bUhz4K
         tExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67r38bE7gQFQq3QdwWGtHId+Jukj2mvNHeTDPSYrtoQ=;
        b=M+KtfbKpruLiEKfjGdGN7+Q6dir4D01is+TC9yh8eeMcZDZE3CZn9bDFnN22CLUl2e
         8Z9Em8lmUvvZkFbm7qPbfMubNLx0k3bAzNtnPis/gYBtzRlYhhR3YHEvafnSTZGWGm9H
         DE9U5yOPuR4CJGdUPrUBHIFpemn11yPSENgfPfk4Cm6BmUSmioyMSsFZMHFHSprII7Di
         x1Vbo5FpYq5jLGjD1WwnSrcI57pAU0jGsnWHMUonEyREBiTPYsS+uwcbwVuZeIL0QF+c
         zIbnmjlMU0j5qYZh+P8bN+yc6id+NH4TBpQ/8czNan308n+BBHr8CMvjwvyLXHIo3Qek
         MSzg==
X-Gm-Message-State: AOAM533MJ3A7CHmooRSed7vzv3oqQXtwi1HVPb9q1TylriBScXqdIkrf
        Duqp1GfgarAG+47qlSpBLxOI30isS6xk9HPrWXV9UA==
X-Google-Smtp-Source: ABdhPJwFttiWi7Jgj1I6L5f60b/n53pkLOBE3RjrV8WhESNsOLc+ROGmWITcmAdN6pWWu9sBPobsQik3WKj/TFI/JsQ=
X-Received: by 2002:a25:bb46:: with SMTP id b6mr31453156ybk.346.1625679746076;
 Wed, 07 Jul 2021 10:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210707172948.1025-1-adrian.hunter@intel.com> <YOXnF4BBPeBEMB38@kroah.com>
In-Reply-To: <YOXnF4BBPeBEMB38@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 7 Jul 2021 10:41:48 -0700
Message-ID: <CAGETcx-Sjo3scN-ZK-aqRCKi-6+1y_KXOuCqK97YgJS32u6tbg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] driver core: Add ability to delete device links
 of unregistered devices
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 7, 2021 at 10:40 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 07, 2021 at 08:29:46PM +0300, Adrian Hunter wrote:
> > Hi
> >
> > There is an issue with the SCSI UFS driver when the optional
> > BOOT well-known LUN fails to probe, which is not a fatal error.
> > The issue is that the device and its "managed" device link do not
> > then get deleted.  The device because the device link has a
> > reference to it.  The device link because it can only be deleted
> > by device_del(), but device_add() was never called, so device_del()
> > never will be either.
>
> How was a link created for something that never had device_add() called
> on it?  Who is doing that?
>

Greg responded as I was typing :)

Nak for the series. I don't like mixing and matching the control of
managed device links like this.

Can I get more details please. How is the device link added in the first place?

-Saravana
