Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94B2C00140
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 00:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbiHCAHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 20:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHCAHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 20:07:17 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF661B7AB
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 17:07:16 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 7so26056732ybw.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 17:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LID6PppF1z9gU+tE6VsSkmWpd5HwGrNeV2dSIOGuA9k=;
        b=Lf18+jbV2UHRV/jigCpNlahlOqXbOsj+3twVjafJ32gIl4GTS+DO55MDRDfIp5+iK9
         jTZvrs/e74OjWNegBJbAS53Ax2qq4oVZ2fZHSp48wqyEJp9zEg6Hr4CnyjK5p95zA6iT
         5VqBLOt+Sw1muSECHxqOVTp/7AmpbucV2yPrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LID6PppF1z9gU+tE6VsSkmWpd5HwGrNeV2dSIOGuA9k=;
        b=2ishK+zBjagOeFPZLF1x9Az1Hayu0zNyovClCum5+Ald7Wrczz6sn9vBGVXkxtTOGS
         trBIVMm1aMxlL2FiR7vi++WFXQZFl+5PyEiHroQuKHwreY95osyE5Gd7gmf/dOQpRKxU
         SJ6VTG+IcvAUeXbQOEM1ZsWBTbt8JjTMnMB43Qeug3HlUGsZFBYcGentWyNlPnSaenQO
         B0tKxbw0aVmOkg++fa+JIzRcXwXDzTa6YwbMDquH6WjTZKDx6ZDfUZjX9Hbpc7rGQnig
         8CulkpYVYdg68vxohpduNXjnXhlTZbnC4n9nj5fuTiwSb5Ij+FJuN8C7S84cDwZ3EP5M
         aXww==
X-Gm-Message-State: ACgBeo3/8Yk+6xgsU+G4oIvUoT/c79fXDyC4Fd9VSVxjL116V/nGgjIw
        rGAjsCKjA6WLPAABD6OSVNUCKkBj0RpZEArNHEPVZw==
X-Google-Smtp-Source: AA6agR6XURFQzTpCJvJlNfHGiJqZ1o8ve0q4LDXLowmGVtIyFzCNGuJhimroNdxvpjpPUyPBIsrvp6/APYPAuEIJ1qY=
X-Received: by 2002:a25:cf91:0:b0:671:83db:c8f9 with SMTP id
 f139-20020a25cf91000000b0067183dbc8f9mr18188088ybg.535.1659485235638; Tue, 02
 Aug 2022 17:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220803074349.v4.1.I699244ea7efbd326a34a6dfd9b5a31e78400cf68@changeid>
 <CAGaU9a8H7QmkhBvNfZhH+CyFaup1oGX1j7a36ph9t+Me3MjCQw@mail.gmail.com>
In-Reply-To: <CAGaU9a8H7QmkhBvNfZhH+CyFaup1oGX1j7a36ph9t+Me3MjCQw@mail.gmail.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 3 Aug 2022 10:07:04 +1000
Message-ID: <CAONX=-cSKdWGAqadzvrdJyZfL+PGOM7V0E1HcHuUny4V00JiUA@mail.gmail.com>
Subject: Re: [PATCH v4] ufs: core: ufshcd: use local_clock() for debugging timestamps
To:     Stanley Chu <chu.stanley@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Please kindly add all Reviewed or Acked tags received in previous
> versions to any newer patches.
Oh, thanks for this suggestion, I didn't know if I should do that. Should
I create a new patch with those brought over?
--Daniil
