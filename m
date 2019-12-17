Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FB7C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 14:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 052D62176D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 14:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfLQO0m convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 09:26:42 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2479 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728929AbfLQO0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 09:26:42 -0500
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id E69CBDC64C2256AF145F;
        Tue, 17 Dec 2019 22:26:34 +0800 (CST)
Received: from DGGEML424-HUB.china.huawei.com (10.1.199.41) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Dec 2019 22:26:34 +0800
Received: from DGGEML505-MBX.china.huawei.com ([169.254.12.46]) by
 dggeml424-hub.china.huawei.com ([10.1.199.41]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 22:26:27 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "robert.w.love@intel.com" <robert.w.love@intel.com>,
        "jeykholt@cisco.com" <jeykholt@cisco.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Mingfangsen <mingfangsen@huawei.com>
Subject: [PATCH] scsi:libfc:fix fc_lport_ptp_setup(): Null pointer
 dereferences
Thread-Topic: [PATCH] scsi:libfc:fix fc_lport_ptp_setup(): Null pointer
 dereferences
Thread-Index: AdW04LVen96kzoPtQo2mFOzLRq0TiA==
Date:   Tue, 17 Dec 2019 14:26:27 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E9AA36@dggeml505-mbx.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

The code following:
fc_rport_create()
    ...
    rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
    if (!rdata)
        return NULL;
    ...

fc_lport_ptp_setup()
   ...
   lport->ptp_rdata = fc_rport_create(lport, remote_fid);
   kref_get(&lport->ptp_rdata->kref);
   lport->ptp_rdata->ids.port_name = remote_wwpn;
   ...

Fix by adding a check for lport->ptp_rdata before be used on fc_lport_ptp_setup func.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/libfc/fc_lport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 684c5e3..36e7bdd 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -238,6 +238,10 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
        }
        mutex_lock(&lport->disc.disc_mutex);
        lport->ptp_rdata = fc_rport_create(lport, remote_fid);
+       if (!lport->ptp_rdata) {
+               mutex_unlock(&lport->disc.disc_mutex);
+               return;
+       }
        kref_get(&lport->ptp_rdata->kref);
        lport->ptp_rdata->ids.port_name = remote_wwpn;
        lport->ptp_rdata->ids.node_name = remote_wwnn;
--
1.8.3.1
