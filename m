Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A01DC04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 18:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjHNSo6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjHNSos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 14:44:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271A2E7E
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692038642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gMFMHL74t2T5YQCuOIjcESsgAxQGO/F/5mkeBwii9+g=;
        b=BTyK162D+LG59lcQyLOrkL+0VgDpAmeDtm2jnmI9iuGa3WV+AUzu4yjlljNt0ibd0jhlof
        Xhmp3oW3GmoN0laAn1UQ7a4OWyKlpQac+n7lRXnjktkrnFEYdWiIJtCKAQmPUgsHIftYgg
        +J6Py3zDGpMy9CgPHR87mMTA4ZrGqII=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-CmG9Y662PLG7r3yJ41hayw-1; Mon, 14 Aug 2023 14:44:00 -0400
X-MC-Unique: CmG9Y662PLG7r3yJ41hayw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-d6861869bcdso3377846276.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 11:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692038640; x=1692643440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMFMHL74t2T5YQCuOIjcESsgAxQGO/F/5mkeBwii9+g=;
        b=gUmHe6ZGU9zp4tWd+fT83+IJFQs1v+hhZvXoEk+n/yvevq3xxPj0Q0WfXIQGaSm85U
         J4hWG9XNg3cgvWstRvUcBWcdGu4Ii9CtKZwQreF9s6ONElcwIIpImKpzahLq9T88D6UC
         EkLZJH2nOwMHx2Fhh/qxXrNmIGB9FMKX5XnEiF5G/YeVbBp07ZHNYqh533s9s9/yqe8S
         xLbn4ZvtT+ZlCKu82AuqjrnfDRFs8CFKOLJsRd7BubfvPtGg2CaN9bPHhSsjXrjFMG4a
         RoT9NV0jWPn+5jLSx5MBQgvUGnPU6yvKFAaqU6QDUE0HHghlhAD5BQnJSKEZmLDDFi9E
         C0Dg==
X-Gm-Message-State: AOJu0Ywnvj+PQVhx2taYIM3jMe8MRLA1JtsH3oyu50IdAtaLWsIc0ZLE
        S1LH7QVFC4hB5TK43N70Vi5NntUGceMH9frA1wPd91U0cA9YhSg6v9/Ls+bgJpHKLelELEE6JC0
        hzbYRagTZEpNfS1QZb8xPAw==
X-Received: by 2002:a25:dad7:0:b0:ced:6134:7606 with SMTP id n206-20020a25dad7000000b00ced61347606mr13115420ybf.30.1692038640193;
        Mon, 14 Aug 2023 11:44:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPVBPkqxgxKUguqFVu0WE+kAMWlWC/xWovboumFU5uuvLkGHLhDjQYXjTgtt+Btm5ldVeQag==
X-Received: by 2002:a25:dad7:0:b0:ced:6134:7606 with SMTP id n206-20020a25dad7000000b00ced61347606mr13115408ybf.30.1692038639962;
        Mon, 14 Aug 2023 11:43:59 -0700 (PDT)
Received: from brian-x1.. (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id x131-20020a25ce89000000b00d674f3e2891sm1864387ybe.40.2023.08.14.11.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:43:59 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com, quic_nguyenb@quicinc.com
Subject: [PATCH v3 0/2] scsi: ufs: convert probe to use dev_err_probe()
Date:   Mon, 14 Aug 2023 14:43:50 -0400
Message-ID: <20230814184352.200531-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following two log messages are shown on bootup due to an
-EPROBE_DEFER when booting on a Qualcomm sa8775p development board:

    ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
        failed err -517
    ufshcd-qcom 1d84000.ufs: Initialization failed

This patch series converts the relevant two probe functions over to use
dev_err_probe() so that these messages are not shown on bootup.

Changes since v2
https://lore.kernel.org/lkml/20230809191054.2197963-1-bmasney@redhat.com/
- Add error code to message in second patch

Changes since v1
https://lore.kernel.org/lkml/20230808142650.1713432-1-bmasney@redhat.com/
- Dropped code cleanup from first patch

Brian Masney (2):
  scsi: ufs: core: convert to dev_err_probe() in hba_init
  scsi: ufs: host: convert to dev_err_probe() in pltfrm_init

 drivers/ufs/core/ufshcd.c        | 5 +++--
 drivers/ufs/host/ufshcd-pltfrm.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.41.0

