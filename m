Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB062C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 09:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78C952072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 09:57:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ed74/e7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgASJ5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 04:57:37 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37855 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726452AbgASJ5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 04:57:36 -0500
X-UUID: 036c361512aa4cc2b4c871464dd875d9-20200119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rnEBj3BQzpj3GkA9td8jqKVk5Gih5svqD1LAcmoYrR8=;
        b=Ed74/e7aOA2BPKTAU5WJPUfqBbhb0YGKWrznsIfVQ64FS4ZlcC/+qXK6plkixrsvRCEU4nPNBuF3CkqwTREd4r7HffkWsDZuArHyNpF1crcijPUsmaASygR95cvisKVKuei0uccWrav8LJOdvso6pI22KgznIkUZP4nlIzojZz4=;
X-UUID: 036c361512aa4cc2b4c871464dd875d9-20200119
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1171699701; Sun, 19 Jan 2020 17:57:30 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 19 Jan 2020 17:57:28 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Sun, 19 Jan
 2020 17:56:23 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 19 Jan 2020 17:56:23 +0800
Message-ID: <1579427847.19362.13.camel@mtksdccf07>
Subject: Re: [PATCH v3 4/8] scsi: ufs: move ufshcd_get_max_pwr_mode() to
 ufs_init_params()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Sun, 19 Jan 2020 17:57:27 +0800
In-Reply-To: <20200119001327.29155-5-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
         <20200119001327.29155-5-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
X-TM-SNTS-SMTP: 368B8B34E628F16213ADBAA06BCFC3B33339665010CF92A04D9C6ADC140BAB812000:8
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTAxLTE5IGF0IDAxOjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IHVmc2hjZF9nZXRfbWF4X3B3
cl9tb2RlKCkgb25seSBuZWVkIHRvIGJlIGNhbGxlZCBvbmNlIHdoaWxlIGJvb3RpbmcsDQo+IHRh
a2UgaXQgb3V0IGZyb20gdWZzaGNkX3Byb2JlX2hiYSgpIGFuZCBpbmxpbmUgaW50byB1ZnNoY2Rf
aW5pdF9wYXJhbXMoKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1p
Y3Jvbi5jb20+DQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KDQo=

