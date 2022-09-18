Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6687FECAAA1
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Sep 2022 02:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIRCqW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Sep 2022 22:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIRCqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2022 22:46:21 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Sep 2022 19:46:06 PDT
Received: from mail11.tencent.com (mail11.tencent.com [14.18.178.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F267A18E3F
        for <linux-scsi@vger.kernel.org>; Sat, 17 Sep 2022 19:46:06 -0700 (PDT)
Received: from EX-SZ018.tencent.com (unknown [10.28.6.39])
        by mail11.tencent.com (Postfix) with ESMTP id D3FEEFC026;
        Sun, 18 Sep 2022 10:36:03 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1663468563;
        bh=vGc8Y0cJBcko2hULJLRwbCZMSdAWWwq3LQU2D88qfbE=;
        h=From:To:CC:Subject:Date;
        b=nfruLQ5yIkOY+Z06yhRyMdtMRy5yYM5EBHC5VjlqGFnf8/qisD9dR6c664HnbFy4O
         iCW4P8zohdQSbM5qgFOZ+ii6+5bmLfyiw1opy2K4C+aXKsKQIcO7+Pmp9ADLAGd+Qp
         KO3chC0n4cNoOLopKfqum+HrQ8KKxJkOJDQZ1IPo=
Received: from EX-SZ051.tencent.com (10.28.6.106) by EX-SZ018.tencent.com
 (10.28.6.39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Sun, 18 Sep
 2022 10:36:03 +0800
Received: from EX-SZ049.tencent.com (10.28.6.102) by EX-SZ051.tencent.com
 (10.28.6.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Sun, 18 Sep
 2022 10:36:03 +0800
Received: from EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7]) by
 EX-SZ049.tencent.com ([fe80::e0be:89c3:ec1:bef7%8]) with mapi id
 15.01.2242.008; Sun, 18 Sep 2022 10:36:03 +0800
From:   =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH ]  scsi/ipr: keep the order of locks
Thread-Topic: [PATCH ]  scsi/ipr: keep the order of locks
Thread-Index: AQHYywdlY7tfNpRgx0+f69LISljf4g==
Date:   Sun, 18 Sep 2022 02:36:03 +0000
Message-ID: <2DD37C22-98B2-45B9-81F4-4DED4643CDC5@tencent.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [9.218.225.3]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB712BA0168463479307EB0BC98388E6@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

aXByX2F0YV9wb3N0X2ludGVybmFsOg0KICAgIGFjcXVpcmUgaG9zdF9sb2NrDQogICAgICAgYWNx
dWlyZSBocnJxLT5fbG9jaw0KICAgICAgICAgICAgIGlwcl9kZXZpY2VfcmVzZXQNCiAgICAgICAg
ICAgICAgICAgaXByX3NlbmRfYmxvY2tpbmdfY21kDQogICAgICAgICAgICAgICAgICAgIHJlbGVh
c2UgaG9zdF9sb2NrDQogICAgICAgICAgICAgICAgICAgIGFjcXVpcmUgaG9zdF9sb2NrDQogICAg
ICAgcmVsZWFzZSBocnJxLT5fbG9jaw0KICAgIHJlbGVhc2UgaG9zdF9sb2NrDQoNCkFzIHNob3du
IGFib3ZlLCB0aGVyZSBhcmUgdHdvIGxvY2sgYWNxdWlzaXRpb24gb3JkZXIgY2hhbmdlcy4NCkF0
IHRoZSBzYW1lIHRpbWUsIHdoZW4gaXByX2RldmljZV9yZXNldCBpcyBleGVjdXRlZCwgdGhlIGxv
Y2sNCmhycnEtPl9sb2NrIGRvZXMgbm90IG5lZWQgdG8gYmUgaGVsZC4NCg0KU2lnbmVkLW9mZi1i
eTogUGVuZyBIYW8gPGZseWluZ3BlbmdAdGVuY2VudC5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kv
aXByLmMgfCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL2lwci5jIGIvZHJpdmVycy9zY3NpL2lwci5jDQppbmRleCA5ZDAx
YTNlM2MyNmEuLjZjYTk4N2RkYTM5NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9pcHIuYw0K
KysrIGIvZHJpdmVycy9zY3NpL2lwci5jDQpAQCAtNjgzNyw3ICs2ODM3LDkgQEAgc3RhdGljIHZv
aWQgaXByX2F0YV9wb3N0X2ludGVybmFsKHN0cnVjdCBhdGFfcXVldWVkX2NtZCAqcWMpDQogICAg
ICAgICAgICAgICAgc3Bpbl9sb2NrKCZocnJxLT5fbG9jayk7DQogICAgICAgICAgICAgICAgbGlz
dF9mb3JfZWFjaF9lbnRyeShpcHJfY21kLCAmaHJycS0+aHJycV9wZW5kaW5nX3EsIHF1ZXVlKSB7
DQogICAgICAgICAgICAgICAgICAgICAgICBpZiAoaXByX2NtZC0+cWMgPT0gcWMpIHsNCisgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Bpbl91bmxvY2soJmhycnEtPl9sb2NrKTsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXByX2RldmljZV9yZXNldChpb2FfY2ZnLCBz
YXRhX3BvcnQtPnJlcyk7DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwaW5fbG9j
aygmaHJycS0+X2xvY2spOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsN
CiAgICAgICAgICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICB9DQotLQ0KMi4yNy4w
DQoNCg==
