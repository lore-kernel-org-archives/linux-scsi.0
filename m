Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106F4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52B12068E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="o8c0FPcp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgFOHYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:24:09 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:46402 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728368AbgFOHYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:24:09 -0400
X-UUID: 76efff77d7964554ab7924da97e32582-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qBTmmysW9mKb6RFIDfIeX1e+1dXzsBfF2+qumyv3dGk=;
        b=o8c0FPcpuBDXKePFQOGk+QKCHcz4v/jOU34m+VhL7h6DVFLkcvEozZ2PeDQj2ZpDet6LHAUl/Bfuw/tfDoOvprX9Qmj+zh6lEAtMCJuQdePNol5ZvD78uT1SeCRnmLNK7n3zW/hOWNBJ0USkzTDU01rY/SevStDsR8aJyg8Z/vg=;
X-UUID: 76efff77d7964554ab7924da97e32582-20200615
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1253782035; Mon, 15 Jun 2020 15:24:05 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 15:24:03 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 15:24:02 +0800
Message-ID: <1592205843.25636.82.camel@mtkswgap22>
Subject: RE: [PATCH v2 2/2] scsi: ufs: Add trace event for UIC commands
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Date:   Mon, 15 Jun 2020 15:24:03 +0800
In-Reply-To: <SN6PR04MB46400CE00A5CAF16CE4D4367FC9C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200615064753.20935-1-stanley.chu@mediatek.com>
         <20200615064753.20935-3-stanley.chu@mediatek.com>
         <SN6PR04MB46400CE00A5CAF16CE4D4367FC9C0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: CCA224B35034D6AA6CDD7520EB7BDB9D9CA9E88F74510A9DD30EC7E85C9088CB2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gTW9uLCAyMDIwLTA2LTE1IGF0IDA3OjEzICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiAgICAgICAgIC8qIFdyaXRlIFVJQyBDbWQgKi8NCj4gPiAgICAgICAgIHVm
c2hjZF93cml0ZWwoaGJhLCB1aWNfY21kLT5jb21tYW5kICYgQ09NTUFORF9PUENPREVfTUFTSywN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgUkVHX1VJQ19DT01NQU5EKTsNCj4gPiBAQCAtNDgy
NSwxMSArNDg0NywxNSBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX3VpY19jbWRfY29tcGwo
c3RydWN0DQo+ID4gdWZzX2hiYSAqaGJhLCB1MzIgaW50cl9zdGF0dXMpDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgdWZzaGNkX2dldF91aWNfY21kX3Jlc3VsdChoYmEpOw0KPiA+ICAgICAg
ICAgICAgICAgICBoYmEtPmFjdGl2ZV91aWNfY21kLT5hcmd1bWVudDMgPQ0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgIHVmc2hjZF9nZXRfZG1lX2F0dHJfdmFsKGhiYSk7DQo+ID4gKyAgICAg
ICAgICAgICAgIHVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCBoYmEtPmFjdGl2ZV91
aWNfY21kLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICJjb21wbGV0ZSIpOw0KPiA+ICAgICAgICAgICAgICAgICBjb21wbGV0ZSgmaGJhLT5hY3RpdmVf
dWljX2NtZC0+ZG9uZSk7DQo+ID4gICAgICAgICAgICAgICAgIHJldHZhbCA9IElSUV9IQU5ETEVE
Ow0KPiA+ICAgICAgICAgfQ0KPiA+IA0KPiA+ICAgICAgICAgaWYgKChpbnRyX3N0YXR1cyAmIFVG
U0hDRF9VSUNfUFdSX01BU0spICYmIGhiYS0+dWljX2FzeW5jX2RvbmUpIHsNCj4gPiArICAgICAg
ICAgICAgICAgdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFjZShoYmEsIGhiYS0+YWN0aXZlX3Vp
Y19jbWQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ImNvbXBsZXRlIik7DQo+ID4gICAgICAgICAgICAgICAgIGNvbXBsZXRlKGhiYS0+dWljX2FzeW5j
X2RvbmUpOw0KPiA+ICAgICAgICAgICAgICAgICByZXR2YWwgPSBJUlFfSEFORExFRDsNCj4gDQo+
IA0KPiBXaHkgbm90IGNhbGwgdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFjZSBvbmNlIGlmIHJl
dHZhbCA9PSBJUlFfSEFORExFRD8NCj4gSXMgaXQgdGhhdCB0aGUgZXhhY3QgdGltZXN0YW1wPw0K
DQpUaGFua3MhIFRoaXMgbWFrZXMgdGhlIGNvZGUgY2xlYW5lci4NCkZpeGVkIGluIHYzLg0KDQpT
dGFubGV5IENodQ0K

