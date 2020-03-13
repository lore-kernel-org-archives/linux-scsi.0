Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42AAC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FEB205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMUbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:31:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43800 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:31:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so5628472pgb.10
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cywHJu632NT7DOtdXKv9aogTuCkxsb1PI2/jTC2VXkE=;
        b=qzFR/KZ96NK9GVbx6bIFwJNNHgHVSpD7dDjwPuy1N5+IyCQUpSocb1tum2coKEor/R
         rWfEXzJR4cq3ADWjPmn9Mf4GkyhkCZtVvcHMESF/e40E+KSM9rwZ5TpU+BybbqEDOwiR
         EzfxjZx7+tIiaVpeJiG/Rdk6WNKMjzFsOKgYXtWULk/LlWev6MbejinJbjOdfx9786tO
         gm1n3H4Oxu1h+ycx6f1z7ZR2MHplh0icSfyR2CsYhQf9IBJrOQSWvHcoAAgVOy83M4OT
         vx7p725nedx/c78v1xtwhbzgrvgusX4NAcMbG4sny8mZ1WIc0rV/DJ/iAb75+erM8ZPS
         QtCw==
X-Gm-Message-State: ANhLgQ1/C6vSSmSMjBrDFh/14wmwAdogPdaIyIpi94JnkQdAaSSiy+K4
        brEZg8wB/SrshEWFJlZLMh8=
X-Google-Smtp-Source: ADFU+vuLWKqppdnTXMa/Ab98Vgl53D5yJfjM/mjU6WLICoRpj959spQOFWaIGe71q7GYQo/VXojYXQ==
X-Received: by 2002:a63:33c2:: with SMTP id z185mr14576408pgz.125.1584131470050;
        Fri, 13 Mar 2020 13:31:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id m12sm12656000pjf.25.2020.03.13.13.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:31:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/5] Consolidate {get,put}_unaligned_[bl]e24() definitions
Date:   Fri, 13 Mar 2020 13:30:57 -0700
Message-Id: <20200313203102.16613-1-bvanassche@acm.org>
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

Changes compared to v2:
- Declared 'val' arguments 'const'.
- Added more Reviewed-by tags.
- See also
  https://lore.kernel.org/linux-scsi/20200313023718.21830-1-bvanassche@acm.org/.

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

