Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8C1C2D0E7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 08:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058D22070A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 08:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZSxbNEfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCZIRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 04:17:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:5186 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727682AbgCZIRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 04:17:19 -0400
X-UUID: 8c21512c61704ae4a13ac9883f90b28b-20200326
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=TUh0oyKKWlFuiaOE7fmc1z5kxisyWDAyryXR2g5CLqg=;
        b=ZSxbNEfk+E6+9b+mtfqZnBwGGFQR00xv7n/73tjl5DCwvKyO1JRIBr6Aump8Q3sEXInsOmEQcS/qgAaVLPVtys+A2IijjwDaQB1TrUSBaODJlCx1fCwPIJUqezfTVbGy39LRXUb5l/sa4PrPykaZdp5ED4GXAp89Tloed+Snjyo=;
X-UUID: 8c21512c61704ae4a13ac9883f90b28b-20200326
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1873759620; Thu, 26 Mar 2020 16:17:15 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 26 Mar 2020 16:17:13 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 26 Mar 2020 16:17:14 +0800
Message-ID: <1585210634.4609.1.camel@mtksdccf07>
Subject: Re: [PATCH v4 1/1] scsi: ufs: Enable block layer runtime PM for
 well-known logical units
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
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "open list" <linux-kernel@vger.kernel.org>
Date:   Thu, 26 Mar 2020 16:17:14 +0800
In-Reply-To: <1585185003-31156-1-git-send-email-cang@codeaurora.org>
References: <1585185003-31156-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBXZWQsIDIwMjAtMDMtMjUgYXQgMTg6MDkgLTA3MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEJsb2NrIGxheWVyIFJQTSBpcyBlbmFibGVkIGZvciB0aGUgZ2VuZXJuYWwgVUZTIFND
U0kgZGV2aWNlcyB3aGVuIHRoZXkgYXJlDQo+IHByb2JlZCBieSB0aGVpciBkcml2ZXIuIEhvd2V2
ZXIgYmxvY2sgbGF5ZXIgUlBNIGlzIG5vdCBlbmFibGVkIGZvciBVRlMNCj4gd2VsbC1rbm93biBT
Q1NJIGRldmljZXMuDQo+IA0KPiBBcyBVRlMgU0NTSSBkZXZpY2VzIGhhdmUgdGhlaXIgY29ycmVz
cG9uZGluZyBCU0cgY2hhciBkZXZpY2VzLCBhY2Nlc3NpbmcNCj4gYSBCU0cgY2hhciBkZXZpY2Ug
dmlhIElPQ1RMIG1heSBzZW5kIHJlcXVlc3RzIHRvIGl0cyBjb3JyZXNwb25kaW5nIFNDU0kNCj4g
ZGV2aWNlIHRocm91Z2ggaXRzIHJlcXVlc3QgcXVldWUuIElmIEJTRyBJT0NUTCBzZW5kcyBhIHJl
cXVlc3QgdG8gYQ0KPiB3ZWxsLWtub3duIFNDU0kgZGV2aWNlIHdoZW4gaGJhIGlzIG5vdCBydW50
aW1lIGFjdGl2ZSwgZHVlIHRvIGJsb2NrIGxheWVyDQo+IFJQTSBpcyBub3QgZWFuYmxlZCBmb3Ig
dGhlIHdlbGwta25vd24gU0NTSSBkZXZpY2VzLCBoYmEsIHdoaWNoIGlzIGF0IHRoZQ0KPiB0b3Ag
b2YgYSBzY3NpIGRldmljZSdzIHBhcmVudCBjaGFpbiwgc2hhbGwgbm90IGJlIHJlc3VtZWQsIHRo
ZW4gdW5leHBlY3RlZA0KPiBlcnJvciB3b3VsZCBoYXBwZW4uDQo+IA0KPiBUaGlzIGNoYW5nZSBl
bmFibGVzIGJsb2NrIGxheWVyIFJQTSBmb3IgdGhlIHdlbGwta25vd24gU0NTSSBkZXZpY2VzLCBz
bw0KPiB0aGF0IGJsb2NrIGxheWVyIGNhbiBoYW5kbGUgUlBNIGZvciB0aGUgd2VsbC1rbm93biBT
Q1NJIGRldmljZXMganVzdCBsaWtlDQo+IGZvciB0aGUgZ2VuZXJhbCBTQ1NJIGRldmljZXMuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiBSZXZp
ZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoNCkxvb2tzIGdvb2Qh
DQpUaGFua3MgdG8gbWFrZSBSUE0gZm9yIFVGUyBjb21wbGV0ZWQhDQoNClJldmlld2VkLWJ5OiBT
dGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

