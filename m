Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70EDC3524F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBDC2086A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iDRbNGK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgBDG0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:26:49 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:50605 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgBDG0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 01:26:48 -0500
X-UUID: 7ce065c3d11b4886a76b72796f1fec38-20200204
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xndwTL4/66nj3QLaUJlq5dI4bc2P0qhopLek7BTz9Ls=;
        b=iDRbNGK/6rPeAiEP02iFSh4hs7U2aLYjhbVawwocytcZQoq+9nmvw9aH/e91mul8K3HbFccW+wO5gbi2qxoIQBCAAONafGUhLxT3H1wBZt+YILo1tI1lECX6/XxgK/EdM1vJn/akd5scUp04bqlvvwEDxeWeC3yJcCSaq0jHVI0=;
X-UUID: 7ce065c3d11b4886a76b72796f1fec38-20200204
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2040104297; Tue, 04 Feb 2020 14:26:45 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 4 Feb 2020 14:26:41 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Feb
 2020 14:26:20 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 4 Feb 2020 14:26:20 +0800
Message-ID: <1580797600.21785.3.camel@mtksdccf07>
Subject: Re: [PATCH v5 5/8] scsi: ufs: Fix ufshcd_hold() caused scheduling
 while atomic
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 4 Feb 2020 14:26:40 +0800
In-Reply-To: <1580721472-10784-6-git-send-email-cang@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
         <1580721472-10784-6-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
X-TM-SNTS-SMTP: DFEC84D42425D5F92FFAE10CD9A3F484BC1DAD7117266E3141EEEC5A085DFDAB2000:8
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTAyLTAzIGF0IDAxOjE3IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBUaGUg
YXN5bmMgdmVyc2lvbiBvZiB1ZnNoY2RfaG9sZChhc3luYyA9PSB0cnVlKSwgd2hpY2ggaXMgb25s
eSBjYWxsZWQNCj4gaW4gcXVldWVjb21tYW5kIHBhdGggYXMgZm9yIG5vdywgaXMgZXhwZWN0ZWQg
dG8gd29yayBpbiBhdG9taWMgY29udGV4dCwNCj4gdGh1cyBpdCBzaG91bGQgbm90IHNsZWVwIG9y
IHNjaGVkdWxlIG91dC4gV2hlbiBpdCBydW5zIGludG8gdGhlIGNvbmRpdGlvbg0KPiB0aGF0IGNs
b2NrcyBhcmUgT04gYnV0IGxpbmsgaXMgc3RpbGwgaW4gaGliZXJuOCBzdGF0ZSwgaXQgc2hvdWxk
IGJhaWwgb3V0DQo+IHdpdGhvdXQgZmx1c2hpbmcgdGhlIGNsb2NrIHVuZ2F0ZSB3b3JrLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCj4gUmV2aWV3
ZWQtYnk6IEhvbmd3dSBTdSA8aG9uZ3d1c0Bjb2RlYXVyb3JhLm9yZz4NCj4gUmV2aWV3ZWQtYnk6
IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg==

