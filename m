Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14388C2D0D2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 04:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD602206CB
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 04:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KJdu55EY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLYEHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 23:07:55 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:17481 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726332AbfLYEHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 23:07:55 -0500
X-UUID: 22bf739267da4681adf5ee9a8f301ecf-20191225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NIJENyJKlWoqwgHXAL2hevvVed09oj9yO9raXuRmiUo=;
        b=KJdu55EYy+80qNsVPMOL7NDDG08LDp+O6eYTpnlPC/V+GNUmBvd1jF8+epGwtUDgMsDwmKIWFO1q1vB4vpCNTFlgpuYQHpVWBl0Qkqf4NMqnQJdoROo7h+I/tIMexNOQSwixTQYo9VcC6b6XAWN9zXKUoZTkCDGpsPixO5zHb+g=;
X-UUID: 22bf739267da4681adf5ee9a8f301ecf-20191225
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1122320882; Wed, 25 Dec 2019 12:07:46 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 25 Dec 2019 12:07:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 25 Dec 2019 12:07:21 +0800
Message-ID: <1577246863.13056.48.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: unify scsi_block_requests usage
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Wed, 25 Dec 2019 12:07:43 +0800
In-Reply-To: <e9a8fbc0-5f08-75f5-b23b-2bbaa28a6222@acm.org>
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
         <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
         <e9a8fbc0-5f08-75f5-b23b-2bbaa28a6222@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 9E8AC75994A9931C91CCCF1ABA221DC9F8391A441FA39B78CDE8538966CF3BFE2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KDQo+IEhpIFN0YW5sZXksDQo+IA0KPiBGcm9tIHRoZSBTQ1NJIGNvcmU6DQo+
IA0KPiB2b2lkIHNjc2lfYmxvY2tfcmVxdWVzdHMoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QpDQo+
IHsNCj4gCXNob3N0LT5ob3N0X3NlbGZfYmxvY2tlZCA9IDE7DQo+IH0NCj4gDQo+IEluIG90aGVy
IHdvcmRzLCBuZWl0aGVyIHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBub3INCj4gdWZzaGNkX3Njc2lf
YmxvY2tfcmVxdWVzdHMoKSB3YWl0IGZvciBvbmdvaW5nIHVmc2hjZF9xdWV1ZWNvbW1hbmQoKQ0K
PiBjYWxscyB0byBmaW5pc2guIElzIGl0IHJlcXVpcmVkIHRvIHdhaXQgZm9yIHRoZXNlIGNhbGxz
IHRvIGZpbmlzaCBiZWZvcmUNCj4gZXhjZXB0aW9ucyBhcmUgaGFuZGxlZD8gSWYgbm90LCBjYW4g
dGhlIHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBhbmQNCj4gc2NzaV91bmJsb2NrX3JlcXVlc3RzKCkg
Y2FsbHMgYmUgbGVmdCBvdXQ/IElmIGl0IGlzIHJlcXVpcmVkIHRvIHdhaXQgZm9yDQo+IG9uZ29p
bmcgdWZzaGNkX3F1ZXVlY29tbWFuZCgpIGNhbGxzIHRvIGZpbmlzaCB0aGVuIEkgdGhpbmsgdGhl
DQo+IHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBhbmQgc2NzaV91bmJsb2NrX3JlcXVlc3RzKCkgd2ls
bCBoYXZlIHRvIGJlDQo+IGNoYW5nZWQgaW50byBzb21ldGhpbmcgZWxzZS4NCg0KQVNGQUlLLCB1
ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoKSBpcyBub3QgcmVxdWlyZWQgdG8gd2FpdCBm
b3INCm9uZ29pbmcgdWZzaGNkX3F1ZXVlY29tbWFuZCgpIGNhbGxzIHRvIGZpbmlzaC4NCg0KVGhl
IHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBjYWxsIGhlcmUgaXMgdHJ5aW5nIHRvIGluY3JlYXNlIHN1
Y2Nlc3NmdWwNCnJhdGUgb2YgcmVxdWVzdHMgc2VudCBieSB1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50
X2hhbmRsZXIoKSBiZWNhdXNlDQp0aW1lb3V0IG1heSBoYXBwZW4gaWYgZGV2aWNlIGlzIHRvbyBi
dXN5IHRvIGhhbmRsZSB0aG9zZSByZXF1ZXN0cy4NCkJsb2NraW5nIGFueSBmdXR1cmUgaW5jb21p
bmcgcmVxdWVzdHMgY2FuIGhlbHAuDQoNCkFzIHRpbWUgZ29lcyBieSwgYWN0dWFsbHkgY3VycmVu
dCBVRlMgZHJpdmVyIGFsbG93cyBtb3JlIHdhaXRpbmcgdGltZSBieQ0KYmVsb3cgY2hhbmdlcyBm
b3IgdWZzaGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKCksIGFuZCB0aHVzIHRoZQ0Kc3VjY2Vz
c2Z1bCByYXRlIHNoYWxsIGJlIHJhaXNlZCBtdWNoIG5vd2FkYXlzLg0KDQotIEVubGFyZ2UgUVVF
UllfUkVRX1RJTUVPVVQgdGltZSBmcm9tIDEwMCBtcyB0byAxLjUgc2Vjb25kcw0KLSBBbGxvdyBy
ZXRyeSBpZiBxdWVyeSByZXF1ZXN0cyBhcmUgdGltZWQgb3V0DQoNClRoZXJlZm9yZSwgdGhlIHNj
c2lfYmxvY2tfcmVxdWVzdHMoKSBjYWxsIGlzIGFjdHVhbGx5IGEgImhlbHBlciIgdG8gaGVscA0K
dWZzaGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKCkgc3VjY2Vzc2Z1bC4gSSB0aGluayBpdCBj
b3VsZCBiZSBiZXR0ZXINCmtlcHQgdG8gbWFrZSBVRlMgZGV2aWNlIHJlY292ZXIgaXRzIHBlcmZv
cm1hbmNlIGFzIHNvb24gYXMgcG9zc2libGUuDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNClRoYW5rcywNClN0YW5sZXkNCg0K

