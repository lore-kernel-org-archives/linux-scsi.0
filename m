Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097CAC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D21610A1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhFIGbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 02:31:17 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:46717 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232540AbhFIGbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 02:31:16 -0400
X-UUID: 0ec36225b39041c9bd8a7a58752ab499-20210609
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Ugb0gksaWQTXvj7JEDeIVT8vyKFync0MevCXBf1HNQ4=;
        b=pugBeaT/2QI3zXrsbkdlw+TzGhFuFemwyz14r5rQSn5y8u0vFbvz33/Ck7TODFH3wieKl2OjjF+4k2sFOVrms/8P9VxNqHpRYAwo6x5TRNkgO641j3t4tDBS+pYixRMeY6iRNh/4fZdS6koaN9MXZ4bQtFHTZtm+B+S8v2cuUvM=;
X-UUID: 0ec36225b39041c9bd8a7a58752ab499-20210609
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 468066029; Wed, 09 Jun 2021 14:29:18 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 9 Jun 2021 14:29:17 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 14:29:17 +0800
Message-ID: <1623220157.11234.0.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Fix a possible use before initialization case
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@qti.qualcomm.com>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <cang@codeaurora.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 9 Jun 2021 14:29:17 +0800
In-Reply-To: <1623209820-37840-1-git-send-email-cang@qti.qualcomm.com>
References: <1623209820-37840-1-git-send-email-cang@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIxLTA2LTA4IGF0IDIwOjM2IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBJbiB1
ZnNoY2RfZXhlY19kZXZfY21kKCksIGlmIGVycm9yIGhhcHBlbnMgYmVmb3JlIGxycGIgaXMgaW5p
dGlhbGl6ZWQsDQo+IHRoZW4gd2Ugc2hvdWxkIGJhaWwgb3V0IGluc3RlYWQgb2YgbGV0dGluZyB0
cmFjZSByZWNvcmQgdGhlIGVycm9yLg0KPiANCj4gRml4ZXM6IGE0NWY5MzcxMTBmYTYgKCJzY3Np
OiB1ZnM6IE9wdGltaXplIGhvc3QgbG9jayBvbiB0cmFuc2ZlciByZXF1ZXN0cyBzZW5kL2NvbXBs
IHBhdGhzIikNCj4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQHF0aS5xdWFsY29tbS5jb20+DQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCj4gaW5kZXggZmUxYjVmNC4uMGQ1NGFiNyAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQo+IEBAIC0yOTcyLDcgKzI5NzIsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9leGVjX2Rldl9jbWQo
c3RydWN0IHVmc19oYmEgKmhiYSwNCj4gIA0KPiAgCWlmICh1bmxpa2VseSh0ZXN0X2JpdCh0YWcs
ICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSkgew0KPiAgCQllcnIgPSAtRUJVU1k7DQo+IC0JCWdv
dG8gb3V0Ow0KPiArCQlnb3RvIG91dF9wdXRfdGFnOw0KPiAgCX0NCj4gIA0KPiAgCWluaXRfY29t
cGxldGlvbigmd2FpdCk7DQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KDQo=

