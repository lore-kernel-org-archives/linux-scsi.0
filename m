Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36C8C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 13:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB85F20663
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 13:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="n7up+uKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgCPNrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:47:42 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:46387 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731128AbgCPNrm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 09:47:42 -0400
X-UUID: 10a504a8f5d14e4fae581bb818e7ad34-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=4JA6NZX9xYGKptnv1DMIdtY2XSn1zUtwqcPfjmJwyTg=;
        b=n7up+uKagsveG+5NfZjhth4tRoOXTNB+oTxgQ7UVoZRnTLAkyIGeU0UHsEj7lJVZgNNThLemjI0rrkL19fmOBa/ssZeA2e1Buq4dzgizm7dnZUBSsqNCJ11D1HtaSKbAFKb8UFBYRR3IiyG6PeLaswb+ML9e+cWkhcDcZ4s3t9I=;
X-UUID: 10a504a8f5d14e4fae581bb818e7ad34-20200316
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1831999363; Mon, 16 Mar 2020 21:47:35 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 21:45:18 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 21:44:36 +0800
Message-ID: <1584366454.14250.12.camel@mtksdccf07>
Subject: Re: [PATCH 2/2] scsi: ufs: Do not rely on prefetched data
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
        "Bjorn Andersson" <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 16 Mar 2020 21:47:34 +0800
In-Reply-To: <1584342373-10282-3-git-send-email-cang@codeaurora.org>
References: <1584342373-10282-1-git-send-email-cang@codeaurora.org>
         <1584342373-10282-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMDMtMTYgYXQgMDA6MDYgLTA3MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IFdlIHdlcmUgc2V0dGluZyBiQWN0aXZlSUNDTGV2ZWwgYXR0cmlidXRlIGZvciBVRlMg
ZGV2aWNlIG9ubHkgb25jZSBidXQNCj4gdHlwZSBvZiB0aGlzIGF0dHJpYnV0ZSBoYXMgY2hhbmdl
ZCBmcm9tIHBlcnNpc3RlbnQgdG8gdm9sYXRpbGUgc2luY2UgVUZTDQo+IGRldmljZSBzcGVjaWZp
Y2F0aW9uIHYyLjEuIFRoaXMgYXR0cmlidXRlIGlzIHNldCB0byB0aGUgZGVmYXVsdCB2YWx1ZSBh
ZnRlcg0KPiBwb3dlciBjeWNsZSBvciBoYXJkd2FyZSByZXNldCBldmVudC4gSXQgaXNuJ3Qgc2Fm
ZSB0byByZWx5IG9uIHByZWZldGNoZWQNCj4gZGF0YSAob25seSB1c2VkIGZvciBiQWN0aXZlSUND
TGV2ZWwgYXR0cmlidXRlIG5vdykuIEhlbmNlIHRoaXMgY2hhbmdlDQo+IHJlbW92ZXMgdGhlIGNv
ZGUgcmVsYXRlZCB0byBkYXRhIHByZWZldGNoaW5nIGFuZCBzZXQgdGhpcyBwYXJhbWV0ZXIgb24N
Cj4gZXZlcnkgYXR0ZW1wdCB0byBwcm9iZSB0aGUgVUZTIGRldmljZS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNClJldmlld2VkIGFuZCBUZXN0
ZWQgYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0K

