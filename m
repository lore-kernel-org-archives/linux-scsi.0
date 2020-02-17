Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3850DC33FA2
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0594B206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="c4eGnLXn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgBQNMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:12:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60431 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbgBQNMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 08:12:55 -0500
X-UUID: 919c576f96ae40d69450de853a9b6952-20200217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=I/tzgvV2R++XQqqJXAJs1pGeA3QGkcVi7IaA4ozzCKc=;
        b=c4eGnLXnZ4GKfGe12tWJAX2BDHbZR+ybkFWRgfB3jbekxVbg9wMEb10urm3SVu9D0DFzeLALeSGMYC9+MdvQQ8tnDAhM7HVJbRyEKVS9kgaUxYtKyzWIuRbcd843WPPbBhP+qc8etrAB0zSF3hP2tHTSWnA+eIIlCrHo0Tyafb8=;
X-UUID: 919c576f96ae40d69450de853a9b6952-20200217
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 232153309; Mon, 17 Feb 2020 21:12:49 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 17 Feb 2020 21:11:05 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 17 Feb 2020 21:12:33 +0800
Message-ID: <1581945168.26304.4.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Mon, 17 Feb 2020 21:12:48 +0800
In-Reply-To: <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
         <20200217093559.16830-2-stanley.chu@mediatek.com>
         <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQoNCj4gPiAgCQkJfSBlbHNlIGlmICghb24gJiYgY2xraS0+ZW5hYmxlZCkgew0K
PiA+ICAJCQkJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGNsa2ktPmNsayk7DQo+ID4gKwkJCQl3YWl0
X3VzID0gaGJhLT5kZXZfaW5mby5jbGtfZ2F0aW5nX3dhaXRfdXM7DQo+ID4gKwkJCQlpZiAocmVm
X2NsayAmJiB3YWl0X3VzKQ0KPiA+ICsJCQkJCXVzbGVlcF9yYW5nZSh3YWl0X3VzLCB3YWl0X3Vz
ICsgMTApOw0KPiANCj4gSGkgU3RhbmxleSwNCj4gDQo+IElmIHdhaXRfdXMgaXMgMXVzLCBpdCB3
b3VsZCBiZSBpbmFwcHJvcHJpYXRlIHRvIHVzZSB1c2xlZXBfcmFuZ2UoKSBoZXJlLg0KPiBZb3Ug
aGF2ZSBjaGVja3Mgb2YgdGhlIGRlbGF5IGluIHBhdGNoICMyLCBidXQgd2h5IGl0IGlzIG5vdCBu
ZWVkZWQgaGVyZT8NCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCg0KWW91IGFyZSByaWdodC4g
SSBjb3VsZCBtYWtlIHRoYXQgZGVsYXkgY2hlY2tpbmcgYXMgY29tbW9uIGZ1bmN0aW9uIHNvIGl0
DQpjYW4gYmUgdXNlZCBoZXJlIGFzIHdlbGwgdG8gY292ZXIgYWxsIHBvc3NpYmxlIHZhbHVlcy4N
Cg0KVGhhbmtzIGZvciBzdWdnZXN0aW9uLg0KU3RhbmxleQ0KDQo=

