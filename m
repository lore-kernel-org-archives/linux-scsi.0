Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A18C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 05:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D1B6103B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 05:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhKKFoT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 00:44:19 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:57688 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229463AbhKKFoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 00:44:19 -0500
X-UUID: 5d98166b89384666a99459a552fec35e-20211111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=uU3GXZThZjqCV+0NTVcHqLrhCFqb20KUFxJbZ2ItdwY=;
        b=KPR8G72/hldnGPX5E2m1h56pVeQMKHwC0vech0uDAn3URu2n4ZeKKvBWRwX1AYzbTCbuJmAZtSGavKjaEYLNITdU7wImCy1eFLugGgWi7FUAlcTyXui01r9MypLeU6c/rem6HJDuc1xiS75HiRmlP9NNGtre/rd+0RtEbByx/64=;
X-UUID: 5d98166b89384666a99459a552fec35e-20211111
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 904434180; Thu, 11 Nov 2021 13:41:25 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 11 Nov 2021 13:41:24 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 11 Nov 2021 13:41:24 +0800
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: add put_device() after
 of_find_device_by_node()
To:     <cgel.zte@gmail.com>, <stanley.chu@mediatek.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <matthias.bgg@gmail.com>, <linux-scsi@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20211110105133.150171-1-ye.guojin@zte.com.cn>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <16e61844-6fc7-2d1d-ee30-364c6df59545@mediatek.com>
Date:   Thu, 11 Nov 2021 13:41:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211110105133.150171-1-ye.guojin@zte.com.cn>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiAxMS8xMC8yMSA2OjUxIFBNLCBjZ2VsLnp0ZUBnbWFpbC5jb20gd3JvdGU6DQo+IEZyb206
IFllIEd1b2ppbiA8eWUuZ3VvamluQHp0ZS5jb20uY24+DQo+DQo+IFRoaXMgd2FzIGZvdW5kIGJ5
IGNvY2NpY2hlY2s6DQo+IC4vZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYywgMjExLCAx
LTcsIEVSUk9SIG1pc3NpbmcgcHV0X2RldmljZTsNCj4gY2FsbCBvZl9maW5kX2RldmljZV9ieV9u
b2RlIG9uIGxpbmUgMTE4NSwgYnV0IHdpdGhvdXQgYSBjb3JyZXNwb25kaW5nDQo+IG9iamVjdCBy
ZWxlYXNlIHdpdGhpbiB0aGlzIGZ1bmN0aW9uLg0KPg0KPiBSZXBvcnRlZC1ieTogWmVhbCBSb2Jv
dCA8emVhbGNpQHp0ZS5jb20uY24+DQo+IFNpZ25lZC1vZmYtYnk6IFllIEd1b2ppbiA8eWUuZ3Vv
amluQHp0ZS5jb20uY24+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQo+IGluZGV4IGZjNWIyMTQzNDdiMy4uNTM5M2I1YzlkZDljIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTExODksNiArMTE4OSw3IEBAIHN0YXRp
YyBpbnQgdWZzX210a19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAl9
DQo+ICAgCWxpbmsgPSBkZXZpY2VfbGlua19hZGQoZGV2LCAmcmVzZXRfcGRldi0+ZGV2LA0KPiAg
IAkJRExfRkxBR19BVVRPUFJPQkVfQ09OU1VNRVIpOw0KPiArCXB1dF9kZXZpY2UoJnJlc2V0X3Bk
ZXYtPmRldik7DQoNClRoYW5rcyBmb3IgZml4IHRoaXMgbWlzc2luZy4NClJldmlld2VkLWJ5OiBQ
ZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KPiAgIAlpZiAoIWxpbmspIHsN
Cj4gICAJCWRldl9ub3RpY2UoZGV2LCAiYWRkIHJlc2V0IGRldmljZV9saW5rIGZhaWxcbiIpOw0K
PiAgIAkJZ290byBza2lwX3Jlc2V0Ow==

