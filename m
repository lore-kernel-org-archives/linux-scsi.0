Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2AAC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD983610CD
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhFPLaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:30:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4711 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhFPLaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842898; x=1655378898;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tbTtiw8zzy4wrmL5TAZBZR8da7fd1xjZE8i5/2ffHgQ=;
  b=PBx74tyrVQlSWPZvYvX7gxDEOXtJPGWSU4IkGSDxS/gKaFc/WOto9Y6b
   bs/11B8Ody/f6EIwtSTFmRGu09hUfvKj5wIJMZMK1tDDjuCdnYhdTmNwh
   nI738uH/Lzu+BWbJzI+KhwduBwdmqW3M7y74lyQwNjiQGz5UJH/ryiRpv
   mHOodripdnKFNs3n4gUDm5QezxuQGkaudQpUkbQmY+lGni5hntNRsYuwv
   OxQp16aTtq1ObFLlren/gRBJzVPt/66gjxYoEQY64QYgftqtM+Q4BvDCl
   kGopby9NFzQwe8Dg3MfiykBLGzdqsDlQRzjHdjgKUScOsTdRqhw5VCGVS
   g==;
IronPort-SDR: f2pBTdUOow6lI8+pX9+TjJ5lbOYoRYVbXvg5LFJcoSrHGmOnhw5G7kqauZnnlAXpXXIgtjrawe
 NeYEqIJKPuPbpsA+9m+00nEGljkUqdGpMcUEdOGRAWQ1DtXVxRaQqpwg4sU7CsjqudUwWAOkLu
 jv5d2lWsfVOzI+gYkIT4WNj8F+w8QXnNgtM+08bRvwpWvgz4fZxde6491WbToRERasdzswW1ql
 2SRzqUIMmosCgpBLNlxPIj+KPbzN2cc59YlBaoAmYsceHL6cwCs4iRAXNK/nxBcjC4AIxPKWAF
 bPQ=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="172653636"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:18 +0800
IronPort-SDR: EnQuJjchdSqKp0GnLZGALW2diLN8ajGTxzK6kcq+bzP6s8q7rQVXSGWuaxIzcTB3SV9ttA4wIf
 R376rg5GNMPOmUua4Lan3N3W+O3x8XtHdQPgKF9BKen0M8fbYmsCUQkzJpDzC1HvnQ4t/U1NDD
 OUtgDVLBCwae5HNFpnVcUES/M6DtuIU0RfPrxdzCacLlvPv6ot3YlEBqkqloSzIlBtzjGmYXp2
 P7FOkPjAUveICC+Hw8r7p9xaWj6nES6lubtS4+vfeE9rnjNNwm/Ee6DrptLyrQ5gC/5gNpwmAb
 x1N+1DMywAwDoJBPRl98tVlq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:07:07 -0700
IronPort-SDR: DZnpWzi9AryrB7acobPWPLEOtpDCjSy+yqAD8RFitxGVyz09jdBkhrVQOrqT9TcW4c3cRKSOhv
 NERtGLd/5okAbQTh02nwQbJUSIsrttBsJr4wh4vkulkDRGdl9rvn11Or4yQTAcW+v1cRvadAtD
 ziKAQiAaEd9JFxXfSVu83nXG3SzRdV2ap2AlSJWA2My6w1MJYHTAhxLnwL+134IZOCC3TdsVCx
 7Cq/8GKThczRM68u3rsynN80MqkW8dxHeXQn2/sS2Wxp/oxEofkPWJRs5PbKCay8CzxXE34Vd0
 QcQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:13 -0700
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
Subject: [PATCH v11 00/12] Add Host control mode to HPB
Date:   Wed, 16 Jun 2021 14:27:48 +0300
Message-Id: <20210616112800.52963-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

