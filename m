Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB309C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 14:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7638A22B2A
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 14:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgLTOKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 09:10:48 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56032 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726751AbgLTOKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 09:10:48 -0500
X-UUID: 8a4f1b41e08b49dcbc0bb46e66520857-20201220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9INxK3G/ANihjUO6Tfm86dtf3DKTzfm6jVNVTXEY5XM=;
        b=TvzshIaocTWoS09acA4ppNDtqAkYblbOSjwvJhQ9FtCiyADfP4lcjVQqSrHygWNrLjrGgmFc2nPgtbDh6dP/QwxEYXUugoVp9Pm6WOS6rLFMf91Gbkgd5I5fPypHx0kYXYkrR5a/i+weLvVaHj8TwF3pkWpcyuPWD59STiRt8WY=;
X-UUID: 8a4f1b41e08b49dcbc0bb46e66520857-20201220
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1492412766; Sun, 20 Dec 2020 22:10:00 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 22:09:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 20 Dec 2020 22:09:56 +0800
Message-ID: <1608473398.10163.41.camel@mtkswgap22>
Subject: Re: [RFC PATCH v1] ufs: relocate flush of exceptional event
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
Date:   Sun, 20 Dec 2020 22:09:58 +0800
In-Reply-To: <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b@epcas2p4.samsung.com>
         <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDIwLTEyLTE5IGF0IDE1OjQwICswOTAwLCBLaXdvb25nIEtpbSB3cm90ZToNCj4g
SSBmb3VuZCBvbmUgY2FzZSBhcyBmb2xsb3dzIGFuZCB0aGUgY3VycmVudCBmbHVzaA0KPiBsb2Nh
dGlvbiBkb2Vzbid0IGd1YXJhbnRlZSBkaXNhYmxpbmcgQktPUFMgaW4gdGhlDQo+IGNhc2Ugb2Yg
cmVxdXN0aW5nIGRldmljZSBwb3dlciBvZmYuDQo+IDEpIFRoZSBleGNlcHRpb25hbCBldmVudCBo
YW5kbGVyIGlzIHF1ZXVlZC4NCj4gMikgdWZzIHN1c3BlbmQgc3RhcnRzIHdpdGggYSByZXF1ZXN0
IG9mIGRldmljZSBwb3dlciBvZmYNCj4gMykgQktPUFMgaXMgZGlzYWJsZWQgaW4gdWZzIHN1c3Bl
bmQNCj4gNCkgVGhlIHF1ZXVlZCB3b3JrIGZvciB0aGUgaGFuZGxlciBpcyBkb25lIGFuZCBCS09Q
Uw0KPiBpcyBlbmFibGVkIGFnYWluLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0g
PGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFu
bGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0K

