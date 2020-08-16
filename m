Return-Path: <SRS0=wEW2=B2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24D6C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C2120708
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mEhHsVis"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgHPBy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:54:59 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:7195 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726029AbgHPBy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2020 21:54:59 -0400
X-UUID: a88aec36c69d42a0858241179003e869-20200816
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5WQE4hm6uoTkhZXy+ZrZXgVLjPUWq85sbjRvsVgzz3Q=;
        b=mEhHsVisNpDbDgwMZ1JwdOzQq2W08jpb8BaWSWg5FtLUXB82B7IyWdlOSq3MMSjE6dnnJsxG5m0mKW4cd+YEg7Achq6NEMGSr7TQmRlSog0oRRwizQ3mUejIHBurGm7a/qGxYlU2AYZJ/JZtua0OlmAMk4Vr3wA6d7FN/rJ5PPI=;
X-UUID: a88aec36c69d42a0858241179003e869-20200816
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1037489703; Sun, 16 Aug 2020 09:54:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 16 Aug 2020 09:54:53 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 16 Aug
 2020 09:54:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 16 Aug 2020 09:54:52 +0800
Message-ID: <1597542893.7483.3.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/2] scsi: ufs: no need to send one Abort Task TM in
 case the task in DB was cleared
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Sun, 16 Aug 2020 09:54:53 +0800
In-Reply-To: <20200811141859.27399-3-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
         <20200811141859.27399-3-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTA4LTExIGF0IDE2OjE4ICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IElmIHRoZSBiaXQgY29ycmVz
cG9uZHMgdG8gYSB0YXNrIGluIHRoZSBEb29yYmVsbCByZWdpc3RlciBoYXMgYmVlbg0KPiBjbGVh
cmVkLCBubyBuZWVkIHRvIHBvbGwgdGhlIHN0YXR1cyBvZiB0aGUgdGFzayBvbiB0aGUgZGV2aWNl
IHNpZGUNCj4gYW5kIHRvIHNlbmQgYW4gQWJvcnQgVGFzayBUTS4gSW5zdGVhZCwgbGV0IGl0IGRp
cmVjdGx5IGdvdG8gY2xlYW51cC4NCj4gDQo+IE1lYW53aGlsZSwgdG8ga2VlcCBvcmlnaW5hbCBk
ZWJ1ZyBwcmludCwgbW92ZSB0aGlzIGdvdG8gYmVsb3cgdGhlIGRlYnVnDQo+IHByaW50Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg==

