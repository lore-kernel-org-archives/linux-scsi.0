Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC1FC33C99
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 13:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A082207FD
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 13:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JMy7lr1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgAENKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 08:10:10 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:23514 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726029AbgAENKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 08:10:10 -0500
X-UUID: 2394d427c6804b14913ac7bb2bd70246-20200105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=FILJcOCG2sGK9VzTixRtMJdMzeT4XRTUIkt6/bNT4+4=;
        b=JMy7lr1A8KGvf71DVhfIAv9ELTKHAViKU7IGdjHKtUWqSGVWaaZ18T316oPaqaUGcA25TJ5+Fqh8OwQR8iIVW/qzkwUDr26B0ZRFo02S9BVBPXbM7y0JAdBeWbriogN9HRBzxCRx9uNKLB9jrm1kDdYQrYzISCYz5qAVZKvWHVU=;
X-UUID: 2394d427c6804b14913ac7bb2bd70246-20200105
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 347406739; Sun, 05 Jan 2020 21:10:04 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 5 Jan 2020 21:09:10 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 5 Jan 2020 21:08:35 +0800
Message-ID: <1578229802.17435.3.camel@mtkswgap22>
Subject: Re: [PATCH v1 0/3] scsi: ufs: pass device information to
 apply_dev_quirks
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Date:   Sun, 5 Jan 2020 21:10:02 +0800
In-Reply-To: <MN2PR04MB69913F0B671032A388747CF7FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
         <MN2PR04MB69913F0B671032A388747CF7FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXZyaSwNCg0KT24gU3VuLCAyMDIwLTAxLTA1IGF0IDA1OjUxICswMDAwLCBBdnJpIEFsdG1h
biB3cm90ZToNCj4gWW91IGhhdmUgdG8gc3F1YXNoIHBhdGNoIDEgJiAyLCBvdGhlcndpc2UgeW91
ciBwYXRjaCAxIHdvbid0IGNvbXBpbGUuDQo+IE90aGVyIHRoYW4gdGhhdDogbG9va3MgZ29vZCB0
byBtZS4NCj4gVGhhbmtzLA0KPiBBdnJpDQoNClNvcnJ5IGJlY2F1c2UgSSBzZW50IDIgc2VyaWVz
IGluIHRoZXNlIHR3byBkYXlzLg0KDQpXb3VsZCB5b3UgbWVhbiBwYXRjaCAxIGlzIHNlcmllczog
InNjc2k6IHVmczogZml4IGVycm9yIGhpc3RvcnkgYW5kDQpjb21wbGV0ZSBkZXZpY2UgcmVzZXQg
aGlzdG9yeSIgYW5kIHBhdGNoIDIgaXMgc2VyaWVzICJzY3NpOiB1ZnM6IHBhc3MNCmRldmljZSBp
bmZvcm1hdGlvbiB0byBhcHBseV9kZXZfcXVpcmtzIj8NCg0KT3IgcGF0Y2ggMSAmIDIgbWVhbiB0
aGUgZmlyc3QgMiBjb21taXRzIGluIHRoaXMgc2VyaWVzOiAic2NzaTogdWZzOiBwYXNzDQpkZXZp
Y2UgaW5mb3JtYXRpb24gdG8gYXBwbHlfZGV2X3F1aXJrcyI/DQoNClRoYW5rcyBhIGxvdC4NClN0
YW5sZXkNCg==

