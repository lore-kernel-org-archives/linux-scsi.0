Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AC8C33CA3
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 07:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1B620838
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 07:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ayGQqiUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgAJHIs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 02:08:48 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40974 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726186AbgAJHIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 02:08:48 -0500
X-UUID: 64689634770c4b26990c40d7a9859c1c-20200110
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ffhcrwjsBwsjrgzkid/yOQ1liD4E9HyfxuER96MEH2g=;
        b=ayGQqiUWEf6Ot02/A+ME7PCtwFS9rvCN3bTRfL5Ubp5cZC6itfr/vewvWrWfJlv4TTranHZvzva+GLM8V2yVLUcmvNhKFD47gN6joQoTzR/sLn2stuPzhKyaHM//434KpARA/T3FXhHRMdIB4lY+HI0yL1LHn78gVvHkIIKVBm0=;
X-UUID: 64689634770c4b26990c40d7a9859c1c-20200110
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 365668579; Fri, 10 Jan 2020 15:08:43 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 15:07:43 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 10 Jan 2020 15:07:04 +0800
Message-ID: <1578640121.17435.7.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <andy.teng@mediatek.com>,
        <jejb@linux.ibm.com>, <chun-hung.wu@mediatek.com>,
        <kuohong.wang@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <avri.altman@wdc.com>, <cang@codeaurora.org>,
        <linux-mediatek@lists.infradead.org>, <peter.wang@mediatek.com>,
        <alim.akhtar@samsung.com>, <matthias.bgg@gmail.com>,
        <asutoshd@codeaurora.org>, <bvanassche@acm.org>,
        <linux-arm-kernel@lists.infradead.org>, <beanhuo@micron.com>
Date:   Fri, 10 Jan 2020 15:08:41 +0800
In-Reply-To: <yq136cnx1yo.fsf@oracle.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
         <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
         <yq136cnx1yo.fsf@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLA0KDQpPbiBGcmksIDIwMjAtMDEtMTAgYXQgMDE6MjUgLTA1MDAsIE1hcnRpbiBL
LiBQZXRlcnNlbiB3cm90ZToNCj4gU3RhbmxleSwNCj4gDQo+ID4gUGFzcyBVRlMgZGV2aWNlIGlu
Zm9ybWF0aW9uIHRvIHZlbmRvci1zcGVjaWZpYyB2YXJpYW50IGNhbGxiYWNrDQo+ID4gImFwcGx5
X2Rldl9xdWlya3MiIGJlY2F1c2Ugc29tZSBwbGF0Zm9ybSB2ZW5kb3JzIG5lZWQgdG8ga25vdyBz
dWNoDQo+ID4gaW5mb3JtYXRpb24gdG8gYXBwbHkgc3BlY2lhbCBoYW5kbGluZ3Mgb3IgcXVpcmtz
IGluIHNwZWNpZmljIGRldmljZXMuDQo+IA0KPiBUaGlzIGRvZXNuJ3QgY29tcGlsZS4gWW91IG1p
c3NlZCBhZGRpbmcgdGhlIGFkZGl0aW9uYWwgYXJndW1lbnQgdG8gb25lDQo+IGNhbGxlciBvZiB1
ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKCkuDQo+IA0KDQpTb3JyeSBmb3IgdGhpcy4gSSdsbCBm
aXggaXQgaW4gbmV4dCB2ZXJzaW9uIGFuZCB0cnkgdG8gc2VwYXJhdGUgdmVuZG9yJ3MNCmltcGxl
bWVudGF0aW9uIGFuZCBjb21tb24gZHJpdmVyIHRvIGRpZmZlcmVudCBjb21taXRzIGlmIHRoaXMg
aXMgdGhlDQpyb290IGNhdXNlIG9mIGNvbXBpbGUgaXNzdWUuDQoNClRoYW5rcy4NClN0YW5sZXkN
Cg0K

