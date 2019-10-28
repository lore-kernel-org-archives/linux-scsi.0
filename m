Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4D4CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C79208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfJ1UHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43216 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbfJ1UHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id v5so6193445ply.10;
        Mon, 28 Oct 2019 13:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmwIjzOj9mNCZOPZyIeIixZhUclJq2tBR5bVlHulNYw=;
        b=Lss5J0ie9VKT8eTIok+xKJMyscENjhLtvbr6DaL1kcoYu2Kpj+HMa7Hm+SRB60GI88
         ORpjwcD5iQpf0m+9CRQ7mRp4+aWKXuXoienDy99NM4yiI/DjN0snWjXiSYUhkXVvGW3z
         fx7iFrlm5Mv+4yMszw+Pdgxt8P2VeKPtYjB4A80deEgbo5y02Leh8EsJqWvfofODO7Gx
         Oj0w8ZzKotKWkwsF99yEDNzFoQziTh+oQ8cNOoeutUxzXgL7wRJVe4LohTIzNXqMKL8T
         1DkMlkSYRsQhHHaTGT9DJWYppsmYmrHjmUGrdniBOAyZquC7MfXu1KrY9dambZyt0F9r
         SDEQ==
X-Gm-Message-State: APjAAAVIfVVsZqvlrj11vM842CmvCmDtuwhOg3lbThWQyqyJUtmsrss3
        eoO6g2Xw2cfNGb1FQ18k90A=
X-Google-Smtp-Source: APXvYqyOysLJXAL+XlfjbcadaI0f8aO/j+RFejYaBsQDSxIhUiYXDMqSX0W/hzI2SZG6R8ql/fHJGg==
X-Received: by 2002:a17:902:fe95:: with SMTP id x21mr20014417plm.53.1572293228122;
        Mon, 28 Oct 2019 13:07:08 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/9] Consolidate {get,put}_unaligned_[bl]e24() definitions
Date:   Mon, 28 Oct 2019 13:06:51 -0700
Message-Id: <20191028200700.213753-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Peter,

This patch series moves the existing {get,put}_unaligned_[bl]e24() definitions
into include/linux/unaligned/generic.h. This patch series also introduces a function
for sign-extending 24-bit into 32-bit integers and introduces users for all new
functions and macros. Please consider this patch series for kernel version v5.5.

Thanks,

Bart.

Bart Van Assche (9):
  linux/unaligned/byteshift.h: Remove superfluous casts
  c6x: Include <linux/unaligned/generic.h> instead of duplicating it
  treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
  drivers/iio: Sign extend without triggering implementation-defined
    behavior
  scsi/st: Use get_unaligned_signed_be24()
  scsi/trace: Use get_unaligned_be*()
  arm/ecard: Use get_unaligned_le{16,24}()
  IB/qib: Sign extend without triggering implementation-defined behavior
  ASoC/fsl_spdif: Use put_unaligned_be24() instead of open-coding it

 arch/arm/mach-rpc/ecard.c                     |  18 +--
 arch/c6x/include/asm/unaligned.h              |  65 +--------
 .../iio/common/st_sensors/st_sensors_core.c   |   7 +-
 drivers/infiniband/hw/qib/qib_rc.c            |   2 +-
 drivers/nvme/host/rdma.c                      |   8 --
 drivers/nvme/target/rdma.c                    |   6 -
 drivers/scsi/scsi_trace.c                     | 128 ++++++------------
 drivers/scsi/st.c                             |   4 +-
 drivers/usb/gadget/function/f_mass_storage.c  |   1 +
 drivers/usb/gadget/function/storage_common.h  |   5 -
 include/linux/unaligned/be_byteshift.h        |   6 +-
 include/linux/unaligned/generic.h             |  44 ++++++
 include/linux/unaligned/le_byteshift.h        |   6 +-
 include/target/target_core_backend.h          |   6 -
 sound/soc/fsl/fsl_spdif.c                     |   5 +-
 15 files changed, 103 insertions(+), 208 deletions(-)
