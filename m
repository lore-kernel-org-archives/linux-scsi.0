Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F48C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D382072A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="E1qqmDCj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfLYHRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 02:17:21 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:31694 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbfLYHRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Dec 2019 02:17:21 -0500
X-UUID: 614f148b3eaa43339322e18207959b07-20191225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=y36LCJBS+Xi4nXpwZhIxIiWdbjmo0pk30cC1qR1RCfc=;
        b=E1qqmDCjx/pcqzJ+X6NCRiEV6Jjm/ComVoCp6bAJ+8TfhZ6ywQlNUVPYfbnlw0okwRCAhn4UyLMMFChlZCV3tEJJHegMi9TCSIIYh4E4SB3+ys4PeCB7ZDQ3e/Ic9aRfaWUYAXcPs7Vc/pW2pSz5/NGs5aRkziE8+lnyT3dKoSU=;
X-UUID: 614f148b3eaa43339322e18207959b07-20191225
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1538162152; Wed, 25 Dec 2019 15:17:16 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 25 Dec 2019 15:16:36 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 25 Dec 2019 15:16:10 +0800
Message-ID: <1577258234.13056.51.camel@mtkswgap22>
Subject: Re: [PATCH 3/6] ufs: Make ufshcd_prepare_utp_scsi_cmd_upiu() easier
 to read
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Date:   Wed, 25 Dec 2019 15:17:14 +0800
In-Reply-To: <20191224220248.30138-4-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
         <20191224220248.30138-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 8AE3B00C739A7D646048B38F826B8014024CEC82F9C7768BFD8634DA4A56CC492000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gVHVlLCAyMDE5LTEyLTI0IGF0IDE0OjAyIC0wODAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IFNpbmNlIHRoZSBscmJwLT5jbWQgZXhwcmVzc2lvbiBvY2N1cnMgbXVs
dGlwbGUgdGltZXMsIGludHJvZHVjZSBhIG5ldw0KPiBsb2NhbCB2YXJpYWJsZSB0byBob2xkIHRo
YXQgcG9pbnRlci4gVGhpcyBwYXRjaCBkb2VzIG5vdCBjaGFuZ2UgYW55DQo+IGZ1bmN0aW9uYWxp
dHkuDQo+IA0KPiBDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gQ2M6IENhbiBH
dW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+IENjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5A
d2RjLmNvbT4NCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+
IENjOiBUb21hcyBXaW5rbGVyIDx0b21hcy53aW5rbGVyQGludGVsLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNClJldmlld2VkLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg==

