Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59370C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 09:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiGGJO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 05:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiGGJOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 05:14:55 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7E72A97F
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 02:14:54 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 26A7C412DE;
        Thu,  7 Jul 2022 09:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received:received; s=mta-01; t=1657185291; x=
        1658999692; bh=sn7ppcDc4q0hu3Ls0LT6KG8ETT6oibJ0Tr8PPEXqSLI=; b=s
        mBpodBYBXiHLIQA6LSaHOnakoGjDF+IR9EQhYtiWag5ZE60sE8IHdOwErg0bt5AU
        dTyCUgJxJySs207Diw9+yMHqSx0M1VuLH+/PNwz/tcTHL1Asq+biejz5QQFNYiqu
        W1D8Q/OyjuxDYHKdEQlP+rJOQdb/rC44Lkt1F/d4Bg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mDqkA6QnfPKN; Thu,  7 Jul 2022 12:14:51 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1E9BC411FD;
        Thu,  7 Jul 2022 12:14:49 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 12:14:48 +0300
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Thu, 7 Jul 2022 12:14:48 +0300
Received: from T-EXCH-08.corp.yadro.com ([172.17.11.58]) by
 T-EXCH-08.corp.yadro.com ([172.17.11.58]) with mapi id 15.02.1118.009; Thu, 7
 Jul 2022 12:14:48 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: RE: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
