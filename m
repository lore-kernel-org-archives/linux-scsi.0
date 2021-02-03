Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4159DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 09:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FFA64E11
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 09:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhBCJqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhBCJp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 04:45:59 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F01C06174A;
        Wed,  3 Feb 2021 01:45:19 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b9so15023075ejy.12;
        Wed, 03 Feb 2021 01:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWGhO/R0pAuQVaURKT9FVGsTGqlU8Ef1ASYagpB/+c0=;
        b=pJ8vRs6O+XElTVmGNBL6byZPwrIt5RdeLiz4AImc5Lfz+68+Oz92JscqqJH0JN424W
         DKoB3TQ/aKp6roVHnGS6hVkSeA4IuFG6hKzNkV+6SRD8ONI5cmOZ6BYr9bj58m8Az+hP
         0E3CqFUcC+yehoN7nXmJwgjVeP02fELJ8hLkzkzbS1ExVkqAKxxvKfSlIFGtRCg8BkhM
         mqMTgH27fcmfKSn6z/z4dUWEFZe2YhHVwrmOM4RCxJHvaQEfGkjcqAGS4mFb+7t8LUxP
         LuV9B8AXMqlpKNU0++I4F0lyf460rF1rd76VhfHPg9swnszuMc01B3fLINP7BHh34Cjf
         Pldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWGhO/R0pAuQVaURKT9FVGsTGqlU8Ef1ASYagpB/+c0=;
        b=INQK3YNwojwwpR0kLI19AYdFeyloPgtAdtiPzh7lIsIpjZTd3ZDPAZkbdN5uUDR3Mb
         YLN/v6+XOfu3n+dr2W5VS/f7Hf27H9rNcua2LdZOsCoc2wkNKv+8cquIcmYwgF2IXGEe
         Oawz34yDjvo8bKIvxkpeft+zJjEVbZBM+nNEOAhIqzNDSHNQEa5sbCwiDK46Zr+HLu/P
         8kv5+AWbgbWbPFkuuv32RnduB7swxNJ/+m9NxQX2P+Ue00BLgGw+QCW2GaMFJozk+9KJ
         tnXnGJenRrIgF36gLAuYCdUzN9LukEbiv33cFyPbMyOj3WaJv7rxOjyfNfSieu7S7XrK
         OhwQ==
X-Gm-Message-State: AOAM532eHLwVWM0hoAI4vILljbGGrhoBeiVBCuPloSPlsz/16r7iCk98
        IfRxMZxYA6ef3qs6vR6cgmU=
X-Google-Smtp-Source: ABdhPJxa3RPqJgg+EqWVA5YI4G9NkuPkYgT1jCDjhNqVF3BzO/Q4qa5aCc9T7yEnAoutFBWkXt1tLw==
X-Received: by 2002:a17:906:a851:: with SMTP id dx17mr2253260ejb.537.1612345517919;
        Wed, 03 Feb 2021 01:45:17 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id bz20sm767023ejc.38.2021.02.03.01.45.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 01:45:17 -0800 (PST)
Message-ID: <85b6cbb805e97081a676aeb30fe76f059eba192e.camel@gmail.com>
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
Date:   Wed, 03 Feb 2021 10:45:15 +0100
In-Reply-To: <20210119141542.3808-4-adrian.hunter@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
         <20210119141542.3808-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 16:15 +0200, Adrian Hunter wrote:
> Allow users to enable specific exception events via debugfs.
> 
> The bits enabled by the driver ee_drv_ctrl are separated from the
> bits
> enabled by the user ee_usr_ctrl. The control mask ee_mask_ctrl is the
> logical-or of those two. A mutex is needed to ensure that the masks
> match
> what was written to the device.

Hallo Adrian

Would you like sharing the advantage of this debugfs node comparing to
sysfs node "attributes/exception_event_control(if it is writable)"?
what is the value of this?
Also, now I can disable/enable UFS event over ufs-bsg.

Bean

