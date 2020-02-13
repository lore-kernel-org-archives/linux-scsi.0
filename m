Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4DFC3B188
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0553A2168B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CbVIPMcK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgBMHya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 02:54:30 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:39195 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729692AbgBMHya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 02:54:30 -0500
X-UUID: a4058ff8d86e415c90f415b400246ada-20200213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=kFZ9stVCf4xYFUM4gEXfNMx0Efg/ykPeH4ni0lUHOaY=;
        b=CbVIPMcKMWOb0C8NdhQ6gFr1fv6jneaLxKNA0TvIPEJHrQkjVhWrH5KW98Qm2SypsBAJXcgDz31SKkmxtxa33/f3LhgUlY5NI0mhjiWE3V0yvi45WebZpLXL8U3D4JUSnOsdWlVrEIteJYEyRAnlccZF6pBSrQXYTWPbkWwdSV8=;
X-UUID: a4058ff8d86e415c90f415b400246ada-20200213
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1318913454; Thu, 13 Feb 2020 15:54:24 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 13 Feb 2020 15:52:59 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 13 Feb 2020 15:54:26 +0800
Message-ID: <1581580462.27391.15.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Use ufshcd_config_pwr_mode() when
 scale gear
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
Date:   Thu, 13 Feb 2020 15:54:22 +0800
In-Reply-To: <1581485910-8307-2-git-send-email-cang@codeaurora.org>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
         <1581485910-8307-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 576BC9EC9E1086F31A3A4E077161C05584B7AF05BDA6493477755F6A0AC46C8F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTExIGF0IDIxOjM4IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBXaGVu
IHNjYWxlIGdlYXIsIHVzZSB1ZnNoY2RfY29uZmlnX3B3cl9tb2RlKCkgaW5zdGVhZCBvZg0KPiB1
ZnNoY2RfY2hhbmdlX3Bvd2VyX21vZGUoKSBzbyB0aGF0IHZvcHNfcHdyX2NoYW5nZV9ub3RpZnko
UFJFX0NIQU5HRSkNCj4gY2FuIGJlIHV0aWxpemVkIHRvIGFsbG93IHZlbmRvcnMgdXNlIGN1c3Rv
bWl6ZWQgc2V0dGluZ3MgYmVmb3JlIGNoYW5nZQ0KPiB0aGUgcG93ZXIgbW9kZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNClJldmlld2VkLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

