Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AFBC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B7B420707
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 08:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fWM9e5bR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgH0Ihb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:37:31 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:52252 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726826AbgH0Iha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 04:37:30 -0400
X-UUID: f7e0a3056edc492798a48a80e713f95b-20200827
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=dwCbybGoQ+wOCZtMMJHOlOJ0VrEP7cWnHHh7pZK3b74=;
        b=fWM9e5bRGuDYFk+PBKHes5OorguScclILKXa68lISKzt2+ESVBy9nxp1Ppxy4yoF7Iub4+fDf7luglA1M5vcO8155+ANLlqnpyYBv2uNC9yligwLO014H50kBk9w6XqDP0+f2uTUGj8CNgMYNDLGVznQEZV5k/ZfhMcnX7/8D8U=;
X-UUID: f7e0a3056edc492798a48a80e713f95b-20200827
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 705747239; Thu, 27 Aug 2020 16:37:26 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 Aug 2020 16:37:24 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Aug 2020 16:37:25 +0800
Message-ID: <1598517445.10649.20.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
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
Date:   Thu, 27 Aug 2020 16:37:25 +0800
In-Reply-To: <1598321228-21093-2-git-send-email-cang@codeaurora.org>
References: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
         <1598321228-21093-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTA4LTI0IGF0IDE5OjA3IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBUbyBy
ZWNvdmVyeSBub24tZmF0YWwgZXJyb3JzLCBubyBmdWxsIHJlc2V0IGlzIHJlcXVpcmVkLCBlcnJf
aGFuZGxlciBvbmx5DQo+IGNsZWFycyB0aG9zZSBwZW5kaW5nIFRScy9UTVJzIHNvIHRoYXQgc2Nz
aSBsYXllciBjYW4gcmUtaXNzdWUgdGhlbS4gSW4NCj4gY3VycmVudCBlcnJfaGFuZGxlciwgVFJz
IGFyZSBkaXJlY3RseSBjbGVhcmVkIGZyb20gVUZTIGhvc3QncyBkb29yYmVsbCBidXQNCj4gbm90
IGFib3J0ZWQgZnJvbSBkZXZpY2Ugc2lkZS4gSG93ZXZlciwgYWNjb3JkaW5nIHRvIHRoZSBVRlNI
Q0kgSkVERUMgc3BlYywNCj4gdGhlIGhvc3Qgc29mdHdhcmUgc2hhbGwgdXNlIFVUUCBUcmFuc2Zl
ciBSZXF1ZXN0IExpc3QgQ0xlYXIgUmVnaXN0ZXIgdG8NCj4gY2xlYXIgYSB0YXNrIGZyb20gVUZT
IGhvc3QncyBkb29yYmVsbCBvbmx5IHdoZW4gYSBVVFAgVHJhbnNmZXIgUmVxdWVzdCBpcw0KPiBl
eHBlY3RlZCB0byBub3QgYmUgY29tcGxldGVkLCBlLmcuIHdoZW4gdGhlIGhvc3Qgc29mdHdhcmUg
cmVjZWl2ZXMgYQ0KPiDigJxGVU5DVElPTiBDT01QTEVUReKAnSBUYXNrIE1hbmFnZW1lbnQgcmVz
cG9uc2Ugd2hpY2ggbWVhbnMgYSBUcmFuc2ZlciBSZXF1ZXN0DQo+IHdhcyBhYm9ydGVkLiBUbyBm
b2xsb3cgdGhlIFVGU0hDSSBKRURFQyBzcGVjLCBpbiBlcnJfaGFuZGxlciwgYWJvcnRzIG9uZSBU
Ug0KPiBiZWZvcmUgY2xlYXJpbmcgaXQgZnJvbSBkb29yYmVsbC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNCkFja2VkLWJ5OiBTdGFubGV5IENo
dSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg0K

