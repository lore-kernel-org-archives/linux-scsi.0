Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BAC7C34022
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 00:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2012A208C4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 00:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aNg9N86M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgBRAuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 19:50:46 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:21142 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726047AbgBRAuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 19:50:46 -0500
X-UUID: ddda55f146e94cfab890b77d24f6973c-20200218
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=aYb7eYVcWGhu/tm1bPl140Be8k4HkWRqF47wgIfyVRY=;
        b=aNg9N86MZL7lAVcfmKvwzIhCL9FpIAhuQZL871hfpxwRQzBS0IHL+xCzTCghNyxzHP3EBjUiB04yyZmlvvVMri1nZDoxeVHTkkj6zpXBa+aLH64f1zzeibOFEkgX2V9HzQBVVrlpeh68QuUT1Bed6ijkhGxiXOWuJAmDE8ceMDw=;
X-UUID: ddda55f146e94cfab890b77d24f6973c-20200218
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1089069488; Tue, 18 Feb 2020 08:50:36 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 18 Feb 2020 08:51:45 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 18 Feb 2020 08:49:59 +0800
Message-ID: <1581987023.26304.22.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Tue, 18 Feb 2020 08:50:23 +0800
In-Reply-To: <87f03ff5-445b-25c2-308d-5c9e18942a0f@acm.org>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
         <20200217093559.16830-2-stanley.chu@mediatek.com>
         <87f03ff5-445b-25c2-308d-5c9e18942a0f@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gTW9uLCAyMDIwLTAyLTE3IGF0IDA4OjE3IC0wODAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDItMTcgMDE6MzUsIFN0YW5sZXkgQ2h1IHdyb3RlOg0K
PiA+IC0JCQlpZiAoc2tpcF9yZWZfY2xrICYmICFzdHJjbXAoY2xraS0+bmFtZSwgInJlZl9jbGsi
KSkNCj4gPiArCQkJcmVmX2NsayA9ICFzdHJjbXAoY2xraS0+bmFtZSwgInJlZl9jbGsiKSA/IHRy
dWUgOiBmYWxzZTsNCj4gPiArCQkJaWYgKHNraXBfcmVmX2NsayAmJiByZWZfY2xrKQ0KPiANCj4g
U2luY2UgdGhlICIgPyB0cnVlIDogZmFsc2UiIHBhcnQgaXMgc3VwZXJmbHVvdXMsIHBsZWFzZSBs
ZWF2ZSBpdCBvdXQuDQoNCldpbGwgZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KDQo+IFRoYW5r
cywNCj4gDQo+IEJhcnQuDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQo=

