Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23DDC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD36F23A61
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLHFEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 00:04:54 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60799 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725818AbgLHFEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 00:04:54 -0500
X-UUID: a6b9dcc20eb941779a1d7cfc438dff54-20201208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Q5YMdW+RVysFqSQDkm41RS68yte9sKqTk6V/21Lw5YE=;
        b=dTLZrd8+8AlME65TTNBnKFG4Yw2ICKZvRNQSqTwru/Be5dgmGTwOb9fA7qoKPK23EZSGcS+CsKYxjS31ZwSiJdwI8YjrQXjKC7fDexeKOxNrrzZhoCsHNjAsYi53kzfJzp2j9Lyy9TuOjsjL483TwjKn1Gu0AB3xYcn+P+0u2Wc=;
X-UUID: a6b9dcc20eb941779a1d7cfc438dff54-20201208
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1569285706; Tue, 08 Dec 2020 13:04:11 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Dec 2020 13:04:06 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Dec 2020 13:04:05 +0800
Message-ID: <1607403850.3580.24.camel@mtkswgap22>
Subject: Re: [PATCH V7 0/3] Minor fixes to UFS error handling
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Can Guo <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>
Date:   Tue, 8 Dec 2020 13:04:10 +0800
In-Reply-To: <yq1mtyp19en.fsf@ca-mkp.ca.oracle.com>
References: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
         <yq1mtyp19en.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLA0KDQpPbiBNb24sIDIwMjAtMTItMDcgYXQgMTg6MzEgLTA1MDAsIE1hcnRpbiBL
LiBQZXRlcnNlbiB3cm90ZToNCj4gQ2FuLA0KPiANCj4gPiBUaGlzIHNlcmllcyBtYWlubHkgZml4
ZXMgYmVsb3cgdHdvIHRoaW5ncyB3aGljaCBjb21lIGFsb25nIHdpdGggVUZTIGVycm9yDQo+ID4g
aGFuZGxpbmcgaW4gc29tZSBjb3JuZXIgY2FzZXMuDQo+ID4gWzFdIENvbmN1cnJlbmN5IHByb2Js
ZW1zIGJ0dyBlcnJfaGFuZGxlciBhbmQgcGF0aHMgbGlrZSBzeXN0ZW0gc3VzcGVuZC9yZXN1bWUv
c2h1dGRvd24gYW5kIGFzeW5jIHNjYW4uDQo+ID4gWzJdIFJhY2UgY29uZGl0aW9uIGJ0dyBVRlMg
ZXJyb3IgcmVjb3ZlcnkgYW5kIHRhc2sgYWJvcnQgd2hpY2ggaGFwcGVucyB0byBXLUxVIGR1cmlu
ZyBzdXNwZW5kL3Jlc3VtZS9zaHV0ZG93bi4NCj4gDQo+IEFwcGxpZWQgdG8gNS4xMS9zY3NpLXN0
YWdpbmcsIHRoYW5rcyENCj4gDQo+IFN0YW5sZXk6IFBsZWFzZSB2ZXJpZnkgY29uZmxpY3QgcmVz
b2x1dGlvbiB3aXRoIHlvdXIgZXZlbnQgbm90aWZpY2F0aW9uDQo+IHNlcmllcy4NCg0KQ29uZmxp
Y3QgaXMgcmVzb2x2ZWQgcGVyZmVjdGx5IQ0KDQpUaGFua3MgZm9yIHlvdXIgdGltZSA6ICkNCg0K
U3RhbmxleSBDaHUNCg0K

