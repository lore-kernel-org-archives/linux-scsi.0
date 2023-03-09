Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46989C6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 14:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjCIOwH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 09:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjCIOvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 09:51:37 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065B6F0C42
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 06:50:11 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1420679wmq.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 06:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678373408;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L8kWZWSHPHOOlfiunyY6FoAdTKK8YhjRAezIkpp/jQs=;
        b=ez8bFX/ePfpEx5GKraUEHM971MTkD/mz4N//WodhCaLS02N3I9dY0UhW960gz+9/je
         cFzOjAP/5U0wG8bS/XQx/llQxEuyhkpp3qT2WqFMx6+CPTZeYe0aCbFjoTmtbX9jrHOY
         nP2A6zBWQ38QD/jblbZQbkVItNAJdp16KwFSkGg90pfn2fhWSHbCusO3hH4zCB9uIfw1
         Qg9EmrnIY9kNRKzhqoDXIX66ScmB4x3wTByx1mfzCT47CQ9H8ESppWUlaXTvrzkOltj/
         dPxqWupMIGtSHEluZumu56G9gXYeB7ymFmhkKSwytRPYacXRJoTo0bwVVQPFay2sOyrf
         WTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373408;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8kWZWSHPHOOlfiunyY6FoAdTKK8YhjRAezIkpp/jQs=;
        b=k64z9ycEkNs2GdVUfsjYYJDkzoZo6me00zE0bY1xIeZVL5alYgS8UUgacZhHw+9MLh
         FhUSeNIYWJs+to1K2NARzfYrkoHSpDhpLjeXihwhVw2Ydr+7s6anVUEm+L/gCyznxIkT
         zlXzikPy9LsvXw/1aqyxzEqNsfhJ8AY0GALga50HASgShugu32yoeqOKzACov4k9T+u+
         koCuO8G4ZT+wtKHsj6M12TlDGBQO+sDqcZEBVHgf7uIfxkrsS5486RCybxzu9N48C8Kj
         E73IVOC9Lbp39noRIb/HSs4Dyu+b7mBOYR5qyWgSRlLX1y98oRSyEz6ffGBunFHFiXDU
         Qu9A==
X-Gm-Message-State: AO0yUKVbpodkOo+sXqVnASUFoxhrX3dl6G6nVMPmS5ebrV7M/leugo23
        cP2qsU1vevNKqG9rJ16Rnv9hDkvWrb8=
X-Google-Smtp-Source: AK7set8kTjDUoYqiX6a7YbmeO+mYzNyr/ojEa/VWJBWUb/mAz4Y5zdtLJb6ctUQGLCM553/kGE4/3g==
X-Received: by 2002:a05:600c:46cb:b0:3eb:4cb5:e13 with SMTP id q11-20020a05600c46cb00b003eb4cb50e13mr20172579wmo.31.1678373408507;
        Thu, 09 Mar 2023 06:50:08 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f10-20020a5d4dca000000b002c70bfe505esm17809898wru.82.2023.03.09.06.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:50:08 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:50:04 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     ranjan.kumar@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpt3sas: Reload SBR without rebooting HBA
Message-ID: <36feaf8d-3454-4020-9997-9151bf00b332@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Ranjan Kumar,

The patch 2c6ebf96dfdf: "scsi: mpt3sas: Reload SBR without rebooting
HBA" from Feb 8, 2023, leads to the following Smatch static checker
warning:

drivers/scsi/mpt3sas/mpt3sas_base.c:7968 mpt3sas_base_unlock_and_get_host_diagnostic() warn: inconsistent indenting
drivers/scsi/mpt3sas/mpt3sas_ctl.c:2576 _ctl_enable_diag_sbr_reload() warn: inconsistent indenting
drivers/scsi/mpi3mr/mpi3mr_transport.c:2365 mpi3mr_report_tgtdev_to_sas_transport() warn: inconsistent indenting

drivers/scsi/mpt3sas/mpt3sas_base.c
    7931 int
    7932 mpt3sas_base_unlock_and_get_host_diagnostic(struct MPT3SAS_ADAPTER *ioc,
    7933         u32 *host_diagnostic)
    7934 {
    7935         u32 count;
    7936         *host_diagnostic = 0;
    7937         count = 0;
    7938 
    7939         do {
    7940                 /* Write magic sequence to WriteSequence register
    7941                  * Loop until in diagnostic mode
    7942                  */
    7943                 drsprintk(ioc, ioc_info(ioc, "write magic sequence\n"));
    7944                 writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
    7945                 writel(MPI2_WRSEQ_1ST_KEY_VALUE, &ioc->chip->WriteSequence);
    7946                 writel(MPI2_WRSEQ_2ND_KEY_VALUE, &ioc->chip->WriteSequence);
    7947                 writel(MPI2_WRSEQ_3RD_KEY_VALUE, &ioc->chip->WriteSequence);
    7948                 writel(MPI2_WRSEQ_4TH_KEY_VALUE, &ioc->chip->WriteSequence);
    7949                 writel(MPI2_WRSEQ_5TH_KEY_VALUE, &ioc->chip->WriteSequence);
    7950                 writel(MPI2_WRSEQ_6TH_KEY_VALUE, &ioc->chip->WriteSequence);
    7951 
    7952                 /* wait 100 msec */
    7953                 msleep(100);
    7954 
    7955                 if (count++ > 20) {
    7956                         ioc_info(ioc,
    7957                             "Stop writing magic sequence after 20 retries\n");
    7958                         _base_dump_reg_set(ioc);
    7959                         return -EFAULT;
    7960                 }
    7961 
    7962                 *host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
    7963                 drsprintk(ioc,
    7964                           ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
    7965                                     count, *host_diagnostic));
    7966 
    7967                 } while ((*host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Indented too far.

--> 7968                 return 0;
    7969 }

regards,
dan carpenter
