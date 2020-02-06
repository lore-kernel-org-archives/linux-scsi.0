Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DE5C35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 00:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 559FE20658
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 00:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RnmR3066"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBFA4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 19:56:11 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47123 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727149AbgBFA4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 19:56:11 -0500
X-UUID: f9d453bfefe44ec99df06b74cc22569c-20200206
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=goe3nKLi654rij3M3c+foadwHfpv05lQ2O5yWyHBAbE=;
        b=RnmR3066tx6Vq++SAYfh/6z9iPLRA66CqrybBeilcYCFapZmcEWqnCE44vrTRl6YXeXBptAzoBsM+AEgDfiuOfmCvb/r6qDjoAyvZU+gFSmKEFdpc01MWHjh67ktJm7WjVwu+TpeEndWGVfplnvJbuHVPLpaFQtmXEwFmvJtOZo=;
X-UUID: f9d453bfefe44ec99df06b74cc22569c-20200206
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1246544321; Thu, 06 Feb 2020 08:56:04 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 6 Feb 2020 08:54:26 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 6 Feb 2020 08:55:30 +0800
Message-ID: <1580950556.27391.11.camel@mtksdccf07>
Subject: Re: [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <kuohong.wang@mediatek.com>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 6 Feb 2020 08:55:56 +0800
In-Reply-To: <d37515ab264b0c46848ee2b88ba0a676@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
         <1580721472-10784-7-git-send-email-cang@codeaurora.org>
         <1580871040.21785.7.camel@mtksdccf07>
         <d37515ab264b0c46848ee2b88ba0a676@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDItMDUgYXQgMTI6NTIgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQoNCg0KPiBIaSBTdGFubGV5LA0KPiANCj4gV2UgdXNlZCB0byBhc2sgdmVuZG9ycyBhYm91
dCBpdCwgNTAgaXMgc29tZWhvdyBhZ3JlZWQgYnkgdGhlbS4gRG8geW91IA0KPiBoYXZlIGENCj4g
YmV0dGVyIHZhbHVlIGluIG1pbmQ/DQo+IA0KPiBGb3IgbWUsIEkganVzdCB3YW50ZWQgdG8gZ2l2
ZSBpdCAxMCwgc28gdGhhdCB3ZSBjYW4gZGlyZWN0bHkgdXNlIA0KPiB1c2xlZXBfcmFuZ2UNCj4g
d2l0aCBpdCwgbm8gbmVlZCB0byBkZWNpZGUgd2hldGhlciB0byB1c2UgdWRlbGF5IG9yIHVzbGVl
cF9yYW5nZS4NCg0KQWN0dWFsbHkgSSBkbyBub3QgaGF2ZSBhbnkgdmFsdWUgaW4gbWluZCBiZWNh
dXNlIEkgZ3Vlc3MgdGhlIDUwdXMgaGVyZQ0KaXMganVzdCBhIG1hcmdpbiB0aW1lIGFkZGVkIGZv
ciBzYWZldHkgYXMgeW91ciBjb21tZW50czogIkdpdmUgaXQgbW9yZQ0KdGltZSB0byBiZSBvbiB0
aGUgc2FmZSBzaWRlIi4NCg0KQW4gZXhhbXBsZSBjYXNlIGlzIHRoYXQgc29tZSB2ZW5kb3JzIG9u
bHkgc3BlY2lmeSAxdXMgaW4NCmJSZWZDbGtHYXRpbmdXYWl0VGltZSwgc28gdGhpcyA1MHVzIG1h
eSBiZSB0b28gbG9uZyBjb21wYXJlZCB0byBkZXZpY2Uncw0KcmVxdWlyZW1lbnQuIElmIHN1Y2gg
ZGV2aWNlIHJlYWxseSBuZWVkcyB0aGlzIGFkZGl0aW9uYWwgNTB1cywgaXQgc2hhbGwNCmJlIHNw
ZWNpZmllZCBpbiBiUmVmQ2xrR2F0aW5nV2FpdFRpbWUuDQoNClNvIGlmIHRoaXMgYWRkaXRpb25h
bCBkZWxheSBkb2VzIG5vdCBoYXZlIGFueSBzcGVjaWFsIHJlYXNvbiBvciBub3QNCm1lbnRpb25l
ZCBieSBVRlMgc3BlY2lmaWNhdGlvbiwgd291bGQgeW91IGNvbnNpZGVyIG1vdmUgaXQgdG8gdmVu
ZG9yDQpzcGVjaWZpYyBpbXBsZW1lbnRhdGlvbnMuIEJ5IHRoaXMgd2F5LCBpdCB3b3VsZCBiZSBt
b3JlIGZsZXhpYmxlIHRvIGJlDQpjb250cm9sbGVkIGJ5IHZlbmRvcnMgb3IgYnkgcGxhdGZvcm1z
Lg0KDQpUaGFua3MsDQpTdGFubGV5DQoNCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCj4gDQo+
ID4+ICAJCQkJICAgICAgJmRldl9pbmZvLT5tb2RlbCwgU0RfQVNDSUlfU1REKTsNCg0K

