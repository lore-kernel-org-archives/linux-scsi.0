Return-Path: <SRS0=vSKu=3V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA08C35246
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 01:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3448E20707
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 01:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PnfObm0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBABpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jan 2020 20:45:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:43910 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726488AbgBABpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2020 20:45:24 -0500
X-UUID: 32a3becb29644f579ca0a4608131875e-20200201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bKHd1tAggSIYDv7JYfnCgulY1L3xWENBKRTIMPNCxIY=;
        b=PnfObm0NMA1GnJ3uWv5kD2RIpWjGCLw0RhHHAS7EUdh9M/+drlk5yzWbJ8nbi8SV4vlXxyQGqPjfvvMhInESy6rR72J75w7xsS9saOcdczd+4uByMN5/kXAOcH0eiofYmJyWg2HymZgit6t14xYKWMNte4H/Vj5nZ9lY65D/g6w=;
X-UUID: 32a3becb29644f579ca0a4608131875e-20200201
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1724066920; Sat, 01 Feb 2020 09:45:18 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 1 Feb 2020 09:44:04 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Feb 2020 09:44:11 +0800
Message-ID: <1580521516.15794.10.camel@mtksdccf07>
Subject: RE: [PATCH RESEND v3 4/4] scsi: ufs-mediatek: gate ref-clk during
 Auto-Hibern8
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Date:   Sat, 1 Feb 2020 09:45:16 +0800
In-Reply-To: <MN2PR04MB699108FC14777CC364522069FC070@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
         <20200129105251.12466-5-stanley.chu@mediatek.com>
         <MN2PR04MB699108FC14777CC364522069FC070@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 1F82E7DC4A3A53250291462851AFB1ACF9319A87D203BA06A9D76D33D8EF52862000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gRnJpLCAyMDIwLTAxLTMxIGF0IDE4OjQ4ICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gPiANCj4gPiArc3RhdGljIHUzMiB1ZnNfbXRrX2xpbmtfZ2V0X3N0YXRlKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4gK3sNCj4gPiArICAgICAgIHUzMiB2YWw7DQo+ID4gKw0K
PiA+ICsgICAgICAgdWZzaGNkX3dyaXRlbChoYmEsIDB4MjAsIFJFR19VRlNfREVCVUdfU0VMKTsN
Cj4gPiArICAgICAgIHZhbCA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VRlNfUFJPQkUpOw0KPiA+
ICsgICAgICAgdmFsID0gdmFsID4+IDI4Ow0KPiA+ICsNCj4gPiArICAgICAgIHJldHVybiB2YWw7
DQo+ID4gK30NCj4gQSBsaXR0bGUgYml0IHN0cmFuZ2UgdGhhdCB5b3UgYXJlIHJlbHlpbmcgb24g
ZGVidWcgcmVnaXN0ZXJzIHRvIHNldHVwIHlvdXIgcmVmLWNsb2NrLg0KPiBJcyB0aGlzIHRoaXMg
ZGVidWcgaW5mbyBpcyBhbHdheXMgYXZhaWxhYmxlPw0KPiANCg0KWWVzLCB0aGlzIHJlZ2lzdGVy
IGlzIG9ubHkgZm9yIHRoaXMgcHVycG9zZSBub3cgKHF1ZXJ5IGxpbmsgc3RhdGUpIGFuZA0KYWx3
YXlzIGV4aXN0ZWQgaW4gTWVkaWFUZWsgVUZTIGhvc3QuDQoNClRoYW5rcywNClN0YW5sZXkNCg==

