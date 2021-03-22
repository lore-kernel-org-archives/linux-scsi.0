Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE82C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972A66198E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCVR4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:56:08 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56414 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230252AbhCVRzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 13:55:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 07F8B41283;
        Mon, 22 Mar 2021 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1616435740; x=
        1618250141; bh=nXMuB0s7q2VS8/QdPyACi3QJZU2Oimhk+lxja7/l/0E=; b=e
        PhZLYuhvKnAfUkHgXxaooMLn3OSC2Tyn13E/eCpMWKiwb514/SprusZUvYJ1OS4x
        oIOUmOH5j/4LNa04jata6nPmfsz4bLL+rMj3Mulij7bS/YnEIdC6E6j/t/J5rea+
        ysDbXEOMS1C9zfekWFht61eEUeqhUDbSCfkqnruIYU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6h3vOdkIJ4hE; Mon, 22 Mar 2021 20:55:40 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EF5FE41241;
        Mon, 22 Mar 2021 20:55:38 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 22 Mar 2021 20:55:38 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Mon, 22 Mar 2021 20:55:38 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        "Michael Cyr" <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v2 1/7] target: core: add common tpg/enable attribute
Thread-Topic: [PATCH v2 1/7] target: core: add common tpg/enable attribute
Thread-Index: AQHXHvI5WsiMlhat70+P5gPZje+eNKqQE2uAgAAyvWA=
Date:   Mon, 22 Mar 2021 17:55:38 +0000
Message-ID: <85469d8f09a240ab8760534a771a7d0d@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
 <20210322080554.7611-2-d.bogdanov@yadro.com>
 <d8d1e9c2-4cd7-3f41-8545-99549b0704d4@oracle.com>
In-Reply-To: <d8d1e9c2-4cd7-3f41-8545-99549b0704d4@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KVGhhbmsgeW91IGZvciB0aGUgY29tbWVudHMuDQoNCj4gPiArCWlmICh0Zi0+
dGZfb3BzLT5mYWJyaWNfZW5hYmxlX3RwZykNCj4gPiArCQlmb3IgKGkgPSAwOyBjb3JlX3RwZ19i
YXNlX2VuYWJsZV9hdHRyc1tpXTsgaSsrKQ0KPiA+ICsJCQlhdHRyc1tpXSA9IGNvcmVfdHBnX2Jh
c2VfZW5hYmxlX2F0dHJzW2ldOw0KPiA+ICsJaWYgKHRmLT50Zl9vcHMtPnRmY190cGdfYmFzZV9h
dHRycykNCj4gPiArCQlmb3IgKGsgPSAwOyB0Zi0+dGZfb3BzLT50ZmNfdHBnX2Jhc2VfYXR0cnNb
a107IGsrKywgaSsrKQ0KDQo+IElmIGZhYnJpY19lbmFibGVfdHBnIGlzIG5vdCBzZXQgdGhlbiBJ
IHRoaW5rIGkgaXMgdGhlIHZhbHVlIGZyb20gYWJvdmUgd2hlbiB3ZSBkaWQgdGhlIHRmY190cGdf
YmFzZV9hdHRycyBsb29wIHRvIGNhbGN1bGF0ZSB0aGUgdG90YWwgbGVuIG5lZWRlZCBmb3IgdGhl
IGt6YWxsb2MuDQpZZXMsIHlvdSBhcmUgcmlnaHQsIHdpbGwgZml4IGl0Lg0KDQo+ID4gKwkJCWF0
dHJzW2ldID0gdGYtPnRmX29wcy0+dGZjX3RwZ19iYXNlX2F0dHJzW2tdOw0KPiA+ICsJYXR0cnNb
aV0gPSBOVUxMOw0KDQo+IElmIGZhYnJpY19lbmFibGVfdHBnIGFuZCB0ZmNfdHBnX2Jhc2VfYXR0
cnMgYXR0cnMgaXMgbm90IHNldCB0aGVuIGkgaXMgbm90IGluaXRpYWxpemVkLg0KWWVzLCB5b3Ug
YXJlIHJpZ2h0LCB3aWxsIGZpeCBpdC4NCg0KPiBJJ20gZ3Vlc3NpbmcgeW91IGd1eXMgZG8gbW9y
ZSB0ZXN0aW5nIHdpdGggdGNtX3FsYS4gTWF5YmUgYWxzbyBkbyBhIHF1aWNrIHRhcmdldCBjcmVh
dGlvbiB0ZXN0IHdpdGggaXNjc2kgYW5kIGxvb3AgdG8gaGl0IHNvbWUgb2YgdGhlIGRpZmZlcmVu
dCBjb21ib3MuDQpTaGFtZSBvbiBtZS4gSSBkaWQgdGVzdHMgZm9yIHYxIGFuZCBiZWxpZXZlZCB0
aGF0IHYyIGFsc28gd29ya3MgYmVjYXVzZSBvZiB0cml2aWFsIGNoYW5nZXMuIEkgd2lsbCB0ZXN0
IGVhY2ggdmVyc2lvbiBiZWZvcmUgc3VibWlzc2lvbiBpbiB0aGUgZnV0dXJlLg0KDQpCUiwNCiBE
bWl0cnkNCg==
