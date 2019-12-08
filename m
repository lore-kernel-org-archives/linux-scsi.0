Return-Path: <SRS0=ZYS2=Z6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5F0C2BBE2
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 12:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E9620706
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 12:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S+oiPd63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfLHMk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 07:40:58 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:9531 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726163AbfLHMk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 07:40:58 -0500
X-UUID: 10fe5277c2ca45248ef3fb16e4980491-20191208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=2WSGfiTkWDpT/mYBDWoIjtdi+bzFTArXnMsQV1RVFoI=;
        b=S+oiPd63IANu67fS3XpDkKJSDxINQKHAYRoQEe6u0D5+4YVz10yFhKIjsYPT6wlBhChCSIhxxbkhBgdOqGnieZNheIhY4UtVVHcID3PGMEQ4wcEdpllSqoFtHBJDS7Fn0nswIXFzd/Ewu1zAZSzTFqOV88HvikxrnQW4m0LBLso=;
X-UUID: 10fe5277c2ca45248ef3fb16e4980491-20191208
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 841033995; Sun, 08 Dec 2019 20:40:52 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 8 Dec 2019 20:39:59 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 8 Dec 2019 20:40:21 +0800
Message-ID: <1575808849.12066.3.camel@mtkswgap22>
Subject: Re: [PATCH v6 5/5] scsi: ufs: Do not free irq in suspend
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Sun, 8 Dec 2019 20:40:49 +0800
In-Reply-To: <0101016ed3d69793-22918f99-23bf-495d-8a36-a9c108d1cbce-000000@us-west-2.amazonses.com>
References: <1575512052-15999-1-git-send-email-cang@codeaurora.org>
         <0101016ed3d69793-22918f99-23bf-495d-8a36-a9c108d1cbce-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: E6395AF04C83190C41F2F37EC7EB2F06A7D53DB6B5AA8BFFBFBB2EEAD866D8202000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUaHUsIDIwMTktMTItMDUgYXQgMDI6MTQgKzAwMDAsIENhbiBHdW8gd3Jv
dGU6DQo+IFNpbmNlIHVmc2hjZCBpcnEgcmVzb3VyY2UgaXMgYWxsb2NhdGVkIHdpdGggdGhlIGRl
dmljZSByZXNvdXJjZSBtYW5hZ2VtZW50DQo+IGF3YXJlIElSUSByZXF1ZXN0IGltcGxlbWVudGF0
aW9uLCB3ZSBkb24ndCByZWFsbHkgbmVlZCB0byBmcmVlIHVwIGlycQ0KPiBkdXJpbmcgc3VzcGVu
ZCwgZGlzYWJsaW5nIGl0IGR1cmluZyBzdXNwZW5kIGFuZCByZWVuYWJsaW5nIGl0IGR1cmluZyBy
ZXN1bWUNCj4gc2hvdWxkIGJlIGdvb2QgZW5vdWdoLg0KDQpUaGlzIGlzIGdvb2QgaW4gY29uc2lk
ZXJhdGlvbiBvZiBwZXJmb3JtYW5jZTogZW5hYmxlX2lycS9kaXNhYmxlX2lycQ0KcGVyZm9ybWFu
Y2UgaXMgbXVjaCBiZXR0ZXIgdGhhbiByZXF1ZXN0X2lycS9mcmVlX2lycS4NCg0KUmV2aWV3ZWQt
Ynk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0KDQo=

