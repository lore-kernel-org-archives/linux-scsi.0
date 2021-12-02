Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CEAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 15:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358997AbhLBPra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347967AbhLBPr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 10:47:29 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B07DC06174A
        for <linux-scsi@vger.kernel.org>; Thu,  2 Dec 2021 07:44:07 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id c4so60521065wrd.9
        for <linux-scsi@vger.kernel.org>; Thu, 02 Dec 2021 07:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=E9lzNdkn7909m1FchmdwxHZSjGvdcsYgvDGh/LoZ6As=;
        b=I3dI/zOfMxZQp8QFo0z0ELPyraPXvMTYfGIp5iG2BQFlsqqGx1N+D9Q86e0QqjhBBS
         /4W+qF3sgX01eYt9jHKKBh1DRvuuL3bG6iFncsFQo0gkNjiDHPOtbH7IP1gnGDJ4JXFY
         8bx77Nr9wPxOdXJs7o97s0eitsIuE7XBtpMTgI/4ogS/g4R1zjd4lIupRnML6mABBELz
         Ol9D3uGR+qj5xGKETTuqNm0tTG/PKozJ0RfUXbN+T/z/69NFgGkvmGl6I9QGj9I1g+fb
         nC5Hb2WMUa/6dEzKRii9tzLqSDyOKN2HYor4pXmQMDe3yrzoFsPhY2rm0m6xMXBod7zn
         0IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=E9lzNdkn7909m1FchmdwxHZSjGvdcsYgvDGh/LoZ6As=;
        b=IKcjUdH+Mc3ZM+TlbYDttAonolQ/H9j721PpGL9PP0E4tc1GyaP9BBO/hdQ31ZDRWI
         pifubA7hQF3vIokdZYZVKAEQ5zVrs49j+i/11a87fARCaaHHqZFSVcUhBnbPFFwenjkl
         bf6ygzpY6hcAxN5BW8OOxW+4T1QnFrFkLqfJz2j22T39PBQMirJSk/tcvu+87PI85WzJ
         PIBOxSWFqcvAeOT46K3iZk0Lv/YQ2kH6IkirWToJJi1ZTHac0+JVccBENpbGT4EbiH1T
         uaJUOE3lPY2CnBd+S5hYq/FyaRxAWSZulo7BsxWOMO/2uU/Z4bctp7N+tW2QF/45Zgar
         u2kw==
X-Gm-Message-State: AOAM5308K8oDGoNMDgNNL8az47l3/FokKR6qfwtc0q0li4Rqcqz1leDo
        WiaGzAS+OiBu6CXftPIPpPQ=
X-Google-Smtp-Source: ABdhPJxsdgmmh/GmSG8+MUHyn2KOJ/UPNtD7irGkHpkNzjpDxj3fWaq2h6WNclx9XKxWlVhcjuu1ig==
X-Received: by 2002:a5d:6849:: with SMTP id o9mr15113048wrw.515.1638459845828;
        Thu, 02 Dec 2021 07:44:05 -0800 (PST)
Received: from p200300e9471019d1b21724649ae7b436.dip0.t-ipconnect.de (p200300e9471019d1b21724649ae7b436.dip0.t-ipconnect.de. [2003:e9:4710:19d1:b217:2464:9ae7:b436])
        by smtp.googlemail.com with ESMTPSA id d2sm29146wmb.31.2021.12.02.07.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 07:44:05 -0800 (PST)
Message-ID: <0f4719c4d62df1e85430a7422d5628adb6f2b4b3.camel@gmail.com>
Subject: Re: [PATCH v3 00/17] UFS patches for kernel v5.17
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Date:   Thu, 02 Dec 2021 16:44:04 +0100
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Reply in the email to cover each sub-patch:

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>


On Tue, 2021-11-30 at 15:33 -0800, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series includes the following changes:
> - Fix a deadlock in the UFS error handler.
> - Add polling support in the UFS driver.
> - Several smaller fixes for the UFS driver.
> 
> Please consider these UFS driver kernel patches for kernel v5.17.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v2:
> - Dropped SCSI core patches that add support for internal commands.
> - Reworked patch "Fix a deadlock in the error handler" such that it
> uses a
>   reserved tag as proposed by Adrian.
> - Split patch "ufs: Introduce ufshcd_release_scsi_cmd()" into two
> patches.
> 
> Changes compared to v1:
> - Add internal command support to the SCSI core.
> - Reworked patch "ufs: Optimize the command queueing code".
> 
> Bart Van Assche (17):
>   scsi: core: Fix scsi_device_max_queue_depth()
>   scsi: core: Fix a race between scsi_done() and scsi_times_out()
>   scsi: ufs: Rename a function argument
>   scsi: ufs: Remove is_rpmb_wlun()
>   scsi: ufs: Remove the sdev_rpmb member
>   scsi: ufs: Remove dead code
>   scsi: ufs: Fix race conditions related to driver data
>   scsi: ufs: Remove ufshcd_any_tag_in_use()
>   scsi: ufs: Rework ufshcd_change_queue_depth()
>   scsi: ufs: Fix a deadlock in the error handler
>   scsi: ufs: Remove the 'update_scaling' local variable
>   scsi: ufs: Introduce ufshcd_release_scsi_cmd()
>   scsi: ufs: Improve SCSI abort handling further
>   scsi: ufs: Fix a kernel crash during shutdown
>   scsi: ufs: Stop using the clock scaling lock in the error handler
>   scsi: ufs: Optimize the command queueing code
>   scsi: ufs: Implement polling support
> 
>  drivers/scsi/scsi.c                |   4 +-
>  drivers/scsi/scsi_error.c          |  22 +--
>  drivers/scsi/ufs/tc-dwc-g210-pci.c |   1 -
>  drivers/scsi/ufs/ufs-exynos.c      |   4 +-
>  drivers/scsi/ufs/ufshcd-pci.c      |   2 -
>  drivers/scsi/ufs/ufshcd-pltfrm.c   |   2 -
>  drivers/scsi/ufs/ufshcd.c          | 268 ++++++++++++++++-----------
> --
>  drivers/scsi/ufs/ufshcd.h          |   7 +-
>  8 files changed, 165 insertions(+), 145 deletions(-)
> 

