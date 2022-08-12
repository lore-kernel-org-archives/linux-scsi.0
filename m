Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EE8C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 04:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiHLE5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 00:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiHLE5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 00:57:50 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D495979DE
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 21:57:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id uj29so155974ejc.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 21:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=esCwiaYMyxPm/0WM1CWCnpWQTYpwGXFmhJ7X2Uu3/Yw=;
        b=JONVOUJyQDPrSdFLQKezRHZn0cp7/xVwESrOSFkwCyzegHoJlMH9SrHVAAyyVAOnMF
         E7mLuuSB1vKmcfJNNcFSxEZuTAo6BghXLL/OpaDMscy9y4LE4INDNTVcTT8BISaWhSm8
         yXU0nbrZTVOTL70bcgHgJOIUxBHXtXqAHwyOl0hF28kSfGin/QdbXOASmgE0b9rrhOWQ
         RlF8bs2/vL08Qkvu9DQuWJ9Q83eLHUSG/ZYA3xb7guXdbvHGGIo0fm/MBwU48lxCKFID
         1m60ntbTzGAor8NagR1I/WzxPqBKhFVNf6bwrimZ21eJTyG4z4YNIku66YO0s1yi/+UM
         OYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=esCwiaYMyxPm/0WM1CWCnpWQTYpwGXFmhJ7X2Uu3/Yw=;
        b=C7fFy25lA4199IAuymJBWDZmW3VSnyH87o1akWjPS7Bis328UfA3G1IkxChIaP2RpW
         EGSOq4WARQ2DMERDzzNyRTf3y6QFiNZlI2KWws29o7Suu54dD1bF+SWj00SvCstQNcwG
         2N+miiCkSHMTVIOBW7dN9jGjzldCvpObGnPUenW+2+heoPUO7Vm9eDmoVRgxB3JR/ArE
         8Z4TEWc+oIcYA6Eoj044YEPRNssjtCh7Nl6W4xevxBW2kG2a9QLCQAr+AuOzMSie9bh4
         SUaBr/N9TfzqNZ63xlQXd3X1vNszxug3ZENDHqrCxshU/2bDWaoYp4ZIDlVSCLuFcRyt
         spMg==
X-Gm-Message-State: ACgBeo0OsQhc8OPjXj6C05AATh5QlFs99kvDdB1MGGS4c4wCSHg1gql4
        uOFZNoKToq5sQTFbEvLNgx7EfaAZQE16jBtC5FvatA==
X-Google-Smtp-Source: AA6agR470OyVHzqds4bFdjKNCgWVMFNHfGSWvdl3gh6dNrGtXRPkPR8GBoj2tyRgsTBlmUFU9ZBQM9KdU0GWgNHJz7E=
X-Received: by 2002:a17:906:d0d0:b0:730:9352:7484 with SMTP id
 bq16-20020a170906d0d000b0073093527484mr1546202ejb.70.1660280266721; Thu, 11
 Aug 2022 21:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <1658489049-232850-1-git-send-email-john.garry@huawei.com>
In-Reply-To: <1658489049-232850-1-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 12 Aug 2022 06:57:35 +0200
Message-ID: <CAMGffEky_UeLbEBKWEMjuJ6B6QFuj08uOuUMZK9Qwt+1Gxxqug@mail.gmail.com>
Subject: Re: [PATCH 0/6] libsas and drivers: NCQ error handling
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@ionos.com, damien.lemoal@opensource.wdc.com,
        yangxingui@huawei.com, chenxiang66@hisilicon.com, hare@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2022 at 1:30 PM John Garry <john.garry@huawei.com> wrote:
>
> As reported in [0], the pm8001 driver NCQ error handling more or less
> duplicates what libata does in link error handling, as follows:
> - abort all commands
> - do autopsy with read log ext 10 command
> - reset the target to recover
>
> Indeed for the hisi_sas driver we want to add similar handling for NCQ
> errors.
>
> This series add a new libsas API - sas_ata_link_abort() - to handle host
> NCQ errors, and fixes up pm8001 and hisi_sas drivers to use it. As
> mentioned in the pm8001 changeover patch, I would prefer a better place to
> locate the SATA ABORT command (rather that nexus reset callback).
>
> I would appreciate some testing of the pm8001 change as the read log ext10
> command mostly hangs on my arm64 machine - these arm64 hangs are a known
> issue.
>
> Finally with these changes we can make the libsas task alloc/free APIs
> private, which they should always have been.
>
> Based on v5.19-rc6
>
> [0] https://lore.kernel.org/linux-scsi/8fb3b093-55f0-1fab-81f4-e8519810a978@huawei.com/
>
> John Garry (5):
>   scsi: pm8001: Modify task abort handling for SATA task
>   scsi: libsas: Add sas_ata_link_abort()
>   scsi: pm8001: Use sas_ata_link_abort() to handle NCQ errors
>   scsi: hisi_sas: Don't issue ATA softreset in hisi_sas_abort_task()
>   scsi: libsas: Make sas_{alloc, alloc_slow, free}_task() private
>
> Xingui Yang (1):
>   scsi: hisi_sas: Add SATA_DISK_ERR bit handling for v3 hw
>
>  drivers/scsi/hisi_sas/hisi_sas_main.c  |   5 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  22 ++-
>  drivers/scsi/libsas/sas_ata.c          |  10 ++
>  drivers/scsi/libsas/sas_init.c         |   3 -
>  drivers/scsi/libsas/sas_internal.h     |   4 +
>  drivers/scsi/pm8001/pm8001_hwi.c       | 194 +++++++------------------
>  drivers/scsi/pm8001/pm8001_sas.c       |  13 ++
>  drivers/scsi/pm8001/pm8001_sas.h       |   8 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c       | 177 ++--------------------
>  include/scsi/libsas.h                  |   4 -
>  include/scsi/sas_ata.h                 |   5 +
>  11 files changed, 132 insertions(+), 313 deletions(-)

Thank! John and Damien,
for pm80xx.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> --
> 2.35.3
>
