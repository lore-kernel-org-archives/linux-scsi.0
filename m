Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8950DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 06:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63DE5207E8
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 06:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f5aQgYOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE1Gcb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 02:32:31 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:12530 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725308AbgE1Gcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 02:32:31 -0400
X-UUID: fdc33ac2baf7469cbd786d81f5623493-20200528
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=X5yIYJsx3HE5VilfUgdZ3rZhUrrpxFF0glSlGP64Xxw=;
        b=f5aQgYOOaRvemxhGQK9nd3qsWQRbZsKUHsRC1cApktA7NMY0WMUo9s4AUnwC8HvE/pfpddsXWXhz+p89Luohacgx3xmwgxRLjzywFqWcvkthib8uEtlUavFENnqilmVojxSrtcf36CrXdt7SPBaDRyYIixMLhgTFd1cod21uy/g=;
X-UUID: fdc33ac2baf7469cbd786d81f5623493-20200528
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1923720607; Thu, 28 May 2020 14:32:27 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 28 May 2020 14:32:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 May 2020 14:32:25 +0800
Message-ID: <1590647545.25636.0.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/1] scsi: ufs: Don't update urgent bkops level when
 toggle auto bkops
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <stanley.chu@mediatek.com>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 28 May 2020 14:32:25 +0800
In-Reply-To: <1590632686-17866-1-git-send-email-cang@codeaurora.org>
References: <1590632686-17866-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDE5OjI0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBVcmdl
bnQgYmtvcHMgbGV2ZWwgaXMgdXNlZCB0byBjb21wYXJlIGFnYWluc3QgYWN0dWFsIGJrb3BzIHN0
YXR1cyByZWFkDQo+IGZyb20gVUZTIGRldmljZS4gVXJnZW50IGJrb3BzIGxldmVsIGlzIHNldCBk
dXJpbmcgaW5pdGlhbGl6YXRpb24gYW5kIG1pZ2h0DQo+IGJlIHVwZGF0ZWQgaW4gZXhjZXB0aW9u
IGV2ZW50IGhhbmRsZXIgZHVyaW5nIHJ1bnRpbWUsIGJ1dCBpdCBzaG91bGQgbm90IGJlDQo+IHVw
ZGF0ZWQgdG8gdGhlIGFjdHVhbCBia29wcyBzdGF0dXMgZXZlcnkgdGltZSB3aGVuIGF1dG8gYmtv
cHMgaXMgdG9nZ2xlZC4NCj4gT3RoZXJ3aXNlLCBpZiB1cmdlbnQgYmtvcHMgbGV2ZWwgaXMgdXBk
YXRlZCB0byAwLCBhdXRvIGJrb3BzIHNoYWxsIGFsd2F5cw0KPiBiZSBrZXB0IGVuYWJsZWQuDQo+
IA0KPiBGaXhlczogMjQzNjZjMmFmYmIwICgic2NzaTogdWZzOiBSZWNoZWNrIGJrb3BzIGxldmVs
IGlmIGJrb3BzIGlzIGRpc2FibGVkIikNCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bj
b2RlYXVyb3JhLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMSAt
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGlu
ZGV4IDE4MjdiNTcuLjE3ODMyMmUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBAQCAtNTEzMyw3ICs1
MTMzLDYgQEAgc3RhdGljIGludCB1ZnNoY2RfYmtvcHNfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LA0KPiAgCQllcnIgPSB1ZnNoY2RfZW5hYmxlX2F1dG9fYmtvcHMoaGJhKTsNCj4gIAllbHNlDQo+
ICAJCWVyciA9IHVmc2hjZF9kaXNhYmxlX2F1dG9fYmtvcHMoaGJhKTsNCj4gLQloYmEtPnVyZ2Vu
dF9ia29wc19sdmwgPSBjdXJyX3N0YXR1czsNCj4gIG91dDoNCj4gIAlyZXR1cm4gZXJyOw0KPiAg
fQ0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4N
Cg0K

