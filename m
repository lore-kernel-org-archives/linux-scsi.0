Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6937BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 09:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiESJHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 05:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiESJHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 05:07:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF61B2E9E0
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 02:07:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p26so6198620eds.5
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 02:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=0AyRPpX8qhEKceAHkqVsDwKW4YWSZBazXFK5XCvmQYo=;
        b=pYMNx6Uovo9HffLcfN80ef2bDI/tkpk2EocYGVVrJbo+wdJTo3+ljZVRB3bYobWf9A
         BUyYQyTDGTZhflCrsSEeQ8qpBdi0Nof9GLYLVZbxcdFIBQ3CyD1r3AlLj/MjNYefPXR3
         ANZC0Y4rzBdqYm/yUKgTgbqS2KXDlyAAUo/ruTgo9u+ICrEgHvNOT0wESOy2/B2OwB3T
         B4KOW68/eXr+JI6IX1/BYFWBGNY81qtapDEKYlP6U7GtWJbiaDP8bhpIIqnTh3rJEjkr
         I96aJWCc4jWvtLkOz1dNfzowReo0pe7v6kqSKVccmo+t0sP/6YBGGkwff3Mm61W5JOme
         0NnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=0AyRPpX8qhEKceAHkqVsDwKW4YWSZBazXFK5XCvmQYo=;
        b=45nU8MWYGpLQDEn2L1SiWtBDNxUksqUJ2rnI9jvWyVn9wuqeO7aq9F2LJ8thFTbw+J
         aU94dYuPpOCWiW+hCMhqmbcgcFwS3Hd0SmaPoDCErHbyXi3XUoj8vfhpB4Sa4ghbOgi2
         dEztfRqzv8hdKl6957YELJsg0+Zhi8uvhXXRe7f1qFp/JU1W50Os7iZL0I7YAdpQ2fFK
         Kr1xFLutZ4Qp/nSkyraMYB+FQz+6CplYsnkDr9Hi1vw0/2+ROJD99ImjDpKy6vnPSNys
         9zFfaBQOaoYNoh8Tp2V9YtQR1YEED6cq330w53+x+SRip7ya9/9vH8fpWcxwV368yFiJ
         FwIA==
X-Gm-Message-State: AOAM531GHnXFHoie9fHzQ5jPwwCYDHN4IZiWhoMw7j4033pPiUWHATRn
        89FujpcKyDQwTskcklYFqB4=
X-Google-Smtp-Source: ABdhPJwiPUhhnOawScO15UEncRro1JnneqgT2eqzoAQrTKUbHqdZTPirlEiqAS7jumsYsF2NB+7qmQ==
X-Received: by 2002:a05:6402:90d:b0:428:c1ad:1e74 with SMTP id g13-20020a056402090d00b00428c1ad1e74mr4151137edz.345.1652951235467;
        Thu, 19 May 2022 02:07:15 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id d16-20020aa7d690000000b0042617ba63c0sm2593201edr.74.2022.05.19.02.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 02:07:15 -0700 (PDT)
Message-ID: <0a6abfbcdadccf6a47fbdd8393d769429fa54d7a.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>
Date:   Thu, 19 May 2022 11:07:13 +0200
In-Reply-To: <20220511212552.655341-1-bvanassche@acm.org>
References: <20220511212552.655341-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-05-11 at 14:25 -0700, Bart Van Assche wrote:
> Split the drivers/scsi/ufs directory into 'core' and 'host'
> directories
> under the drivers/ufs/ directory. Move shared header files into the
> include/ufs/ directory. This separation makes it clear which header
> files UFS drivers are allowed to include (include/ufs/*.h) and which
> header files UFS drivers are not allowed to include
> (drivers/ufs/core/*.h).
>=20
> Update the MAINTAINERS file. Add myself as a UFS reviewer.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Keoseong Park <keosung.park@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

