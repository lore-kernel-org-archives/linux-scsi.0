Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AACC04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 23:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiG1XIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 19:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiG1XIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 19:08:18 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7885252463
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 16:08:17 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3238de26fb1so16273887b3.8
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 16:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XoO5+n5lAtjmhTQDOVl7dv9SMJLx74LKvYh0rgO002k=;
        b=lf+VaVNgHbKzynF2J+uFL/65qWQblyv/9uz1kSSTpdG+YcE1xSbVSN3ZjSlOkui0LD
         oxqD0UuKiRQ6Wrjxnp/A+jXV/dUGvANr6EOypo48O2JJ77SzZsaR7by4hiY8JFm99JXI
         Fsnz8aeYw6gS4lZqBQ7h1C98wUa1NEGt7LYO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XoO5+n5lAtjmhTQDOVl7dv9SMJLx74LKvYh0rgO002k=;
        b=vtZ7/cyhlvAUT1bOccM/cOROrtflxJoAKzpObGVu4t3TRicZBxIss/gCDncyWqnocv
         +nKxv1mAiVWxnHawXDZuzqeIQ/C9qnVyc2/7Wb0/FHdX+VUxKgz1v0bq616Pk3jpN7C0
         6coTUhtyTrP5XH0N3htJojfwrtKXCXZBZ+dXKaGQCwtNAasPXzx9nn2rhHiCbBkpO3bQ
         Fh978yCXZG1XJCOl/FznYnWv6TUQpwFq2LZOHT63haoxI5S2bD9cQn8kUn5oiIzmsgVS
         rXqNckws12YZdONSBIN3+EiAKqG7plenyKMUe2soYeBm0RzedSBFJUwGC6qvqqfCCUa/
         aNTg==
X-Gm-Message-State: ACgBeo3g7KTM4JxpDAfTWOzI0PjQu+tn5oDg5jczJvwqUPilbqba+MsM
        uTQB0RNxhYfxJjG0vGzijw1Sb/4XDpiBBThnLnm3Sg==
X-Google-Smtp-Source: AA6agR5oRXRMaifdJbmmaXl+CGlcWTtqcKz1yXvC0+ms6Icr72IEbWbAZYkNL79SKIo5v7cCLBJh1TyvepcI/Wm0FFo=
X-Received: by 2002:a81:81c1:0:b0:31e:7378:960c with SMTP id
 r184-20020a8181c1000000b0031e7378960cmr947411ywf.266.1659049696719; Thu, 28
 Jul 2022 16:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220728144710.1.Id612b86fd30936dfd4c456b3341547c15cecf321@changeid>
 <28005e66-ba90-8986-1b8f-b76bba46064c@acm.org>
In-Reply-To: <28005e66-ba90-8986-1b8f-b76bba46064c@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Fri, 29 Jul 2022 09:08:05 +1000
Message-ID: <CAONX=-d-_2bXqf0TCjdJ1u+B3cU3ZkP9WCu3QxqSZT-v3E_4BQ@mail.gmail.com>
Subject: Re: [PATCH] ufs: core: print capabilities in controller's sysfs node
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 28, 2022 at 11:37 PM Bart Van Assche <bvanassche@acm.org> wrote:
> This code change includes all of the UFSHCD_CAP_* constants in the
> kernel ABI. Is that really what we want? I'm wondering whether it
> perhaps would be better only to export those capabilities to user space
> that user space needs to know about.
Adding the filtering would introduce an extra maintenance burden and
will likely go out
of sync. I don't see harm in exposing all capabilities, both intrinsic
to the controller and
negotiated with the device. Do you see any scenario where that would be harmful?
--Daniil
