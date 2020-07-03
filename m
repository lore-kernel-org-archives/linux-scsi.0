Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC20C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 06:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AB82075D
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 06:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ujTaLW6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgGCGAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 02:00:02 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:45226 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725648AbgGCGAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 02:00:02 -0400
X-UUID: ab5cc45f06c84ea6bfa5c3fc60903647-20200703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=XFRMUht807YSIAvJ5pzoMzvbR8F12q9KH5zChfGQD3w=;
        b=ujTaLW6VIoFIar72p6tMqtA87CqR0K93ckl72jnNgaUx9VSsmkyr7p222sE1tXIF7QcPf5VHJ9CxKF1KkkfMSpLdWkkdsAAquC3IZpgXNUrECc1L7JLmnpmTwiKeTe79uUCAFkw2F6NDuCV7yUNbnt9FqyEEEttEIH1/Pl8phgo=;
X-UUID: ab5cc45f06c84ea6bfa5c3fc60903647-20200703
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 954593965; Fri, 03 Jul 2020 13:59:59 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkexhb01.mediatek.inc (172.21.101.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 3 Jul 2020 13:59:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 13:59:52 +0800
Message-ID: <1593755992.3278.14.camel@mtkswgap22>
Subject: Re: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of
 command completion
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>
Date:   Fri, 3 Jul 2020 13:59:52 +0800
In-Reply-To: <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
References: <cover.1593752220.git.kwmad.kim@samsung.com>
         <CGME20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d@epcas2p1.samsung.com>
         <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgS2l3b29uZywNCg0KT24gRnJpLCAyMDIwLTA3LTAzIGF0IDE0OjMxICswOTAwLCBLaXdvb25n
IEtpbSB3cm90ZToNCj4gU29tZSBTb0Mgc3BlY2lmaWMgbWlnaHQgbmVlZCBjb21tYW5kIGhpc3Rv
cnkgZm9yDQo+IHZhcmlvdXMgcmVhc29ucywgc3VjaCBhcyBzdGFja2luZyBjb21tYW5kIGNvbnRl
eHRzDQo+IGluIHN5c3RlbSBtZW1vcnkgdG8gY2hlY2sgZm9yIGRlYnVnZ2luZyBpbiB0aGUgZnV0
dXJlDQo+IG9yIHNjYWxpbmcgc29tZSBEVkZTIGtub2JzIHRvIGJvb3N0IElPIHRocm91Z2hwdXQu
DQo+IA0KPiBXaGF0IHlvdSB3b3VsZCBkbyB3aXRoIHRoZSBpbmZvcm1hdGlvbiBjb3VsZCBiZQ0K
PiB2YXJpYW50IHBlciBTb0MgdmVuZG9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBL
aW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4NCj4gLS0tDQoNClBsZWFzZSBoZWxwIGNvbGxlY3Qg
YWxsIHRhZ3MgcmVjZWl2ZWQgaW4gcHJldmlvdXMgdmVyc2lvbnMgYW5kIGFkZCB0aGVtDQp0byBh
bnkgZnV0dXJlIG5ldyB2ZXJzaW9ucywgZm9yIGV4YW1wbGUsIGZvciB0aGlzIHBhdGNoLA0KDQpB
Y2tlZC1CeTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQoNCg==

