Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDF1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 15:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E8964D9F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 15:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhBDPBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 10:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbhBDO7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 09:59:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA3FC061786;
        Thu,  4 Feb 2021 06:58:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id r12so5773175ejb.9;
        Thu, 04 Feb 2021 06:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTTiHduwnoXqR6b8TrKcHrHm61227F3QjrDLKsXeD7I=;
        b=SrYxamP4i+r8UNU02W7Z9zvldd7UYJ2fiJBl9hxzhqZ4/TOSWE6QqAMs5FgeZRvFMc
         DZFihkjaIBZ5fdvMG0bsmxkwHGnBhB48wX7LtRVQTaI4jL/RI+Zo0XVIgTfBA49IX1au
         thd9RR7Obc6ty0QQpY/oJsahU/Jj8/vfn0OuHbSMklMHJr/u935Wk2laCjaRjMFvEa6T
         RJLoz7UK2o4WSRqvnuj595rI5U4iPAsrk1x/nGj0hP7Sfv1/SnR1ghnO1eQ53N2OM6SN
         F/sIwUKUNsVlx75Sf+7OsG/qdnrTi2t13qPSavim+cihmCVf8yYGYOT5Nl/MeimrOnjl
         kWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTTiHduwnoXqR6b8TrKcHrHm61227F3QjrDLKsXeD7I=;
        b=mk9+JFLNHDRMm7Xyp5hORGPMHFb4cZA3JDTcs9sWMBLC/ZhgYW3t3/zvNJ+upmYtLo
         hJk51wE6s6xvrJWTuw9Bpj3bANsSXgTRKQ7kIedMFWTy/BNl3g8FGZvpbIsshR1cAWUK
         QNp0X2VYQ/wlGhT39o8MZGS8QfLzTTfnEa2xsSZ9C9ISY6czjtW/YuqIL0/yyoVLi3gv
         ZW5DjGPC+t7GnbsX1ZzeYx7s7VNWmhKtsP4MzT6GAAEym1uOagxhiTd1YIhA8N9wm+6F
         C5XKimHBqoJmQpi9+MuVjuFDW5CNFPb57N2xjhzK2pg49kdzAk9ZisuXr9J2rRjVv/n+
         +Gow==
X-Gm-Message-State: AOAM533cfKQxIz2mFpOQ+Idm8RJaO4OzN8c1xWNA3M1ufVDZb303aPok
        aOH3kq8C+oXjBFgyuz0xgsw=
X-Google-Smtp-Source: ABdhPJxUzoQqufvj3OQgO85FemOV70JYaabYPzt7rEoWKyi722zVpTRCn2XzVNwW2Yct/PbfAjP8Xw==
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr8463064ejt.56.1612450713780;
        Thu, 04 Feb 2021 06:58:33 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id qx8sm2565695ejb.48.2021.02.04.06.58.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 06:58:32 -0800 (PST)
Message-ID: <372c6dbbda18cccdcf2b053ee87f2ada9640e2b8.camel@gmail.com>
Subject: Re: [PATCH 3/4] scsi: ufs-debugfs: Add user-defined
 exception_event_mask
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Thu, 04 Feb 2021 15:58:31 +0100
In-Reply-To: <b7a812ed-8965-76cf-3d05-be2486fcaed2@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
         <20210119141542.3808-4-adrian.hunter@intel.com>
         <85b6cbb805e97081a676aeb30fe76f059eba192e.camel@gmail.com>
         <b7a812ed-8965-76cf-3d05-be2486fcaed2@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-02-03 at 11:56 +0200, Adrian Hunter wrote:
> > 
> > Hallo Adrian
> 
> Hi Bean
> 
> Thanks for the review
> 
> > 
> > Would you like sharing the advantage of this debugfs node comparing
> > to
> > sysfs node "attributes/exception_event_control(if it is writable)"?
> 
> Primarily this is being done as a debug interface, but the user's
> exception
> events also need to be kept separate from the driver's ones.
> 
> > what is the value of this?
> 
> To be able to determine if the UFS device is being affected by
> exception events.
> 
> > Also, now I can disable/enable UFS event over ufs-bsg.
> 
> That will be overwritten by the driver when it updates the e.g. bkops
> control, or sometimes also suspend/resume.

Hi Adrian
yes, I saw that, they are not tracked by driver.

I have one question that why "exception_event_mask" cannot represent
the current QUERY_ATTR_IDN_EE_CONTROL value? only after writing it.


thanks,
Bean




