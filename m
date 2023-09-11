Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C79EE3F05
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjIKUvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbjIKI2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 04:28:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FC8FB
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 01:28:11 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4cbso5199289a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1694420889; x=1695025689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBxIxDBPX2uE4bhwMr4vV3mzF4qpVG8rCPy6CtitBO4=;
        b=jEKxd9edzah7j7EDVgWbhAucH3WVsLNYo60IZQ1MvRGez96AWwUrJAi/BqFJDhrfg8
         tNTVL4fnkDCIShyVzSLlYXS+S2nE4RqS39uPVsRUiTxylpZTlvRFRgc/JjkX2RB1QSlp
         pFmxJ57wSxS8l1oSx2vYcbp8Ep5JfUeh2RrDFNcyFlRltKrgF6DkR0On9mhK4ydWyzSo
         8cF2KwLxhAELSLeTbiTTkS8G4b4bzwjmbqLjjWUNfwsakv1pr1sh0zbmy8eT8HiM7rDu
         d+nW1o6NnYBpsiTcEoON87XjZWPFzh+dPcAvCaoxnl4fwynWTq0i4tbhy4O8d8c55dii
         Fl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694420889; x=1695025689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBxIxDBPX2uE4bhwMr4vV3mzF4qpVG8rCPy6CtitBO4=;
        b=PZp+j1fhU4DIpP2V/YWEXPZRDF/otYBHlzXhZ4E9NWsBge/h7XJhJKIwDGW0r6iGYi
         q7OSXku2dwoEyu5ep0JcIl+irfingnhqT0FMBd0RJv4JuimoTzxRvGy7OhjSW7NleAwa
         ldx973MhoybfUao+zGBxD1v8icxj82XMFZAsJlP02pabOIGylcV1+LVqJgVUTry4yTnO
         1Y/WfRAGc92ITlh2w6C9CRtwXPQATf+qlQygh5/6A7+zrzF5tbKeXtCB/7cAeJ2uWpDc
         1/VqYLklVq88Z8Eihxm1ud09Uk+C7Y++WI/AEzH711Di13hNlj/eIl7z/w0g7qG9B1Ve
         7oYw==
X-Gm-Message-State: AOJu0YzEvnx3IsZx9PXFa7JVWrsGD3pBd1ia2IcHqjS30e/tGnrSFDoD
        SXfjpChfuGODnrsnn0T4yShzNJdQsHi/HQ5jRWphErkNC9fRUXkPn48=
X-Google-Smtp-Source: AGHT+IHszTxyQyEAdAC4oLjOHzyZvzcPxVVDhxQDlDiSQrzAaYli4cCufb3eqDnYWirIeLCBj1B49LA8AHEAx7lmpnw=
X-Received: by 2002:a05:6402:138d:b0:523:1ce9:1f41 with SMTP id
 b13-20020a056402138d00b005231ce91f41mr6895754edv.18.1694420889633; Mon, 11
 Sep 2023 01:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230911030207.242917-1-dlemoal@kernel.org>
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 11 Sep 2023 10:27:58 +0200
Message-ID: <CAMGffEk5ALBPpAUay5v73t4Tp8tE4rDfqoFURZjHQn3_vvNpjw@mail.gmail.com>
Subject: Re: [PATCH 00/10] scsi: pm8001: Bug fix and cleanup
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 5:02=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> The first patch of this series fixes an issue with IRQ setup which
> prevents the controller from resuming after a system suspend.
> The following patches are code cleanup without any functional changes.
>
> Damien Le Moal (10):
>   scsi: pm8001: Setup IRQs on resume
>   scsi: pm8001: Introduce pm8001_free_irq()
>   scsi: pm8001: Introduce pm8001_init_tasklet()
>   scsi: pm8001: Introduce pm8001_kill_tasklet()
>   scsi: pm8001: Introduce pm8001_handle_irq()
>   scsi: pm8001: Simplify pm8001_chip_interrupt_enable/disable()
>   scsi: pm8001: Remove pm80xx_chip_intx_interrupt_enable/disable()
>   scsi: pm8001: Remove PM8001_USE_MSIX
>   scsi: pm8001: Remove PM8001_USE_TASKLET
>   scsi: pm8001: Remove PM8001_READ_VPD
>
>  drivers/scsi/pm8001/pm8001_hwi.c  |  89 ++-------
>  drivers/scsi/pm8001/pm8001_init.c | 322 +++++++++++++++---------------
>  drivers/scsi/pm8001/pm8001_sas.h  |  11 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  59 ++----
>  4 files changed, 202 insertions(+), 279 deletions(-)
>
> --
> 2.41.0
>
Thanks for the patchset.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
