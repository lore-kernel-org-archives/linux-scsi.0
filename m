Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E00FC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97BC21D80
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WRgfEzll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgIJCuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:50:08 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:44830 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730483AbgIJCsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:48:17 -0400
X-UUID: 448029e51310475492f2cf0a0116796d-20200910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=TGqc1+zgYwYtjPwGXOLfmyB55si+JzeFkKZj3cqjM3o=;
        b=WRgfEzllMtgZPJpNyqVGY44Xle8BOAZIdAgVyxdRr3vsVhd2LN4ln6Wq0gZqGyaGQ3fY5sgKRwYnoonllfA1uJmDT5Or6m5tud5KHgF4UhNU1hVxB2Ck6iBf/cwLkBf0dWXVRWx+6p2+hu+l5gV1NNIhHeRi1Nxyc+bAYZRiOgc=;
X-UUID: 448029e51310475492f2cf0a0116796d-20200910
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1663720026; Thu, 10 Sep 2020 10:48:08 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Sep 2020 10:48:00 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Sep 2020 10:48:00 +0800
Message-ID: <1599706080.10649.30.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Can Guo <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <ziqichen@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 10 Sep 2020 10:48:00 +0800
In-Reply-To: <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
         <1599627906.10803.65.camel@linux.ibm.com>
         <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: C95A5FF5A81532B7594C3EEBC793AF7F2BFEA205FC1420AA08019861A81DF8022000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCBDYW4sDQoNCk9uIFdlZCwgMjAyMC0wOS0wOSBhdCAyMjozMiAtMDQwMCwgTWFy
dGluIEsuIFBldGVyc2VuIHdyb3RlOg0KPiBDYW4gYW5kIFN0YW5sZXksDQo+IA0KPiA+IEkgY2Fu
J3QgcmVjb25jaWxlIHRoaXMgaHVuazoNCj4gDQo+IFBsZWFzZSBwcm92aWRlIGEgcmVzb2x1dGlv
biBmb3IgdGhlc2UgY29uZmxpY3RpbmcgY29tbWl0cyBpbiBmaXhlcyBhbmQNCj4gcXVldWU6DQo+
IA0KPiAzMDczNDhmNmFiMTQgc2NzaTogdWZzOiBBYm9ydCB0YXNrcyBiZWZvcmUgY2xlYXJpbmcg
dGhlbSBmcm9tIGRvb3JiZWxsDQo+IA0KPiBiMTAxNzhlZTdmYTggc2NzaTogdWZzOiBDbGVhbiB1
cCBjb21wbGV0ZWQgcmVxdWVzdCB3aXRob3V0IGludGVycnVwdA0KPiBub3RpZmljYXRpb24NCj4g
DQoNCkNhbidzIHBhdGNoIGhhcyBjb25zaWRlcmVkIG15IGZpeCBpbiB0aGUgbmV3IGZsb3cuDQoN
ClRvIGJlIG1vcmUgY2xlYXIsIGZvciB0aGUgZml4aW5nIGNhc2UgaW4gbXkgcGF0Y2gsDQp1ZnNo
Y2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSB3aWxsIHJldHVybiAwIChlcnIgPSAwKSBhbmQgZmluYWxs
eSB0aGUNCnRhcmdldCB0YWcgY2FuIGJlIGNvbXBsZXRlZCBhbmQgY2xlYXJlZCBieSBfX3Vmc2hj
ZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KaW4gQ2FuJ3MgbmV3IGZsb3cuDQoNClRodXMgSSB0aGlu
ayB0aGUgcmVzb2x1dGlvbiBjYW4ganVzdCB1c2luZyB0aGUgY29kZSBpbiBDYW4ncyBwYXRjaC4N
Cg0KQ2FuLCBwbGVhc2UgY29ycmVjdCBtZSBpZiBJIHdhcyB3cm9uZy4NCg0KVGhhbmtzLA0KU3Rh
bmxleSBDaHUNCg0KDQo+IFRoYW5rcyENCj4gDQoNCg==

