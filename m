Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D309C3527A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358173AbiDFBIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452390AbiDEPyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 11:54:51 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF150463;
        Tue,  5 Apr 2022 07:54:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h16so8188245wmd.0;
        Tue, 05 Apr 2022 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=ZgloS23OHbbWJmMWCBBuxDQhTcLsXy3usgzVwJSOKgk=;
        b=IZ5zhCimPIiAsz0DRrHxkz6PkwkjPuFniWAHfKJziaaJrfFbpYjZuJGaMF8O541WDU
         fa7nFrPAgZOkHDqMa5NV4j64ioctuzTP5KY4v+CVHa9ie5efzsdPBr4rWv6xDankrbod
         mNPxtwYZpOlyz/xP0BvwAB8foKwqOEH/JvEw/XYo1Y46hh/IwSZEZxPO+gn3CEKqAmch
         Y3txROz/BrhKCeVLZkVoGtq43FsJyivRvYQFmbFijwCqmXKBxVzn1Q2j/Ln4F9kuHVAp
         jR0ukyxQE8zRFZwsQDtJ6m+7pxEnjySQoxVjt53r9IfHzTHd7mS+46i0C96usXJzF8aV
         lBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=ZgloS23OHbbWJmMWCBBuxDQhTcLsXy3usgzVwJSOKgk=;
        b=mD9DXTXxunSCKZZ2wRhKgxM4yk5bnee8yjTpmJ3zJXfFEHgRGOTYB9vDzeH+nW9z5V
         wa/OMZm5rf7xCcmx62k7il0kAq5dCA7eA5SfXiCNKF6ub8PNtl5Lz2q6CCe5Si00wajj
         qJiY/jGFIPsplv+l/hsYnsxTsyK3v25T6bNkCeNj3uCzjpvVQVqR6pw8RSmL4A4PEuUW
         PzVRiYICMSe85ImDLt00FUvJgu6MtX/srW+TTC4hNziqgPefpczP+4MZKwtFuKCTRhu6
         QP6KZ+D+9e1magMrvMC6f77MvBH33GxGxyds1mAyPbxwNJie6qgMVGP3VeUQv21wE6Bd
         lNPQ==
X-Gm-Message-State: AOAM53176nZ0gGA3m/lwXGmITVLTcx+NMvp5+9bdaRBQkYasEMJVL7x5
        eNBy74t7VyPBO3YN0n6FOGw=
X-Google-Smtp-Source: ABdhPJzuEe7OsLIY9AfwcG+I3E3XAqgVLzqCt8GNajGHJBJi7D2qTPcOGnYa5vyjo04qwdEoRMmBPA==
X-Received: by 2002:a7b:c341:0:b0:37b:c619:c9f4 with SMTP id l1-20020a7bc341000000b0037bc619c9f4mr3536266wmj.38.1649170473374;
        Tue, 05 Apr 2022 07:54:33 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm17662993wry.72.2022.04.05.07.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 07:54:32 -0700 (PDT)
Message-ID: <8b3ce88f65fd11523a4d2daab3c617f7089eb1ce.camel@gmail.com>
Subject: Re: [PATCH  v2 0/4] rpmb subsystem, uapi and virtio-rpmb driver
From:   Bean Huo <huobean@gmail.com>
To:     Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        linux-kernel@vger.kernel.org
Cc:     maxim.uvarov@linaro.org, joakim.bech@linaro.org,
        ulf.hansson@linaro.org, ilias.apalodimas@linaro.org,
        arnd@linaro.org, ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Tue, 05 Apr 2022 16:54:32 +0200
In-Reply-To: <20220405093759.1126835-1-alex.bennee@linaro.org>
References: <20220405093759.1126835-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alex,

Thanks for this unified RPMB interface, I wanted to verify this on our
UFS, it seems you didn't add the UFS access interface in this version=20
from your userspace tools, right?


Kind regards,
Bean
