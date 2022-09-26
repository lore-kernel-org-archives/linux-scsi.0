Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8716DC07E9D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbiIZPMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiIZPLj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 11:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6215D1BE85
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 06:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD6960DC4
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 13:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A8C433C1;
        Mon, 26 Sep 2022 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664200191;
        bh=8cBSY/c98zhLzt9mBybVF6c7J50QLah1jmN2uLzVuJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABQmkoWDYpQtHx3IK4N83Qx41nJzfsuDrVPsjLsj4crqZjSNEsMfU0ndG58BDZACH
         S28U4rnLKBvykxPqtYv8qQ6q3KtBvl3fGXaKTJ6cP5X2uYJv6jV2c/B8NjczMr+Mw2
         /qJpUrbm0EWnYJ9PFw094OityW0gFeS8Lriv67nHEgjBEzojxoyq7TZHpBGajtpRDt
         R1Bj3NRKjg0Oi46GJg5yJpur4uBBcPQgBuC92FTfIl5VKt63jOhTNu9oI6ITGv+uMm
         Y3xhs4GzdSUz+mQ3sQ4502NO+2W9hUTU+jAVQrm5xMS8i6n1COCT4MW9vLz9KQLFWz
         UMEwlkTghHeLA==
Date:   Mon, 26 Sep 2022 19:19:42 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     quic_nguyenb@quicinc.com, quic_xiaosenh@quicinc.com,
        quic_cang@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com, quic_richardp@quicinc.com,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        bvanassche@acm.org, avri.altman@wdc.com, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 00/16] Add Multi Circular Queue Support
Message-ID: <20220926134942.GB101994@thinkpad>
References: <cover.1663894792.git.quic_asutoshd@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1663894792.git.quic_asutoshd@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 06:05:07PM -0700, Asutosh Das wrote:
> 
> UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to improve storage performance.
> This patch series is a RFC implementation of this.

This is no more an RFC series. Also, it would be good if you can provide a
summary on how the implementation has been done.

Thanks,
Mani

> 
> This is the initial driver implementation and it has been verified by booting on an emulation
> platform. During testing, all low power modes were disabled and it was in HS-G1 mode.
> 
> Please take a look and let us know your thoughts.
> 
> v1:
> - Split the changes
> - Addressed Bart's comments
> - Addressed Bean's comments
> 
> * RFC versions:
> v2 -> v3:
> - Split the changes based on functionality
> - Addressed queue configuration issues
> - Faster SQE tail pointer increments
> - Addressed comments from Bart and Manivannan
> 
> v1 -> v2:
> - Enabled host_tagset
> - Added queue num configuration support
> - Added one more vops to allow vendor provide the wanted MAC
> - Determine nutrs and can_queue by considering both MAC, bqueuedepth and EXT_IID support
> - Postponed MCQ initialization and scsi_add_host() to async probe
> - Used (EXT_IID, Task Tag) tuple to support up to 4096 tasks (theoretically)
> 
> Asutosh Das (16):
>   ufs: core: Probe for ext_iid support
>   ufs: core: Introduce Multi-circular queue capability
>   ufs: core: Defer adding host to scsi if mcq is supported
>   ufs: core: mcq: Introduce Multi Circular Queue
>   ufs: core: mcq: Configure resource regions
>   ufs: core: mcq: Calculate queue depth
>   ufs: core: mcq: Allocate memory for mcq mode
>   ufs: core: mcq: Configure operation and runtime interface
>   ufs: core: mcq: Use shared tags for MCQ mode
>   ufs: core: Prepare ufshcd_send_command for mcq
>   ufs: core: mcq: Find hardware queue to queue request
>   ufs: core: Prepare for completion in mcq
>   ufs: mcq: Add completion support of a cqe
>   ufs: core: mcq: Add completion support in poll
>   ufs: core: mcq: Enable Multi Circular Queue
>   ufs: qcom-host: Enable multi circular queue capability
> 
>  drivers/ufs/core/Makefile      |   2 +-
>  drivers/ufs/core/ufs-mcq.c     | 511 +++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd-priv.h |  84 ++++++-
>  drivers/ufs/core/ufshcd.c      | 322 +++++++++++++++++++++-----
>  drivers/ufs/host/ufs-qcom.c    |  49 ++++
>  drivers/ufs/host/ufs-qcom.h    |   4 +
>  include/ufs/ufs.h              |   6 +
>  include/ufs/ufshcd.h           | 136 +++++++++++
>  include/ufs/ufshci.h           |  63 +++++
>  9 files changed, 1117 insertions(+), 60 deletions(-)
>  create mode 100644 drivers/ufs/core/ufs-mcq.c
> 
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
