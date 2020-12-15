Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3610C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 06:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A98420798
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 06:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgLOGQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 01:16:26 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53242 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726177AbgLOGQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 01:16:21 -0500
X-UUID: 39aef113e706494b88c7f61998e9288c-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=VY4bXUPBFQUBKaKb6BMuLM5IaflmpZ4yvdcnHQPYq08=;
        b=pfcpNQcHguo9fOoYoXW7oohlG55EBloTXpzm2FZ8wubkW8Sbt44a5oVHD71kFSQ2auL9yc8f3j9FWLegknlPj0FV+Imf5Mc7PeHzMrhZ9WDhvKmfE/YxUVDo95CRJ9+Uw21AksF25ndoW8Lwt7IrsIonw75i7vwOWv0Qjgagizw=;
X-UUID: 39aef113e706494b88c7f61998e9288c-20201215
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1786950825; Tue, 15 Dec 2020 14:15:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 14:15:30 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 14:15:29 +0800
Message-ID: <1608012929.10163.11.camel@mtkswgap22>
Subject: Re: [PATCH v4 3/3] scsi: ufs: Revert "Make sure clk scaling happens
 only when HBA is runtime ACTIVE"
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
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 14:15:29 +0800
In-Reply-To: <1607877104-8916-4-git-send-email-cang@codeaurora.org>
References: <1607877104-8916-1-git-send-email-cang@codeaurora.org>
         <1607877104-8916-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 5DE2468B82C95C3F4ABD3EC0CE1DF56FB482EE2A25E659867F53F62AF44FD01D2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTEyLTEzIGF0IDA4OjMxIC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBDb21t
aXQgNzNjYzI5MWMyNzAyNCAoIk1ha2Ugc3VyZSBjbGsgc2NhbGluZyBoYXBwZW5zIG9ubHkgd2hl
biBIQkEgaXMNCj4gcnVudGltZSBBQ1RJVkUiKSBpcyBubyBsb25nZXIgbmVlZGVkIHNpbmNlIGNv
bW1pdCBmN2E0MjU0MDkyOGE4ICgic2NzaToNCj4gdWZzOiBQcm90ZWN0IHNvbWUgY29udGV4dHMg
ZnJvbSB1bmV4cGVjdGVkIGNsb2NrIHNjYWxpbmciKSBpcyBhIG1vcmUNCj4gbWF0dXJlIGZpeCB0
byBwcm90ZWN0IFVGUyBMTEQgc3RhYmlsaXR5IGZyb20gY2xvY2sgc2NhbGluZyBpbnZva2VkIHRo
cm91Z2gNCj4gc3lzZnMgbm9kZXMgYnkgdXNlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4g
R3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0
YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

