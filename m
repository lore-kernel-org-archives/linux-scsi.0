Return-Path: <SRS0=wEW2=B2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ED4C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E817D2068E
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nLOeaU1x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgHPBB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:01:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:21921 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726177AbgHPBB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2020 21:01:27 -0400
X-UUID: 260dc3c3a6254acdb5b53560ea00401f-20200816
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=enWqZWxvZprgK2P17HZjxRJ//LO5boAVzAX+gXM/CZ8=;
        b=nLOeaU1xXlrPXDztzniImhcBXwkaqttH2gaeyQi7E0Puc9Ulyimd4cwjMYXucDpDUh/UfhM1fTjcqECRHxdwAs9fhPXUvkO28y0TxEAD0ShyGxTolWtsLj3Tm02f2gU8eaY+3hFqrFNfkPniO8lZ2CTQxUhJly9xz0ktDZT6IyY=;
X-UUID: 260dc3c3a6254acdb5b53560ea00401f-20200816
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1517930685; Sun, 16 Aug 2020 09:01:23 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 16 Aug 2020 09:01:20 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 16 Aug 2020 09:01:20 +0800
Message-ID: <1597539680.7483.1.camel@mtkswgap22>
Subject: Re: [PATCH v3 1/2] scsi: ufs: change ufshcd_comp_devman_upiu() to
 ufshcd_compose_devman_upiu()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Sun, 16 Aug 2020 09:01:20 +0800
In-Reply-To: <20200814095034.20709-2-huobean@gmail.com>
References: <20200814095034.20709-1-huobean@gmail.com>
         <20200814095034.20709-2-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: BE5561C9627A85C7D95F4CCD228B02614F34083724DAA7C132890BF0765094472000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIwLTA4LTE0IGF0IDExOjUwICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IHVmc2hjZF9jb21wX2Rldm1h
bl91cGl1KCkgYWx3YXN5IG1ha2UgbWUgY29uZnVzZSB0aGF0IGl0IGlzIGEgcmVxdWVzdA0KPiBj
b21wbGV0aW9uIGNhbGxpbmcgZnVuY3Rpb24uIENoYW5nZSBpdCB0byB1ZnNoY2RfY29tcG9zZV9k
ZXZtYW5fdXBpdSgpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWlj
cm9uLmNvbT4NCj4gQWNrZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
PiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5j
b20+DQoNCg0K

