Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5213C47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE9CA613F0
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFCC4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 22:56:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54469 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229812AbhFCC4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 22:56:46 -0400
X-UUID: 144e700ae6a044128ab6d0af69907f6c-20210603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=pihTp1DwQK+HeV7mk+RNkiNU9/T3ejwlYv/tON4uSVU=;
        b=K8dISz8A3sCqVuZ7Dv3NqYr+YwmqdYVXSrdlzyJPC8LGmlZH7DX2UQZ7lvnBnFIMu95rYcjVPBJDyOIYrmi1DRO3y4xCR5HY+WujmZcYbExluZLTc5CDFr0I+uvGrYi4X/NQNgvm662hGVzuCB4AfSCGMF1g/BMAs1YQVeVxSco=;
X-UUID: 144e700ae6a044128ab6d0af69907f6c-20210603
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1431275690; Thu, 03 Jun 2021 10:55:00 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 10:54:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 10:54:59 +0800
Message-ID: <1622688899.7096.7.camel@mtkswgap22>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Utilize Transfer Request List
 Completion Notification Register
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Caleb Connolly <caleb@connolly.tech>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 3 Jun 2021 10:54:59 +0800
In-Reply-To: <1621845419-14194-4-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjEtMDUtMjQgYXQgMDE6MzYgLTA3MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEJ5IHJlYWRpbmcgdGhlIFVUUCBUcmFuc2ZlciBSZXF1ZXN0IExpc3QgQ29tcGxldGlv
biBOb3RpZmljYXRpb24gUmVnaXN0ZXIsDQo+IHdoaWNoIGlzIGFkZGVkIGluIFVGU0hDSSBWZXIg
My4wLCBTVyBjYW4gZWFzaWx5IGdldCB0aGUgY29tcGVsZXRlZCB0cmFuc2Zlcg0KPiByZXF1ZXN0
cy4gVGh1cywgU1cgY2FuIGdldCByaWQgb2YgaG9zdCBsb2NrLCB3aGljaCBpcyB1c2VkIHRvIHN5
bmNocm9uaXplDQo+IHRoZSB0cl9kb29yYmVsbCBhbmQgb3V0c3RhbmRpbmdfcmVxcywgb24gdHJh
bnNmZXIgcmVxdWVzdHMgZGlzcGF0Y2ggYW5kDQo+IGNvbXBsZXRpb24gcGF0aHMuIFRoaXMgY2Fu
IGZ1cnRoZXIgYmVuZWZpdCByYW5kb20gcmVhZC93cml0ZSBwZXJmb3JtYW5jZS4NCj4gDQo+IENj
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiBDby1kZXZlbG9wZWQt
Ynk6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCj4gU2lnbmVkLW9mZi1i
eTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJvcmEub3JnPg0KPiBTaWduZWQtb2ZmLWJ5
OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNpLmgNCj4gQEAgLTM5LDYgKzM5LDcgQEAgZW51bSB7DQo+ICAJUkVHX1VUUF9UUkFO
U0ZFUl9SRVFfRE9PUl9CRUxMCQk9IDB4NTgsDQo+ICAJUkVHX1VUUF9UUkFOU0ZFUl9SRVFfTElT
VF9DTEVBUgkJPSAweDVDLA0KPiAgCVJFR19VVFBfVFJBTlNGRVJfUkVRX0xJU1RfUlVOX1NUT1AJ
PSAweDYwLA0KPiArCVJFR19VVFBfVFJBTlNGRVJfUkVRX0xJU1RfQ09NUEwJCT0gMHg2NCwNCj4g
IAlSRUdfVVRQX1RBU0tfUkVRX0xJU1RfQkFTRV9MCQk9IDB4NzAsDQo+ICAJUkVHX1VUUF9UQVNL
X1JFUV9MSVNUX0JBU0VfSAkJPSAweDc0LA0KPiAgCVJFR19VVFBfVEFTS19SRVFfRE9PUl9CRUxM
CQk9IDB4NzgsDQoNCg==

