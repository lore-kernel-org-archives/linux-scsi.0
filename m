Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F276CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 08:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2E621BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 08:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL3Iei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 03:34:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55194 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725853AbgL3Iei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 03:34:38 -0500
X-UUID: 6d5be9ddf8904ca4ab1481f38afc1884-20201230
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=EzXwqs+poHgsVaqz/QjcZDwPofwlI/DBkbg5hyAshKg=;
        b=lBxI7fhzuuMySPmVTkBhA/jly4/XixT4ZiMu/FSjU0+PC0xZOVOXOrxlA53vcw4XfT2vQJnecs7fMhbHrGET/5gxOZRQ5bHkIgPc65gZUn26ZZoa49Oc0pwY8ajTwZ7Efent4wKmY7kbPUGezHjHRH5lhMwvBeqRCP2nzYxEhPU=;
X-UUID: 6d5be9ddf8904ca4ab1481f38afc1884-20201230
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1642656073; Wed, 30 Dec 2020 16:33:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 30 Dec 2020 16:33:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Dec 2020 16:33:54 +0800
Message-ID: <1609317234.9795.11.camel@mtkswgap22>
Subject: Re: [PATCH] scsi: ufs: Correct the lun used in
 eh_device_reset_handler() callback
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <ziqichen@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 30 Dec 2020 16:33:54 +0800
In-Reply-To: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
References: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 7ADB87078B6301CF35771595272FACC3A25FDDDD69E9931D11B4E1857AA114D52000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTI4IGF0IDA0OjA0IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBVc2Vy
cyBjYW4gaW5pdGlhdGUgcmVzZXRzIHRvIHNwZWNpZmljIFNDU0kgZGV2aWNlL3RhcmdldC9ob3N0
IHRocm91Z2gNCj4gSU9DVEwuIFdoZW4gdGhpcyBoYXBwZW5zLCB0aGUgU0NTSSBjbWQgcGFzc2Vk
IHRvIGVoX2RldmljZS90YXJnZXQvaG9zdA0KPiBfcmVzZXRfaGFuZGxlcigpIGNhbGxiYWNrcyBp
cyBpbml0aWFsaXplZCB3aXRoIGEgcmVxdWVzdCB3aG9zZSB0YWcgaXMgLTEuDQo+IFNvLCBpbiB0
aGlzIGNhc2UsIGl0IGlzIG5vdCByaWdodCBmb3IgZWhfZGV2aWNlX3Jlc2V0X2hhbmRsZXIoKSBj
YWxsYmFjaw0KPiB0byBjb3VudCBvbiB0aGUgbHVuIGdldCBmcm9tIGhiYS0+bHJiWy0xXS4gRml4
IGl0IGJ5IGdldHRpbmcgbHVuIGZyb20gdGhlDQo+IFNDU0kgZGV2aWNlIGFzc29jaWF0ZWQgd2l0
aCB0aGUgU0NTSSBjbWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVh
dXJvcmEub3JnPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlh
dGVrLmNvbT4NCg==

