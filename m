Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16086C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 07:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACB260F43
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 07:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhJVHub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 03:50:31 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44088 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231773AbhJVHua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 03:50:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 84FEA43B9A;
        Fri, 22 Oct 2021 07:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1634888891; x=
        1636703292; bh=UlmBZOypFnZoEHyHev75QC+FAdiumfFof7f0RVuR3xU=; b=m
        PeWv+H6ifLTBzqrz8Zzoxv/kIj5cnDLa8feb0Z2NEDW2CvdldMQCpYQmn3NVw2I1
        pSITdignwgeRvTB9f1sLTw5YzE+gNnXg4AieSnEO8eb0gKzHmvvNB+XXCBJ1NBFy
        fVCio0owS8z5jpps4rij3MWaFNOHrRLN7aLo/YBUkI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PmIsfc4kTn4i; Fri, 22 Oct 2021 10:48:11 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B23E743BB0;
        Fri, 22 Oct 2021 10:48:08 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 22 Oct 2021 10:48:07 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Fri, 22 Oct 2021 10:48:07 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Thread-Topic: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Thread-Index: AQHXxLmS7SuA9HdbIk2r5RVxhcl+j6veWFEAgABFs0A=
Date:   Fri, 22 Oct 2021 07:48:07 +0000
Message-ID: <15af5f6f490a42c5a02c9d9bd79f1a28@yadro.com>
References: <20211019071843.14890-1-d.bogdanov@yadro.com>
 <ec9e01a3-73d0-a06b-8c20-ae492c0c3313@oracle.com>
In-Reply-To: <ec9e01a3-73d0-a06b-8c20-ae492c0c3313@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.178.112.183]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPiBJIGNhbid0IHNlZW0gdG8gZ2V0IHRoZSBwYXRjaGVzIHdvcmtpbmcgd2l0
aCB0aGUgdGFyZ2V0Y2xpIGNvbmZpZyBmaWxlIGJlbG93IEl0IHdvcmtlZCBvayBiZWZvcmUgdGhl
IHBhdGNoZXMuDQo+DQo+IEkgZ2V0IHRoaXMgZXJyb3I6DQo+DQo+IE9jdCAyMiAwMDo1NjoyNSBv
bDQga2VybmVsOiBDSEFQIHVzZXIgb3IgcGFzc3dvcmQgbm90IHNldCBmb3IgSW5pdGlhdG9yIEFD
TA0KPiBPY3QgMjIgMDA6NTY6MjUgb2w0IGtlcm5lbDogU2VjdXJpdHkgbmVnb3RpYXRpb24gZmFp
bGVkLg0KPiBPY3QgMjIgMDA6NTY6MjUgb2w0IGtlcm5lbDogaVNDU0kgTG9naW4gbmVnb3RpYXRp
b24gZmFpbGVkLg0KDQpUaGlzIGtpbmQgb2YgZXJyb3IgaXMgcmVwb3J0ZWQgZm9yIHRoZSB1bmtu
b3duIChkeW5hbWljKSBBQ0wgc2luY2UgdGhlIGNvbmZpZyBmaWxlIGhhdmUgbm90IGhhdmUNCnVz
ZXJpZC9wYXNzd29yZCBjb25maWd1cmVkIGZvciBUUEcuIFlvdXIgY29uZmlnIGZpbGUgbG9va3Mg
c3RyYW5nZSAtIGl0IGhhcyBnZW5lcmF0ZV9keW5fYWNscz0xDQpidXQgaGFzIG5vdCBjcmVkZW50
aWFscyBmb3IgZHluYW1pYyBhY2xzLg0KDQpMb2dpbiBmcm9tIHRoZSBjb25maWd1cmVkIEFDTCBp
biB0aGlzIGNvbmZpZyBmaWxlIHdvcmtzIHdlbGwgZm9yIG1lLg0KDQpDb3VsZCB5b3UsIHBsZWFz
ZSwgZGVzY3JpYmUgbW9yZSBkZXRhaWxzIG9mIHlvdXIgdXNlY2FzZT8NCg0KQlIsDQogRG1pdHJ5
DQo=
