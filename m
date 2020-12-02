Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4860CC71155
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD6322206
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgLBIeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:34:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60785 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729067AbgLBIeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 03:34:50 -0500
X-UUID: 12f49e1fa9a746b29e6a90923cc49f54-20201202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qUlvQ+KjFai94KCMGfmyVlWMEPs2AsrkcVXJP+aAqZw=;
        b=n/2a+wxelOueXEPR0ivZXPXEr/67/pwEHPm2dutr03vyg283UjYoLxhs6+UAv+bTTdmapcITHUAOH9h1H6wL6rvj8Frczk2Vpm2kq8gnUhuhOgc69NV33hqkP1zrzuPgef7tB9O8fJZlBcajUgKs8/7FLrl/LFGQzSPdLzDRjnE=;
X-UUID: 12f49e1fa9a746b29e6a90923cc49f54-20201202
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2054206314; Wed, 02 Dec 2020 16:34:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Dec 2020 16:34:02 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 16:34:01 +0800
Message-ID: <1606898042.23925.34.camel@mtkswgap22>
Subject: Re: [PATCH V5 1/3] scsi: ufs: Serialize eh_work with system PM
 events and async scan
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
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 2 Dec 2020 16:34:02 +0800
In-Reply-To: <1606897475-16907-2-git-send-email-cang@codeaurora.org>
References: <1606897475-16907-1-git-send-email-cang@codeaurora.org>
         <1606897475-16907-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 736FAF53FD02A48F2F79A713A9A138580E286DE3E8982D91C6BFE8DE8F62C93D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTAyIGF0IDAwOjI0IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBTZXJp
YWxpemUgZWhfd29yayB3aXRoIHN5c3RlbSBQTSBldmVudHMgYW5kIGFzeW5jIHNjYW4gdG8gbWFr
ZSBzdXJlIGVoX3dvcmsNCj4gZG9lcyBub3QgcnVuIGluIHBhcmFsbGVsIHdpdGggdGhlbS4NCj4g
DQo+IFJldmlld2VkLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQo+
IFJldmlld2VkLWJ5OiBIb25nd3UgU3U8aG9uZ3d1c0Bjb2RlYXVyb3JhLm9yZz4NCj4gU2lnbmVk
LW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo=

