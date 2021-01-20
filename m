Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F17C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 13:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008A223381
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 13:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbhATNTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 08:19:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43064 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730545AbhATNPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 08:15:39 -0500
X-UUID: 60b6bc89ec734d91a51602aa5828f7ed-20210120
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rAYd+FVMlgcEIg6UoFBMR9Wnpjlgxf5lFnSG19N+XHc=;
        b=P7MQuR1SzsJcin6KCNB0dBFf9KcIlWWKDx21pwaCyoDlkJM1MSUhshSPTgwTuVeCN+3+pHBTqsTvPCfrzGTxQ5qhJ+/86oDJBLPKCDyrhXkDLQLdA5BIxHVgppi+IAfhBLRSgF1LM20uHmh5b41g69NS4TCsJEsphUJ2P4RrE9o=;
X-UUID: 60b6bc89ec734d91a51602aa5828f7ed-20210120
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 299025821; Wed, 20 Jan 2021 21:14:33 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 21:14:32 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Jan 2021 21:14:31 +0800
Message-ID: <1611148472.1261.6.camel@mtkswgap22>
Subject: Re: [PATCH v11 1/3] scsi: ufs: Protect some contexts from
 unexpected clock scaling
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Satya Tangirala" <satyat@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 20 Jan 2021 21:14:32 +0800
In-Reply-To: <1611137065-14266-2-git-send-email-cang@codeaurora.org>
References: <1611137065-14266-1-git-send-email-cang@codeaurora.org>
         <1611137065-14266-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIxLTAxLTIwIGF0IDAyOjA0IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBJbiBj
b250ZXh0cyBsaWtlIHN1c3BlbmQsIHNodXRkb3duIGFuZCBlcnJvciBoYW5kbGluZywgd2UgbmVl
ZCB0byBzdXNwZW5kDQo+IGRldmZyZXEgdG8gbWFrZSBzdXJlIHRoZXNlIGNvbnRleHRzIHdvbid0
IGJlIGRpc3R1cmJlZCBieSBjbG9jayBzY2FsaW5nLg0KPiBIb3dldmVyLCBzdXNwZW5kaW5nIGRl
dmZyZXEgaXMgbm90IGVub3VnaCBzaW5jZSB1c2VycyBjYW4gc3RpbGwgdHJpZ2dlciBhDQo+IGNs
b2NrIHNjYWxpbmcgYnkgbWFuaXB1bGF0aW5nIHRoZSBkZXZmcmVxIHN5c2ZzIG5vZGVzIGxpa2Ug
bWluL21heF9mcmVxIGFuZA0KPiBnb3Zlcm5vciBldmVuIGFmdGVyIGRldmZyZXEgaXMgc3VzcGVu
ZGVkLiBNb3Jlb3ZlciwgbWVyZSBzdXNwZW5kaW5nIGRldmZyZXENCj4gY2Fubm90IHN5bmNocm9p
bnplIGEgY2xvY2sgc2NhbGluZyB3aGljaCBoYXMgYWxyZWFkeSBiZWVuIGludm9rZWQgdGhyb3Vn
aA0KPiB0aGVzZSBzeXNmcyBub2Rlcy4gQWRkIG9uZSBtb3JlIGZsYWcgaW4gc3RydWN0IGNsa19z
Y2FsaW5nIGFuZCB3cmFwIHRoZQ0KPiBlbnRpcmUgZnVuYyB1ZnNoY2RfZGV2ZnJlcV9zY2FsZSgp
IHdpdGggdGhlIGNsa19zY2FsaW5nX2xvY2ssIHNvIHRoYXQgd2UNCj4gY2FuIHVzZSB0aGlzIGZs
YWcgYW5kIGNsa19zY2FsaW5nX2xvY2sgdG8gY29udHJvbCBhbmQgc3luY2hyb25pemUgY2xvY2sN
Cj4gc2NhbGluZyBpbnZva2VkIHRocm91Z2ggZGV2ZnJlcSBzeXNmcyBub2Rlcy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNClJldmlld2VkLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

