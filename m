Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F87C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3108320722
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dAaHRELa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHCJoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 05:44:24 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:41323 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725968AbgHCJoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 05:44:23 -0400
X-UUID: 3ac428711cf848909e39cce4385870c7-20200803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZhKk3+aYfBtmyDfjmtzRdC9n/uCOzIpf/GjJwiyB4Og=;
        b=dAaHRELah656k8mrFCHfIOihZ5+eBWflnkiktZdcDtNO+x/0h7R+gzMEyhQleGlB4XIhuxUMxJTZMXOxC1Hpm00CQst2EuxseGTHesvJ0uK8waLOXZbXikTFlD9os4UmsNevcFm33nCXMclVjk/c2sFB0dnT+WLlqN2KwuUV7ik=;
X-UUID: 3ac428711cf848909e39cce4385870c7-20200803
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1170194191; Mon, 03 Aug 2020 17:44:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 3 Aug 2020 17:44:15 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas08.mediatek.inc
 (172.21.101.126) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug
 2020 17:44:15 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 3 Aug 2020 17:44:15 +0800
Message-ID: <1596447857.32283.24.camel@mtkswgap22>
Subject: Re: [PATCH v9 9/9] scsi: ufs: Properly release resources if a task
 is aborted successfully
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 3 Aug 2020 17:44:17 +0800
In-Reply-To: <1596445485-19834-10-git-send-email-cang@codeaurora.org>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
         <1596445485-19834-10-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTA4LTAzIGF0IDAyOjA0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBJbiBj
dXJyZW50IFVGUyB0YXNrIGFib3J0IGhvb2ssIG5hbWVseSB1ZnNoY2RfYWJvcnQoKSwgaWYgYSB0
YXNrIGlzDQo+IGFib3J0ZWQgc3VjY2Vzc2Z1bGx5LCBjbG9jayBzY2FsaW5nIGJ1c3kgdGltZSBz
dGF0aXN0aWNzIGlzIG5vdCB1cGRhdGVkDQo+IGFuZCwgbW9zdCBpbXBvcnRhbnQsIGNsa19nYXRp
bmcuYWN0aXZlX3JlcXMgaXMgbm90IGRlY3JlYXNlZCwgd2hpY2ggbWFrZXMNCj4gY2xrX2dhdGlu
Zy5hY3RpdmVfcmVxcyBzdGF5IGFib3ZlIHplcm8gZm9yZXZlciwgdGh1cyBjbG9jayBnYXRpbmcg
d291bGQNCj4gbmV2ZXIgaGFwcGVuLiBUbyBmaXggaXQsIGluc3RlYWQgb2YgcmVsZWFzaW5nIHJl
c291cmNlcyAibWFubnVhbGx5IiwgdXNlDQo+IHRoZSBleGlzdGluZyBmdW5jIF9fdWZzaGNkX3Ry
YW5zZmVyX3JlcV9jb21wbCgpLiBUaGlzIGNhbiBhbHNvIGVsaW1pbmF0ZQ0KPiByYWNpbmcgb2Yg
c2NzaV9kbWFfdW5tYXAoKSBmcm9tIHRoZSByZWFsIGNvbXBsZXRpb24gaW4gSVJRIGhhbmRsZXIg
cGF0aC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+
DQo+IENDOiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA1ICstLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXgg
ZDdkMjc1OC4uOWE0ODM4OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC02NjM1LDExICs2NjM1
LDggQEAgc3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KPiAg
CQlnb3RvIG91dDsNCj4gIAl9DQo+ICANCj4gLQlzY3NpX2RtYV91bm1hcChjbWQpOw0KPiAtDQo+
ICAJc3Bpbl9sb2NrX2lycXNhdmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+IC0JdWZzaGNk
X291dHN0YW5kaW5nX3JlcV9jbGVhcihoYmEsIHRhZyk7DQo+IC0JaGJhLT5scmJbdGFnXS5jbWQg
PSBOVUxMOw0KPiArCV9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbChoYmEsICgxVUwgPDwgdGFn
KSk7DQo+ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsN
Cj4gIA0KPiAgb3V0Og0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1l
ZGlhdGVrLmNvbT4NCg0KDQo=

