Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB06C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009BB2078C
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="a4C80QRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgFJOoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 10:44:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:23678 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726801AbgFJOoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 10:44:03 -0400
X-UUID: bc7378ef58ec4a11abf96cb28e4f560e-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=07Z7MmVgrHfi2H+JSAP6qzcbOEwmhFuc4sUjT1yUldQ=;
        b=a4C80QRyYVf8lwiZ9/bGl9Z5GO7GlatD+Kpbays0OnXwm3PvCwBTHv5AH+LZ3JTfRhb3ZOKWxhYpVE9cYbftc85h+s8zedtYMBTDY44M+/IAMqXRP5OhblGtVfm+TpLxwljm5h+KlzySFyhGYN7AovdIMG1xnsBn9Tj3NbZQ2qk=;
X-UUID: bc7378ef58ec4a11abf96cb28e4f560e-20200610
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 26017537; Wed, 10 Jun 2020 22:43:59 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 10 Jun 2020 22:43:55 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 22:43:55 +0800
Message-ID: <1591800237.25636.33.camel@mtkswgap22>
Subject: RE: [PATCH v2] scsi: ufs: Fix imprecise time in devfreq window
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Wed, 10 Jun 2020 22:43:57 +0800
In-Reply-To: <SN6PR04MB46404C13248B105082BFE8E3FC830@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200609154035.1950-1-stanley.chu@mediatek.com>
         <SN6PR04MB46404C13248B105082BFE8E3FC830@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gV2VkLCAyMDIwLTA2LTEwIGF0IDExOjQzICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gSGkgU3RhbmxleSwNCj4gDQo+ID4gDQo+ID4gDQo+ID4gUHJvbWlzZSBwcmVj
aXNpb24gb2YgZGV2ZnJlcSB3aW5kb3dzIGJ5DQo+IFByb21pc2UgLT4gZ3VhcmFudGVlIC8gYXNz
dXJlIC8gdmVyaWZ5IHRoYXQgdGhlPw0KPiBDYW4geW91IHBsZWFzZSBhbHNvIGVsYWJvcmF0ZSB3
aHkgdGhlIGN1cnJlbnQgd2luZG93IGlzbid0IGFjY3VyYXRlIGVub3VnaD8NCj4gQW5kIGFkZCBh
IGZpeGVzIHRhZz8NCg0KT0shIEkgd2lsbCBmaXggYWxsIG9mIHRoZW0gaW4gbmV4dCB2ZXJzaW9u
Lg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0K

