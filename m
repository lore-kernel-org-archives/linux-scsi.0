Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97AEC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9431206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 12:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKNMq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 07:46:57 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2508 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbfKNMq4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 07:46:56 -0500
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 76393CEB6D434285D970;
        Thu, 14 Nov 2019 20:46:54 +0800 (CST)
Received: from DGGEML505-MBS.china.huawei.com ([169.254.11.138]) by
 dggeml406-hub.china.huawei.com ([10.3.17.50]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 20:46:45 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Lee Duncan <LDuncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: RE: [PATCH v3] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Topic: [PATCH v3] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Index: AdWa5/1WRcCg2Y9dT3SFjNDUgEm04Q==
Date:   Thu, 14 Nov 2019 12:46:44 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E28CFE@dggeml505-mbs.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCj4gT24gMTEvMTIvMTkgNTozNyBQTSwgTWFydGluIEsuIFBldGVyc2VuIHdyb3RlOg0K
PiA+DQo+ID4+IEluIGlzY3NpX2lmX3J4IGZ1bmMsIGFmdGVyIHJlY2VpdmluZyBvbmUgcmVxdWVz
dCB0aHJvdWdoDQo+ID4+IGlzY3NpX2lmX3JlY3ZfbXNnIGZ1bmMsIGlzY3NpX2lmX3NlbmRfcmVw
bHkgd2lsbCBiZSBjYWxsZWQgdG8gdHJ5IHRvDQo+ID4+IHJlcGx5IHRoZSByZXF1ZXN0IGluIGRv
LWxvb3AuIElmIHRoZSByZXR1cm4gb2YgaXNjc2lfaWZfc2VuZF9yZXBseQ0KPiA+PiBmdW5jIHJl
dHVybiAtRUFHQUlOIGFsbCB0aGUgdGltZSwgb25lIGRlYWRsb29wIHdpbGwgb2NjdXIuDQo+ID4+
DQo+ID4+IEZvciBleGFtcGxlLCBhIGNsaWVudCBvbmx5IHNlbmQgbXNnIHdpdGhvdXQgY2FsbGlu
ZyByZWN2bXNnIGZ1bmMsDQo+ID4+IHRoZW4gaXQgd2lsbCByZXN1bHQgaW4gdGhlIHdhdGNoZG9n
IHNvZnQgbG9ja3VwLg0KPiA+PiBUaGUgZGV0YWlscyBhcmUgZ2l2ZW4gYXMgZm9sbG93cywNCj4g
Pg0KPiA+IExlZS9DaHJpcy9VbHJpY2g6IFBsZWFzZSByZXZpZXchDQo+ID4NCj4gDQo+IA0KPiBP
a2F5LCBhZnRlciBsb29raW5nIGFnYWluIGF0IHRoZSB0aHJlYWQsIEkgZG8gaGF2ZSBzb21lIGFk
ZGl0aW9uYWwgZmVlZGJhY2sgZm9yDQo+IHRoZSBwYXRjaCBzdWJtaXR0ZXIuDQo+IA0KPiBZb3Ug
c2hvdWxkIHB1dCB5b3VyICJjaGFuZ2VzIGluIFYyLCBWMywgLi4uIiBhYm92ZSB0aGUgcGF0Y2gg
bGluZSAodGhlDQo+ICItLSAiIG9uIGEgbGluZSBieSBpdHNlbGYpLCBub3QgYXMgcGFydCBvZiB0
aGUgcGF0Y2guDQo+IA0KPiBBbHNvLCBhcyBsb25nIGFzIHlvdSBhcmUgbWFraW5nIG9uZSBsYXN0
IHJvdW5kIG9mIGNoYW5nZXMsIHBsZWFzZSBjaGFuZ2UNCj4gImRlYWRsb29wIiB0byAiZGVhZGxv
Y2siIGluIHlvdXIgcGF0Y2ggc3ViamVjdCwgYXMgZGVhZGxvb3AgaXMgbm90IGEgd29yZC4NCj4g
DQoNCk9rYXksIEkgd2lsbCBjb3JyZWN0IGl0IGluIFY0Lg0KDQo+IExhc3RseSwgdGhlICJTdWdn
ZXN0ZWQtYnkiIGxpbmVzIHlvdSBhZGRlZCBhcmUgZmluZSwgYnV0IHRoYXQgZ2VuZXJhbGx5IG1l
YW5zDQo+IHRoYXQgcGVyc29uIHN1Z2dlc3RlZCB0aGUgcGF0Y2gsIG5vdCBjaGFuZ2VzLiBGb3Ig
Zm9sa3MgdGhhdCBzdWdnZXN0IGNoYW5nZXMsDQo+IGl0J3MgdXAgdG8gdGhlbSB0byBzYXkgdGhl
eSBsaWtlIG9yIGRvIG5vdCBsaWtlIHlvdXIgY2hhbmdlcyBhZnRlciB5b3UgbWFrZSB0aGVtLA0K
PiBhdCB3aGljaCBwb2ludCB0aGV5IGNhbiBhZGQgdGhlaXIgIlJldmlld2VkLWJ5IiB0YWcgaWYg
dGhleSB3aXNoLg0KPiANCj4gUGxlYXNlIGZlZWwgZnJlZSB0byBzZW5kIHlvdXIgcGF0Y2ggdG8g
bWUgZGlyZWN0bHksIGJlZm9yZSBwdWJsaXNoaW5nLCBpZiB5b3UNCj4gd291bGQgbGlrZSBhIHJl
dmlldyBiZWZvcmUgcHVibGlzaGluZyBhZ2Fpbi4NCg0KT2theSwgVGhhbmtzLg0KPiANCj4gLS0N
Cj4gTGVlDQo=
