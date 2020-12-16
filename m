Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AB5C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 04:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FDB23118
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 04:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgLPERH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:17:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:35592 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725274AbgLPERH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 23:17:07 -0500
X-UUID: 6104fe90c71244d4bf6ab001d6aceba2-20201216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xXViU+jCjnJBc17OQ5s/hqIlGucncZm+jcbPh2ljq70=;
        b=tSx7Gtmm6IUOoYX6WZCw+4cFEwWz15+T1HLaatGCwOEHCNKkCTOQOmp36z66n3B19wHA7j6ZkTunbwgZqKhibh7r9bLLmK46CvgVL/+H1YVvJ8ppCeTJ3i+nHujBi/9KIJ52LxrnapEbjmfTejJurc1qMFMjB/enNNGp7sMdxbk=;
X-UUID: 6104fe90c71244d4bf6ab001d6aceba2-20201216
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1544996646; Wed, 16 Dec 2020 12:16:23 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 12:16:20 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 12:16:20 +0800
Message-ID: <1608092181.10163.30.camel@mtkswgap22>
Subject: Re: [PATCH v5 5/7] scsi: ufs: Group UFS WB related flags to struct
 ufs_dev_info
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 12:16:21 +0800
In-Reply-To: <20201215230519.15158-6-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-6-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: CA0EF9279DBA7005060E63A6DCBB892D5B96BF7D5720714D28D33363D007E1BC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTE2IGF0IDAwOjA1ICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IFVGUyBkZXZpY2UtcmVsYXRl
ZCBmbGFncyBzaG91bGQgYmUgZ3JvdXBlZCBpbiB1ZnNfZGV2X2luZm8uIFRha2UNCj4gd2JfZW5h
YmxlZCBhbmQgd2JfYnVmX2ZsdXNoX2VuYWJsZWQgb3V0IGZyb20gdGhlIHN0cnVjdCB1ZnNfaGJh
LA0KPiBncm91cCB0aGVtIHRvIHN0cnVjdCB1ZnNfZGV2X2luZm8sIGFuZCBhbGlnbiB0aGUgbmFt
ZXMgb2YgdGhlIHN0cnVjdHVyZQ0KPiBtZW1iZXJzIHZlcnRpY2FsbHkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KDQpBY2tlZC1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg==

