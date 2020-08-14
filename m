Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EC4C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 05:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE38520791
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 05:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OPaTZnQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgHNFdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 01:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgHNFdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 01:33:36 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81727C061757
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 22:33:36 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id l204so7220326oib.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 22:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=3x17KKdqWy/HtW43uvhY70rIzlO/3v8kZxBXBECCJ88=;
        b=OPaTZnQv5Y0mMgh6D0fQXcWex2ciETyXlgIlMgvCzmdhzjfkWusVsBAPNplQD0+T2E
         3wUYkKM1mo6ojljkn/CtOKNEE98HXUQZbayWao+im2vEix7RHPMm7inL5DKvOQ96ey/u
         oegWa9w+wbg8Yj+frA4r4GfWP8PG42H1spiCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=3x17KKdqWy/HtW43uvhY70rIzlO/3v8kZxBXBECCJ88=;
        b=dTFB5n8sglj2VOnbKmIGZRp4kGM2b1Q49uWNTTw86q9B2wQHKq4SL1k5ilOmPE49VF
         X8muuOfPw0VbHqA1vA/MpL0CMcN/xdlccjttAd59jYcZ3Wdi/98jQ131vl+W2nEHBkAN
         L+PpYAnSTf+UXXFSbaAELMIvel12AEVCwszSO5Pr6X7wEYUVkRfwhm2s0l8lP28M1rOG
         dVBTkg7nq87xmXHU8MvsQIxhUIxyQ6e1Tl0M4s27dO41ZMdUfm047XASJm18z9rDXKjj
         FtNRReYTy9w6ksNF9K/0tixAJPGX298kcbEknbGQy7nRO+PvDzitXKmEJsGtv7TStmtP
         JCVg==
X-Gm-Message-State: AOAM530wqbGD2gpfRAG/x4gyqZvEryvvA17YmOyoANEyKf4W/R6tww6g
        K806LnG7YLRh+w7c+eEjPtp34tbxog20A/CvPIV4OQ==
X-Google-Smtp-Source: ABdhPJzI7bc+O12RYugTa03HeZFYVzw4/akPj00JTMeItS0f7YDDFVZIZvcyBMWVxWxl423iH5RRiME7pVKSwt2Cyzk=
X-Received: by 2002:a54:478f:: with SMTP id o15mr594659oic.77.1597383215270;
 Thu, 13 Aug 2020 22:33:35 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com>
 <b5469eef-08cf-267a-77e7-5e4a3640f4f3@suse.de> <2bab689170901076a118204cf05063d5@mail.gmail.com>
 <b18e3d59-1bf8-ff7d-db81-88f60ef283c1@suse.de> <579d6af65acdc2f3cf673d73d00d4694@mail.gmail.com>
 <354f6b67-4a54-1807-b205-d3c0b71906b5@suse.de>
In-Reply-To: <354f6b67-4a54-1807-b205-d3c0b71906b5@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ7Mkz9vjBwWq9e6w+xaVY+lMObkwJ+Z0PfAmkI7CECA8cWxQIL+hSbAS3gpoUB5xqMdKeNMZVQ
Date:   Fri, 14 Aug 2020 11:03:31 +0530
Message-ID: <58f0f6051d6ef99c29a3695d2a8571ff@mail.gmail.com>
Subject: RE: [PATCH 5/5] scsi_transport_fc: Added a new sysfs attribute noretries_abort
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,


>>>
>>> Hmm. Wouldn't it make more sense to introduce a new port state
>>> 'marginal'
>>> for this? We might >want/need to introduce additional error recovery
>>> mechanisms here, so having a new state >might be easier in the long
>>> run ...
>Ah. So that changes things slightly; I had hoped we can address things
>systematically, but with link integrity issues we don't have any other
>choice but to replace the cable (ie wait for user interaction).

>But still I'm in favour of the 'marginal' state; that one could be set
>manually (or by an FPIN LI event), and would need to be reset either
>manually or by link reset.

>And have the advantage of being easier to implement :-)

Thanks for the review.
I will incorporate all your review comments and will add marginal state in
my next version.

Regards,
Muneendra.
