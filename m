Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0603C63798
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5464324654
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ra3qQXA/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbgKRJJL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 04:09:11 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51498 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726704AbgKRJJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 04:09:10 -0500
X-UUID: a65f9d900f0b4a95a1c39a653adb6685-20201118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9qQ2MTnmFZ5gd1t1CoayM7oj5fRrO2+V03uugCH4TZQ=;
        b=ra3qQXA/tn0bzc3x6LjAHjwwR9Va4WR3HFiwsC8lSZYFdI9+I58nFTbCTJ+Jt06uhDx1JW97H3GppA868SLD8uQPTW9iiANuHYtvRb4GuTJFwSCYfLhSYCpsgNd2yj2AvgPliVfFd7nOBL52aG9fW0vnWirYlJuiwWcO+GYR7F8=;
X-UUID: a65f9d900f0b4a95a1c39a653adb6685-20201118
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1157048324; Wed, 18 Nov 2020 17:09:05 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Nov 2020 17:09:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 17:08:56 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 17:08:56 +0800
Message-ID: <1605690537.18082.2.camel@mtkswgap22>
Subject: Re: [PATCH v2 8/9] block, scsi, ide: Only process PM requests if
 rpm_status != RPM_ACTIVE
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Can Guo" <cang@codeaurora.org>, Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Date:   Wed, 18 Nov 2020 17:08:57 +0800
In-Reply-To: <20201116030459.13963-9-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
         <20201116030459.13963-9-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTE2IGF0IDExOjA0ICswODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEluc3RlYWQgb2Ygc3VibWl0dGluZyBhbGwgU0NTSSBjb21tYW5kcyBzdWJtaXR0ZWQgd2l0
aCBzY3NpX2V4ZWN1dGUoKSB0bw0KPiBhIFNDU0kgZGV2aWNlIGlmIHJwbV9zdGF0dXMgIT0gUlBN
X0FDVElWRSwgb25seSBzdWJtaXQgUlFGX1BNIChwb3dlcg0KPiBtYW5hZ2VtZW50IHJlcXVlc3Rz
KSBpZiBycG1fc3RhdHVzICE9IFJQTV9BQ1RJVkUuIFJlbW92ZSBmbGFnDQo+IFJRRl9QUkVFTVBU
IHNpbmNlIGl0IGlzIG5vIGxvbmdlciBuZWNlc3NhcnkuDQo+IA0KPiBDYzogTWFydGluIEsuIFBl
dGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQ2M6IEFsYW4gU3Rlcm4gPHN0
ZXJuQHJvd2xhbmQuaGFydmFyZC5lZHU+DQo+IENjOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEu
b3JnPg0KPiBDYzogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gQ2M6
IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPg0KPiBDYzogUmFmYWVsIEouIFd5c29ja2kg
PHJhZmFlbC5qLnd5c29ja2lAaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IE1hcnRpbiBLZXBwbGlu
Z2VyIDxtYXJ0aW4ua2VwcGxpbmdlckBwdXJpLnNtPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZh
biBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1
IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg==

