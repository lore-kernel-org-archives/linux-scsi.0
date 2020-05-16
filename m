Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8340C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 13:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F40206D8
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 13:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NVN2Tpyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgEPNX5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 09:23:57 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:40548 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726245AbgEPNX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 09:23:56 -0400
X-UUID: df400191c4d84be68061ff4a332682b3-20200516
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=RurzsbN02/QUThs3HzT434TYi503FodH5xCpi40Zuwg=;
        b=NVN2Tpyj4BFLmptqRCllGgtTPU7Fcclj1cdb/rZ1mSXXkgWcpO1UgrGCmXC7JGVorFn7ikxb8c8GR4rBPaAudWLxOC+19xaagZSyHUWqaRHETqBf+gxA3brAoLz2vlSxxcWn5U+0yeI1q+otmagqEgm9bRR+nM1tcQFE1vx117k=;
X-UUID: df400191c4d84be68061ff4a332682b3-20200516
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 389630958; Sat, 16 May 2020 21:23:53 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 16 May 2020 21:23:50 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 16 May 2020 21:23:50 +0800
Message-ID: <1589635432.3197.115.camel@mtkswgap22>
Subject: Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep instead
 of busy-waiting
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Date:   Sat, 16 May 2020 21:23:52 +0800
In-Reply-To: <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
References: <20200507222750.19113-1-bvanassche@acm.org>
         <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
         <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gRnJpLCAyMDIwLTA1LTE1IGF0IDEyOjI4IC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDUtMDggMDk6MjcsIEFzdXRvc2ggRGFzIChhc2QpIHdy
b3RlOg0KPiA+IE9uIDUvNy8yMDIwIDM6MjcgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4g
Pj4gVGhlIHVmc2hjZF93YWl0X2Zvcl9yZWdpc3RlcigpIGZ1bmN0aW9uIGVpdGhlciBzbGVlcHMg
b3Igc3BpbnMgdW50aWwgdGhlDQo+ID4+IHNwZWNpZmllZCByZWdpc3RlciBoYXMgcmVhY2hlZCB0
aGUgZGVzaXJlZCB2YWx1ZS4gQnVzeS13YWl0aW5nIGlzIG5vdA0KPiA+PiBvbmx5IGNvbnNpZGVy
ZWQgYSBiYWQgcHJhY3RpY2UgYnV0IGFsc28gaGFzIGEgYmFkIGltcGFjdCBvbiBlbmVyZ3kNCj4g
Pj4gY29uc3VtcHRpb24uIEFsd2F5cyBzbGVlcCBpbnN0ZWFkIG9mIHNwaW5uaW5nIGJ5IG1ha2lu
ZyBzdXJlIHRoYXQgYWxsDQo+ID4+IHVmc2hjZF93YWl0X2Zvcl9yZWdpc3RlcigpIGNhbGxzIGhh
cHBlbiBmcm9tIGEgY29udGV4dCB3aGVyZSBpdCBpcw0KPiA+PiBhbGxvd2VkIHRvIHNsZWVwLiBU
aGUgb25seSBmdW5jdGlvbiBjYWxsIHRoYXQgaGFzIHRvIGJlIG1vdmVkIGlzIHRoZQ0KPiA+PiB1
ZnNoY2RfaGJhX3N0b3AoKSBjYWxsIGluIHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9yZXN0b3JlKCku
DQo+ID4+DQo+ID4+IENjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiA+PiBDYzog
QXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+ID4+IENjOiBCZWFuIEh1byA8YmVh
bmh1b0BtaWNyb24uY29tPg0KPiA+PiBDYzogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1
bmcuY29tPg0KPiA+PiBDYzogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJvcmEub3JnPg0K
PiA+PiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4N
Cg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoN
Cg==

