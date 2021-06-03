Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7743CC47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A51613EE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 02:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFCC4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 22:56:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54171 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229541AbhFCC4N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 22:56:13 -0400
X-UUID: 05c7891aec4c4d7c963a539b75deee66-20210603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=T1f3ciz9FJ4+c/XRklk7ljIC8zMrcEktrNSPUm0vuD8=;
        b=PIDq4YzCmHMgZC8LQ2xeznDU81jF9iTSuYwjaUGtzWj3LKC+sEq717XiH92YKAcI5IxcRBiKAdEDMvya3DqmMeFC8IpEm1kV5dDGy5olQPGaYg3LDPt/xZacc23A5e/ZLSBER6+rwg6ACd6vVY1bblILovg7yOE5n9ZHp0dGyN8=;
X-UUID: 05c7891aec4c4d7c963a539b75deee66-20210603
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 869516845; Thu, 03 Jun 2021 10:54:26 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 3 Jun 2021 10:54:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 10:54:25 +0800
Message-ID: <1622688865.7096.6.camel@mtkswgap22>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer
 requests send/compl paths
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 3 Jun 2021 10:54:25 +0800
In-Reply-To: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjEtMDUtMjQgYXQgMDE6MzYgLTA3MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEN1cnJlbnQgVUZTIElSUSBoYW5kbGVyIGlzIGNvbXBsZXRlbHkgd3JhcHBlZCBieSBo
b3N0IGxvY2ssIGFuZCBiZWNhdXNlDQo+IHVmc2hjZF9zZW5kX2NvbW1hbmQoKSBpcyBhbHNvIHBy
b3RlY3RlZCBieSBob3N0IGxvY2ssIHdoZW4gSVJRIGhhbmRsZXINCj4gZmlyZXMsIG5vdCBvbmx5
IHRoZSBDUFUgcnVubmluZyB0aGUgSVJRIGhhbmRsZXIgY2Fubm90IHNlbmQgbmV3IHJlcXVlc3Rz
LA0KPiB0aGUgcmVzdCBDUFVzIGNhbiBuZWl0aGVyLiBNb3ZlIHRoZSBob3N0IGxvY2sgd3JhcHBp
bmcgdGhlIElSUSBoYW5kbGVyIGludG8NCj4gc3BlY2lmaWMgYnJhbmNoZXMsIGkuZS4sIHVmc2hj
ZF91aWNfY21kX2NvbXBsKCksIHVmc2hjZF9jaGVja19lcnJvcnMoKSwNCj4gdWZzaGNkX3RtY19o
YW5kbGVyKCkgYW5kIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKS4gTWVhbndoaWxlLCB0byBm
dXJ0aGVyDQo+IHJlZHVjZSBvY2NwdWF0aW9uIG9mIGhvc3QgbG9jayBpbiB1ZnNoY2RfdHJhbnNm
ZXJfcmVxX2NvbXBsKCksIGhvc3QgbG9jayBpcw0KPiBubyBsb25nZXIgcmVxdWlyZWQgdG8gY2Fs
bCBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKS4gQXMgcGVyIHRlc3QsIHRoZQ0KPiBvcHRp
bWl6YXRpb24gY2FuIGJyaW5nIGNvbnNpZGVyYWJsZSBnYWluIHRvIHJhbmRvbSByZWFkL3dyaXRl
IHBlcmZvcm1hbmNlLg0KPiANCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRl
ay5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJv
cmEub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9y
YS5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoN
CkFjY29yZGluZyB0byBteSB0ZXN0LCB0aGUgcGVyZm9ybWFuY2UgaW5kZWVkIGhhcyBpbXByZXNz
aXZlIGltcHJvdmVtZW50DQp3aXRoIHRoaXMgc2VyaWVzIQ0KDQpSZXZpZXdlZC1ieTogU3Rhbmxl
eSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQoNCg0KPiAgI2VuZGlmDQo+ICAN
Cj4gIAlib29sIHJlcV9hYm9ydF9za2lwOw0KPiAtCWJvb2wgaW5fdXNlOw0KPiAgfTsNCj4gIA0K
PiAgLyoqDQoNCg==

