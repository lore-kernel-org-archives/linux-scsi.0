Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3447AC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC026102A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhGLJxq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:53:46 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4412 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhGLJxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083456; x=1657619456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8uLwDUcIZKh52XDcB8HOArOYQ7v3MjkXgZ08NqdIkyE=;
  b=IxE43c/CbI7xSA+ph9rBxIT8riWkyIamNuj+LXG7s8kpXZ2w/RS9+62n
   OX/ccRmCX5PULrIY8I5YSuwznvIJHE3UAxPPpDr8VYrTntc6Hd6tNoVzU
   Rl4ndv9rHXWJzAiPIB4E4REMf9vtWy0ZWK1WLd3hWYpMXfq4ktP3ZTalo
   YNKS0q6y4m9h/emPATLiujahPkKxxxfX2bbj7nLmqn4F1CstpZukVb7vd
   yAhOXAJc4EVBjU0zS7aG9iuHkQRnN7pENk0fOp8TW6voPpbV6pOYZSwtx
   0NG/q/88u9ymbF1xXV5PLluDU1CBCi9i1IpzcmMpebS014DpPFDTujsjm
   A==;
IronPort-SDR: dkLNni/46Go4g6HHWfEYCzZ3aDB4PEicNi4oFP8rma5EXev86c/z0Axx23Sjfdot06J3zvEVeH
 LNmASuS4jcW8P84XCchAlWfbLorRJJhP55OlcqTKMS7cS8YrI2C9VRfIH1IPfrgcliYmpOwly2
 8VQxSWxEcubgooY8BkwTuCnBsY55bvoSDgobjzwRQSXJiNMIduYKks1dZ8QAWNXHDMXQiYq9pY
 y2y2G46Ahk3uD9D8o/qOaPKZZ7Pbt60Gzxve+KDRnh7eRmJHmdmePGIoCdBzwOCuotVMsDH2Hj
 /vg=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="173586743"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:50:55 +0800
IronPort-SDR: WHI0oue425dDQ2KZA4TspvQ0G96T7RHUNZPS8ahXNzfyDuTFO2lHD70ej98jZGMKRigdaFD7rS
 DVkLpRO7O0DrNZp3Lj1sAYDR62v2AJeO6jboWX4UwSvZt7CdAfUEFuwA/Gmi/q0yZt/LeoCoAz
 wt6OBMflPWUHNjxv+pdhQsVXL9OvcBQmq6cOtfD72lmbQ2XIhTSLuerR++Di3U4wa8bD6s9w4W
 3904o3yJZ0SBXjHZ6YpVs9Qu4zgZDcOlTfdMi559EcUkSfQyA/9zqW53JsiSc2hY6EXCBQjWQu
 3PL1AAlvMIkjlKnl6B2HW7S0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:29:02 -0700
IronPort-SDR: T9xN4GFF4Hdc2nUuWkb2V8bOoSpdEPJZYaxcg1Ku+QQcQRbj8qeLmR9Y4hVWXvMZE+kmfznjZn
 cJ+fDNmd092Wr27MjSOXpa/ZmwQLwfN5kSIBWeflJrJx7w786/sWDF3o16KelviJsiJ2V2ej/x
 Zaa8gyUDHP0eGrwzibp/1QCovsLHG45m9WLetRd0ImQZMv2HIorEg34iM3ChzN/AmN5AGMR/pb
 +wH8a0qQb5CH2IONt+9Hqf7JycORcBxNenE67mbBWq93XyxKHpgHd86gTTZGl4lCK3IEojPy+U
 jvc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:50:51 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v12 00/12] Add Host control mode to HPB
Date:   Mon, 12 Jul 2021 12:50:27 +0300
Message-Id: <20210712095039.8093-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v11 -> v12:
 - rebase on Daejun's v40

v10 -> v11:
 - rebase on Daejun's v38

v9 -> v10:
 - rebase on Daejun's v36

v8 -> v9:
 - Add one more patch: do not send unmap_all in host mode
 - rebase on Daejun's v35
 - tested on one more platform - Galaxy S21

v7 -> v8:
 - restore Daejun atomic argument to ufshpb_get_req (v31)
 - Add Daejun's Reviewed-by tag

v6 -> v7:
 - attend CanG's comments
 - add one more patch to transform set_dirty to iterate_rgn
 - rebase on Daejun's v32

v5 -> v6:
 - attend CanG's comments
 - rebase on Daejun's v29

v4 -> v5:
 - attend Daejun's comments
 - Control the number of inflight map requests

v3 -> v4:
 - rebase on Daejun's v25

v2 -> v3:
 - Attend Greg's and Can's comments
 - rebase on Daejun's v21

v1 -> v2:
 - attend Greg's and Daejun's comments
 - add patch 9 making host mode parameters configurable
 - rebase on Daejun's v19


The HPB spec defines 2 control modes - device control mode and host
control mode. In oppose to device control mode, in which the host obey
to whatever recommendation received from the device - In host control
mode, the host uses its own algorithms to decide which regions should
be activated or inactivated.

We kept the host managed heuristic simple and concise.

Aside from adding a by-spec functionality, host control mode entails
some further potential benefits: makes the hpb logic transparent and
readable, while allow tuning / scaling its various parameters, and
utilize system-wide info to optimize HPB potential.

This series is based on Samsung's device-control HPB2.0 driver

This version was tested on Galaxy S21, Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri


Avri Altman (12):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Transform set_dirty to iterate_rgn
  scsi: ufshpb: Add reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Limit the number of inflight map requests
  scsi: ufshpb: Do not send umap_all in host control mode
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  76 ++-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 583 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  44 ++
 4 files changed, 676 insertions(+), 29 deletions(-)

-- 
2.25.1

