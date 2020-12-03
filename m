Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEB6C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 06:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBC620643
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 06:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgLCGEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:04:12 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54146 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729458AbgLCGEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 01:04:11 -0500
X-UUID: 09e45c68bb16487a96c96b2518a8a4dd-20201203
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=XrMDBOPH0/Kj16iXJYkaW28uKCRVbAh84nWO9OHLR6c=;
        b=ffh5qK8eVJqn1bCEO8feiAOa9Xll821xKyXNNp/divVRguFjL6PAK9fAj4um6YNbwuRMFSnw0S2eTtzC/yp4xlj5CUgkSoJb4jmAGXPyYWax84amJ9nYlyU5E89x11uXBeBEHKmVYQu5Uy5o4hQLBOZogjQCp3k/Lm4ikAS7bTs=;
X-UUID: 09e45c68bb16487a96c96b2518a8a4dd-20201203
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 813641303; Thu, 03 Dec 2020 14:03:29 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 3 Dec 2020 14:03:26 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Dec 2020 14:03:26 +0800
Message-ID: <1606975407.23925.61.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Adjust ufshcd_hold() during sending
 attribute requests
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Jintae Jang <jt77.jang@samsung>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jt77.jang@samsung.com>
Date:   Thu, 3 Dec 2020 14:03:27 +0800
In-Reply-To: <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
References: <CGME20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d@epcas1p2.samsung.com>
         <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTAzIGF0IDE0OjI1ICswOTAwLCBKaW50YWUgSmFuZyB3cm90ZToNCj4g
RnJvbTogamludGFlIGphbmcgPGp0NzcuamFuZ0BzYW1zdW5nLmNvbT4NCj4gDQo+IEludmFsaWRh
dGlvbiBjaGVjayBvZiBhcmd1bWVudHMgc2hvdWxkIGhhdmUgYmVlbiBjaGVja2VkIGJlZm9yZQ0K
PiB1ZnNoY2RfaG9sZCgpLiBJdCBjYW4gaGVscCB0byBwcmV2ZW50IHVmc2hjZF9ob2xkKCkvDQo+
IHVmc2hjZF9yZWxlYXNlKCkgZnJvbSBiZWluZyBpbnZva2VkIHVubmVjZXNzYXJpbHkuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBqaW50YWUgamFuZyA8anQ3Ny5qYW5nQHNhbXN1bmcuY29tPg0KDQpS
ZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg==

