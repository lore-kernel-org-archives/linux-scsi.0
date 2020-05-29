Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05567C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC83C2078C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f6itfLMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438248AbgE2BMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 21:12:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:8887 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2438237AbgE2BMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 21:12:33 -0400
X-UUID: e7045c405d0a4c61b65bcf9f59ade33a-20200529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=x/w/7rmvWh/jqkaED4Q4+Z68FTrZSdM12AQq1U0/nb8=;
        b=f6itfLMBd6GKXycr9PMr/BLB9gjXNiPWDGdntLY+7TMyBPzaqhasOzu10Ef3gbrrXdQoKvoFiOuFyh63pg09v9+pk8TVJ/k6hcnHnpaxVQo0j3wPbPmkn1IrwmSFVo1nhaxx6O0I0Sbk+sbhxEobt7qmPdIBJfqyKE3Paoy7Iq8=;
X-UUID: e7045c405d0a4c61b65bcf9f59ade33a-20200529
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 523268404; Fri, 29 May 2020 09:12:27 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 29 May 2020 09:12:21 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 29 May
 2020 09:12:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 May 2020 09:12:25 +0800
Message-ID: <1590714745.25636.1.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/3] scsi: ufs: delete ufshcd_read_desc()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Fri, 29 May 2020 09:12:25 +0800
In-Reply-To: <20200528115616.9949-3-huobean@gmail.com>
References: <20200528115616.9949-1-huobean@gmail.com>
         <20200528115616.9949-3-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIwLTA1LTI4IGF0IDEzOjU2ICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IERlbGV0ZSB1ZnNoY2RfcmVh
ZF9kZXNjKCkuIEluc3RlYWQsIGxldCBjYWxsZXIgZGlyZWN0bHkgY2FsbA0KPiB1ZnNoY2RfcmVh
ZF9kZXNjX3BhcmFtKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0Bt
aWNyb24uY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAyNyArKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMo
KyksIDE5IGRlbGV0aW9ucygtKQ0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCg==

