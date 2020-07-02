Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F29C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 05:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 213CA20656
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 05:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QGOBqJN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGBFKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 01:10:16 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:27366 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgGBFKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 01:10:16 -0400
X-UUID: a0e54661558e4756b76ab59eb346461c-20200702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=A8hKhr1jcLoaE2if7XGFXaCdA8hNzzcNVZOu2qoqs2A=;
        b=QGOBqJN/t5rJKDTJmpwnCxGOlsAkEgRCBO/CcLDP5hVu4AztWc2nKf/eewjzSPqzZXuhJCeotX8zLzJZUYx50a9ZUUIFv/4RzEkIHFgJMtTcX7AkBYzkd3xQjCKl4Pn2fx0atFpvkHB+D0C9kH/0rJMgoEGMYtl1qAKYy7Zu0v8=;
X-UUID: a0e54661558e4756b76ab59eb346461c-20200702
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 100274838; Thu, 02 Jul 2020 13:10:13 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 13:10:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 13:10:11 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 13:10:11 +0800
Message-ID: <1593666611.3278.10.camel@mtkswgap22>
Subject: Re: [RFC PATCH v2 1/2] ufs: introduce a callback to get info of
 command completion
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>
Date:   Thu, 2 Jul 2020 13:10:11 +0800
In-Reply-To: <cc9a0edf340931397c04303213ea0d54023708de.1593657314.git.kwmad.kim@samsung.com>
References: <cover.1593657314.git.kwmad.kim@samsung.com>
         <CGME20200702024558epcas2p38e61e50755728e18dadc9d9f08dabfbd@epcas2p3.samsung.com>
         <cc9a0edf340931397c04303213ea0d54023708de.1593657314.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTAyIGF0IDExOjM4ICswOTAwLCBLaXdvb25nIEtpbSB3cm90ZToNCj4g
U29tZSBTb0Mgc3BlY2lmaWMgbWlnaHQgbmVlZCBjb21tYW5kIGhpc3RvcnkgZm9yDQo+IHZhcmlv
dXMgcmVhc29ucywgc3VjaCBhcyBzdGFja2luZyBjb21tYW5kIGNvbnRleHRzDQo+IGluIHN5c3Rl
bSBtZW1vcnkgdG8gY2hlY2sgZm9yIGRlYnVnZ2luZyBpbiB0aGUgZnV0dXJlDQo+IG9yIHNjYWxp
bmcgc29tZSBEVkZTIGtub2JzIHRvIGJvb3N0IElPIHRocm91Z2hwdXQuDQo+IA0KPiBXaGF0IHlv
dSB3b3VsZCBkbyB3aXRoIHRoZSBpbmZvcm1hdGlvbiBjb3VsZCBiZQ0KPiB2YXJpYW50IHBlciBT
b0MgdmVuZG9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBz
YW1zdW5nLmNvbT4NCg0KQWNrZWQtQnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRl
ay5jb20+DQo=

