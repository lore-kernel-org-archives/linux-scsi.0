Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CCCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 09:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A0F61BF6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 09:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhKPJK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:10:26 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53006 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232764AbhKPJKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 04:10:16 -0500
X-UUID: 8fd92ae8f74341d79688559bc0cb3d72-20211116
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:CC:To:From:Subject; bh=bIKODVeKHXJ56BjdRfzxvGtklaoublQxVDmLtXTHKAE=;
        b=gOQD2T00mLoBYRBAHreAn8H7X84MI5fs/wJqkeIPtBNa5ztS7lyW4kja4gSEj+LuEOZT0FyamcC28ICtEhfsrkZMSzdzotrGP7uKXIgb5XHI27TJB0ZPp+BfQMZele/8756doEEE6/ahOU8QBhnGnFbLldQoczjCRiy3WbQGurw=;
X-UUID: 8fd92ae8f74341d79688559bc0cb3d72-20211116
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1408160208; Tue, 16 Nov 2021 17:07:15 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 16 Nov 2021 17:07:13 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Nov 2021 17:07:13 +0800
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
From:   Peter Wang <peter.wang@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
Message-ID: <1a196e1b-1412-90f3-e511-3f669572a619@mediatek.com>
Date:   Tue, 16 Nov 2021 17:07:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiAxMS8xMS8yMSA1OjE3IFBNLCBQZXRlciBXYW5nIHdyb3RlOg0KPiBIaSBCYXJ0LA0KPg0K
PiBPbiAxMS8xMC8yMSA4OjQ0IEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+PiBNYWtlIHN1
cmUgdGhhdCBhYm9ydGVkIGNvbW1hbmRzIGFyZSBjb21wbGV0ZWQgb25jZSBieSBjbGVhcmluZyB0
aGUNCj4+IGNvcnJlc3BvbmRpbmcgdGFnIGJpdCBmcm9tIGhiYS0+b3V0c3RhbmRpbmdfcmVxcy4g
VGhpcyBwYXRjaCBpcyBhDQo+PiBmb2xsb3ctdXAgZm9yIGNvbW1pdCBjZDg5MjA5NmM5NDAgKCJz
Y3NpOiB1ZnM6IGNvcmU6IEltcHJvdmUgU0NTSQ0KPj4gYWJvcnQgaGFuZGxpbmciKS4NCj4+DQo+
PiBGaXhlczogN2EzZTk3YjBkYzRiICgiW1NDU0ldIHVmc2hjZDogVUZTIEhvc3QgY29udHJvbGxl
ciBkcml2ZXIiKQ0KPj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hl
QGFjbS5vcmc+DQo+PiAtLS0NCj4+IMKgIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA5ICsr
KysrKysrKw0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KPj4gaW5kZXggOGY1NjQwNjQ3MDU0Li4xZTE1ZWQxZjYzOWYgMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+PiArKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQo+PiBAQCAtNzA5MCw2ICs3MDkwLDE1IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Fi
b3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHJl
bGVhc2U7DQo+PiDCoMKgwqDCoMKgIH0NCj4+IMKgICvCoMKgwqAgLyoNCj4+ICvCoMKgwqDCoCAq
IHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygpIGNsZWFyZWQgdGhlICd0YWcnIGJpdCBpbiB0aGUg
ZG9vcmJlbGwNCj4+ICvCoMKgwqDCoCAqIHJlZ2lzdGVyLiBDbGVhciB0aGUgY29ycmVzcG9uZGlu
ZyBiaXQgZnJvbSBvdXRzdGFuZGluZ19yZXFzIHRvDQo+PiArwqDCoMKgwqAgKiBwcmV2ZW50IGVh
cmx5IGNvbXBsZXRpb24uDQo+PiArwqDCoMKgwqAgKi8NCj4+ICvCoMKgwqAgc3Bpbl9sb2NrX2ly
cXNhdmUoJmhiYS0+b3V0c3RhbmRpbmdfbG9jaywgZmxhZ3MpOw0KPj4gK8KgwqDCoCBfX2NsZWFy
X2JpdCh0YWcsICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpOw0KPj4gK8KgwqDCoCBzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZoYmEtPm91dHN0YW5kaW5nX2xvY2ssIGZsYWdzKTsNCj4+ICsNCj4NCj4g
c2hvdWxkIHdlIGFsc28gY2FsbCB1bm1hcD8NCj4NCj4gwqDCoMKgIHNjc2lfZG1hX3VubWFwKGNt
ZCk7DQo+DQpIaSBCYXJ0LA0KDQpTaG91bGQgd2UgYWRkIHVubWFwPw0KDQoNClRoYW5rcy4NCg0K
UGV0ZXINCg0KDQo+DQo+PiDCoMKgwqDCoMKgIGxyYnAtPmNtZCA9IE5VTEw7DQo+PiDCoMKgwqDC
oMKgIGVyciA9IFNVQ0NFU1M7

