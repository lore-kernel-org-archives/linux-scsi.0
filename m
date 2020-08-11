Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F38C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 00:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8005520782
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 00:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CS2HqMyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgHKA7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 20:59:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:46585 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725969AbgHKA7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 20:59:34 -0400
X-UUID: 6deb9e530c33457ba713ce97576cf806-20200811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=eZHjFiyiASXULkWhdzej/uAPq7dIxSthynfU0WX6dbY=;
        b=CS2HqMyZ58vnncmc2j6KDoYhzHy8lDOOjRa+pFAyhV7qClp0mr5jBAE5ZL2GLdgqCEx9vz8inR/OudU28T9IWtfP+jH7ChDah2mtVQFI2lDi6HN4kpFr+/v6BN+DS4nKh+kIUBIdJOPWlMTgQzHuYWe7sttPdxJY7nIVXiWeMiA=;
X-UUID: 6deb9e530c33457ba713ce97576cf806-20200811
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1793720629; Tue, 11 Aug 2020 08:59:31 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 11 Aug 2020 08:59:30 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 11 Aug 2020 08:59:30 +0800
Message-ID: <1597107570.19734.1.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs-pci: Add quirk for broken auto-hibernate for
 Intel EHL
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>
Date:   Tue, 11 Aug 2020 08:59:30 +0800
In-Reply-To: <20200810141024.28859-1-adrian.hunter@intel.com>
References: <20200810141024.28859-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 807553FE94D3A074998F4239A4885CD394BF796EA04DC6264A1F8E27538C89122000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTA4LTEwIGF0IDE3OjEwICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBJbnRlbCBFSEwgVUZTIGhvc3QgY29udHJvbGxlciBhZHZlcnRpc2VzIGF1dG8taGliZXJuYXRl
IGNhcGFiaWxpdHkgYnV0IGl0DQo+IGRvZXMgbm90IHdvcmsgY29ycmVjdGx5LiBBZGQgYSBxdWly
ayBmb3IgdGhhdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkcmlhbiBIdW50ZXIgPGFkcmlhbi5o
dW50ZXJAaW50ZWwuY29tPg0KPiBGaXhlczogOGMwOWQ3NTI3Njk3MSAoInNjc2k6IHVmc2hkYy1w
Y2k6IEFkZCBJbnRlbCBQQ0kgSURzIGZvciBFSEwiKQ0KPiAtLS0NCg0KQWNrZWQtYnk6IFN0YW5s
ZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0KDQoNCg0K

