Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B7DC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 17:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73EA224B1
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 17:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HaYjRzay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIPRCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgIPRAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 13:00:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8073AC0A3BDA;
        Wed, 16 Sep 2020 09:44:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so7600654wrm.9;
        Wed, 16 Sep 2020 09:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NIAOHzQzFLfA0GPWXwaNH3lHE/0XW9hoINO0h/wj+Js=;
        b=HaYjRzay6bO8Gb/ySvO0a1JMXZ0yNUMnoS3JJa+Lo/IKV6kXGuGbjj+buu/BHpwpa9
         bSaoFF1NkIqV7FcEqfUhZv87klmLDuw5FEZdVLy6PGlw0if9csJ+FydEPmWeuQLHpLq1
         f2YwwJVYIHKGrXHYpoM95X1pgEQBAJfe5oQnaStAza5umWvhwYRGZogc0BX6yN5Ilqwj
         3pOEmshgvRdJXjNj248td+7lKwiI91JRwaJjlvRY+zE/GD9e1i61511w8ROaGEx0M5WP
         CZYD9vu5oS3JGhM4hkKVaQtkXhHJiuCy86Fl0twTu+DhzxVi2q/O5np8IZGLZN9mbnrN
         lsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NIAOHzQzFLfA0GPWXwaNH3lHE/0XW9hoINO0h/wj+Js=;
        b=hkQSN8wcZJAqINkm35IqhVDcGTa/onn3XvZcNiN5umk5R5SI/X1zYvR7s0n07toyOx
         hmdFKx6j5FlMhtmSd3F4SoVXlLh+1N8ocjrR/oEpFKeMwalsMUWFLalAmDaqB2srjTIg
         cFV3BzQmmTkiBPGqnbXXHgDmUuk0vmd1+sEF9SJvKmANsWDYvP5TJ9/FaCoDG+Sy0ZNl
         f1errBu1y/UGzVs3XVkrlCck9tjPxNooxqNaRpiY6gUAxR3OU+L4ZQ1RgkIZlzg7NEGZ
         ewvgEYpyLBQq5TSpfBFDmZmd+OQDfpgRf0+rCaeQCw0b/4G+96drw0NCbZlMc8yAPjU0
         dSQQ==
X-Gm-Message-State: AOAM530NRUpDnTRQ4P0vX/bgqLOaQoAldhNR78MQL5d6qkT2sB9JrKZG
        JaAGJyPdJgNH4SKRQLPJ8FY=
X-Google-Smtp-Source: ABdhPJysWo0vQD8RNCx9oWslc3MySE+uNCO1jeXyh3UMpdHfudjcl27MfFfbX5e6qhsafFQJHYbJJg==
X-Received: by 2002:a5d:540a:: with SMTP id g10mr26279976wrv.138.1600274654416;
        Wed, 16 Sep 2020 09:44:14 -0700 (PDT)
Received: from lenovo-laptop (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id x24sm33199670wrd.53.2020.09.16.09.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:44:13 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 16 Sep 2020 17:44:11 +0100
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] scsi: mpt: Refactor and port to dma_* interface
Message-ID: <20200916164411.hkpmqigdhgdb66dl@lenovo-laptop>
References: <20200903152832.484908-1-alex.dewar90@gmail.com>
 <yq1ft7ixyg8.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ft7ixyg8.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 15, 2020 at 10:12:06PM -0400, Martin K. Petersen wrote:
> 
> Alex,
> 
> > Any feedback would be greatly appreciated!
> 
> Have you tested your changes?

No, as I'm afraid I don't have the hardware.

For patch #1 though, I'm not sure that's such an issue, as the
refactoring was really simple, even though the diffstat has ended up
being quite large! I probably should have submitted that one
individually without the RFC tag. Absolutely loads of functions have a
sleepFlag parameter, but I only found one case where this was actually
set to NO_SLEEP. Otherwise, if you follow the call stack it always ends
up being a sleeping case. I verified this by changing functions one at a
time and compile testing. Would you like me to resend this separately? I
feel that this should probably be merged in any case before we discuss
any of the other changes.

If someone who does have the hardware would like to test it though, that'd be
great :-)

Best,
Alex

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
