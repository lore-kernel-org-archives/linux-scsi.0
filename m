Return-Path: <SRS0=ayNI=WD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BCEC32751
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 16:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6E2A22296
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 16:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBD4VQR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387987AbfHGQFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 12:05:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53047 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387626AbfHGQFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 12:05:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so591377wms.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Aug 2019 09:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kvxGyxH2R4MguxPxMoiGF/4nbAvKcJZ+N13SSPZxhrk=;
        b=dBD4VQR4HwddR5aihOf1S3q0Fv/h7BSg2Vw7fIYmqd7QA96QGtBkt1STa64DvwzFQ2
         82HXKWYz0dFT3ezRiOBdOBMHLXTJs2NkpIF3/zRZheae2nX2g4TAFXNp5dg/MODP0BK7
         Hfz+/+ImAOXsNWEYyLoYKcPQjJZI6ldbakt0OM7EySlxzCGtxM13NVnqoHHDAR3jnhCj
         R6zBq02QF/Pxk03Z0Yvta4wI0+WS1p15OXf2OnGQbhy4+n80/ato4XSlwBA5opVjWcjc
         fTuy3WvwkeEwiPv9EUDIdUBSRLLRIEY2pGMu+z/VdexwoirpQ25oJ1pFTd9B+fe0srZ/
         JVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kvxGyxH2R4MguxPxMoiGF/4nbAvKcJZ+N13SSPZxhrk=;
        b=FRGQ+7apHIbf00lHLqVdqt+h3p6pVil33UhBPZCv0urHjtMoy9NlL02QAxHbwBEQ9Z
         yYAT6teXCQDYRnVOosmzKWk28Djv1khhS+IHctbI/6zBlP+2evYhTI3TsQOhCDeC2gPf
         w9X7l2nfsKVQ2tL8qpl7WbF4PATEdx/2w6OglrQ2rHx/DeqHSGYddWT28k0zz6JIUgCh
         s5Y/pAX6RDmoByiI/KUfsqMHfL9N4WYjNdvp37WRxY6h9jOQLqHhF3QQs7w+uTshv+fc
         nWTjpEBZvjkY9qJm770i5/BwOGJN7FBkyxWZDCATVNF0A4hbd4e567uLhV6+WunklCZc
         S99Q==
X-Gm-Message-State: APjAAAUHTuBcQvUDaL+pEt3wYs4dzmcHVRIrdSMZN/GItfA33kEn4sBY
        ap0fcqx92W2CzW5IKEEonQ==
X-Google-Smtp-Source: APXvYqxtqI6f3P9lSbPbinbbmdh71tNiPhH7vHQVVrTXMVqbY+2hG8WDmI9nlpMA9vX3ab5U9fBXWw==
X-Received: by 2002:a1c:6882:: with SMTP id d124mr663180wmc.40.1565193934678;
        Wed, 07 Aug 2019 09:05:34 -0700 (PDT)
Received: from localhost (118.red-88-12-24.staticip.rima-tde.net. [88.12.24.118])
        by smtp.gmail.com with ESMTPSA id y7sm617460wmm.19.2019.08.07.09.05.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 09:05:34 -0700 (PDT)
Subject: Re: [dm-devel] [PATCH] ALUA support for PURE FlashArray
To:     Brian Bunker <brian@purestorage.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
References: <EF473529-CF81-4AE9-BD96-08624B59BA10@purestorage.com>
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <ef113ecf-e564-a959-870e-b80af8fe5a30@gmail.com>
Date:   Wed, 7 Aug 2019 18:05:32 +0200
MIME-Version: 1.0
In-Reply-To: <EF473529-CF81-4AE9-BD96-08624B59BA10@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190807160532.0kbSytyWFh-XQ0Cl5ltbD0v7VoOdEfoZcguzQ9vBwZo@z>

On 6/26/19 7:37 PM, Brian Bunker wrote:

> It has been some time since we updated our PURE FlashArray configuration. The
> Linux vendors that we had been seeing in the field were using very old versions
> of multipath-tools, so we haven’t needed to change anything for some time. With
> the release of RHEL8, some of our earlier values have been lost by upstream
> changes. 
> 
> In addition we have our Active Cluster feature which leverages ALUA since our
> last patch. The ALUA confguration will work for all FlashArrays with or without
> Active Cluster.
> 
> We are changing 3 things.
> 
> 1. ALUA support
>
> 2. Fast fail timeout from the default of 5 seconds to 10 seconds (We need this
> for our FC NPIV port migration).
>
> 3. Maximum sector size of 4MB. Some Linux vendors don’t honor the block limits
> VPD page of INQUIRY).


#3, kernel or udev bug?


> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1d964333..37e97f60 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1024,7 +1024,12 @@ static struct hwentry default_hw[] = {
>                 /* FlashArray */
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
> -               .pgpolicy      = MULTIBUS,
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .hwhandler     = "1 alua",
> +               .prio_name     = PRIO_ALUA,
> +               .fast_io_fail  = 10,
> +               .max_sectors_kb = 4096,
