Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666BBC28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 09:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiHVJDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 05:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiHVJDQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 05:03:16 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAF618F
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 02:03:13 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-32a09b909f6so275223057b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 02:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EuziAoq5ZbtPrSZbeUk8bQqTzuyS7XPxbOwKK2h6M3I=;
        b=Sw3kIy20SNGugBW8dL2ZMcQGAgqJ/0rc8tznUC4Q0+BOOO85ccRBiVpJitf6eK1Iaa
         RjQCiALJNCBQ6CFRTYn5FHPW8bV5kgVDvlP6Yq32hZslXgIJmJr+Jna1zxeXneR38Ihj
         34zAejNuIsR38piTK9NXJDONa4Y76Jh9fsQBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EuziAoq5ZbtPrSZbeUk8bQqTzuyS7XPxbOwKK2h6M3I=;
        b=aqB59jO3Bcsi0jzYyIYN+wywYaihdZ3quKvBC3sPzrtLpg9UNFE+tjg5CY0QoUMrrV
         OaZj6c3o6jLAF9WqJHw1qZ2UZ3YYcroabvsIRaklcBpq4YvrnEAEFsb5AcqLW0ZEW8wN
         e7CghheBWD6Ic04yd9tX/cqAWFYZGiw6ckyQPoj9VaMGXgowN3azvYLy3Q+13ji9Lhtx
         uC3TylbMVPAjFnLWhK0glJTo7CDX6WTmBiTQ07MS7GTQuNF7OTd3CmBb2B/A+j5BpsbR
         vOnXZ9ZVCygNvBmHrhZ0pjDfMaqHem0nVsXV06oWPcl3aGAH+/ZvSmIsxRDBoD111ZIj
         WHpw==
X-Gm-Message-State: ACgBeo3V7XjhfpB66Qef3wI9tuUqM/zFefKenhliAIKxpQHxRd13Zkqa
        EmBsANLUaU8R/YEZSUeKP5T7vKuso2oQIZgw2u7wpQ==
X-Google-Smtp-Source: AA6agR6APdt78F3uw+1hsI55dL+JHbLtSlHcfqi0jLhAPn0QEEgxu7vETGl/x/2GaGSTbsdSnHe62HeLvEmG/XpC7hM=
X-Received: by 2002:a05:6902:100b:b0:695:bd4e:95d6 with SMTP id
 w11-20020a056902100b00b00695bd4e95d6mr2569366ybt.595.1661158993033; Mon, 22
 Aug 2022 02:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220815104739.v7.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <Yvnq5o5f+qp5zs1c@kroah.com>
In-Reply-To: <Yvnq5o5f+qp5zs1c@kroah.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Mon, 22 Aug 2022 19:03:02 +1000
Message-ID: <CAONX=-fScRJt-j1USO6gKXm780S=XBGHVc_LUziSZDiStc5P6A@mail.gmail.com>
Subject: Re: [PATCH v7] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 15, 2022 at 4:42 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Please provide a lot more information about this in the changelog text.
> What would you want to see here if you had to review this change?

Hi Greg,
Sorry for toppost, let me try again.
Can you clarify what specifically is missing from the changelog?
The comment used to be on the "c" file, but now is moved to the
documentation. Is there anything specific missing? Or do you
mean commit messages?

Thanks,
Daniil
