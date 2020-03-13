Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F141BC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7DF420716
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCMCh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 22:37:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35736 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCMCh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 22:37:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so4087899pgr.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 19:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ePyHsGwqntgv85tsborhI1nEEgiY54kTJ+2PGy3/CNg=;
        b=rIa16tSWZYJaC1YkudWcDAtZtipclgVSFZgw6N1tC6S9wW0//5rZzav1ZfFCIB1lIW
         cik6taoPFLGZvGWspZPafaW9hP++uIdEnn18vl6OC3vSdLcuGQWwiuLHdcvB0qZRrpB7
         jaITKGKnKjer9EEE31QXiUMZW8QzrmqKIlNChek+ibVFHQstJVrCf4M8GEYVH/QnmZDK
         wbRDnOvdc/BKNJpGS2oRxWEGHYVPgeHkW49vxlECR2GkNvaqX/lE3hLiN6m4RD6JHy43
         AlMW4owk3C1iQHU8Sqt60JAnkz7nUF7782YeS4R3bIlNRV1S4DagL8EYRjll33PzUBGk
         WlJQ==
X-Gm-Message-State: ANhLgQ31yY/y5GZIVYY6svdWcrsLWopAjPXgJ/P0jcUMsHvSlMAlu2rP
        +n69U1njNUk6ZFJBfs0wp4Q=
X-Google-Smtp-Source: ADFU+vvrRdWG2aqVUK6UoJFTE82jy1kdY33eSJ9OpyvRD4BBn51BXR5PngyXEmekyM9gwmy724qkhw==
X-Received: by 2002:aa7:83d7:: with SMTP id j23mr10749084pfn.77.1584067046694;
        Thu, 12 Mar 2020 19:37:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dc2:675a:7f2a:2f89])
        by smtp.gmail.com with ESMTPSA id o129sm3123516pfb.61.2020.03.12.19.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:37:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] Consolidate {get,put}_unaligned_[bl]e24() definitions
Date:   Thu, 12 Mar 2020 19:37:13 -0700
Message-Id: <20200313023718.21830-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series moves the existing {get,put}_unaligned_[bl]e24() definitions
into include/linux/unaligned/generic.h and also replaces some open-coded
implementations of these functions with calls to these functions. Please
consider this patch series for kernel version v5.7.

Thanks,

Bart.

Changes compared to v1:
- Left out the drivers/iio, arm/ecard, IB/qib and ASoC/fsl_spdif patches.
- Dropped the sign_extend_24_to_32(), get_unaligned_signed_be24() and
  get_unaligned_signed_le24() functions.
- See also
  https://lore.kernel.org/lkml/20191028200700.213753-1-bvanassche@acm.org/.

Bart Van Assche (5):
  linux/unaligned/byteshift.h: Remove superfluous casts
  c6x: Include <linux/unaligned/generic.h> instead of duplicating it
  treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
  scsi/st: Use get_unaligned_be24() and sign_extend32()
  scsi/trace: Use get_unaligned_be24()

 arch/c6x/include/asm/unaligned.h             | 65 +-------------------
 drivers/nvme/host/rdma.c                     |  8 ---
 drivers/nvme/target/rdma.c                   |  6 --
 drivers/scsi/scsi_trace.c                    |  6 +-
 drivers/scsi/st.c                            |  4 +-
 drivers/usb/gadget/function/f_mass_storage.c |  1 +
 drivers/usb/gadget/function/storage_common.h |  5 --
 include/linux/unaligned/be_byteshift.h       |  6 +-
 include/linux/unaligned/generic.h            | 46 ++++++++++++++
 include/linux/unaligned/le_byteshift.h       |  6 +-
 include/target/target_core_backend.h         |  6 --
 11 files changed, 58 insertions(+), 101 deletions(-)

