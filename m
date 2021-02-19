Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3DDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB2D64E76
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBSNtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 08:49:20 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:48304 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229681AbhBSNtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 08:49:19 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 972AA41308;
        Fri, 19 Feb 2021 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1613742515; x=
        1615556916; bh=dEQbX76p267T71Am+JrbHnvqGUPl2dZEP5VsfMdipGk=; b=C
        MwvKknnGKK3VIrScuaVrH6v2cC1ygL6tdf8esTzFHd5LqyVAfZAUMl8R7f2kKAqC
        uJrhizZM5Jutpw9YtpU4O7svHk6ECKkjCbOt8p0rpPBC9C51NH7H5i+qEM1bidPy
        jSw+tkdLqaKdZIyRt1Bhmi2yuQT4lAE7gWIq+SCYCc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qs_jm5MbU2MN; Fri, 19 Feb 2021 16:48:35 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7934441203;
        Fri, 19 Feb 2021 16:48:35 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 19 Feb 2021 16:48:34 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Fri, 19 Feb 2021 16:48:35 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Thread-Topic: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Thread-Index: AQHW7xbhz/v++AJPt0KtRI7xihE05Ko670O0gACd+bCAAdADAIAiNHhA
Date:   Fri, 19 Feb 2021 13:48:35 +0000
Message-ID: <e9dcf5ad40194b1c8abb8d631b97c788@yadro.com>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
 <yq1tur3knh1.fsf@ca-mkp.ca.oracle.com>
 <83b96eded14d4722883836daebbe40dd@yadro.com>
 <9a3c59aa-2f4d-c022-c573-afdbc00ca08f@acm.org>
In-Reply-To: <9a3c59aa-2f4d-c022-c573-afdbc00ca08f@acm.org>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.210]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCj4+PiBJJ20gYSBiaXQgY29uY2VybmVkIGFib3V0IHRoaW5ncyBpbmFkdmVydGVudGx5
IGJyZWFraW5nIGlmIHdlIHJldHVybiBhbiBlbXB0eSBsaXN0IGZvciB0aGUgd2VsbCBrbm93biBM
VU5zLg0KPiA+DQo+PiBBY2NvcmRpbmcgdG8gU1BDIHdlIHNoYWxsIHJlcG9ydCBhbiBlbXB0eSBs
aXN0IGlmIHRoZXJlIGlzIG5vIHdlbGwta25vd24gTFVOUy4NCj4+IEZyZWVCU0QgaGFzIHRoZSBz
YW1lIGxvZ2ljIGluIFJFUE9SVCBMVU5TIGhhbmRsaW5nLiBTQ1NUIGRvZXMgbm90IHN1cHBvcnQg
U0VMRUNUX1dFTExLTk9XTiBjYXNlIGF0IGFsbC4NCj4+IA0KPj4gSSBkb24ndCBrbm93IHRoZSBo
aXN0b3J5IG9mIHRoZSBleGlzdGluZyBiZWhhdmlvdXIgdG8gc2VuZCBhbHdheXMgTFVOMCBpbnN0
ZWFkIG9mIGVtcHR5IGxpc3QuIFByb2JhYmx5IGl0IHdhcw0KPj4gZm9yIHRoZSBTQ1NJX1NFTEVD
VF9BTExfQUNDRVNTSUJMRSgweDAyKSBjYXNlLCB3aGVyZSBTUEMgYWxsb3dzIExVTjAuIE15IHBh
dGNoIGtlZXBzIGl0IGZvciB0aGUgMHgwMCwgMHgwMiwgMHgxMSBjYXNlcy4NCj4+IFRodXMsIEkg
YmVsaWV2ZSBpdCBkb2VzIG5vdCBicmVhayB0aGUgYmFja3dhcmQgY29tcGF0aWJpbGl0eS4NCg0K
PldpbGwgdGhpcyBjaGFuZ2UgcmVxdWlyZSB1c2VycyB0byB1cGRhdGUgdGhlaXIgTFVOIGNvbmZp
Z3VyYXRpb24/IFNvbWUgDQo+aW5pdGlhdG9yIG9wZXJhdGluZyBzeXN0ZW1zIHJlcXVpcmUgcHJl
c2VuY2Ugb2YgYSBkdW1teSBMVU4gMC4gQWx0aG91Z2ggDQo+SSBhZ3JlZSB0aGF0IGl0IGlzIGNs
ZWFuZXIgbm90IHRvIHByb3ZpZGUgYSBoYXJkY29kZWQgTFVOIDAsIEkgdGhpbmsgDQo+TWFydGlu
IGlzIGNvbmNlcm5lZCBhYm91dCB0aGlzIHBhdGNoIHBvdGVudGlhbGx5IGJyZWFraW5nIGV4aXN0
aW5nIA0KPmNvbmZpZ3VyYXRpb25zIGFuZCBjYXVzaW5nIGZydXN0cmF0aW9uIGFtb25nIExJTyB1
c2Vycy4NCg0KTm8gcmVjb25maWd1cmF0aW9uIG9uIGluaXRpYXRvciBzaWRlIGlzIHJlcXVpcmVk
Lg0KVy1MVU4gaXMgYSBzcGVjaWZpYyBMVU4gZm9yIHRoZSBzcGVjaWZpYyBTQ1NJIHRhcmdldCBk
ZXZpY2UgdGhhdCBpcyB3ZWxsIGtub3duDQpmb3IgdGhlIEluaXRpYXRvci4gR2VuZXJpYyBMaW51
eCBUQ00gZG9lcyBub3QgaGF2ZSBXLUxVTnMuIFNvbWUgc3RvcmFnZQ0Kc3lzdGVtcyBiYXNlZCBv
biBMaW51eCBUQ00gbWF5IGhhdmUgVy1MVU5zLiBCdXQgdGhlbiB0aGV5IHNoYWxsIC8gYWxyZWFk
eSBoYXZlDQppdHMgb3duIGhhbmRsaW5nIG9mIFJFUE9SVCBMVU5TIGNvbW1hbmQuDQpCYXNpY2Fs
bHksIGl0IGlzIGFuIGVycm9yIHRvIHJlcG9ydCBMVU4wIGFzIFctTFVOIGZvciB0aGUgSW5pdGlh
dG9yIHRoYXQNCmV4cGVjdHMgc29tZSBvdGhlciBudW1iZXJzLg0KDQpCUiwNCiBEbWl0cnkNCg==
