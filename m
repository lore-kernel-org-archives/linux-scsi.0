Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43236C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 13:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE5D20732
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 13:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rTojZOWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKONqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 08:46:51 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51915 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727249AbfKONqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 08:46:50 -0500
X-UUID: 1c05cd0800e04c98ad7dd221599a2afb-20191115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=IbsqhxtLdyCG5Eu6AnHMONmNOpBKJGZF2K32LR2u4vY=;
        b=rTojZOWXCfHQ2mdXVjUTfvSyMuORbgW7VMXEhXkBqcI+6vldfYepfKemCsjAPDZKHyV0ks/6aVZttdB6gqRXXDOPxs7kwq+f63p/nZD4Lrz1WG73MRUR/M7BbwWyfvfHnLDbU09zaHJ4LUx7XaN+VAzlVjTbGYC81jCtoTuwo6E=;
X-UUID: 1c05cd0800e04c98ad7dd221599a2afb-20191115
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1409881764; Fri, 15 Nov 2019 21:46:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 15 Nov
 2019 21:46:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 15 Nov 2019 21:46:40 +0800
Message-ID: <1573825602.4956.11.camel@mtkswgap22>
Subject: Re: [PATCH v5 3/7] scsi: ufs: Fix up auto hibern8 enablement
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 15 Nov 2019 21:46:42 +0800
In-Reply-To: <433afef33c8ca61aa299fa453c0d25d3@codeaurora.org>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
         <1573798172-20534-4-git-send-email-cang@codeaurora.org>
         <1573799728.4956.5.camel@mtkswgap22>
         <2a925548b8ead7c3b5ddf2d7bf3de05d@codeaurora.org>
         <1573802311.4956.8.camel@mtkswgap22>
         <433afef33c8ca61aa299fa453c0d25d3@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMTktMTEtMTUgYXQgMjA6MjcgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQoNCj4gSGkgU3RhbmxleSwNCj4gDQo+IEFjdHVhbGx5LCBJIHRob3VnaHQgYWJvdXQgdGhl
IHdheSB5b3UgcmVvbW1hbmQuDQo+IA0KPiBCdXQgSSBndWVzcyB0aGUgYXV0aG9yJ3MgaW50ZW50
aW9uIGhlcmUgaXMgdG8gdXBkYXRlIHRoZSBBSDggdGltZXINCj4gb25seSB3aGVuIGN1cnJlbnQg
cnVudGltZSBzdGF0dXMgaXMgUlBNX0FDVElWRS4gSWYgaXQgaXMgbm90IFJQTV9BQ1RJVkUsDQo+
IHdlIGp1c3QgdXBkYXRlIHRoZSBoYmEtPmFoaXQgYW5kIGJhaWwgb3V0LCBiZWNhdXNlIHRoZSBB
SDggdGltZXIgd2lsbCBiZQ0KPiB1cGRhdGVkIGluIHVmc2hjZF9yZXVzbWUoKSBldmVudHVhbGx5
IHdoZW4gaGJhIGlzIHJlc3VtZWQuIFRoaXMgY2FuIA0KPiBhdm9pZA0KPiBmcmVxdWVudGx5IHdh
a2luZyB1cCBoYmEganVzdCBmb3IgYWNjZXNzaW5nIGEgc2luZ2xlIHJlZ2lzdGVyLg0KPiBIb3cg
ZG8geW91IHRoaW5rPw0KPiANCj4gVGhhbmtzLA0KPiBDYW4gR3VvLg0KPiANCj4gDQoNCkFncmVl
IHdpdGggeW91Lg0KDQpUaGFua3MgOikNCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFu
bGV5LmNodUBtZWRpYXRlay5jb20+DQo=

