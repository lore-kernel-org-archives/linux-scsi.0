Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96F6C2D0E9
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 00:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE26206DB
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 00:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XbkfjqRw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgC3AfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:35:17 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57879 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727720AbgC3AfR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2020 20:35:17 -0400
X-UUID: a7b933f471464cc49eb9130694ce64ad-20200330
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ARyi+D7+aAbNt7/fY8aaKOulBqVbiCAEf60r2lM1CdQ=;
        b=XbkfjqRwE6PnLr0qgGnvYKVP3NaLc6A5F8VfSyZFoBst0gBu2SPr8ImlIlPZizR51zAPnrVayBYwz880H5iBPgu5EryzJL9VlUoyooInb5aXlwQ8A833t5YseBBGaIn75AsuYawUgC+z8TVK3MIxUygUK0IFQroZ5IYVWnIBV0w=;
X-UUID: a7b933f471464cc49eb9130694ce64ad-20200330
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2020272089; Mon, 30 Mar 2020 08:35:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 30 Mar 2020 08:35:04 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 30 Mar 2020 08:35:06 +0800
Message-ID: <1585528506.4609.13.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was
 off
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
Date:   Mon, 30 Mar 2020 08:35:06 +0800
In-Reply-To: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
References: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBGcmksIDIwMjAtMDMtMjcgYXQgMTk6MjcgLTA3MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEZyb206IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCj4gDQo+
IER1cmluZyBzdXNwZW5kLCBpZiB0aGUgbGluayBpcyBwdXQgdG8gb2ZmLCBpdCB3b3VsZCByZXF1
aXJlDQo+IGEgZnVsbCBpbml0aWFsaXphdGlvbiBkdXJpbmcgcmVzdW1lLiBUaGlzIHBhdGNoIHJl
c2V0cyBhbmQNCj4gcmVzdG9yZXMgYm90aCB0aGUgaGJhIGFuZCB0aGUgY2FyZCBkdXJpbmcgaW5p
dGlhbGl6YXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRA
Y29kZWF1cm9yYS5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9y
YS5vcmc+DQoNClBlcnNvbmFsbHkgSSBsaWtlIHRoaXMgcGF0Y2ggYmVjYXVzZSB0aGUgcmUtaW5p
dGlhbGl6YXRpb24gcGVyZm9ybWFuY2UNCmlzIGltcHJvdmVkIGluIG15IHRlc3QgcGxhdGZvcm0g
d2l0aCBteSBwYXRjaCAic2NzaTogdWZzOiBzZXQgZGV2aWNlIGFzDQphY3RpdmUgcG93ZXIgbW9k
ZSBhZnRlciByZXNldHRpbmcgZGV2aWNlIiB3b3JraW5nIHRvZ2V0aGVyLiBCdXQgSSBhbSBub3QN
CnN1cmUgaWYgZXZlcnkgdmVuZG9yIGlzIGhhcHB5IGFib3V0IHRoaXMuDQoNCkFueXdheSwNCkFj
a2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K

