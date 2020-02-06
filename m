Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1417C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7338120720
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="j3jX1pJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgBFHa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 02:30:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53043 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727904AbgBFHa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 02:30:59 -0500
X-UUID: cc3df51b3c784a85bb370feed4fd46fc-20200206
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=KE6yPm5qo2YLAPFxJE94fNiKdtvVGTGYh0XDXv5j1jE=;
        b=j3jX1pJQihdHrbyVMjUwxM1SiDm7atgjgpn2bKUtro4rrAZl9/OWQTNvqPofYrG9VK57aA8c9mmj5qrGZNgPxXLPyf9Bel8KkEIWQOSSEIL+3Htlb2WQhyEFcmg3fka4Gr7s/ZBYnDxIXC9a0V8M2yriJZGFIsrMAE9iXm1xN64=;
X-UUID: cc3df51b3c784a85bb370feed4fd46fc-20200206
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2009264483; Thu, 06 Feb 2020 15:30:51 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 6 Feb 2020 15:29:25 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 6 Feb 2020 15:30:15 +0800
Message-ID: <1580974242.27391.13.camel@mtksdccf07>
Subject: Re: [PATCH 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 6 Feb 2020 15:30:42 +0800
In-Reply-To: <1580972212-29881-7-git-send-email-cang@codeaurora.org>
References: <1580972212-29881-1-git-send-email-cang@codeaurora.org>
         <1580972212-29881-7-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 3AEE117141CC94A56CFD60B474E37A43AF73E67C31E646B4994A0389369BE3A02000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDItMDUgYXQgMjI6NTYgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEluIFVGUyB2ZXJzaW9uIDMuMCwgYSBuZXdseSBhZGRlZCBhdHRyaWJ1dGUgYlJlZkNs
a0dhdGluZ1dhaXRUaW1lIGRlZmluZXMNCj4gdGhlIG1pbmltdW0gdGltZSBmb3Igd2hpY2ggdGhl
IHJlZmVyZW5jZSBjbG9jayBpcyByZXF1aXJlZCBieSBkZXZpY2UgZHVyaW5nDQo+IHRyYW5zaXRp
b24gdG8gTFMtTU9ERSBvciBISUJFUk44IHN0YXRlLiBNYWtlIHRoaXMgY2hhbmdlIHRvIHJlZmxl
Y3QgdGhlIG5ldw0KPiByZXF1aXJlbWVudCBieSBhZGRpbmcgZGVsYXlzIGJlZm9yZSB0dXJuaW5n
IG9mZiB0aGUgY2xvY2suDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVh
dXJvcmEub3JnPg0KPiBSZXZpZXdlZC1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJv
cmEub3JnPg0KPiBSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCg0K
VGhhbmtzIGZvciB0aGUgZml4Lg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCg==

