Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0D4C83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AFB20838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HoJiajny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgD3Ihj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:37:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:33997 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726127AbgD3Ihi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 04:37:38 -0400
X-UUID: ad5f9674fb3c46edb7722b64b2b2972a-20200430
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6fuLsSr7ht5XTQtQNi2tUVonpMMOQGnUTyqQfCtGbyc=;
        b=HoJiajnysPjLiHqP3nXrg4uXQYs/P3Y2XWVD/MPYwOyG6sIWnCM3uFsHLnY6FDnFf6Gm1YOB15ZVrhTgJkhtvaRbN/v4bH0ndFD5yw4TAkSQjp8mBORqiovtlvrl0yYejJRNz0jQC2WIly/ym8DqY/2cjDQoA6vo5/0hmtAj+No=;
X-UUID: ad5f9674fb3c46edb7722b64b2b2972a-20200430
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 675497186; Thu, 30 Apr 2020 16:37:35 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 30 Apr 2020 16:37:33 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 16:37:34 +0800
Message-ID: <1588235853.3197.6.camel@mtkswgap22>
Subject: RE: [PATCH v2 3/5] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Thu, 30 Apr 2020 16:37:33 +0800
In-Reply-To: <BYAPR04MB462991CBE166B51BFAF2E6B3FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
         <20200429135610.23750-4-stanley.chu@mediatek.com>
         <BYAPR04MB462991CBE166B51BFAF2E6B3FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 830AF5C7FA77C69071E5C6943126B4BF8D7E7B2D8CE0B39DC1FC316DFF1272C52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gVGh1LCAyMDIwLTA0LTMwIGF0IDA4OjMwICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVjdCB1
ZnNfaGJhICpoYmEsIHU4ICpkZXNjX2J1ZikNCj4gPiAgew0KPiA+ICsgICAgICAgaW50IHJldDsN
Cj4gPiArICAgICAgIHU4IGx1bjsNCj4gPiArICAgICAgIHUzMiBkX2x1X3diX2J1Zl9hbGxvYyA9
IDA7DQo+ID4gKw0KPiA+ICAgICAgICAgaWYgKGhiYS0+ZGVzY19zaXplLmRldl9kZXNjIDw9DQo+
ID4gREVWSUNFX0RFU0NfUEFSQU1fRVhUX1VGU19GRUFUVVJFX1NVUCkNCj4gPiAgICAgICAgICAg
ICAgICAgZ290byB3Yl9kaXNhYmxlZDsNCj4gPiANCj4gPiBAQCAtNjgyMSwxNSArNjg0MiwzNSBA
QCBzdGF0aWMgdm9pZCB1ZnNoY2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmENCj4gPiAqaGJhLCB1
OCAqZGVzY19idWYpDQo+ID4gICAgICAgICBoYmEtPmRldl9pbmZvLmJfd2JfYnVmZmVyX3R5cGUg
PQ0KPiA+ICAgICAgICAgICAgICAgICBkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9UWVBF
XTsNCj4gPiANCj4gPiAtICAgICAgIGhiYS0+ZGV2X2luZm8uZF93Yl9hbGxvY191bml0cyA9DQo+
ID4gLSAgICAgICAgICAgICAgIGdldF91bmFsaWduZWRfYmUzMihkZXNjX2J1ZiArDQo+ID4gLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBERVZJQ0VfREVTQ19QQVJBTV9XQl9TSEFS
RURfQUxMT0NfVU5JVFMpOw0KPiA+ICAgICAgICAgaGJhLT5kZXZfaW5mby5iX3ByZXNydl91c3Bj
X2VuID0NCj4gPiAgICAgICAgICAgICAgICAgZGVzY19idWZbREVWSUNFX0RFU0NfUEFSQU1fV0Jf
UFJFU1JWX1VTUlNQQ19FTl07DQo+ID4gDQo+ID4gLSAgICAgICBpZiAoIShoYmEtPmRldl9pbmZv
LmJfd2JfYnVmZmVyX3R5cGUgJiYNCj4gPiAtICAgICAgICAgICAgIGhiYS0+ZGV2X2luZm8uZF93
Yl9hbGxvY191bml0cykpDQo+ID4gLSAgICAgICAgICAgICAgIGdvdG8gd2JfZGlzYWJsZWQ7DQo+
ID4gKyAgICAgICBpZiAoaGJhLT5kZXZfaW5mby5iX3diX2J1ZmZlcl90eXBlID09IFdCX0JVRl9N
T0RFX1NIQVJFRCkgew0KPiA+ICsgICAgICAgICAgICAgICBoYmEtPmRldl9pbmZvLmRfd2JfYWxs
b2NfdW5pdHMgPQ0KPiA+ICsgICAgICAgICAgICAgICBnZXRfdW5hbGlnbmVkX2JlMzIoZGVzY19i
dWYgKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgREVWSUNFX0RFU0Nf
UEFSQU1fV0JfU0hBUkVEX0FMTE9DX1VOSVRTKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCFo
YmEtPmRldl9pbmZvLmRfd2JfYWxsb2NfdW5pdHMpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgZ290byB3Yl9kaXNhYmxlZDsNCj4gPiArICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIGZvciAobHVuID0gMDsgbHVuIDwgaGJhLT5kZXZfaW5mby5tYXhfbHVfc3VwcG9ydGVk
OyBsdW4rKykgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IHVmc2hjZF9yZWFk
X3VuaXRfZGVzY19wYXJhbShoYmEsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGx1biwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgVU5JVF9ERVNDX1BBUkFNX1dCX0JVRl9BTExPQ19VTklUUywNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKHU4ICopJmRfbHVfd2JfYnVmX2FsbG9jLA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzaXplb2YoZF9sdV93Yl9i
dWZfYWxsb2MpKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAocmV0KQ0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byB3Yl9kaXNhYmxlZDsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoZF9sdV93Yl9idWZfYWxsb2MpIHsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGhiYS0+ZGV2X2luZm8ud2JfZGVkaWNhdGVkX2x1ID0g
bHVuOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+IFdoeSBh
cmUgeW91IGFsbG93aW5nIG9ubHkgYSBzaW5nbGUgV0IgbHVuPw0KPiBZb3Ugc2hvdWxkIGFsbG93
IHRob3NlIGJ1ZmZlcnMgZm9yIGx1bjAuLmx1bjcNCg0KSW4gVUZTIDMuMSBzcGVjaWZpY2F0aW9u
LCB0aGUgdmFsaWQgdmFsdWUgb2YgYkRldmljZU1heFdyaXRlQm9vc3RlckxVcw0KaXMgMS4gVGhl
cmVmb3JlIG9ubHkgb25lIExVIGNhbiBoYXZlIFdyaXRlQm9vc3RlciBidWZmZXIuDQoNClRoYW5r
cywNClN0YW5sZXkNCg0KDQo=

