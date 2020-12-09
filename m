Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0F6C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 01:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC6A23B54
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 01:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgLIBHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 20:07:45 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38705 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgLIBHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 20:07:45 -0500
X-UUID: 8689fde0e57843adbb990debd1ee835d-20201209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WA0bjrG4z9ju8DMvpDZEhvn8BFPltLxS2hZ/ZtQOZk4=;
        b=cz7mgLrFQOZrJPekeA8FPwzLyfwNO49Tix0er+KiShbIG0jaoGplunSHw7bURvTxzymBerNdVUMPFkw028p9t/pkXlQ5zjVS9Ya50Kqeb/fW9HFQUc67TrBmd8unOhMBgMmsmqWmyglNsgw9gDx7SPaOnuB++7TIdM2rDbOSj1k=;
X-UUID: 8689fde0e57843adbb990debd1ee835d-20201209
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 573708763; Wed, 09 Dec 2020 09:06:54 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 09:06:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Dec 2020 09:06:48 +0800
Message-ID: <1607476012.3580.26.camel@mtkswgap22>
Subject: Re: [PATCH v2] scsi: ufs: clear uac for RPMB after ufshcd resets
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <cang@codeaurora.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <bvanassche@acm.org>, <martin.petersen@oracle.com>,
        Randall Huang <huangrandall@google.com>,
        Leo Liou <leoliou@google.com>
Date:   Wed, 9 Dec 2020 09:06:52 +0800
In-Reply-To: <X8/1U8+Dd3UJjKA/@google.com>
References: <20201201041402.3860525-1-jaegeuk@kernel.org>
         <X8/1U8+Dd3UJjKA/@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTA4IGF0IDEzOjUxIC0wODAwLCBKYWVnZXVrIEtpbSB3cm90ZToNCj4g
RnJvbSA5MDJlMzEzZjBkN2NjZjVlMjQ0OTFjMmJhZGM2ZGMxNzNjZTM1ZmIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBSYW5kYWxsIEh1YW5nIDxodWFuZ3JhbmRhbGxAZ29vZ2xl
LmNvbT4NCj4gRGF0ZTogVHVlLCAyNCBOb3YgMjAyMCAxNToyOTo1OCArMDgwMA0KPiBTdWJqZWN0
OiBbUEFUQ0hdIHNjc2k6IHVmczogY2xlYXIgdWFjIGZvciBSUE1CIGFmdGVyIHVmc2hjZCByZXNl
dHMNCj4gDQo+IElmIFJQTUIgaXMgbm90IHByb3Zpc2lvbmVkLCB3ZSBtYXkgc2VlIFJQTUIgZmFp
bHVyZSBhZnRlciBVRlMgc3VzcGVuZC9yZXN1bWUuDQo+IEluamVjdCByZXF1ZXN0X3NlbnNlIHRv
IGNsZWFyIHVhYyBpbiB1ZnNoY2QgcmVzZXQgZmxvdy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJh
bmRhbGwgSHVhbmcgPGh1YW5ncmFuZGFsbEBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBM
ZW8gTGlvdSA8bGVvbGlvdUBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYWVnZXVrIEtp
bSA8amFlZ2V1a0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

