Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B29C33CB2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A352E20732
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 10:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MgUrR9fb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgA2KqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 05:46:17 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:10161 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726091AbgA2KqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 05:46:17 -0500
X-UUID: 00a31ccbf40e4079903ca03398bb6b92-20200129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Yt581FabJCvS7KYli29oSxtfGgARonQD9rLsBaD4O/A=;
        b=MgUrR9fbsNx5Yp09f5XqZRx52b1GN/RVEx+Gkg0xBU5BbKgPmk9yYbRBeuL7I7eD9GM/8RK2aTCLFGnxw8Fjm4ODU/5LisLxrp4c+2JXWTA47VWIjFhfrsn6S5zorPDf/EXWYCdeI4bdMlhrShfXd3uzFsPkRCPoi7lt9Wt52NI=;
X-UUID: 00a31ccbf40e4079903ca03398bb6b92-20200129
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 246872476; Wed, 29 Jan 2020 18:46:12 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 Jan 2020 18:44:50 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 Jan 2020 18:46:17 +0800
Message-ID: <1580294770.15794.1.camel@mtksdccf07>
Subject: Re: [PATCH v3 3/4] scsi: ufs: fix Auto-Hibern8 error detection
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <stable@vger.kernel.org>
Date:   Wed, 29 Jan 2020 18:46:10 +0800
In-Reply-To: <20200129075225.GA3774452@kroah.com>
References: <20200129073902.5786-1-stanley.chu@mediatek.com>
         <20200129073902.5786-4-stanley.chu@mediatek.com>
         <20200129075225.GA3774452@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgR3JlZywNCg0KT24gV2VkLCAyMDIwLTAxLTI5IGF0IDA4OjUyICswMTAwLCBHcmVnIEtIIHdy
b3RlOg0KDQo+ID4gRml4ZXM6IDgyMTc0NDQgKCJzY3NpOiB1ZnM6IEFkZCBlcnJvci1oYW5kbGlu
ZyBvZiBBdXRvLUhpYmVybmF0ZSIpDQo+IA0KPiBUaGlzIHNob3VsZCBiZToNCj4gRml4ZXM6IDgy
MTc0NDQwMzkxMyAoInNjc2k6IHVmczogQWRkIGVycm9yLWhhbmRsaW5nIG9mIEF1dG8tSGliZXJu
YXRlIikNCg0KVGhhbmtzIGZvciByZW1pbmQuIEknbGwgcmVzZW5kIHRoaXMgcGF0Y2ggd2l0aCB1
cGRhdGVkIHRhZy4NCg0KU3RhbmxleQ0KDQo=

