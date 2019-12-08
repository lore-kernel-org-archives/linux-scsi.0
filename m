Return-Path: <SRS0=ZYS2=Z6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D29C2D0BE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 05:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A6E20637
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 05:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Wx4Tj8Sk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbfLHFh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 00:37:29 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:5263 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbfLHFh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 00:37:29 -0500
X-UUID: 39f6db29e94645b79f77cc28ff30df5b-20191208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=JnqPU30kEl4+RpNJnlGsN4JNwgLzMQ4oKfpMLvPeckU=;
        b=Wx4Tj8SkDAmVgSADeTZy0I0iQMYfQUfD4ImYPfqwkxZId2c/djEFQMadPwSIHoHW/s5p3n92jMT4jml6TZGekZSeo5753Zminh/jgJuFvIP3GpDBYLp6/MJFwXetqWxAIejdQkEtNakgQn5z2FxgWKxVIyMmVzenZLSdYG1BLOI=;
X-UUID: 39f6db29e94645b79f77cc28ff30df5b-20191208
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 744958452; Sun, 08 Dec 2019 13:37:25 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 8 Dec 2019 13:37:00 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 8 Dec 2019 13:36:37 +0800
Message-ID: <1575783443.12066.1.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] soc: mediatek: add header for SiP service
 interface
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        Leon Chen =?UTF-8?Q?=28=E9=99=B3=E6=96=87=E9=8F=98=29?= 
        <Leon.Chen@mediatek.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Sun, 8 Dec 2019 13:37:23 +0800
In-Reply-To: <b3c568f1-d57b-f3f3-b1da-4b312c595fc8@gmail.com>
References: <1575700748-28191-1-git-send-email-stanley.chu@mediatek.com>
         <1575700748-28191-2-git-send-email-stanley.chu@mediatek.com>
         <b3c568f1-d57b-f3f3-b1da-4b312c595fc8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: ABB0BF249B6939E6F146B64C56060BDB722E71EF5051679CF21468003F6AF5F42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgRmxvcmlhbiwNCg0KT24gU3VuLCAyMDE5LTEyLTA4IGF0IDAxOjQwICswODAwLCBGbG9yaWFu
IEZhaW5lbGxpIHdyb3RlOg0KDQo+ID4gKyNpZmRlZiBDT05GSUdfQVJNNjQNCj4gPiArI2RlZmlu
ZSBNVEtfU0lQX1NNQ19BQVJDSF9CSVQgICAgICAgICAgIDB4NDAwMDAwMDANCj4gPiArI2Vsc2UN
Cj4gPiArI2RlZmluZSBNVEtfU0lQX1NNQ19BQVJDSF9CSVQgICAgICAgICAgIDB4MDAwMDAwMDAN
Cj4gPiArI2VuZGlmDQo+IA0KPiBDYW5ub3QgeW91IHVzZSB0aGUgZGVmaW5pdGlvbnMgZnJvbSBp
bmNsdWRlL2xpbnV4L2FybS1zbWNjYy5oIGFuZCB1c2UNCj4gQVJNX1NNQ0NDX0NBTExfQ09OVl9T
SElGVCBoZXJlIGFuZCBhc3NvY2lhdGVkIGhlbHBlcnM/DQo+IA0KPiA+ICsNCj4gPiArLyogVUZT
IHJlbGF0ZWQgU01DIGNhbGwgKi8NCj4gPiArI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MIFwN
Cj4gPiArCSgweDgyMDAwMjc2IHwgTVRLX1NJUF9TTUNfQUFSQ0hfQklUKQ0KPiANCj4gRG9lcyBi
aXQgMzEgbWFwIHRvIHRoZSBmYXN0IHZzLiBzbG93IGNhbGwgb2YgdGhlIEFSTSBTTUNDQyBjb252
ZW50aW9uIG9yDQo+IGRvZXMgaXQgaGF2ZSBhIGRpZmZlcmVudCBtZWFuaW5nIChzaG91bGQgbm90
KS4gTGlrZXdpc2UgYml0IDI1IHdvdWxkIGJlDQo+IEFSTV9TTU1DQ0NfT1dORVJfU0lQIG5vPw0K
PiANCj4gVGhhdCB3b3VsZCBsZWF2ZSB1cyB3aXRoIG9ubHkgMHgyNzYgd2hpY2ggaXMgYSB2YWxp
ZCBmdW5jdGlvbiBudW1iZXIuDQoNClRoYW5rcyBzbyBtdWNoIGZvciB0aGVzZSBjb21tZW50cy4N
CkknbGwgdHJ5IHRvIHVzZSBzdWl0YWJsZSBkZWZpbml0aW9ucyBpbnN0ZWFkIGluIG5leHQgdmVy
c2lvbi4NCg0KU3RhbmxleQ0KDQo=

