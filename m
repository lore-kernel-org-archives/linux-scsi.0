Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F83C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 01:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB65227BF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 01:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qcUct+bD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLTBZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 20:25:27 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:18949 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727006AbfLTBZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 20:25:27 -0500
X-UUID: 92f579cd67114b839355644f6e6d3d63-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6G3dtw5AJylg2abavZ7E0QIWsi21fn4ZfWIqnuXqxBM=;
        b=qcUct+bDYeVS1aaDJcL6m6qACEsT2L7zyOsMEz+hx9bn+mGHjFgZjnrGiFi7NNGRjSrAKdyGvyjkqcpLH/rd3n21mHWONU5YYQz4x2mzccQGJEEIk8pms+mCMtX2CFpwRZRf8Pc6dqujWB3Mr7Kha3JUXOGmv+F2mRzBI+EQ2V8=;
X-UUID: 92f579cd67114b839355644f6e6d3d63-20191220
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 646347533; Fri, 20 Dec 2019 09:25:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 09:24:45 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 09:25:18 +0800
Message-ID: <1576805118.13056.31.camel@mtkswgap22>
Subject: Re: [PATCH v1 0/4] scsi: ufs-mediatek: provide power management
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <andy.teng@mediatek.com>,
        <jejb@linux.ibm.com>, <chun-hung.wu@mediatek.com>,
        <kuohong.wang@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <avri.altman@wdc.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <alim.akhtar@samsung.com>,
        <matthias.bgg@gmail.com>, <pedrom.sousa@synopsys.com>,
        <linux-arm-kernel@lists.infradead.org>, <beanhuo@micron.com>
Date:   Fri, 20 Dec 2019 09:25:18 +0800
In-Reply-To: <yq1tv5vc3ci.fsf@oracle.com>
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
         <yq1tv5vc3ci.fsf@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: A67BF4AF579820BA1BD2EC944F6F15F073CC96FDD18A0D00DFAB356298EA55922000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLA0KDQpUaGFuayB5b3Ugc28gbXVjaCBhbmQgc29ycnkgZm9yIHlvdXIgaW5jb252
ZW5pZW5jZS4NCg0KSSB3YXMgYmFzZWQgb24gdGhlIGxhdGVzdCBsaW51eC1uZXh0IGNvbW1pdCBp
biBteSBzdWJtaXNzaW9uIHRpbWUuIEkNCndpbGwgYmUgbW9yZSBjYXJlZnVsIGFuZCB1c2UgeW91
ciAicXVldWUiIGJyYW5jaCBpbnN0ZWFkIGZvciBzdWJtaXNzaW9uLg0KDQpCVFcsIHNvcnJ5IGFn
YWluIGJlY2F1c2UgdGhpcyBzZXJpZXMgYWN0dWFsbHkgcmVxdWlyZSBhIGhlYWRlciBmaWxlDQpw
cmVzZW50IGJ5IGJlbG93IHBhdGNoIGluIGFub3RoZXIgc2VyaWVzIHdoaWNoIHdhcyBzdWJtaXR0
ZWQgZWFybGllcg0KdGhhbiB0aGlzIHNlcmllcywNCg0KInNvYzogbWVkaWF0ZWs6IGFkZCBoZWFk
ZXIgZm9yIFNpUCBzZXJ2aWNlIGludGVyZmFjZSINCg0KT3RoZXJ3aXNlIG1pc3NpbmcgaGVhZGVy
ICJpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oIiB3aWxsDQpjYXVzZSBi
dWlsZCBlcnJvciBpZiBNZWRpYVRlayBVRlMgZHJpdmVyIGlzIGVuYWJsZWQuDQoNCkhvcGUgInNv
YzogbWVkaWF0ZWs6IGFkZCBoZWFkZXIgZm9yIFNpUCBzZXJ2aWNlIGludGVyZmFjZSIgY291bGQg
YmUNCm1lcmdlZCBzb29uLCBvciBwbGVhc2Ugcm9sbGJhY2sgdGhpcyBzZXJpZXMgZmlyc3QgaWYg
YnVpbGQgZXJyb3IgaGFwcGVucw0KYW5kIHdhaXQgdW50aWwgYWJvdmUgcGF0Y2ggaXMgbWVyZ2Vk
Lg0KDQpUbyBwcmV2ZW50IHRoaXMgZXJyb3IsIEkgc2hhbGwgbWVyZ2UgYm90aCBzZXJpZXMgYW5k
IHByb3ZpZGUgYSBuZXcNCmNvbWJpbmVkIHNlcmllcy4gSWYgeW91IHdhbnQgbWUgdG8gZG8gc28s
IHBsZWFzZSBraW5kbHkgbGV0IG1lIGtub3cuDQpTb3JyeSBmb3IgdGhpcyBhZ2Fpbi4NCg0KT24g
VGh1LCAyMDE5LTEyLTE5IGF0IDE4OjE3IC0wNTAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6
DQo+IFN0YW5sZXksDQo+IA0KPiA+IFRoZSBwYXRjaCBzZXQgcHJvdmlkZXMgcG93ZXIgbWFuYWdl
bWVudCBvbiBNZWRpYVRlayBDaGlwc2V0cyBieQ0KPiANCj4gSGFkIHRvIGFwcGx5IHRoaXMgYnkg
aGFuZC4gUGxlYXNlIG1ha2Ugc3VyZSB5b3UgcHJlcGFyZSBwYXRjaA0KPiBzdWJtaXNzaW9ucyBh
Z2FpbnN0IG15ICJxdWV1ZSIgYnJhbmNoLg0KPiANCg0KVGhhbmtzLA0KU3RhbmxleQ0KDQoNCg==

