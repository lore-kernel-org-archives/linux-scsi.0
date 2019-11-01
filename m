Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF164CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC58220656
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfKAJVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 05:21:09 -0400
Received: from smtp.h3c.com ([60.191.123.50]:41855 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfKAJVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Nov 2019 05:21:09 -0400
Received: from DAG2EX01-BASE.srv.huawei-3com.com ([10.8.0.64])
        by h3cspam02-ex.h3c.com with ESMTPS id xA19KZYN076709
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 17:20:35 +0800 (GMT-8)
        (envelope-from zhang.guanghui@h3c.com)
Received: from DAG2EX10-IDC.srv.huawei-3com.com (10.8.0.73) by
 DAG2EX01-BASE.srv.huawei-3com.com (10.8.0.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 17:20:38 +0800
Received: from DAG2EX10-IDC.srv.huawei-3com.com ([fe80::e886:502d:5063:7e2b])
 by DAG2EX10-IDC.srv.huawei-3com.com ([fe80::e886:502d:5063:7e2b%10]) with
 mapi id 15.01.1713.004; Fri, 1 Nov 2019 17:20:38 +0800
From:   Zhangguanghui <zhang.guanghui@h3c.com>
To:     James Smart <jsmart2021@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: scsi: lpfc: Fix crash in the function lpfc_sli4_queue_free when
 reboot  
Thread-Topic: scsi: lpfc: Fix crash in the function lpfc_sli4_queue_free when
 reboot  
Thread-Index: AdWQlS+EA4kt8dflQIqlo37LRckPOw==
Date:   Fri, 1 Nov 2019 09:20:38 +0000
Message-ID: <dce8e80b96114a63a85417c04219235c@h3c.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.114.72.62]
x-sender-location: DAG2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com xA19KZYN076709
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgZXZlcnlvbmUNClRoZXJlIGlzIGEgY3Jhc2ggaW4gdGhlIGZ1bmN0aW9uIGxwZmNfc2xpNF9x
dWV1ZV9mcmVlIHdoaWxlIHJlYm9vdGluZyB0aGUgaG9zdC4NCnBvdGVudGlhbCBjcmFzaCBhcmlz
aW5nIGZyb20gJyB3cV9saXN0IGxpc3RfZGVsZXRlJyBvcmRlcmluZyBwcm9ibGVtcy4NCkkgdGhp
bmtzIGl04oCZcyB0aGUgY29ycmVjdCBvcmRlci4NCmNhbiB5b3UgaGVscCBtZSByZXZpZXcgYW5k
IGNvbW1pdCB0aGlzIHBhdGNoLCBCZXN0IHJlZ2FyZHMNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9scGZjIC9scGZjX3NsaS5jIGIvZHJpdmVycy9zY3NpL2xwZmMgL2xwZmNfc2xpLmMNCmlu
ZGV4IDUwZjEzYWIuLjBjZDVhOTYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvbHBmYyAvbHBm
Y19zbGkuYw0KKysrIGIvZHJpdmVycy9zY3NpL2xwZmMgL2xwZmNfc2xpLmMNCkBAIC0xNDQzOCw5
ICsxNDQzOCw2IEBAIGxwZmNfc2xpNF9xdWV1ZV9mcmVlKHN0cnVjdCBscGZjX3F1ZXVlICpxdWV1
ZSkNCiAgICAgICAgaWYgKCFxdWV1ZSkNCiAgICAgICAgICAgICAgICByZXR1cm47DQoNCi0gICAg
ICAgaWYgKCFsaXN0X2VtcHR5KCZxdWV1ZS0+d3FfbGlzdCkpDQotICAgICAgICAgICAgICAgbGlz
dF9kZWwoJnF1ZXVlLT53cV9saXN0KTsNCi0NCiAgICAgICAgd2hpbGUgKCFsaXN0X2VtcHR5KCZx
dWV1ZS0+cGFnZV9saXN0KSkgew0KICAgICAgICAgICAgICAgIGxpc3RfcmVtb3ZlX2hlYWQoJnF1
ZXVlLT5wYWdlX2xpc3QsIGRtYWJ1Ziwgc3RydWN0IGxwZmNfZG1hYnVmLA0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgbGlzdCk7DQpAQCAtMTQ0NTMsNiArMTQ0NTAsOSBAQCBscGZj
X3NsaTRfcXVldWVfZnJlZShzdHJ1Y3QgbHBmY19xdWV1ZSAqcXVldWUpDQogICAgICAgICAgICAg
ICAga2ZyZWUocXVldWUtPnJxYnApOw0KICAgICAgICB9DQoNCisgICAgICAgaWYgKCFsaXN0X2Vt
cHR5KCZxdWV1ZS0+d3FfbGlzdCkpDQorICAgICAgICAgICAgICAgbGlzdF9kZWwoJnF1ZXVlLT53
cV9saXN0KTsNCisNCiAgICAgICAgaWYgKCFsaXN0X2VtcHR5KCZxdWV1ZS0+Y3B1X2xpc3QpKQ0K
ICAgICAgICAgICAgICAgIGxpc3RfZGVsKCZxdWV1ZS0+Y3B1X2xpc3QpOw0KLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0K5pys6YKu5Lu25Y+K5YW26ZmE5Lu25ZCr5pyJ5paw5Y2O5LiJ6ZuG5Zui55qE5L+d
5a+G5L+h5oGv77yM5LuF6ZmQ5LqO5Y+R6YCB57uZ5LiK6Z2i5Zyw5Z2A5Lit5YiX5Ye6DQrnmoTk
uKrkurrmiJbnvqTnu4TjgILnpoHmraLku7vkvZXlhbbku5bkurrku6Xku7vkvZXlvaLlvI/kvb/n
lKjvvIjljIXmi6zkvYbkuI3pmZDkuo7lhajpg6jmiJbpg6jliIblnLDms4TpnLLjgIHlpI3liLbj
gIENCuaIluaVo+WPke+8ieacrOmCruS7tuS4reeahOS/oeaBr+OAguWmguaenOaCqOmUmeaUtuS6
huacrOmCruS7tu+8jOivt+aCqOeri+WNs+eUteivneaIlumCruS7tumAmuefpeWPkeS7tuS6uuW5
tuWIoOmZpOacrA0K6YKu5Lu277yBDQpUaGlzIGUtbWFpbCBhbmQgaXRzIGF0dGFjaG1lbnRzIGNv
bnRhaW4gY29uZmlkZW50aWFsIGluZm9ybWF0aW9uIGZyb20gTmV3IEgzQywgd2hpY2ggaXMNCmlu
dGVuZGVkIG9ubHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHdob3NlIGFkZHJlc3MgaXMgbGlz
dGVkIGFib3ZlLiBBbnkgdXNlIG9mIHRoZQ0KaW5mb3JtYXRpb24gY29udGFpbmVkIGhlcmVpbiBp
biBhbnkgd2F5IChpbmNsdWRpbmcsIGJ1dCBub3QgbGltaXRlZCB0bywgdG90YWwgb3IgcGFydGlh
bA0KZGlzY2xvc3VyZSwgcmVwcm9kdWN0aW9uLCBvciBkaXNzZW1pbmF0aW9uKSBieSBwZXJzb25z
IG90aGVyIHRoYW4gdGhlIGludGVuZGVkDQpyZWNpcGllbnQocykgaXMgcHJvaGliaXRlZC4gSWYg
eW91IHJlY2VpdmUgdGhpcyBlLW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRl
cg0KYnkgcGhvbmUgb3IgZW1haWwgaW1tZWRpYXRlbHkgYW5kIGRlbGV0ZSBpdCENCg==