Thread-Topic: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
Thread-Index: AQHYkZFt2dlz1fcCV0GBRBN7WQpUfq1ynPhw
Date:   Thu, 7 Jul 2022 09:14:48 +0000
Message-ID: <17d93b498de04ee5b550ff0fe8b91847@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <6a5487365f0804447d4cbb8911d0719d8b21b601.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <6a5487365f0804447d4cbb8911d0719d8b21b601.1657149962.git.Thinh.Nguyen@synopsys.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.178.114.42]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgVGhpbmgsDQoNCj4gRnJlZSB1cCBzYml0bWFwIGluZGV4IGltbWVkaWF0ZWx5IG9uY2UgdGhl
IGNvbW1hbmQgaXMgY29tcGxldGVkIHJhdGhlcg0KPiB0aGFuIHdhaXRpbmcgZm9yIGtyZWYgdG8g
Y2FsbCBmcmVlaW5nIHRhZy4gVGhpcyBrZWVwcyB0aGUgc2JpdG1hcCBxdWV1ZQ0KPiBmcmVlIHF1
aWNrZXIuDQo+IA0KVGhhdCBpcyBjb21wbGV0ZWx5IHdyb25nLiBTYml0bWFwIGluZGV4IGlzIGEg
cGxhY2Ugb2YgdXNiZ19jbWQqIGluDQphIHByZS1hbGxvY2F0ZWQgbWVtb3J5IHBvb2wuIEl0IG11
c3Qgbm90IGJlIGZyZWVkIHVudGlsIHVzYmdfY21kKg0KaXMgbm90IHVzZWQuDQoNCj4gU2lnbmVk
LW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3RjbS5jIHwgNiArKysrKysNCj4gIDEg
ZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9nYWRnZXQvZnVuY3Rpb24vZl90Y20uYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlv
bi9mX3RjbS5jDQo+IGluZGV4IGMxM2FhNjFkODJhYS4uZmEwOTk5OWFkZGE3IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vZl90Y20uYw0KPiArKysgYi9kcml2ZXJz
L3VzYi9nYWRnZXQvZnVuY3Rpb24vZl90Y20uYw0KPiBAQCAtNTcwLDYgKzU3MCw3IEBAIHN0YXRp
YyB2b2lkIHVhc3Bfc3RhdHVzX2RhdGFfY21wbChzdHJ1Y3QgdXNiX2VwICplcCwgc3RydWN0IHVz
Yl9yZXF1ZXN0ICpyZXEpDQo+ICAgICAgICAgc3RydWN0IHVzYmdfY21kICpjbWQgPSByZXEtPmNv
bnRleHQ7DQo+ICAgICAgICAgc3RydWN0IHVhc19zdHJlYW0gKnN0cmVhbSA9IGNtZC0+c3RyZWFt
Ow0KPiAgICAgICAgIHN0cnVjdCBmX3VhcyAqZnUgPSBjbWQtPmZ1Ow0KPiArICAgICAgIHN0cnVj
dCBzZV9zZXNzaW9uICpzZV9zZXNzID0gY21kLT5zZV9jbWQuc2Vfc2VzczsNCj4gICAgICAgICBp
bnQgcmV0Ow0KPiANCj4gICAgICAgICBpZiAocmVxLT5zdGF0dXMgPT0gLUVTSFVURE9XTikNCj4g
QEAgLTYwMyw2ICs2MDQsOCBAQCBzdGF0aWMgdm9pZCB1YXNwX3N0YXR1c19kYXRhX2NtcGwoc3Ry
dWN0IHVzYl9lcCAqZXAsIHN0cnVjdCB1c2JfcmVxdWVzdCAqcmVxKQ0KPiAgICAgICAgICAgICAg
ICAgYnJlYWs7DQo+IA0KPiAgICAgICAgIGNhc2UgVUFTUF9RVUVVRV9DT01NQU5EOg0KPiArDQo+
ICsgICAgICAgICAgICAgICB0YXJnZXRfZnJlZV90YWcoc2Vfc2VzcywgJmNtZC0+c2VfY21kKTsN
Cj4gICAgICAgICAgICAgICAgIHRyYW5zcG9ydF9nZW5lcmljX2ZyZWVfY21kKCZjbWQtPnNlX2Nt
ZCwgMCk7DQo+ICAgICAgICAgICAgICAgICB1c2JfZXBfcXVldWUoZnUtPmVwX2NtZCwgY21kLT5y
ZXEsIEdGUF9BVE9NSUMpOw0KPiANCj4gQEAgLTYxNCw2ICs2MTcsNyBAQCBzdGF0aWMgdm9pZCB1
YXNwX3N0YXR1c19kYXRhX2NtcGwoc3RydWN0IHVzYl9lcCAqZXAsIHN0cnVjdCB1c2JfcmVxdWVz
dCAqcmVxKQ0KPiAgICAgICAgIHJldHVybjsNCj4gDQo+ICBjbGVhbnVwOg0KPiArICAgICAgIHRh
cmdldF9mcmVlX3RhZyhzZV9zZXNzLCAmY21kLT5zZV9jbWQpOw0KPiAgICAgICAgIHRyYW5zcG9y
dF9nZW5lcmljX2ZyZWVfY21kKCZjbWQtPnNlX2NtZCwgMCk7DQo+ICB9DQo+IA0KPiBAQCAtOTQx
LDYgKzk0NSw3IEBAIHN0YXRpYyB2b2lkIHVzYmdfZGF0YV93cml0ZV9jbXBsKHN0cnVjdCB1c2Jf
ZXAgKmVwLCBzdHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkNCj4gICAgICAgICBzdHJ1Y3Qgc2VfY21k
ICpzZV9jbWQgPSAmY21kLT5zZV9jbWQ7DQo+IA0KPiAgICAgICAgIGlmIChyZXEtPnN0YXR1cyA9
PSAtRVNIVVRET1dOKSB7DQo+ICsgICAgICAgICAgICAgICB0YXJnZXRfZnJlZV90YWcoc2VfY21k
LT5zZV9zZXNzLCBzZV9jbWQpOw0KPiAgICAgICAgICAgICAgICAgdHJhbnNwb3J0X2dlbmVyaWNf
ZnJlZV9jbWQoJmNtZC0+c2VfY21kLCAwKTsNCj4gICAgICAgICAgICAgICAgIHJldHVybjsNCj4g
ICAgICAgICB9DQo+IEBAIC05NjMsNiArOTY4LDcgQEAgc3RhdGljIHZvaWQgdXNiZ19kYXRhX3dy
aXRlX2NtcGwoc3RydWN0IHVzYl9lcCAqZXAsIHN0cnVjdCB1c2JfcmVxdWVzdCAqcmVxKQ0KPiAg
Y2xlYW51cDoNCj4gICAgICAgICAvKiBDb21tYW5kIHdhcyBhYm9ydGVkICovDQo+ICAgICAgICAg
aWYgKGNtZC0+c3RhdGUgPT0gVUFTUF9RVUVVRV9DT01NQU5EKSB7DQo+ICsgICAgICAgICAgICAg
ICB0YXJnZXRfZnJlZV90YWcoc2VfY21kLT5zZV9zZXNzLCBzZV9jbWQpOw0KPiAgICAgICAgICAg
ICAgICAgdHJhbnNwb3J0X2dlbmVyaWNfZnJlZV9jbWQoc2VfY21kLCAwKTsNCj4gICAgICAgICAg
ICAgICAgIHJldHVybjsNCj4gICAgICAgICB9DQoNCg==
