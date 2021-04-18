Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1D9C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8253D6120C
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 07:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhDRHWt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 03:22:49 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26689 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhDRHWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Apr 2021 03:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618730537; x=1650266537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IgziuC7NqjHVuW+40lWSUPp9sVUBlCXbGfxYLFmYcZ4=;
  b=Q6jBqubFkI2kOyc3TKt4ahQOVdGVtvboHaBCABi3t7Z6FQ4VhnCwqj/L
   SW2YxTzqyR4OpKIlpWjdz9LlQa1ArzMjRWDsdU4bguj4BZkPYaRxHwiMB
   TsV1dS3amjg+wY49TbJSQAXJketku4Fyi0LY+A4pu5jC302Y9MzglJhFR
   RxLW8t+XzijGlfsx2EBSrkf5SBbQkf7W6BfE6YbqxARicO48NRHhDNSQ8
   f4/RxiY6lADBPwFH3jYk+ZjV/O3qt/QUTh470CbJLXav31tnzzaK9MRjt
   Audrqzspcp5Qjj5GXZlfUSeYAzg4zPb6C1PPS/RdXkudr/M3fb28TfLtn
   g==;
IronPort-SDR: iRTJHoZ/W4xLGUfSARfR7toyosmjvCXN8qw5J86d0D61YjI9adQ32TtxAohzqlWkN7oneINXEl
 niNxmMFIQ0mxgR4uQjT8Xb2nF+m8NBGwcmoh8e/DKKgXYEnZigO9R2BCvdiqyWbsL5oz1gKT4z
 qjkdv4Y+FADBK80vfArSS+ktdoUaUdsLMfjCxkwAUtwcxJ1OOA96f0ddD0OK8duQOo6tKj1ZjP
 qIKzuQEGCARkDampqtruYha1C5xf+uGL5351au4QYMUGf4sYy3+K7mZbmQRvo6B00csCPXDPxu
 hko=
X-IronPort-AV: E=Sophos;i="5.82,231,1613404800"; 
   d="scan'208";a="276267663"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2021 15:22:17 +0800
IronPort-SDR: 4D0ZExdbv/LjFpmI0stICE3JUgslQ/jVgljbpgChdX4cMtVeBQ2ujIdzG/6zuPJcGxGe/mZ7xf
 0l7VGtrQWikWiNHWHuTOQeojg1l1RiGJIsjf5qWJk0cm3WAmXYtvUAeMAfP+ILpqDvRpVhbqYG
 qGdJMwIlvsSOBJlCrX5bq1Hi7Q8eIL9xPyBpq5p1azSVeUyNE/XoI1YXIz04H5hDdd2KS7TlwY
 4nhiTqV9R1QZKoqZ4SFvMYxMxuPr5k9ZOVHELBCmYMlKHEYIyjJZTBFB85r/GdemExICaQOYme
 GE1xXBF1p4f5rXXq5OM55Mpf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 00:03:03 -0700
IronPort-SDR: IRSLbvLKgH2VOlJ7Oci00Hk4NPrXuNy4SA3I1kaZ61OeLVz5cp6dTUa97qlvFdTASQ5DJpye96
 pshpfF2Fo3/dZT4FChnIskf7SEtW3iiRofp2T9osl5xA0xO8QfKtNCBlO9K36BCKOhVxXAlSVV
 5Tg6zzg4rzyAiusdEhf6/e2yl+OfAli4y+eLjJt3jLxIucSuja/5XSyth9kP9K0I4nPZ6kpyD4
 LGnhod48ItgrWM6TykS1wZAy9af8av2utUAO/5e/M80MSWnOhMMDlDEOI+nEgCJE9yzDgw5rM/
 BF0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Apr 2021 00:22:15 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alex Lemberg <alex.lemberg@wdc.com>
Subject: [PATCH] scsi: ufs: Check for bkops in runtime suspend
Date:   Sun, 18 Apr 2021 10:21:50 +0300
Message-Id: <20210418072150.3288-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The UFS driver allowed BKOPS and WB Flush operations to be completed on
Runtime suspend. Adding the DeepSleep support, this is no longer true:
the driver will ignore BKOPS and WB Flush states, and force a link state
transition to UIC_LINK_OFF_STATE.

Do not ignore BKOPS and WB Flush on runtme suspend flow.

fixes: fe1d4c2ebcae (scsi: ufs: Add DeepSleep feature)

Suggested-by: Alex Lemberg <alex.lemberg@wdc.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 58d7f264c664..1a0cac670aba 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8755,7 +8755,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * In the case of DeepSleep, the device is expected to remain powered
 	 * with the link off, so do not check for bkops.
 	 */
-	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
+	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba) ||
+			  hba->dev_info.b_rpm_dev_flush_capable;
 	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
 	if (ret)
 		goto set_dev_active;
-- 
2.25.1

