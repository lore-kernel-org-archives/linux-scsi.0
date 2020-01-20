Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B80BC2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D04EB22522
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aW+jYWBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgATNIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:08:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45134 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgATNIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:08:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so29454404wrj.12;
        Mon, 20 Jan 2020 05:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z0UrFTfKrgLfX01/rLl/IRCgo7e5VdzQ1WnFgxsg8f4=;
        b=aW+jYWBiw3d/3RR6GlTjxdSJhejziaCQfj5civ8JE3jtjVDgVQO/NmoJcXeP1EfiTa
         6mGAnFURVF6Qs2xy/JugSFjQMGmgh7igyxCIvFkJXulZWi7zvtk36NGY3kytHfW6uJ/P
         l3YPCWJzYG679ds52lFFnSzJynedJi2/ULee0b4aLgRNdM7Duw8WDpSmG34QOcjC6Ucc
         vULKWM+q4qoyqjY1rGzxZTIyVwF+r+e0pDfgHYDe/TNWE7LsxUU7NHhKrGRzjkCqOHF3
         ZFipCEYXKzbSR9e+vNB8SeHWzQSvqyv6HhVZLplY6Na+1m81P1OMfFkfY5hG8i1GR5Z2
         htaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z0UrFTfKrgLfX01/rLl/IRCgo7e5VdzQ1WnFgxsg8f4=;
        b=qR6s6TYslMIFb5psEEC9dykgZMAZF/V0nzb2JtZ2lZ8dAEnBt2xohMktdzxPd3HPev
         tiMKzVE8mDnc6D7AnQ8wpkt97PumHaru3HuMG5vklYlKbAMSvSuH0yiBBDMekOLsoRjM
         bENIGtqmcZv3/qN9RkP9f7H0aRKDdtbz5SL9i7aKpjiXyhT+Gl17HPc+QRbtiW6VDHX1
         /CiynPIscei9XOKvzLxzccuhUpkDSwKdEyO1OeX9WJoC/qaL6uz8qUKFbbfusDfSPNBF
         msJVPfuQ4HpwumU4ruXf83nwOf3oSBpFvJIAzejtBXKpWOBKzqOWK+MDRnynn5iWthtB
         vZpw==
X-Gm-Message-State: APjAAAUCbAw7woiV1/Bl8IAgAEVn87VaMcrCjTJqAq5yYB+w7ua94inw
        Be7mmrF/JRH6g2D9ohvHcpA=
X-Google-Smtp-Source: APXvYqygYO3cV2Q0MtXBT4CpNDLJTR1uHtIFoGURV2gMgh7rpueobPHTMQMvM6cwl2Pfet1vTxHNTg==
X-Received: by 2002:adf:ec41:: with SMTP id w1mr17925790wrn.212.1579525722126;
        Mon, 20 Jan 2020 05:08:42 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:08:41 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <huobean@gmail.com>
Subject: [PATCH v4 0/8] Use UFS device indicated maximum LU number
Date:   Mon, 20 Jan 2020 14:08:12 +0100
Message-Id: <20200120130820.1737-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series of patches is to simplify UFS driver initialization flow
and add a new parameter max_lu_supported used to specify how many LUs
supported by the UFS device.
This series of patches being tested on my two platforms, Qualcomm SOC
based and Hisilicon SOC based platforms.                                                                                                                                                                   
v1-v2:
    1. Split ufshcd_probe_hba() based on its called flow
    2. Delete two unnecessary functions
    3. Add a fixup patch

v2-v3:
    1. Combine patches 7/9 and 8/9 of v2 to patch 7/8 of v3
    2. Change patches 1/8 and 5/8 subject
    3. Change the name of two functions in patch 7/8

v3-v4:
    1. Change patch 4/8 subject
    2. Change new added function name from ufshcd_init_params() to
       ufshcd_device_params_init()
    3. Change new added function name from ufshcd_init_device_geo_params()
       to ufshcd_device_geo_params_init()
    4. Fix two compilation errors in patch 2/8:
       1) Missed an operator "&" in function ufs_mtk_apply_dev_quirks()
          when getting address of the dev_info.
       2) Incorrectly changed hba->dev_quirks to dev_info->dev_quirks in
          function ufs_qcom_apply_dev_quirks().


Bean Huo (8):
  scsi: ufs: Fix ufshcd_probe_hba() reture value in case
    ufshcd_scsi_add_wlus() fails
  scsi: ufs: Delete struct ufs_dev_desc
  scsi: ufs: Split ufshcd_probe_hba() based on its called flow
  scsi: ufs: Move ufshcd_get_max_pwr_mode() to
    ufshcd_device_params_init()
  scsi: ufs: Inline two functions into their callers
  scsi: ufs: Delete is_init_prefetch from struct ufs_hba
  scsi: ufs: Add max_lu_supported in struct ufs_dev_info
  scsi: ufs: Use UFS device indicated maximum LU number

 drivers/scsi/ufs/ufs-mediatek.c |   7 +-
 drivers/scsi/ufs/ufs-qcom.c     |   3 +-
 drivers/scsi/ufs/ufs-sysfs.c    |   2 +-
 drivers/scsi/ufs/ufs.h          |  25 ++-
 drivers/scsi/ufs/ufs_quirks.h   |   9 +-
 drivers/scsi/ufs/ufshcd.c       | 276 +++++++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h       |   9 +-
 7 files changed, 194 insertions(+), 137 deletions(-)

-- 
2.17.1

