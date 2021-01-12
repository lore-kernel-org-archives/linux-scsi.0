Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC87C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5677523107
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbhALJg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:36:57 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:33057 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726211AbhALJg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:36:57 -0500
X-UUID: 5c86277b71ba40838df4e9af34201d29-20210112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Iu8lnmjN/TPe2FBwqAQYsax0J6qOLIwwrgKQk5YJHOg=;
        b=VKT6yj2cNfO9ljSkWFvDmKsvgQXy20VAalgAHc9Hm7xHcVabldaE2sYUxHJ91EtjO4o04XHM+aWSpNzseN/PrZRG0fdFg+jaAhMyPLm9WYyLzK29popoBTtD9xvKSJYGdICFGNnC23oMlwcRjprTF9p01AbM6E23iLLaZ1cShuE=;
X-UUID: 5c86277b71ba40838df4e9af34201d29-20210112
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1150739987; Tue, 12 Jan 2021 17:36:10 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 12 Jan 2021 17:36:09 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 17:36:09 +0800
Message-ID: <1610444169.17820.11.camel@mtkswgap22>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Satya Tangirala" <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Jan 2021 17:36:09 +0800
In-Reply-To: <1609595975-12219-3-git-send-email-cang@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDIxLTAxLTAyIGF0IDA1OjU5IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBVc2Vy
IGxheWVyIG1heSBhY2Nlc3Mgc3lzZnMgbm9kZXMgd2hlbiBzeXN0ZW0gUE0gb3BzIG9yIGVycm9y
IGhhbmRsaW5nDQo+IGlzIHJ1bm5pbmcsIHdoaWNoIGNhbiBjYXVzZSB2YXJpb3VzIHByb2JsZW1z
LiBSZW5hbWUgZWhfc2VtIHRvIGhvc3Rfc2VtDQo+IGFuZCB1c2UgaXQgdG8gcHJvdGVjdCBQTSBv
cHMgYW5kIGVycm9yIGhhbmRsaW5nIGZyb20gdXNlciBsYXllciBpbnRlcnZlbmUuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiANCg0KTG9va3Mg
Z29vZCB0byBtZS4NCg0KRmVlbCBmcmVlIHRvIGFkZA0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1
IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0K

