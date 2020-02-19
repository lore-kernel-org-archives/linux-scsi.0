Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876F5C3404D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 09:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6004824672
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 09:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qt0zwqzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgBSJLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 04:11:47 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58570 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbgBSJLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 04:11:47 -0500
X-UUID: 557d7cd66a6a422f971494d1dc2267f0-20200219
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SLGppPs6Z/J39znqpbn3i7/ZsMo7evHcwHC2/b+MPjU=;
        b=qt0zwqzX4AHHitPhtdDlzMqc5Jzk7iBeYR/CHj0sm359kd8/gljuMzU7ipNZFXFnB0U8X96/BU/IM7h4ePi0eLaQ+xQsPDO8ZTf3HagJq2KcL/XushcFrFFgU61GUDDIDwNM0xnM2GaTs1uiVBin/Gbjd+DT/PD9pBddM1a2xnM=;
X-UUID: 557d7cd66a6a422f971494d1dc2267f0-20200219
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 289965575; Wed, 19 Feb 2020 17:11:40 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 19 Feb 2020 17:09:07 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 19 Feb 2020 17:12:13 +0800
Message-ID: <1582103495.26304.42.camel@mtksdccf07>
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
Date:   Wed, 19 Feb 2020 17:11:35 +0800
In-Reply-To: <a8cd5beee0a1e12a40da752c6cd9b5de@codeaurora.org>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
         <20200217093559.16830-2-stanley.chu@mediatek.com>
         <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
         <1581945168.26304.4.camel@mtksdccf07>
         <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
         <1581946449.26304.15.camel@mtksdccf07>
         <56c1fc80919491d058d904fcc7301835@codeaurora.org>
         <a8cd5beee0a1e12a40da752c6cd9b5de@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 9236600DEE7C39A014B8A4C770286A4CF9C92C55D3222424BDB3994F3AAEDF2E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDItMTkgYXQgMTA6MzUgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQoNCj4gU2luY2Ugd2UgYWxsIG5lZWQgdGhpcyBkZWxheSBoZXJlLCBob3cgYWJvdXQgcHV0
IHRoZSBkZWxheSBpbiB0aGUNCj4gZW50cmVuY2Ugb2YgdWZzaGNkX3NldHVwX2Nsb2NrcygpLCBi
ZWZvcmUgdm9wc19zZXR1cF9jbG9ja3MoKT8NCj4gSWYgc28sIHdlIGNhbiByZW1vdmUgYWxsIHRo
ZSBkZWxheXMgd2UgYWRkZWQgaW4gb3VyIHZvcHMgc2luY2UgdGhlDQo+IGRlbGF5IGFueXdheXMg
ZGVsYXlzIGV2ZXJ5dGhpbmcgaW5zaWRlIHVmc2hjZF9zZXR1cF9jbG9ja3MoKS4NCj4gDQoNCkFs
d2F5cyBwdXR0aW5nIHRoZSBkZWxheSBpbiB0aGUgZW50cmFuY2Ugb2YgdWZzaGNkX3NldHVwX2Ns
b2NrcygpIG1heQ0KYWRkIHVud2FudGVkIGRlbGF5IGZvciB2ZW5kb3JzLCBqdXN0IGxpa2UgeW91
ciBjdXJyZW50IGltcGxlbWVudGF0aW9uLA0Kb3Igc29tZSBvdGhlciB2ZW5kb3JzIHdobyBkbyBu
b3Qgd2FudCB0byBkaXNhYmxlIHRoZSByZWZlcmVuY2UgY2xvY2suDQoNCkkgdGhpbmsgY3VycmVu
dCBwYXRjaCBpcyBtb3JlIHJlYXNvbmFibGUgYmVjYXVzZSB0aGUgZGVsYXkgaXMgYXBwbGllZCB0
bw0KY2xvY2sgb25seSBuYW1lZCBhcyAicmVmX2NsayIgc3BlY2lmaWNhbGx5Lg0KDQpJZiB5b3Ug
bmVlZHMgdG8ga2VlcCAicmVmX2NsayIgaW4gRFQsIHdvdWxkIHlvdSBjb25zaWRlciB0byByZW1v
dmUgdGhlDQpkZWxheSBpbiB5b3VyIHVmc19xY29tX2Rldl9yZWZfY2xrX2N0cmwoKSBhbmQgbGV0
IHRoZSBkZWxheSBoYXBwZW5zIHZpYQ0KY29tbW9uIHVmc2hjZF9zZXR1cF9jbG9ja3MoKSBvbmx5
PyBIb3dldmVyIHlvdSBtYXkgc3RpbGwgbmVlZCBkZWxheSBpZg0KY2FsbCBwYXRoIGNvbWVzIGZy
b20gdWZzX3Fjb21fcHdyX2NoYW5nZV9ub3RpZnkoKS4NCg0KV2hhdCBkbyB5b3UgdGhpbms/DQoN
Cj4gTWVhbndoaWxlLCBpZiB5b3Ugd2FudCB0byBtb2RpZnkgdGhlIGRlbGF5DQo+IChoYmEtPmRl
dl9pbmZvLmNsa19nYXRpbmdfd2FpdF91cykgZm9yIHNvbWUgcmVhc29ucywgc2F5IGZvciBzcGVj
aWZpYw0KPiBVRlMgZGV2aWNlcywgeW91IHN0aWxsIGNhbiBkbyBpdCBpbiB2b3BzX2FwcGx5X2Rl
dl9xdWlya3MoKS4NCj4gDQo+IFdoYXQgZG8geW91IHNheT8NCj4gDQo+IFRoYW5rcywNCj4gQ2Fu
IEd1by4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

