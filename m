Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C353AC388F7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 01:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C53A20715
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 01:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JMxCjwlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgKEBm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 20:42:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45785 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725862AbgKEBm7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 20:42:59 -0500
X-UUID: 1bef8b12dd4d435b9108f60879640ac5-20201105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DQeeK3y6tT8rfnIb28bW7sTSRBJVhBxclVvnAe9p7dA=;
        b=JMxCjwlOT7WseV/P4NVAv5GezKM/lthZkwoJj4G+cXmA1UJhmhTl4rgvwOgMRziJBjmdBjgKHRwW7eh5gi6d2TD5LB3ueOeitVY7jiJJLs0DqvZcD+J/AsindgOh8FjAch+0RbHXOT8QPKXnGoZbyhy7U5g87cL1DSoY176tYos=;
X-UUID: 1bef8b12dd4d435b9108f60879640ac5-20201105
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 159934362; Thu, 05 Nov 2020 09:42:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 5 Nov 2020 09:42:46 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 09:42:46 +0800
Message-ID: <1604540566.13152.16.camel@mtkswgap22>
Subject: Re: [PATCH V4 1/2] scsi: ufs: Add DeepSleep feature
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>, Bean Huo <huobean@gmail.com>,
        Can Guo <cang@codeaurora.org>
Date:   Thu, 5 Nov 2020 09:42:46 +0800
In-Reply-To: <20201103141403.2142-2-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
         <20201103141403.2142-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTExLTAzIGF0IDE2OjE0ICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBEZWVwU2xlZXAgaXMgYSBVRlMgdjMuMSBmZWF0dXJlIHRoYXQgYWNoaWV2ZXMgdGhlIGxvd2Vz
dCBwb3dlciBjb25zdW1wdGlvbg0KPiBvZiB0aGUgZGV2aWNlLCBhcGFydCBmcm9tIHBvd2VyIG9m
Zi4NCj4gDQo+IEluIERlZXBTbGVlcCBtb2RlLCBubyBjb21tYW5kcyBhcmUgYWNjZXB0ZWQsIGFu
ZCB0aGUgb25seSB3YXkgdG8gZXhpdCBpcw0KPiB1c2luZyBhIGhhcmR3YXJlIHJlc2V0IG9yIHBv
d2VyIGN5Y2xlLg0KPiANCj4gVGhpcyBwYXRjaCBhc3N1bWVzIHRoYXQgaWYgYSBwb3dlciBjeWNs
ZSB3YXMgYW4gb3B0aW9uLCB0aGVuIHBvd2VyIG9mZg0KPiB3b3VsZCBiZSBwcmVmZXJhYmxlLCBz
byBvbmx5IGV4aXQgdmlhIGEgaGFyZHdhcmUgcmVzZXQgaXMgc3VwcG9ydGVkLg0KPiANCj4gRHJp
dmVycyB0aGF0IHdpc2ggdG8gc3VwcG9ydCBEZWVwU2xlZXAgbmVlZCB0byBzZXQgYSBuZXcgY2Fw
YWJpbGl0eSBmbGFnDQo+IFVGU0hDRF9DQVBfREVFUFNMRUVQIGFuZCBwcm92aWRlIGEgaGFyZHdh
cmUgcmVzZXQgdmlhIHRoZSBleGlzdGluZw0KPiAgLT5kZXZpY2VfcmVzZXQoKSBjYWxsYmFjay4N
Cj4gDQo+IEl0IGlzIGFzc3VtZWQgdGhhdCBVRlMgZGV2aWNlcyB3aXRoIHdzcGVjdmVyc2lvbiA+
PSAweDMxMCBzdXBwb3J0DQo+IERlZXBTbGVlcC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkcmlh
biBIdW50ZXIgPGFkcmlhbi5odW50ZXJAaW50ZWwuY29tPg0KDQpSZXZpZXdlZC1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQo=

